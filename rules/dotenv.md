---
description: Protect sensitive files from accidental exposure
globs: "**/.env*,**/credentials*,**/*secret*,**/config.json"
---

- NEVER commit .env files or credentials to git.
- NEVER log, print, or echo secret values.
- Use environment variables or secret managers for sensitive config.
- When creating .env.example, use placeholder values only.
