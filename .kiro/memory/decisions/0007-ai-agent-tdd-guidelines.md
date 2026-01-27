# ADR-0007: AI Agent Guidelines for TDD

**Date**: 2025-01
**Status**: Accepted

## Context

ADR-0006 established TDD workflow standards for the organization. During implementation, we observed that AI agents (Claude Code, Cursor, etc.) exhibit specific behavioral patterns that undermine TDD effectiveness:

### Observed AI Agent Tendencies

1. **Over-implementation in GREEN phase** — AI agents trained on "complete" code tend to add error handling, edge cases, and abstractions before tests require them. This defeats TDD's incremental design benefit.

2. **Test batching** — AI agents batch multiple test cases together before implementing, leading to batch implementations that skip the design feedback loop.

3. **Scope creep in REFACTOR** — AI agents expand refactor scope to "improve" adjacent code, introducing untested changes.

4. **Skipping RED verification** — AI agents assume tests will fail rather than confirming actual failure output, missing opportunities to catch incorrect tests.

5. **Gaming tests** — AI agents may write implementation that technically passes the test but misses the intent (e.g., returning hardcoded values).

6. **Context accumulation** — Long TDD sessions accumulate context, making it harder for agents to track what's tested vs. implemented.

### Why Standard TDD Instructions Are Insufficient

Generic TDD instructions ("write test first, then implement") don't address these AI-specific failure modes. The agent follows the letter of TDD while violating its spirit through over-implementation, batching, and scope creep.

### Alternative Considered: No Special Guidelines

We considered relying on the base TDD workflow without AI-specific additions.

**Rejected because:**
- Observed failures persisted despite correct TDD task ordering
- AI agents need explicit constraints (not just principles) to override training patterns
- Feedback loop efficiency matters more for AI agents (tool call overhead)

## Decision

Add a dedicated "AI Agent Guidelines" section to the TDD workflow standards with explicit constraints addressing each failure mode:

| Failure Mode | Guideline |
|--------------|-----------|
| Over-implementation | Minimality constraint with ~20 line self-check |
| Test batching | One-test-at-a-time rule with explicit task structure |
| Scope creep in REFACTOR | Scope lock with allowed/disallowed table |
| Skipping RED verification | Verification checkpoint requiring actual output |
| Gaming tests | Post-GREEN self-check: "Would this work for ANY valid input?" |
| Context accumulation | Context management triggers at 5-cycle intervals |

### Additional Guidelines

- **Fast feedback configuration** — Target < 2 second RED/GREEN cycles to minimize tool call overhead
- **AI-specific anti-patterns table** — Reference for common failure modes with mitigations
- **Prompt patterns** — Explicit TDD language for instructing agents

## Consequences

**Positive:**
- Explicit constraints override AI training patterns
- Measurable targets (20 lines, 2 seconds) provide clear boundaries
- Anti-patterns table serves as quick reference during development
- Prompt patterns improve human-AI TDD collaboration

**Negative:**
- Additional documentation to maintain
- Guidelines may need updates as AI agent capabilities evolve
- May feel prescriptive to experienced TDD practitioners

**Neutral:**
- Guidelines are additive to base TDD workflow, not replacement
- Same principles apply to human developers who exhibit similar patterns

## References

- ADR-0006: TDD Workflow Standards
- `.kiro/standards/workflows/tdd-workflow.md` — Implementation location
