# Contributing to Kiro AI Rules

Thank you for your interest in contributing! This guide covers how to propose changes to AI coding standards, templates, and configurations.

## Table of Contents

- [Development Setup](#development-setup)
- [What Can I Contribute?](#what-can-i-contribute)
- [Code Quality Tools](#code-quality-tools)
- [Git Workflow](#git-workflow)
- [Commit Conventions](#commit-conventions)
- [Pull Request Process](#pull-request-process)

## Development Setup

### Prerequisites

- Node.js 20+
- npm 9+
- Git

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/palpito-hunch/kiro-project-template.git
   cd kiro-project-template
   ```

2. **Install dependencies**

   ```bash
   npm install
   ```

   This automatically sets up Husky git hooks via the `prepare` script.

3. **Verify setup**

   ```bash
   npm run validate
   ```

## What Can I Contribute?

### Standards (`.kiro/standards/`)

- Improve existing coding standards
- Add new library-specific standards
- Fix errors or inconsistencies
- Add examples and clarifications

### Templates (`.kiro/templates/`)

- Improve feature spec template
- Add new templates for common patterns

### Validation Rules (`.kiro/validation/`)

- Add new validation rules for AI code generation
- Improve pattern matching accuracy
- Fix false positives/negatives

### Reference Configs

- Update TypeScript or ESLint configurations
- Add missing rules or options
- Improve documentation comments

## Code Quality Tools

### ESLint

Validates TypeScript code in the `.kiro/` directory.

```bash
# Check for issues
npm run lint

# Auto-fix issues
npm run lint:fix
```

### Prettier

Formats code for consistent style.

```bash
# Format all files
npm run format

# Check formatting (CI)
npm run format:check
```

### TypeScript

Type checks the codebase.

```bash
npm run type-check
```

### Run All Checks

```bash
npm run validate
```

## Git Workflow

### Branch Naming

Use the format: `type/description`

| Type        | Purpose                       |
| ----------- | ----------------------------- |
| `feature/`  | New standards or templates    |
| `fix/`      | Corrections to existing rules |
| `docs/`     | Documentation improvements    |
| `refactor/` | Restructuring without changes |
| `chore/`    | Maintenance tasks             |

**Examples:**

- `feature/react-query-standards`
- `fix/prisma-transaction-rule`
- `docs/improve-examples`

### Workflow

1. Create a branch from `main`

   ```bash
   git checkout -b feature/my-changes
   ```

2. Make your changes with atomic commits

3. Push and create a pull request
   ```bash
   git push -u origin feature/my-changes
   ```

## Commit Conventions

We use [Conventional Commits](https://www.conventionalcommits.org/) enforced by commitlint.

### Format

```
type(scope): description

[optional body]

[optional footer]
```

### Types

| Type       | Description                              |
| ---------- | ---------------------------------------- |
| `feat`     | New standard, template, or rule          |
| `fix`      | Correction to existing content           |
| `docs`     | Documentation only                       |
| `refactor` | Restructuring without changing behavior  |
| `chore`    | Maintenance tasks                        |

### Examples

```bash
# New standard
git commit -m "feat(standards): add React Query standards"

# Fix to existing rule
git commit -m "fix(validation): correct transaction-required pattern"

# Documentation
git commit -m "docs: improve TypeScript style examples"
```

### Rules

- Type must be lowercase
- Subject must be lowercase
- No period at the end of subject
- Maximum header length: 100 characters

## Pull Request Process

### Before Submitting

1. Ensure all checks pass locally:

   ```bash
   npm run validate
   ```

2. If adding standards, ensure they include:
   - Clear rationale for each rule
   - Good and bad examples
   - References to ESLint/TypeScript enforcement where applicable

3. Rebase on latest main if needed:
   ```bash
   git fetch origin
   git rebase origin/main
   ```

### PR Requirements

- Clear title following commit conventions
- Description explaining:
  - What changes were made
  - Why the changes improve AI code generation
  - Any tradeoffs or considerations
- All CI checks passing

### Review Checklist

Reviewers will check:

- [ ] Standards are clear and actionable
- [ ] Examples demonstrate the rule effectively
- [ ] No contradictions with existing standards
- [ ] Validation rules have correct patterns
- [ ] Documentation is well-formatted

## Questions?

If you have questions about contributing:

1. Check existing documentation in `.kiro/`
2. Open an issue for discussion
3. Reach out to the maintainers
