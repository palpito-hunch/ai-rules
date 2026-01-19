# Architecture Decision Records (ADRs)

This document captures significant architectural and technical decisions made in this project. Each decision includes context, the decision itself, and consequences.

---

## ADR-001: Use Next.js App Router

**Date**: 2024-01
**Status**: Accepted

### Context

Need a React framework that supports:
- Server-side rendering for SEO
- API routes for backend functionality
- Modern React patterns (Server Components)
- Good developer experience

### Decision

Use Next.js 14+ with App Router (not Pages Router).

### Consequences

**Positive:**
- Server Components reduce client bundle size
- Built-in API routes eliminate need for separate backend
- Excellent TypeScript support
- Streaming and Suspense support

**Negative:**
- Learning curve for Server vs Client Components
- Some libraries not yet compatible with App Router
- Different mental model from traditional React

### References

- `standards/libraries/nextjs.md`

---

## ADR-002: Use Prisma for Database Access

**Date**: 2024-01
**Status**: Accepted

### Context

Need an ORM/database client that provides:
- Type safety
- Migration management
- Good developer experience
- Support for common databases

### Decision

Use Prisma as the database ORM.

### Consequences

**Positive:**
- Full type safety with generated types
- Schema-first approach with migrations
- Excellent TypeScript integration
- Prisma Studio for data exploration

**Negative:**
- Slight performance overhead vs raw SQL
- Some complex queries harder to express
- Generated client increases bundle size

### References

- `standards/libraries/prisma.md`

---

## ADR-003: Layered Architecture

**Date**: 2024-01
**Status**: Accepted

### Context

Need a consistent architecture pattern that:
- Separates concerns
- Makes code testable
- Scales with team size
- Is easy to understand

### Decision

Use layered architecture: Controllers → Services → Repositories → Types

### Consequences

**Positive:**
- Clear separation of concerns
- Each layer is independently testable
- Easy to understand and onboard new developers
- Consistent patterns across features

**Negative:**
- More files/boilerplate for simple features
- May be overkill for very small projects

### References

- `standards/typescript/architecture.md`

---

## ADR-004: Zod for Runtime Validation

**Date**: 2024-01
**Status**: Accepted

### Context

Need runtime validation because:
- TypeScript types are erased at runtime
- API inputs need validation
- Form data needs validation
- Environment variables need validation

### Decision

Use Zod for all runtime validation and type inference.

### Consequences

**Positive:**
- Single source of truth for types and validation
- Excellent TypeScript integration with `z.infer`
- Rich validation API
- Good error messages

**Negative:**
- Another dependency to learn
- Some overlap with TypeScript types

### References

- `standards/libraries/zod.md`

---

## ADR-005: Strict TypeScript Configuration

**Date**: 2024-01
**Status**: Accepted

### Context

TypeScript strictness levels affect:
- Type safety
- Developer experience
- Code quality
- Refactoring confidence

### Decision

Enable all strict TypeScript options including:
- `strict: true`
- `noUncheckedIndexedAccess: true`
- `exactOptionalPropertyTypes: true`

### Consequences

**Positive:**
- Maximum type safety
- Catches more bugs at compile time
- Safer refactoring
- Better IDE support

**Negative:**
- More verbose code in some cases
- Steeper learning curve
- More type assertions needed

### References

- `tsconfig.json`
- `standards/typescript/style.md`

---

## ADR-006: ESLint with Type-Aware Rules

**Date**: 2024-01
**Status**: Accepted

### Context

Need linting that:
- Catches common errors
- Enforces coding standards
- Works with TypeScript types

### Decision

Use ESLint with `@typescript-eslint` plugin and type-aware rules enabled.

### Consequences

**Positive:**
- Catches floating promises
- Enforces explicit return types
- Prevents unsafe `any` usage
- Consistent code style

**Negative:**
- Slower linting (requires type information)
- More configuration complexity

### References

- `eslint.config.mjs`
- `standards/typescript/style.md`

---

## ADR-007: Semantic Versioning with Conventional Commits

**Date**: 2024-01
**Status**: Accepted

### Context

Need versioning strategy that:
- Automates version bumps
- Generates changelogs
- Follows industry standards

### Decision

Use semantic-release with conventional commits.

### Consequences

**Positive:**
- Automated version management
- Generated changelogs
- Consistent commit messages
- CI/CD integration

**Negative:**
- Requires commit message discipline
- Initial setup complexity

### References

- `.releaserc.json`
- `standards/domain/git-workflow.md`

---

## ADR-008: Centralized AI Rules Architecture

**Date**: 2025-01
**Status**: Accepted

### Context

The organization needs consistent AI-assisted code generation across all projects. Both Claude (Claude Code, Cursor, Claude.ai) and Kiro IDE are used for development. Without centralized rules:
- Each project defines its own standards (inconsistency)
- AI tools generate code differently across projects
- Rule updates require manual changes to every project
- New projects start without established standards

### Decision

Adopt a three-tier architecture:

