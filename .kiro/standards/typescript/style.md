# TypeScript Style Guide

## Purpose

TypeScript-specific style rules that complement ESLint configuration. These rules guide code generation to produce lint-compliant, idiomatic TypeScript.

---

## Type Annotations

### Always Annotate

```typescript
// ✅ Function return types (enforced by ESLint)
function calculateTotal(items: Item[]): number {
  return items.reduce((sum, item) => sum + item.price, 0);
}

// ✅ Exported functions and methods
export function fetchUser(id: string): Promise<User> {
  // ...
}

// ✅ Class properties
class UserService {
  private readonly repository: UserRepository;
  private cache: Map<string, User> = new Map();
}

// ✅ Complex object destructuring
function processConfig({ timeout, retries }: { timeout: number; retries: number }): void {
  // ...
}
```

### Annotation Optional

```typescript
// ✅ Variable with obvious type from initializer
const name = 'John';  // string is obvious
const count = 0;      // number is obvious
const users = [];     // Add type: const users: User[] = [];

// ✅ Arrow functions in callbacks (when type is inferred)
items.map(item => item.name);  // item type inferred from items
```

---

## Type vs Interface

### Prefer `type` for

```typescript
// ✅ Union types
type Status = 'pending' | 'active' | 'completed';

// ✅ Mapped types
type Readonly<T> = { readonly [K in keyof T]: T[K] };

// ✅ Utility type combinations
type UserWithRole = User & { role: Role };

// ✅ Function types
type Handler = (event: Event) => void;

// ✅ Tuple types
type Coordinate = [number, number];
```

### Prefer `interface` for

```typescript
// ✅ Object shapes that may be extended
interface User {
  id: string;
  name: string;
  email: string;
}

// ✅ Class contracts
interface Repository<T> {
  findById(id: string): Promise<T | null>;
  save(entity: T): Promise<T>;
}

// ✅ Declaration merging needs
interface Window {
  customProperty: string;
}
```

### Decision Framework

```
Is it a union/intersection/mapped type? → type
Will it be extended/implemented?       → interface
Is it a function signature?            → type
Is it a simple object shape?           → either (be consistent)
```

---

## Null Handling

### Explicit Null Checks

```typescript
// ✅ Explicit narrowing
function getUser(id: string): User | null {
  const user = users.get(id);
  if (!user) {
    return null;  // Explicit about missing data
  }
  return user;
}

// ✅ Early return pattern
function processUser(user: User | null): void {
  if (!user) {
    throw new UserNotFoundError();
  }
  // user is now narrowed to User
  console.log(user.name);
}
```

### Avoid

```typescript
// ❌ Non-null assertion without validation
const user = getUser(id)!;  // Dangerous

// ❌ Optional chaining without fallback consideration
const name = user?.profile?.name;  // What if undefined?

// ✅ Better: explicit fallback
const name = user?.profile?.name ?? 'Unknown';
```

### Array Access (with noUncheckedIndexedAccess)

```typescript
// With noUncheckedIndexedAccess: true, array access returns T | undefined

// ❌ Assumes element exists
const first = items[0];  // Type: Item | undefined
console.log(first.name); // Error: Object is possibly undefined

// ✅ Check first
const first = items[0];
if (first) {
  console.log(first.name);
}

// ✅ Or use assertion after validation
if (items.length > 0) {
  const first = items[0]!;  // OK: we verified length
}
```

---

## Async/Await

### Always Await or Return

```typescript
// ✅ Await the promise
async function saveUser(user: User): Promise<void> {
  await repository.save(user);
  await cache.invalidate(user.id);
}

// ✅ Return the promise (if not awaiting)
function fetchUser(id: string): Promise<User> {
  return repository.findById(id);  // No async needed
}

// ❌ Floating promise (caught by ESLint)
async function processUser(id: string): Promise<void> {
  fetchUser(id);  // Error: Promise not handled
}
```

### Error Handling

```typescript
// ✅ Try-catch with typed errors
async function fetchData(): Promise<Data> {
  try {
    const response = await api.get('/data');
    return response.data;
  } catch (error) {
    if (error instanceof ApiError) {
      throw new DataFetchError('Failed to fetch data', { cause: error });
    }
    throw error;
  }
}

// ✅ Promise.allSettled for parallel operations that can fail independently
const results = await Promise.allSettled([
  fetchUser(id1),
  fetchUser(id2),
]);
```

---

## Enums vs Union Types

### Prefer Union Types

```typescript
// ✅ String literal union (preferred)
type Status = 'draft' | 'published' | 'archived';

// Benefits:
// - No runtime code generated
// - Better type inference
// - Works with JSON serialization

function updateStatus(status: Status): void {
  // ...
}
```

