# ADR-0001: Use Next.js App Router

**Date**: 2024-01
**Status**: Accepted

## Context

Need a React framework that supports:
- Server-side rendering for SEO
- API routes for backend functionality
- Modern React patterns (Server Components)
- Good developer experience

## Decision

Use Next.js 14+ with App Router (not Pages Router).

## Consequences

**Positive:**
- Server Components reduce client bundle size
- Built-in API routes eliminate need for separate backend
- Excellent TypeScript support
- Streaming and Suspense support

**Negative:**
- Learning curve for Server vs Client Components
- Some libraries not yet compatible with App Router
- Different mental model from traditional React

## References

- `standards/libraries/nextjs.md`
