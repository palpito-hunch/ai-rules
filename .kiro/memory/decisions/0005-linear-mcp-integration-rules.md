# ADR-0005: Linear MCP Integration Rules

**Date**: 2025-01
**Status**: Accepted

## Context

The organization uses Linear for issue tracking and has integrated Linear's MCP server to enable AI agents to update issue statuses during development. The question is how strictly to enforce Linear status updates during agent task execution.

An initial proposal mandated:
- **ALL** task execution must update Linear status
- Agents must update to "In Progress" before writing any code
- Agents must update to "Done" immediately after completing code
- Violations constitute "incorrect agent behavior"

While well-intentioned, this absolutist approach creates brittleness in real-world scenarios.

### Problems with Strict Enforcement

1. **Assumes 1:1 task-to-issue mapping** - Not all work has a corresponding Linear issue. Quick fixes, exploratory work, and ad-hoc requests often bypass formal issue creation.

2. **No error handling** - If the MCP call fails (network issues, auth expiry, Linear outage), the agent has no guidance. Should it block all work? That's too disruptive.

3. **No escape hatch** - Urgent hotfixes shouldn't be blocked by ceremony. Production incidents need fast action, not status dance.

4. **False precision** - Marking something "In Progress" implies work is underway. But agents may read files, think, and not write code. Status changes should reflect meaningful state transitions.

5. **Over-broad scope** - "ALL task execution" captures trivial changes (typo fixes, formatting) that don't warrant tracking overhead.

## Decision

Adopt a **pragmatic Linear integration** approach that maintains workflow discipline while handling edge cases gracefully.

### Core Rules

1. **When a Linear issue exists for the work:**
   - Update status to "In Progress" before beginning implementation
   - Update status to "Done" after completing implementation
   - Verify status updates succeeded before proceeding

2. **When Linear MCP is unavailable:**
   - Note the intended status change in the commit message
   - Continue with the work (don't block on MCP failures)
   - Create/update the issue when MCP connectivity is restored

3. **When no Linear issue exists:**
   - For substantial work: Create an issue first, then follow rule 1
   - For trivial changes (typos, formatting, one-line fixes): Proceed without Linear tracking

4. **Error handling:**
   - Retry status updates once on transient failures
   - On persistent failure, log the intended action and continue
   - Never block development work due to Linear API issues

### What Constitutes "Substantial Work"

Work requires Linear tracking when:
- It implements a feature or user story
- It fixes a bug reported by users
- It takes more than a few minutes to complete
- It changes behavior observable to users
- It's part of a planned sprint or project

Work does NOT require Linear tracking when:
- It's a typo fix or formatting change
- It's exploratory (spiking, investigating)
- It's a one-line configuration change
- It's documentation-only (unless the docs are the deliverable)

## Implementation

### MCP Configuration

Add instructions to `.mcp.json`:

```json
"linear": {
  "command": "npx",
  "args": ["-y", "mcp-remote", "https://mcp.linear.app/mcp"],
  "description": "Access Linear issues, projects, and team workflows",
  "instructions": "Before starting substantial development work, update the corresponding Linear issue status to 'In Progress'. After completing work, update to 'Done'. If no issue exists for trivial changes, proceed without Linear tracking. On MCP failures, note the intended status in commit messages and continue."
}
```

### CLAUDE.md Section

Add to global or project `CLAUDE.md`:

```markdown
## Linear Integration

When working on tasks with a corresponding Linear issue:

1. **Starting work**: Update issue status to "In Progress" before coding
2. **Completing work**: Update issue status to "Done" after coding
3. **Verification**: Confirm status updates succeeded before proceeding

If Linear MCP is unavailable or no issue exists:
- Note it in the commit message (e.g., `[Linear unavailable]` or `[No issue]`)
- Continue with the work
- Create/update the issue when MCP is restored

### Exceptions

- Trivial fixes (typos, formatting) don't require Linear tracking
- Exploratory work doesn't require status updates
- Never block work due to Linear API failures
```

### Commit Message Convention

When Linear tracking is skipped:

```
fix(auth): correct token expiration check [No Linear issue]

One-line fix for off-by-one error in token validation.

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
```

When Linear is unavailable:

```
feat(dashboard): add export button [Linear unavailable - intended: PROJ-123 -> Done]

Implemented CSV export functionality for dashboard data.

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
```

## Consequences

**Positive:**
- Linear remains source of truth for planned work
- Agents maintain workflow discipline without fragility
- Failures degrade gracefully (work continues, tracking catches up)
- Commit messages provide audit trail when MCP fails
- Trivial work doesn't incur unnecessary overhead

**Negative:**
- Requires agent judgment on "substantial" vs "trivial" work
- Status may temporarily lag during MCP outages
- Some work may slip through without Linear tracking

**Mitigations:**
- Clear examples of what requires tracking reduce ambiguity
- Commit message conventions ensure traceability
- Periodic review of commits without Linear references catches gaps

## References

- Linear MCP documentation: https://linear.app/docs/mcp
- `.mcp.json` - MCP server configuration
- `CLAUDE.md` - Agent behavior rules
