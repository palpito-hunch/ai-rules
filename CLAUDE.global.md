# Claude Code Global Settings

These are organization-wide preferences for Claude Code that apply to all repositories.

## Git Workflow (Mandatory)

**NEVER commit directly to protected branches.** Projects use a promotion-based flow:

```
feature/* → develop → uat → main → develop (sync)
```

### Branch Purposes

| Branch    | Purpose                          | Deploys To  |
| --------- | -------------------------------- | ----------- |
| `develop` | Integration branch for features  | Development |
| `uat`     | User acceptance testing/staging  | Staging     |
| `main`    | Production-ready code            | Production  |

### Workflow Steps

1. **Create feature branch from develop:**
   ```bash
   git checkout develop && git pull origin develop
   git checkout -b feature/description
   ```

2. **Develop and commit to feature branch**

3. **Create PR to develop:**
   ```bash
   gh pr create --base develop
   ```

4. **Promote develop → uat** (when ready for testing):
   ```bash
   gh pr create --base uat --head develop --title "chore: promote develop to uat"
   ```

5. **Promote uat → main** (when UAT passes):
   ```bash
   gh pr create --base main --head uat --title "chore: promote uat to main"
   ```

6. **Sync main back to develop** (after production release):
   ```bash
   gh pr create --base develop --head main --title "chore: sync main to develop"
   ```

### Branch Protection

CI enforces allowed PR directions via `.github/workflows/branch-flow.yml`:
- Feature branches → `develop` only
- `develop` → `uat` only
- `uat` → `main` only
- `main` → `develop` only (sync back)

No exceptions, even for small changes.

## Commit Messages

Use conventional commits format:

```
type(scope): subject

body (optional)

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
```

Types: `feat`, `fix`, `docs`, `chore`, `refactor`, `test`, `perf`, `ci`

## Creating New Projects (Mandatory)

**ALWAYS use GitHub's template feature** when creating projects from organization templates:

```bash
# Correct - uses GitHub template feature
gh repo create org/new-project --template palpito-hunch/backend-template --private --clone

# Wrong - cloning loses template attribution and carries git history
git clone org/backend-template new-project  # DON'T DO THIS
```

## ADR Compliance (Mandatory)

**ALWAYS check ADRs before making architectural changes.** If a proposed change contradicts an existing ADR:

1. **STOP** - Do not proceed with the change
2. **NOTIFY** - Inform the user that the change conflicts with ADR-XXXX
3. **ASK** - Request explicit approval to either:
   - Modify the approach to comply with the ADR
   - Update/supersede the ADR (requires justification)

ADRs represent deliberate architectural decisions. Contradicting them without review undermines the decision-making process.

## Documentation Updates (Mandatory)

**ALWAYS keep documentation in sync with code changes.** After completing any task:

1. **Review impacted documentation**: README, ADRs, inline comments, API docs
2. **Update immediately**: Don't defer documentation updates to "later"
3. **Verify accuracy**: Ensure examples, diagrams, and references are still correct
4. **Add new docs**: Document new features, APIs, or architectural decisions

Common documentation touchpoints:
- **README.md**: Features, setup instructions, architecture diagrams
- **ADRs** (`.kiro/memory/decisions/`): Architectural decisions and their rationale
- **API documentation**: Endpoint changes, request/response formats
- **Code comments**: Complex logic, non-obvious decisions
- **CHANGELOG.md**: User-facing changes

**Outdated documentation is worse than no documentation.** If you change code, update the docs in the same PR.

## Code Style

- **Files:** kebab-case (`user-service.ts`, `user-profile.tsx`)
- **Components:** PascalCase (`UserProfile.tsx`)
- **Functions/Variables:** camelCase
- **Constants:** UPPER_SNAKE_CASE

## Red Flags (Never Generate)

- `reduce()` without initial value
- Generic `Error` class instead of specific error types
- Missing return type annotations on public functions
- Floating promises (unhandled async)
- Using `any` type instead of proper TypeScript types
- Prisma operations outside transactions (when multiple writes)
- N+1 query patterns
- SQL/command injection vulnerabilities (string concatenation in queries)
- Missing authentication/authorization checks on endpoints
- Hardcoded secrets or credentials in code
- Missing rate limiting on public endpoints
- `dangerouslySetInnerHTML` without DOMPurify sanitization
- Storing auth tokens in localStorage/sessionStorage (use httpOnly cookies)

## Key Principles

1. **Default to safety** - More validations, explicit error handling
2. **Fail explicitly** - Descriptive errors with context, never silent failures
3. **One pattern at a time** - Don't combine patterns unnecessarily
4. **Measure before optimizing** - No premature optimization

## Debugging & RCA Approach

### Before Starting

1. **Clarify the symptom** - What's the expected vs actual behavior?
2. **Gather context** - When did it start? What changed? Who's affected?
3. **Reproduce first** - Confirm you can trigger the issue reliably

### Investigation

1. **Form a hypothesis** - State what you think is wrong and why
2. **Test systematically** - One variable at a time, don't shotgun
3. **Follow the data** - Logs, traces, state inspection—not guesses
4. **Document dead ends** - Note what was ruled out and why

### Resolution

1. **Identify root cause** - Not just the symptom, the underlying why
2. **Propose fix** - Explain the change and why it addresses the root cause
3. **Verify** - Confirm the fix works and doesn't break other things

### Expected Artifacts

- Root cause summary (1-2 sentences)
- Fix with explanation
- Test that reproduces the bug (when feasible)
- Follow-up items (monitoring, related issues, tech debt)
- **Prevention rule in ai-rules repo** (mandatory - see below)

### Capturing Learnings (Mandatory)

**The RCA process is not complete until a rule has been added to the ai-rules repository that addresses the issue.**

Every debugging session should result in either:
- A new rule (if not covered by existing standards)
- An updated rule (if existing standards need strengthening)
- A red flag entry (if it's a "never do this" pattern)

This ensures the same class of bug doesn't recur and builds organizational knowledge over time.

### Principles

- **Don't guess** - If unsure, investigate more before changing code
- **Smallest fix first** - Address the root cause, don't refactor the world
- **Ask before assuming** - Clarify unknowns rather than filling gaps with assumptions

## Organization Resources

- **AI Rules**: https://github.com/palpito-hunch/ai-rules
- **Backend Template**: https://github.com/palpito-hunch/backend-template
- **Frontend Template**: https://github.com/palpito-hunch/frontend-template
