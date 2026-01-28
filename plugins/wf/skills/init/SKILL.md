---
name: init
description: Scaffold a new Python project with the standard structure, tooling configuration, and a CLI that outputs project name and version. Use when starting a new project from scratch.
command: true
subagent: true
---

# Init Skill

Scaffold a new Python project following the standard conventions defined in the python skill.

## When to Use This Skill

✅ **Use when:**
- Starting a new Python project from scratch
- Setting up project structure for an existing idea
- Creating a new microservice or tool

❌ **Don't use when:**
- Project already has structure (use /compliance-check instead)
- Converting an existing project (manual migration needed)

## Usage

```bash
/init <project-name> [description]
```

**Arguments:**
- `project-name` - Name for the project (kebab-case, e.g., `my-awesome-tool`)
- `description` - Optional project description

**Examples:**
```bash
/init my-tool
/init data-processor "A tool for processing data files"
```

## What Gets Created

### Directory Structure

```
<project-name>/
├── pyproject.toml              # Project config, dependencies, tooling
├── mkdocs.yml                  # Documentation config
├── README.md                   # Project readme
├── .gitignore                  # Git ignore patterns
├── .python-version             # Python version for pyenv/uv
├── .claude/
│   └── settings.json           # Claude Code settings (no attribution)
├── docs/
│   ├── index.md                # Documentation homepage
│   └── scripts/
│       └── gen_ref_pages.py    # API docs generator
├── src/
│   └── <package_name>/
│       ├── __init__.py         # Package init with version
│       ├── py.typed             # PEP 561 marker
│       ├── core/
│       │   ├── __init__.py     # Exports logger, config
│       │   ├── logger.py       # Loguru configuration
│       │   ├── config.py       # Pydantic settings
│       │   └── exceptions.py   # Custom exceptions
│       ├── services/
│       │   └── __init__.py     # Business logic placeholder
│       └── interfaces/
│           └── cli/
│               ├── __init__.py
│               └── main.py     # Typer CLI with version command
└── tests/
    ├── __init__.py
    ├── conftest.py             # Pytest fixtures
    └── test_cli.py             # CLI tests
```

## Generated Files

### pyproject.toml

```toml
[project]
name = "<project-name>"
description = "<description>"
readme = "README.md"
license = "MIT"
requires-python = ">=3.14"
dynamic = ["version"]
dependencies = [
    "loguru>=0.7",
    "pydantic>=2.0",
    "pydantic-settings>=2.0",
    "typer>=0.12",
]

[dependency-groups]
dev = [
    "pytest>=8.0",
    "pytest-cov>=5.0",
    "ruff>=0.8",
    "pyright>=1.1",
]
docs = [
    "mkdocs-material>=9.5",
    "mkdocstrings[python]>=0.27",
    "mkdocs-gen-files>=0.5",
    "mkdocs-literate-nav>=0.6",
    "mkdocs-section-index>=0.3",
]

[project.scripts]
<project-name> = "<package_name>.interfaces.cli.main:app"

[build-system]
requires = ["hatchling", "hatch-vcs"]
build-backend = "hatchling.build"

[tool.hatch.version]
source = "vcs"
fallback-version = "0.0.0+unknown"

[tool.hatch.build.hooks.vcs]
version-file = "src/<package_name>/_version.py"

[tool.hatch.envs.docs]
features = ["docs"]

[tool.hatch.envs.docs.scripts]
build = "mkdocs build --strict"
serve = "mkdocs serve"
deploy = "mkdocs gh-deploy --force"

[tool.ruff]
line-length = 88
target-version = "py314"

[tool.ruff.lint]
select = ["E", "W", "F", "I", "B", "S", "C4", "UP", "N", "SIM"]
ignore = ["E501"]

[tool.ruff.lint.per-file-ignores]
"tests/*" = ["S101"]

[tool.pyright]
pythonVersion = "3.14"
typeCheckingMode = "strict"
include = ["src"]
exclude = ["**/__pycache__", ".venv"]
reportMissingTypeStubs = false
reportUnknownMemberType = false

[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "-v --cov=src/<package_name> --cov-report=term-missing"
```

### src/<package_name>/__init__.py

```python
"""<Project description>.

This package provides...
"""

from <package_name>.core import logger
from <package_name>.core.config import settings

try:
    from <package_name>._version import __version__
except ImportError:
    __version__ = "0.0.0+unknown"

__all__ = ["__version__", "logger", "settings"]
```

### src/<package_name>/core/logger.py

```python
"""Logging configuration using loguru."""

import sys

from loguru import logger

# Remove default handler
logger.remove()

# Add console handler
logger.add(
    sys.stderr,
    format="<green>{time:YYYY-MM-DD HH:mm:ss}</green> | <level>{level: <8}</level> | <cyan>{name}</cyan>:<cyan>{function}</cyan>:<cyan>{line}</cyan> - <level>{message}</level>",
    level="INFO",
)

__all__ = ["logger"]
```

### src/<package_name>/core/config.py

```python
"""Application configuration using pydantic-settings."""

from pydantic import SecretStr
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    """Application settings loaded from environment variables."""

    debug: bool = False
    log_level: str = "INFO"

    model_config = {
        "env_prefix": "<PROJECT_NAME_UPPER>_",
        "env_file": ".env",
        "env_file_encoding": "utf-8",
    }


settings = Settings()

__all__ = ["Settings", "settings"]
```

