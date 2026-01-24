# .kiro/standards/README.md

# Development Standards Documentation

This directory contains all development standards and best practices for this project. These standards serve as specifications for AI-driven development with Kiro IDE.

## 📁 Directory Structure

```
standards/
├── core/                       # Always-loaded core standards
│   ├── priority-framework.md   # Decision rules, KISS, Boy Scout Rule
│   ├── when-not-to-apply.md    # When NOT to use patterns (SOLID, DRY, etc.)
│   ├── ai-behavior.md          # AI interaction guidelines
│   ├── debugging-rca.md        # Debugging and root cause analysis approach
│   └── linear-mcp-rules.md     # Linear MCP integration workflow
│
├── typescript/                 # TypeScript-specific standards
│   ├── style.md                # Style rules (complements ESLint)
│   └── architecture.md         # Architectural patterns
│
├── libraries/                  # Library-specific standards
│   ├── prisma.md               # Database operations, transactions
│   ├── nextjs.md               # App Router, Server/Client Components
│   └── zod.md                  # Schema validation patterns
│
├── domain/                     # Context-specific standards
│   ├── errors.md
│   ├── file-organization.md
│   ├── comments.md
│   ├── performance.md
│   ├── git-workflow.md
│   └── testing-mocks.md
│
├── workflows/                  # Reserved for task-specific guides
│   └── .gitkeep
│
├── quick-reference.md          # Quick lookup card (consolidated reference)
├── kiro-integration.md         # Kiro IDE integration guide
└── README.md                   # This file

# Additional .kiro directories:
.kiro/
├── docs/                       # Documentation
│   └── ai-code-generation-improvements.md
├── memory/                     # Project memory for AI context
│   ├── decisions/              # Architecture Decision Records
│   └── glossary.yml            # Domain terminology
├── specs/                      # Feature specifications
│   ├── features/               # Feature specs before implementation
│   └── components/             # Component behavior specs
├── templates/                  # Templates for specs and docs
│   └── feature-spec.md
└── validation/                 # AI validation rules
    └── rules.yml
```

## 🎯 Core Standards (Load First)

### 1. Quick Reference (`quick-reference.md`)

One-page consolidated reference card with all standards. **Print and keep visible!**

**Use when:** Always - this is your primary reference.

### 2. Priority Framework (`core/priority-framework.md`)

Decision-making rules for when standards conflict:

- P0: Financial Safety & Type Safety
- P1: SOLID Principles & DRY
- P2: Performance
- Cross-cutting: KISS, YAGNI, Boy Scout Rule

**Use when:** Making trade-off decisions between standards.

### 3. When Not to Apply (`core/when-not-to-apply.md`)

Negative examples showing when NOT to use patterns (all SOLID principles, DRY, etc.).

**Use when:** Avoiding over-engineering and premature optimization.

### 4. AI Behavior Guidelines (`core/ai-behavior.md`)

Guidelines for how AI assistants should interact with this codebase:

- Rule hierarchy and override order
- When to follow vs deviate from rules
- How to handle conflicting instructions
- Communication style and code generation behavior

**Use when:** Configuring AI-assisted development or understanding AI decisions.

### 5. Debugging & RCA (`core/debugging-rca.md`)

Structured approach for debugging and root cause analysis:

- Three-phase process: Before starting, Investigation, Resolution
- Expected artifacts: Root cause summary, fix explanation, tests, follow-ups
- Principles: Don't guess, smallest fix first, ask before assuming
- Checklists for each phase

**Use when:** Investigating bugs, troubleshooting incidents, or diagnosing issues.

### 6. Linear MCP Integration (`core/linear-mcp-rules.md`)

Rules for AI agents integrating with Linear issue tracking via MCP:

- Status update workflow (In Progress -> Done)
- Error handling when MCP is unavailable
- What work requires Linear tracking vs. what doesn't
- Commit message conventions for fallback scenarios

**Use when:** Working on tasks that have corresponding Linear issues.

## 🔷 TypeScript Standards

### Style Guide (`typescript/style.md`)

TypeScript-specific style rules that complement ESLint configuration:

- Type annotations and when to use them
- Type vs interface decisions
- Null handling with strict TypeScript
- Async/await patterns
- Enums vs union types
- Naming conventions

**Use when:** Writing TypeScript code or reviewing style consistency.

### Architecture Patterns (`typescript/architecture.md`)

TypeScript-specific architectural patterns:

- Project structure and file naming
- Layered architecture (Controllers → Services → Repositories)
- Service and repository patterns
- Dependency injection approaches
- Error handling architecture
- React-specific patterns (if frontend)

**Use when:** Designing new features, structuring services, or implementing patterns.

## 📦 Library Standards

### Prisma (`libraries/prisma.md`)

Database operations best practices:

- Transaction requirements and patterns
- N+1 query prevention
- Query optimization (select, pagination)
- Error handling and common error codes
- Type safety with generated types

**Use when:** Writing database operations or reviewing data access code.

### Next.js (`libraries/nextjs.md`)

Next.js App Router patterns:

