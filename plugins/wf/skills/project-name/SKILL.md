---
name: project-name
description: Detect and provide the project name from package.json or pyproject.toml. Use when you need the project name, package name, or module name for imports, paths, or documentation.
user-invocable: false
---

# Project Name Skill

Detect the project name from configuration files and make it available as `${PROJECT_NAME}` for use in other skills and instructions.

## When to Use This Skill

✅ **Use when:**
- You need the project/package name for import statements
- Constructing paths like `src/{PROJECT_NAME}/`
- Writing documentation that references the package
- Any skill or instruction references `${PROJECT_NAME}`

❌ **Don't use when:**
- The project name is already known and hardcoded
- Working outside a Python or Node.js project

## Detection Order

1. **pyproject.toml** (Python projects)
   ```toml
   [project]
   name = "my-package"
   ```

2. **package.json** (Node.js projects)
   ```json
   {
     "name": "my-package"
   }
   ```

3. **Ask user** (if neither file exists or name not found)

## Instructions

When `${PROJECT_NAME}` is referenced or you need the project name:

1. **Check for pyproject.toml** at project root
   - Look for `[project]` section with `name` field
   - If found, use this as `${PROJECT_NAME}`

2. **Check for package.json** at project root
   - Look for `"name"` field at top level
   - If found, use this as `${PROJECT_NAME}`

3. **Ask the user** if neither file contains a project name
   - "What is your project/package name?"
   - Store the response as `${PROJECT_NAME}`

## Python Package Name Normalization

For Python projects, normalize the name for imports:
- Replace hyphens with underscores: `my-package` → `my_package`
- Use normalized name for import paths: `from my_package.core import ...`
- Use original name for pyproject.toml references

## Usage in Other Skills

Other skills can reference the project name using `${PROJECT_NAME}`:

```markdown
# Example usage in another skill

Import the logger:
```python
from ${PROJECT_NAME}.core import logger
```

Project structure:
```
src/${PROJECT_NAME}/
├── core/
├── models/
└── services/
```
```

## Output

When this skill is invoked, provide:

```
Project name: ${PROJECT_NAME}
Source: pyproject.toml | package.json | user input
Normalized (Python imports): ${PROJECT_NAME_NORMALIZED}
```

## Example

**pyproject.toml**:
```toml
[project]
name = "my-awesome-tool"
```

**Result**:
```
Project name: my-awesome-tool
Source: pyproject.toml
Normalized (Python imports): my_awesome_tool
```

**Usage**:
- Import: `from my_awesome_tool.core import logger`
- Path: `src/my_awesome_tool/services/`
