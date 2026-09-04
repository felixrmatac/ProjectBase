#!/usr/bin/env bash
set -Eeuo pipefail

TIMESTAMP="$(date -Iseconds)"
declare -A CHECKS_STATUS
declare -A CHECKS_REASON

compute_checksum() {
  local checksum=""
  local paths=""
  for p in src supabase package.json; do
    [[ -e "$p" ]] && paths+=" $p"
  done
  if [[ -n "$paths" ]]; then
    # shellcheck disable=SC2086
    if command -v md5sum >/dev/null 2>&1; then
      checksum=$(find $paths -type f 2>/dev/null | sort | xargs -r md5sum | md5sum | cut -d' ' -f1)
    elif command -v shasum >/dev/null 2>&1; then
      checksum=$(find $paths -type f 2>/dev/null | sort | xargs -r shasum | shasum | cut -d' ' -f1)
    fi
  fi
  echo "${checksum:-unknown}"
}

CODEBASE_CHECKSUM=$(compute_checksum)

fail() {
  local check="$1"
  local err="$2"
  # shellcheck disable=SC2001
  err="$(echo "$err" | sed 's/^/      /g')"
  
  cat <<YAML
quality_gate:
  version: 1
  status: failed
  timestamp: "$TIMESTAMP"
  codebase_checksum: "$CODEBASE_CHECKSUM"
  checks:
YAML

  for c in "${!CHECKS_STATUS[@]}"; do
    if [[ "${CHECKS_STATUS[$c]}" == "skipped" ]]; then
      echo "    $c:"
      echo "      status: skipped"
      echo "      reason: ${CHECKS_REASON[$c]}"
    else
      echo "    $c:"
      echo "      status: ${CHECKS_STATUS[$c]}"
    fi
  done

  cat <<YAML
    $check:
      status: failed
  failure:
    check: "$check"
    error: |
$err
YAML
  exit 1
}

run_check() {
  local check_id="$1"
  local output
  if ! output=$("${@:2}" 2>&1); then
    fail "$check_id" "$output"
  fi
  CHECKS_STATUS["$check_id"]="passed"
}

skip_check() {
  local check_id="$1"
  local reason="${2:-no_relevant_changes}"
  CHECKS_STATUS["$check_id"]="skipped"
  CHECKS_REASON["$check_id"]="$reason"
}

check_task_metadata() {
  local output=""
  for file in docs/features/*/00-task.md; do
    if [[ -f "$file" ]]; then
      if ! grep -q "^domain:" "$file"; then output+="Task $file is missing 'domain' field.\n"; fi
      if ! grep -q "^prd:" "$file"; then output+="Task $file is missing 'prd' field.\n"; fi
      if ! grep -q "^status:" "$file"; then output+="Task $file is missing 'status' field.\n"; fi
      if ! grep -q "^traceability:" "$file"; then output+="Task $file is missing 'traceability' field.\n"; fi
      
      local status
      status=$(grep "^status:" "$file" | sed 's/status: *//' | tr -d ' ' | tr -d '"')
      case "$status" in
        READY|IN_PROGRESS|IMPLEMENTED|VALIDATING|DONE|BLOCKED) ;;
        *) output+="Task $file has invalid status: '$status'.\n" ;;
      esac
    fi
  done
  
  if [[ -n "$output" ]]; then
    echo -e "$output"
    return 1
  fi
  return 0
}

