# ADR-0006: TDD Workflow Standards

**Date**: 2025-01
**Status**: Accepted

## Context

AI-assisted code generation benefits from structured workflows that ensure quality and consistency. Without explicit TDD guidance:

- AI agents write tests after implementation, missing the design benefits of TDD
- Test coverage gaps occur when agents skip the RED phase verification
- Regressions go unnoticed when agents only run single tests instead of full test suites
- Scaffold prerequisites (test setup, factories, error classes) are often forgotten
- Task ordering is inconsistent, leading to implementation before tests exist

Additionally, when configuring linting and TypeScript together:

- Rules from ESLint and TypeScript compiler can conflict (e.g., both enforcing unused variable checks)
- Agents spend time debugging tooling conflicts instead of writing code
- Inconsistent rule ownership leads to duplicate or contradictory enforcement

## Decision

Add a comprehensive TDD workflow standard to the ai-rules repository that:

1. **Defines the RED → GREEN → REFACTOR cycle** with explicit verification steps
2. **Establishes task ordering rules** — tests always come before implementations
3. **Specifies scaffold prerequisites** — test framework, coverage thresholds, error classes, factories
4. **Provides TypeScript/ESLint conflict resolution** — clear ownership of which tool enforces which rules
5. **Documents anti-patterns** — common mistakes AI agents should avoid

### TypeScript vs ESLint Rule Ownership

The standard establishes that **TypeScript takes precedence** for type-related enforcement:

| Tool | Responsibility |
|------|----------------|
| TypeScript | Type checking, unused variables, implicit any, null checks, unreachable code |
| ESLint | Code style, complexity limits, naming conventions, import ordering, framework rules |

When both tools can enforce the same rule, prefer TypeScript because:
- Errors are caught at compile time
- Better IDE integration
- Single source of truth for type-related issues

## Consequences

**Positive:**
- Consistent TDD practices across all projects
- AI agents follow predictable test-first workflows
- Reduced debugging time from tooling conflicts
- Clear verification steps at each phase (RED, GREEN, REFACTOR)
- Scaffold checklist prevents missing prerequisites
- Regression handling protocol preserves code quality

**Negative:**
- More prescriptive workflow may feel rigid for some use cases
- Teams preferring ESLint's granular unused variable config must explicitly opt out of TypeScript's
- Additional documentation to maintain

## References

- `.kiro/standards/workflows/tdd-workflow.md` - The TDD workflow standard
- `.kiro/standards/core/` - Core standards that complement TDD workflow
- `.kiro/standards/typescript/` - TypeScript-specific standards
