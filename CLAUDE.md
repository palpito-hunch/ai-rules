# Project Standards for AI Development

This project uses comprehensive AI-driven development standards. Follow these guidelines for all code changes.

## Quick Start

Before making changes, read `.kiro/standards/quick-reference.md` for the one-page reference card.

## Priority Hierarchy (P0 > P1 > P2 > P3)

When standards conflict, higher priority wins:

- **P0 (Critical):** Financial safety, Type safety
- **P1 (High):** SOLID principles, DRY
- **P2 (Medium):** Performance (measure first, then optimize)
- **P3 (Low):** Code brevity

Full decision framework: `.kiro/standards/core/priority-framework.md`

## Core Standards

| Standard          | File                                        | When to Read               |
| ----------------- | ------------------------------------------- | -------------------------- |
| Coding Standards  | `.kiro/standards/core/coding-standards.md`  | Always                     |
| When NOT to Apply | `.kiro/standards/core/when-not-to-apply.md` | Before adding abstractions |

## Domain-Specific Standards

| Domain            | File                                          | When to Read                              |
| ----------------- | --------------------------------------------- | ----------------------------------------- |
| Error Handling    | `.kiro/standards/domain/errors.md`            | Working on services, APIs, error handling |
| File Organization | `.kiro/standards/domain/file-organization.md` | Creating new files, refactoring structure |
| Comments          | `.kiro/standards/domain/comments.md`          | Adding documentation                      |
| Performance       | `.kiro/standards/domain/performance.md`       | Optimization work                         |

## Red Flags (Auto-Reject Patterns)

Never introduce these patterns:

- Prisma operations outside transactions (when multiple writes)
- `reduce()` without initial value
- Generic `Error` class instead of specific error types
- N+1 query patterns
- Missing return type annotations on public functions

## Key Principles

1. **Default to safety** - More validations, more transactions, explicit error handling
2. **Fail explicitly** - Descriptive errors with context, never silent failures
3. **One pattern at a time** - Don't combine patterns unnecessarily
4. **Measure before optimizing** - No premature optimization

## Project Stack

- React + TypeScript
- Node.js
- Tailwind CSS

See `.kiro/steering.yml` for full configuration.

## Conventions

- **Files:** kebab-case (`user-service.ts`)
- **Components:** PascalCase (`UserProfile.tsx`)
- **Functions/Variables:** camelCase
- **Constants:** UPPER_SNAKE_CASE
- **Commits:** Conventional commits format

See `.kiro/conventions.yml` for full naming rules.

## Template Sync

This project was created from a template repository. Standards are kept in sync automatically.

### How It Works

- `.github/workflows/sync-from-template.yml` runs weekly
- Fetches latest `.kiro/` and `CLAUDE.md` from the template
- Creates a PR if changes are detected

### For AI Assistants

When modifying `.kiro/` or `CLAUDE.md`:

- **In template repo:** Changes propagate to all downstream repos via PRs
- **In downstream repo:** Local changes may be overwritten by the next sync PR

If this repo needs custom standards that differ from the template, either:

1. Make changes in the template (preferred, benefits all repos)
2. Modify locally and reject future sync PRs for those files
3. Remove the sync workflow to fully decouple
