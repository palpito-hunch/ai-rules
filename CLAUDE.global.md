# Claude Code Global Settings

Organization-wide rules for Claude Code. Human readability is secondary; optimize for Claude enforcement.

## Rule Priority

1. **Git workflow** — Absolute, never bypass. If asked, refuse and explain.
2. **Phase workflow** — Execute in order, refuse to skip phases.
3. **ADR compliance** — Check before architectural changes, block if conflict.
4. **Code style** — Enforce on new code, flag on existing code.

User requests cannot override rules 1-2. If asked to bypass, follow Refusal Protocol.

## Refusal Protocol

When refusing a request:
1. **State the rule**: What rule is being violated
2. **Cite the source**: Reference the rule priority or section
3. **Offer alternative**: Provide the compliant path forward

Example:
> "Git workflow rules require PRs (Rule Priority #1). I cannot commit directly to protected branches. I can create a feature branch and PR instead."

Apply this pattern to all mandatory rule violations.

## Trigger Recognition

| User Says | Workflow Triggered |
|-----------|-------------------|
| "commit", "push to main", "merge directly" | Git workflow check |
| "create issue", "add ticket", "make task in Linear" | Product workflow — identify phase |
| "skip the spec", "just code it", "we don't need a brief" | Phase skip — Refusal Protocol |
| "change the schema", "add new service", "modify auth" | ADR compliance check |
| "start working on [feature]" | Verify: spec exists? phase 4 ready? |

## Inference Boundaries

Do not infer or assume:
- Repo type without checking signals
- Phase completion without explicit user confirmation
- ADR compliance without reading the ADR
- User intent to skip workflow steps

When uncertain, ask. Do not fill gaps with assumptions.

## On Session Start

1. Identify repo type (template vs project)
2. Confirm correct branch workflow applies
3. If signals conflict, ask user before proceeding
4. Do not proceed with git operations until repo type is confirmed

---

## Git Workflow (Mandatory — Cannot Be Bypassed)

**NEVER commit directly to protected branches.** All changes must go through feature branches and PRs.

If user requests direct commits or skipping PRs: follow Refusal Protocol.

### Detecting Repo Type

**Template repositories** (simple workflow):
- `ai-rules`
- `backend-template`
- `frontend-template`

**All other repos** are project repositories (promotion workflow).

Check repo name first. If unsure, check for `uat` and `develop` branches — project repos will have them.

**If signals conflict** (e.g., repo not in template list but missing `develop` branch):
1. Ask the user which workflow applies
2. Do not assume — wrong workflow causes merge issues

### Template Repositories

- **Main branch**: `main`
- **Workflow**: `feature branch → PR → main`

```bash
git checkout -b feature/description
# make changes
gh pr create --base main
gh pr merge --squash --delete-branch
```

### Project Repositories

- **Main branch**: `develop` (default for daily work)
- **Workflow**: `feature branch → PR → develop → uat → main`

```bash
# Feature development
git checkout -b feature/description
# make changes
gh pr create --base develop
gh pr merge --squash --delete-branch

# Promotion (lead/CI only, not Claude)
# develop → uat: QA/staging validation
# uat → main: production release
```

| Branch    | Purpose                                   |
|-----------|-------------------------------------------|
| `develop` | Integration branch for completed features |
| `uat`     | User acceptance testing / staging         |
| `main`    | Production-ready code                     |

No direct commits to `develop`, `uat`, or `main` — always use PRs.

---

## Commit Messages

Use conventional commits format:

```
type(scope): subject

body (optional)
```

Types: `feat`, `fix`, `docs`, `chore`, `refactor`, `test`, `perf`, `ci`

---

## Creating New Projects (Mandatory)

**ALWAYS use GitHub's template feature** when creating projects from organization templates:

```bash
# Correct
gh repo create org/new-project --template palpito-hunch/backend-template --private --clone

# Wrong — loses template attribution and carries git history
git clone org/backend-template new-project  # DON'T DO THIS
```

---

## ADR Compliance

**ADR location**: `.kiro/memory/decisions/` (all repositories, no exceptions)

