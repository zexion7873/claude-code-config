---
description: Python project conventions
globs: "**/*.py"
---

- Use type hints on all function signatures.
- Prefer `pathlib.Path` over `os.path`.
- Use `ruff` for linting and formatting (not black/isort separately).
- Prefer dataclasses or Pydantic models over plain dicts for structured data.
- Use `from __future__ import annotations` for deferred evaluation.
