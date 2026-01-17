# TypeScript Architecture Patterns

## Purpose

TypeScript-specific architectural patterns and conventions. These complement the language-agnostic principles in `core/priority-framework.md`.

---

## Project Structure

### Recommended Layout

```
src/
├── components/          # React components (if frontend)
│   ├── ui/             # Generic UI components
│   ├── forms/          # Form-specific components
│   └── layout/         # Layout components
├── pages/              # Page components / routes
├── services/           # Business logic layer
│   ├── __tests__/      # Co-located tests
│   └── *.service.ts
├── repositories/       # Data access layer
│   └── *.repository.ts
├── hooks/              # Custom React hooks
├── utils/              # Pure utility functions
├── types/              # Shared type definitions
│   ├── domain/         # Business domain types
│   └── api/            # API request/response types
├── errors/             # Custom error classes
├── config/             # Configuration loading
└── index.ts            # Main entry point
```

### File Naming

```
kebab-case.purpose.ts

Examples:
- user.service.ts       # Service
- user.repository.ts    # Repository
- user.types.ts         # Types
- user.test.ts          # Test
- use-user.ts           # Hook (React convention)
- UserCard.tsx          # React component (PascalCase)
```

---

## Layered Architecture

### Layer Responsibilities

```
┌─────────────────────────────────────────────┐
│  Controllers / Handlers / Components        │  ← HTTP/UI layer
│  - Input validation                         │
│  - Response formatting                      │
│  - Error translation                        │
├─────────────────────────────────────────────┤
│  Services                                   │  ← Business logic
│  - Business rules                           │
│  - Orchestration                            │
│  - Transaction boundaries                   │
├─────────────────────────────────────────────┤
│  Repositories                               │  ← Data access
│  - Database queries                         │
│  - External API calls                       │
│  - Caching                                  │
├─────────────────────────────────────────────┤
│  Domain Types / Entities                    │  ← Core types
│  - Business entities                        │
│  - Value objects                            │
└─────────────────────────────────────────────┘
```

### Dependency Direction

```typescript
// ✅ Dependencies flow downward
// Controllers → Services → Repositories → Types

// ❌ Never import upward
// Repository should NOT import from Service
// Service should NOT import from Controller
```

---

## Service Pattern

### Structure

```typescript
// user.service.ts
import { UserRepository } from '@/repositories/user.repository';
import { User, CreateUserInput } from '@/types/domain/user';
import { ValidationError, NotFoundError } from '@/errors';

export class UserService {
  constructor(private readonly userRepository: UserRepository) {}

  async createUser(input: CreateUserInput): Promise<User> {
    // Validation
    this.validateCreateInput(input);

    // Business logic
    const existingUser = await this.userRepository.findByEmail(input.email);
    if (existingUser) {
      throw new ValidationError('Email already registered', {
        field: 'email',
        value: input.email,
      });
    }

    // Persistence
    return this.userRepository.create(input);
  }

  async getUserById(id: string): Promise<User> {
    const user = await this.userRepository.findById(id);
    if (!user) {
      throw new NotFoundError('User', id);
    }
    return user;
  }

  private validateCreateInput(input: CreateUserInput): void {
    if (!input.email.includes('@')) {
      throw new ValidationError('Invalid email format', {
        field: 'email',
        value: input.email,
      });
    }
  }
}
```

### Guidelines

- One service per domain concept
- Services contain business logic, not data access
- Services can call other services (but be careful of cycles)
- Keep services stateless when possible

---

## Repository Pattern

### Structure

```typescript
// user.repository.ts
import { prisma } from '@/lib/prisma';
import { User, CreateUserInput } from '@/types/domain/user';

export class UserRepository {
  async findById(id: string): Promise<User | null> {
    return prisma.user.findUnique({
      where: { id },
    });
  }

  async findByEmail(email: string): Promise<User | null> {
    return prisma.user.findUnique({
      where: { email },
    });
  }

  async create(input: CreateUserInput): Promise<User> {
    return prisma.user.create({
      data: input,
    });
  }

  async update(id: string, data: Partial<User>): Promise<User> {
    return prisma.user.update({
      where: { id },
      data,
    });
  }
}
```

### Guidelines

- Repositories only handle data access
- No business logic in repositories
- Return domain types, not ORM models (map if needed)
- One repository per aggregate root

---

## Dependency Injection

### Manual DI (Recommended for Most Projects)

```typescript
// composition-root.ts
import { PrismaClient } from '@prisma/client';
import { UserRepository } from '@/repositories/user.repository';
import { UserService } from '@/services/user.service';
import { OrderService } from '@/services/order.service';

export function createServices(prisma: PrismaClient) {
  const userRepository = new UserRepository(prisma);
  const userService = new UserService(userRepository);

  const orderRepository = new OrderRepository(prisma);
  const orderService = new OrderService(orderRepository, userService);

  return {
    userService,
    orderService,
  };
}

// Usage
const prisma = new PrismaClient();
const services = createServices(prisma);
```

### When to Skip DI

```typescript
// ✅ Skip DI for pure functions
export function calculateTax(amount: number, rate: number): number {
  return amount * rate;
}

// ✅ Skip DI for simple utilities
export function formatDate(date: Date): string {
  return date.toISOString().split('T')[0];
}

// ✅ Skip DI for constant configuration
export const CONFIG = {
  apiUrl: process.env.API_URL,
  timeout: 5000,
};
```

---

## Error Handling Architecture

