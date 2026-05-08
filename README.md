# Claude Code Personal Configuration

**English** | [繁體中文](README.zh-TW.md)

[![License: MIT](https://img.shields.io/github/license/zexion7873/claude-code-config?style=flat)](LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/zexion7873/claude-code-config?style=flat)](https://github.com/zexion7873/claude-code-config/stargazers)
[![Last commit](https://img.shields.io/github/last-commit/zexion7873/claude-code-config?style=flat)](https://github.com/zexion7873/claude-code-config/commits)
[![GitHub issues](https://img.shields.io/github/issues/zexion7873/claude-code-config?style=flat)](https://github.com/zexion7873/claude-code-config/issues)
[![Repo size](https://img.shields.io/github/repo-size/zexion7873/claude-code-config?style=flat)](https://github.com/zexion7873/claude-code-config)

Personal [Claude Code](https://docs.anthropic.com/en/docs/claude-code) configuration — custom agents, slash commands, hooks, language-specific rules, and a Powerlevel10k-style status line. Symlink once, use everywhere.

## Quick Start

```bash
git clone https://github.com/zexion7873/claude-code-config.git
cd claude-code-config
bash install.sh
```

`install.sh` symlinks every item into `~/.claude/`, backing up existing files automatically.

## Directory Structure

```
~/.claude/
├── CLAUDE.md                    ← Global base instructions (response style, git conventions, forbidden rules)
├── settings.json                ← Model, permissions, hooks, plugins, status line
├── statusline-p10k.sh           ← Powerlevel10k-style status line script
├── install.sh                   ← One-click symlink installer
│
├── rules/                       ← Auto-applied rules based on glob patterns
│   ├── python.md                  **/*.py
│   ├── typescript.md              **/*.{ts,tsx,js,jsx,mjs,cjs}
│   ├── sql.md                     **/*.sql
│   └── dotenv.md                  **/.env*, **/credentials*, **/*secret*
│
├── agents/                      ← Specialized sub-agents for delegation
│   ├── architect-review.md
│   ├── code-reviewer.md
│   ├── database-optimizer.md
│   ├── debugger.md
│   ├── deployment-engineer.md
│   ├── devops-troubleshooter.md
│   ├── legacy-modernizer.md
│   ├── performance-engineer.md
│   ├── security-auditor.md
│   ├── tdd-orchestrator.md
│   └── test-automator.md
│
├── commands/                    ← Slash commands (invoke via /command-name)
│   ├── code-explain.md
│   ├── pr-enhance.md
│   ├── debug-trace.md
│   ├── error-analysis.md
│   ├── full-review.md
│   ├── git-workflow.md
│   ├── refactor-clean.md
│   ├── smart-fix.md
│   └── _README.md                Personal cheatsheet (not a real command)
│
└── hooks/                       ← Lifecycle hooks
    ├── guard-bash.sh              PreToolUse — block dangerous shell commands
    ├── format-on-edit.sh          PostToolUse — auto-format on Write/Edit/MultiEdit
    └── stop-notify.sh             Stop — macOS desktop notification + sound
```

---

## CLAUDE.md (Global Instructions)

Loaded into every Claude Code conversation. Key behaviors:

- Respond in Traditional Chinese; code/commits/filenames in English
- Concise style: short explanation + result + next-step hint
- Conventional Commits (`feat:` / `fix:` / `refactor:` / etc.)
- Stage files explicitly (never `git add -A`)
- 10 hard forbidden rules (no force-push to main, no `--no-verify`, no filler comments, etc.)

---

## settings.json

| Setting | Value |
|---------|-------|
| Model | `claude-opus-4-6` |
| Effort | `xhigh` |
| Telemetry | Disabled |
| Plugin | Context7 |
| Deny list | `~/.ssh`, `~/.aws`, `~/.kube`, `~/.gnupg`, credentials, keychains, shell profiles |

---

## Rules

Auto-applied when file globs match.

| Rule | Glob | Description |
|------|------|-------------|
| `python` | `**/*.py` | Type hints, `pathlib`, `ruff`, dataclasses/Pydantic, `from __future__ import annotations` |
| `typescript` | `**/*.{ts,tsx,js,jsx,mjs,cjs}` | `const` default, `interface` over `type`, `unknown` over `any`, named exports, `satisfies` |
| `sql` | `**/*.sql` | Parameterized queries, explicit columns, `IF EXISTS` guards, transactions |
| `dotenv` | `**/.env*`, credentials, secrets | Never commit/log secrets, use env vars or secret managers |

---

## Agents

Specialized sub-agents invoked via the Agent tool for task delegation.

| Agent | Description |
|-------|-------------|
| `architect-review` | Architecture patterns, clean architecture, microservices, DDD |
| `code-reviewer` | Code analysis, security vulnerabilities, performance, production reliability |
| `database-optimizer` | Query optimization, indexing, caching, partitioning |
| `debugger` | Error diagnosis, test failures, unexpected behavior |
| `deployment-engineer` | CI/CD pipelines, GitOps, progressive delivery, container security |
| `devops-troubleshooter` | Incident response, log analysis, distributed tracing, K8s debugging |
| `legacy-modernizer` | Framework migration, technical debt, dependency updates |
| `performance-engineer` | Response times, memory usage, query efficiency, scalability |
| `security-auditor` | DevSecOps, vulnerability assessment, OWASP, compliance (GDPR/HIPAA/SOC2) |
| `tdd-orchestrator` | Red-green-refactor discipline, multi-agent TDD coordination |
| `test-automator` | Unit, integration, E2E tests, TDD/BDD workflows |

---

## Commands

Slash commands invoked via `/command-name` in Claude Code.

| Command | Description |
|---------|-------------|
| `/code-explain` | Explain complex code through narratives, diagrams, and step-by-step breakdowns |
| `/pr-enhance` | Generate comprehensive PR descriptions and optimize review workflows |
| `/debug-trace` | Set up debugging environments, distributed tracing, and diagnostic tools |
| `/error-analysis` | Analyze and resolve errors with automatic agent routing |
| `/full-review` | Multi-agent comprehensive review (code, security, architecture, TDD) |
| `/git-workflow` | End-to-end git workflow: review changes, commit, push |
| `/refactor-clean` | Refactor code following clean code principles and SOLID patterns |
| `/smart-fix` | Auto-select the best specialist agent(s) to fix an issue |

---

## Hooks

| Hook | Event | Description |
|------|-------|-------------|
| `guard-bash.sh` | PreToolUse (Bash) | Deny dangerous commands (`rm -rf /`, `chmod 777`, etc.) |
| `format-on-edit.sh` | PostToolUse (Write/Edit) | Auto-format with prettier / ruff / gofmt (skips if formatter not installed) |
| `stop-notify.sh` | Stop | macOS notification ("任務完成") + Glass sound |

---

## Status Line

`statusline-p10k.sh` renders a Powerlevel10k-inspired status bar showing:

- Current directory + git branch
- Model name
- Context window remaining (color-coded: green/yellow/red)
- Effort level + thinking mode
- Output style
- 5-hour rate limit usage + reset countdown

---

## License

[MIT](LICENSE)
