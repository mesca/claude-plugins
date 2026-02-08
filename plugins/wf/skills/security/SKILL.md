---
name: security
description: Apply security best practices for Python applications. Use when handling secrets, validating user input, preventing injection attacks, managing dependencies, or reviewing code for vulnerabilities.
user-invocable: false
---

# Security Best Practices

## Golden Rules

1. **Never commit secrets** - No API keys, passwords, tokens in code
2. **Validate all input** - Trust nothing from users
3. **Principle of least privilege** - Minimal permissions
4. **Defense in depth** - Multiple security layers
5. **Secure by default** - Safe configurations out of the box

## Secrets Management

### Pydantic SecretStr

```python
from pydantic import SecretStr
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    api_key: SecretStr  # Masked in logs/repr
    database_url: SecretStr

    model_config = {
        "env_prefix": "${PROJECT_NAME}_",
        "env_file": ".env",
        "env_file_encoding": "utf-8",
    }

settings = Settings()

# Access secret value when needed
api_key_value = settings.api_key.get_secret_value()

# Safe to log - shows '**********'
logger.info(f"Using API key: {settings.api_key}")
```

### .env File Protection

```bash
# .gitignore - MUST include
.env
.env.*
!.env.example
```

```json
// .claude/settings.json - protect .env from Claude
{
  "permissions": {
    "deny": [
      "Read(.env)", "Read(.env.*)", "Read(**/.env)", "Read(**/.env.*)",
      "Write(.env)", "Write(.env.*)"
    ]
  }
}
```

## Input Validation

```python
from typing import Annotated
from pydantic import BaseModel, Field, field_validator

class UserInput(BaseModel):
    username: Annotated[str, Field(min_length=3, max_length=50, pattern=r"^[a-zA-Z0-9_]+$")]
    email: Annotated[str, Field(pattern=r"^[^@]+@[^@]+\.[^@]+$")]
    age: Annotated[int, Field(ge=0, le=150)]

    @field_validator("username")
    @classmethod
    def username_not_reserved(cls, v: str) -> str:
        reserved = {"admin", "root", "system", "null", "undefined"}
        if v.lower() in reserved:
            raise ValueError(f"Username '{v}' is reserved")
        return v
```

## Injection Prevention

### SQL Injection

```python
# NEVER: f"SELECT * FROM users WHERE id = {user_id}"
# ALWAYS: parameterized queries
cursor.execute("SELECT * FROM users WHERE id = ?", (user_id,))

# SQLAlchemy - safe by default
stmt = select(User).where(User.id == user_id)
```

### Command Injection

```python
import subprocess

# NEVER: subprocess.run(f"grep {pattern} {filename}", shell=True)
# ALWAYS: list arguments, no shell
subprocess.run(["grep", pattern, filename], check=True)
```

### Path Traversal

```python
from pathlib import Path

def read_user_file(filename: str, base_dir: Path) -> str:
    base_dir = base_dir.resolve()
    filepath = (base_dir / filename).resolve()

    if not filepath.is_relative_to(base_dir):
        raise ValueError(f"Path traversal attempt: {filename}")

    return filepath.read_text()
```

### Template Injection

```python
from jinja2 import Environment, select_autoescape, sandbox

# Safe Jinja2 configuration
env = Environment(autoescape=select_autoescape(["html", "xml"]))

# For user-provided templates, use sandbox
sandbox_env = sandbox.SandboxedEnvironment()
```

## Authentication & Authorization

### Password Hashing

```python
from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["argon2", "bcrypt"], deprecated="auto")

def hash_password(password: str) -> str:
    return pwd_context.hash(password)

def verify_password(password: str, hashed: str) -> bool:
    return pwd_context.verify(password, hashed)
```

### Secure Tokens

```python
import secrets

def generate_token(length: int = 32) -> str:
    return secrets.token_urlsafe(length)
```

## Dependency Security

```bash
uv add --dev pip-audit
uv run pip-audit              # Security audit
uv pip list --outdated        # Check outdated
uv sync --upgrade             # Update all
```

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "pip"
    directory: "/"
    schedule:
      interval: "weekly"
```

## Logging Security Events

```python
# Log auth events - NEVER log passwords or full tokens
logger.info(f"Auth success: user={username} ip={ip}")
logger.warning(f"Auth failure: user={username} ip={ip}")
logger.warning(f"Permission denied: user={user_id} resource={resource}")
```

## Quick Reference

| Threat | Prevention |
|--------|------------|
| Secrets in code | Environment variables, SecretStr |
| SQL injection | Parameterized queries |
| Command injection | List arguments, no shell=True |
| Path traversal | resolve() + is_relative_to() |
| XSS | html.escape(), autoescape |
| Weak passwords | Argon2/bcrypt hashing |
| Vulnerable deps | pip-audit, dependabot |

## See Also

- **conventions** — error handling and configuration patterns
