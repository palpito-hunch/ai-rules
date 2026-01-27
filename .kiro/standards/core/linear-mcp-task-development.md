# Linear MCP: Task Development Workflow
---
inclusion: always
---

## Purpose

This document defines **mandatory workflow rules** for agents when developing tasks. These rules ensure real-time visibility of work-in-progress by requiring status updates in Linear at each phase: development, version control commit, testing, and completion.

For rules about **creating projects and issues from specs**, see `linear-mcp-spec-to-project.md`.

---

## CRITICAL - MANDATORY WORKFLOW

**Every time you develop a task, you MUST follow this four-phase workflow:**

### **Phase 1: Development (MANDATORY)**

1. **Update Linear status to "In Progress"** before writing any code
   - Call `update_issue()` to set status to "In Progress"
   - Confirm the update succeeded
   - ONLY THEN begin code development

### **Phase 2: Testing (MANDATORY)**

2. **Update Linear status to "Testing"** after completing code, BEFORE running tests
   - Call `update_issue()` to set status to "Testing"
   - Confirm the update succeeded
   - Add a comment with **development summary only** using `create_comment()`
   - ONLY THEN run tests

### **Phase 3: Commit (MANDATORY)**

3. **Commit code changes** after tests pass successfully, BEFORE marking as "Done"
   - Stage all relevant code changes
   - Write a clear, descriptive commit message following conventional commits format
   - Commit the changes to the repository
   - Confirm the commit succeeded
   - ONLY commit if ALL tests passed

### **Phase 4: Completion (MANDATORY)**

4. **Update Linear status to "Done"** after committing code
   - Call `update_issue()` to set status to "Done"
   - Confirm the update succeeded
   - Add a comment with **test results and commit reference** using `create_comment()`
   - Update tasks.md checkbox from `[ ]` to `[x]`
   - ONLY THEN move to next task

**NEVER:**
- Start coding without updating Linear status first
- Run tests without moving to "Testing" first
- Commit code before tests pass successfully
- Mark as "Done" without committing code first
- Skip the version control commit step
- Skip any of the required comments
- Mix development details and test results in the same comment
- Commit code when tests fail

---

## Status Management Rules (MANDATORY)

**Rule S1 — Pre-Development Status Update (MANDATORY)**
- **BEFORE** writing ANY code for a task, the agent MUST update the corresponding Linear Issue status to "In Progress".
- The agent MUST call `update_issue()` with the appropriate status parameter.
- The agent MUST wait for confirmation that the status update succeeded.
- Code development MUST NOT begin until the Linear status has been successfully updated.
- This ensures real-time visibility of work-in-progress across the team.

**Rule S2 — Post-Development Status Update (MANDATORY)**
- **IMMEDIATELY AFTER** completing all code development for a task, the agent MUST update the corresponding Linear Issue status to "Testing".
- The agent MUST call `update_issue()` to set status to "Testing".
- The agent MUST wait for confirmation that the status update succeeded.
- Testing MUST NOT begin until the Linear status has been successfully updated to "Testing".
- This signals that code is ready for testing and review.

**Rule S3 — Development Comment (MANDATORY)**
- After moving to "Testing", the agent MUST add a comment using `create_comment()`.
- The comment MUST include:
  - Summary of what was implemented
  - Key technical details or decisions
  - Files modified or created
  - Any important notes for reviewers
- This comment documents ONLY the development work before testing begins.
- **IMPORTANT**: Keep focused on implementation details. Test results will be in a separate comment.

**Rule S4 — Run Tests (MANDATORY)**
- After adding the development comment, the agent MUST run all relevant tests.
- The agent MUST verify that ALL tests pass successfully.
- If ANY test fails, the agent MUST NOT proceed to commit or mark as "Done".

**Rule S5 — Version Control Commit (MANDATORY)**
- **IMMEDIATELY AFTER** tests pass successfully, the agent MUST commit the changes to version control.
- The agent MUST:
  - Stage all relevant code changes using `git add`
  - Write a clear, descriptive commit message following conventional commits format (feat/fix/docs/chore/refactor/test/perf/ci)
  - Include the task number or Linear issue reference in the commit message
  - Commit the changes to the repository
  - Verify the commit succeeded
