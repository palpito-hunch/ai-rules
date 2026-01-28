# ADR-0008: Epistemic Honesty for AI Agents

**Date**: 2025-01
**Status**: Accepted

## Context

AI language models are trained to be helpful and complete, which creates a systematic bias toward generating plausible-sounding content rather than admitting uncertainty or gaps. In spec-driven development, this manifests as:

1. **Inventing requirements** — Stating requirements that aren't in the spec
2. **Silent gap-filling** — Assuming values for unspecified behavior without flagging
3. **Confident-sounding speculation** — Pattern-matching from training data presented as fact
4. **Reluctance to say "I don't know"** — Generating something rather than admitting gaps

### Why This Matters

In spec-driven workflows (Phase 2-4 of our product development process), accuracy is critical:
- **Phase 2** (Spec Creation): AI helps draft specs—speculation becomes embedded requirements
- **Phase 3** (Spec-to-Project): AI creates issues from specs—invented details become tasks
- **Phase 4** (Task Development): AI implements from specs—unflagged assumptions become bugs

A single invented requirement can cascade through the entire development pipeline.

### The Root Cause

This isn't a bug—it's how LLMs work. They're trained to predict likely next tokens, not to distinguish between "stated in source" vs. "plausible inference" vs. "pure speculation." Without explicit rules, the model has no incentive to surface this distinction.

### Alternatives Considered

**1. Verbose flagging with confidence scores**
- Require `[ASSUMPTION: 70% confidence]` tags on everything
- Rejected: Over-precise, creates false sense of calibration, user fatigue

**2. Mandatory source citations for every claim**
- Every statement must include file:line reference
- Rejected: Too heavy for conversational flow, not all contexts have citable sources

**3. No special rules (rely on model behavior)**
- Trust the model to self-moderate
- Rejected: Observed failures show this doesn't work consistently

## Decision

Adopt a lightweight epistemic honesty rule focused on spec-driven work:

### The Rule

When working from specs or requirements:

1. **Cite sources** — Reference the spec section when stating requirements
2. **Flag gaps** — If something isn't specified, say so before assuming
3. **Ask, don't invent** — Use AskUserQuestion for gaps that affect implementation
4. **"Not specified" is valid** — Don't fill silence with plausible-sounding content

### Quick Test

Before stating a requirement as fact: *Can I point to where this is written?*
- Yes → cite it
- No → flag it as assumption or ask

### Scope

This rule applies primarily to:
- Implementing from spec files (requirements.md, design.md, tasks.md)
- Creating issues or tasks from specifications
- Answering questions about what a spec requires

Less applicable to:
- Exploratory coding / prototyping
- Brainstorming sessions
- General knowledge questions

## Consequences

**Positive:**
- Reduces silent gap-filling that creates bugs
- Makes assumptions visible and reviewable
- Encourages proactive clarification
- Aligns with Phase 2's deep probing requirement

**Negative:**
- Adds overhead to responses
- Relies on model compliance (not automatically enforceable)
- May slow down simple tasks with unnecessary caution

**Mitigation:**
- Rule is scoped to spec-driven work, not all interactions
- Lightweight format (no verbose tagging)
- Combined with TDD (tests catch incorrect assumptions)

## References

- `.kiro/standards/core/epistemic-honesty.md` — Implementation
- ADR-0005: Ways of Working (Phase 2 deep probing requirement)
- ADR-0007: AI Agent TDD Guidelines (tests as safety net)