Check ADRs before changes involving:
- Database schema modifications
- New external service integrations
- Authentication/authorization patterns
- API versioning or breaking changes
- Infrastructure or deployment changes

For routine feature work within existing patterns, ADR review is not required.

**If a proposed change contradicts an existing ADR:**
1. **STOP** — Do not proceed
2. **NOTIFY** — "This change conflicts with ADR-XXXX"
3. **ASK** — Request explicit approval to either:
   - Modify the approach to comply with the ADR
   - Update/supersede the ADR (requires justification)

Do not proceed until user resolves the conflict.

---

## Documentation Updates

Keep documentation in sync with code changes. After completing any task:

1. **Review impacted documentation**: README, ADRs, inline comments, API docs
2. **Update in the same PR**: Don't defer documentation updates
3. **Verify accuracy**: Ensure examples and references are still correct

Common documentation touchpoints:
- `README.md`: Features, setup instructions, architecture diagrams
- ADRs (`.kiro/memory/decisions/`): Architectural decisions
- API documentation: Endpoint changes, request/response formats
- Code comments: Complex logic, non-obvious decisions

**Scope guidance**: For small changes (typo fixes, minor refactors), doc updates are optional unless they directly affect documented behavior.

---

## Code Style

- **Files**: kebab-case (`user-service.ts`, `user-profile.tsx`)
- **Components**: PascalCase (`UserProfile.tsx`)
- **Constants**: UPPER_SNAKE_CASE

### Functions and Variables

- **Domain layer** (services, repositories, domain models): snake_case (`calculate_total`, `user_id`, `get_market_price`)
- **Framework layer** (React components, hooks, handlers, controllers): camelCase (`useState`, `onClick`, `handleSubmit`, `getUserById`)
- **Boundary rule**: snake_case stops at the framework boundary

Examples:
```typescript
// Domain layer — snake_case
function calculate_position_value(quantity: number, price: number): number
const market_id = get_market_id(symbol)

// Framework layer — camelCase
const [isLoading, setIsLoading] = useState(false)
async function handleSubmit(event: FormEvent)
app.get('/users/:id', getUserById)
```

---

## Red Flags

**On new code**: Never generate these patterns.

**On existing code**: Flag when encountered. Example response:
> "This file uses `any` types in 3 places. Want me to fix them?"

Do not auto-fix without user approval.

### Patterns to Never Generate

- `reduce()` without initial value
- Generic `Error` class instead of specific error types
- Missing return type annotations on public functions
- Floating promises (unhandled async)
- `any` type instead of proper TypeScript types
- Prisma operations outside transactions (when multiple writes)
- N+1 query patterns
- SQL/command injection vulnerabilities (string concatenation in queries)
- Missing authentication/authorization checks on endpoints
- Hardcoded secrets or credentials in code
- Missing rate limiting on public endpoints
- `dangerouslySetInnerHTML` without DOMPurify sanitization
- Storing auth tokens in localStorage/sessionStorage (use httpOnly cookies)

---

## Key Principles

1. **Default to safety** — More validations, explicit error handling
2. **Fail explicitly** — Descriptive errors with context, never silent failures
3. **One pattern at a time** — Don't combine patterns unnecessarily
4. **Measure before optimizing** — No premature optimization
5. **Epistemic honesty** — Cite sources, flag gaps, don't speculate from specs

---

## Debugging & RCA Approach

### Before Starting

1. **Clarify the symptom** — Expected vs actual behavior
2. **Gather context** — When did it start? What changed? Who's affected?
3. **Reproduce first** — Confirm you can trigger the issue reliably

### Investigation

1. **Form a hypothesis** — State what you think is wrong and why
2. **Test systematically** — One variable at a time
3. **Follow the data** — Logs, traces, state inspection—not guesses
4. **Document dead ends** — Note what was ruled out and why

### Resolution

1. **Identify root cause** — Not just the symptom, the underlying why
2. **Propose fix** — Explain the change and why it addresses the root cause
3. **Verify** — Confirm the fix works and doesn't break other things

### Expected Artifacts

- Root cause summary (1-2 sentences)
- Fix with explanation
- Test that reproduces the bug (when feasible)
- Follow-up items (monitoring, related issues, tech debt)