- The commit message MUST be meaningful and describe what was changed and why.
- Code MUST ONLY be committed if ALL tests passed successfully.
- If tests failed, code MUST NOT be committed.
- This ensures only tested, working code is committed to version control.

**Rule S6 — Post-Testing Status Update (MANDATORY)**
- **IMMEDIATELY AFTER** committing code changes, the agent MUST update the corresponding Linear Issue status to "Done".
- The agent MUST call `update_issue()` to set status to "Done".
- The agent MUST wait for confirmation that the status update succeeded.
- The agent MUST NOT move to the next task until the status has been successfully updated to "Done".

**Rule S7 — Completion Comment (MANDATORY)**
- After moving to "Done", the agent MUST add a comment using `create_comment()`.
- The comment MUST include:
  - Test results (all passed)
  - Test execution details (which tests were run)
  - Test output summary
  - Commit hash or reference
  - Any warnings or notes from test execution
- This comment documents the testing validation and commit information.
- **IMPORTANT**: Do NOT repeat implementation details from the development comment.
- Keep this comment focused on test results and the commit.

**Rule S8 — Status Update Timing**
- Status updates MUST occur at the correct phase boundaries:
  - "In Progress" → Before coding
  - "Testing" → After coding, before testing
  - "Done" → After testing passes and code is committed
- Status updates MUST NOT be batched or deferred.
- If multiple tasks are being worked on sequentially, each task's status MUST be updated individually at each phase.

**Rule S9 — Status Update Verification**
- After calling `update_issue()`, the agent SHOULD verify the status change by checking the response.
- If the status update fails, the agent MUST retry or notify the user before proceeding.

**Rule S10 — Failed Tests Handling**
- If tests fail, the issue MUST remain in "Testing" status.
- The agent MUST add a comment with failure details.
- The agent MUST notify the user about the test failures.
- The agent MUST NOT commit code when tests fail.
- The agent MUST NOT move to "Done" status.
- The agent MUST NOT proceed to the next task.

---

## Development Workflow Ordering (MANDATORY)

When working on a task, the agent MUST follow this strict sequence:

### **Phase 1: Starting Development**
1. **Find Linear issue** → Use `list_issues()` to find the task
2. **Update status to "In Progress"** → Call `update_issue()`
3. **Verify update** → Confirm the status change succeeded
4. **Begin development** → Start writing code only after steps 1-3 complete

### **Phase 2: Code Complete, Ready for Testing**
5. **Finish development** → Complete all code changes for the task
6. **Update status to "Testing"** → Call `update_issue()`
7. **Verify update** → Confirm the status change succeeded
8. **Add development comment** → Call `create_comment()` with implementation summary

### **Phase 3: Run Tests**
9. **Run tests** → Execute relevant tests only after steps 5-8 complete
10. **Verify tests passed** → Ensure ALL tests executed successfully
11. **If tests FAIL** → Add failure comment → Notify user → STOP (do NOT commit or proceed)

### **Phase 4: Commit and Complete**
12. **Stage changes** → Use `git add` to stage all relevant files (only after tests pass)
13. **Commit changes** → Create commit with descriptive message following conventional commits format
14. **Verify commit** → Confirm the commit succeeded
15. **Update status to "Done"** → Call `update_issue()`
16. **Verify update** → Confirm the status change succeeded
17. **Add completion comment** → Call `create_comment()` with test results and commit reference
18. **Update tasks.md** → Change checkbox from `[ ]` to `[x]`
19. **Move to next task** → Only proceed after steps 12-18 complete

**This sequence MUST NOT be reversed or parallelized.**

---

## Finding the Correct Linear Issue

**Rule F1 — Issue Discovery**
- Before starting development, the agent MUST find the correct Linear issue for the task.
- Use `list_issues()` with a search query based on the task number or description.
- Verify the issue matches the task from `tasks.md`.

