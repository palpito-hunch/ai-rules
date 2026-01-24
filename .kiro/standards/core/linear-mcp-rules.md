# Linear MCP Integration Rules

> See [ADR-0005](../../memory/decisions/0005-linear-mcp-integration-rules.md) for rationale.

## Quick Reference

| Scenario | Action |
|----------|--------|
| Starting work on a Linear issue | Update status to "In Progress" |
| Completing work on a Linear issue | Update status to "Done" |
| Linear MCP unavailable | Note in commit message, continue work |
| No Linear issue exists (substantial work) | Create issue first |
| No Linear issue exists (trivial work) | Proceed without tracking |

## Workflow

### When a Linear Issue Exists

```
1. Call mcp__linear__update_issue({ id: "ISSUE-ID", state: "In Progress" })
2. Verify the update succeeded
3. Perform the development work
4. Call mcp__linear__update_issue({ id: "ISSUE-ID", state: "Done" })
5. Verify the update succeeded
```

### When Linear MCP Fails

Do NOT block development. Instead:

1. Log the intended status change
2. Continue with the work
3. Include in commit message: `[Linear unavailable - intended: PROJ-123 -> Done]`
4. Retry the status update after work is complete

### When No Issue Exists

**Substantial work** (features, bug fixes, multi-file changes):
- Create a Linear issue first using `mcp__linear__create_issue()`
- Then follow the standard workflow

**Trivial work** (typos, one-line fixes, formatting):
- Proceed without Linear tracking
- Optionally note in commit: `[No Linear issue - trivial fix]`

## What Requires Linear Tracking

**Track these:**
- Feature implementation
- Bug fixes
- Refactoring that changes behavior
- API changes
- Database migrations
- Security fixes

**Don't track these:**
- Typo fixes
- Code formatting
- Comment updates
- Dependency version bumps (unless breaking)
- Documentation fixes
- Exploratory spikes

## Error Handling

```typescript
// Pseudocode for agent behavior
async function updateLinearStatus(issueId: string, status: string) {
  try {
    await mcp__linear__update_issue({ id: issueId, state: status });
    return { success: true };
  } catch (error) {
    // Retry once
    try {
      await mcp__linear__update_issue({ id: issueId, state: status });
      return { success: true };
    } catch (retryError) {
      // Log and continue - don't block work
      console.log(`Linear update failed: ${issueId} -> ${status}`);
      return {
        success: false,
        fallback: `Include in commit: [Linear unavailable - intended: ${issueId} -> ${status}]`
      };
    }
  }
}
```

## Common Patterns

### Starting a Task from tasks.md

```markdown
Given: Task "Implement user export" linked to PROJ-456

1. Read the task requirements
2. Update PROJ-456 to "In Progress"
3. Implement the feature
4. Run tests
5. Update PROJ-456 to "Done"
6. Commit with reference to PROJ-456
```

### Handling a Quick Fix Request

```markdown
Given: User asks to "fix the typo in the README"

1. Assess: This is trivial (one word change)
2. Skip Linear tracking
3. Make the fix
4. Commit: "docs: fix typo in README [No Linear issue]"
```

### Recovering from MCP Failure

```markdown
Given: Linear MCP times out during status update

1. Note the failure
2. Complete the development work
3. Commit with fallback note: "[Linear unavailable - intended: PROJ-789 -> Done]"
4. After commit, attempt to update Linear status again
5. If still failing, move on (human can reconcile later)
```
