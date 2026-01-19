# ADR-0003: Manifest-Based Template Sync

**Date**: 2025-01
**Status**: Accepted

## Context

The organization uses a three-tier architecture for AI rules:
1. **ai-rules** - Centralized standards repository
2. **Templates** (backend-template, frontend-template) - Stack-specific starters
3. **Projects** - Applications created from templates

Templates sync standards from ai-rules via GitHub Actions. However, not all standards apply to all templates:
- Backend doesn't need Next.js/React standards
- Frontend doesn't need Prisma/Express standards

Initial approach used hardcoded exclusions in each template's workflow, but this:
- Duplicates logic across templates
- Requires workflow changes when adding new standards
- Lacks visibility into what's synced where

## Decision

Use a manifest file in ai-rules that defines sync behavior per template type.

### Manifest Structure

```yaml
# ai-rules/.kiro/sync-manifest.yml

templates:
  backend:
    description: "Node.js + Express + Prisma backend projects"
    exclude:
      - standards/libraries/nextjs.md
      - standards/libraries/react.md
      - steering/nextjs-standards.md

  frontend:
    description: "Next.js + React frontend projects"
    exclude:
      - standards/libraries/prisma.md
      - standards/libraries/express.md
      - steering/prisma-standards.md
```

### Sync Workflow Logic

```bash
# 1. Read manifest from ai-rules
MANIFEST="ai-rules/.kiro/sync-manifest.yml"

# 2. Get exclusions for this template type
EXCLUSIONS=$(yq ".templates.$TEMPLATE_TYPE.exclude[]" "$MANIFEST")

# 3. Sync all files
cp -r ai-rules/.kiro/standards .kiro/
cp -r ai-rules/.kiro/steering .kiro/
# ...

# 4. Remove excluded files
for exclusion in $EXCLUSIONS; do
  rm -f ".kiro/$exclusion"
done
```

### Adding New Rules Workflow

1. **Create standard** in ai-rules (e.g., `.kiro/standards/libraries/express.md`)
2. **Create steering file** (optional, e.g., `.kiro/steering/express-standards.md`)
3. **Update manifest** to exclude from irrelevant templates
4. **Commit and push** to ai-rules
5. **Sync workflows run** and create PRs in affected templates

### Visual Flow

```
ai-rules (edit here)
    │
    │ 1. Add new standard
    │ 2. Update manifest
    │ 3. Push to main
    │
    ▼
┌─────────────────────────────────────────────────┐
│           Weekly sync workflows run             │
│                                                 │
│  Each template:                                 │
│  1. Clones ai-rules                             │
│  2. Reads sync-manifest.yml                     │
│  3. Copies all .kiro/ content                   │
│  4. Removes files listed in exclude             │
│  5. Creates PR if changes detected              │
└─────────────────────────────────────────────────┘
    │                               │
    ▼                               ▼
backend-template                frontend-template
(excludes frontend files)       (excludes backend files)
```

## Alternatives Considered

### Directory-Based Categorization

```
ai-rules/.kiro/standards/libraries/
├── shared/
│   └── zod.md
├── backend/
│   └── prisma.md
└── frontend/
    └── nextjs.md
```

**Rejected because:**
- Requires restructuring existing files
- File can only belong to one category
- Harder to refactor (moving files breaks references)
- Need matching structure in steering files

## Consequences

**Positive:**
- Single source of truth for sync behavior
- Self-documenting (manifest shows what goes where)
- Easy to add new templates (add section to manifest)
- Flexible (same file can have different rules per template)
- No changes needed to ai-rules file structure
- Templates only need to know their type, not exclusion details

**Negative:**
- Two-step process to add template-specific rules (file + manifest)
- Requires `yq` tool in workflow runners (available by default on GitHub Actions)
- Manifest must stay in sync with actual files

## References

- `ADR-0002` - Centralized AI Rules Architecture
- `.kiro/sync-manifest.yml` - The manifest file
- `.github/workflows/sync-from-ai-rules.yml` - Template sync workflows
