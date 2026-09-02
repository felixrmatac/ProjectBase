---
id: frontend
version: 1.0.0
enforcement: declarative
---

# Reglas SvelteKit Frontend

- **Solo Runes**: Es obligatorio usar exclusivamente la sintaxis de Runes de Svelte 5 (`$state`, `$derived`, `$props`, `$effect`).
- **Fronteras validadas**: Toda entrada externa de usuario debe ser validada con `Valibot` en tiempo de ejecución (runtime) antes de ejecutar cualquier mutación de estado o llamada a base de datos.
- **Separación de Lógica**: La lógica de negocio debe estar extraída y aislada de los componentes UI.
