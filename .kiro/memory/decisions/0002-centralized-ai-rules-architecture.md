# ADR-0002: Centralized AI Rules Architecture

**Date**: 2025-01
**Status**: Accepted

## Context

The organization needs consistent AI-assisted code generation across all projects. Both Claude (Claude Code, Cursor, Claude.ai) and Kiro IDE are used for development. Without centralized rules:
- Each project defines its own standards (inconsistency)
- AI tools generate code differently across projects
- Rule updates require manual changes to every project
- New projects start without established standards

## Decision

Adopt a three-tier architecture:

1. **ai-rules repository** (this repo) - Single source of truth for all AI coding standards
2. **Template repositories** (backend-template, frontend-template) - Stack-specific starter code that inherits rules
3. **Project repositories** - Actual applications created from templates, sync rules from ai-rules

## Architecture Diagram

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

## Sync Flow

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

## What Gets Synced

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

## Override Hierarchy

```
  1. Explicit user instruction in prompt     (highest priority)
  2. Project-level overrides (.kiro/steering/overrides.md)
  3. Org rules from ai-rules (.kiro/standards/**)
  4. Language/framework defaults             (lowest priority)
```

## Versioning Strategy

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

## Consequences

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

## References

- `CLAUDE.md` - Entry point for Claude tools
- `.kiro/steering/` - Kiro steering files
- `.github/workflows/sync-from-template.yml` - Sync workflow
