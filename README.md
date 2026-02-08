# Claude Plugins

Opinionated Python development standards for Claude Code. Scaffolds projects, enforces coding conventions, and audits compliance automatically.

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
| `detect-rate-limit.sh` | Notification, Stop | Logs rate limit warnings to `~/.claude/rate-limit.log` |

## Project Architecture

Projects scaffolded by `/wf:init` follow this layered structure:

```
src/<package>/
    contracts/         # API schemas (OpenAPI 3.1, OpenRPC 1.3) - single source of truth
    core/              # Infrastructure only: logger, config, exceptions
    models/            # Shared Pydantic domain models
    services/          # Business logic (framework-agnostic)
    interfaces/        # Thin wrappers: cli/ (Typer), rest/ (FastAPI)
```

Development order: **contract -> models -> tests -> implementation**.

## Tech Stack

| Aspect | Tool |
|--------|------|
| Python version | 3.14+ |
| Package manager | uv |
| Build system | Hatchling + hatch-vcs |
| Linter/Formatter | Ruff |
| Type checker | Pyright (strict) |
| Test framework | pytest |
| Documentation | Material for MkDocs + mkdocstrings |
| CLI framework | Typer |
| REST API | FastAPI + uvicorn |
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
# Python 3.14+
uv python install 3.14

# Dev dependencies
uv add --dev pytest ruff pyright pip-audit
```

## File Structure

```
plugins/wf/
    .claude-plugin/
        plugin.json
    .mcp.json
    hooks/
        hooks.json
        detect-rate-limit.sh
    skills/
        audit/                      # /audit command
        audit-config/               # /audit-config command
        audit-mcp/                  # /audit-mcp command
        init/                       # /init command
        simplify/                   # /simplify command
        conventions/                # Background: coding standards
            SKILL.md
            tooling.md              # Tool configurations
            templates.md            # File templates
        documentation/              # Background: docs setup
            SKILL.md
            mkdocs.md               # MkDocs configuration
        git-workflow/               # Background: git conventions
        performance/                # Background: optimization
        project-name/               # Background: name detection
        security/                   # Background: security practices
        spec-driven/                # Background: contracts-first dev
        tdd/                        # Background: test-driven dev
```

## Workflow

[TBD]

## TODO

[ ] https://github.com/upstash/context7/tree/HEAD/plugins/claude/context7
[ ] https://github.com/anthropics/claude-code/tree/main/plugins/plugin-dev
[ ] https://github.com/anthropics/claude-code/tree/main/plugins/ralph-wiggum
[ ] DevContainer
[ ] Tool discovery
[ ] Workflow
[ ] UI skills
[ ] Docker skills
