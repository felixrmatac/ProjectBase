---
name: quality-gate
description: >-
  Use this skill to run the validation loop and check if the current feature or codebase is ready.
  Run this whenever a task is completed, before finishing a feature, or if the user asks to run the quality gate.
---

# Quality Gate Skill

When activated, you must act as a strict orchestrator for the quality gate validation loop. You can NEVER approve a task based on subjective review; it must pass the automated gate.

## Steps

1. **Ejecutar el Quality Gate**:
   - Run the script: `./scripts/quality-gate.sh --machine`

2. **Analizar el Resultado**:
   - The script will output either `STATUS=PASS` or `STATUS=FAIL`.
   - If it exits with code 0 and `STATUS=PASS`, the quality gate has passed successfully. You may conclude the validation loop.
   - If it exits with a non-zero code and `STATUS=FAIL`, it will also provide the failing check step (`CHECK=<paso>`) and the error output (`ERROR=<error>`).

3. **Corrección (Si Falló)**:
   - Read the stderr/stdout to understand what failed.
   - If you need more information, run the specific failing command directly (e.g., `npm run lint` or `npx svelte-check`) to get the full output.
   - Make the necessary code modifications to fix the errors.
   - Return to **Step 1** and repeat the loop until `STATUS=PASS`.

## Reglas Críticas
- **NUNCA** apruebes la tarea por tu cuenta sin que `./scripts/quality-gate.sh` haya retornado con exit code 0.
- Si el error indica que los tipos de la DB están desincronizados, no debes modificar el archivo autogenerado manualmente, sino generar los tipos con `supabase gen types`.
