---
name: git-workflow
description: Follow git commit conventions and branching strategies. Use when committing changes, creating branches, or writing commit messages to maintain consistent version control practices.
command: false
---

# Git Workflow Skill

Follow git conventions for commits, branches, and version control. Uses GitHub MCP if configured, otherwise falls back to CLI tools.

## When to Use This Skill

✅ **Use when:**
- Committing changes to git
- Creating commit messages
- Creating or naming branches
- Preparing pull requests
- Writing release notes

❌ **Don't use when:**
- Just staging files (git add)
- Viewing git history
- Resolving merge conflicts
- Rebasing or cherry-picking

## Tool Selection

Check for GitHub MCP availability:

```
If mcp__github__* tools available:
  → Use GitHub MCP for PR creation, issue management
  → Use git CLI for local operations (commit, branch, push)
Else:
  → Use git CLI + gh CLI for all operations
```

## Pre-Commit Checks

**ALWAYS run these checks before committing:**

```bash
# 1. Lint and format
uv run ruff check .
uv run ruff format .

# 2. Type checking (REQUIRED)
uv run pyright

# 3. Security audit
uv run pip-audit

# 4. Run tests
uv run pytest

# 5. Check coverage
uv run pytest --cov=src
```

**All checks must pass before committing.** If any fail:
- Fix linting issues: `uv run ruff check --fix .`
- Fix type errors before proceeding
- Address security vulnerabilities
- Fix failing tests

## Commit Message Format

```
<type>: <subject>

<body>

<footer>
```

## Commit Types

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation only
- **style**: Formatting (no code change)
- **refactor**: Code restructuring (no behavior change)
- **test**: Adding or updating tests
- **perf**: Performance improvements
- **chore**: Build process, dependencies, tooling
- **ci**: CI/CD changes

## Rules

- Subject under 50 characters
- Use imperative mood (add not added)
- No emojis
- Capitalize subject line
- No period at end of subject
- Wrap body at 72 characters
- Reference issues in footer

## Example

```
feat: add data validation module

Add input validation for user-submitted data with support for
common patterns (email, phone, URL). Includes custom validators
and comprehensive error messages.

- Email validation with RFC 5322 compliance
- Phone number validation with international format
- URL validation with protocol and domain checks

Closes #123
```

## Branch Naming

- `feature/description` - New features
- `fix/description` - Bug fixes
- `refactor/description` - Code refactoring
- `docs/description` - Documentation updates

## Workflow: Using GitHub MCP

When GitHub MCP is configured:

```python
# Check MCP availability
# If mcp__github__* tools are available, use them

# Create branch (CLI)
git checkout -b feature/my-feature

# ... make changes ...

# Pre-commit checks
uv run ruff check . && uv run ruff format .
uv run pyright
uv run pip-audit
uv run pytest

# Commit (CLI)
git add <files>
git commit -m "feat: add feature"

# Push (CLI)
git push -u origin feature/my-feature

# Create PR (GitHub MCP)
mcp__github__create_pull_request(
    owner="username",
    repo="repo-name",
    title="feat: add feature",
    body="Description of changes",
    head="feature/my-feature",
    base="main"
)

# List PRs (GitHub MCP)
mcp__github__list_pull_requests(owner="username", repo="repo-name")

# Get PR details (GitHub MCP)
mcp__github__get_pull_request(owner="username", repo="repo-name", pull_number=123)
```

## Workflow: Using CLI Only

When GitHub MCP is not available:

```bash
# Create branch
git checkout -b feature/my-feature

# ... make changes ...

# Pre-commit checks (REQUIRED)
uv run ruff check . && uv run ruff format .
uv run pyright
uv run pip-audit
uv run pytest

# Commit
git add <files>
git commit -m "feat: add feature"

# Push
git push -u origin feature/my-feature

# Create PR (gh CLI)
gh pr create --title "feat: add feature" --body "Description"

# List PRs (gh CLI)
gh pr list

# View PR (gh CLI)
gh pr view 123
```

## Security Checklist

Before every commit, verify:

- [ ] `uv run ruff check .` passes
- [ ] `uv run ruff format --check .` passes
- [ ] `uv run pyright` passes with no errors
- [ ] `uv run pip-audit` shows no vulnerabilities
- [ ] `uv run pytest` all tests pass
- [ ] No secrets in staged files (API keys, passwords)
- [ ] No `.env` files staged
- [ ] No large binary files staged

## Quick Commands

```bash
# Full pre-commit check
uv run ruff check . && uv run ruff format . && uv run pyright && uv run pip-audit && uv run pytest

# Quick check (no tests)
uv run ruff check . && uv run pyright

# Amend last commit (same message)
git commit --amend --no-edit

# Amend last commit (new message)
git commit --amend -m "new message"

# Interactive rebase last N commits
git rebase -i HEAD~N

# Squash commits before PR
git rebase -i main
```

## Output Format

When creating commits, confirm:

1. All pre-commit checks passed (ruff, pyright, pip-audit, pytest)
2. Commit type is appropriate
3. Message follows conventions
4. No sensitive files staged
5. Branch pushed to remote
6. PR created (if requested)

## See Also

- **python** - Python conventions and tooling
- **security** - Security checks in detail
- **tdd** - Test requirements before commit
- **/mcp-check** - Verify GitHub MCP is configured
