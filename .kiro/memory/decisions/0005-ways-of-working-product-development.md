# ADR-0005: Ways of Working for Product Development

**Date**: 2025-01

**Status**: Accepted

## Context

The organization uses AI agents (Claude Code, Cursor, etc.) extensively for software development. Three key problems emerged:

1. **Visibility gap** - When AI agents worked on code, team members had no real-time visibility into work-in-progress status. Agents would complete tasks without updating any tracking system.

2. **Drift between specs and tracking** - Linear issues drifted from specification files over time. Requirements changed in spec files but Linear remained outdated, or vice versa.

3. **Inconsistent workflows** - Different agents and developers used different processes for updating Linear, leading to unreliable status information and incomplete documentation.

The organization needed a standardized way for AI agents to interact with Linear that would:
- Provide real-time visibility into agent work
- Maintain alignment between specs and Linear
- Enforce consistent workflows across all agents

### Alternative Considered: Manual Linear Updates

The primary alternative was having developers manually update Linear status rather than having AI agents do it automatically.

**Rejected because:**
- Adds friction to the development workflow
- Developers forget to update status when focused on code
- No real-time visibility during AI agent coding sessions (agents code autonomously)
- Status updates lag behind actual progress
- Comments and documentation are often skipped under time pressure

## Decision

Adopt a standardized product development workflow with six phases, executed in order:

| Phase | Name | Owner | Purpose |
|-------|------|-------|---------|
| 0 | Product Brief Creation | PM | Define what needs to be built |
| 1 | Product Brief → Projects | PM + AI | Break down into sprint-sized Linear projects |
| 2 | Spec Creation / Feature Refinement | PM + Engineering | Create detailed specifications collaboratively |
| 3 | Spec-to-Project | AI | Populate Linear with issues from specs |
| 4 | Task Development | AI | Develop tasks with status tracking |
| 5 | Feature Verification | PM + Engineering | Verify feature against requirements |
| 6 | Release Tracking | Engineering | Track through deployment pipeline |

**Key Concept**: Problem → Product Brief → Linear Projects → Specs → Issues → Development → Verification → Release

**Workflow Details**: See [Product Development Workflow](../../standards/workflows/product-development-workflow.md) for complete phase descriptions, processes, and rules.

### Source of Truth Model

| Aspect | Authoritative Source |
|--------|---------------------|
| Requirements (what must be true) | `requirements.md` |
| Design (how correctness is achieved) | `design.md` |
| Work breakdown (tasks to execute) | `tasks.md` |
| Execution status | Linear |
| Time tracking / estimates | Linear |
| Development comments / discussions | Linear |

**Principle:** Spec files define WHAT needs to be done. Linear tracks HOW execution is progressing.

### Constraints

1. **Linear team setup required** - Valid Linear team, statuses, and labels must exist before agents can interact with Linear.

2. **Single agent at a time** - Only one agent should work on a task at a time to avoid status update conflicts.

3. **Issues require spec files** - Linear projects can be created without spec files, but Linear issues within projects should only be created once spec files are ready.

### Enforcement

These workflows are enforced through normative rule files in `.kiro/standards/core/`:

```
.kiro/standards/core/
├── linear-mcp-rules.md                 # Overview and quick reference
├── linear-mcp-product-to-projects.md   # Product brief → projects
├── linear-mcp-spec-to-project.md       # Spec files → issues
└── linear-mcp-task-development.md      # Task development workflow rules
```

## Consequences

**Positive:**
- Real-time visibility into AI agent work-in-progress
- Consistent status tracking across all agents and developers
- Clear audit trail through Linear comments (implementation + testing)
- Spec files and Linear stay aligned through explicit workflows
- Failed tests prevent premature completion (quality gate)
- Version control commits are mandatory and documented
- Project status accurately reflects development progress

**Negative:**
- Additional MCP calls add latency to development workflow
- Agents must have Linear MCP properly configured
- More complex agent instructions (four-phase workflow)
- Requires discipline to maintain spec files as source of truth
- Single-agent constraint may slow parallel work

**Neutral:**
- Linear MCP tooling may evolve, requiring rule updates
- Other project management tools could be integrated similarly in the future

## References

- `.kiro/standards/workflows/product-development-workflow.md` - Complete workflow documentation
- `.kiro/standards/core/linear-mcp-rules.md` - Overview and quick reference
- `.kiro/standards/core/linear-mcp-product-to-projects.md` - Product brief → projects workflow
- `.kiro/standards/core/linear-mcp-spec-to-project.md` - Spec-to-project workflow
- `.kiro/standards/core/linear-mcp-task-development.md` - Task development workflow
- `CLAUDE.global.md` - Global settings referencing Linear MCP integration
