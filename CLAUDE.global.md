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
- **Functions/Variables:** snake_case (all languages)
- **Constants:** UPPER_SNAKE_CASE

**Note:** Use snake_case for all custom code. Follow framework conventions when calling 3rd party APIs (e.g., `useState`, `onClick` in React).

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
5. **Epistemic honesty** - Cite sources, flag gaps, don't speculate from specs

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
---

## Product Development Workflow

Follow the six-phase product development workflow defined in **ADR-0005**.

**ADR**: `.kiro/memory/decisions/0005-ways-of-working-product-development.md`

### Six Phases (Execute in Order)

0. **Product Brief Creation** (FOUNDATION) — Owner: PM
   - PM identifies problem/requirement, drafts brief with AI assistance
   - PM curates extensively for clarity and completeness
   - Quality gate: Brief must be approved before proceeding

1. **Product Brief → Projects** — Owner: PM + AI
   - Break down product brief into sprint-sized Linear projects
   - Rules: `.kiro/standards/core/linear-mcp-product-to-projects.md`

2. **Spec Creation / Feature Refinement** — Owner: PM + Engineering
   - Collaborative refinement session (like super-charged Scrum refinement)
   - Create specs (requirements.md, design.md, tasks.md) with AI assistance
   - **IMPORTANT:** AI must use `AskUserQuestion` extensively to probe edge cases, clarify ambiguities, and ensure completeness
   - Quality gate: PM and Engineering sign off before proceeding

3. **Spec-to-Project** — Owner: AI
   - Populate project with issues from approved spec files
   - Rules: `.kiro/standards/core/linear-mcp-spec-to-project.md`

4. **Task Development** (MANDATORY) — Owner: AI
   - Develop tasks with status tracking
   - Rules: `.kiro/standards/core/linear-mcp-task-development.md`

5. **Feature Verification** — Owner: PM + Engineering
   - PM reviews completed feature against requirements
   - Engineering demonstrates implementation
   - Quality gate: Sign off before PR review begins

### Quick Reference

**Key Concept**: Problem → Product Brief → Projects → Specs → Issues → Development → Verification → PR Review.

**Project Creation Rules**:
- Names: Title Case, no emojis (use icons instead)
- Summaries: Required, 1-2 sentences, deliverable-focused
- Icons: Use shortcode format (`:lock:`, `:gear:`, etc.)
- Priority: 2=High, 3=Medium, 4=Low (never 1=Urgent)
- State: Default to "backlog" for new projects
- Scope: Sprint-sized (1-2 weeks of work)

**Task Development Rules**:
- Four phases: In Progress → Testing → Commit → Done
- Development comment AFTER coding
- Testing allows fix/retest loops with documented results
- Commit ONLY after tests pass
- See task development rules for full workflow

**Before Any Linear Work**:
```bash
# Read the overview file
view .kiro/standards/core/linear-mcp-rules.md
```

**Pattern**: When user requests Linear work, identify which workflow applies and read the corresponding rules file.