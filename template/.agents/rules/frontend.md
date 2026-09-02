# Reglas SvelteKit Frontend

- **Solo Runes**: Es obligatorio usar exclusivamente la sintaxis de Runes de Svelte 5 (`$state`, `$derived`, `$props`, `$effect`).
- **Fronteras validadas**: Valida todas las entradas de usuario con Valibot en la frontera (runtime) antes de intentar cualquier mutación a la base de datos.
- **Separación de Lógica**: Separa la lógica de negocio pura de la lógica de UI de los componentes.
