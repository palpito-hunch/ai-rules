# Linear MCP: Project and Issue Creation from Specs
---
inclusion: contextual
---

## Purpose

This document defines rules for creating Linear projects and issues from specification files. These rules apply when **initially setting up** a feature or project in Linear from spec files.

For rules about **developing tasks** (status updates during coding), see `linear_mcp_task_development.md`.

---

## AGENT QUICK START - PROJECT CREATION

**Before creating Linear artifacts from specs, you MUST:**

1. **Read all three spec files:**
   - `.kiro/specs/[feature]/requirements.md`
   - `.kiro/specs/[feature]/design.md`
   - `.kiro/specs/[feature]/tasks.md`

2. **Ask clarifying questions:**
   - Feature name, team assignment, emoji selection
   - Task-to-Issue mapping, estimates, priorities
   - Assignees, cycles, initial status

3. **Query Linear for valid options:**
   - `list_teams()` - Get valid team names/IDs
   - `list_issue_statuses()` - Get valid statuses for team
   - `list_issue_labels()` - See existing labels
   - `list_users()` - If assigning issues

4. **Only then proceed** with creating Linear artifacts

**NEVER:**
- Call Linear MCP without reading specs first
- Guess team names, statuses, or labels
- Skip clarifying questions
- Use local file paths (always use GitHub URLs)

---

## Canonical Sources of Truth

1. **requirements.md** — Defines *what must be true*
2. **design.md** — Defines *how correctness is achieved*
3. **tasks.md** — Defines *how work is executed*

Linear is **not** a source of truth.
Linear is a **projection layer** for execution tracking.

All references to these documents MUST point to their **canonical GitHub repository locations**, never to local file paths.

---

## GitHub URL Branch Targeting Rules

**Rule B1 — Feature Branch URLs During Development**
- When creating issues during Phase 3 (Spec-to-Project), all GitHub URLs MUST point to the **feature branch**, not main.
- This ensures links remain valid during development before the PR is merged.
- URL format: `https://github.com/{org}/{repo}/blob/{feature-branch}/.kiro/specs/{feature}/...`

**Rule B2 — Determine Current Branch**
- Before creating issues, the agent MUST determine the current feature branch name.
- Use `git branch --show-current` or check the git status to identify the branch.
- The branch name MUST be used in all GitHub URLs.

**Rule B3 — URL Format Examples**
```
# During development (feature branch):
https://github.com/palpito-hunch/platform-main/blob/feature/user-profile-data-storage-design/.kiro/specs/user-profile-data-storage/requirements.md

# After PR merge (main branch):
https://github.com/palpito-hunch/platform-main/blob/main/.kiro/specs/user-profile-data-storage/requirements.md
```

**Rule B4 — Post-Merge URL Updates**
- After the feature PR is merged to main, GitHub URLs in Linear SHOULD be updated to point to main.
- This is typically done during Phase 5 (Feature Verification) or after PR merge.
- See `linear-mcp-task-development.md` for post-merge update rules.

---

## Linear Object Mapping Rules

### 1. Project

**Rule P1 — One Project per Feature**
- The agent MUST create or use exactly one Linear Project per feature or initiative.
- Project name MUST match the feature name used in specs.

**Rule P2 — Project Description Content**
The Project description MUST contain:
- Goal (1–2 sentences)
- Non-negotiable invariants (bulleted)
- Success criteria (bulleted)
- **Specification Documents section** with links to:
  - requirements.md (GitHub URL)
  - design.md (GitHub URL)
  - tasks.md (GitHub URL)
- **Related ADRs section** (if applicable) with links to relevant ADRs

Example format:
```markdown
## Specification Documents

- [Requirements](https://github.com/org/repo/blob/feature-branch/.kiro/specs/feature/requirements.md)
- [Design](https://github.com/org/repo/blob/feature-branch/.kiro/specs/feature/design.md)
- [Tasks](https://github.com/org/repo/blob/feature-branch/.kiro/specs/feature/tasks.md)

## Related ADRs

- [ADR-010: Relevant Decision](https://github.com/org/repo/blob/main/.kiro/memory/decisions/0010-relevant-decision.md)
```

