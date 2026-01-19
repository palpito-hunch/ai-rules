# ADR-0001: Semantic Versioning with Conventional Commits

**Date**: 2024-01
**Status**: Accepted

## Context

Need versioning strategy that:
- Automates version bumps
- Generates changelogs
- Follows industry standards

## Decision

Use semantic-release with conventional commits.

## Consequences

**Positive:**
- Automated version management
- Generated changelogs
- Consistent commit messages
- CI/CD integration

**Negative:**
- Requires commit message discipline
- Initial setup complexity

## References

- `.releaserc.json`
- `standards/domain/git-workflow.md`
