# .kiro/standards/README.md
# Development Standards Documentation

This directory contains all development standards and best practices for this project. These standards serve as specifications for AI-driven development with Kiro IDE.

## 📁 Directory Structure

```
standards/
├── core/                   # Always-loaded core standards
│   ├── priority-framework.md
│   ├── coding-standards.md
│   └── when-not-to-apply.md
│
├── domain/                 # Context-specific standards
│   ├── errors.md
│   ├── file-organization.md
│   ├── comments.md
│   └── performance.md
│
├── workflows/              # Task-specific guides
│   ├── code-review-checklist.md
│   ├── race-conditions.md
│   └── testing.md
│
├── quick-reference.md      # Quick lookup card
├── kiro-integration.md     # Kiro IDE integration guide
└── README.md               # This file
```

## 🎯 Core Standards (Load First)

### 1. Priority Framework (`core/priority-framework.md`)
Decision-making rules for when standards conflict:
- P0: Financial Safety & Type Safety
- P1: SOLID Principles & DRY
- P2: Performance

**Use when:** Making trade-off decisions between standards.

### 2. Coding Standards (`core/coding-standards.md`)
SOLID principles, DRY, race condition prevention, and core patterns.

**Use when:** Writing any production code.

### 3. When Not to Apply (`core/when-not-to-apply.md`)
Negative examples showing when NOT to use patterns.

**Use when:** Avoiding over-engineering and premature optimization.

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

### Code Review Checklist (`workflows/code-review-checklist.md`)
Comprehensive checklist for code reviews.

**Load when:** Reviewing code or preparing for review.

### Race Condition Prevention (`workflows/race-conditions.md`)
TOCTOU prevention, transaction patterns, concurrent operation testing.

**Load when:** Working with database transactions or concurrent operations.

### Testing Guidelines (`workflows/testing.md`)
Test requirements, patterns, and execution strategies.

**Load when:** Writing or running tests.

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
2. Review `core/priority-framework.md` (decision rules)
3. Read `core/coding-standards.md` (patterns)
4. Skim `core/when-not-to-apply.md` (anti-patterns)

### Before First Commit:
1. Review `workflows/code-review-checklist.md`
2. Check `workflows/race-conditions.md` if using transactions
3. Validate against quick-reference.md checklist

### For Code Reviews:
1. Use `workflows/code-review-checklist.md` as guide
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