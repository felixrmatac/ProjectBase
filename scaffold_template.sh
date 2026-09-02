#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

readonly PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"

usage() {
  echo "Uso: ./scaffold-llm-project.sh"
  echo "Este script inicializa el Agent Engineering Framework V4.1"
}

log()  { printf '[SCAFFOLD] %s\n' "$*"; }
fail() { printf '[SCAFFOLD][ERROR] %s\n' "$*" >&2; exit 1; }

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

ensure_repo_root() {
  [[ -n "$PROJECT_ROOT" ]] || fail "Este script debe ejecutarse dentro de un repositorio Git."
  local current_root
  current_root="$(pwd -P)"
  [[ "$current_root" == "$PROJECT_ROOT" ]] || fail "Ejecuta este script desde la raíz del repo: $PROJECT_ROOT"
}

copy_templates() {
  log "Copiando plantilla base del Framework V4.1..."
  local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  cp -a "$script_dir/template/." ./
}

main() {
  ensure_repo_root
  copy_templates
  log "Scaffolding completado exitosamente."
}

main "$@"