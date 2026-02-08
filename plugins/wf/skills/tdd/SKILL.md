---
name: tdd
description: Apply test-driven development methodology to write tests before implementation. Use when adding new features, fixing bugs, or refactoring code. Guides through red-green-refactor cycle with pytest.
user-invocable: false
---

# Test-Driven Development

Follow the red-green-refactor cycle:

1. **RED**: Write a failing test that defines desired behavior
2. **GREEN**: Write minimal code to make the test pass
3. **REFACTOR**: Improve code quality while keeping tests green

## Standards

- Write tests before implementation
- One test per behavior
- Descriptive names: `test_function_does_what_when_condition`
- Use fixtures for setup/teardown
- Mock external dependencies
- Test both success and failure cases
- Aim for high coverage of core logic

## Test Structure

```python
class TestClassName:
    @pytest.fixture
    def setup_data(self):
        return {"key": "value"}

    def test_method_returns_expected_value(self, setup_data):
        assert method(setup_data) == expected

    def test_method_raises_error_on_invalid_input(self):
        with pytest.raises(ValueError):
            method(invalid_input)
```

## Pytest Patterns

### Parametrize

```python
@pytest.mark.parametrize("input,expected", [
    (1, 2),
    (0, 1),
    (-1, 0),
])
def test_increment(input, expected):
    assert increment(input) == expected
```

### Mock External Dependencies

```python
def test_api_call(mocker):
    mocker.patch('module.api_call', return_value={'status': 'ok'})
    result = function_that_calls_api()
    assert result == expected
```

## Running Tests

```bash
uv run pytest                              # All tests
uv run pytest tests/test_module.py         # Specific file
uv run pytest -k "test_method"             # By name pattern
uv run pytest --cov=src                    # With coverage
```

## TDD Workflow

1. Understand the requirement
2. Write a failing test defining expected behavior
3. Run test — verify it fails (RED)
4. Write minimal code to pass
5. Run test — verify it passes (GREEN)
6. Refactor while keeping tests green
7. Run all tests to catch regressions
8. Repeat for next requirement

## See Also

- **conventions** — test file templates and pytest configuration
