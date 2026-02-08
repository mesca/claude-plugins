---
name: spec-driven
description: Enforce spec-driven development with contracts as single source of truth and models-first coding. Always apply when designing APIs, creating services, or writing data models.
user-invocable: false
---

# Spec-Driven Development

Contracts are the single source of truth. Pydantic models come before implementation. Always.

## Contracts Directory

Every project with an API (REST, JSON-RPC, or both) must have a contracts directory inside the source package:

```
src/${PROJECT_NAME}/
├── contracts/              # Single source of truth
│   ├── openapi.yaml        # REST API schema (OpenAPI 3.1)
│   └── openrpc.yaml        # JSON-RPC schema (OpenRPC 1.3)
├── models/                 # Top-level shared models
├── core/
├── services/
└── interfaces/
```

### Rules

- **Write the contract first** — before any implementation, define the API surface in `contracts/`
- **OpenAPI 3.1** for REST/HTTP APIs (`openapi.yaml`)
- **OpenRPC 1.3** for JSON-RPC APIs (`openrpc.yaml`)
- Schemas in contracts define the canonical data shapes — Pydantic models must match them
- When the contract changes, update models and implementation to match
- Contracts are versioned alongside the code — no separate schema repo

### Contract Structure

OpenAPI example:

```yaml
openapi: "3.1.0"
info:
  title: ${PROJECT_NAME}
  version: "0.1.0"
paths:
  /items:
    get:
      summary: List items
      responses:
        "200":
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: "#/components/schemas/Item"
components:
  schemas:
    Item:
      type: object
      required: [id, name]
      properties:
        id:
          type: integer
        name:
          type: string
        description:
          type: string
          default: ""
```

OpenRPC example:

```yaml
openrpc: "1.3.2"
info:
  title: ${PROJECT_NAME}
  version: "0.1.0"
methods:
  - name: get_item
    params:
      - name: item_id
        schema:
          type: integer
    result:
      name: item
      schema:
        $ref: "#/components/schemas/Item"
components:
  schemas:
    Item:
      type: object
      required: [id, name]
      properties:
        id:
          type: integer
        name:
          type: string
```

## Models-First Development

Pydantic models are written **before** the code that uses them. Models live in `models/` directories at each relevant architectural level.

### Model Placement

```
src/${PROJECT_NAME}/
├── models/                 # Shared domain models (used across layers)
│   ├── __init__.py
│   ├── item.py             # e.g. Item, ItemCreate, ItemUpdate
│   └── user.py
├── services/
│   ├── models/             # Service-specific models (DTOs, internal state)
│   │   ├── __init__.py
│   │   └── processing.py   # e.g. ProcessingResult, ProcessingOptions
│   └── item_service.py
└── interfaces/
    ├── cli/
    │   └── models/          # CLI-specific models (command args, output)
    │       ├── __init__.py
    │       └── args.py
    └── rest/
        └── models/          # API-specific models (request/response bodies)
            ├── __init__.py
            └── responses.py  # e.g. PaginatedResponse, ErrorResponse
```

### Rules

- **Top-level `models/`**: Shared domain models — entities referenced by multiple layers
- **Layer `models/`**: Layer-specific models — DTOs, request/response shapes, internal state
- Create `models/` directories only when the layer needs them (not preemptively)
- Models in a lower layer must not import from a higher layer (`models/` never imports from `services/`)

### Model Conventions

```python
"""Item domain models."""

from pydantic import BaseModel, Field


class ItemBase(BaseModel):
    """Shared fields for Item models."""

    name: str = Field(min_length=1, max_length=200)
    description: str = ""


class ItemCreate(ItemBase):
    """Fields required to create an item."""

    pass


class ItemUpdate(BaseModel):
    """Fields that can be updated on an item. All optional."""

    name: str | None = None
    description: str | None = None


class Item(ItemBase):
    """Full item as stored and returned."""

    id: int
```

### Workflow

The development order is always:

1. **Contract** — define the API surface in `contracts/` (OpenAPI/OpenRPC)
2. **Models** — write Pydantic models matching the contract schemas
3. **Tests** — write failing tests against the models and expected behavior
4. **Implementation** — write services and interfaces to pass the tests

This integrates with TDD: models define the data shapes, tests define the behavior, implementation satisfies both.

### Contract-to-Model Alignment

Every schema defined in `contracts/` must have a corresponding Pydantic model:

| Contract schema | Pydantic model location |
|----------------|------------------------|
| `components/schemas/Item` | `models/item.py::Item` |
| `components/schemas/ItemCreate` | `models/item.py::ItemCreate` |
| Request body schemas | `interfaces/rest/models/` |
| Response wrapper schemas | `interfaces/rest/models/` |
| Method params (OpenRPC) | `interfaces/*/models/` |

Field names, types, and constraints in models must match the contract. If they diverge, the contract wins — update the model.

## See Also

- **conventions** — project structure and coding standards
- **tdd** — test-driven development workflow (models → tests → code)
- **security** — input validation with Pydantic
- **/init** — scaffolds `contracts/` directory in new projects
- **/audit** — audits contract and model compliance
