---
inclusion: always
---

# Core Coding Standards

These standards apply to ALL code generation. They define the priority framework, key principles, and anti-patterns.

## Quick Reference

#[[file:.kiro/standards/quick-reference.md]]

## Priority Framework

When standards conflict, use this framework to decide:

#[[file:.kiro/standards/core/priority-framework.md]]

## When NOT to Apply Patterns

Before adding abstractions, check if the pattern should be applied:

#[[file:.kiro/standards/core/when-not-to-apply.md]]

## AI Behavior Guidelines

How AI should interact with this codebase:

#[[file:.kiro/standards/core/ai-behavior.md]]

## Linear MCP Integration (MANDATORY)

**CRITICAL: Linear MCP has two workflows with different rules.**

**All Linear MCP rules are the SINGLE SOURCE OF TRUTH in `.kiro/standards/core/`:**

### Workflow 1: Task Development (MANDATORY FOR ALL AGENTS)

#[[file:.kiro/standards/core/linear-mcp-task-development.md]]

**This workflow is non-negotiable and applies to ALL task development.**

### Workflow 2: Project Creation (CONTEXTUAL)

#[[file:.kiro/standards/core/linear-mcp-spec-to-project.md]]

**Use when populating an existing Linear project with requirements, design, and tasks from spec files.**

### Overview

#[[file:.kiro/standards/core/linear-mcp-rules.md]]

**Violation of the task development workflow constitutes incorrect agent behavior.**
