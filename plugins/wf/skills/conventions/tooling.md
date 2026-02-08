# Python Tooling Configuration

Detailed configuration for the project's Python tooling stack.

## Package Manager: uv

```bash
uv add package           # Add dependency
uv add --dev pytest      # Add dev dependency
uv run pytest            # Run command
uv sync                  # Sync dependencies
uv sync --all-groups     # Sync all dependency groups
```

## Linting & Formatting: Ruff

```bash
uv run ruff check .      # Lint
uv run ruff format .     # Format
uv run ruff check --fix . # Auto-fix
```

**pyproject.toml**:
```toml
[tool.ruff]
line-length = 88
target-version = "py314"

[tool.ruff.lint]
select = ["E", "W", "F", "I", "B", "S", "C4", "UP", "N", "SIM"]
ignore = ["E501"]

[tool.ruff.lint.per-file-ignores]
"tests/*" = ["S101"]
```

## Type Checking: Pyright

```bash
uv run pyright           # Type check entire project
uv run pyright src/      # Type check specific directory
```

**pyproject.toml**:
```toml
[tool.pyright]
pythonVersion = "3.14"
typeCheckingMode = "strict"
include = ["src"]
exclude = ["**/__pycache__", ".venv"]
reportMissingTypeStubs = false
reportUnknownMemberType = false
```

Run pyright before committing to catch type errors early.

## Build System & Versioning: Hatch

Use hatchling with hatch-vcs for git-based versioning:

**pyproject.toml**:
```toml
[build-system]
requires = ["hatchling", "hatch-vcs"]
build-backend = "hatchling.build"

[tool.hatch.version]
source = "vcs"
fallback-version = "0.0.0+unknown"

[tool.hatch.build.hooks.vcs]
version-file = "src/${PROJECT_NAME}/_version.py"
```

Auto-generates `_version.py` from git tags:

```python
from ${PROJECT_NAME}._version import __version__
```

### Bumping Versions

Versions are derived from git tags:

```bash
git tag -a v1.0.0 -m "Release 1.0.0"
git push origin v1.0.0
```

| Git State | Version Example |
|-----------|-----------------|
| On tag `v1.2.3` | `1.2.3` |
| 4 commits after `v1.2.3` | `1.2.4.dev4+gabc1234` |
| No tags yet | `0.0.0+unknown` |

### Building

```bash
uv build                  # Build sdist and wheel
uv publish                # Publish to PyPI
```

## Testing: pytest

```bash
uv run pytest                    # Run all tests
uv run pytest tests/services/    # Run specific tests
uv run pytest -v --cov           # With coverage
```

**pyproject.toml**:
```toml
[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "-v --cov=src/${PROJECT_NAME} --cov-report=term-missing"
```

## Documentation: Material for MkDocs

```bash
uv run mkdocs serve              # Local dev server with hot reload
uv run mkdocs build --strict     # Build static site
uv run mkdocs gh-deploy --force  # Deploy to GitHub Pages
```

**pyproject.toml**:
```toml
[dependency-groups]
docs = [
    "mkdocs-material>=9.5",
    "mkdocstrings[python]>=0.27",
    "mkdocs-gen-files>=0.5",
    "mkdocs-literate-nav>=0.6",
    "mkdocs-section-index>=0.3",
]
```

See the **documentation** skill for full MkDocs configuration and mkdocstrings setup.
