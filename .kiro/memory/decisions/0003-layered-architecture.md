# ADR-0003: Layered Architecture

**Date**: 2024-01
**Status**: Accepted

## Context

Need a consistent architecture pattern that:
- Separates concerns
- Makes code testable
- Scales with team size
- Is easy to understand

## Decision

Use layered architecture: Controllers → Services → Repositories → Types

## Consequences

**Positive:**
- Clear separation of concerns
- Each layer is independently testable
- Easy to understand and onboard new developers
- Consistent patterns across features

**Negative:**
- More files/boilerplate for simple features
- May be overkill for very small projects

## References

- `standards/typescript/architecture.md`
