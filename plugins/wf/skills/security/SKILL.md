---
name: security
description: Apply security best practices for Python applications. Use when handling secrets, validating user input, preventing injection attacks, managing dependencies, or reviewing code for vulnerabilities.
command: false
---

# Security Best Practices Skill

Apply security best practices for Python applications.

## When to Use This Skill

✅ **Use when:**
- Handling secrets (API keys, passwords, tokens)
- Validating user input
- Preventing injection attacks (SQL, command, path traversal)
- Managing dependencies and vulnerabilities
- Implementing authentication/authorization
- Reviewing code for security issues
- Configuring secure defaults

❌ **Don't use when:**
- Working with non-sensitive internal data
- Writing unit tests with mock data
- Making purely cosmetic changes

## Golden Rules

1. **Never commit secrets** - No API keys, passwords, tokens in code
2. **Validate all input** - Trust nothing from users
3. **Principle of least privilege** - Minimal permissions
4. **Defense in depth** - Multiple security layers
5. **Secure by default** - Safe configurations out of the box

## Secrets Management

### Environment Variables

```python
import os

# Required secrets - fail fast if missing
API_KEY = os.environ["API_KEY"]  # Raises KeyError if not set

# Optional with validation
DATABASE_URL = os.getenv("DATABASE_URL")
if not DATABASE_URL:
    raise ValueError("DATABASE_URL environment variable is required")

# Never do this
API_KEY = "sk-1234567890abcdef"  # NEVER hardcode secrets!
```

### Pydantic Settings

```python
from pydantic import SecretStr
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    """Application settings with secret handling."""

    api_key: SecretStr  # Masked in logs/repr
    database_url: SecretStr
    debug: bool = False

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

# .env.example - safe to commit (no real values)
${PROJECT_NAME}_API_KEY=your-api-key-here
${PROJECT_NAME}_DATABASE_URL=postgresql://user:pass@localhost/db
```

```json
// .claude/settings.json - protect .env from Claude
{
  "permissions": {
    "deny": [
      "Read(.env)",
      "Read(.env.*)",
      "Read(**/.env)",
      "Read(**/.env.*)",
      "Write(.env)",
      "Write(.env.*)"
    ]
  }
}
```

## Input Validation

### Basic Validation

```python
import re
from typing import Annotated
from pydantic import BaseModel, Field, field_validator

class UserInput(BaseModel):
    """Validated user input."""

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

### Sanitization

```python
import html
import re

def sanitize_html(text: str) -> str:
    """Escape HTML to prevent XSS."""
    return html.escape(text)

def sanitize_filename(filename: str) -> str:
    """Remove dangerous characters from filename."""
    # Remove path separators and null bytes
    sanitized = re.sub(r'[/\\:\x00]', '', filename)
    # Remove leading dots (hidden files)
    sanitized = sanitized.lstrip('.')
    # Limit length
    return sanitized[:255] if sanitized else "unnamed"

def strip_control_chars(text: str) -> str:
    """Remove control characters except newlines and tabs."""
    return re.sub(r'[\x00-\x08\x0b\x0c\x0e-\x1f\x7f]', '', text)
```

## Injection Prevention

### SQL Injection

```python
# NEVER do this - SQL injection vulnerability!
query = f"SELECT * FROM users WHERE id = {user_id}"

# ALWAYS use parameterized queries
cursor.execute("SELECT * FROM users WHERE id = ?", (user_id,))

# SQLAlchemy - safe by default
from sqlalchemy import select
stmt = select(User).where(User.id == user_id)

# For dynamic column names (rare), use allowlist
ALLOWED_COLUMNS = {"name", "email", "created_at"}
def order_by(column: str) -> str:
    if column not in ALLOWED_COLUMNS:
        raise ValueError(f"Invalid column: {column}")
    return column
```

### Command Injection

```python
import subprocess
import shlex

# NEVER do this - command injection!
os.system(f"ls {user_input}")
subprocess.run(f"grep {pattern} {filename}", shell=True)

# ALWAYS use list arguments (no shell)
subprocess.run(["ls", user_input], check=True)
subprocess.run(["grep", pattern, filename], check=True)

# If shell is absolutely required, validate strictly
def safe_filename(name: str) -> str:
    """Validate filename for shell use."""
    if not re.match(r'^[a-zA-Z0-9._-]+$', name):
        raise ValueError(f"Invalid filename: {name}")
    return shlex.quote(name)
```

### Path Traversal

```python
from pathlib import Path

def read_user_file(filename: str, base_dir: Path) -> str:
    """Read file with path traversal protection."""
    # Resolve to absolute path
    base_dir = base_dir.resolve()
    filepath = (base_dir / filename).resolve()

    # Verify file is within allowed directory
    if not filepath.is_relative_to(base_dir):
        raise ValueError(f"Path traversal attempt: {filename}")

    # Additional checks
    if not filepath.is_file():
        raise FileNotFoundError(f"File not found: {filename}")

    return filepath.read_text()

