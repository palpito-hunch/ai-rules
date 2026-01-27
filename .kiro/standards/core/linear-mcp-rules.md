# Linear MCP Integration Rules
---
inclusion: always
---

## Purpose

This document provides an overview of Linear MCP integration rules and references the detailed rule documents.

Linear MCP integration has two main workflows:

1. **Project and Issue Creation** - Setting up a feature in Linear from spec files
2. **Task Development** - Working on individual tasks with proper status tracking

---

## Quick Reference

### For Creating Projects and Issues from Specs

See: `.kiro/standards/core/linear-mcp-spec-to-project.md`

**When to use:** Populating an existing Linear project with requirements, design, and tasks from spec files.

**Key rules:**
- Read all spec files first (requirements.md, design.md, tasks.md)
- Ask clarifying questions about team, emoji, priorities
- Query Linear for valid options
- Create 1:1 mapping between tasks.md and Linear issues
- Include proper estimates, labels, and traceability links

---

### For Developing Tasks (MANDATORY FOR ALL AGENTS)

See: `.kiro/standards/core/linear-mcp-task-development.md`

**When to use:** Every time you start working on a task

**Critical four-phase workflow (MANDATORY):**

1. **Phase 1 - Development:** Update to "In Progress" → Code
2. **Phase 2 - Testing:** Update to "Testing" → Dev Comment → Test
3. **Phase 3 - Commit:** Git Add → Git Commit (ONLY if tests pass)
4. **Phase 4 - Completion:** Update to "Done" → Completion Comment → Update tasks.md

**Key points:**
- Four phases per task with version control mandatory
- Three status updates: "In Progress" → "Testing" → "Done"
- **Git commit required ONLY after tests pass successfully**
- **NEVER commit code if tests fail**
- Two comments required: Development summary + Test results & commit reference
- Testing ONLY happens in "Testing" phase
- Commit ONLY happens after tests pass
- "Done" ONLY after tests pass AND code is committed
- One task at a time
- No batching of status updates

---

## Agent Behavior Summary

- Specs define truth (requirements.md, design.md, tasks.md)
- GitHub hosts canonical documents
- Linear tracks execution
- **Status updates BEFORE and AFTER code** (mandatory)
- Projects = feature intent (with emoji)
- Issues = 1:1 mapping with tasks.md
- Priorities follow tasks.md ordering
- Labels classify work type
- Comments document completion

---

## Critical Development Flow

**Every task must follow this sequence:**

```
1. Find Linear issue for task
2. Update status to "In Progress"
3. Verify update succeeded
4. Write code
5. Update status to "Testing"
6. Verify update succeeded
7. Add development comment
8. Run tests
9. If tests PASS: Git add and commit changes
10. Verify commit succeeded
11. Update status to "Done" (only after commit succeeds)
12. Verify update succeeded
13. Add completion comment with test results and commit reference
14. Update tasks.md checkbox
15. Move to next task
16. If tests FAIL: Add failure comment, notify user, STOP (do NOT commit or mark Done)
```

**This flow is non-negotiable.**

---

## File Organization

```
.kiro/standards/core/
├── linear-mcp-rules.md                    # This file (overview)
├── linear-mcp-spec-to-project.md         # Spec to project population
└── linear-mcp-task-development.md         # Task development workflow (MANDATORY)
```

---

## For More Details

- **Spec to Project:** Read `.kiro/standards/core/linear-mcp-spec-to-project.md`
- **Task Development:** Read `.kiro/standards/core/linear-mcp-task-development.md`

**Both files contain normative rules that must be followed.**

Violating these rules constitutes incorrect agent behavior.