### Use Const Enum Sparingly

```typescript
// ⚠️ Only when you need numeric values AND iteration
const enum HttpStatus {
  OK = 200,
  NotFound = 404,
  ServerError = 500,
}

// Note: const enum is inlined at compile time
```

### Avoid Regular Enums

```typescript
// ❌ Regular enum generates runtime code
enum Status {
  Draft,
  Published,
  Archived,
}
// Generates: var Status; (function (Status) { ...
```

---

## Generics

### Name Generics Descriptively

```typescript
// ❌ Single letters for complex generics
function transform<T, U, V>(input: T, fn: (x: U) => V): V;

// ✅ Descriptive names
function transform<TInput, TIntermediate, TOutput>(
  input: TInput,
  fn: (x: TIntermediate) => TOutput
): TOutput;

// ✅ Single letter OK for simple, obvious cases
function identity<T>(value: T): T {
  return value;
}
```

### Constrain When Possible

```typescript
// ✅ Constrained generic
function getProperty<T, K extends keyof T>(obj: T, key: K): T[K] {
  return obj[key];
}

// ✅ With default
function createContainer<T = unknown>(value: T): Container<T> {
  return { value };
}
```

---

## Imports

### Import Order

```typescript
// 1. Node built-ins
import { readFile } from 'fs/promises';
import path from 'path';

// 2. External packages
import React from 'react';
import { z } from 'zod';

// 3. Internal aliases (@/*)
import { Button } from '@/components/Button';
import { useAuth } from '@/hooks/useAuth';

// 4. Relative imports
import { helper } from './utils';
import type { Config } from './types';
```

### Type-Only Imports

```typescript
// ✅ Use type imports for types only
import type { User, Role } from './types';
import { UserService } from './services';

// ✅ Inline type imports
import { UserService, type User } from './user';
```

---

## Naming Conventions

| Item | Convention | Example |
|------|------------|---------|
| Variables/functions | camelCase | `getUserById`, `isActive` |
| Classes | PascalCase | `UserService`, `HttpClient` |
| Interfaces | PascalCase | `User`, `Repository` |
| Types | PascalCase | `UserId`, `Status` |
| Enums | PascalCase | `HttpStatus` |
| Constants | SCREAMING_SNAKE | `MAX_RETRIES`, `API_URL` |
| Private fields | camelCase with `private` | `private cache` |
| Boolean variables | `is`/`has`/`can` prefix | `isActive`, `hasPermission` |
| Event handlers | `handle` + Event | `handleClick`, `handleSubmit` |
| Async functions | verb describing action | `fetchUser`, `saveOrder` |

---

## Error Classes

```typescript
// ✅ Custom error classes
class ApplicationError extends Error {
  constructor(
    message: string,
    public readonly code: string,
    public readonly context?: Record<string, unknown>
  ) {
    super(message);
    this.name = this.constructor.name;
  }
}

class ValidationError extends ApplicationError {
  constructor(message: string, context?: Record<string, unknown>) {
    super(message, 'VALIDATION_ERROR', context);
  }
}

// ✅ Usage
throw new ValidationError('Invalid email format', { email, field: 'email' });
```

---

## Comments

### When to Comment

```typescript
// ✅ Complex business logic
// Calculate compound interest using the formula: A = P(1 + r/n)^(nt)
// where P = principal, r = annual rate, n = compounds per year, t = years
function calculateCompoundInterest(
  principal: number,
  rate: number,
  compounds: number,
  years: number
): number {
  return principal * Math.pow(1 + rate / compounds, compounds * years);
}

// ✅ Non-obvious workarounds
// Using setTimeout(0) to defer execution until after React's batch update
setTimeout(() => setCount(count + 1), 0);

// ✅ TODO with context
// TODO(ticket-123): Refactor once new API is available
```

### JSDoc for Public APIs

```typescript
/**
 * Fetches a user by their unique identifier.
 *
 * @param id - The user's unique identifier
 * @returns The user if found, null otherwise
 * @throws {DatabaseError} If the database connection fails
 *
 * @example
 * const user = await fetchUser('user-123');
 * if (user) {
 *   console.log(user.name);
 * }
 */
export async function fetchUser(id: string): Promise<User | null> {
  // ...
}
```

---

## Summary

| Rule | Enforcement |
|------|-------------|
| Explicit return types | ESLint error |
| Prefer `type` for unions | Guideline |
| Prefer `interface` for objects | Guideline |
| Handle null explicitly | ESLint + tsconfig |
| Await all promises | ESLint error |
| Use union types over enums | Guideline |
| Type-only imports | Guideline |
| Descriptive generic names | Guideline |
