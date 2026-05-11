# Pull Request Enhancement

Generate a high-quality PR description and review hotspots from the current branch's diff.

## Input

`$ARGUMENTS` — optional base branch (default: `main`) or PR-specific intent the user wants emphasized.

## Workflow

1. **Read the diff**: `git status`, `git log <base>..HEAD`, `git diff <base>..HEAD --stat`, and the full diff for substantive files.
2. **Group commits and files** by logical unit: feature additions, refactors, fixes, test changes, config / infra, docs.
3. **Extract intent** from commit messages and code. If commits are unclear, ask the user before guessing.
4. **Draft the description** using the template below. Keep it scannable.
5. **Flag risk**: breaking changes, migrations, security-sensitive paths, large diff size.

## PR description template

````
## Summary
<2–4 bullets: what changed and why, in plain English>

## Changes
<grouped list — only categories that actually apply: feat / fix / refactor / test / docs / chore>

## Why
<motivation: link to issue / ticket if one exists, or one paragraph of rationale>

## Risk & rollout
<breaking changes, migrations, feature flags, rollback plan if non-trivial>

## Test plan
- [ ] <how this was verified locally>
- [ ] <CI checks that must pass>
- [ ] <manual verification steps for reviewer, if needed>
````

## Output

- **Suggested PR title** (≤ 70 chars, Conventional Commits prefix)
- **Filled-in description** ready to paste
- **Review hotspots**: `file:line` pointers to the changes most worth a reviewer's eyes
- **Size warning**: if diff > 500 lines or > 15 files, propose split boundaries
- **Open questions**: anything that needs the author to clarify before merging

## Constraints

- Don't run `gh pr create` unless the user explicitly asks.
- Don't invent test coverage that doesn't exist — if there are no tests, say so in the description.
- Keep the description PR-shaped: focus on what reviewers need, not a comprehensive changelog.
- Use Conventional Commits prefixes consistent with the project's existing commit history.
