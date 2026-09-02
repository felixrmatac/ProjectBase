import svelte from 'eslint-plugin-svelte';

export default [
  ...svelte.configs['flat/recommended'],
  {
    files: ['**/*.svelte'],
    rules: {
      'no-restricted-syntax': [
        'error',
        {
          selector: 'ExportNamedDeclaration > VariableDeclaration > VariableDeclarator',
          message: 'Sintaxis obsoleta de Svelte 3/4 (export let). Usa Runes de Svelte 5 ($props).'
        }
      ]
    }
  },
  {
    files: ['**/*.ts', '**/*.js', '**/*.svelte'],
    ignores: ['src/types/database.ts'],
    rules: {
      'no-restricted-syntax': [
        'error',
        {
          selector: 'TSTypeAliasDeclaration[id.name="Database"], TSInterfaceDeclaration[id.name="Database"]',
          message: 'Tipo Database duplicado fuera de src/types/database.ts.'
        }
      ]
    }
  }
];
