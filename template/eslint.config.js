import svelte from 'eslint-plugin-svelte';
import * as svelteParser from 'svelte-eslint-parser';
import tseslint from 'typescript-eslint';

export default [
  ...svelte.configs['flat/recommended'],
  ...tseslint.configs.recommended.map((cfg) => ({
    ...cfg,
    files: ['**/*.ts', '**/*.svelte']
  })),
  {
    ignores: ['src/types/database.ts']
  },
  {
    files: ['**/*.svelte'],
    languageOptions: {
      parser: svelteParser,
      parserOptions: {
        parser: tseslint.parser,
        svelteFeatures: {
          generate: false
        }
      }
    },
    rules: {
      'prefer-const': 'off',
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