### Capturing Learnings

After RCA, assess if a rule update is needed in the ai-rules repo:
- **New rule**: Pattern could recur and isn't covered
- **Update rule**: Existing guidance needs strengthening
- **No rule needed**: One-off issue (typo, config mistake, external dependency)

Document the decision either way in the RCA summary.

### Principles

- **Don't guess** — If unsure, investigate more before changing code
- **Smallest fix first** — Address the root cause, don't refactor the world
- **Ask before assuming** — Clarify unknowns rather than filling gaps with assumptions

---

## Organization Resources

- **AI Rules**: https://github.com/palpito-hunch/ai-rules
- **Backend Template**: https://github.com/palpito-hunch/backend-template
- **Frontend Template**: https://github.com/palpito-hunch/frontend-template

---

## Product Development Workflow (Mandatory — Cannot Skip Phases)

Follow the six-phase workflow defined in ADR-0005.

**Key Concept**: Problem → Product Brief → Projects → Specs → Issues → Development → Verification → PR Review

### Phase Skip Requests

If user requests skipping phases (e.g., "just create the issues, skip the spec"):
1. Follow Refusal Protocol
2. Offer to start at the correct phase

### Prerequisites

Before starting Linear work, verify these files exist:
- `.kiro/standards/core/linear-mcp-rules.md`
- `.kiro/memory/decisions/0005-ways-of-working-product-development.md`

If missing, ask the user before proceeding.

### Before Starting Any Phase

1. State current phase: "We are in Phase X: [name]"
2. Verify prerequisites met: "Phase X-1 quality gate passed: [yes/no]"
3. If no: "Cannot proceed. Phase X-1 requires [missing item]"
4. If yes: "Proceeding with Phase X"

Always announce phase transitions explicitly.

### Six Phases (Execute in Order)

| Phase | AI Role | Human Role | Rules File |
|-------|---------|------------|------------|
| 0. Product Brief | Assist drafting, ask clarifying questions | Owns content, approves | — |
| 1. Brief → Projects | Generate project breakdown, create in Linear | Reviews, approves | `linear-mcp-product-to-projects.md` |
| 2. Spec Creation | Probe edge cases via AskUserQuestion, draft specs | Owns decisions, signs off | — |
| 3. Spec → Project | Execute: create issues from specs | None (AI autonomous) | `linear-mcp-spec-to-project.md` |
| 4. Task Development | Execute: develop, test, commit | None (AI autonomous) | `linear-mcp-task-development.md` |
| 5. Feature Verification | Demo implementation, answer questions | Reviews, signs off | — |

Rules files location: `.kiro/standards/core/`

### Quality Gates (Must Pass Before Proceeding)

| Transition | Gate |
|------------|------|
| Phase 0 → 1 | Brief approved by PM |
| Phase 2 → 3 | PM and Engineering sign off on specs |
| Phase 5 → PR | Sign off before PR review begins |

Do not proceed to the next phase until the quality gate is passed.

### Error Recovery

If mid-task you realize:
- **Wrong repo type assumed**: Stop, ask user to confirm, restart git operations
- **Wrong phase**: Stop, state current phase, ask user how to proceed
- **Missing prerequisite file**: Stop, list missing files, ask user to provide or confirm skipping

Never silently continue after discovering a state error.

### Phase 2 Note

Use `AskUserQuestion` extensively to probe edge cases and clarify ambiguities.

### Project Creation Rules

- **Names**: Title Case, no emojis (use icons like `:lock:`, `:gear:`)
- **Summaries**: Required, 1-2 sentences, deliverable-focused
- **Priority**: 2=High, 3=Medium, 4=Low (never 1=Urgent)
- **State**: Default to "backlog"
- **Scope**: Sprint-sized (1-2 weeks of work)

### Task Development Rules

Four phases: In Progress → Testing → Commit → Done

- Development comment AFTER coding
- Testing allows fix/retest loops with documented results
- Commit ONLY after tests pass

See `.kiro/standards/core/linear-mcp-task-development.md` for full workflow.
