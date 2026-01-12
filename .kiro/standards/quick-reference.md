# Development Standards Quick Reference Card

**For AI-Driven Development with Kira IDE**

---

## 🎯 Priority Hierarchy (When Rules Conflict)

```
P0 - CRITICAL (Always First)
├── Financial Safety → Transactions, race conditions, balance consistency
└── Type Safety → Explicit types, null handling, input validation

P1 - HIGH (Unless Conflicts with P0)
├── SOLID Principles → Clean architecture, maintainability
└── DRY → Single source of truth, no duplication

P2 - MEDIUM (Only When Measured Need)
└── Performance → Profile first, optimize only bottlenecks
```

**Decision Rule**: When uncertain, choose safety and clarity over brevity and performance.

---

## âš¡ Critical Rules (NEVER Violate)

### Financial Safety
```typescript
// ✅ ALWAYS: All balance changes in transactions
await prisma.$transaction(async (tx) => {
  const user = await tx.user.findUnique({ where: { id } }); // Fresh data
  await tx.user.update({ ... });                             // Atomic update
  await tx.trade.create({ ... });                            // Related data
});

// ❌ NEVER: Operations outside transaction
const user = await getUser(id);  // TOCTOU vulnerability!
await updateBalance(id, amount);
```

### Race Conditions
```typescript
// ✅ ALWAYS: Validation inside transaction
await prisma.$transaction(async (tx) => {
  const market = await tx.market.findUnique({ where: { id } });
  if (market.resolved) throw new Error(); // Check with fresh data
  await tx.market.update({ ... });
});

// ❌ NEVER: Check outside, use inside
const market = await getMarket(id);
if (market.resolved) throw new Error(); // Stale data!
await prisma.$transaction(async (tx) => {
  await tx.market.update({ ... }); // Race condition possible
});
```

### Variable Initialization
```typescript
// ✅ ALWAYS: Initial value for reduce()
const sum = array.reduce((acc, val) => acc + val, 0);
const max = array.reduce((m, v) => v > m ? v : m, array[0]!);

// ❌ NEVER: reduce() without initial value
const sum = array.reduce((acc, val) => acc + val); // Breaks on empty array
```

---

## 🚨 Red Flags (Auto-Reject in Code Review)

| Pattern | Issue | Fix |
|---------|-------|-----|
| `await prisma.*.update()` outside `$transaction()` | Financial operation not atomic | Wrap in transaction |
| `array.reduce(...)` with 1 parameter | Crashes on empty array | Add initial value |
| `throw new Error('Invalid')` | Non-actionable error | Use specific error class with context |
| `function foo(...)` without return type | Type safety | Add `: ReturnType` |
| Database query in `for` loop | N+1 problem | Use batch query with `in` |
| `const market = await getMarket(id)` then use in transaction | TOCTOU | Fetch inside transaction |

---

## ✅ ALWAYS Do

### Transactions
- ✅ All database writes in transactions
- ✅ Fetch fresh data inside transaction
- ✅ Related updates in same transaction

### Error Handling
```typescript
// ✅ Structure
throw new BusinessLogicError(
  'User balance ($10.50) insufficient for trade ($15.00)',
  'INSUFFICIENT_BALANCE',
  { userId, currentBalance, requiredAmount, shortfall }
);
```

### Types
- ✅ Explicit return types: `function foo(): ReturnType`
- ✅ Validate inputs at boundaries
- ✅ Handle null/undefined explicitly

### Testing
- ✅ Race condition tests for concurrent operations
- ✅ Property-based tests for financial calculations
- ✅ Integration tests for complex workflows

---

## ❌ When NOT to Apply

### DRY
**Skip if:**
- Different business concepts (despite similar code)
- Only 2 occurrences, unlikely to grow
- Extraction reduces clarity significantly

```typescript
// ❌ DON'T extract - different concepts
validateMarketTitle(title); // Min 5 chars
validateOutcomeName(name);  // Min 2 chars
// May diverge in future
```

### Dependency Injection
**Skip if:**
- Pure calculation (no side effects)
- Simple utility, one use case
- Would add complexity without benefit

```typescript
// ❌ DON'T inject - pure function
function calculatePercentage(value: number, total: number): number {
  return (value / total) * 100;
}
```

### Transactions
**Skip if:**
- Read-only operations
- Single atomic database operation
- Logging/analytics (eventual consistency OK)

```typescript
// ✅ OK without transaction - just reading
const market = await prisma.market.findUnique({ where: { id } });
```

### Optimization
**Skip if:**
- Operation <100ms and infrequent
- Would significantly reduce clarity
- Haven't profiled to confirm bottleneck

---

## 🔍 Common Scenarios

### Scenario: Should I extract this duplicate code?
```
1. Same concept? NO → Don't extract
2. Used 3+ times? NO → Wait for third use
3. Reduces clarity? YES → Don't extract
4. All above pass? → Extract
```

### Scenario: Should I use a transaction?
```
1. Modifying data? NO → No transaction
2. Financial operation? YES → USE TRANSACTION
3. Multiple related changes? YES → USE TRANSACTION
4. Single atomic write? → Optional but safe
```

