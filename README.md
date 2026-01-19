# AI Rules

Centralized AI coding standards for the organization. This repository is the **single source of truth** for all AI-assisted code generation rules used by Claude (Claude Code, Cursor, Claude.ai) and Kiro IDE.

## Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           ai-rules (this repo)                              │
│                         ══════════════════════                              │
│  Single source of truth for all AI coding standards                         │
│                                                                             │
│  .kiro/                                                                     │
│  ├── standards/           ← Coding standards by category                    │
│  ├── steering/            ← Kiro steering files                             │
│  ├── validation/          ← Machine-readable rules                          │
│  ├── memory/              ← ADRs, glossary                                  │
│  └── templates/           ← Spec templates                                  │
│  CLAUDE.{backend,frontend}.md  ← Template-specific Claude entry points      │
│  CLAUDE.global.md         ← Org-wide Claude Code settings                   │
│  CHANGELOG.md             ← Track rule changes                              │
└─────────────────────────────────────────────────────────────────────────────┘
                                     │
                                     │ sync-from-ai-rules.yml
                                     │ (daily at 6am UTC-6)
                    ┌────────────────┴────────────────┐
                    ▼                                 ▼
┌───────────────────────────────────┐ ┌───────────────────────────────────┐
│       backend-template            │ │       frontend-template           │
│  .kiro/        ← synced           │ │  .kiro/        ← synced           │
│  src/          ← starter code     │ │  src/          ← starter code     │
│  CLAUDE.md     ← from ai-rules    │ │  CLAUDE.md     ← from ai-rules    │
└───────────────────────────────────┘ └───────────────────────────────────┘
                    │                                 │
                    │ gh repo create --template       │
                    ▼                                 ▼
          ┌─────────────────┐               ┌─────────────────┐
          │ backend projects│               │frontend projects│
          └─────────────────┘               └─────────────────┘
```

## Quick Start

### Creating a New Project

Always use GitHub's template feature:

```bash
# Backend project
gh repo create org/my-api --template palpito-hunch/backend-template --private --clone

# Frontend project
gh repo create org/my-app --template palpito-hunch/frontend-template --private --clone
```

**Never clone templates directly** - this loses template attribution and carries git history.

### Updating Rules

1. Make changes in this repository (ai-rules)
2. Create a PR and merge to main
3. Sync workflows in templates/projects will create PRs automatically

### Installing Global Claude Code Settings

For org-wide Claude Code behavior (applies to all repos):

```bash
# Clone ai-rules (if you haven't already)
git clone https://github.com/palpito-hunch/ai-rules.git ~/ai-rules

# Run the install script
~/ai-rules/scripts/install.sh
```

This creates a symlink from `~/.claude/CLAUDE.md` to `CLAUDE.global.md`, so:
- All Claude Code sessions use org-wide settings
- Updates propagate automatically when you `git pull`

## What's Included

### Standards (`.kiro/standards/`)

| Category | Files | Description |
|----------|-------|-------------|
| Core | `priority-framework.md`, `ai-behavior.md`, `when-not-to-apply.md` | Universal rules for all projects |
| TypeScript | `style.md`, `architecture.md` | Language-specific standards |
| Libraries | `prisma.md`, `nextjs.md`, `zod.md`, etc. | Library-specific patterns |
| Domain | `errors.md`, `testing-mocks.md` | Domain modeling standards |

### Claude Files

| File | Purpose | Destination |
|------|---------|-------------|
| `CLAUDE.global.md` | Org-wide settings for all repos | `~/.claude/CLAUDE.md` (via install script) |
| `CLAUDE.backend.md` | Backend project rules | Synced as `CLAUDE.md` to backend projects |
| `CLAUDE.frontend.md` | Frontend project rules | Synced as `CLAUDE.md` to frontend projects |

### Validation Rules (`.kiro/validation/`)

Machine-readable patterns in `rules.yml` for AI code validation:
- **Critical**: Transaction requirements, floating promises
- **High**: N+1 queries, explicit return types
- **Medium**: Console logging, pagination

### Project Memory (`.kiro/memory/`)

- **ADRs**: Architecture Decision Records in `decisions/`
- **Glossary**: Domain terminology in `glossary.yml`

## Sync Flow

```
Developer updates        Automated sync           Team reviews
rules in ai-rules       workflows run            and merges PRs
      │                       │                        │
      ▼                       ▼                        ▼
 ┌─────────┐   merged    ┌──────────┐   creates   ┌──────────┐
 │ ai-rules│ ───────────▶│  GitHub  │ ───────────▶│   PRs    │
 │         │   to main   │ Actions  │             │ in each  │
 └─────────┘             └──────────┘             │   repo   │
                               │                  └──────────┘
               ┌───────────────┼───────────────┐
               ▼               ▼               ▼
         backend-       frontend-        existing
         template       template         projects
```

### What Gets Synced

| Source (ai-rules) | Destination | Behavior |
|-------------------|-------------|----------|
| `.kiro/standards/**` | `.kiro/standards/**` | Overwrite |
| `.kiro/steering/**` | `.kiro/steering/**` | Overwrite |
| `.kiro/validation/**` | `.kiro/validation/**` | Overwrite |
| `.kiro/templates/**` | `.kiro/templates/**` | Overwrite |
| `CLAUDE.{type}.md` | `CLAUDE.md` | Template-specific |

**Not synced**: `src/`, `package.json`, project-specific files

## Override Hierarchy

1. Explicit user instruction in prompt (highest)
2. Project-level overrides (`.kiro/steering/overrides.md`)
3. Org rules from ai-rules (`.kiro/standards/**`)
4. Language/framework defaults (lowest)

## Semantic Versioning

This repository uses semantic-release for automated versioning.

| Commit Type | Version Bump | Example |
|-------------|--------------|---------|
| `feat:` | Minor (1.x.0) | New rule added |
| `fix:` | Patch (1.0.x) | Rule clarification |
| `BREAKING CHANGE:` | Major (x.0.0) | Breaking rule change |
| `docs:`, `chore:` | No release | Documentation only |

## Available Scripts

| Script | Description |
|--------|-------------|
| `npm run format` | Format markdown/yaml with Prettier |
| `npm run format:check` | Check formatting |
| `npm run release` | Run semantic-release |
| `npm run release:dry-run` | Preview next release |

## Related Repositories

- [backend-template](https://github.com/palpito-hunch/backend-template) - Node.js/Express backend starter
- [frontend-template](https://github.com/palpito-hunch/frontend-template) - React/Next.js frontend starter

## Architecture Decision Records

See `.kiro/memory/decisions/` for ADRs documenting key architectural decisions:

- **ADR-0001**: Semantic versioning strategy
- **ADR-0002**: Centralized AI rules architecture (this document reflects)
- **ADR-0003**: Prioritization framework for coding standards
- **ADR-0004**: Centralized rules for distributed teams

## License

MIT
