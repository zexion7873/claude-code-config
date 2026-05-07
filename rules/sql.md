---
description: SQL and database conventions
globs: "**/*.sql"
---

- Always use parameterized queries — never string interpolation.
- Prefer explicit column lists over `SELECT *`.
- Add `IF EXISTS` / `IF NOT EXISTS` guards on DDL statements.
- Use `BEGIN` / `COMMIT` for multi-statement migrations.
- Comment non-obvious WHERE clauses or JOIN conditions.
