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

set -uo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT="${LOOPPLANE_PROJECT:-$PWD}"
PORT="${LOOPPLANE_PORT:-8765}"
PUBLIC=0
CLONE=1
OPEN=1

while [ $# -gt 0 ]; do
  case "$1" in
    --project) PROJECT="$2"; shift 2 ;;
    --port)    PORT="$2"; shift 2 ;;
    --public)  PUBLIC=1; shift ;;
    --no-clone) CLONE=0; shift ;;
    --no-open) OPEN=0; shift ;;
    -h|--help) sed -n '2,20p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
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
  echo
  echo "Heads up: reading the dashboard works through the forwarded URL, but buttons that"
  echo "act (approve, control) send a POST, and LoopPlane only accepts POSTs whose origin"
  echo "is the bind host. Through a Codespaces URL those come back 403. Approve from the"
  echo "terminal instead, or set same_origin_required false in the workflow's"
  echo "config/security.json if you accept what that turns off."
fi

echo
echo "Stop it later with:  python3 $LP/scripts/loopplane dashboard stop --project $PROJECT"
