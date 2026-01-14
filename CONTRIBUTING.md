# Contributing to Kiro Project Template

Thank you for your interest in contributing! This guide will help you get set up and understand our development workflow.

## Table of Contents

- [Development Setup](#development-setup)
- [Code Quality Tools](#code-quality-tools)
- [Git Workflow](#git-workflow)
- [Commit Conventions](#commit-conventions)
- [Pull Request Process](#pull-request-process)
- [CI/CD Pipeline](#cicd-pipeline)

## Development Setup

### Prerequisites

- Node.js 20+
- npm 9+
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/kiro-project-template.git
   cd kiro-project-template
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```
   This automatically sets up Husky git hooks via the `prepare` script.

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your values
   ```

4. **Verify setup**
   ```bash
   npm run validate
   ```
   This runs linting, type checking, and tests to ensure everything is working.

5. **Start development server**
   ```bash
   npm run dev
   ```

## Code Quality Tools

We use several tools to maintain code quality. These run automatically via git hooks, but you can also run them manually.

### ESLint

Lints TypeScript and React code for errors and best practices.

```bash
# Check for issues
npm run lint

# Auto-fix issues
npm run lint:fix
```

**Configuration:** `.eslintrc.json`

Includes rules for:
- TypeScript (`@typescript-eslint`)
- React and React Hooks
- Accessibility (`jsx-a11y`)
- Next.js best practices

### Prettier

Formats code for consistent style.

```bash
# Format all files
npm run format

# Check formatting (CI)
npm run format:check
```

**Configuration:** `.prettierrc`

### TypeScript

Type checks the codebase without emitting files.

```bash
npm run type-check
```

### Jest

Runs unit and integration tests.

```bash
# Run tests
npm test

# Run tests in watch mode
npm run test:watch

# Run tests with coverage (CI)
npm run test:ci
```

**Configuration:** `jest.config.js`

Coverage thresholds are set to 70% for branches, functions, lines, and statements.

### Run All Checks

```bash
npm run validate
```

This runs `lint`, `type-check`, and `test:ci` sequentially.

## Git Workflow

We follow a gitflow-inspired workflow.

### Branch Naming

Use the format: `type/description`

| Type | Purpose |
|------|---------|
| `feature/` | New features |
| `fix/` | Bug fixes |
| `docs/` | Documentation changes |
| `refactor/` | Code refactoring |
| `test/` | Adding or updating tests |
| `chore/` | Maintenance tasks |

**Examples:**
- `feature/user-authentication`
- `fix/login-redirect-loop`
- `docs/api-documentation`

### Workflow

1. Create a branch from `main` (or `develop` if using full gitflow)
   ```bash
   git checkout -b feature/my-feature
   ```

2. Make your changes with atomic commits

3. Push and create a pull request
   ```bash
   git push -u origin feature/my-feature
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

| Type | Description |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `style` | Formatting, missing semicolons, etc. |
| `refactor` | Code change that neither fixes a bug nor adds a feature |
| `perf` | Performance improvement |
| `test` | Adding or updating tests |
| `build` | Build system or external dependencies |
| `ci` | CI configuration |
| `chore` | Other changes that don't modify src or test files |
| `revert` | Reverts a previous commit |

### Examples

```bash
# Feature
git commit -m "feat(auth): add password reset functionality"

# Bug fix
git commit -m "fix(api): handle null response from user endpoint"

# Documentation
git commit -m "docs: update API documentation for v2 endpoints"

# Breaking change
git commit -m "feat(api)!: change authentication to use JWT tokens"
```

### Rules

- Type must be lowercase
- Subject must be lowercase
- No period at the end of subject
- Maximum header length: 100 characters

**Configuration:** `commitlint.config.js`

## Git Hooks

Git hooks run automatically to ensure code quality before commits and pushes.

### Pre-commit Hook

Runs lint-staged, which executes:
- ESLint (with auto-fix) on `.ts`, `.tsx`, `.js`, `.jsx` files
- Prettier on all staged files

**Configuration:** `.lintstagedrc.json`

### Commit-msg Hook

Validates commit messages against conventional commit format.

### Bypassing Hooks (Not Recommended)

In rare cases, you can bypass hooks:
```bash
git commit --no-verify -m "message"
```

Only do this for emergency fixes and ensure CI passes.

## Pull Request Process

### Before Submitting

1. Ensure all checks pass locally:
   ```bash
   npm run validate
   ```

2. Update documentation if needed

3. Add or update tests for your changes

4. Rebase on latest main if needed:
   ```bash
   git fetch origin
   git rebase origin/main
   ```

### PR Requirements

- Clear title following commit conventions
- Description explaining:
  - What changes were made
  - Why the changes were needed
  - How to test the changes
- Link to related issue (if applicable)
- All CI checks passing
- At least 2 approvals (see `.kiro/team-standards.yml`)

### Review Checklist

Reviewers will check:
- [ ] Code follows project conventions
- [ ] Tests are included and passing
- [ ] No console.log statements
- [ ] Documentation is updated
- [ ] Accessibility considerations addressed
- [ ] No security vulnerabilities introduced

## CI/CD Pipeline

Our GitHub Actions workflow runs on all PRs and pushes to `main`/`develop`.

### Jobs

| Job | Description |
|-----|-------------|
| **Lint** | ESLint + Prettier check |
| **Type Check** | TypeScript compilation check |
| **Test** | Jest tests with coverage |
| **Build** | Next.js production build |
| **Security** | npm audit for vulnerabilities |

### Viewing Results

- Check the "Checks" tab on your PR
- All jobs must pass before merging

### Running CI Locally

You can simulate CI locally:
```bash
npm run validate && npm run build
```

## Additional Resources

- [Project Standards](.kiro/standards/) - Detailed coding standards
- [Team Standards](.kiro/team-standards.yml) - Collaboration guidelines
- [Conventions](.kiro/conventions.yml) - Naming and style conventions
- [Quick Reference](.kiro/standards/quick-reference.md) - One-page developer guide

## Questions?

If you have questions about contributing, please:
1. Check existing documentation in `docs/` and `.kiro/`
2. Open an issue for discussion
3. Reach out to the maintainers
