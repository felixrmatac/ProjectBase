#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

usage() {
  echo "Uso: scaffold_template.sh <nombre-proyecto>"
  echo "Crea un proyecto con el Agent Engineering Framework V4.1"
  echo ""
  echo "Ejemplo: scaffold_template.sh active_recall"
}

log()  { printf '[SCAFFOLD] %s\n' "$*"; }
fail() { printf '[SCAFFOLD][ERROR] %s\n' "$*" >&2; exit 1; }

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

[[ $# -eq 1 ]] || fail "Debes especificar el nombre del proyecto. Usa -h para ayuda."

PROJECT_NAME="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$(pwd)/$PROJECT_NAME"

[[ ! -e "$TARGET_DIR" ]] || fail "Ya existe un directorio llamado '$PROJECT_NAME' en $(pwd)"

log "Creando proyecto '$PROJECT_NAME'..."
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"
git init -b main

log "Copiando plantilla base del Framework V4.1..."
cp -a "$SCRIPT_DIR/template/." ./

log "Renombrando paquete a '$PROJECT_NAME'..."
sed -i "s/\"name\": \"project\",/\"name\": \"$PROJECT_NAME\",/" package.json

log "Scaffolding completado exitosamente en $TARGET_DIR"