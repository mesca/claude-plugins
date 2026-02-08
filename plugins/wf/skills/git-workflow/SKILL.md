---
name: git-workflow
description: Follow git commit conventions and branching strategies. Use when committing changes, creating branches, or writing commit messages.
user-invocable: false
---

# Git Workflow

## Pre-Commit Checks

Run all checks from the **conventions** skill's Code Review Checklist before every commit:

```bash
uv run ruff check . && uv run ruff format . && uv run pyright && uv run pytest
```

All checks must pass. If any fail, fix before committing.

## Commit Message Format

```
<type>: <subject>

<body>

<footer>
```

### Commit Types

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation only
- **style**: Formatting (no code change)
- **refactor**: Code restructuring (no behavior change)
- **test**: Adding or updating tests
- **perf**: Performance improvements
- **chore**: Build process, dependencies, tooling
- **ci**: CI/CD changes

### Rules

- Subject under 50 characters
- Use imperative mood ("add" not "added")
- No emojis
- Capitalize subject line
- No period at end of subject
- Wrap body at 72 characters
- Reference issues in footer

### Example

```
feat: add data validation module

Add input validation for user-submitted data with support for
common patterns (email, phone, URL). Includes custom validators
and comprehensive error messages.

Closes #123
```

## Branch Naming

- `feature/description` - New features
- `fix/description` - Bug fixes
- `refactor/description` - Code refactoring
- `docs/description` - Documentation updates

## Tool Selection

If GitHub MCP tools are available, use them for PR creation and issue management. Use git CLI for local operations (commit, branch, push). Fall back to `gh` CLI if no MCP is configured.

## Security Checklist

Before every commit, verify:

- [ ] No secrets in staged files (API keys, passwords)
- [ ] No `.env` files staged
- [ ] No large binary files staged

## See Also

- **conventions** — code review checklist and pre-commit quality checks
- **tdd** — test requirements before commit
