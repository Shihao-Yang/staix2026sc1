#!/usr/bin/env bash
# Pre-complete Claude Code's first-run setup so `claude` opens straight to the prompt.
#
#     bash scripts/claude-skip-onboarding.sh
#
# Without this, the first `claude` in a fresh Codespace walks every student through the
# onboarding wizard, and the login screen in that wizard will happily send them into
# their OWN account instead of using the credential you just gave them. In a room of
# thirty that costs you ten minutes and splits the class across two auth states.
#
# This writes ~/.claude.json with onboarding marked complete and the folder-trust dialog
# pre-accepted for this repo. It touches NO credentials, so it is safe and useful no
# matter how you authenticate: workspace API key, shared token, or your own account.
#
# Idempotent. Re-running is harmless. Existing settings (including your theme) are kept.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="${1:-$REPO_ROOT}"

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 not found; skipping onboarding pre-completion." >&2
  exit 0
fi

python3 - "$TARGET" <<'PY'
import json, os, sys

root = sys.argv[1] if len(sys.argv) > 1 else os.getcwd()
path = os.path.expanduser("~/.claude.json")

try:
    data = json.load(open(path)) if os.path.exists(path) else {}
except Exception:
    data = {}          # unreadable or corrupt: start clean rather than crash
if not isinstance(data, dict):
    data = {}

data["hasCompletedOnboarding"] = True
data.setdefault("theme", "dark")          # setdefault: never clobber a chosen theme
data.setdefault("projects", {}).setdefault(root, {})["hasTrustDialogAccepted"] = True

with open(path, "w") as fh:
    json.dump(data, fh, indent=2)

print("Onboarding pre-completed in %s" % path)
print("Folder trust pre-accepted for %s" % root)
PY

echo "Claude Code will now open straight to the prompt."
