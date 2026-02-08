# Claude Plugins

## Overview

Claude Plugins is a collection of tools and skills designed to enhance the productivity and efficiency of developers using the Claude AI platform.

### Commands

User-invokable slash commands that run as autonomous subagents.

**Workspace:** `wf` (invoke as `/wf:<command>`)

| Command | Description |
|---------|-------------|
| `/wf:init <name> [description]` | Scaffold a new Python project with standard structure, tooling, and CLI |
| `/wf:simplify` | Simplify and refine Python code for clarity while preserving functionality (opus model) |
| `/wf:compliance-check [category]` | Audit project compliance with coding standards and best practices |
| `/wf:meta-check [category]` | Analyze .claude directory and plugin structure for issues |
| `/wf:mcp-check` | Verify configured MCP servers are working correctly |

**Usage examples:**
```bash
/wf:init my-tool "A CLI tool for data processing"
/wf:simplify
/wf:compliance-check security
/wf:compliance-check code testing
/wf:meta-check plugin
/wf:mcp-check
```

### Auto-Loaded Skills

These skills are automatically applied by Claude Code when relevant - not invokable as commands:

| Skill | Description |
|-------|-------------|
| `conventions` | Project coding conventions (structure, quality, typing, logging, tooling) |
| `documentation` | Documentation with Material for MkDocs and mkdocstrings |
| `tdd` | Test-driven development with pytest |
| `git-workflow` | Git commit conventions and branching strategies |
| `security` | Security best practices (secrets, validation, injection prevention) |
| `performance` | Performance optimization (caching, generators, async) |
| `project-name` | Detect project name from pyproject.toml/package.json |

### Hooks

Automatically triggered hooks:

| Hook | Event | Description |
|------|-------|-------------|
| `detect-rate-limit.sh` | Notification, Stop | Logs rate limit warnings to `~/.claude/rate-limit.log` |

### Tech Stack

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
/wf:mcp-check
```

**Note:** For GitHub MCP, ensure `GITHUB_TOKEN` is set in your environment.

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

## Workflow

[TBD]

### Scaffolding

### Create specs

### Create plan

### Create tasks

### Implement

### Refine

## TODO

[ ] Contracts and models  
[ ] https://github.com/upstash/context7/tree/HEAD/plugins/claude/context7  
[ ] https://github.com/anthropics/claude-code/tree/main/plugins/plugin-dev  
[ ] https://github.com/anthropics/claude-code/tree/main/plugins/ralph-wiggum  
[ ] DevContainer  
[ ] Tool discovery  
[ ] Workflow  
[ ] UI skills  
[ ] Docker skills