**Rule F2 — Task-Issue Correspondence**
- Ensure the Linear issue corresponds to the task you're working on.
- Verify by checking the issue title contains the task number (e.g., "4.2" for task 4.2).
- If no issue exists, notify the user - do NOT create issues during development.

---

## Status Update Examples

### Example 1: Starting a task

```typescript
// CORRECT: Update status before coding
const issue = await list_issues({ query: "4.2 keyboard navigation" });
await update_issue({ id: issue.id, state: "In Progress" });
// Status updated - NOW begin coding
```

```typescript
// WRONG: Starting to code without status update
// This violates Rule S1
const code = "function handleKeyPress() { ... }";
```

### Example 2: Code complete, move to testing

```typescript
// CORRECT: Update status to "Testing" and add development comment
await update_issue({ id: issue.id, state: "Testing" });
await create_comment({
  issueId: issue.id,
  body: `## Development Complete

### Implementation Summary
- Implemented keyboard navigation test for dismiss button
- Added property-based test using fast-check
- Test validates Requirements 6.1, 6.2, 8.5

### Technical Details
- Tests both Enter and Space key activation
- Validates focus indicators (focus:ring-2, focus:ring-blue-500)
- Verifies DOM focus state and button activation

### Files Modified
- \`src/components/__tests__/notification-card.property.test.tsx\` (lines 311-410)

Ready for testing.`
});
// Status updated and commented - NOW run tests
```

### Example 3: Tests pass, commit and mark as done

```typescript
// CORRECT: Tests passed, commit code, update status to "Done", and add completion comment
// First, commit the changes after tests pass
await bash({
  command: 'git add src/components/__tests__/notification-card.property.test.tsx && git commit -m "test(notification-card): add keyboard navigation property test\n\nImplement property-based test for dismiss button keyboard navigation.\nValidates Requirements 6.1, 6.2, 8.5.\n\nCo-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"'
});

