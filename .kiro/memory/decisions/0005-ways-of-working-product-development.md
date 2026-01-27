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

**Key Concept**: Problem → Product Brief → Linear Projects → Specs → Issues → Development. One product brief may result in multiple projects. Each Linear Project = one feature in Kiro/GitHub/Claude.

### 0. Product Brief Creation (FOUNDATION)

For creating a well-defined product brief that describes what needs to be built.

**When to use:** When a product manager identifies a problem, requirement, or opportunity to address.

**Process:**
1. Product manager identifies a problem, requirement, or opportunity
2. PM drafts initial product brief describing the functionality
3. PM collaborates with AI to refine and improve the brief
4. PM curates extensively to ensure clarity and completeness
5. Final brief is reviewed and approved before proceeding

**Product Brief Requirements:**
- Clear problem statement or opportunity description
- Well-defined scope and objectives
- User stories or use cases
- Success criteria and acceptance criteria
- Constraints and dependencies
- Out-of-scope items explicitly stated

**Key Principles:**
- **AI-assisted, PM-curated**: AI helps draft and refine, but PM owns the final document
- **Depth over speed**: Take time to create a solid, well-defined brief
- **Clarity is paramount**: The brief must explain clearly what needs to be created
- **No ambiguity**: Vague requirements lead to rework; resolve unclear items before proceeding

**Quality Gate:** The product brief must be complete and approved before moving to Step 1 (breaking down into projects).

---

### 1. Product Brief → Projects Workflow

For breaking down a Product Brief into sprint-sized Linear projects.

**When to use:** After a product brief is created, as the first step before any development work.

**Process:**
1. Analyze the product brief to identify features
2. Break down into sprint-sized projects (1-2 weeks each)
3. Present projects for PM review and approval
4. Query Linear for valid teams and labels
5. Create projects after approval
6. Document manual follow-up (initiative linking, labels)

**Key MCP Tools:**
- `list_teams()` - Get valid team names/IDs
- `list_projects()` - Check for existing projects
- `list_project_labels()` - See existing project labels
- `create_project()` - Create new projects

**Project Creation Rules:**
- Names: Title Case, no emojis (use icons instead)
- Priority: 2 (High), 3 (Medium), 4 (Low) — never 1 (Urgent)
- Summaries: Required, 1-2 sentences
- Icons: Use shortcode format (`:lock:`, `:gear:`)
- State: Default to "backlog"
- Scope: Sprint-sized (1-2 weeks of work)

---

### 2. Spec Creation / Feature Refinement

For creating detailed specification files from the Linear project/feature definition. This is a collaborative refinement session—similar to a "super-charged Scrum refinement"—where PM and Engineering work together with AI assistance to define the complete specifications.

**When to use:** After a project exists in Linear (Phase 1 complete), before creating issues.

**Owners:** Product Manager + Engineering (AI-assisted)

**Process:**
1. Review the Linear project definition (name, description, summary)
2. PM and Engineering collaborate to define requirements
3. Use AI to draft and refine specification documents
4. Create `requirements.md` - what must be true (acceptance criteria)
5. Create `design.md` - how correctness is achieved (technical approach)
6. Create `tasks.md` - how work is executed (task breakdown)
7. Review and iterate until specs are complete and unambiguous
8. PM and Engineering sign off on specifications

**Spec File Locations:**
```
.kiro/specs/[feature]/
├── requirements.md    # What must be true
├── design.md          # How correctness is achieved
└── tasks.md           # How work is executed
```

**Key Principles:**
- **Collaborative**: PM brings product context, Engineering brings technical feasibility
- **AI-assisted**: AI helps draft, organize, and identify gaps—humans curate and approve
- **Thorough refinement**: Resolve ambiguities before development starts
- **No rushing**: Quality specs prevent rework during development

**IMPORTANT - Deep Refinement with AskUserQuestion:**

AI agents MUST use the `AskUserQuestion` tool extensively during this phase to:
- Probe for edge cases that may not be immediately obvious
- Clarify ambiguous requirements before they become implementation problems
- Explore alternative approaches and trade-offs
- Validate assumptions about user behavior and system constraints
- Identify potential failure modes and error scenarios
- Ensure completeness of acceptance criteria

This deep questioning process is essential for producing well-defined specs that minimize rework during development. The goal is to surface and resolve issues during refinement, not during coding.

**Quality Gate:** Both PM and Engineering must sign off on specs before proceeding to Phase 3.

---

### 3. Spec-to-Project Workflow (Issues from Specs)

For populating the Linear project with issues from the approved specification files.

**When to use:** After specs are approved (Phase 2 complete), to create Linear issues.

**Owner:** AI (autonomous after sign-off)

**Process:**
1. Read all spec files (requirements.md, design.md, tasks.md)
2. Query Linear for valid options (teams, statuses, labels)
3. Update Linear Project with appropriate metadata
4. Create Issues with 1:1 mapping to tasks.md entries
5. Set priorities, estimates, and labels
6. Update Project status to "Planned"

**Key MCP Tools:**
- `list_teams()` - Get valid team names/IDs
- `list_issue_statuses()` - Get valid statuses for team
- `list_issue_labels()` - See existing labels
- `list_users()` - If assigning issues
- `update_project()` - Update project metadata
- `create_issue()` - Create issues from tasks

---

### 4. Task Development Workflow (Mandatory for All Agents)

For developing individual tasks with proper status tracking.

**When to use:** Every time an agent starts working on a task.

**Mandatory Four-Phase Workflow:**

