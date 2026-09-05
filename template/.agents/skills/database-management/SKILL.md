---
name: database-management
version: 1.0.0
description: >-
  Consolidates data operations such as resetting the local database and regenerating TypeScript contracts.
---

# Database Management Skill

When activated by the user requesting database operations, execute the corresponding standardized commands from `package.json`.

## STEPS

### 1. Resetear base de datos (Database Reset)
If the user asks to reset the local database:
- Invoke: `npm run db:reset`
- Inform the user that the local database has been successfully reset.

### 2. Regenerar contratos de TypeScript (Types Generation)
If the user asks to generate database types:
- Invoke: `npm run db:types`
- Inform the user that `src/types/database.ts` has been updated successfully.

### RESTRICTIONS
- Prohibido tipear rutas de archivos o banderas de `supabase gen types` manualmente fuera del script centralizado de `package.json`.
