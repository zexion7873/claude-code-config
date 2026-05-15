# Response Language
Always respond in Traditional Chinese (zh-TW). Keep code, commit messages, PR titles, and filenames in English.

# Response Style
- Short explanation + result + next-step hint when needed. No long-form prose.
- Don't summarize "what I just did" at the end of every turn — the diff speaks for itself.
- Don't proactively create README / planning / report files unless I ask.
- No emojis in code or replies unless I ask.
- One sentence before acting, one sentence on blockers or direction changes, otherwise stay quiet.

# Context7 Usage
Call context7 for fresh docs (don't rely on memory) when:
- Third-party library / framework APIs (React, Next.js, Tailwind, FastAPI, Prisma, etc.)
- Version-specific behavior ("Next.js 15...", "React 19...")
- Library upgrades or deprecated API replacements
- I explicitly say "use context7"

Skip context7 for:
- Pure language syntax
- Algorithms / data structures
- Reading or editing my own project code
- Generic design patterns

# Git / Commits
- **Conventional Commits**: `feat:` / `fix:` / `refactor:` / `docs:` / `chore:` / `test:` / `perf:`.
- Commit messages in English, focus on WHY not WHAT.
- One logical change per commit. Don't bundle unrelated edits.
- Never `--amend` a pushed commit.
- Always `git status` + `git diff` before staging or pushing.
- Don't push or open PRs unless I explicitly ask.
- Stage by explicit filename, not `git add -A` / `git add .` (avoids leaking `.env`, binaries).

# Forbidden
Hard rules — even if my intent sounds ambiguous, do not:

1. **Force-push to main / master** (including `--force-with-lease`); confirm before force-pushing any branch.
2. **Bypass git hooks** (`--no-verify`, `--no-gpg-sign`) unless I explicitly say so.
3. **Modify test assertions to make tests pass** — diagnose the failure first.
4. **Write defensive code for impossible cases** — no try/catch, validation, or fallback for things that can't happen. Trust internal calls and framework guarantees. Validate only at system boundaries (user input, external APIs).
5. **Add backward-compat shims, deprecation wrappers, or feature flags** I didn't ask for. Just change the code.
6. **Write filler comments** — don't restate what well-named code already shows; don't write "used by X" / "added for Y" (that's PR-description content). Comment only when WHY is non-obvious.
7. **Invent URLs, APIs, or package names** — use context7 / WebSearch when unsure, or admit you don't know.
8. **Take destructive actions without authorization** — `rm -rf`, deleting branches, dropping tables, killing processes — ask first.
9. **Upload chat content, tokens, or credentials to third-party services** (diagram renderers, pastebins, gists).
10. **Refactor unrelated files while fixing a bug**. Bug fix = bug fix. Cleanup is a separate task.

---

# Repository Overview

This repo is my personal Claude Code configuration. `install.sh` symlinks each top-level item into `~/.claude/`, so editing a file here changes my live Claude Code behavior globally on next session start.

When working **on** this repo (versus consuming it elsewhere), treat every file as a live config artifact — there's no build step, no test suite, no compile errors to catch mistakes. A typo in `settings.json` or a malformed agent frontmatter ships straight to my next session.

## Layout

| Path | Symlinks to | Purpose |
|------|-------------|---------|
| `CLAUDE.md` | `~/.claude/CLAUDE.md` | This file. Global instructions loaded into every session. |
| `settings.json` | `~/.claude/settings.json` | Model, env vars, permission deny list, hooks, plugins, status line. |
| `statusline-p10k.sh` | `~/.claude/statusline-p10k.sh` | Powerlevel10k-style status bar renderer. |
| `install.sh` | — | Symlink installer; backs up existing `~/.claude/<item>` to `.bak.<timestamp>`. |
| `agents/*.md` | `~/.claude/agents/` | Sub-agent definitions (frontmatter + system prompt). |
| `commands/*.md` | `~/.claude/commands/` | Slash command bodies invoked via `/name`. `_README.md` is a personal cheatsheet, not a command. |
| `hooks/*.sh` | `~/.claude/hooks/` | Lifecycle scripts referenced by `settings.json`. |
| `rules/*.md` | `~/.claude/rules/` | Glob-scoped rules auto-applied when matching files are touched. |

## File Conventions

**Agents (`agents/*.md`)** — YAML frontmatter then markdown system prompt:

```
---
name: <kebab-case>           # must match filename
description: <one-liner>     # shown in agent picker
model: opus | sonnet | haiku | inherit
color: cyan | blue | ...     # status-line accent
---
<system prompt body>
```

**Commands (`commands/*.md`)** — plain markdown, no frontmatter. `$ARGUMENTS` interpolates the user's argument string. Reference sub-agents with `Use Task tool with subagent_type="<agent-name>"`.

**Hooks (`hooks/*.sh`)** — bash scripts. Read tool I/O from stdin as JSON (`jq -r '.tool_input.<field>'`). For `PreToolUse`, emit a JSON object with `hookSpecificOutput.permissionDecision="deny"` to block; silent `exit 0` to allow. Keep them fast (timeouts set in `settings.json`: 5s for PreToolUse/Stop, 30s for PostToolUse).

**Rules (`rules/*.md`)** — frontmatter `description` + `globs`, then bullet list of conventions. Globs are comma-separated, brace expansion supported.

## Development Workflow

1. **Edit in place.** No build; changes apply once symlinks resolve (next session, or restart current session).
2. **Test by using it.** There's no CI. After editing a hook, trigger the matching tool call. After editing an agent, invoke it. After editing a rule, touch a matching file.
3. **Validate before committing:**
   - `settings.json` — `jq . settings.json` to catch syntax errors.
   - Hook scripts — `bash -n hooks/<file>.sh` for syntax; manually pipe a sample JSON to test `jq` extraction.
   - Agent/rule frontmatter — eyeball it; malformed YAML silently breaks the file.
4. **`install.sh` is idempotent** — safe to re-run; it removes existing symlinks and backs up regular files.
5. **Don't add files to top-level without updating `install.sh`** — only items listed in the `items=()` array get symlinked.

## Adding Things

- **New agent** → drop a `<name>.md` in `agents/` with the frontmatter shown above. No registry to update.
- **New slash command** → drop a `<name>.md` in `commands/`. Mention any required sub-agents in the body; update `commands/_README.md` table if I'm keeping the cheatsheet in sync.
- **New hook** → write the script in `hooks/`, `chmod +x`, then wire it into `settings.json` under the right `PreToolUse` / `PostToolUse` / `Stop` matcher. The script path uses `~/.claude/hooks/<name>.sh` (post-symlink).
- **New rule** → drop a `<lang>.md` in `rules/` with `description` + `globs` frontmatter.
- **New top-level artifact** → add it to the `items=()` array in `install.sh`.

## Things That Bite

- **macOS-only hook**: `stop-notify.sh` uses `osascript` + `afplay`. On Linux/WSL it silently no-ops (already wrapped in `2>&1`), but don't expect notifications.
- **`guard-bash.sh` regex patterns** are intentionally narrow — they catch common foot-guns, not every variant. Don't over-engineer; the goal is to slow me down on obvious mistakes, not to be a real sandbox.
- **`format-on-edit.sh` swallows formatter failures** (`|| true`). If a file isn't being formatted, check the formatter is installed and on `PATH`; the hook won't tell you.
- **`settings.json` permission deny list** uses tilde expansion — `Read(~/.ssh/**)`. Glob is `**` not `*`.
- **Agent `model: inherit`** means "use the parent session's model"; some agents (e.g. `database-optimizer`) rely on this so they match whatever model I'm running.
- **The `effortLevel: "xhigh"`** in `settings.json` is non-default; don't normalize it away.
