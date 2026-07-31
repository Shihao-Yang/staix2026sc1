#!/usr/bin/env bash
# Start the LoopPlane dashboard and print a URL you can actually click.
#
#     scripts/open-dashboard.sh
#     scripts/open-dashboard.sh --project ~/my-study --port 8765 --public
#
# Inside a Codespace, http://localhost:PORT is not reachable from your browser.
# This resolves the forwarded https://<codespace>-<port>.<domain> address instead,
# opens it, and prints it so you can paste it to somebody else. On a laptop it
# just uses localhost. Companion to 03_loopplane_research_loop.md.
#
# Flags:
#   --project DIR   folder LoopPlane is managing        (default: current folder)
#   --port N|auto   dashboard port                      (default: 8765)
#   --public        make the forwarded port public       (Codespaces only)
#   --no-clone      fail instead of cloning LoopPlane
#   --no-open       print the URL, do not launch a browser
#   --strict-origin keep LoopPlane's same-origin check on
#
# By default this sets same_origin_required false in the workflow's
# config/security.json, because with it on, every action button clicked through a
# forwarded URL returns 403 "same-origin check failed". That check is CSRF
# protection, not authentication: the dashboard token is still required, and an
# off-origin POST without one is still refused. Pass --strict-origin to keep it.

set -uo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT="${LOOPPLANE_PROJECT:-$PWD}"
PORT="${LOOPPLANE_PORT:-8765}"
PUBLIC=0
CLONE=1
OPEN=1
ALLOW_ORIGIN=1

while [ $# -gt 0 ]; do
  case "$1" in
    --project) PROJECT="$2"; shift 2 ;;
    --port)    PORT="$2"; shift 2 ;;
    --public)  PUBLIC=1; shift ;;
    --no-clone) CLONE=0; shift ;;
    --no-open) OPEN=0; shift ;;
    --strict-origin) ALLOW_ORIGIN=0; shift ;;
    --allow-forwarded-origin) shift ;;  # now the default; accepted so old copies of the command still run
    -h|--help) sed -n '2,26p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown flag: $1 (try --help)" >&2; exit 2 ;;
  esac
done

PROJECT="$(cd "$PROJECT" 2>/dev/null && pwd)" || { echo "no such project folder" >&2; exit 1; }

# --- locate LoopPlane -------------------------------------------------------
LP=""
for c in "${LOOPPLANE_HOME:-}" "$REPO/LoopPlane" "$REPO/../LoopPlane" "$HOME/LoopPlane" "$PROJECT/LoopPlane"; do
  [ -n "$c" ] && [ -f "$c/scripts/loopplane" ] && { LP="$(cd "$c" && pwd)"; break; }
done

if [ -z "$LP" ]; then
  if [ "$CLONE" = 0 ]; then
    echo "LoopPlane not found and --no-clone was given." >&2
    echo "Clone it yourself: git clone https://github.com/LJC-FVNR/LoopPlane $REPO/LoopPlane" >&2
    exit 1
  fi
  echo "LoopPlane not found. Cloning github.com/LJC-FVNR/LoopPlane into $REPO/LoopPlane"
  git clone --depth 1 https://github.com/LJC-FVNR/LoopPlane "$REPO/LoopPlane" || exit 1
  LP="$REPO/LoopPlane"
fi

echo "LoopPlane : $LP"
echo "Project   : $PROJECT"

if [ ! -d "$PROJECT/.loopplane" ]; then
  echo
  echo "Note: $PROJECT has no .loopplane/ yet, so the dashboard will be empty."
  echo "Set the workflow up first by pasting the prompt from 03_loopplane_research_loop.md"
  echo "into your agent. This script only shows a dashboard, it does not create one."
  echo
fi

# --- start the dashboard ----------------------------------------------------
mkdir -p "$PROJECT/.loopplane"
LOG="$PROJECT/.loopplane/dashboard.log"