1. **ai-rules repository** (this repo) - Single source of truth for all AI coding standards
2. **Template repositories** (backend-template, frontend-template) - Stack-specific starter code that inherits rules
3. **Project repositories** - Actual applications created from templates, sync rules from ai-rules

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           ai-rules (this repo)                              │
│                         ══════════════════════                              │
│  Single source of truth for all AI coding standards                         │
│                                                                             │
│  .kiro/                                                                     │
│  ├── standards/                                                             │
│  │   ├── core/                 ← Universal rules (all projects)             │
│  │   ├── typescript/           ← Shared language rules                      │
│  │   ├── libraries/            ← Library-specific (conditionally loaded)    │
│  │   │   ├── prisma.md              [backend]                               │
│  │   │   ├── express.md             [backend]                               │
│  │   │   ├── nextjs.md              [frontend]                              │
│  │   │   ├── react.md               [frontend]                              │
│  │   │   └── zod.md                 [shared]                                │
│  │   └── domain/               ← Domain rules (shared)                      │
│  ├── steering/                 ← Kiro steering files                        │
│  ├── validation/               ← Machine-readable rules                     │
│  └── memory/                   ← ADRs, glossary                             │
│  CLAUDE.md                     ← Entry point for Claude tools               │
│  CHANGELOG.md                  ← Track rule changes                         │
│                                                                             │
│  Versioned with semantic releases: v1.0.0, v1.1.0, v2.0.0                   │
└─────────────────────────────────────────────────────────────────────────────┘
                                     │
                                     │ sync-from-ai-rules.yml
                                     │ (weekly + manual trigger)
                    ┌────────────────┴────────────────┐
                    ▼                                 ▼
┌───────────────────────────────────┐ ┌───────────────────────────────────┐
│       backend-template            │ │       frontend-template           │
│       ════════════════            │ │       ═════════════════           │
│                                   │ │                                   │
│  .kiro/        ← synced from      │ │  .kiro/        ← synced from      │
│                  ai-rules         │ │                  ai-rules         │
│  src/          ← starter code     │ │  src/          ← starter code     │
│  package.json  ← stack deps       │ │  package.json  ← stack deps       │
│  CLAUDE.md     ← from ai-rules    │ │  CLAUDE.md     ← from ai-rules    │
│                                   │ │                                   │
└───────────────────────────────────┘ └───────────────────────────────────┘
                    │                                 │
                    │ "Use this template"             │ "Use this template"
                    ▼                                 ▼
          ┌─────────────────┐               ┌─────────────────┐
          │ backend projects│               │frontend projects│
          │ (user-service,  │               │ (web-app,       │
          │  order-service) │               │  admin-portal)  │
          └─────────────────┘               └─────────────────┘
                    │                                 │
                    └────────── sync-from-ai-rules.yml ───────┘
                               (projects sync directly)
```

### Sync Flow

```
  Developer updates               Automated sync              Team reviews
  rules in ai-rules              workflows run                and merges PRs
        │                              │                            │
        ▼                              ▼                            ▼
   ┌─────────┐    PR merged      ┌──────────┐    Creates     ┌──────────┐
   │ ai-rules│ ──────────────────│  GitHub  │ ───────────────│   PRs    │
   │  repo   │    to main        │ Actions  │     PRs        │ in each  │
   └─────────┘                   └──────────┘                │   repo   │
                                       │                     └──────────┘
                     ┌─────────────────┼─────────────────┐
                     ▼                 ▼                 ▼
               ┌──────────┐     ┌──────────┐     ┌──────────────┐
               │ backend- │     │ frontend-│     │   existing   │
               │ template │     │ template │     │   projects   │
               └──────────┘     └──────────┘     └──────────────┘
```

### What Gets Synced

```
ai-rules                          templates & projects
────────                          ────────────────────

.kiro/standards/**/*      ──────► .kiro/standards/**/*        (overwrite)
.kiro/steering/**/*       ──────► .kiro/steering/**/*         (overwrite)
.kiro/validation/**/*     ──────► .kiro/validation/**/*       (overwrite)
.kiro/memory/**/*         ──────► .kiro/memory/**/*           (overwrite)
.kiro/templates/**/*      ──────► .kiro/templates/**/*        (overwrite)
CLAUDE.md                 ──────► CLAUDE.md                   (overwrite)

                                  src/**/*                    (NOT synced)
                                  package.json                (NOT synced)
                                  project-specific files      (NOT synced)
```

### Override Hierarchy

```
  1. Explicit user instruction in prompt     (highest priority)
  2. Project-level overrides (.kiro/steering/overrides.md)
  3. Org rules from ai-rules (.kiro/standards/**)
  4. Language/framework defaults             (lowest priority)
```

### Versioning Strategy

```
ai-rules versions:

  v1.0.0 → v1.1.0 → v1.2.0 → v2.0.0
    │        │        │        │
    │        │        │        └── MAJOR: Breaking rule changes
    │        │        └── MINOR: New rules added (non-breaking)
    │        └── MINOR: Rule clarifications (non-breaking)
    └── Initial release

Project sync options:
  - Always latest: sync from main branch (default)
  - Pinned version: sync from specific tag (e.g., v1.x)
```

### Consequences

**Positive:**
- Single source of truth for all AI standards
- Consistent code generation across all projects
- Both Claude and Kiro follow same rules
- Automated propagation of rule updates
- New projects inherit all standards immediately
- Clear versioning for breaking changes

**Negative:**
- Requires discipline to update ai-rules, not individual projects
- Sync PRs need to be reviewed and merged
- Breaking rule changes affect all projects
- Additional workflow complexity

### References

- `CLAUDE.md` - Entry point for Claude tools
- `.kiro/steering/` - Kiro steering files
- `.github/workflows/sync-from-template.yml` - Sync workflow

---

## Template for New Decisions

```markdown
## ADR-XXX: [Title]

**Date**: YYYY-MM
**Status**: Proposed | Accepted | Deprecated | Superseded

### Context

[Why is this decision needed?]

### Decision

[What is the decision?]

### Consequences

**Positive:**
- [Benefit 1]
- [Benefit 2]

**Negative:**
- [Drawback 1]
- [Drawback 2]

### References

- [Related documents]
```
