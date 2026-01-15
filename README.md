# Kiro Project Template

A well-structured project template following Kiro best practices for modern web development.

## 🏗️ Project Structure

This template follows the recommended Kiro project structure:

```
├── .kiro/                  # Kiro configuration and automation
├── docs/                   # Project documentation (EARS requirements, ADRs)
├── src/                    # Frontend source code
├── server/                 # Backend code
└── Configuration files
```

## 🚀 Getting Started

### Prerequisites

- Node.js 22+
- npm or yarn
- Docker and Docker Compose (optional, for containerized development)

### Installation

1. **Use this template** by clicking "Use this template" button above
2. **Clone your new repository**

   ```bash
   git clone https://github.com/your-username/your-project.git
   cd your-project
   ```

3. **Install dependencies**

   ```bash
   npm install
   ```

4. **Set up environment variables**

   ```bash
   cp .env.example .env
   # Edit .env with your actual values
   ```

5. **Start development server**
   ```bash
   npm run dev
   ```

## 📁 Directory Overview

### `.kiro/`

Kiro configuration files that define project context, personas, conventions, and automation hooks.

- `steering.yml` - Project context and preferences
- `personas.yml` - AI agent personalities for different roles
- `conventions.yml` - Code style and naming patterns
- `team-standards.yml` - Collaboration and review standards
- `hooks/` - Automation hooks for testing, security, and performance

### `docs/`

Project documentation using industry-standard formats.

- `requirements.md` - EARS format requirements
- `design.md` - Architecture and design decisions
- `tasks.md` - Implementation roadmap
- `adr/` - Architecture Decision Records
- `api/` - API documentation

### `src/`

Frontend source code with clear separation of concerns.

- `components/` - Reusable UI components (ui, forms, layout)
- `pages/` - Page-level components
- `hooks/` - Custom React hooks
- `services/` - API clients and external services
- `utils/` - Utility functions
- `types/` - TypeScript type definitions
- `__tests__/` - Test files

### `server/`

Backend code (if your project needs a backend).

- `routes/` - API route handlers
- `middleware/` - Express middleware
- `models/` - Data models
- `services/` - Business logic layer
- `__tests__/` - Backend tests

## 🛠️ Available Scripts

| Script                 | Description                             |
| ---------------------- | --------------------------------------- |
| `npm run dev`          | Start development server                |
| `npm run build`        | Build for production                    |
| `npm start`            | Start production server                 |
| `npm test`             | Run tests                               |
| `npm run test:watch`   | Run tests in watch mode                 |
| `npm run test:ci`      | Run tests with coverage                 |
| `npm run lint`         | Check code for linting errors           |
| `npm run lint:fix`     | Auto-fix linting errors                 |
| `npm run format`       | Format code with Prettier               |
| `npm run format:check` | Check code formatting                   |
| `npm run type-check`   | Run TypeScript type checking            |
| `npm run validate`     | Run all checks (lint, type-check, test) |

## 🐳 Docker

### Development with Docker

Start the development environment with hot reloading:

```bash
docker compose up
```

The app will be available at http://localhost:3000 with hot reloading enabled.

### Production Build

Test the production build locally:

```bash
docker compose --profile production up app-prod
```

### Building Images

```bash
# Development image
docker build --target development -t kiro-app:dev .

# Production image
docker build --target runner -t kiro-app:prod .
```

### Docker Commands

| Command                           | Description              |
| --------------------------------- | ------------------------ |
| `docker compose up`               | Start development server |
| `docker compose up -d`            | Start in detached mode   |
| `docker compose down`             | Stop all containers      |
| `docker compose logs -f`          | View logs                |
| `docker compose build --no-cache` | Rebuild images           |

### Health Check

The application exposes a health endpoint at `/api/health` for container orchestration.

## 📝 Development Workflow

