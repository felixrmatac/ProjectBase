# Task: Cognitive UI System

## Feature
cognitive-ui-system

## Domain
active-recall

## PRD
docs/product/ui-system-prd.md

## Status
VALIDATING

## Descripción
Integrar el sistema de UI y diseño cognitivo de baja fatiga visual para el modo estudio activo.

## Entregables
- [x] `.agents/rules/frontend-design.md` (regla de ergonomía cognitiva)
- [x] `docs/domains/active-recall.md` (dominio y componentes)
- [x] `docs/product/ui-system-prd.md` (PRD y criterios de aceptación)
- [x] `src/lib/components/ui/StudyCard.svelte` (contenedor zen)
- [x] `src/lib/components/ui/RatingButton.svelte` (botón FSRS con atajos)
- [x] `src/lib/components/ui/ZenHeader.svelte` (contador "X de Y" + barra de progreso)
- [x] `src/lib/components/ui/RecallInput.svelte` (textarea con atajo Cmd/Ctrl+Enter)
- [x] `src/lib/components/ui/ui-components.test.ts` (tests unitarios Vitest)

## Criterios Cumplidos
- [x] Solo Svelte 5 Runes (`$props`, `$state`, `$derived`). Sin `export let` ni `$:`.
- [x] Paleta cognitiva Tailwind (`bg-slate-950` / `bg-stone-50`, `bg-slate-900/90`, bordes, variantes FSRS).
- [x] Tests unitarios en Vitest (10/10 PASS).

## Evidencia Quality Gate
- `npm run lint`: PASS (0 errores)
- `npm run typecheck` (svelte-check): PASS (0 errores, 0 warnings)
- `npm test` (vitest): PASS (10 tests)

## Notas
- Se añadió `vitest.config.ts` con `svelteTesting` plugin.
- Se registró `package.json` scripts `test`, `lint`, `typecheck` y devDependencies necesarias.
