---
name: logging
description: Implement and maintain logging using loguru framework. Use when adding logging to code, configuring log levels, debugging issues, or ensuring proper logging practices. Never use print() statements - always use logger.
command: false
---

# Logging Skill

Implement structured logging using loguru framework following project standards.

## When to Use This Skill

✅ **Use when:**
- Adding logging to new or existing code
- Replacing print() statements
- Debugging or troubleshooting issues
- Logging errors and exceptions
- Adding progress tracking for long operations
- Configuring log levels

❌ **Don't use when:**
- Writing test assertions (use assert)
- Returning values to callers (use return)
- Displaying CLI output to users (CLI frameworks handle this)
- Just viewing existing log files

## Instructions

Use loguru for all logging needs. Never use print() statements. Follow logging best practices from .claude/CLAUDE.md.

### Core Principles

1. **Never use print()** - Always use logger
2. **Import from core**: `from ${PROJECT_NAME}.core import logger`
3. **Choose appropriate log level** for each message
4. **Include context** in log messages
5. **Log exceptions** with exc_info=True
6. **No sensitive data** in logs

### Log Levels

**DEBUG**: Diagnostic info, variable values, internal state
```python
logger.debug(f"Processing item {i} of {total}")
logger.debug(f"Configuration loaded: {config}")
```

**INFO**: General program flow, operations started/completed
```python
logger.info("Starting document parsing")
logger.info(f"Processing {count} files")
```

**SUCCESS**: Successful completion of significant operations
```python
logger.success("Document parsed successfully")
logger.success(f"Exported {count} records")
```

**WARNING**: Recoverable issues, deprecations, unexpected situations
```python
logger.warning("Rate limit approaching")
logger.warning(f"File {filename} not found, skipping")
```

**ERROR**: Failures that don't stop execution
```python
logger.error(f"Failed to process file: {filename}")
logger.error("Database query failed", exc_info=True)
```

**CRITICAL**: Critical errors causing termination
```python
logger.critical("Database connection lost")
logger.critical("Configuration file missing")
```

### Configuration

Logging is configured centrally in `src/${PROJECT_NAME}/core/logger.py`. Environment variables control behavior:

```bash
LOG_LEVEL_CONSOLE=INFO    # NONE, DEBUG, INFO, WARNING, ERROR, CRITICAL
LOG_LEVEL_FILE=DEBUG      # File gets more detailed logs
LOG_DIR=logs              # Log file directory
```

### Usage Patterns

**Import logger**:
```python
from ${PROJECT_NAME}.core import logger
```

**Basic logging**:
```python
logger.info("Operation started")
logger.success("Operation completed")
```

**Logging with context**:
```python
logger.info(f"Processing document: {filepath}")
logger.debug(f"Using model: {model_name}, temperature: {temp}")
```

**Logging exceptions**:
```python
try:
    risky_operation()
except Exception as e:
    logger.error(f"Operation failed: {e}", exc_info=True)
    raise
```

**Progress logging for long operations**:
```python
total = len(items)
logger.info(f"Starting processing of {total} items")

for i, item in enumerate(items, 1):
    process_item(item)
    if i % 100 == 0:
        logger.info(f"Progress: {i}/{total} items processed")

logger.success(f"Completed processing {total} items")
```

**Conditional debug logging**:
```python
logger.debug(f"Cache hit: {cache_key}")
logger.debug(f"Query returned {len(results)} results")
```

### Best Practices

**DO**:
- Import logger: `from ${PROJECT_NAME}.core import logger`
- Use structured messages with context
- Log at appropriate levels
- Include variable values in f-strings
- Use exc_info=True for exceptions
- Log operation start and completion
- Log progress for long operations
- Use logger for all output

**DONT**:
- Use print() statements
- Log sensitive data (passwords, API keys, tokens)
- Log inside tight loops (use sampling)
- Use bare except without logging
- Duplicate log messages
- Log at wrong level (debug as error, etc)

### Common Patterns

**Function entry/exit**:
```python
def process_data(data: list) -> dict:
    """Process input data."""
    logger.debug(f"process_data called with {len(data)} items")

    result = perform_processing(data)

    logger.debug(f"process_data returning {len(result)} results")
    return result
```

**Error handling with logging**:
```python
def load_file(filepath: str) -> str:
    """Load file content."""
    logger.debug(f"Loading file: {filepath}")

    try:
        with open(filepath, 'r') as f:
            content = f.read()
    except FileNotFoundError:
        logger.error(f"File not found: {filepath}")
        raise
    except PermissionError:
        logger.error(f"Permission denied: {filepath}")
        raise
    except Exception as e:
        logger.error(f"Error loading {filepath}: {e}", exc_info=True)
        raise

    logger.info(f"Loaded file: {filepath} ({len(content)} bytes)")
    return content
```

**Configuration logging**:
```python
def configure_app(config: dict) -> None:
    """Configure application."""
    logger.info("Configuring application")
    logger.debug(f"Config: {config}")

    # Apply configuration

    logger.success("Application configured successfully")
```

### Log File Management

Logs are automatically managed:
- **Location**: `logs/` directory
- **Rotation**: At 100MB file size
- **Retention**: 30 days
- **Compression**: Old logs compressed
- **Format**: UTC timestamps for consistency

View logs:
```bash
# Latest log file
ls -t logs/*.log | head -1 | xargs cat

# Follow live logs
ls -t logs/*.log | head -1 | xargs tail -f

# Search logs
grep "ERROR" logs/*.log
```

### Testing with Logging

In tests, capture or suppress log output:

```python
def test_function_logs_correctly(caplog):
    """Test that function logs expected messages."""
    with caplog.at_level("INFO"):
        my_function()
        assert "Expected message" in caplog.text

def test_without_log_noise():
    """Test with suppressed logging."""
    logger.remove()
    try:
        my_function()
        # assertions
    finally:
        logger.add(sys.stderr)
```

### Migration from print()

When finding print() statements, replace with appropriate logger:

```python
# Before
print(f"Processing {filename}")
print(f"[ERROR] Failed to process")

# After
logger.info(f"Processing {filename}")
logger.error("Failed to process")
```

### Quality Checklist

- [ ] No print() statements in code
- [ ] Logger imported correctly: `from ${PROJECT_NAME}.core import logger`
- [ ] Appropriate log levels used
- [ ] Context included in messages
- [ ] Exceptions logged with exc_info=True
- [ ] No sensitive data in logs
- [ ] Progress logged for long operations
- [ ] Meaningful, actionable messages

### Output Format

When implementing logging, report:

1. Files modified with logging added
2. Log levels used and why
3. Any print() statements removed
4. Exception handling improvements made

## See Also

- **project-name** - Resolves `${PROJECT_NAME}` for import paths
- **python** - Foundational conventions
- **code-quality** - Error handling patterns
- **security** - Security event logging (without sensitive data)