### src/<package_name>/core/exceptions.py

```python
"""Custom exceptions for <project-name>."""


class <ProjectName>Error(Exception):
    """Base exception for <project-name>."""

    pass


class ConfigurationError(<ProjectName>Error):
    """Raised when configuration is invalid."""

    pass


class ProcessingError(<ProjectName>Error):
    """Raised when processing fails."""

    pass


__all__ = ["<ProjectName>Error", "ConfigurationError", "ProcessingError"]
```

### src/<package_name>/core/__init__.py

```python
"""Core infrastructure components."""

from <package_name>.core.config import settings
from <package_name>.core.logger import logger

__all__ = ["logger", "settings"]
```

### src/<package_name>/interfaces/cli/main.py

```python
"""Command-line interface for <project-name>."""

from typing import Annotated, Optional

import typer

from <package_name> import __version__
from <package_name>.core import logger

app = typer.Typer(
    name="<project-name>",
    help="<Project description>.",
    no_args_is_help=True,
)


def version_callback(value: bool) -> None:
    """Print version and exit."""
    if value:
        typer.echo(f"<project-name> {__version__}")
        raise typer.Exit()


@app.callback()
def main(
    version: Annotated[
        Optional[bool],
        typer.Option(
            "--version",
            "-v",
            help="Show version and exit.",
            callback=version_callback,
            is_eager=True,
        ),
    ] = None,
) -> None:
    """<Project description>."""
    pass


@app.command()
def info() -> None:
    """Show project information."""
    typer.echo(f"Name: <project-name>")
    typer.echo(f"Version: {__version__}")
    logger.debug("Info command executed")


if __name__ == "__main__":
    app()
```

### tests/conftest.py

```python
"""Pytest fixtures and configuration."""

import pytest


@pytest.fixture
def sample_data() -> dict[str, str]:
    """Provide sample test data."""
    return {"key": "value"}
```

### tests/test_cli.py

```python
"""Tests for the CLI interface."""

from typer.testing import CliRunner

from <package_name>.interfaces.cli.main import app

runner = CliRunner()


class TestCLI:
    """Tests for CLI commands."""

    def test_version_flag(self) -> None:
        """Test --version flag shows version."""
        result = runner.invoke(app, ["--version"])
        assert result.exit_code == 0
        assert "<project-name>" in result.stdout

    def test_info_command(self) -> None:
        """Test info command shows project info."""
        result = runner.invoke(app, ["info"])
        assert result.exit_code == 0
        assert "Name: <project-name>" in result.stdout
        assert "Version:" in result.stdout

    def test_help(self) -> None:
        """Test --help shows help text."""
        result = runner.invoke(app, ["--help"])
        assert result.exit_code == 0
        assert "<project-name>" in result.stdout.lower() or "usage" in result.stdout.lower()
```

### README.md

```markdown
# <project-name>

<Project description>.

## Installation

```bash
uv add <project-name>
```

## Usage

```bash
# Show version
<project-name> --version

# Show project info
<project-name> info
```

## Development

```bash
# Clone and install
git clone <repo-url>
cd <project-name>
uv sync --all-groups

# Run tests
uv run pytest

# Run linting
uv run ruff check .
uv run ruff format .

# Run type checking
uv run pyright

# Serve documentation
uv run mkdocs serve
```

## License

MIT
```

### .gitignore

```gitignore
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Virtual environments
.venv/
venv/
ENV/

# IDE
.idea/
.vscode/
*.swp
*.swo

# Testing
.coverage
htmlcov/
.pytest_cache/
.mypy_cache/

# Environment
.env
.env.*
!.env.example

# Generated
src/*/_version.py
site/

# OS
.DS_Store
Thumbs.db
```

### .python-version

```
3.14
```

### .claude/settings.json

```json
{
  "attribution": {
    "commit": "",
    "pr": ""
  }
}
```

This removes Claude Code attribution from commits and pull requests.

## Scaffold Process

1. **Parse arguments**: Extract project name and description
2. **Normalize names**:
   - `project-name` → kebab-case for CLI, pyproject.toml name
   - `package_name` → snake_case for Python imports
   - `ProjectName` → PascalCase for class names
   - `PROJECT_NAME` → UPPER_SNAKE for env prefix
3. **Create directories**: Build full directory structure
4. **Generate files**: Write all files with proper substitutions
5. **Initialize git**: `git init` and initial commit
6. **Install dependencies**: `uv sync --all-groups`
7. **Run initial checks**: `uv run ruff check . && uv run pytest`
8. **Report**: Show created structure and next steps

## Output Format

```
# Project Scaffolded: <project-name>

## Structure Created
<tree output>

## Files Generated
- pyproject.toml (project configuration)
- src/<package_name>/ (source code)
- tests/ (test suite)
- docs/ (documentation)
- .claude/settings.json (no attribution)
- README.md, .gitignore, .python-version

## CLI Available
<project-name> --version    # Show version
<project-name> info         # Show project info

## Next Steps
1. cd <project-name>
2. Review and customize pyproject.toml
3. Start implementing in src/<package_name>/services/
4. Run tests: uv run pytest
5. Create initial git tag: git tag -a v0.1.0 -m "Initial release"
```

## See Also

- **python** - Python conventions this scaffold follows
- **documentation** - MkDocs setup details
- **logging** - Loguru configuration
- **tdd** - Test-driven development approach
- **/compliance-check** - Verify scaffold compliance
