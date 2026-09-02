---
id: database
version: 1.0.0
enforcement: machine-enforced (via pgTAP and schema checks)
---

# Protocolo de Base de Datos (Supabase)

- **Alteraciones vía Migración SQL**: Toda alteración al esquema de la base de datos está restringida a migraciones SQL en `supabase/migrations/`. Se prohíbe realizar mutaciones de esquema directas en caliente.
- **RLS Obligatorio**: Es mandatorio tener habilitado `ROW LEVEL SECURITY` (`ALTER TABLE ... ENABLE ROW LEVEL SECURITY;`) para cada tabla existente.