// Then update Linear status to "Done"
await update_issue({ id: issue.id, state: "Done" });
await create_comment({
  issueId: issue.id,
  body: `## Testing Results

**Status**: All tests passed

### Tests Executed
- Property 14: Keyboard Navigation
- Duration: 10.2s
- Runs: 20 property test iterations

### Test Output
\`\`\`
Property 14: Keyboard Navigation  10257ms
\`\`\`

### Requirements Validated
- Requirement 6.1: Button focusable via tab navigation
- Requirement 6.2: Clear visual focus indicators present
- Requirement 8.5: Enter/Space key activation working

### Commit
- Changes committed to version control
- Commit message: "test(notification-card): add keyboard navigation property test"`
});
// Tests passed, code committed, status updated, and commented - NOW move to next task
```

### Example 4: Tests fail (DO NOT mark as Done)

```typescript
// CORRECT: Keep in "Testing" and add failure comment (testing ONLY)
await create_comment({
  issueId: issue.id,
  body: `## Testing Results

**Status**: Tests failed

### Failed Test
- Property 14: Keyboard Navigation
- **Error**: Expected button to be focusable, but tabIndex was -1

### Test Output
\`\`\`
Property 14: Keyboard Navigation
  Expected: tabIndex >= 0
  Received: tabIndex = -1
\`\`\`

**Task remains in "Testing" - requires investigation and fix.**`
});
// Notified about failure - DO NOT move to "Done" or next task
```

---

## Query Linear for Valid Options

Before updating status, agents SHOULD verify valid status names:

```typescript
// Get valid statuses for the team
const statuses = await list_issue_statuses({ team: "playground" });
// statuses will include: "Backlog", "Todo", "In Progress", "Testing", "Done", etc.
```

---

## Anti-Patterns (Strictly Forbidden)

The agent MUST NOT:
- Start writing code before updating Linear status to "In Progress"
- Run tests before updating Linear status to "Testing"
- Commit code before tests pass successfully
- Skip the version control commit step after tests pass
- Mark a task as "Done" before committing code
- Mark a task as "Done" before tests pass
- Skip the development comment when moving to "Testing"
- Skip the completion comment when moving to "Done"
- Mix development and testing details in the same comment
- Repeat implementation details in the completion comment
- Mark as "Done" when tests fail (keep in "Testing")
- Commit code when tests fail
- Batch status updates (each phase must be updated individually)
- Update status without verifying it succeeded
- Commit without a clear, descriptive commit message

---

## Critical Development Flow (TL;DR)

**Mandatory four-phase sequence for every task:**

```
Phase 1: In Progress → Code
Phase 2: Testing → Dev Comment → Test
Phase 3: Commit → Git Add → Git Commit (ONLY if tests pass)
Phase 4: Done → Completion Comment → Update tasks.md → Next Task
```

**Complete Flow:**
```
1. Find Issue
2. Update to "In Progress" → Verify
3. Code
4. Update to "Testing" → Verify
5. Add Development Comment
6. Run Tests
7. If tests PASS: Git Add → Git Commit → Verify → Update to "Done" → Verify → Completion Comment → Update tasks.md → Next Task
8. If tests FAIL: Keep in "Testing" → Failure Comment → Notify User → STOP (do NOT commit)
9. If ALL tasks complete: Update Project to "Final Review" → Verify → Notify User
```

**Key Points:**
- Four phases per task: "In Progress" → "Testing" → Commit → "Done"
- **Version control commit MANDATORY** after tests pass, before marking "Done"
- **NEVER commit code if tests fail**
- Three status updates per task: "In Progress" → "Testing" → "Done"
- Two separate comments per task: Development summary (Phase 2) + Test results & commit (Phase 4)
- Keep comments focused: Development comment = implementation only, Completion comment = test results + commit ref
- Testing ONLY happens in "Testing" phase
- Commit ONLY happens after tests pass
- "Done" ONLY after tests pass AND code is committed
- One task at a time
- No batching
- **Project status to "Final Review" when all tasks complete**

**Violating these rules constitutes incorrect agent behavior.**

---

## Integration with tasks.md

**Rule T1 — Update tasks.md Checkbox**
- After marking an issue as "Done" in Linear, the agent MUST update the corresponding checkbox in `.kiro/specs/[feature]/tasks.md`.
- Change `- [ ]` to `- [x]` for the completed task.
- This keeps the spec file in sync with Linear status.
- This MUST only happen after tests pass and status is "Done".

---

## Project Status Management (MANDATORY)

**Rule P1 — Project Status Update After All Tasks Complete**
- When ALL required tasks from `tasks.md` have been completed (all checkboxes marked `[x]` and all issues marked "Done"), the agent MUST update the Project status to "Final Review".
- The agent MUST call `update_project()` to set the project status to "Final Review".
- The agent MUST verify the project status update succeeded.
- This status change indicates that all development and testing work is complete and the project is ready for final review.
- This MUST happen AFTER the last task's status is updated to "Done" and its checkbox is marked in tasks.md.

**Rule P2 — Verification of Completion**
- Before updating the project status to "Final Review", the agent MUST verify:
  - All tasks in tasks.md are checked `[x]`
  - All corresponding Linear issues are marked "Done"
  - All tests have passed successfully
- If any task is incomplete, the project status MUST NOT be updated.

**Rule P3 — Project Completion Notification**
- After updating the project status to "Final Review", the agent MUST notify the user that:
  - All tasks have been completed
  - All tests have passed
  - The project is ready for final review
  - The project status has been updated in Linear

---

## Summary

This four-phase workflow ensures:
- Real-time visibility of work-in-progress at each phase
- **All code changes committed to version control ONLY after tests pass**
- **Failed tests prevent code commits** - only working, tested code is committed
- Clear separation between development, testing, and version control
- Documentation of both implementation and validation
- Tests are always run before committing code
- Failed tests prevent premature completion and commits
- Clear audit trail of development → testing → commit → completion
- Proper synchronization between Linear and spec files
- Project status updated to "Final Review" when all tasks complete

**The workflow is non-negotiable.** Every agent developing tasks must follow these rules exactly.
