---
name: tdd
description: Apply test-driven development methodology to write tests before implementation. Use when adding new features, fixing bugs, or refactoring code. Guides through red-green-refactor cycle with pytest best practices.
user-invocable: false
---

# Test-Driven Development Skill

Apply test-driven development (TDD) methodology following the red-green-refactor cycle.

## When to Use This Skill

✅ **Use when:**
- Adding new features or functionality
- Fixing bugs (write failing test first)
- Refactoring code (ensure tests still pass)
- Improving test coverage
- Writing integration or unit tests
- Implementing test fixtures or mocks

❌ **Don't use when:**
- Just running existing tests
- Investigating test failures (debugging, not writing)
- Working on documentation or configuration
- Making changes to test infrastructure itself

## Instructions

Follow TDD principles to write tests first, implement functionality, then refactor. Use pytest framework with best practices from .claude/CLAUDE.md.

### TDD Cycle

**RED**: Write a failing test that defines desired functionality

**GREEN**: Write minimal code to make the test pass

**REFACTOR**: Improve code quality while keeping tests green

### Standards

1. Write tests before implementation
2. One test per function behavior
3. Use descriptive test names (test_function_does_what_when_condition)
4. Aim for 100% code coverage
5. Use fixtures for setup/teardown
6. Mock external dependencies
7. Test both success and failure cases

### Test Structure

**Test File Location**: tests/test_module.py for each src/module.py

**Test Class Organization**:
```python
class TestClassName:
    @pytest.fixture
    def setup_data(self):
        """Provide test data or resources."""
        return {"key": "value"}

    def test_method_returns_expected_value(self, setup_data):
        """Test that method returns correct value."""
        assert method(setup_data) == expected

    def test_method_raises_error_on_invalid_input(self):
        """Test that method raises appropriate error."""
        with pytest.raises(ValueError):
            method(invalid_input)
```

### Test Categories

**Unit Tests**: Test individual functions in isolation

**Integration Tests**: Test component interactions

**Edge Cases**: Empty inputs, null values, boundary conditions

**Error Cases**: Invalid inputs, exceptions, error handling

### Pytest Best Practices

**Fixtures for common setup**:
```python
@pytest.fixture
def sample_data():
    """Create test data."""
    return [1, 2, 3, 4, 5]
```

**Parametrize for multiple inputs**:
```python
@pytest.mark.parametrize("input,expected", [
    (1, 2),
    (0, 1),
    (-1, 0),
])
def test_increment(input, expected):
    """Test increment with various values."""
    assert increment(input) == expected
```

**Mock external dependencies**:
```python
from unittest.mock import Mock, patch

def test_api_call(mocker):
    """Test function that calls external API."""
    mocker.patch('module.api_call', return_value={'status': 'ok'})
    result = function_that_calls_api()
    assert result == expected
```

### TDD Workflow

1. **Understand requirement**: Clarify what needs to be implemented
2. **Write failing test**: Define expected behavior with assertions
3. **Run test**: Verify it fails (RED)
4. **Implement minimal code**: Make test pass with simplest solution
5. **Run test**: Verify it passes (GREEN)
6. **Refactor**: Improve code quality, extract functions, remove duplication
7. **Run all tests**: Ensure refactoring didn't break anything
8. **Repeat**: Move to next requirement

### Running Tests

```bash
# Run all tests
uv run python -m pytest

# Run specific test file
uv run python -m pytest tests/test_module.py

# Run specific test
uv run python -m pytest tests/test_module.py::TestClass::test_method

# Run with coverage
uv run python -m pytest --cov=src

# Run with verbose output
uv run python -m pytest -v
```

### Quality Checklist

- [ ] Test written before implementation
- [ ] Test has descriptive name explaining what it tests
- [ ] Test focuses on one behavior
- [ ] Both success and failure paths tested
- [ ] Edge cases covered
- [ ] External dependencies mocked
- [ ] Fixtures used for common setup
- [ ] Test runs and passes
- [ ] Code coverage meets 80% threshold
- [ ] All tests still pass after refactoring

### Best Practices

DO: Write smallest possible test first, test one thing per test, use fixtures, parametrize similar tests, mock externals

DONT: Test implementation details, write tests after code, skip edge cases, ignore failing tests, write overly complex tests

### Example: TDD Session

**Requirement**: Function to validate email addresses

**Step 1 - Write failing test**:
```python
def test_validate_email_returns_true_for_valid_email():
    """Test that valid email passes validation."""
    assert validate_email("user@example.com") is True
```

**Step 2 - Run test** (RED - function doesn't exist yet)

**Step 3 - Implement minimal code**:
```python
def validate_email(email: str) -> bool:
    """Validate email address format."""
    return "@" in email and "." in email
```

**Step 4 - Run test** (GREEN - test passes)

**Step 5 - Add more tests for edge cases**:
```python
def test_validate_email_returns_false_for_invalid_email():
    """Test that invalid email fails validation."""
    assert validate_email("notanemail") is False

def test_validate_email_returns_false_for_empty_string():
    """Test that empty string fails validation."""
    assert validate_email("") is False
```

**Step 6 - Refactor with better validation**:
```python
import re

def validate_email(email: str) -> bool:
    """Validate email address format.

    Args:
        email: Email address to validate.

    Returns:
        True if email is valid, False otherwise.
    """
    pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    return bool(re.match(pattern, email))
```

**Step 7 - Run all tests** (All GREEN)

### Output Format

When completing TDD tasks, report:

1. Number of tests written
2. Coverage percentage achieved
3. Test files created or modified
4. Implementation files created or modified
5. Any remaining test cases needed

## See Also

- **python** - Test file templates and pytest configuration
- **code-quality** - Code quality standards for tests
- **logging** - Capturing logs in tests
- **/compliance-check** - Audit test coverage