# Example attacks this prevents:
# "../../../etc/passwd"
# "....//....//etc/passwd"
# "/etc/passwd"
```

### Template Injection

```python
from jinja2 import Environment, select_autoescape, sandbox

# Safe Jinja2 configuration
env = Environment(
    autoescape=select_autoescape(["html", "xml"]),
    # Use sandbox for untrusted templates
)

# For user-provided templates, use sandbox
sandbox_env = sandbox.SandboxedEnvironment()

# NEVER do this with user input
template_string = user_input  # Dangerous!
env.from_string(template_string).render()
```

## Authentication & Authorization

### Password Hashing

```python
import secrets
from passlib.context import CryptContext

# Configure password hashing
pwd_context = CryptContext(
    schemes=["argon2", "bcrypt"],
    deprecated="auto",
)

def hash_password(password: str) -> str:
    """Hash password for storage."""
    return pwd_context.hash(password)

def verify_password(password: str, hashed: str) -> bool:
    """Verify password against hash."""
    return pwd_context.verify(password, hashed)

# Generate secure tokens
def generate_token(length: int = 32) -> str:
    """Generate cryptographically secure token."""
    return secrets.token_urlsafe(length)
```

### Secure Session Tokens

```python
import secrets
import hashlib
from datetime import datetime, timedelta

def create_session_token() -> str:
    """Create secure session token."""
    return secrets.token_urlsafe(32)

def hash_token(token: str) -> str:
    """Hash token for storage (don't store raw tokens)."""
    return hashlib.sha256(token.encode()).hexdigest()

def is_token_expired(created_at: datetime, max_age_hours: int = 24) -> bool:
    """Check if token has expired."""
    return datetime.utcnow() > created_at + timedelta(hours=max_age_hours)
```

## Dependency Security

### Audit Dependencies

```bash
# Install audit tool
uv add --dev pip-audit

# Run security audit
uv run pip-audit

# Check for outdated packages
uv pip list --outdated

# Update specific package
uv add package --upgrade

# Update all dependencies
uv sync --upgrade
```

### Pin Dependencies

```toml
# pyproject.toml - pin major versions
[project]
dependencies = [
    "httpx>=0.27,<1.0",
    "pydantic>=2.0,<3.0",
]

# Use uv.lock for exact versions (auto-generated)
```

### Vulnerability Monitoring

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "pip"
    directory: "/"
    schedule:
      interval: "weekly"
    open-pull-requests-limit: 5
```

## Logging Security Events

```python
from ${PROJECT_NAME}.core import logger

def log_auth_attempt(username: str, success: bool, ip: str) -> None:
    """Log authentication attempt."""
    if success:
        logger.info(f"Auth success: user={username} ip={ip}")
    else:
        logger.warning(f"Auth failure: user={username} ip={ip}")

def log_permission_denied(user_id: int, resource: str, action: str) -> None:
    """Log authorization failure."""
    logger.warning(
        f"Permission denied: user={user_id} resource={resource} action={action}"
    )

# NEVER log sensitive data
logger.info(f"User logged in: {username}")  # OK
logger.info(f"Password: {password}")  # NEVER!
logger.info(f"Token: {token[:8]}...")  # Partial OK for debugging
```

## Secure Defaults

```python
import ssl
import httpx

# HTTPS by default
DEFAULT_TIMEOUT = 30
DEFAULT_VERIFY_SSL = True

async def fetch(url: str) -> dict:
    """Fetch with secure defaults."""
    async with httpx.AsyncClient(
        timeout=DEFAULT_TIMEOUT,
        verify=DEFAULT_VERIFY_SSL,
        follow_redirects=False,  # Explicit redirect handling
    ) as client:
        response = await client.get(url)
        response.raise_for_status()
        return response.json()

# SSL context for servers
def create_ssl_context() -> ssl.SSLContext:
    """Create secure SSL context."""
    context = ssl.create_default_context()
    context.minimum_version = ssl.TLSVersion.TLSv1_2
    return context
```

## Security Checklist

Before deploying, verify:

- [ ] No secrets in code or version control
- [ ] All user input validated and sanitized
- [ ] Parameterized queries for all database operations
- [ ] No shell=True with user input
- [ ] Path traversal protection on file operations
- [ ] Passwords hashed with strong algorithm (Argon2/bcrypt)
- [ ] Dependencies audited for vulnerabilities
- [ ] Security events logged (without sensitive data)
- [ ] HTTPS enforced for all external communication
- [ ] Error messages don't leak internal details

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

## Output Format

When reporting security improvements:

```
## Security Review Report

### Vulnerabilities Found
- [HIGH] SQL injection in `get_user()` - user_id not parameterized
- [MEDIUM] Path traversal possible in `download_file()`
- [LOW] Debug mode enabled in production config

### Fixes Applied
- Converted raw SQL to parameterized query
- Added path validation with resolve() check
- Set DEBUG=False as default

### Recommendations
- Add rate limiting to authentication endpoints
- Implement CSRF protection for forms
- Set up dependency vulnerability scanning in CI
```
