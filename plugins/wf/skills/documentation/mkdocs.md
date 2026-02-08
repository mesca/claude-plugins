# MkDocs Configuration

Full configuration for Material for MkDocs with mkdocstrings.

## mkdocs.yml

```yaml
site_name: ${PROJECT_NAME}
site_description: Project description here
site_url: https://username.github.io/${PROJECT_NAME}
repo_url: https://github.com/username/${PROJECT_NAME}
repo_name: username/${PROJECT_NAME}

theme:
  name: material
  palette:
    - media: "(prefers-color-scheme: light)"
      scheme: default
      primary: indigo
      accent: indigo
      toggle:
        icon: material/brightness-7
        name: Switch to dark mode
    - media: "(prefers-color-scheme: dark)"
      scheme: slate
      primary: indigo
      accent: indigo
      toggle:
        icon: material/brightness-4
        name: Switch to light mode
  features:
    - content.code.copy
    - content.code.annotate
    - navigation.instant
    - navigation.instant.prefetch
    - navigation.tabs
    - navigation.sections
    - navigation.expand
    - navigation.top
    - search.highlight
    - search.suggest
    - toc.follow

plugins:
  - search
  - gen-files:
      scripts:
        - docs/scripts/gen_ref_pages.py
  - literate-nav:
      nav_file: SUMMARY.md
  - section-index
  - mkdocstrings:
      handlers:
        python:
          paths: [src]
          options:
            docstring_style: google
            docstring_options:
              ignore_init_summary: true
            merge_init_into_class: true
            show_root_heading: true
            show_root_full_path: false
            show_symbol_type_heading: true
            show_symbol_type_toc: true
            show_signature_annotations: true
            separate_signature: true
            signature_crossrefs: true
            summary: true
            show_source: true

markdown_extensions:
  - admonition
  - pymdownx.details
  - pymdownx.superfences
  - pymdownx.highlight:
      anchor_linenums: true
  - pymdownx.inlinehilite
  - pymdownx.snippets
  - pymdownx.tabbed:
      alternate_style: true
  - toc:
      permalink: true
  - attr_list
  - md_in_html

nav:
  - Home: index.md
  - Getting Started: getting-started.md
  - User Guide:
      - user-guide/index.md
      - Installation: user-guide/installation.md
      - Configuration: user-guide/configuration.md
      - Usage: user-guide/usage.md
  - API Reference: reference/
  - Development:
      - development/index.md
      - Contributing: development/contributing.md
      - Architecture: development/architecture.md
```

## API Reference Generator Script

Create `docs/scripts/gen_ref_pages.py`:

```python
"""Generate API reference pages for mkdocstrings."""

from pathlib import Path

import mkdocs_gen_files

nav = mkdocs_gen_files.Nav()

src = Path(__file__).parent.parent / "src"

for path in sorted(src.rglob("*.py")):
    module_path = path.relative_to(src).with_suffix("")
    doc_path = path.relative_to(src).with_suffix(".md")
    full_doc_path = Path("reference", doc_path)

    parts = tuple(module_path.parts)

    if parts[-1].startswith("_") and parts[-1] != "__init__":
        continue

    if parts[-1] == "__init__":
        parts = parts[:-1]
        if not parts:
            continue
        doc_path = doc_path.with_name("index.md")
        full_doc_path = full_doc_path.with_name("index.md")

    nav[parts] = doc_path.as_posix()

    with mkdocs_gen_files.open(full_doc_path, "w") as fd:
        identifier = ".".join(parts)
        fd.write(f"::: {identifier}")

    mkdocs_gen_files.set_edit_path(full_doc_path, path.relative_to(src.parent))

with mkdocs_gen_files.open("reference/SUMMARY.md", "w") as nav_file:
    nav_file.writelines(nav.build_literate_nav())
```

## pyproject.toml Docs Dependencies

```toml
[dependency-groups]
docs = [
    "mkdocs-material>=9.5",
    "mkdocstrings[python]>=0.27",
    "mkdocs-gen-files>=0.5",
    "mkdocs-literate-nav>=0.6",
    "mkdocs-section-index>=0.3",
]

[tool.hatch.envs.docs]
features = ["docs"]

[tool.hatch.envs.docs.scripts]
build = "mkdocs build --strict"
serve = "mkdocs serve"
deploy = "mkdocs gh-deploy --force"
```
