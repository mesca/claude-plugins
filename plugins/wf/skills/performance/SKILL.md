---
name: performance
description: Apply performance optimization best practices. Use when profiling slow code, optimizing memory usage, implementing caching, handling large datasets, or improving database queries.
user-invocable: false
---

# Performance Optimization Skill

Apply performance optimization best practices for Python applications.

## When to Use This Skill

✅ **Use when:**
- Profiling slow or memory-intensive code
- Implementing caching strategies
- Processing large datasets or files
- Optimizing database queries
- Adding async/concurrent processing
- Reducing memory footprint
- Improving startup time

❌ **Don't use when:**
- Writing initial implementations (make it work first)
- Code without measured performance issues
- Premature optimization without profiling data
- Micro-optimizations that hurt readability

## Golden Rule

**Profile before optimizing.** Never guess where bottlenecks are.

```bash
# CPU profiling
uv run python -m cProfile -s cumtime script.py

# Memory profiling
uv add --dev memray
uv run memray run script.py
uv run memray flamegraph memray-output.bin
```

## Profiling Tools

### CPU Profiling

```python
import cProfile
import pstats
from io import StringIO

def profile_function(func, *args, **kwargs):
    """Profile a function and print stats."""
    profiler = cProfile.Profile()
    profiler.enable()
    result = func(*args, **kwargs)
    profiler.disable()

    stream = StringIO()
    stats = pstats.Stats(profiler, stream=stream)
    stats.sort_stats("cumulative")
    stats.print_stats(20)
    print(stream.getvalue())

    return result
```

### Timing Decorator

```python
import time
from functools import wraps
from typing import Callable, ParamSpec, TypeVar

from ${PROJECT_NAME}.core import logger

P = ParamSpec("P")
R = TypeVar("R")

def timed(func: Callable[P, R]) -> Callable[P, R]:
    """Log function execution time."""
    @wraps(func)
    def wrapper(*args: P.args, **kwargs: P.kwargs) -> R:
        start = time.perf_counter()
        result = func(*args, **kwargs)
        elapsed = time.perf_counter() - start
        logger.debug(f"{func.__name__} took {elapsed:.3f}s")
        return result
    return wrapper
```

## Caching Strategies

### In-Memory Caching

```python
from functools import lru_cache, cache

# LRU cache with size limit
@lru_cache(maxsize=128)
def expensive_calculation(n: int) -> int:
    """Cache results of expensive computation."""
    return sum(i**2 for i in range(n))

# Unlimited cache (Python 3.9+)
@cache
def fibonacci(n: int) -> int:
    """Cache all results."""
    if n < 2:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)

# Clear cache when needed
expensive_calculation.cache_clear()
```

### TTL Cache

```python
from cachetools import TTLCache
from cachetools.func import ttl_cache

# Cache with 10-minute expiration
@ttl_cache(maxsize=100, ttl=600)
def fetch_user_data(user_id: int) -> dict:
    """Fetch with time-based cache expiration."""
    return api.get_user(user_id)

# Manual TTL cache
cache: TTLCache[str, dict] = TTLCache(maxsize=100, ttl=600)

def get_config(key: str) -> dict:
    if key not in cache:
        cache[key] = load_config(key)
    return cache[key]
```

### Async Caching

```python
from aiocache import cached, Cache

@cached(ttl=300, cache=Cache.MEMORY)
async def fetch_data(url: str) -> dict:
    """Async function with caching."""
    async with httpx.AsyncClient() as client:
        response = await client.get(url)
        return response.json()
```

## Memory Optimization

### Generators for Large Data

```python
from collections.abc import Iterator
from typing import Any

# Bad - loads entire file into memory
def read_all_lines(filepath: str) -> list[str]:
    with open(filepath) as f:
        return f.readlines()  # Memory spike!

# Good - yields one line at a time
def read_lines(filepath: str) -> Iterator[str]:
    with open(filepath) as f:
        for line in f:
            yield line.strip()

# Good - process in chunks
def process_large_file(filepath: str, chunk_size: int = 8192) -> Iterator[bytes]:
    with open(filepath, "rb") as f:
        while chunk := f.read(chunk_size):
            yield chunk
```

### __slots__ for Many Objects

```python
# Without slots: ~400 bytes per instance
class PointRegular:
    def __init__(self, x: float, y: float) -> None:
        self.x = x
        self.y = y

# With slots: ~56 bytes per instance
class PointOptimized:
    __slots__ = ("x", "y")

    def __init__(self, x: float, y: float) -> None:
        self.x = x
        self.y = y
```

### Data Classes with Slots

```python
from dataclasses import dataclass

@dataclass(slots=True)
class User:
    id: int
    name: str
    email: str
```

## Bulk Operations

### Database Bulk Insert