# LoopPlane only accepts POSTs whose origin is the host it bound to, so through a
# forwarded URL every action button returns 403 "same-origin check failed". Turn
# that check off by default. The token still gates mutating calls, verified
# against v1.6.0: an off-origin POST without one is still a 401.
# --strict-origin restores the check rather than merely declining to turn it off,
# so the flag still means something after a previous default run flipped the file.
WANT_SAME_ORIGIN=$([ "$ALLOW_ORIGIN" = 1 ] && echo false || echo true)
changed="$(python3 - "$PROJECT" "$WANT_SAME_ORIGIN" <<'PY'
import glob, json, os, sys
project, want = sys.argv[1], sys.argv[2] == "true"
for path in glob.glob(os.path.join(project, ".loopplane/workflows/*/config/security.json")):
    with open(path, encoding="utf-8") as fh:
        cfg = json.load(fh)
    dash = cfg.setdefault("dashboard", {})
    if bool(dash.get("same_origin_required", True)) is want:
        continue                     # already correct, leave the file and the server alone
    dash["same_origin_required"] = want
    with open(path, "w", encoding="utf-8") as fh:
        json.dump(cfg, fh, indent=2, sort_keys=True)
        fh.write("\n")
    print(os.path.relpath(path, project))
PY
)"

if [ -n "$changed" ]; then
  if [ "$ALLOW_ORIGIN" = 1 ]; then
    echo "Same-origin check off (the dashboard token is still required) in:"
  else
    echo "Same-origin check restored in:"
  fi
  echo "$changed" | sed 's/^/  /'
  # A server already running holds the old value in memory, so replace it. Its
  # own stop relies on registry records, which go missing often enough that an
  # orphan is left holding the port and serving the old config. Then this script
  # starts a fresh server one port up and the setting looks like it did nothing,
  # so sweep the orphans by command line too, scoped to this project.
  python3 "$LP/scripts/loopplane" dashboard stop --project "$PROJECT" >/dev/null 2>&1 || true
  while read -r stale_pid; do
    [ -n "$stale_pid" ] && kill "$stale_pid" 2>/dev/null
  done < <(ps -eo pid=,args= 2>/dev/null | grep "loopplane dashboard" | grep -v grep \
             | grep -F -- "$PROJECT" | awk '{print $1}')
  sleep 0.5
fi

# Probe in a subshell: `exec` with no command in THIS shell would make the
# redirection permanent and silently swallow every later error message.
port_taken() { (exec 3<>"/dev/tcp/127.0.0.1/$1") 2>/dev/null; }

# A busy port is somebody else's process, not necessarily a dashboard, so step
# past it rather than assuming we can reuse whatever is sitting there.
if [ "$PORT" != "auto" ]; then
  want="$PORT"
  n=0
  while [ "$n" -lt 20 ] && port_taken "$PORT"; do PORT=$((PORT+1)); n=$((n+1)); done
  if port_taken "$PORT"; then echo "No free port near $want." >&2; exit 1; fi
  [ "$PORT" != "$want" ] && echo "Port $want is in use by something else, using $PORT instead."
fi

nohup python3 "$LP/scripts/loopplane" dashboard --project "$PROJECT" --port "$PORT" \
  >"$LOG" 2>&1 &
PID=$!
disown "$PID" 2>/dev/null || true
echo "Dashboard : pid $PID, log $LOG"

# Fixed port: wait for the bind. Auto port: read the port back out of the log.
ok=0
i=0
while [ "$i" -lt 80 ]; do
  if ! kill -0 "$PID" 2>/dev/null; then
    echo
    echo "The dashboard exited immediately. Last lines of $LOG:" >&2
    tail -n 20 "$LOG" >&2
    exit 1
  fi
  if [ "$PORT" = "auto" ]; then
    found="$(grep -oE '(127\.0\.0\.1|localhost|0\.0\.0\.0):[0-9]{2,5}' "$LOG" 2>/dev/null | tail -n1 | sed 's/.*://')"
    if [ -n "$found" ]; then PORT="$found"; ok=1; break; fi
  else
    if port_taken "$PORT"; then ok=1; break; fi
  fi
  sleep 0.25
  i=$((i+1))
