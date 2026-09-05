#!/usr/bin/env bash
set -Eeuo pipefail
cd "$(git rev-parse --show-toplevel)" || exit 1
command -v supabase >/dev/null 2>&1 || { echo "Supabase CLI required"; exit 1; }
echo "Generando tipos de base de datos..."
supabase gen types typescript --local > src/types/database.ts
