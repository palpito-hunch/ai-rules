# Kiro AI Rules

AI code generation rules and standards for Kiro-driven development. This repository provides a comprehensive set of standards, templates, and configurations to guide AI code generation tools.

## What's Included

```
├── .kiro/                      # AI rules and standards
│   ├── standards/              # Coding standards by category
│   │   ├── core/               # Priority framework and core principles
│   │   ├── typescript/         # TypeScript style and architecture
│   │   ├── libraries/          # Library-specific standards (Prisma, Next.js, Zod)
│   │   └── domain/             # Domain modeling and error handling
│   ├── templates/              # Spec templates for features and components
│   ├── specs/                  # Feature and component specifications
│   ├── memory/                 # Project memory (ADRs, glossary)
│   ├── validation/             # AI code validation rules
│   └── docs/                   # Documentation and guides
├── .mcp.json                   # MCP server configuration
├── tsconfig.json               # Reference TypeScript config
├── eslint.config.mjs           # Reference ESLint config
└── package.json                # Tooling dependencies
```

## Quick Start

### Option 1: Use as Template

1. Click "Use this template" to create a new repository
2. Clone your new repository
3. Install dependencies: `npm install`
4. Start building with AI-assisted development

### Option 2: Copy into Existing Project

Copy the `.kiro/` directory into your project root:

```bash
# Clone this repo
git clone https://github.com/palpito-hunch/kiro-project-template.git kiro-rules

# Copy .kiro to your project
cp -r kiro-rules/.kiro /path/to/your/project/

# Optionally copy reference configs
cp kiro-rules/tsconfig.json /path/to/your/project/tsconfig.reference.json
cp kiro-rules/eslint.config.mjs /path/to/your/project/eslint.reference.mjs
```

## Standards Overview

### Core Standards

- **Priority Framework** (`.kiro/standards/core/priority-framework.md`) - P0 (security), P1 (correctness), P2 (maintainability), P3 (efficiency)
- **AI Behavior Guidelines** (`.kiro/standards/core/ai-behavior.md`) - How AI should interact with the codebase

### TypeScript Standards

- **Style Guide** (`.kiro/standards/typescript/style.md`) - Code style rules with ESLint enforcement
- **Architecture** (`.kiro/standards/typescript/architecture.md`) - Layered architecture patterns

### Library Standards

- **Prisma** (`.kiro/standards/libraries/prisma.md`) - Database operations, transactions, query optimization
- **Next.js** (`.kiro/standards/libraries/nextjs.md`) - App Router, Server/Client Components, API Routes
- **Zod** (`.kiro/standards/libraries/zod.md`) - Schema validation and type inference

## MCP Integration

The `.mcp.json` file configures Model Context Protocol servers for enhanced AI capabilities:

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"]
    }
  }
}
```

**Context7** fetches up-to-date library documentation, ensuring AI has access to current APIs.

## Reference Configurations

### TypeScript (`tsconfig.json`)

A reference configuration demonstrating recommended settings:

- Strict type checking (`strict: true`, `noUncheckedIndexedAccess`)
- Path aliases (`@/*`, `@components/*`, etc.)
- Modern module resolution (`bundler`)

### ESLint (`eslint.config.mjs`)

A reference configuration with:

- TypeScript-ESLint recommended rules
- Explicit return type enforcement
- No floating promises
- Error class requirements

To add React/Next.js support, see the commented section at the bottom of the file.

## Validation Rules

The `.kiro/validation/rules.yml` file defines patterns for AI code validation:

- **Critical**: Transaction requirements, floating promises, error throwing
- **High**: N+1 queries, explicit return types, Zod validation
- **Medium**: Console logging, field selection, pagination

## Templates

### Feature Spec Template

`.kiro/templates/feature-spec.md` provides a structured template for feature specifications:

- Intent and user stories
- Behavior scenarios (Given/When/Then)
- Technical approach
- Constraints and acceptance criteria

## Project Memory

### Architecture Decision Records

`.kiro/memory/decisions.md` tracks architectural decisions using ADR format.

### Domain Glossary

`.kiro/memory/glossary.yml` defines domain terminology for consistent naming.

## Available Scripts

| Script | Description |
|--------|-------------|
| `npm run lint` | Check code for linting errors |
| `npm run lint:fix` | Auto-fix linting errors |
| `npm run format` | Format code with Prettier |
| `npm run format:check` | Check code formatting |
| `npm run type-check` | Run TypeScript type checking |
| `npm run validate` | Run lint and format check |

## Semantic Versioning

This project uses [semantic-release](https://semantic-release.gitbook.io/) for automated versioning.

### Branch Release Strategy

| Branch | Tag Format | Example | Purpose |
|--------|------------|---------|---------|
| `develop` | `x.y.z-a.N` | `1.2.0-a.1` | Alpha releases for dev testing |
| `uat` | `x.y.z-rc.N` | `1.2.0-rc.1` | Release candidates for QA |
| `main` | `x.y.z` | `1.2.0` | Production releases |

### Version Bump Rules

| Commit Type | Version Bump | Example |
|-------------|--------------|---------|
| `feat:` | Minor (1.x.0) | New feature |
| `fix:` | Patch (1.0.x) | Bug fix |
| `BREAKING CHANGE:` | Major (x.0.0) | Breaking change |
| `docs:`, `chore:` | No release | Documentation, maintenance |

## Syncing Standards

Repositories created from this template can sync updates via the `sync-from-template.yml` workflow:

1. Runs weekly (Mondays at 9am UTC) or on-demand
2. Fetches latest `.kiro/` from this template
3. Creates a PR if changes are detected

### Manual Sync

**Actions** → **Sync Standards from Template** → **Run workflow**

## Related Templates

- **Backend Template**: Coming soon - Node.js/Express backend with these AI rules
- **Frontend Template**: Coming soon - React/Next.js frontend with these AI rules

## License

MIT

## Acknowledgments

- Built with [Kiro](https://kiro.directory) best practices
- MCP integration via [Context7](https://context7.com)