done

if [ "$ok" = 0 ]; then
  echo "Dashboard did not come up within 20s. Log so far:" >&2
  tail -n 20 "$LOG" >&2
  exit 1
fi

# --- resolve the URL --------------------------------------------------------
# The dashboard is token-protected, so the bare host:port gives a 401. The server
# writes the real link into LOOPPLANE_DASHBOARD.url; take its query string and
# graft it onto whichever host actually reaches us.
QUERY="$(python3 - "$PROJECT" "$PORT" <<'PY' 2>/dev/null
import glob, json, os, sys, urllib.parse
project, port = sys.argv[1], int(sys.argv[2])

link = os.path.join(project, "LOOPPLANE_DASHBOARD.url")
if os.path.exists(link):
    for line in open(link, encoding="utf-8", errors="replace"):
        line = line.strip()
        if line.upper().startswith("URL="):
            parsed = urllib.parse.urlparse(line[4:])
            if parsed.port == port and parsed.query:
                print(parsed.query)
                sys.exit()

for state in glob.glob(os.path.join(project, ".loopplane/workflows/*/runtime/dashboard_server.json")):
    try:
        rec = json.load(open(state, encoding="utf-8"))
    except Exception:
        continue
    if int(rec.get("port") or 0) != port:
        continue
    tf = rec.get("token_file") or ""
    tf = tf if os.path.isabs(tf) else os.path.join(project, tf)
    parts = {}
    if os.path.exists(tf):
        parts["token"] = open(tf, encoding="utf-8").read().strip()
    if rec.get("workflow_id"):
        parts["workflow"] = rec["workflow_id"]
    if parts:
        print(urllib.parse.urlencode(parts))
        sys.exit()
PY
)"

if [ -n "${CODESPACE_NAME:-}" ] && [ -n "${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN:-}" ]; then
  BASE="https://${CODESPACE_NAME}-${PORT}.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}"
  IN_CS=1
else
  BASE="http://localhost:${PORT}"
  IN_CS=0
fi

if [ -n "$QUERY" ]; then
  URL="${BASE}/?${QUERY}"
else
  URL="${BASE}/"
  echo "Warning: could not find the dashboard token, so this URL will probably 401." >&2
fi

if [ "$PUBLIC" = 1 ]; then
  if [ "$IN_CS" = 1 ] && command -v gh >/dev/null 2>&1; then
    gh codespace ports visibility "${PORT}:public" -c "$CODESPACE_NAME" \
      && echo "Port $PORT is now public. Anyone with the link can see this dashboard."
  else
    echo "--public only applies inside a Codespace with the gh CLI available; skipping."
  fi
fi

echo
echo "  $URL"
echo

if [ "$OPEN" = 1 ]; then
  if [ -n "${BROWSER:-}" ] && command -v "$BROWSER" >/dev/null 2>&1; then
    "$BROWSER" "$URL" >/dev/null 2>&1 &
  elif command -v open >/dev/null 2>&1; then
    open "$URL"
  elif command -v xdg-open >/dev/null 2>&1; then
    xdg-open "$URL" >/dev/null 2>&1 &
  else
    echo "No browser opener found. Open the URL above by hand."
  fi
fi

if [ "$IN_CS" = 1 ]; then
  echo "If the tab does not load, open the PORTS panel next to TERMINAL and click the"
  echo "globe icon on the row for port $PORT. Forwarded ports are private by default."
  if [ "$ALLOW_ORIGIN" = 0 ]; then
    echo
    echo "You passed --strict-origin, so action buttons clicked through this forwarded URL"
    echo "will return 403 same-origin check failed. Reading works; approve from the terminal."
  fi
fi

echo
echo "Stop it later with:  python3 $LP/scripts/loopplane dashboard stop --project $PROJECT"
