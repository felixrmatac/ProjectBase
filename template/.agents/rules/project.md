---
id: project
version: 1.0.0
enforcement: mixed (declarative & machine-enforced)
---

# Reglas Generales del Proyecto

- **Svelte 5 Estricto**: Todo el código debe estar escrito en Svelte 5 con Runes. Cero sintaxis antigua.
- **Tipos de Supabase**: Los tipos de base de datos (`Database`) deben ser los autogenerados usando `npm run db:types`. Está terminantemente prohibido redeclararlos o crearlos a mano. Toda tipificación de DB debe provenir de `src/types/database.ts`.
- **Quality Gate Obligatorio**: Todas las tareas deben aprobar las comprobaciones del Quality Gate (`npm run quality-gate`). Las autoevaluaciones subjetivas sin evidencia automatizada no tienen validez.
