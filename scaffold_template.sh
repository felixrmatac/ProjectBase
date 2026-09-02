#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

readonly PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
FORCE=false
VERIFY=false

usage() {
  echo "Uso: ./scaffold-llm-project.sh [opciones]"
  echo "Opciones:"
  echo "  --force     Sobrescribe archivos generados por este scaffold"
  echo "  --verify    Ejecuta ./scripts/quality-gate.sh tras la creación"
  echo "  -h, --help  Muestra esta ayuda"
}

log()  { printf '[SCAFFOLD] %s\n' "$*"; }
fail() { printf '[SCAFFOLD][ERROR] %s\n' "$*" >&2; exit 1; }

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --force)  FORCE=true ;;
      --verify) VERIFY=true ;;
      -h|--help) usage; exit 0 ;;
      *) fail "Argumento desconocido: $1" ;;
    esac
    shift
  done
}

ensure_repo_root() {
  [[ -n "$PROJECT_ROOT" ]] || fail "Este script debe ejecutarse dentro de un repositorio Git."
  local current_root
  current_root="$(pwd -P)"
  [[ "$current_root" == "$PROJECT_ROOT" ]] || fail "Ejecuta este script desde la raíz del repo: $PROJECT_ROOT"
}

copy_templates() {
  log "Copiando plantilla..."
  local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  cp -a "$script_dir/template/." ./
}

main() {
  parse_args "$@"
  ensure_repo_root
  copy_templates

  log "Scaffolding completado."
  if [[ "$VERIFY" == true ]]; then
    ./scripts/quality-gate.sh
  fi
}

main "$@"