1. **Check requirements** in `docs/requirements.md`
2. **Review design** in `docs/design.md`
3. **Pick a task** from `docs/tasks.md`
4. **Create a branch** following naming convention: `type/description`
5. **Write code** following conventions in `.kiro/conventions.yml`
6. **Write tests** alongside your code
7. **Commit** using conventional commits format
8. **Submit PR** with description linking to the task

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed information on:

- Development environment setup
- Code quality tools (ESLint, Prettier, TypeScript)
- Git hooks and commit conventions
- Pull request process
- CI/CD pipeline

For team-specific standards, see `.kiro/team-standards.yml`.

## 📚 Documentation

- Requirements are documented in EARS format
- Architecture decisions are recorded as ADRs
- API documentation is in `docs/api/`
- Inline code comments explain the "why"

## 🔄 Syncing Standards from Template

Repositories created from this template automatically inherit a workflow to sync standards updates.

### How It Works

The `sync-from-template.yml` workflow:

1. Runs weekly (Mondays at 9am UTC) or on-demand
2. Fetches the latest `.kiro/` and `CLAUDE.md` from this template
3. Creates a PR if changes are detected

### Private Template Setup

If the template repository is private, downstream repos need a PAT to fetch from it:

1. Create a PAT with `repo` scope
2. Add it as a secret named `TEMPLATE_PAT` in each downstream repo

### Manual Sync

Trigger manually in your repo: **Actions** → **Sync Standards from Template** → **Run workflow**

### Customization

To change the sync schedule, edit `.github/workflows/sync-from-template.yml` in your repo:

```yaml
on:
  schedule:
    - cron: '0 9 * * 1' # Change this cron expression
```

### Opting Out

To stop syncing, delete `.github/workflows/sync-from-template.yml` from your repo.

## 🏷️ Semantic Versioning

This project uses [semantic-release](https://semantic-release.gitbook.io/) for automated versioning.

### How It Works

1. Push to `main` triggers the release workflow
2. Commits are analyzed to determine version bump
3. Version is updated, changelog generated, GitHub release created

### Version Bump Rules

| Commit Type        | Version Bump  | Example                    |
| ------------------ | ------------- | -------------------------- |
| `feat:`            | Minor (1.x.0) | New feature                |
| `fix:`             | Patch (1.0.x) | Bug fix                    |
| `perf:`            | Patch (1.0.x) | Performance improvement    |
| `BREAKING CHANGE:` | Major (x.0.0) | Breaking change            |
| `docs:`, `chore:`  | No release    | Documentation, maintenance |

### For Downstream Repos

Each repository created from this template has its own independent version. The versioning configuration is inherited but versions are tracked separately per repo.

### Slack Release Notifications

The release workflow can notify a Slack channel when a new version is published.

#### Configuration

Add these to your repository settings:

| Type         | Name                     | Value                          |
| ------------ | ------------------------ | ------------------------------ |
| **Secret**   | `SLACK_WEBHOOK_URL`      | Slack incoming webhook URL     |
| **Variable** | `SLACK_RELEASES_CHANNEL` | Channel name (e.g., `#releases`) |

#### Creating a Slack Webhook

1. Go to [Slack API: Apps](https://api.slack.com/apps)
2. Create a new app (or use existing) → **Incoming Webhooks**
3. Activate incoming webhooks and add one to your workspace
4. Copy the webhook URL and add it as `SLACK_WEBHOOK_URL` secret

#### Notification Format

When a release is published, Slack receives a formatted message:

```
🚀 New Release Published
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Repository:  your-org/your-repo
Version:     v1.2.0
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Released via GitHub Actions
```

#### Opting Out

Notifications are disabled by default. Simply don't configure the `SLACK_RELEASES_CHANNEL` variable to skip notifications.

## 🔒 Security

Security scanning is automated via Kiro hooks:

- Pre-commit secret scanning
- Dependency auditing
- Regular security reviews

## 📄 License

[Your License Here]

## 🙏 Acknowledgments

- Built with [Kiro](https://kiro.directory) best practices
- Structure inspired by modern web development standards
