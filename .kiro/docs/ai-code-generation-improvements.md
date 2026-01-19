# AI Code Generation Improvements

## Overview

This document outlines recommendations for improving AI-generated code quality based on the existing `.kiro/standards/` structure, MCP (Model Context Protocol) servers, and Tessl's spec-driven development approach.

---

## 1. MCP Server Integration

MCP (Model Context Protocol) is an open standard that enables AI tools to connect to external data sources and tools. Adding MCP servers significantly enhances AI code generation capabilities.

### Recommended MCP Servers

| Server | Purpose | Benefit |
|--------|---------|---------|
| [Context7](https://github.com/upstash/context7) | Up-to-date library docs | Prevents hallucinated APIs, correct versions |
| [Claude Context](https://github.com/zilliztech/claude-context) | Semantic code search | AI finds relevant code across entire codebase |
| GitHub MCP | PR/issue context | AI understands project history and discussions |
| Postgres MCP | Database schema | AI generates correct queries for your schema |

### Configuration

MCP servers are configured in `.mcp.json` at the project root. See the implementation in this repository.

### References

- [Model Context Protocol - Anthropic](https://www.anthropic.com/news/model-context-protocol)
- [MCP Servers GitHub](https://github.com/modelcontextprotocol/servers)
- [Claude Code MCP Docs](https://code.claude.com/docs/en/mcp)

---

## 2. Spec-Driven Development (Tessl Approach)

Tessl's spec-driven development (SDD) captures intent in structured specifications before code generation. This ensures AI agents build with clarity and guardrails.

### Key Concepts

1. **Specs as Long-Term Memory**: Specifications live in the codebase and guide agents as the app evolves
2. **Intent Before Code**: AI creates structured specs before writing code
3. **Guardrails**: Specs pair with tests to enforce constraints

### Implementation

- Feature specs in `.kiro/specs/features/`
- Library specs in `.kiro/standards/libraries/`
- Component specs in `.kiro/specs/components/`

### References

- [Tessl - AI Native Development Platform](https://tessl.io/)
- [Tessl Spec-Driven Development](https://ainativedev.io/news/tessl-launches-spec-driven-framework-and-registry)
- [Tessl 2025 Year in Review](https://tessl.io/blog/a-year-in-review-from-vibe-coding-to-viable-code/)

---

## 3. Library-Specific Specs

Add specifications for commonly used libraries to prevent API hallucinations and ensure correct usage patterns.

### Implemented Specs

| Library | File | Purpose |
|---------|------|---------|
| Prisma | `standards/libraries/prisma.md` | Database operations, transactions, N+1 prevention |
| Next.js | `standards/libraries/nextjs.md` | App Router patterns, API routes, SSR/SSG |
| Zod | `standards/libraries/zod.md` | Schema validation, type inference |

### Benefits

- Prevents outdated API usage
- Enforces best practices per library
- Reduces hallucinated methods/properties

---

## 4. Project Memory

Persistent context that helps AI understand project history and domain concepts.

### Components

| File | Purpose |
|------|---------|
| `memory/decisions/` | Architecture Decision Records (ADRs) |
| `memory/glossary.yml` | Domain terminology and definitions |

### Benefits

- AI understands "why" behind architectural choices
- Consistent domain language across generated code
- Prevents contradictory implementations

---

## 5. Feature Spec Templates

Structured templates for defining features before implementation.

### Template Location

`.kiro/templates/feature-spec.md`

### Template Structure

1. **Intent**: What the feature accomplishes (the "why")
2. **Behavior**: Given/When/Then scenarios
3. **Constraints**: Standards and rules to follow
4. **Acceptance Criteria**: Definition of done
5. **Anti-patterns**: What to avoid

### Usage

Before implementing a new feature:
1. Copy the template
2. Fill in all sections
3. Review with team
4. AI uses spec as implementation guide

---

## 6. Validation Rules

Machine-readable rules that AI can check against during and after code generation.

### Configuration

`.kiro/validation/rules.yml`

### Rule Types

- **Pattern matching**: Required/forbidden code patterns
- **Conditional rules**: Rules that apply in specific contexts
- **Cross-file rules**: Consistency checks across files

---

## 7. Enhanced Hooks

Pre and post-generation hooks for quality gates.

### Pre-Generation

- Verify spec exists before implementation
- Check that test cases are defined

### Post-Generation

- Run linting and type checking
- Execute related tests
- Validate against standards

---

## 8. Implementation Priority

### Phase 1: Quick Wins

1. MCP server configuration
2. Library specs (Prisma, Next.js, Zod)
3. Feature spec template

### Phase 2: Foundation

4. Project memory (decisions, glossary)
5. Validation rules

### Phase 3: Automation

6. Enhanced pre/post hooks
7. CI/CD integration

---

## 9. Measuring Success

Track these metrics to validate improvements:

| Metric | Before | Target |
|--------|--------|--------|
| API hallucinations | Baseline | -80% |
| Code review iterations | Baseline | -50% |
| Standards violations | Baseline | -90% |
| Time to implementation | Baseline | -30% |

---

## 10. Maintenance

### Keeping Specs Updated

- Review library specs when upgrading dependencies
- Update glossary when domain concepts change
- Add new ADRs for significant decisions

### Versioning

- Specs should be versioned with the codebase
- Breaking changes to specs require team review
