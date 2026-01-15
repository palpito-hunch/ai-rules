# Project Structure

## Root Organization

```
├── .kiro/           # Kiro configuration (steering, hooks, conventions)
├── docs/            # Project documentation (requirements, design, ADRs)
├── src/             # Frontend source code
├── server/          # Backend code (optional)
├── coverage/        # Test coverage reports (generated)
├── .next/           # Next.js build output (generated)
└── node_modules/    # Dependencies (generated)
```

## Frontend Structure (`src/`)

```
src/
├── components/      # Reusable UI components
│   ├── ui/         # Base UI components (buttons, inputs, etc.)
│   ├── forms/      # Form-specific components
│   └── layout/     # Layout components (header, footer, etc.)
├── pages/          # Next.js pages (file-based routing)
│   └── api/        # API routes
├── hooks/          # Custom React hooks
├── services/       # API clients and external service integrations
├── utils/          # Utility functions and helpers
├── types/          # TypeScript type definitions
└── __tests__/      # Test files
```

## Backend Structure (`server/`)

```
server/
├── routes/         # API route handlers
├── middleware/     # Express middleware
├── models/         # Data models
├── services/       # Business logic layer
└── __tests__/      # Backend tests
```

## Documentation (`docs/`)

```
docs/
├── requirements.md  # EARS format requirements
├── design.md       # Architecture and design decisions
├── tasks.md        # Implementation roadmap
├── adr/            # Architecture Decision Records
└── api/            # API documentation
```

## Configuration Files

- `.kiro/` - Kiro steering, conventions, and automation
- `package.json` - Dependencies and scripts
- `tsconfig.json` - TypeScript configuration
- `next.config.js` - Next.js configuration
- `tailwind.config.js` - Tailwind CSS configuration
- `jest.config.js` - Jest test configuration
- `.eslintrc.json` - ESLint rules
- `.prettierrc` - Prettier formatting rules
- `commitlint.config.js` - Commit message rules
- `docker-compose.yml` - Docker services
- `Dockerfile` - Multi-stage Docker build

## Naming Conventions

- **Components**: PascalCase (e.g., `Button.tsx`, `UserProfile.tsx`)
- **Hooks**: camelCase with `use` prefix (e.g., `useAuth.ts`, `useFetch.ts`)
- **Utils**: camelCase (e.g., `formatDate.ts`, `apiClient.ts`)
- **Types**: PascalCase (e.g., `User.ts`, `ApiResponse.ts`)
- **Test files**: Same name as source with `.test.ts(x)` suffix

## File Colocation

Tests are colocated in `__tests__/` directories at the appropriate level, not scattered throughout the codebase.
