/**
 * ESLint Configuration Reference
 *
 * This configuration serves as a reference for projects using these AI rules.
 * It demonstrates the TypeScript rules documented in .kiro/standards/typescript/style.md
 *
 * To use in your project:
 * 1. Copy this file to your project root
 * 2. Add React/Next.js plugins if needed (see commented section below)
 * 3. Run: npm install -D eslint @typescript-eslint/eslint-plugin @typescript-eslint/parser
 */

import js from '@eslint/js';
import typescript from '@typescript-eslint/eslint-plugin';
import typescriptParser from '@typescript-eslint/parser';
import prettier from 'eslint-config-prettier';
import globals from 'globals';

export default [
  js.configs.recommended,
  {
    ignores: [
      'node_modules/',
      'dist/',
      'build/',
      'coverage/',
      '*.config.js',
      '*.config.mjs',
    ],
  },
  {
    files: ['**/*.{ts,tsx}'],
    languageOptions: {
      parser: typescriptParser,
      parserOptions: {
        ecmaVersion: 'latest',
        sourceType: 'module',
        // Enable type-aware linting (required for rules like no-floating-promises)
        project: './tsconfig.json',
        tsconfigRootDir: import.meta.dirname,
      },
      globals: {
        ...globals.node,
        ...globals.es2022,
      },
    },
    plugins: {
      '@typescript-eslint': typescript,
    },
    rules: {
      // Base TypeScript rules
      ...typescript.configs.recommended.rules,

      // Type safety - explicit return types (per coding standards)
      // Reference: .kiro/standards/typescript/style.md#explicit-function-return-type
      '@typescript-eslint/explicit-function-return-type': ['error', {
        allowExpressions: true,
        allowTypedFunctionExpressions: true,
        allowHigherOrderFunctions: true,
      }],
      '@typescript-eslint/explicit-module-boundary-types': 'error',

      // Variable handling
      '@typescript-eslint/no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
      '@typescript-eslint/no-explicit-any': 'warn',

      // Error handling - use specific error classes (per coding standards)
      // Reference: .kiro/standards/typescript/style.md#only-throw-error
      '@typescript-eslint/only-throw-error': 'error',

      // Async safety - no floating promises
      // Reference: .kiro/standards/typescript/style.md#no-floating-promises
      '@typescript-eslint/no-floating-promises': 'error',

      // Unsafe any operations - warn to catch potential issues
      // Reference: .kiro/standards/typescript/style.md#avoiding-any
      '@typescript-eslint/no-unsafe-assignment': 'warn',
      '@typescript-eslint/no-unsafe-member-access': 'warn',
      '@typescript-eslint/no-unsafe-return': 'warn',

      // General rules
      'no-console': ['warn', { allow: ['warn', 'error'] }],
      'prefer-const': 'error',
      'no-var': 'error',
    },
  },

  // Test files - relaxed rules
  {
    files: ['**/__tests__/**/*', '**/*.test.ts', '**/*.test.tsx', '**/*.spec.ts'],
    rules: {
      '@typescript-eslint/no-explicit-any': 'off',
      '@typescript-eslint/no-unsafe-assignment': 'off',
      '@typescript-eslint/no-unsafe-member-access': 'off',
      '@typescript-eslint/no-unsafe-return': 'off',
      '@typescript-eslint/explicit-function-return-type': 'off',
    },
  },

  prettier,
];

/*
 * React/Next.js Extension (add if using React)
 *
 * Install:
 *   npm install -D eslint-plugin-react eslint-plugin-react-hooks eslint-plugin-jsx-a11y
 *
 * Add to imports:
 *   import react from 'eslint-plugin-react';
 *   import reactHooks from 'eslint-plugin-react-hooks';
 *   import jsxA11y from 'eslint-plugin-jsx-a11y';
 *
 * Add to plugins:
 *   react,
 *   'react-hooks': reactHooks,
 *   'jsx-a11y': jsxA11y,
 *
 * Add to rules:
 *   ...react.configs.recommended.rules,
 *   ...reactHooks.configs.recommended.rules,
 *   ...jsxA11y.configs.recommended.rules,
 *   'react/react-in-jsx-scope': 'off',
 *   'react/prop-types': 'off',
 *
 * Add to settings:
 *   settings: {
 *     react: { version: 'detect' },
 *   },
 *
 * Add to languageOptions.globals:
 *   ...globals.browser,
 */
