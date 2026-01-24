# ADR-0005: Linear MCP Integration Rules

**Date**: 2025-01
**Status**: Draft

## Context

### Organizational Context

- **Fully distributed team** - No synchronous visibility into what others are working on
- **Small team** - Can't afford manual overhead or process ceremony
- **Spec-driven development** - Using Kiro IDE with specs (`tasks.md`, feature specs) that drive AI agent development
- **Heavy AI agent usage** - Agents do the majority of implementation work

### The Problem

With spec-driven development, work happens inside repositories:
1. Developer creates a spec in `.kiro/specs/`
2. AI agent works on tasks defined in the spec
3. Code gets written, commits happen, PRs get created
4. **Linear issues sit untouched** - no one updates them

This creates a visibility gap:
- Linear shows issues as "To Do" while work is actively happening
- Team members can't see what's in progress without checking each repo
- Work completes without Linear ever reflecting the state change
- Sprint planning and capacity tracking become unreliable

### The Goal

**Linear as the single source of truth** with 1:1 state management:
- Every planned task has a Linear issue
- Issue status reflects actual work state in real-time
- Automation handles updates, not humans remembering to update
- Distributed team has visibility without asking "what are you working on?"

### Original Proposal

An initial proposal mandated strict enforcement:
- ALL task execution must update Linear status
- Update to "In Progress" before writing any code
- Update to "Done" immediately after completing code
- Violations constitute "incorrect agent behavior"

### Concerns with Strict Enforcement

While the goal (1:1 sync) is correct, the original rules had implementation gaps:

1. **No error handling** - What happens when MCP fails? Block all work?
2. **Missing linking mechanism** - How do specs reference Linear issues?
3. **Unclear automation boundary** - Agent-driven vs GitHub Actions vs hooks?
4. **Status mapping undefined** - What Linear statuses map to what workflow states?

## Decision

**[PENDING - Requires resolution of open questions below]**

### Design Principles

1. **Linear is source of truth** - All planned work has a Linear issue
2. **1:1 state sync** - Repo state and Linear state stay synchronized
3. **Automation over memory** - Don't rely on humans/agents remembering
4. **Graceful degradation** - Failures are logged, not blocking

### Open Questions

#### 1. Issue Creation Flow

Who creates issues first?

| Option | Pros | Cons |
|--------|------|------|
| **Linear first** - Issues created in Linear, specs reference them | Linear is clearly source of truth | Requires discipline to create issues before specs |
| **Spec first** - Specs auto-create Linear issues | Lower friction for developers | Risk of orphaned issues, sync complexity |
| **Hybrid** - Major work in Linear, agents can create issues for discovered subtasks | Flexible | More complex rules |

#### 2. Linking Mechanism

How should specs reference Linear issues?

```markdown
<!-- Option A: Inline reference -->
## Task 1: Implement export [PROJ-123]

<!-- Option B: Frontmatter -->
---
linear: PROJ-123
---

<!-- Option C: Dedicated field -->
## Task 1: Implement export
- **Linear Issue**: PROJ-123
```

#### 3. Status Mapping

What Linear statuses map to workflow states?

| Workflow State | Linear Status | Trigger |
|----------------|---------------|---------|
| Spec created | ? | ? |
| Agent starts work | In Progress | Agent reads task from spec |
| Code committed | ? | git commit |
| PR created | In Review | `gh pr create` |
| PR merged | Done | PR merge |

#### 4. Automation Approach

Where should automation live?

| Approach | When to Use | Implementation |
|----------|-------------|----------------|
| **MCP calls from agents** | Real-time status during work | Agent rules in CLAUDE.md |
| **GitHub Actions** | PR lifecycle events | `.github/workflows/` |
| **Git hooks** | Commit-time validation | `.husky/` or similar |
| **Combination** | Full coverage | All of the above |

#### 5. Error Handling Strategy

When Linear MCP is unavailable:

| Option | Behavior |
|--------|----------|
| **Block** | Agent stops, waits for MCP | Ensures sync but blocks work |
| **Continue + Log** | Work proceeds, intended status logged | Work continues, may drift |
| **Continue + Retry** | Background retry with eventual consistency | Complex but resilient |

## Proposed Implementation

**[To be finalized after resolving open questions]**

### Phase 1: Agent-Driven Updates (MCP)

Agents update Linear status during task execution:
- Read spec → find linked Linear issue
- Update to "In Progress" before coding
- Update to "Done" after completing

### Phase 2: GitHub Actions (PR Lifecycle)

Automated status updates on PR events:
- PR opened → "In Review"
- PR merged → "Done"
- PR closed without merge → Back to "To Do"?

### Phase 3: Validation

Ensure specs and Linear stay linked:
- CI check: specs must reference valid Linear issues
- Weekly report: orphaned issues, stale specs

## Consequences

**Positive:**
- Distributed team has real-time visibility into work state
- No manual status updates required
- Linear becomes reliable for planning and tracking
- Audit trail of state changes

**Negative:**
- Upfront investment in automation infrastructure
- Specs must include Linear references (new requirement)
- Debugging sync issues requires understanding the full pipeline

**Risks:**
- Over-automation may create noise (too many status changes)
- MCP reliability becomes critical path
- Edge cases (multiple issues per spec, spec spans multiple PRs) need handling

## References

- Linear MCP documentation: https://linear.app/docs/mcp
- `.mcp.json` - MCP server configuration
- `CLAUDE.md` - Agent behavior rules
- `.kiro/specs/` - Spec-driven development location