check_task_states() {
  local output=""
  for file in docs/features/*/00-task.md; do
    if [[ -f "$file" ]]; then
      if grep -q "^status: DONE" "$file"; then
        if ! grep -q "status: passed" "$file"; then
           output+="Task $file is marked DONE but lacks 'status: passed' validation evidence.\n"
        fi
        local file_checksum
        file_checksum=$(grep "codebase_checksum:" "$file" | head -n1 | awk -F'"' '{print $2}')
        if [[ -z "$file_checksum" ]]; then
           file_checksum=$(grep "codebase_checksum:" "$file" | head -n1 | awk '{print $2}')
        fi
        if [[ "$file_checksum" != "$CODEBASE_CHECKSUM" ]]; then
           output+="Task $file is marked DONE but evidence is stale (checksum mismatch). Re-run validation.\n"
        fi
      fi
    fi
  done
  
  if [[ -n "$output" ]]; then
    echo -e "$output"
    return 1
  fi
  return 0
}

check_shellcheck() {
  if ! command -v shellcheck >/dev/null 2>&1; then
    echo "ShellCheck is not installed. Please install it."
    return 1
  fi
  local scripts
  scripts=$(find scripts -name "*.sh" 2>/dev/null || true)
  if [[ -n "$scripts" ]]; then
    # shellcheck disable=SC2086
    shellcheck $scripts || return 1
  fi
  if [[ -f "scaffold_template.sh" ]]; then
    shellcheck scaffold_template.sh || return 1
  fi
  return 0
}

check_lockfile() {
  if [[ ! -f "package.json" ]]; then
    return 0
  fi
  if [[ ! -f "package-lock.json" ]]; then
    echo "package.json exists but package-lock.json is missing. Please run npm install."
    return 1
  fi
  if [[ "package.json" -nt "package-lock.json" ]]; then
    echo "package.json is newer than package-lock.json. Please run npm install."
    return 1
  fi
  return 0
}

# Framework integrity checks (run regardless of application changes)
run_check "task_metadata" check_task_metadata
run_check "task_state" check_task_states
run_check "shellcheck" check_shellcheck
run_check "lockfile" check_lockfile

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
      docs/*|*.md|.agents/*) ;;
      package.json|*config*.js|tsconfig*) RUN_FRONTEND=true; RUN_DB=true; RUN_DOCS_ONLY=false ;;
      src/types/database.ts) RUN_DB=true; RUN_FRONTEND=true; RUN_DOCS_ONLY=false ;;
      src/routes/*|src/components/*|*.svelte|src/lib/*|*.ts|tests/*) RUN_FRONTEND=true; RUN_DOCS_ONLY=false ;;
      supabase/*) RUN_DB=true; RUN_DOCS_ONLY=false ;;
      *) RUN_FRONTEND=true; RUN_DB=true; RUN_DOCS_ONLY=false ;;
    esac
  done <<< "$CHANGES"
fi

if [[ "$RUN_DOCS_ONLY" == "true" ]]; then
  skip_check "svelte_check" "documentation_change_only"
  skip_check "eslint" "documentation_change_only"
  skip_check "vitest" "documentation_change_only"
  skip_check "db_tests" "documentation_change_only"
  skip_check "types" "documentation_change_only"
else
  if [[ "$RUN_FRONTEND" == "true" ]]; then
    run_check "svelte_check" npx svelte-check
    run_check "eslint" npm run lint
    run_check "vitest" npm run test
  else
    skip_check "svelte_check" "no_frontend_changes"
    skip_check "eslint" "no_frontend_changes"
    skip_check "vitest" "no_frontend_changes"
  fi

  if [[ "$RUN_DB" == "true" ]]; then
    if command -v supabase >/dev/null 2>&1 && supabase status >/dev/null 2>&1; then
      run_check "db_tests" supabase test db
      tmp="$(mktemp)"
      supabase gen types typescript --local >"$tmp" 2>/dev/null || fail "types" "Fallo al generar tipos localmente."
      diff -u src/types/database.ts "$tmp" >/dev/null 2>&1 || fail "types" "database.ts está desactualizado."
      rm -f "$tmp"
      CHECKS_STATUS["types"]="passed"
    else
      skip_check "db_tests" "supabase_not_running"
      skip_check "types" "supabase_not_running"
    fi
  else
    skip_check "db_tests" "no_db_changes"
    skip_check "types" "no_db_changes"
  fi
fi

cat <<YAML
quality_gate:
  version: 1
  status: passed
  timestamp: "$TIMESTAMP"
  codebase_checksum: "$CODEBASE_CHECKSUM"
  checks:
YAML

for c in "${!CHECKS_STATUS[@]}"; do
  if [[ "${CHECKS_STATUS[$c]}" == "skipped" ]]; then
    echo "    $c:"
    echo "      status: skipped"
    echo "      reason: ${CHECKS_REASON[$c]}"
  else
    echo "    $c:"
    echo "      status: passed"
  fi
done
