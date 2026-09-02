---
name: new-feature
version: 1.0.0
description: >-
  Use this skill to initialize a new feature task. Run this when the user asks to create a new task or feature.
---

# New Feature Skill

When activated, execute this strict workflow to initialize a new task.

## STEPS

1. **Identifica Inputs**: Ask the user for the following if not provided:
   - `domain` (e.g., orders, users)
   - `feature` (e.g., orders-filter)
   - `PRD` (e.g., orders-prd, or same as domain)

2. **Carga y Valida**:
   - Check if `docs/product/<PRD>.md` exists.
   - Check if `docs/domains/<domain>.md` exists.
   - If missing, abort and request the user to create them first.
   - Check if `docs/features/<feature>/00-task.md` already exists. If yes, abort.

3. **Genera (Implementación)**:
   - Create `docs/features/<feature>/00-task.md` using the exact structure below.
   - Ensure the state machine is initialized at `READY` and traceability is recorded.

```markdown
---
id: <feature>
domain: <domain>
prd: <PRD>
status: READY
traceability:
  skill: new-feature@1.0.0
  rules: []
validation:
  quality_gate:
    status: pending
    evidence: null
---

# Feature: <feature>

## Contexto (Lazy Context)
- **PRD**: docs/product/<PRD>.md
- **Domain**: docs/domains/<domain>.md

> **Nota para el Agente:** Carga únicamente el contexto estrictamente necesario de las referencias anteriores para tomar tu próxima decisión.

## Objetivo
[Descripción de la feature o pedir al usuario]
```

4. **Reglas de Transición de Estado**:
   - The state machine for a task is strictly: `READY -> IN_PROGRESS -> IMPLEMENTED -> VALIDATING -> DONE`.
   - The Agent MUST NOT transition a task to `DONE` directly from `READY`, `IN_PROGRESS`, or `IMPLEMENTED`.
   - The Agent MUST NOT transition a task to `DONE` if validation fails (`VALIDATING + FAIL -> IN_PROGRESS`).
   - If a task is modified or returned to `IN_PROGRESS` after being `DONE`, the Agent MUST invalidate stale evidence by setting `validation.quality_gate.status: pending` and removing any `codebase_checksum`.
   - The Agent MUST update `traceability.rules` with any declarative rules that were relevant to the implementation.

5. **Validación**:
   - Confirm to the user the file was successfully created and the task is `READY`.
