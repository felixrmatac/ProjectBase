---
name: quality-gate
version: 2.1.0
description: >-
  Use this skill to run the validation loop and generate objective evidence of task completion.
  Run this whenever a task is implemented and moved to VALIDATING state.
---

# Quality Gate Skill

When activated, you must act as a strict orchestrator for the validation loop, executing tools directly via the standardized package.json script.

## STEPS

1. **Estado VALIDATING**: Ensure the task in `docs/features/*/00-task.md` is updated to `status: VALIDATING`.

2. **Ejecutar Quality Gate**: Run the following validation command in your terminal:
   - `npm run quality-gate` (or `bun run quality-gate`)

3. **Evalúa Resultado**:
   - Check the exit code of the command ($exit 0$).
   - If the command passes successfully (exit code 0), proceed to Step 4.
   - If the command fails, you MUST abort. Fix the application code, and repeat Step 2.
   - You MUST NOT interpret a failure as a pass, regardless of subjective reasoning. Do not allow updating the task state to DONE if this fails.

4. **Registra Evidencia y Cierra (DONE)**:
   - Validate the metadata of `00-task.md`.
   - Update `00-task.md`:
     - Change `status: DONE`.
     - Append the execution evidence at the end of the document.
   - Inform the user that validation is complete and the task is objectively DONE.