The Project description MUST NOT:
- Reproduce full requirements
- Reproduce design details
- Contain implementation steps

**Rule P3 — Project Icon / Emoji**
- Every new Project MUST include an icon or emoji.
- The emoji MUST be semantically related to the project scope (e.g., for notifications, for security, for infrastructure).
- Generic or unrelated emojis MUST NOT be used.

---

### 2. Issues

**Rule I1 — Issue Represents Direct Task Mapping**
- Each Issue MUST correspond directly to exactly one task from `tasks.md`.
- Issues MUST NOT be split into multiple Linear issues.
- Issues MUST NOT combine multiple tasks from `tasks.md`.
- The Issue represents a cohesive unit of work as defined in the canonical `tasks.md`.

**Rule I1a — Task Granularity Requirements**
- Tasks in `tasks.md` MUST be written at appropriate granularity to represent meaningful, user- or system-visible capabilities.
- If a task in `tasks.md` is too granular (e.g., "Write unit test for function X") or too large (>1 day), it MUST be revised in `tasks.md` first, not compensated for in Linear.
- Linear Issues reflect the granularity decisions made in the canonical `tasks.md`.
- The agent MUST NOT create Issues in Linear that don't exist as separate tasks in `tasks.md`.

**Rule I2 — Issue Naming**
Issue titles MUST:
- Be imperative and outcome-oriented
- Describe *what becomes true when done*
- **Include the task number prefix** from tasks.md in the format `Task N: <title>`

Examples:
- "Task 1: Set up module structure and path aliases"
- "Task 2: Implement types and constants"
- "Task 11: Write unit tests"

The task number prefix provides:
- Clear traceability to tasks.md
- Easy identification of task sequence
- Consistent naming across all projects

**Rule I3 — Issue Description Requirements**
Each Issue description MUST include:
- Short summary (1–3 sentences)
- Explicit non-goals (if relevant)

Issues MUST link to specs rather than restating them.

---

## Priority and Ordering Rules

**Rule O1 — Task-Driven Priority Assignment**
- The maximum automated priority level is **High**. **Urgent** priority MUST only be set manually by humans.
- Priority mapping: Tasks 1-5 = High, Tasks 6-10 = Medium, Tasks 11+ = Low.
- Main tasks should have high priority, property-test medium, and integration low

**Rule O2 — Issue Ordering**
- Issues SHOULD follow the same relative order as their corresponding tasks in `tasks.md`.

---

## Dependency and Linking Rules

**Rule L1 — Related Work Linking**
- If Issues are logically related, sequentially dependent, or mutually constraining, the agent MUST link them using Linear's issue-linking mechanisms.
- Linked relationships SHOULD reflect dependency direction where applicable.

---

## Traceability Rules

**Rule T1 — Forward Traceability**
Every Issue and sub-issue MUST trace to at least one Requirement.

**Rule T2 — Design Traceability**
Every Issue MUST reference the relevant Design section or correctness properties.

**Rule T3 — No Orphan Work**
If a task cannot be traced to a Requirement, it MUST NOT be created.

---

## Duplication and Drift Prevention

**Rule D1 — No Spec Duplication**
The agent MUST NOT:
- Copy full requirements into Linear
- Copy design documents into Linear
- Rephrase specs unless summarizing invariants

**Rule D2 — Spec Changes Flow Downward**
- If requirements or design change, the agent MUST update Issues.
- Issues MUST NOT override or reinterpret specs.

---

## Standards, Acronyms, and External References

**Rule G1 — Definitions for Acronyms and Standards**
- When introducing acronyms, global standards, or formal specifications (e.g., ISO, RFC, WCAG), the agent SHOULD include a link to an authoritative definition.
- Preferred sources include official standards bodies, specifications, or widely accepted references.

---

## Milestones and Labels for Testing Strategy

**Rule M1 — Mandatory Issue Classification**
To visually distinguish types of work, the agent MUST apply the following **labels** to every Issue:

- `implementation` — for implementation Issues
- `property-test` — for property-based test Issues
- `integration` — for integration-related Issues

