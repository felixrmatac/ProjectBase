---
name: new-feature
description: >-
  Use this skill to create a new feature task file (00-task.md).
  Run this whenever the user requests to start a new feature or create a new task.
---

# New Feature Skill

When activated, you must guide the user to create a new feature task following this strict procedure:

## Steps

1. **Solicitar Información**: Ask the user for the following 3 variables if not provided yet:
   - `domain` (e.g., orders, users)
   - `feature` (e.g., orders-filter)
   - `PRD` (e.g., orders-filter-prd, or same as domain)

2. **Validar Existencia**:
   - Check if the PRD file exists at `docs/product/<PRD>.md`.
   - Check if the Domain file exists at `docs/domains/<domain>.md`.
   - If any of them do NOT exist, stop and inform the user that they must create them first.
   - Check if `docs/features/<feature>/00-task.md` already exists. If it does, abort and inform the user.

3. **Generar el Archivo de Tarea**:
   - Create the directory `docs/features/<feature>/`.
   - Create the file `docs/features/<feature>/00-task.md` with the exact Lazy Context format below.
   - **CRITICAL**: Do NOT copy or duplicate the contents of the PRD or Domain into the task. Just reference them as shown in the template.

## Template para `00-task.md`

```markdown
---
id: <feature>
domain: <domain>
prd: <PRD>
status: draft
---

# Feature: <feature>

## Contexto (Lazy Context)
- **PRD**: docs/product/<PRD>.md
- **Domain**: docs/domains/<domain>.md

> **Nota para LLMs:** No copies ni dupliques el contenido del PRD o Domain aquí. Referencia únicamente. Lee solo lo requerido para esta feature.

## Objetivo
[Describe el objetivo general o pide al usuario que lo complete]

## Criterios de Éxito (Definition of Done verificable)
- [ ] PRD requirement satisfied
- [ ] Domain rules satisfied
- [ ] Implementation exists
- [ ] Relevant tests exist
- [ ] Relevant tests pass
- [ ] Quality gate passes
```

4. **Confirmación**: Inform the user that the task file was created successfully.
