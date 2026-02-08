# Python File Templates

Standard templates for new Python files in the project.

## New Module

```python
"""Module description.

This module provides functionality for...
"""

from ${PROJECT_NAME}.core import logger

__all__ = ["main_function", "MainClass"]


def main_function(arg: str) -> str:
    """Do something with arg.

    Args:
        arg: The input argument.

    Returns:
        Processed result.
    """
    logger.debug(f"Processing: {arg}")
    return arg.upper()


class MainClass:
    """Class description."""

    def __init__(self, value: str) -> None:
        """Initialize with value.

        Args:
            value: Initial value.
        """
        self.value = value
```

## New Pydantic Model

```python
"""Module description models."""

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

## New Test File

```python
"""Tests for module_name."""

import pytest

from ${PROJECT_NAME}.services.module_name import main_function, MainClass


class TestMainFunction:
    """Tests for main_function."""

    def test_returns_uppercase(self) -> None:
        result = main_function("hello")
        assert result == "HELLO"

    def test_raises_on_empty_input(self) -> None:
        with pytest.raises(ValueError, match="cannot be empty"):
            main_function("")


class TestMainClass:
    """Tests for MainClass."""

    def test_init_stores_value(self) -> None:
        obj = MainClass("test")
        assert obj.value == "test"
```
