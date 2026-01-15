# Tech Stack

## Core Framework

- **Next.js 14** - React framework with SSR/SSG capabilities
- **React 18** - UI library
- **TypeScript 5** - Type-safe JavaScript

## Styling

- **Tailwind CSS 3** - Utility-first CSS framework

## Code Quality

- **ESLint** - Linting with TypeScript, React, and accessibility plugins
- **Prettier** - Code formatting
- **Husky** - Git hooks for pre-commit checks
- **lint-staged** - Run linters on staged files
- **commitlint** - Enforce conventional commit messages

## Testing

- **Jest 29** - Test runner
- **Testing Library** - React component testing
- **jsdom** - DOM environment for tests

## Build & Deploy

- **Docker** - Containerization with multi-stage builds
- **semantic-release** - Automated versioning and releases

## Path Aliases

TypeScript path aliases are configured:

- `@/*` → `./src/*`
- `@components/*` → `./src/components/*`
- `@hooks/*` → `./src/hooks/*`
- `@services/*` → `./src/services/*`
- `@utils/*` → `./src/utils/*`
- `@types/*` → `./src/types/*`

## Common Commands

### Development

```bash
npm run dev          # Start dev server (localhost:3000)
npm run build        # Production build
npm start            # Start production server
```

### Testing

```bash
npm test             # Run tests once
npm run test:watch   # Run tests in watch mode
npm run test:ci      # Run tests with coverage
```

### Code Quality

```bash
npm run lint         # Check for linting errors
npm run lint:fix     # Auto-fix linting errors
npm run format       # Format code with Prettier
npm run format:check # Check formatting
npm run type-check   # TypeScript type checking
npm run validate     # Run all checks (lint + type + test)
```

### Docker

```bash
docker compose up              # Start dev environment
docker compose --profile production up app-prod  # Test production build
```

### Release

```bash
npm run release          # Create release (CI only)
npm run release:dry-run  # Preview release changes
```
