# Reglas Generales del Proyecto

- **Svelte 5 Estricto**: Todo el código debe estar escrito en Svelte 5 con Runes. Cero sintaxis antigua.
- **Tipos de Supabase**: Los tipos de base de datos (`Database`) deben ser los autogenerados. Está terminantemente prohibido redeclararlos o crearlos a mano. Toda tipificación de DB debe provenir de `src/types/database.ts`.
- **Quality Gate Obligatorio**: No existe la autoevaluación subjetiva para dar una tarea por terminada. Todas las tareas deben pasar el orquestador `./scripts/quality-gate.sh` de forma exitosa (exit code 0).
- **Flujo de Trabajo (Lazy Context)**:
  1. Lee el `00-task.md` de la feature actual.
  2. Lee los archivos referenciados en `00-task.md` (PRD, Domain) SOLO si es necesario. No copies su contenido dentro de la feature.