- Server vs Client Components
- Data fetching strategies
- API Routes (Route Handlers)
- Server Actions
- Caching and revalidation
- Metadata configuration

**Use when:** Building pages, API routes, or working with Next.js features.

### Zod (`libraries/zod.md`)

Schema validation patterns:

- Basic and complex schema definitions
- API request validation
- Error handling and custom messages
- Schema composition (extend, pick, omit)
- Type inference with `z.infer`
- Transformations and coercion

**Use when:** Validating inputs, defining API contracts, or working with forms.

## 📚 Domain-Specific Standards

### Error Handling (`domain/errors.md`)

Error message structure, error classes, and actionable error messages.

**Load when:** Implementing error handling or validation.

### File Organization (`domain/file-organization.md`)

Directory structure, naming conventions, file size limits.

**Load when:** Creating new files or reorganizing code.

### Comments (`domain/comments.md`)

When to comment, JSDoc standards, documentation best practices.

**Load when:** Adding documentation or reviewing code clarity.

### Performance (`domain/performance.md`)

When to optimize, profiling requirements, performance patterns.

**Load when:** Optimizing code or investigating performance issues.

## 🔄 Workflow Guides

Workflow content is consolidated in `quick-reference.md`:

- **Code Review:** See "Pre-Commit Checklist" and "Red Flags" sections
- **Race Conditions:** See "Race Conditions" section with transaction patterns
- **Testing:** See "Testing Requirements" and "Mock Policy" sections

The `workflows/` directory is reserved for future task-specific guides.

## ⚡ Quick Reference

**File:** `quick-reference.md`

Single-page reference card with:

- Priority hierarchy
- Red flags (auto-reject patterns)
- Quick decision frameworks
- Pre-commit checklist

**Keep open during development!**

## 🔧 Kiro IDE Integration

**File:** `kiro-integration.md`

Complete guide for using these standards with Kiro IDE:

- Context loading strategies
- Workflow templates
- Prompt patterns
- Configuration examples

## 📖 Usage Examples

### Starting a New Feature

```bash
# Load core standards
@Kiro load .kiro/standards/core/

# Load relevant domain standards
@Kiro load .kiro/standards/domain/errors.md

# Create feature with standards context
@Kiro create service --spec=feature-requirements.md
```

### Code Review

```bash
# Load review standards
@Kiro load .kiro/standards/workflows/code-review-checklist.md
@Kiro load .kiro/standards/workflows/race-conditions.md

# Run review
@Kiro review src/services/market.service.ts
```

### Performance Optimization

```bash
# Load performance standards
@Kiro load .kiro/standards/domain/performance.md

# Profile first!
@Kiro profile src/services/market.service.ts

# Optimize with context
@Kiro optimize --method=getMarketDetails
```

## 🎓 Learning Path

### For New Developers:

1. Read `quick-reference.md` (print and keep visible)
2. Review `core/priority-framework.md` (decision rules, KISS, Boy Scout)
3. Skim `core/when-not-to-apply.md` (anti-patterns for all SOLID principles)
4. Review `typescript/style.md` and `typescript/architecture.md` for TypeScript patterns

### Before First Commit:

1. Review "Pre-Commit Checklist" in `quick-reference.md`
2. Check "Race Conditions" section if using transactions
3. Validate against "Red Flags" section

### For Code Reviews:

1. Use "Pre-Commit Checklist" in `quick-reference.md` as guide
2. Reference specific standards when commenting
3. Link to relevant sections in review comments

## 🔄 Keeping Standards Updated

### When to Update Standards:

- New patterns emerge from code reviews
- Team agrees on new best practices
- Technology/framework changes require new guidance
- Anti-patterns discovered in production

### Update Process:

1. Propose change in team discussion
2. Update relevant standard document
3. Update `quick-reference.md` if needed
4. Announce change to team
5. Update Kiro IDE configuration if needed

## 📊 Standards Metrics

Track these metrics to validate standards effectiveness:

- Code review time (should decrease)
- Production bugs related to standards violations (should decrease)
- Time to onboard new developers (should decrease)
- Code consistency scores (should increase)

## 🆘 Getting Help

### If standards conflict:

1. Check `core/priority-framework.md` for decision rules
2. Consult `quick-reference.md` for common scenarios
3. Ask team lead for clarification
4. Propose standard update if gap identified

### If standard seems wrong:

1. Check `core/when-not-to-apply.md` for exceptions
2. Verify you're not over-applying the pattern
3. Discuss with team if standard needs updating
4. Document exception with justification

## 📝 Contributing to Standards

### Adding New Standards:

1. Identify gap in current standards
2. Draft new standard document
3. Follow existing format and structure
4. Get team review and approval
5. Update this README with new standard
6. Update `standards-config.yml` with loading rules

### Standard Document Format:

```markdown
# [Standard Name]

## Purpose

[Why this standard exists]

## When to Apply

[Specific scenarios]

## When NOT to Apply

[Exceptions and anti-patterns]

## Examples

[Good and bad examples]

## Checklist

[Validation items]
```

**Remember:** Standards exist to improve code quality and team velocity. If a standard is slowing you down or making code worse, it should be questioned and potentially updated.