```python
# Bad - N individual inserts
for user in users:
    db.execute("INSERT INTO users (name) VALUES (?)", (user.name,))

# Good - single bulk insert
db.executemany(
    "INSERT INTO users (name) VALUES (?)",
    [(u.name,) for u in users]
)

# SQLAlchemy bulk insert
session.bulk_insert_mappings(User, [{"name": u.name} for u in users])
```

### Batch API Calls

```python
import asyncio
from itertools import batched  # Python 3.12+

async def fetch_users(user_ids: list[int], batch_size: int = 50) -> list[User]:
    """Fetch users in batches to avoid overwhelming API."""
    results = []
    for batch in batched(user_ids, batch_size):
        batch_results = await asyncio.gather(
            *[api.get_user(uid) for uid in batch]
        )
        results.extend(batch_results)
        await asyncio.sleep(0.1)  # Rate limiting
    return results
```

## Async/Concurrent Processing

### Async I/O

```python
import asyncio
import httpx

async def fetch_all(urls: list[str]) -> list[dict]:
    """Fetch multiple URLs concurrently."""
    async with httpx.AsyncClient() as client:
        tasks = [client.get(url) for url in urls]
        responses = await asyncio.gather(*tasks)
        return [r.json() for r in responses]

# With concurrency limit
async def fetch_with_limit(urls: list[str], limit: int = 10) -> list[dict]:
    """Fetch with semaphore to limit concurrent requests."""
    semaphore = asyncio.Semaphore(limit)

    async def fetch_one(url: str) -> dict:
        async with semaphore:
            async with httpx.AsyncClient() as client:
                response = await client.get(url)
                return response.json()

    return await asyncio.gather(*[fetch_one(url) for url in urls])
```

### Thread Pool for CPU-bound in Async

```python
import asyncio
from concurrent.futures import ThreadPoolExecutor

executor = ThreadPoolExecutor(max_workers=4)

async def process_with_threads(items: list[str]) -> list[str]:
    """Run CPU-bound work in thread pool."""
    loop = asyncio.get_event_loop()
    tasks = [
        loop.run_in_executor(executor, cpu_intensive_function, item)
        for item in items
    ]
    return await asyncio.gather(*tasks)
```

## Database Optimization

### Avoid N+1 Queries

```python
# Bad - N+1 queries
users = session.query(User).all()
for user in users:
    print(user.posts)  # Each access triggers a query!

# Good - eager loading
users = session.query(User).options(joinedload(User.posts)).all()
for user in users:
    print(user.posts)  # Already loaded
```

### Use Indexes

```sql
-- Add indexes for frequently queried columns
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_posts_user_id ON posts(user_id);

-- Composite index for common query patterns
CREATE INDEX idx_posts_user_created ON posts(user_id, created_at DESC);
```

### Pagination

```python
from sqlalchemy import select

def get_users_paginated(
    session: Session,
    page: int = 1,
    per_page: int = 20,
) -> list[User]:
    """Fetch users with offset pagination."""
    offset = (page - 1) * per_page
    stmt = select(User).offset(offset).limit(per_page)
    return list(session.scalars(stmt))

# Cursor-based pagination (better for large datasets)
def get_users_cursor(
    session: Session,
    after_id: int | None = None,
    limit: int = 20,
) -> list[User]:
    """Fetch users after a cursor ID."""
    stmt = select(User).order_by(User.id).limit(limit)
    if after_id:
        stmt = stmt.where(User.id > after_id)
    return list(session.scalars(stmt))
```

## Lazy Loading

```python
from functools import cached_property

class DataProcessor:
    """Load expensive resources only when needed."""

    def __init__(self, config_path: str) -> None:
        self._config_path = config_path

    @cached_property
    def config(self) -> dict:
        """Load config on first access only."""
        return load_config(self._config_path)

    @cached_property
    def model(self) -> Model:
        """Load ML model on first access only."""
        return load_model(self.config["model_path"])
```

## Quick Reference

| Technique | Use Case |
|-----------|----------|
| `@lru_cache` | Pure functions, repeated calls |
| `@ttl_cache` | Data that expires |
| Generators | Large files, streaming data |
| `__slots__` | Many instances of same class |
| Bulk operations | Database inserts/updates |
| `asyncio.gather` | Concurrent I/O operations |
| `ThreadPoolExecutor` | CPU-bound in async context |
| Eager loading | Avoid N+1 database queries |
| Cursor pagination | Large result sets |

## Output Format

When reporting performance improvements:

```
## Performance Optimization Report

### Changes Made
- Added LRU cache to `calculate_metrics()` - eliminates redundant computation
- Replaced list comprehension with generator in `process_files()`
- Added database index on `users.email`

### Measurements
- Before: 4.2s for 1000 items
- After: 0.8s for 1000 items
- Improvement: 5.25x faster

### Memory Impact
- Peak memory reduced from 512MB to 48MB

### Recommendations
- Consider Redis cache for multi-process scenarios
- Monitor cache hit rate in production
```
