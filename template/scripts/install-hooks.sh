#!/usr/bin/env bash
set -euo pipefail

# Find git root
GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || true)

if [[ -z "$GIT_ROOT" ]]; then
  echo "Error: Not inside a git repository."
  exit 1
fi

HOOKS_DIR="$GIT_ROOT/.git/hooks"
PRE_COMMIT_HOOK="$HOOKS_DIR/pre-commit"
QG_SCRIPT="scripts/quality-gate.sh"

if [[ ! -f "$QG_SCRIPT" ]]; then
  echo "Error: $QG_SCRIPT not found. Are you running this from the project root?"
  exit 1
fi

echo "Installing pre-commit hook..."

# Create a simple pre-commit hook that calls quality-gate.sh
cat << 'EOF' > "$PRE_COMMIT_HOOK"
#!/usr/bin/env bash
set -e
echo "[pre-commit] Running quality gate..."
./scripts/quality-gate.sh
EOF

chmod +x "$PRE_COMMIT_HOOK"

echo "Success! The pre-commit hook has been installed."
echo "It will automatically run the Quality Gate before every commit."
echo "Note: You can bypass this local enforcement layer with 'git commit --no-verify'."
