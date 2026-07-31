#!/usr/bin/env bash
# Install the coding agents used in this segment. Log in afterward: see docs/agent-setup.md.
#
#     bash scripts/setup-agents.sh
#
# Installs Claude Code always, and Codex too if you want it. Neither is logged in by
# this script; authentication is a separate, deliberate step.
set -euo pipefail

echo "Installing Claude Code..."
npm install -g @anthropic-ai/claude-code

echo "Installing Codex..."
npm install -g @openai/codex

echo
echo "Installed:"
claude --version 2>/dev/null || echo "  claude: not on PATH (restart your shell)"
codex --version  2>/dev/null || echo "  codex:  not on PATH (restart your shell)"

# Skip Claude Code's first-run wizard. No credentials involved, so this is worth doing
# regardless of how you end up authenticating.
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
echo
bash "$REPO_ROOT/scripts/claude-skip-onboarding.sh" "$REPO_ROOT" || true

echo
echo "Next: log in. See docs/agent-setup.md"
echo "  Claude Code, with the workspace key from the course:  export ANTHROPIC_API_KEY=..."
echo "  Codex, with your own ChatGPT account:                 codex   (then sign in)"