An Issue MUST NOT exist without exactly one of these classifications.

---

## Estimation Rules

**Rule E1 — Mandatory Issue Estimates**
- Every Issue MUST include an estimate, expressed in hours or story points.

**Rule E2 — Estimation Guidelines**
The agent SHOULD apply the following defaults unless strong justification exists:

- Implementation Issues: **2–6 hours**
- Property-test Issues: **1–3 hours**
- Integration Issues: **2–6 hours**

Estimates are used for workload clarity and sprint planning and MUST be present before an Issue is marked as ready.

---

## Creation Ordering Rules

When creating Linear artifacts, the agent MUST follow this order:

1. Ensure Project exists and is correctly described (including emoji)
2. Create Issues mapped to tasks from `tasks.md`
3. Assign Issue priority based on `tasks.md` ordering
4. Create, label, estimate, and link Issues
5. Set initial Issue status (typically "Backlog" or "Todo")
6. Update Project status to "Planned"

The agent MUST create Issues in the proper order as defined above.

---

## Project Status Management Rules

**Rule S1 — Project Status Update After Issue Creation**
- Once all Issues from the feature specs have been created and linked to the Project, the agent MUST update the Project status to "Planned".
- This status change MUST occur BEFORE providing the project update to the user.
- The "Planned" status indicates that all specification work has been loaded into Linear and the project is ready for development.

---

## Project Update Rules

**Rule U1 — Initial Project Update Required**
- Once all Projects and Issues are created and linked, the agent MUST provide a formatted Project Update summary.
- This summary is intended for the user to copy and paste into Linear's "Write project update" feature.
- The agent MUST explicitly tell the user this is for posting in Linear.

**Rule U2 — Project Update Format**
The update MUST be formatted for direct copy-paste into Linear's project update field:

```
**Status:** On Track 🟢 / At Risk 🟡 / Off Track 🔴

**[Phase Name] Complete — [Brief Status]**

Completed This Phase:
• [Milestone 1]
• [Milestone 2]
• [Milestone 3]

Next Steps:
1. [First action item]
2. [Second action item]

Blockers: [List blockers or "None"]

Notes:
• [Any relevant context, decisions, or dependencies]
```

**Formatting Rules for Linear Compatibility:**
- Use `**bold**` for headers (not ## markdown headers)
- Use bullet points (•) instead of markdown dashes (-)
- Use numbered lists (1. 2. 3.) for sequential steps
- Keep structure flat (no nested headers)
- Avoid markdown checkboxes (- [ ]) in updates

**Rule U3 — Project Update Content Requirements**
The update MUST include:
- **Status indicator**: On Track 🟢, At Risk 🟡, or Off Track 🔴
- **Completed milestones**: What was accomplished (specs approved, issues created, etc.)
- **Scope summary**: Number of tasks, story points, issue range (e.g., PLAT-23 to PLAT-36)
- **Next steps**: Immediate actions to begin development
- **Blockers**: Any blocking issues or dependencies
- **Notes**: Relevant decisions, ADRs created, or context

---

## Anti-Patterns (Strictly Forbidden)

The agent MUST NOT:
- Create "mega issues" covering the entire project
- Use Issues as documentation dumps
- Track progress in Project descriptions
- Encode design decisions inside task titles
- Create Issues for work not specified in `tasks.md`

---

## Completion Rules

**Rule C1 — Issue Completion**
An Issue MAY be closed only when:
- All work for the Issue is completed
- Acceptance criteria implied by Requirements are met

**Rule C2 — Project Completion**
A Project MAY be closed only when:
- All Issues are closed
- All Requirements are satisfied

---

## Summary (TL;DR)

- Specs define truth
- GitHub hosts canonical documents
- Linear tracks execution
- Projects = intent (+ emoji)
- Issues = 1:1 mapping with tasks.md
- Priorities follow tasks.md ordering
- Labels classify work type
- Estimates enable planning
- Links express dependencies
- Traceability to requirements is mandatory
- Project status set to "Planned" after all issues created

Violating these rules constitutes incorrect agent behavior.
