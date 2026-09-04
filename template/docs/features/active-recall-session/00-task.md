---
id: active-recall-session
domain: active-recall
prd: ui-system-prd
status: IN_PROGRESS # State Machine: READY -> IN_PROGRESS -> IMPLEMENTED -> VALIDATING -> DONE
traceability:
  skill: new-feature@1.0.0
  rules:
    - project
    - frontend
    - frontend-design
    - database
    - testing
validation:
  quality_gate:
    status: pending
    evidence: null
---

# Feature: active-recall-session

## Contexto (Lazy Context)
- **PRD**: docs/product/ui-system-prd.md
- **Domain**: docs/domains/active-recall.md

> **Nota para el Agente:** Carga únicamente el contexto estrictamente necesario de las referencias anteriores para tomar tu próxima decisión.

## Objetivo
Implementar el módulo integral de Sesión de Estudio Activo (`StudySession`) con cálculo de intervalos FSRS, validación de esquemas en runtime con Valibot, persistencia segura en Supabase con RLS, e integración ergonómica de los componentes UI (`StudyCard`, `ZenHeader`, `RecallInput`, `RatingButton`).

## Criterios de Aceptación (Given / When / Then)

### Criterio 1: Validación y cálculo de intervalo FSRS (Lógica Pura)
- **Given** una tarjeta de estudio con estabilidad y dificultad actuales.
- **When** el usuario califica su evocación con una valoración del 1 al 4 (1: Again, 2: Hard, 3: Good, 4: Easy).
- **Then** el sistema calcula de forma determinista la nueva estabilidad, dificultad y fecha del próximo repaso en días.
- **Given** una calificación fuera del rango [1, 4] o con formato inválido.
- **When** se evalúa con el esquema de validación en runtime (Valibot).
- **Then** el esquema rechaza la entrada y emite un fallo controlado de validación.

### Criterio 2: Persistencia Segura en Supabase (RLS)
- **Given** un usuario autenticado completando un repaso.
- **When** se envía el registro del repaso con `card_id`, `rating`, y `recall_answer`.
- **Then** se inserta en `study_reviews` asignando `user_id = auth.uid()`.
- **Given** un intento de lectura o mutación por un usuario ajeno o no autenticado.
- **When** se evalúa la política de Row Level Security.
- **Then** Supabase bloquea el acceso denegando la operación.

### Criterio 3: Experiencia de Usuario y Orquestación Zen (Svelte 5 Runes)
- **Given** una lista de tarjetas de estudio para la sesión.
- **When** el usuario navega la sesión.
- **Then** se muestra el progreso "X de Y" en `ZenHeader` sin temporizadores estresantes.
- **When** el usuario redacta su respuesta en `RecallInput` y pulsa `[Cmd/Ctrl+Enter]`, o presiona `[Espacio]`.
- **Then** se revela la solución y se habilitan los 4 botones de calificación `RatingButton` con atajos `[1]`, `[2]`, `[3]`, `[4]`.
- **When** el usuario califica la tarjeta con una tecla o click.
- **Then** se despacha la acción de guardado y se transiciona suavemente a la siguiente tarjeta.

## Checklist de Verificación
- [x] Especificación de la tarea y criterios Given/When/Then documentados.
- [ ] Migración SQL `study_reviews` con RLS habilitado y políticas por usuario.
- [ ] Checkpoint de seguridad de base de datos confirmado por el usuario.
- [ ] Tipos de base de datos sincronizados en `src/types/database.ts`.
- [ ] Fase RED: Pruebas unitarias de Vitest para algoritmo FSRS y schema Valibot.
- [ ] Fase RED: Pruebas de integración de componentes para `StudySession`.
- [ ] Fase GREEN: Implementación de `fsrs.ts` y `review-schema.ts` en TypeScript estricto.
- [ ] Fase GREEN: Implementación de `StudySession.svelte` con Svelte 5 Runes y Tailwind.
- [ ] Calidad de código: `npm run lint`, `npm run typecheck`, `npm test` passing al 100%.
- [ ] Quality Gate verificado vía `bash scripts/quality-gate.sh`.
- [ ] Product Owner Acceptance Review y checklist completado.
