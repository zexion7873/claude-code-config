# Commands Cheatsheet

這是個人速查表，不是要用的 slash command（雖然會被列在 `/` 自動補全裡，無視它即可）。

## 8 個 Slash Commands

| 指令 | 用途 | 依賴 subagent |
|------|------|---------------|
| `/code-explain <檔案/主題>` | 解釋 code，含複雜度 + 視覺化 | 無 |
| `/refactor-clean <檔案>` | 抓 code smell、SOLID 違反、清死碼 | 無 |
| `/error-analysis <錯誤描述>` | 錯誤根因分析 + 改善建議 | 無 |
| `/debug-trace <情境>` | 設置 debugger / OpenTelemetry / tracing | 無 |
| `/pr-enhance` | 自動寫 PR 描述、檢查可讀性（在 git repo 跑） | 無 |
| `/git-workflow <目標分支>` | review→test→deploy check→commit→PR 一條龍 | code-reviewer, test-automator, deployment-engineer |
| `/full-review <路徑>` | 6 角度平行 review | code-reviewer, security-auditor, architect-review, performance-engineer, test-automator, tdd-orchestrator |
| `/smart-fix <問題>` | 自動判斷該叫哪個 agent 修 | debugger, devops-troubleshooter, database-optimizer, performance-engineer, legacy-modernizer |

## 11 個 Subagents（在 `~/.claude/agents/`）

通常被上面 3 個 command 自動呼叫，但也可以手動點名：「請用 XXX 幫我看…」

| Agent | 點名時機 | 模型 |
|-------|---------|------|
| `code-reviewer` | 整體 code review | opus |
| `architect-review` | 架構決策評估 | opus |
| `security-auditor` | OWASP / 安全漏洞 | opus |
| `tdd-orchestrator` | 強制走 TDD 流程 | opus |
| `performance-engineer` | App 效能瓶頸 | sonnet |
| `database-optimizer` | SQL / index / schema | inherit |
| `debugger` | 詭異 bug 根因分析 | sonnet |
| `devops-troubleshooter` | 部署 / 基礎設施問題 | sonnet |
| `legacy-modernizer` | 老 code 現代化 | sonnet |
| `test-automator` | 補測試 / 測試策略 | sonnet |
| `deployment-engineer` | 部署準備檢查 | haiku |

## 快速試用

```
1. /code-explain @某個檔案    → 最簡單，不依賴 agent
2. /refactor-clean @某個檔案  → 看 prompt 品質
3. /git-workflow main         → 測試多 agent 編排是否正常
```

## 升級

來源：
- Commands: https://github.com/wshobson/commands
- Agents: https://github.com/wshobson/agents

升級流程記錄在 memory `reference_wshobson_install.md`，包含手動修正項目。
