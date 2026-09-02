#!/usr/bin/env bash
set -Eeuo pipefail
command -v supabase >/dev/null 2>&1 || { echo "Supabase CLI required"; exit 1; }

# Comprobación de seguridad: 'supabase status' solo funciona si hay una instancia local corriendo.
# Si falla, abortamos para evitar ejecutar destructivamente contra una base de datos remota si estuviera enlazada.
if ! supabase status >/dev/null 2>&1; then
  echo "[ERROR] Supabase local no está ejecutándose. Abortando 'db reset' para proteger producción."
  exit 1
fi

echo "Reiniciando base de datos local..."
supabase db reset