### Scenario: Should I optimize?
```
1. N+1 or query in loop? YES → FIX IMMEDIATELY
2. Missing index? YES → FIX IMMEDIATELY
3. Operation >100ms + frequent? → Profile first
4. Operation <100ms? → Don't optimize
```

---

## 📁 File Organization

```
src/
├── services/           # Business logic
│   ├── __tests__/
│   └── *.service.ts
├── repositories/       # Data access
│   └── *.repository.ts
├── utils/             # Pure functions
│   └── *.util.ts
├── types/             # TypeScript types
│   └── *.types.ts
└── errors/            # Custom errors
    └── *.error.ts
```

**Naming:**
- Files: `kebab-case.type.ts` (e.g., `market.service.ts`)
- Classes: `PascalCase` (e.g., `MarketService`)
- Functions: `camelCase` (e.g., `calculatePrice`)
- Constants: `SCREAMING_SNAKE_CASE` (e.g., `MAX_TRADE_AMOUNT`)
- Booleans: `isActive`, `hasBalance`, `canTrade`

**Size Limits:**
- Soft: 300 lines → Consider splitting
- Hard: 500 lines → Must split

---

## 💬 Comments

### ✅ ALWAYS Comment
- Complex algorithms (explain approach)
- Non-obvious business rules
- Race condition prevention strategies
- Performance optimizations (with measurements)
- Security considerations

```typescript
// ✅ GOOD - Explains WHY
// Fetch inside transaction to prevent TOCTOU race condition.
// Market could be resolved between check and update if fetched outside.
await prisma.$transaction(async (tx) => {
  const market = await tx.market.findUnique({ where: { id } });
  if (market.resolved) throw new Error();
});
```

### ❌ NEVER Comment
- What code does (make code self-explanatory)
- Variable declarations (use descriptive names)
- Obvious operations
- Instead of fixing bad code

```typescript
// ❌ BAD - States obvious
// Calculate total price
const totalPrice = quantity * unitPrice;
```

---

## ⚡ Performance

### ALWAYS Fix
- N+1 query problems
- Database queries in loops
- Missing indexes on frequently queried columns
- Loading unnecessary data
- O(n²) when O(n) is simple

### Profile Before Optimizing
- Operations <100ms
- Infrequently called code
- When optimization reduces clarity

### Never Optimize
- Without measuring bottleneck
- At expense of safety/correctness
- Before verifying it's actually slow

---

## 🧪 Testing Requirements

### Required Tests
- Unit tests for business logic
- Integration tests for database operations
- **Race condition tests for concurrent operations**
- Property-based tests for financial calculations

### Race Condition Test Pattern
```typescript
test('should prevent double resolution', async () => {
  const attempts = Array.from({ length: 5 }, () =>
    service.resolveMarket(marketId, outcome)
  );
  
  const results = await Promise.allSettled(attempts);
  const successes = results.filter(r => r.status === 'fulfilled');
  
  expect(successes.length).toBe(1); // Only one should succeed
});
```

---

## 🎯 Kira IDE Quick Commands

```bash
# Load core specs
@specs/core/priority-framework.md
@specs/core/coding-standards.md
@specs/core/when-not-to-apply.md

# Create service
@kira create service --spec=feature-spec.md

# Review code
@kira review --spec=code-review.md --strict

# Fix race conditions
@kira fix --spec=race-conditions.md

# Optimize (after profiling!)
@kira optimize --spec=performance.md --profile-first
```

---

## ✅ Pre-Commit Checklist

```
Before committing, verify:
[ ] ESLint: 0 warnings (npm run lint:strict)
[ ] TypeScript: no errors (tsc --noEmit)
[ ] All tests passing (npm test)
[ ] All reduce() have initial values
[ ] DB writes inside transactions
[ ] Errors follow standards (message + code + context)
[ ] Functions have return types
[ ] Race condition tests for concurrent operations
```

---

## 🆘 When in Doubt

### Decision Framework
1. **Safety first** → Choose safer option
2. **Explicit over implicit** → Add null checks
3. **Clarity over brevity** → Write clearer code
4. **Simple over complex** → Choose simpler approach
5. **Measure over guess** → Profile before optimizing
6. **Ask** → Clarify business requirements

### Quick Decisions
- **Unknown nullability?** → Add explicit check
- **Unsure about transaction?** → Use transaction (safer)
- **DRY or not?** → Wait for third occurrence
- **Optimize or not?** → Profile first
- **Comment or not?** → Only if explains WHY

---

## 📚 Standards Documents Map

**Core (Load Always)**
- `ai-development-priority-framework.md` - Decision rules
- `coding-standards.md` - SOLID, DRY, patterns
- `when-not-to-apply-patterns.md` - Negative examples

**Domain (Load by Context)**
- `error-message-standards.md` - Error handling
- `file-organization-standards.md` - Project structure
- `comment-standards.md` - Documentation
- `performance-standards.md` - Optimization

**Workflows (Load by Task)**
- `code-review-checklist.md` - Review process
- `race-condition-checklist.md` - Concurrent safety
- `test-execution-guidelines.md` - Testing

---

## 🎓 Remember

**The Mantra:**
> "Make it work, make it right, make it fast - in that order"

**The Priority:**
> Safety > Correctness > Maintainability > Performance

**The Goal:**
> Code that's easy to understand, modify, and doesn't lose money

---

**Print this card and keep it visible during development!**