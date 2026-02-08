# wf

Opinionated Python development standards for Claude Code. Scaffolds projects, enforces coding conventions, and audits compliance automatically.

## Commands

| Command | Description |
|---------|-------------|
| `/init <name> [desc]` | Scaffold a new Python project with full structure and tooling |
| `/audit [category]` | Audit codebase compliance against development guidelines |
| `/audit-config [category]` | Audit `.claude/` directory and plugin structure for best practices |
| `/audit-mcp [server]` | Verify MCP servers are configured and working |
| `/simplify [scope]` | Refine Python code for clarity and consistency |

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

## Project Architecture

Projects scaffolded by `/init` follow this layered structure:

```
src/<package>/
    contracts/         # API schemas (OpenAPI 3.1, OpenRPC 1.3) - single source of truth
    core/              # Infrastructure only: logger, config, exceptions
    models/            # Shared Pydantic domain models
    services/          # Business logic (framework-agnostic)
    interfaces/        # Thin wrappers: cli/ (Typer), rest/ (FastAPI)
```

Development order: **contract -> models -> tests -> implementation**.

## Tooling Stack

| Tool | Purpose |
|------|---------|
| Python 3.14+ | Language version |
| uv | Package manager |
| Ruff | Linting and formatting |
| Pyright | Type checking (strict mode) |
| pytest | Testing with coverage |
| loguru | Logging (never `print()`) |
| Pydantic | Data models and validation |
| Typer | CLI interfaces |
| FastAPI | REST APIs |
| Material for MkDocs | Documentation sites |

## Hooks

- **Rate limit detection** — monitors Notification and Stop events for rate limit indicators, logs to `~/.claude/rate-limit.log`

## MCP Servers

Configured in `.mcp.json`:

| Server | Type | Purpose |
|--------|------|---------|
| serena | stdio | Code intelligence |
| context7 | stdio | Documentation context |
| github | http | GitHub API |
| playwright | stdio | Browser automation |

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
