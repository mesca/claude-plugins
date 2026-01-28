---
name: compliance-check
description: Check project compliance with .claude/CLAUDE.md, .claude/PROJECT.md, and skills guidelines. Use when auditing codebase adherence, verifying code quality standards, checking testing coverage, or validating configuration files.
command: true
subagent: true
---

# Compliance Check Skill

Perform a comprehensive audit of the codebase to ensure adherence to all development guidelines and standards defined in both CLAUDE.md (framework guidelines) and PROJECT.md (project-specific conventions).

## When to Use This Skill

✅ **Use when:**
- Auditing project compliance before a release
- Verifying code follows established guidelines
- Checking architecture and structure adherence
- Reviewing logging, testing, or security practices
- Validating configuration files

❌ **Don't use when:**
- Checking .claude directory itself (use meta-check instead)
- Verifying MCP server configuration (use mcp-check instead)
- Just reading or understanding code without auditing

## Usage

```
/compliance-check [category]
```

**Categories:**
- `structure` - Project structure and architecture compliance
- `code-quality` - Code quality standards (docstrings, type hints, naming)
- `testing` - Testing standards and coverage
- `logging` - Logging practices (no print(), proper logger usage)
- `git` - Git workflow and commit conventions
- `performance` - Performance optimization practices
- `security` - Security best practices
- `config` - Configuration files (pyproject.toml, .env, etc.)
- `all` - Run all checks (default if no category specified)

**Examples:**
- `/compliance-check` - Run all checks
- `/compliance-check code-quality` - Check only code quality
- `/compliance-check logging testing` - Check logging and testing

## Audit Categories

### 1. Project Structure Compliance

Check that the project follows the structure defined in CLAUDE.md and PROJECT.md:
- Verify src-layout: `src/${PROJECT_NAME}/` exists (package name from pyproject.toml)
- Check for proper separation: `${PROJECT_NAME}/core/`, `${PROJECT_NAME}/models/`, `${PROJECT_NAME}/services/`
- Verify interface layer in `${PROJECT_NAME}/interfaces/` with CLI and/or REST subdirectories
- Verify CLI entry point in `${PROJECT_NAME}/interfaces/cli/main.py` (if implemented)
- Check if REST API exists in `${PROJECT_NAME}/interfaces/rest/main.py` (if implemented)
- Verify tests mirror source structure in `tests/`

### 2. Architecture Compliance

Verify layered architecture pattern from CLAUDE.md:
- Check that `${PROJECT_NAME}/core/` contains ONLY infrastructure (logger, config, exceptions, utils) - NO business logic
- Verify `${PROJECT_NAME}/services/` contains business logic (framework-agnostic, testable)
- Verify `${PROJECT_NAME}/interfaces/cli/` is thin (calls services, minimal logic)
- Verify `${PROJECT_NAME}/interfaces/rest/` is thin (calls services, minimal logic, if exists)
- Check for code duplication between CLI and REST interfaces
- Verify service modules have no Typer/FastAPI imports (framework-agnostic)
- Check that business logic lives ONLY in services, never in interfaces

### 3. Code Quality Standards

Apply code-quality skill checks:
- Verify all public functions have Google-style docstrings
- Check for complete type hints on all function signatures
- Look for print() statements (should use logger instead)
- Check for magic numbers (should be named constants)
- Verify function sizes (small, focused, single responsibility)
- Check naming conventions (explicit variable names, ALL_CAPS constants)

### 4. Documentation Standards

Apply documentation skill checks:
- Verify all public APIs have complete docstrings
- Check docstring format (Google-style with Args, Returns, Raises, Examples)
- Verify type hints are accurate and complete
- Check for missing or outdated README sections
- Verify no emojis in documentation

### 5. Testing Standards

Apply tdd skill checks:
- Verify test files exist for all modules
- Check test coverage (aim for 100% of core logic)
- Verify tests use descriptive names (test_function_does_what_when_condition)
- Check for fixtures usage (no repeated setup code)
- Verify both success and failure paths are tested
- Check that core logic tests have no CLI/API dependencies

### 6. Logging Standards

Apply logging skill checks:
- Verify NO print() statements exist in code
- Check logger is imported correctly: `from ${PROJECT_NAME}.core import logger` (or `from ${PROJECT_NAME} import logger`)
- Verify appropriate log levels used (DEBUG, INFO, SUCCESS, WARNING, ERROR, CRITICAL)
- Check for structured logging with context (f-strings with variables)
- Verify exceptions logged with `exc_info=True`
- Check for sensitive data in log messages

### 7. Git Workflow Compliance

Apply git-workflow skill checks:
- Check recent commits follow conventional format (type: subject)
- Verify commit types are valid (feat, fix, docs, style, refactor, test, perf, chore)
- Check commit messages are under 50 characters
- Verify branch naming follows conventions (if applicable)

### 8. Performance

Apply performance skill checks:
- Look for unoptimized patterns (loading large files into memory)
- Check for missing caching on expensive operations
- Verify generators used for large datasets
- Check for N+1 database query patterns
- Look for blocking I/O that should be async
- Verify bulk operations used instead of loops
- Check for proper pagination on large result sets

### 9. Security

Apply security skill checks:
- Check for hardcoded secrets (API keys, passwords, tokens)
- Verify secrets are in .env and .env is gitignored
- Check for input validation on user-facing functions
- Look for SQL injection vulnerabilities (raw queries)
- Check for command injection (shell=True, os.system)
- Verify path traversal protection on file operations
- Check for proper password hashing (not MD5/SHA1)
- Verify environment variables used for sensitive configuration
- Check dependencies for known vulnerabilities (pip-audit)

