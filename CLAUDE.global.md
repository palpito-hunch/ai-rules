# Claude Code Global Settings

These are organization-wide preferences for Claude Code that apply to all repositories.

## Git Workflow (Mandatory)

**NEVER commit directly to main.** All changes must go through a feature branch and PR:

1. Create a feature branch: `git checkout -b feature/description`
2. Make changes and commit to the branch
3. Push and create a PR: `gh pr create`
4. Merge via PR after approval: `gh pr merge --squash --delete-branch`

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

## Organization Resources

- **AI Rules**: https://github.com/palpito-hunch/ai-rules
- **Backend Template**: https://github.com/palpito-hunch/backend-template
- **Frontend Template**: https://github.com/palpito-hunch/frontend-template