### Error Hierarchy

```typescript
// errors/base.ts
export class ApplicationError extends Error {
  constructor(
    message: string,
    public readonly code: string,
    public readonly statusCode: number = 500,
    public readonly context?: Record<string, unknown>
  ) {
    super(message);
    this.name = this.constructor.name;
    Error.captureStackTrace(this, this.constructor);
  }

  toJSON() {
    return {
      error: this.code,
      message: this.message,
      ...(this.context && { details: this.context }),
    };
  }
}

// errors/domain.ts
export class ValidationError extends ApplicationError {
  constructor(message: string, context?: Record<string, unknown>) {
    super(message, 'VALIDATION_ERROR', 400, context);
  }
}

export class NotFoundError extends ApplicationError {
  constructor(entity: string, id: string) {
    super(`${entity} not found: ${id}`, 'NOT_FOUND', 404, { entity, id });
  }
}

export class ConflictError extends ApplicationError {
  constructor(message: string, context?: Record<string, unknown>) {
    super(message, 'CONFLICT', 409, context);
  }
}

export class UnauthorizedError extends ApplicationError {
  constructor(message = 'Unauthorized') {
    super(message, 'UNAUTHORIZED', 401);
  }
}
```

### Error Translation at Boundaries

```typescript
// In API handler
export async function handleRequest(req: Request): Promise<Response> {
  try {
    const result = await userService.createUser(req.body);
    return Response.json(result, { status: 201 });
  } catch (error) {
    if (error instanceof ApplicationError) {
      return Response.json(error.toJSON(), { status: error.statusCode });
    }
    // Log unexpected errors, return generic message
    console.error('Unexpected error:', error);
    return Response.json(
      { error: 'INTERNAL_ERROR', message: 'An unexpected error occurred' },
      { status: 500 }
    );
  }
}
```

---

## Module Organization

### Barrel Exports (Use Sparingly)

```typescript
// ✅ Good: Explicit exports for public API
// services/index.ts
export { UserService } from './user.service';
export { OrderService } from './order.service';
export type { CreateUserInput } from './user.service';

// ❌ Avoid: Re-exporting everything
export * from './user.service';
export * from './order.service';
// This can lead to circular dependencies and bundle bloat
```

### Feature-Based Organization (Alternative)

```typescript
// For larger applications, consider feature-based organization
src/
├── features/
│   ├── users/
│   │   ├── user.service.ts
│   │   ├── user.repository.ts
│   │   ├── user.types.ts
│   │   ├── user.controller.ts
│   │   └── __tests__/
│   ├── orders/
│   │   └── ...
│   └── products/
│       └── ...
├── shared/
│   ├── errors/
│   ├── utils/
│   └── types/
└── infrastructure/
    ├── database/
    └── http/
```

---

## React-Specific Patterns

### Component Architecture

```typescript
// ✅ Separate concerns
// UserCard.tsx - Presentation
export function UserCard({ user, onEdit }: UserCardProps): JSX.Element {
  return (
    <div>
      <h2>{user.name}</h2>
      <button onClick={() => onEdit(user.id)}>Edit</button>
    </div>
  );
}

// UserCardContainer.tsx - Logic
export function UserCardContainer({ userId }: { userId: string }): JSX.Element {
  const { data: user, isLoading } = useUser(userId);
  const navigate = useNavigate();

  if (isLoading) return <Skeleton />;
  if (!user) return <NotFound />;

  return <UserCard user={user} onEdit={(id) => navigate(`/users/${id}/edit`)} />;
}
```

### Custom Hooks

```typescript
// hooks/use-user.ts
export function useUser(id: string) {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    let cancelled = false;

    async function fetchUser(): Promise<void> {
      try {
        setIsLoading(true);
        const data = await userService.getUserById(id);
        if (!cancelled) {
          setUser(data);
        }
      } catch (err) {
        if (!cancelled) {
          setError(err instanceof Error ? err : new Error('Unknown error'));
        }
      } finally {
        if (!cancelled) {
          setIsLoading(false);
        }
      }
    }

    fetchUser();

    return () => {
      cancelled = true;
    };
  }, [id]);

  return { user, isLoading, error };
}
```

---

## API Client Pattern

```typescript
// lib/api-client.ts
class ApiClient {
  constructor(private readonly baseUrl: string) {}

  async get<T>(path: string): Promise<T> {
    const response = await fetch(`${this.baseUrl}${path}`);
    if (!response.ok) {
      throw await this.handleError(response);
    }
    return response.json();
  }

  async post<T>(path: string, body: unknown): Promise<T> {
    const response = await fetch(`${this.baseUrl}${path}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body),
    });
    if (!response.ok) {
      throw await this.handleError(response);
    }
    return response.json();
  }

  private async handleError(response: Response): Promise<ApplicationError> {
    const body = await response.json().catch(() => ({}));
    return new ApplicationError(
      body.message || 'API request failed',
      body.code || 'API_ERROR',
      response.status
    );
  }
}

export const apiClient = new ApiClient(process.env.API_URL!);
```

---

## Summary

| Pattern | When to Use |
|---------|-------------|
| Services | Business logic, orchestration |
| Repositories | Data access, external APIs |
| Manual DI | Most projects (simple, explicit) |
| Container DI | Large projects with many dependencies |
| Barrel exports | Public module APIs only |
| Feature folders | Large applications (10+ features) |
| Hooks | React state + effects |
| API Client | Centralized HTTP handling |
