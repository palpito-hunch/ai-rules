# What's New: AI Code Generation Improvements Guide

This document provides a comprehensive explanation of all new files added to improve AI-generated code quality. Each section explains what was added, how it works, and the benefits it provides.

---

## Table of Contents

1. [MCP Server Configuration](#1-mcp-server-configuration)
2. [Library Standards](#2-library-standards)
3. [Feature Specification Template](#3-feature-specification-template)
4. [Project Memory](#4-project-memory)
5. [Validation Rules](#5-validation-rules)
6. [Updated Configuration](#6-updated-configuration)
7. [How Everything Works Together](#7-how-everything-works-together)

---

## 1. MCP Server Configuration

### File: `.mcp.json`

### What It Is

MCP (Model Context Protocol) is an open standard created by Anthropic that allows AI assistants to connect to external tools and data sources. The `.mcp.json` file configures which MCP servers are available to AI tools like Claude Code.

### What Was Added

```json
{
  "mcpServers": {
    "context7": { ... },      // Library documentation server
    "github": { ... },        // GitHub integration server
    "filesystem": { ... }     // File system access server
  }
}
```

### How Each Server Helps

| Server | What It Does | Benefit |
|--------|--------------|---------|
| **Context7** | Fetches up-to-date documentation for libraries (React, Prisma, Next.js, etc.) | Prevents AI from using outdated or hallucinated APIs |
| **GitHub** | Provides access to issues, PRs, and repository context | AI understands project history and discussions |
| **Filesystem** | Enables reading project files | AI can explore codebase for context |

### Real-World Example

Without Context7:
```typescript
// AI might generate outdated Next.js 12 code:
export async function getServerSideProps() { ... }
```

With Context7:
```typescript
// AI generates correct Next.js 14 App Router code:
export default async function Page() {
  const data = await fetchData(); // Server Component
  return <div>{data}</div>;
}
```

### How to Use

MCP servers are automatically available when using Claude Code or other MCP-compatible tools. No manual activation required.

---

## 2. Library Standards

Three new files provide detailed usage patterns for the project's core libraries.

### File: `.kiro/standards/libraries/prisma.md`

### What It Is

A comprehensive guide for using Prisma ORM correctly, focusing on preventing common database issues.

### Key Sections

| Section | What It Covers | Why It Matters |
|---------|----------------|----------------|
| **Transaction Requirements** | When to use `$transaction` | Prevents data inconsistencies and race conditions |
| **N+1 Query Prevention** | Using `include` and batch queries | Prevents performance disasters (1000 users = 1001 queries) |
| **Query Optimization** | `select`, pagination, `count` | Reduces database load and response times |
| **Error Handling** | Prisma error codes (P2002, P2025) | Proper error responses to clients |
| **Type Safety** | Using generated Prisma types | Compile-time safety for database operations |

### Example Problem This Solves

```typescript
// ❌ WITHOUT standards: N+1 query problem
const users = await prisma.user.findMany();
for (const user of users) {
  const posts = await prisma.post.findMany({ where: { authorId: user.id } });
}
// 100 users = 101 database queries!

// ✅ WITH standards: Single query with include
const users = await prisma.user.findMany({
  include: { posts: true }
});
// 100 users = 1 database query
```

---

### File: `.kiro/standards/libraries/nextjs.md`

### What It Is

Patterns and best practices for Next.js App Router, the modern way to build Next.js applications.

### Key Sections

| Section | What It Covers | Why It Matters |
|---------|----------------|----------------|
| **Server vs Client Components** | When to use each type | Optimal bundle size and performance |
| **Data Fetching** | Direct DB access in Server Components | Simpler, faster data loading |
| **API Routes** | Route Handlers with proper typing | Type-safe API endpoints |
| **Server Actions** | Form handling without API routes | Simpler mutations |
| **Caching** | `revalidate`, `no-store`, tags | Correct caching behavior |
| **File Structure** | App Router conventions | Consistent project organization |

### Example Problem This Solves

```typescript
// ❌ WITHOUT standards: Using Client Component for static content
'use client';
export default function ProductList() {
  const [products, setProducts] = useState([]);
  useEffect(() => {
    fetch('/api/products').then(r => r.json()).then(setProducts);
  }, []);
  return <ul>{products.map(p => <li>{p.name}</li>)}</ul>;
}
// Problems: Client-side fetch, loading spinner, SEO issues

// ✅ WITH standards: Server Component with direct data access
export default async function ProductList() {
  const products = await prisma.product.findMany();
  return <ul>{products.map(p => <li key={p.id}>{p.name}</li>)}</ul>;
}
// Benefits: No loading state, SEO-friendly, faster initial load
```

---

### File: `.kiro/standards/libraries/zod.md`

### What It Is

Schema validation patterns using Zod, ensuring all inputs are validated at runtime.

### Key Sections

| Section | What It Covers | Why It Matters |
|---------|----------------|----------------|
| **Basic Schemas** | Primitives, objects, arrays | Foundation for all validation |
| **API Validation** | `safeParse` in route handlers | Prevents invalid data from reaching business logic |
| **Error Handling** | Structured error responses | Consistent, helpful error messages |
| **Schema Composition** | `extend`, `pick`, `omit`, `partial` | DRY schema definitions |
| **Type Inference** | `z.infer<typeof Schema>` | Single source of truth for types |
| **Transformations** | `transform`, `coerce` | Handle form data and query params |

### Example Problem This Solves

```typescript
// ❌ WITHOUT standards: No validation, types lie at runtime
export async function POST(request: NextRequest) {
  const { email, name } = await request.json(); // Could be anything!
  await prisma.user.create({ data: { email, name } });
}
// Runtime error if email is missing or invalid

// ✅ WITH standards: Zod validation with type safety
const CreateUserSchema = z.object({
  email: z.string().email(),
  name: z.string().min(1),
});

export async function POST(request: NextRequest) {
  const body = await request.json();
  const result = CreateUserSchema.safeParse(body);

  if (!result.success) {
    return NextResponse.json(
      { error: 'VALIDATION_ERROR', details: result.error.flatten().fieldErrors },
      { status: 400 }
    );
  }

  await prisma.user.create({ data: result.data }); // Type-safe!
}
```

---

## 3. Feature Specification Template

### File: `.kiro/templates/feature-spec.md`

### What It Is

A structured template for defining features before implementation. Based on Tessl's spec-driven development approach where "specs drive everything."

### Template Sections

| Section | Purpose | Example Content |
|---------|---------|-----------------|
| **Intent** | Why the feature exists | "Allow users to reset their password securely" |
| **User Stories** | Who needs it and why | "As a user, I want to reset my password so that I can regain access" |
| **Behavior** | Given/When/Then scenarios | "Given a valid email, When reset requested, Then email is sent" |
| **Technical Approach** | High-level implementation | Components affected, data model changes |
| **Constraints** | Standards to follow | Link to prisma.md, errors.md |
| **Acceptance Criteria** | Definition of done | Testable checklist items |
| **Anti-Patterns** | What to avoid | "Do NOT store reset tokens in plain text" |
| **Test Plan** | How to test | Unit tests, integration tests, edge cases |

### How It Helps

1. **Before Implementation**: Forces thinking through requirements
2. **During Implementation**: AI uses spec as guide, follows constraints
3. **After Implementation**: Acceptance criteria become test cases
4. **For Reviews**: Clear criteria for approval

### Directory Structure

```
.kiro/specs/
├── features/           # Feature specs go here
│   └── password-reset.spec.md
└── components/         # Component specs go here
    └── user-avatar.spec.md
```

---

## 4. Project Memory

Two files provide persistent context that helps AI understand the project's history and domain.

### File: `.kiro/memory/decisions.md`

### What It Is

Architecture Decision Records (ADRs) documenting significant technical decisions.

### Structure of Each Decision

```markdown
## ADR-001: [Title]

**Date**: YYYY-MM
**Status**: Accepted

### Context
Why was this decision needed?

### Decision
What was decided?

### Consequences
**Positive:** Benefits
**Negative:** Trade-offs

### References
Related documentation
```

### Decisions Documented

| ADR | Decision | Why It Matters |
|-----|----------|----------------|
| ADR-001 | Use Next.js App Router | AI generates App Router code, not Pages Router |
| ADR-002 | Use Prisma | AI uses Prisma patterns, not raw SQL |
| ADR-003 | Layered Architecture | AI creates proper service/repository separation |
| ADR-004 | Zod for Validation | AI adds Zod schemas, not manual validation |
| ADR-005 | Strict TypeScript | AI uses strict types, handles undefined |
| ADR-006 | ESLint Type-Aware Rules | AI generates code that passes linting |
| ADR-007 | Semantic Versioning | AI writes proper commit messages |

### How It Helps

Without ADRs:
```typescript
// AI might generate raw SQL (doesn't know Prisma is preferred)
const users = await db.query('SELECT * FROM users WHERE id = ?', [id]);
```

With ADRs:
```typescript
// AI knows Prisma is the standard
const user = await prisma.user.findUnique({ where: { id } });
```

---

### File: `.kiro/memory/glossary.yml`

### What It Is

Domain terminology and naming conventions in machine-readable format.

### What's Defined

| Category | Examples | Purpose |
|----------|----------|---------|
| **Terms** | User, Order, Product | Domain entity definitions with properties and states |
| **Technical** | Service, Repository, DTO | Layer definitions and responsibilities |
| **Conventions** | File naming, variable naming | Consistent naming patterns |
| **Abbreviations** | API, DTO, UUID, SSR | Common abbreviation meanings |
| **Statuses** | Order states, User states | Valid status values |

### Example Entry

```yaml
Order:
  definition: "A purchase transaction"
  states:
    - pending: "Order created, awaiting payment"
    - confirmed: "Payment received"
    - shipped: "Order dispatched"
    - delivered: "Order received by customer"
    - cancelled: "Order cancelled"
  properties:
    - id: "Unique identifier"
    - userId: "Reference to User"
    - status: "Current order state"
    - total: "Order total amount"
```

### How It Helps

Without glossary:
```typescript
// AI might use inconsistent naming
const orderData = { state: 'PENDING', orderStatus: 'new' };
```

With glossary:
```typescript
// AI uses consistent terminology
const order = { status: 'pending' }; // Uses defined status value
```

---

## 5. Validation Rules

### File: `.kiro/validation/rules.yml`

### What It Is

Machine-readable rules that AI can check during and after code generation. Complements ESLint/TypeScript with domain-specific checks.

### Rule Categories

| Category | Severity | Examples |
|----------|----------|----------|
| **Critical** | Blocks generation | Transactions required, no floating promises |
| **High** | Should fix | N+1 queries, missing Zod validation |
| **Medium** | Suggestions | No console.log, use path aliases |
| **Naming** | Conventions | Service naming, hook naming |
| **Structure** | File placement | Services in services/, repos in repositories/ |

### Example Rules

```yaml
critical:
  - name: transaction-required
    pattern: "prisma\\.(create|update|delete)"
    required_context: "\\$transaction"
    message: "Database write operation found outside of transaction"

high:
  - name: n-plus-one-query
    pattern: "for\\s*\\([^)]+\\)\\s*\\{[^}]*await\\s+prisma\\."
    message: "Potential N+1 query - use include or batch query"

naming:
  - name: service-naming
    valid_pattern: "^[A-Z][a-zA-Z]+Service$"
    message: "Service classes must be PascalCase ending with 'Service'"
```

### How It Helps

The rules provide a checklist for AI to verify generated code:

1. **During Generation**: AI avoids patterns that would violate rules
2. **After Generation**: Rules serve as automated review checklist
3. **In CI/CD**: Rules can be automated into validation pipeline

---

## 6. Updated Configuration

### File: `.kiro/standards-config.yml` (Updated)

### What Changed

Added new sections for libraries and memory:

```yaml
defaults:
  libraries:
    - standards/libraries/prisma.md
    - standards/libraries/nextjs.md
    - standards/libraries/zod.md

  memory:
    - memory/decisions.md
    - memory/glossary.yml

  validation_rules: validation/rules.yml

contexts:
  api_routes:
    patterns: ['src/pages/api/**/*.ts', 'app/api/**/*.ts']
    standards:
      - standards/libraries/nextjs.md
      - standards/libraries/zod.md
      - standards/domain/errors.md

  pages:
    patterns: ['app/**/*.tsx']
    standards:
      - standards/libraries/nextjs.md
```

### How Auto-Loading Works

When AI works on a file matching a pattern, relevant standards are automatically loaded:

| Working On | Standards Auto-Loaded |
|------------|----------------------|
| `src/services/user.service.ts` | architecture.md, prisma.md, zod.md, errors.md |
| `app/api/users/route.ts` | nextjs.md, zod.md, errors.md |
| `src/repositories/user.repository.ts` | architecture.md, prisma.md, performance.md |

---

### File: `.kiro/standards/README.md` (Updated)

### What Changed

Added documentation for all new directories:

- Library Standards section explaining Prisma, Next.js, Zod
- Updated directory tree showing new structure
- Cross-references to new files

---

## 7. How Everything Works Together

### The Complete Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                     AI Code Generation Flow                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. CONTEXT GATHERING                                            │
│     ┌──────────────┐  ┌──────────────┐  ┌──────────────┐        │
│     │ MCP Servers  │  │   Memory     │  │  Standards   │        │
│     │ (Context7,   │  │ (decisions,  │  │ (libraries,  │        │
│     │  GitHub)     │  │  glossary)   │  │  typescript) │        │
│     └──────────────┘  └──────────────┘  └──────────────┘        │
│            │                 │                 │                 │
│            └─────────────────┼─────────────────┘                 │
│                              ▼                                   │
│  2. SPECIFICATION                                                │
│     ┌──────────────────────────────────────────┐                │
│     │         Feature Spec Template             │                │
│     │  (intent, behavior, constraints, tests)   │                │
│     └──────────────────────────────────────────┘                │
│                              │                                   │
│                              ▼                                   │
│  3. CODE GENERATION                                              │
│     ┌──────────────────────────────────────────┐                │
│     │     AI generates code following:          │                │
│     │     - Library standards (prisma, zod)     │                │
│     │     - Architecture patterns               │                │
│     │     - Naming conventions                  │                │
│     │     - Feature spec constraints            │                │
│     └──────────────────────────────────────────┘                │
│                              │                                   │
│                              ▼                                   │
│  4. VALIDATION                                                   │
│     ┌──────────────────────────────────────────┐                │
│     │     Validation Rules Check:               │                │
│     │     - Transactions present?               │                │
│     │     - No N+1 queries?                     │                │
│     │     - Zod validation used?                │                │
│     │     - Correct naming?                     │                │
│     └──────────────────────────────────────────┘                │
│                              │                                   │
│                              ▼                                   │
│  5. OUTPUT                                                       │
│     ┌──────────────────────────────────────────┐                │
│     │     High-quality, consistent code that:   │                │
│     │     - Follows project patterns            │                │
│     │     - Uses correct APIs                   │                │
│     │     - Handles errors properly             │                │
│     │     - Is type-safe                        │                │
│     └──────────────────────────────────────────┘                │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Before vs After Comparison

| Aspect | Before | After |
|--------|--------|-------|
| **Library APIs** | May hallucinate methods | Uses documented patterns from library specs |
| **Architecture** | Inconsistent structure | Follows decisions.md patterns |
| **Naming** | Varies by generation | Consistent per glossary.yml |
| **Validation** | Often missing | Zod schemas per zod.md |
| **Database** | May have N+1 issues | Correct queries per prisma.md |
| **Components** | Mixed Server/Client | Proper separation per nextjs.md |
| **Errors** | Generic messages | Specific classes per standards |

### Expected Improvements

| Metric | Expected Change |
|--------|-----------------|
| API Hallucinations | -80% (Context7 + library specs) |
| Code Review Iterations | -50% (validation rules catch issues) |
| Standards Violations | -90% (auto-loaded standards) |
| Naming Inconsistencies | -95% (glossary + naming rules) |
| Database Issues | -90% (prisma.md patterns) |

---

## Quick Reference

### File Locations

```
.kiro/
├── docs/
│   ├── ai-code-generation-improvements.md  # Recommendations
│   └── whats-new-guide.md                  # This document
├── memory/
│   ├── decisions.md                        # Architecture decisions
│   └── glossary.yml                        # Domain terminology
├── specs/
│   ├── features/                           # Feature specs
│   └── components/                         # Component specs
├── standards/
│   └── libraries/
│       ├── prisma.md                       # Database patterns
│       ├── nextjs.md                       # Next.js patterns
│       └── zod.md                          # Validation patterns
├── templates/
│   └── feature-spec.md                     # Spec template
└── validation/
    └── rules.yml                           # Validation rules

.mcp.json                                   # MCP server config
```

### When to Reference Each File

| Task | Reference |
|------|-----------|
| Database operations | `libraries/prisma.md` |
| Building pages/routes | `libraries/nextjs.md` |
| Input validation | `libraries/zod.md` |
| New feature | `templates/feature-spec.md` |
| Understanding "why" | `memory/decisions.md` |
| Naming questions | `memory/glossary.yml` |
| Code review | `validation/rules.yml` |