### 11. Configuration Files

Check configuration compliance:
- Verify `pyproject.toml` has correct project name and dependencies
- Check Python version requirement (>=3.13)
- Verify Ruff configuration (line-length: 88, target: py313)
- Check pytest configuration exists
- Verify `.env.example` exists with required variables
- Check `.claude/mcp.json` has Context7 and Serena configured
- Verify `.claude/settings.json` has proper deny rules

### 12. Dependencies

Check dependency organization:
- Verify core dependencies in `[project.dependencies]`
- Check optional dependency groups in `[dependency-groups.*]` (if any)
- Verify dev dependencies in `[dependency-groups.dev]` or `[tool.uv.dev-dependencies]`
- Check for unused dependencies
- Verify all imports match declared dependencies

## Category Mapping

When user specifies a category, check only the relevant audit categories:

- `structure` → Category 1 (Project Structure)
- `code-quality` → Categories 2, 4 (Architecture, Code Quality)
- `testing` → Category 5 (Testing Standards)
- `logging` → Category 6 (Logging Standards)
- `git` → Category 7 (Git Workflow)
- `performance` → Category 8 (Performance)
- `security` → Category 9 (Security)
- `config` → Categories 10, 11 (Configuration Files, Dependencies)
- `all` → All 11 categories

## Audit Process

1. **Parse input**: Determine which categories to check (default to all)
2. **Read guidelines**: Review .claude/CLAUDE.md (framework guidelines), .claude/PROJECT.md (project-specific conventions), and relevant skills for selected categories
3. **Scan codebase**: Use Serena for semantic analysis, Grep/Glob for pattern matching
4. **Check selected categories**: Systematically verify compliance for requested categories only
5. **Document issues**: List all non-compliance issues found with file:line references
6. **Prioritize**: Categorize issues as Critical, High, Medium, Low priority
7. **Provide fixes**: Suggest specific remediation steps for each issue

## Output Format

Provide a structured report:

```
# Project Adherence Audit Report

## Summary
- Total issues found: X
- Critical: X | High: X | Medium: X | Low: X
- Overall compliance: X%

## Issues by Category

### 1. Project Structure (X issues)
- [CRITICAL] Missing src/${PROJECT_NAME}/ directory or incorrect structure
- [HIGH] Business logic in interfaces/ instead of services/

### 2. Architecture (X issues)
- [HIGH] Business logic found in ${PROJECT_NAME}/interfaces/cli/ instead of services/
- [MEDIUM] Service module imports Typer (should be framework-agnostic)

### 3. Code Quality (X issues)
- [HIGH] ${PROJECT_NAME}/services/parser.py:45 - Missing docstring on parse_document()
- [MEDIUM] ${PROJECT_NAME}/interfaces/cli/main.py:78 - Using print() instead of logger
...

### 4. Documentation (X issues)
...

### 5. Testing (X issues)
- [CRITICAL] No tests for ${PROJECT_NAME}/services/processor.py
- [HIGH] Coverage only 65% (target: 80%+)
...

### 6. Logging (X issues)
...

### 7. Git Workflow (X issues)
...

### 8. Performance (X issues)
- [MEDIUM] Loading entire file into memory in ${PROJECT_NAME}/services/processor.py:45
- [LOW] Missing caching on expensive API call in ${PROJECT_NAME}/services/api.py:78
...

### 9. Security (X issues)
- [CRITICAL] API key hardcoded in ${PROJECT_NAME}/services/api_client.py:12
- [HIGH] SQL injection vulnerability in ${PROJECT_NAME}/services/db.py:34
...

### 10. Configuration (X issues)
...

### 11. Dependencies (X issues)
...

## Recommendations

### Immediate Actions (Critical/High Priority)
1. Fix security issue: Remove hardcoded API key
2. Add missing tests for core modules
3. Replace all print() with logger calls

### Short-term Improvements (Medium Priority)
1. Add missing docstrings
2. Improve test coverage to 100%
3. Extract magic numbers to constants

### Long-term Enhancements (Low Priority)
1. Refactor long functions
2. Add more comprehensive examples to docstrings

## Compliance Checklist

- [ ] Project structure matches CLAUDE.md (src-layout with proper layers)
- [ ] Architecture follows CLAUDE.md (services contain business logic, interfaces are thin)
- [ ] Business logic in services/, not in interfaces/
- [ ] All public functions have Google-style docstrings
- [ ] No print() statements (logger only)
- [ ] Test coverage ≥80%
- [ ] All commits follow conventional format
- [ ] No hardcoded secrets
- [ ] Configuration files are correct
- [ ] Dependencies properly organized
- [ ] PROJECT.md conventions followed (project-specific rules)
```

## Tools to Use

- **Serena**: Semantic code analysis, find usages, understand data flow
- **Grep**: Find patterns (print statements, missing docstrings, hardcoded values)
- **Glob**: Find files matching patterns
- **Read**: Examine specific files for detailed checks
- **Bash**: Run tests, check coverage, run linters

## Notes

- Be thorough but practical - prioritize actionable issues
- Provide file:line references for all issues
- Suggest concrete fixes, not just problems
- Consider project maturity (early stage vs production)
- Check both what exists and what's missing

## See Also

- **/meta-check** - Audit .claude directory structure
- **/mcp-check** - Verify MCP server health
- **code-quality** - Code quality standards referenced in audit
- **logging** - Logging standards referenced in audit
- **tdd** - Testing standards referenced in audit
- **security** - Security standards referenced in audit
- **python** - Python conventions referenced in audit
