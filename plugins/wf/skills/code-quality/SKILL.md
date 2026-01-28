---
name: code-quality
description: Enforce code quality standards including naming conventions, code structure, type hints, and best practices. Use when writing new code, reviewing code, or refactoring to ensure consistency and readability.
command: false
---

# Code Quality Skill

Enforce code quality standards for Python development following project guidelines.

## When to Use This Skill

✅ **Use when:**
- Writing new functions or classes
- Reviewing code before commit
- Refactoring existing code
- Responding to code review feedback
- Extracting magic numbers or improving naming

❌ **Don't use when:**
- Just reading or understanding code
- Running tests without code changes
- Working on documentation only
- Investigating bugs without fixes

## General Principles

- Write elegant, well-tested, clear, concise, well-organized code
- Prioritize readability over cleverness
- Follow principle of least surprise
- Keep functions small and focused (single responsibility)
- Avoid premature optimization - profile first

## Code Structure

**Functions and Classes**
- Google-style docstrings for all public APIs
- Type hints required for all parameters and return values
- Single responsibility per function

**Naming Conventions**
- Variables: Explicit names (file_count not fc, user_data not ud)
- Constants: ALL_CAPS at module level
- Extract magic numbers to named constants

**Example**:
```python
# Good
def process_data(input_data: str, threshold: int = 100) -> dict[str, Any]:
    """Process input data and return results.

    Args:
        input_data: Raw data to process.
        threshold: Processing threshold value. Defaults to 100.

    Returns:
        Dictionary with processed results and metadata.
    """
    pass

# Bad - No types, no docstring
def process_data(input_data, threshold=100):
    pass
```

## Error Handling

- Use specific exception types, not bare except
- Provide helpful error messages with context
- Log errors with exc_info=True
- Clean up with finally or context managers
- Validate inputs early, fail fast

**Pattern**:
```python
def process_file(filepath: str) -> dict[str, Any]:
    """Process file and return results."""
    if not filepath:
        raise ValueError("filepath cannot be empty")

    logger.debug(f"Processing: {filepath}")

    try:
        with open(filepath, 'r') as f:
            data = f.read()
    except FileNotFoundError:
        logger.error(f"File not found: {filepath}")
        raise
    except Exception as e:
        logger.error(f"Error processing {filepath}: {e}", exc_info=True)
        raise

    logger.info(f"Processed {filepath} ({len(data)} bytes)")
    return {"filepath": filepath, "size": len(data)}
```

## Refactoring Guidelines

- Look for duplication, long functions, unclear names
- Extract common functionality to reusable functions
- Improve error handling and edge cases
- Update tests to match refactored code
- Keep refactoring commits separate

## Code Review Checklist

Before committing:
- [ ] All functions have Google-style docstrings
- [ ] Type hints complete and accurate
- [ ] Tests comprehensive and meaningful
- [ ] Magic numbers extracted to constants
- [ ] Error handling appropriate
- [ ] No code smells (duplication, long functions)
- [ ] Logger used, not print()
- [ ] No sensitive info in logs
- [ ] All tests pass
- [ ] Code coverage meets threshold

## Quality Tools

**Ruff** - Linting and formatting:
```bash
uv run ruff check .
uv run ruff format .
uv run ruff check --fix .
```

Configuration:
```toml
[tool.ruff]
line-length = 88
target-version = "py314"

[tool.ruff.lint]
select = ["E", "W", "F", "I", "B", "C4", "UP", "N", "SIM"]
ignore = ["E501"]  # line too long

[tool.ruff.lint.per-file-ignores]
"tests/*" = ["S101"]  # Allow assert
```

## Output Format

When completing code quality tasks, report:

1. Files modified with improvements made
2. Issues found and fixed
3. Any remaining quality concerns
4. Code coverage impact if applicable

## See Also

- **python** - Foundational Python conventions
- **logging** - Logging patterns (never use print())
- **documentation** - Google-style docstring format
- **tdd** - Test-driven development approach
- **/compliance-check** - Audit code quality across project
