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
- Node.js 20+ 
- npm or yarn

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

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm start` - Start production server
- `npm test` - Run tests
- `npm run lint` - Lint code
- `npm run format` - Format code with Prettier

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

See `.kiro/team-standards.yml` for:
- Code review checklist
- Git workflow
- Commit message format
- Pull request requirements

## 📚 Documentation

- Requirements are documented in EARS format
- Architecture decisions are recorded as ADRs
- API documentation is in `docs/api/`
- Inline code comments explain the "why"

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