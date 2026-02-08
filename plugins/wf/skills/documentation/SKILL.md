---
name: documentation
description: Generate and maintain project documentation using Material for MkDocs and mkdocstrings. Use when creating API references, building documentation sites, or writing user guides.
user-invocable: false
---

# Documentation

Generate and maintain documentation using Material for MkDocs and mkdocstrings. For full MkDocs configuration and the API reference generator script see [mkdocs.md](./mkdocs.md). For docstring conventions see the **conventions** skill.

## When to Use This Skill

Use when setting up a documentation site, generating API docs from code, writing user guides, or creating architecture documentation. Not for inline code comments or commit messages.

## Documentation Stack

| Tool | Purpose |
|------|---------|
| Material for MkDocs | Documentation site theme |
| mkdocstrings | Auto-generate API docs from docstrings |
| mkdocs-gen-files | Generate pages programmatically |
| mkdocs-literate-nav | Navigation from markdown |
| mkdocs-section-index | Section index pages |

## Directory Structure

```
${PROJECT_NAME}/
├── docs/
│   ├── index.md              # Homepage
│   ├── getting-started.md    # Quick start guide
│   ├── user-guide/           # User documentation
│   ├── reference/            # Auto-generated API docs
│   ├── development/          # Developer docs
│   └── scripts/
│       └── gen_ref_pages.py  # API docs generator script
├── mkdocs.yml                # MkDocs configuration
└── pyproject.toml
```

## Commands

```bash
uv sync --group docs             # Install docs dependencies
uv run mkdocs serve              # Local dev server with hot reload
uv run mkdocs build --strict     # Build static site
uv run mkdocs gh-deploy --force  # Deploy to GitHub Pages
```

## Writing Standards

1. **No emojis** in documentation
2. **Google-style docstrings** — see **conventions** skill for format
3. **Complete type hints** — rendered in API docs
4. **Working examples** — tested with doctest where possible
5. **Cross-references** — link to related APIs

### Admonitions

```markdown
!!! note
    This is a note.

!!! warning
    This is a warning.

??? info "Collapsible"
    Collapsed by default.
```

### Code Blocks with Annotations

````markdown
```python
result = process()  # (1)!

1. This annotation explains the line
```
````

### Cross-References

```markdown
See [`fetch_data`][${PROJECT_NAME}.services.api.fetch_data] for details.
The [`Config`][${PROJECT_NAME}.core.config.Config] class handles settings.
```

## See Also

- **conventions** — docstring format and coding conventions
- **tdd** — test documentation patterns
