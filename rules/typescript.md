---
description: TypeScript and JavaScript project conventions
globs: "**/*.{ts,tsx,js,jsx,mjs,cjs}"
---

- Use `const` by default; `let` only when reassignment is needed.
- Prefer `interface` over `type` for object shapes (better error messages, extensibility).
- Use `unknown` over `any`; narrow with type guards.
- Prefer named exports over default exports.
- Use `satisfies` for type-safe config objects that preserve literal types.
