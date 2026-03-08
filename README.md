# Claude Plugins

Opinionated Python development standards for Claude Code. Scaffolds projects, enforces coding conventions, and audits compliance automatically.

## Constitution

Core principles injected at every session start. Non-negotiable.

**Development loop** — always follow this sequence, never skip steps:

**contract → models → tests → implementation → simplify → documentation → audit**

**Interface design** — every interface (CLI, API, web) must be designed from the end-user perspective: obvious mental model, simple, intuitive, consistent, explicit.

## Commands

User-invokable slash commands that run as autonomous subagents.

| Command | Description |
|---------|-------------|
| `/wf:init <name> [desc]` | Scaffold a new Python project with full structure and tooling |
| `/wf:audit [category]` | Audit codebase compliance against development guidelines |
| `/wf:simplifier [scope]` | Refine Python code for clarity and consistency |

**Usage examples:**
```bash
/wf:init my-tool "A CLI tool for data processing"
/wf:simplifier
/wf:audit security
/wf:audit code testing
```

## Background Skills

These skills are applied automatically by Claude when relevant:

| Skill | Purpose |
|-------|---------|
| **conventions** | Python coding standards: structure, typing, logging, style |
| **simplifier** | Code refinement for clarity and consistency |
| **spec-driven** | Contracts-first development with OpenAPI/OpenRPC/docopt and models-first workflow |
| **tdd** | Test-driven development: red-green-refactor with pytest |
| **security** | Secrets management, input validation, injection prevention |
| **performance** | Profiling, caching, memory optimization, async patterns |
| **documentation** | Material for MkDocs setup and API doc generation |
| **git-workflow** | Commit conventions, branch naming, pre-commit checks |
| **project-name** | Detects and normalizes `${PROJECT_NAME}` from pyproject.toml |

## Hooks

| Hook | Event | Description |
|------|-------|-------------|
| `load-constitution.sh` | SessionStart | Injects constitution into every session |
| `detect-rate-limit.sh` | Notification, Stop | Logs rate limit warnings to `~/.claude/rate-limit.log` |

## Project Architecture

Projects scaffolded by `/wf:init` follow this layered structure:

```
src/<package>/
    contracts/         # API schemas (OpenAPI 3.1, OpenRPC 1.3, docopt) — single source of truth
    core/              # Infrastructure only: logger, config, exceptions
    models/            # Shared Pydantic domain models
    services/          # Business logic (framework-agnostic)
    interfaces/        # Thin wrappers: cli/ (Typer), rest/ (FastAPI), rpc/ (JSON-RPC/WebSocket)
```

## Tech Stack

| Aspect | Tool |
|--------|------|
| Python version | 3.13+ |
| Package manager | uv |
| Build system | Hatchling + hatch-vcs |
| Linter/Formatter | Ruff |
| Type checker | Pyright (strict) |
| Test framework | pytest |
| Property-based testing | hypothesis |
| Documentation | Material for MkDocs + mkdocstrings |
| CLI framework | Typer |
| REST API | FastAPI + uvicorn |
| JSON-RPC / WebSocket | jsonrpc-websocket, websockets |
| Simple websites | FastAPI + Jinja2 + HTMX |
| Logging | loguru |

## Setup

### Prerequisites

#### System Dependencies

**macOS** (via Homebrew):

```bash
brew install node uv
```

**Linux** (Debian/Ubuntu):

```bash
# Node.js (via NodeSource)
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs

# uv
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**Linux** (Fedora/RHEL):

```bash
sudo dnf install nodejs
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Verify installations:

```bash
node --version && npx --version && uv --version && uvx --version
```

#### Companion Plugins

Install from the official Anthropic Claude Plugins marketplace (run inside Claude Code):

```
/plugin install serena@claude-plugins-official
/plugin install context7@claude-plugins-official
/plugin install github@claude-plugins-official
/plugin install playwright@claude-plugins-official
/plugin install claude-md-management@claude-plugins-official
/plugin install ralph-loop@claude-plugins-official
```

These plugins configure their MCP servers automatically.

The **github** plugin requires a `GITHUB_PERSONAL_ACCESS_TOKEN` environment variable:

1. Create a token at https://github.com/settings/tokens (Fine-grained or Classic)
2. Add to your shell profile (`~/.zshrc` or `~/.bashrc`):
   ```bash
   export GITHUB_PERSONAL_ACCESS_TOKEN="ghp_..."
   ```
3. Reload your shell (`source ~/.zshrc`) before launching Claude Code.

### Install the Plugin

Inside Claude Code:

```
/plugin marketplace add mesca/claude-plugins
/plugin install wf@mesca-claude-plugins
```

Restart Claude Code to load the plugin.

### Project Setup

For new projects, use the init command:
```bash
/wf:init my-project "My project description"
cd my-project
uv sync --all-groups
```

For existing projects, ensure you have:
```bash
# Python 3.13+
uv python install 3.13

# Dev dependencies
uv add --dev pytest ruff pyright pip-audit hypothesis
```

## TODO

- [ ] UI skills
- [ ] Docker skills
- [ ] Git worktree rules
