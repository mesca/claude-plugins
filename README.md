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
| `/wf:audit-config [category]` | Audit `.claude/` directory and plugin structure for best practices |
| `/wf:audit-mcp [server]` | Verify MCP servers are configured and working |
| `/wf:simplify [scope]` | Refine Python code for clarity and consistency |

**Usage examples:**
```bash
/wf:init my-tool "A CLI tool for data processing"
/wf:simplify
/wf:audit security
/wf:audit code testing
/wf:audit-config plugin
/wf:audit-mcp
```

## Background Skills

These skills are applied automatically by Claude when relevant:

| Skill | Purpose |
|-------|---------|
| **conventions** | Python coding standards: structure, typing, logging, style |
| **simplify** | Code refinement for clarity and consistency |
| **spec-driven** | Contracts-first development with OpenAPI/OpenRPC and models-first workflow |
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

### Install the Plugin

1. **Add the marketplace to Claude Code:**

   Add to your `~/.claude/settings.json`:
   ```json
   {
     "extraKnownMarketplaces": {
       "mesca": {
         "source": {
           "source": "github",
           "repo": "mesca/claude-plugins"
         }
       }
     }
   }
   ```

2. **Enable the plugin:**

   Add to your project's `.claude/settings.json` or global settings:
   ```json
   {
     "enabledPlugins": {
       "wf@mesca": true
     }
   }
   ```

3. **Restart Claude Code** to load the plugin.

### MCP Servers

MCP servers are pre-configured with the plugin.

**Verify MCP setup:**
```bash
/wf:audit-mcp
```

Configured servers:

| Server | Type | Purpose |
|--------|------|---------|
| serena | stdio | Code intelligence |
| context7 | stdio | Documentation context |
| github | http | GitHub API (requires `GITHUB_TOKEN`) |
| playwright | stdio | Browser automation |

### Install Prerequisites

```bash
# Install uv (Python package manager)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install Node.js (for MCP servers)
# macOS
brew install node

# Verify installations
uv --version
node --version
npx --version
```

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