| Phase | Action | Linear Status | Comments |
|-------|--------|---------------|----------|
| 1. Development | Update status → Code → Comment | "In Progress" | Summary of what was developed |
| 2. Testing | Update status → Test → Comment → Fix/retest loop → Final comment | "Testing" | First test results + Final results (with fixes if any) |
| 3. Commit | Git add → Git commit (only if tests pass) | (no change) | None |
| 4. Completion | Update status → Final comment → Update tasks.md | "Done" | Commit info + final summary |

**Key MCP Tools:**
- `list_issues()` - Find the correct issue for the task
- `update_issue()` - Update status at each phase boundary
- `create_comment()` - Document development, testing iterations, and completion

**Critical Rules:**
- Development comment comes AFTER coding is complete
- Testing phase allows iterative fix/retest cycles with documented results
- Commits ONLY after tests pass
- "Done" ONLY after tests pass AND code is committed
- One task at a time (no batching)

---

### 5. Feature Verification / Pre-PR Review

For verifying and reviewing the completed feature before initiating the formal PR review process.

**When to use:** After all tasks are completed (Phase 4), before creating/submitting PRs for review.

**Owners:** Product Manager (with Engineering support)

**Process:**
1. PM reviews the completed feature against requirements.md
2. Engineering demonstrates the implementation to PM
3. Verify all acceptance criteria are met
4. Verify the feature works as specified in the product brief
5. Identify any gaps, issues, or deviations from specs
6. Document any necessary follow-up items or known issues
7. PM and Engineering sign off on feature completeness
8. Proceed to PR review process

**Verification Checklist:**
- [ ] All tasks in tasks.md are marked complete
- [ ] All Linear issues are marked "Done"
- [ ] Feature meets requirements defined in requirements.md
- [ ] Implementation aligns with design.md
- [ ] No critical bugs or regressions identified
- [ ] Feature is ready for formal code review

**Key Principles:**
- **PM-led**: Product Manager drives verification against original requirements
- **Engineering support**: Engineers demonstrate and explain implementation details
- **Quality gate**: Feature must be verified before PR review begins
- **Early feedback**: Catch issues before formal review process

**Quality Gate:** PM and Engineering must sign off that the feature is complete and ready for PR review.

---

### 6. Release Tracking / Environment Promotion (TODO)

For tracking the project/feature through the PR and deployment pipeline, with status reflected in Linear.

**When to use:** After feature verification (Phase 5), through production deployment.

**Owners:** Engineering (with PM visibility)

**Promotion Flow:**
```
Feature Branch → Develop → UAT → Production
     ↓              ↓        ↓        ↓
  PR Created    PR Merged  PR Merged  PR Merged
     ↓              ↓        ↓        ↓
 Linear: "Final Review" → "In Develop" → "In UAT" → "Released"
```

**Process:**
1. **Feature → Develop**: Create PR from feature branch to develop
   - Linear Project status: "Final Review"
   - PR review and approval
   - Squash merge to develop
   - Linear Project status: "In Develop"

2. **Develop → UAT**: Promote to UAT branch
   - Create PR from develop to UAT
   - Linear Project status: "In UAT"
   - QA/acceptance testing in staging environment
   - PM sign-off on UAT

3. **UAT → Production**: Promote to main/production
   - Create PR from UAT to main
   - Final approval
   - Merge to production
   - Linear Project status: "Released"
   - Tag release version

**Linear Project Status Progression:**

| Stage | Linear Status | Environment | Gate |
|-------|---------------|-------------|------|
| After Phase 5 | "Final Review" | - | Feature verified |
| Merged to develop | "In Develop" | Dev server | PR approved |
| Merged to UAT | "In UAT" | Staging server | QA testing |
| Merged to main | "Released" | Production | Final approval |

**TODO - Implementation Required:**
- [ ] Define Linear project statuses for each environment stage
- [ ] Create automation to update Linear status on PR merge events
- [ ] Define rollback procedures and Linear status handling
- [ ] Document hotfix flow and Linear tracking
- [ ] Integrate with CI/CD pipeline notifications

---

### Source of Truth Model (Bidirectional)

| Aspect | Authoritative Source |
|--------|---------------------|
| Requirements (what must be true) | `requirements.md` |
| Design (how correctness is achieved) | `design.md` |
| Work breakdown (tasks to execute) | `tasks.md` |
| Execution status | Linear |
| Time tracking / estimates | Linear |
| Development comments / discussions | Linear |
| Cycles / sprints | Linear |

**Principle:** Spec files define WHAT needs to be done. Linear tracks HOW execution is progressing.

### Constraints

1. **Linear team setup required** - Valid Linear team, statuses, and labels must exist before agents can interact with Linear.

2. **Single agent at a time** - Only one agent should work on a task at a time to avoid status update conflicts.

3. **Issues require spec files** - Linear projects can be created without spec files, but Linear issues within projects should only be created once spec files (requirements.md, design.md, tasks.md) are ready.

### Enforcement

These workflows are enforced through normative rule files in `.kiro/standards/core/`:

```
.kiro/standards/core/
├── linear-mcp-rules.md                 # Overview and quick reference
├── linear-mcp-product-to-projects.md   # Product brief → projects (FIRST STEP)
├── linear-mcp-spec-to-project.md       # Spec files → issues
└── linear-mcp-task-development.md      # Task development workflow rules
```

Violating these rules constitutes incorrect agent behavior. Agents must follow the detailed rules in these files exactly.

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

- `.kiro/standards/core/linear-mcp-rules.md` - Overview and quick reference
- `.kiro/standards/core/linear-mcp-product-to-projects.md` - Product brief → projects workflow
- `.kiro/standards/core/linear-mcp-spec-to-project.md` - Spec-to-project workflow
- `.kiro/standards/core/linear-mcp-task-development.md` - Task development workflow
- `CLAUDE.global.md` - Global settings referencing Linear MCP integration
