# ADR-0004: Centralized Rules for Distributed Teams

**Date**: 2025-01
**Status**: Accepted

## Context

The organization is considering whether maintaining centralized AI coding standards with automated sync is over-engineering, given current AI tooling limitations.

Key organizational characteristics:
- **Fully remote team** - Communication is limited and asynchronous
- **Heavy AI agent usage** - Coding agents do the majority of implementation work
- **6+ projects** - Multiple repositories that should follow consistent standards
- **Contractor-based** - Team members rotate, institutional knowledge is limited

Current AI tooling reality:
- AI agents (Claude Code, Cursor, etc.) read local files like `CLAUDE.md` or `.cursorrules`
- No native support for organizational/remote rules
- Agents don't "phone home" to check central standards
- They only know what's in the local repository

## Decision

Maintain centralized AI rules with automated sync despite the complexity, because the organizational context justifies the investment.

### When Centralized Rules Make Sense

1. **Remote teams** - You can't rely on "everyone knows" or Slack announcements. Rules must be in the code, not in people's heads.

2. **AI agents doing the coding** - Agents only know what's in the repo. If standards aren't synced, projects drift apart.

3. **6+ projects** - Manual syncing becomes a burden and source of inconsistency.

4. **Contractor turnover** - Standards persist even as team members rotate. Onboarding is "clone the repo, the AI knows the rules."

5. **Sync PRs as communication** - Weekly automated PRs serve as async notifications. Team members see the PR, review the changes, understand what's new.

### When It's Overkill

1. **2-3 projects** - Manual copy-paste is manageable
2. **Stable standards** - If rules rarely change, automation adds overhead without benefit
3. **Co-located team** - Can communicate changes directly
4. **Small team with low turnover** - Institutional knowledge stays in the team

### Architecture Trade-offs

**Complexity accepted:**
- Manifest files for template-specific exclusions
- Template-specific CLAUDE files (`CLAUDE.backend.md`, `CLAUDE.frontend.md`)
- GitHub Actions workflows with `yq` parsing
- Two-step process to add new rules (file + manifest update)

**Simplicity preserved:**
- Each template still has a simple local `CLAUDE.md` - agents see nothing unusual
- Changes propagate automatically - no manual intervention needed
- Single source of truth - update once in ai-rules, propagates everywhere

### Alternative Considered: Simple Manual Sync

- Keep ai-rules as documentation only
- Each template maintains its own `CLAUDE.md`
- Update manually when standards change

**Rejected because:**
- Remote team + contractors = things get missed
- "We'll update it later" becomes "we forgot"
- No audit trail of when standards changed
- Onboarding contractors requires explaining the manual process

## Consequences

**Positive:**
- Standards stay consistent across all projects without human intervention
- Onboarding is simple: clone the repo, AI knows the rules
- Changes propagate reliably through PRs (audit trail)
- PRs serve as async communication for distributed team
- Contractors don't need to know about the central repo - they just work in their assigned project

**Negative:**
- Upfront investment in automation infrastructure
- Debugging sync issues requires understanding the workflow
- Must remember to update manifest when adding template-specific rules
- Over-engineered for smaller organizations

**Neutral:**
- AI tooling may add native organizational rules support in the future, potentially making this obsolete

## References

- `ADR-0002` - Centralized AI Rules Architecture (the what)
- `ADR-0003` - Manifest-Based Template Sync (the how)
- `.kiro/sync-manifest.yml` - Sync configuration
- `.github/workflows/sync-from-ai-rules.yml` - Template sync workflows
