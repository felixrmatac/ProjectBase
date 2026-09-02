#!/usr/bin/env bash
set -Eeuo pipefail

MACHINE_MODE=false
[[ "${1:-}" == "--machine" || "${2:-}" == "--machine" ]] && MACHINE_MODE=true

fail() {
  if [[ "$MACHINE_MODE" == "true" ]]; then
    local err
    err="$(printf '%s' "$1" | tr '\n' ' ' | tr -s ' ')"
    printf 'STATUS=FAIL\nCHECK=%s\nERROR=%s\n' "$2" "$err" >&2
  else
    printf '[QUALITY-GATE][FAIL] %s\n' "$1" >&2
  fi
  exit 1
}

run_check() {
  local output
  if ! output=$("${@:3}" 2>&1); then
    [[ "$MACHINE_MODE" == "true" ]] && fail "$(echo "$output" | head -n 1)" "$2"
    echo "$output"
    fail "$1 falló." "$2"
  fi
}

# Change-aware logic
RUN_FRONTEND=false
RUN_DB=false
RUN_DOCS_ONLY=true

if git rev-parse HEAD >/dev/null 2>&1; then
  CHANGES=$(git diff HEAD --name-only || true)
  CHANGES+=$'\n'$(git ls-files --others --exclude-standard || true)
else
  CHANGES=$(git ls-files || true)
fi

if [[ -z "$CHANGES" ]]; then
  RUN_FRONTEND=true; RUN_DB=true; RUN_DOCS_ONLY=false
else
  while read -r file; do
    [[ -z "$file" ]] && continue
    case "$file" in
      docs/*|*.md|.agents/*) ;; # DOCS/RULES
      package.json|*config*.js|tsconfig*) RUN_FRONTEND=true; RUN_DB=true; RUN_DOCS_ONLY=false ;;
      src/routes/*|src/components/*|*.svelte|src/lib/*|*.ts|tests/*) RUN_FRONTEND=true; RUN_DOCS_ONLY=false ;;
      src/types/database.ts) RUN_DB=true; RUN_FRONTEND=true; RUN_DOCS_ONLY=false ;;
      supabase/*) RUN_DB=true; RUN_DOCS_ONLY=false ;;
      *) RUN_FRONTEND=true; RUN_DB=true; RUN_DOCS_ONLY=false ;;
    esac
  done <<< "$CHANGES"
fi

if [[ "$RUN_DOCS_ONLY" == "true" ]]; then
  [[ "$MACHINE_MODE" == "true" ]] && echo "STATUS=PASS" || echo "[QUALITY-GATE] PASSED (docs only)"
  exit 0
fi

if [[ "$RUN_FRONTEND" == "true" ]]; then
  run_check "svelte-check" "svelte" npx svelte-check
  run_check "Linter" "lint" npm run lint
  run_check "Tests" "test" npm run test
fi

if [[ "$RUN_DB" == "true" ]]; then
  if command -v supabase >/dev/null 2>&1 && supabase status >/dev/null 2>&1; then
    run_check "DB tests" "db-test" supabase test db
    tmp="$(mktemp)"
    supabase gen types typescript --local >"$tmp" 2>/dev/null || fail "Fallo al generar tipos." "types"
    diff -u src/types/database.ts "$tmp" >/dev/null 2>&1 || fail "database.ts desactualizado." "types"
    rm -f "$tmp"
  fi
fi

[[ "$MACHINE_MODE" == "true" ]] && echo "STATUS=PASS" || echo "[QUALITY-GATE] PASSED"
