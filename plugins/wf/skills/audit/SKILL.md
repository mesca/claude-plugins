---
name: audit
description: Audit project code against development guidelines and skills conventions. Use when checking codebase compliance, verifying code quality standards, checking testing coverage, or validating configuration files.
context: fork
agent: general-purpose
argument-hint: [category]
---

# Audit

Audit the codebase against the development guidelines defined in the project's instruction files (CLAUDE.md, PROJECT.md if they exist) and this plugin's skills.

## Usage

```
/audit [category]
```

**Categories:**
- `structure` - Project structure and architecture
- `contracts` - API contracts and models-first compliance
- `code` - Code quality, docstrings, type hints, logging practices
- `testing` - Test coverage and standards
- `git` - Commit conventions and branch naming
- `performance` - Optimization patterns
- `security` - Vulnerabilities and secrets management
- `config` - Configuration files and dependencies
- `all` - Run all checks (default)

**Examples:**
- `/audit` - Run all checks
- `/audit code` - Check code quality only
- `/audit security testing` - Check security and testing

## Audit Categories

### 1. Structure & Architecture

Check project layout and layer boundaries per the **conventions** skill:

- Verify src-layout: `src/${PROJECT_NAME}/` exists (package name from pyproject.toml)
- Check layer separation: `contracts/`, `core/`, `models/`, `services/`, `interfaces/`
- Verify `core/` contains ONLY infrastructure (logger, config, exceptions) — no business logic
- Verify `services/` is framework-agnostic (no Typer/FastAPI imports)
- Verify `interfaces/` are thin wrappers (call services, minimal logic)
- Check for code duplication between CLI and REST interfaces
- Verify tests mirror source structure in `tests/`

### 2. Contracts & Models

Apply **spec-driven** skill checks:

- Verify `contracts/` directory exists under `src/${PROJECT_NAME}/` if the project has an API
- Contract files are valid OpenAPI 3.1 (`openapi.yaml`) or OpenRPC 1.3 (`openrpc.yaml`)
- Every schema in `components/schemas/` has a corresponding Pydantic model
- Model field names, types, and constraints match the contract schemas
- Pydantic models exist in `models/` directories at appropriate levels (shared domain models in top-level `models/`, layer-specific in layer `models/`)
- No service or interface code exists without corresponding models being defined first
- Models do not import from higher architectural layers

### 3. Code Quality

Apply **conventions** and **documentation** skill checks:

- All public functions have Google-style docstrings (Args, Returns, Raises)
- Complete type hints on all function signatures
- No `print()` statements — use logger from `${PROJECT_NAME}.core`
- Logger used at appropriate levels (DEBUG, INFO, SUCCESS, WARNING, ERROR, CRITICAL)
- Exceptions logged with `exc_info=True`
- No sensitive data in log messages
- Magic numbers extracted to named constants
- Explicit variable names (`file_count` not `fc`)
- Functions small and focused (single responsibility)
- No emojis in documentation
- README up to date

### 4. Testing

Apply **tdd** skill checks:

- Test files exist for all modules
- Test coverage high for core logic
- Descriptive test names (`test_function_does_what_when_condition`)
- Fixtures used for common setup
- Both success and failure paths tested
- Core logic tests have no CLI/API dependencies

### 5. Git Workflow

Apply **git-workflow** skill checks:

- Recent commits follow conventional format (`type: subject`)
- Valid commit types (feat, fix, docs, style, refactor, test, perf, chore)
- Subjects under 50 characters, imperative mood
- Branch naming follows conventions

### 6. Performance

Apply **performance** skill checks:

- No unoptimized patterns (loading large files into memory)
- Caching on expensive operations
- Generators used for large datasets
- No N+1 database query patterns
- Bulk operations instead of loops
- Proper pagination on large result sets

### 7. Security

Apply **security** skill checks:

- No hardcoded secrets (API keys, passwords, tokens)
- Secrets in `.env`, `.env` gitignored
- Input validation on user-facing functions
- No SQL injection (parameterized queries only)
- No command injection (no `shell=True` with user input)
- Path traversal protection on file operations
- Strong password hashing (Argon2/bcrypt, not MD5/SHA1)
- Dependencies audited (`pip-audit`)

### 8. Configuration & Dependencies

- `pyproject.toml` has correct project name, Python version (>=3.14)
- Ruff configured (line-length: 88, target: py314)
- Pyright configured (strict mode)
- pytest configured
- `.env.example` exists with required variables
- `.claude/settings.json` has `.env` deny rules
- Core dependencies in `[project.dependencies]`
- Dev dependencies in `[dependency-groups.dev]`
- No unused dependencies; all imports match declared dependencies

## Audit Process

1. **Parse input**: Determine which categories to check (default: all)
2. **Read guidelines**: Check for .claude/CLAUDE.md and .claude/PROJECT.md (if they exist), and review relevant plugin skills
3. **Scan codebase**: Use Grep/Glob for pattern matching, MCP tools if available
4. **Check categories**: Systematically verify compliance
5. **Document issues**: List findings with file:line references, prioritized as Critical/High/Medium/Low
6. **Recommend fixes**: Specific, actionable remediation steps

## Output Format

```
# Compliance Audit Report

## Summary
- Total issues: X
- Critical: X | High: X | Medium: X | Low: X

## Issues by Category

### 1. Structure & Architecture (X issues)
- [HIGH] Business logic in interfaces/cli/ instead of services/
- [MEDIUM] Service module imports Typer (should be framework-agnostic)

### 2. Code Quality (X issues)
- [HIGH] services/parser.py:45 - Missing docstring on parse_document()
- [MEDIUM] interfaces/cli/main.py:78 - Using print() instead of logger

### 3. Testing (X issues)
- [CRITICAL] No tests for services/processor.py

...

## Recommendations

### Immediate (Critical/High)
1. ...

### Short-term (Medium)
1. ...
```

## Notes

- Be thorough but practical — prioritize actionable issues
- Provide file:line references for all issues
- Suggest concrete fixes, not just problems
- Consider project maturity (early stage vs production)

## See Also

- **/audit-config** — .claude directory and plugin structure
- **/audit-mcp** — MCP server health
- **conventions** — conventions referenced in audit
- **spec-driven** — contracts and models-first standards referenced in audit
- **security** — security standards referenced in audit
- **tdd** — testing standards referenced in audit
