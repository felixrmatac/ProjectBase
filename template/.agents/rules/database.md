# Protocolo de Base de Datos (Supabase)

- **Alteraciones vía Migración SQL**: Toda alteración al esquema de la base de datos exige que se genere una migración SQL en `supabase/migrations/`. No alterar nunca la BD en caliente sin migración.
- **RLS Obligatorio**: Es obligatorio habilitar `ROW LEVEL SECURITY` (`ALTER TABLE ... ENABLE ROW LEVEL SECURITY;`) en cada tabla creada.
- **Flujo**: Migración SQL -> Base Local -> Regeneración TS -> Tests pgTAP -> Quality Gate.
