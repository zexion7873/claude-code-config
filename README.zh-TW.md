# Claude Code 個人設定

[English](README.md) | **繁體中文**

[![License: MIT](https://img.shields.io/github/license/zexion7873/claude-code-config?style=flat)](LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/zexion7873/claude-code-config?style=flat)](https://github.com/zexion7873/claude-code-config/stargazers)
[![Last commit](https://img.shields.io/github/last-commit/zexion7873/claude-code-config?style=flat)](https://github.com/zexion7873/claude-code-config/commits)
[![GitHub issues](https://img.shields.io/github/issues/zexion7873/claude-code-config?style=flat)](https://github.com/zexion7873/claude-code-config/issues)
[![Repo size](https://img.shields.io/github/repo-size/zexion7873/claude-code-config?style=flat)](https://github.com/zexion7873/claude-code-config)

個人 [Claude Code](https://docs.anthropic.com/en/docs/claude-code) 設定檔 — 自訂代理人、斜線指令、Hooks、語言規則，以及 Powerlevel10k 風格的狀態列。一鍵 symlink，全域套用。

## 快速開始

```bash
git clone https://github.com/zexion7873/claude-code-config.git
cd claude-code-config
bash install.sh
```

`install.sh` 會將所有項目 symlink 至 `~/.claude/`，若有既存檔案會自動備份。

## 目錄結構

```
~/.claude/
├── CLAUDE.md                    ← 全域基礎指示（回應風格、Git 慣例、禁止規則）
├── settings.json                ← 模型、權限、Hooks、Plugin、狀態列
├── statusline-p10k.sh           ← Powerlevel10k 風格狀態列腳本
├── install.sh                   ← 一鍵 symlink 安裝器
│
├── rules/                       ← 依 glob 規則自動套用
│   ├── python.md                  **/*.py
│   ├── typescript.md              **/*.{ts,tsx,js,jsx,mjs,cjs}
│   ├── sql.md                     **/*.sql
│   └── dotenv.md                  **/.env*, **/credentials*, **/*secret*
│
├── agents/                      ← 可委派任務的專業子代理人
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
├── commands/                    ← 斜線指令（透過 /command-name 呼叫）
│   ├── code-explain.md
│   ├── pr-enhance.md
│   ├── debug-trace.md
│   ├── error-analysis.md
│   ├── full-review.md
│   ├── git-workflow.md
│   ├── refactor-clean.md
│   ├── smart-fix.md
│   └── _README.md                個人速查表（非實際指令）
│
└── hooks/                       ← 生命週期 Hooks
    ├── guard-bash.sh              PreToolUse — 攔截危險的 Shell 指令
    ├── format-on-edit.sh          PostToolUse — 寫入/編輯後自動格式化
    └── stop-notify.sh             Stop — macOS 桌面通知 + 音效
```

---

## CLAUDE.md（全域指示）

每次 Claude Code 對話都會自動載入。主要行為：

- 以繁體中文回覆；程式碼、commit、檔名使用英文
- 簡潔風格：簡短說明 + 結果 + 下一步提示
- Conventional Commits（`feat:` / `fix:` / `refactor:` / 等）
- 明確指定檔案 staging（禁止 `git add -A`）
- 10 條硬性禁止規則（禁止 force-push main、禁止 `--no-verify`、禁止填充式註解等）

---

## settings.json

| 設定 | 值 |
|------|-----|
| 模型 | `claude-opus-4-6` |
| 思考力度 | `xhigh` |
| 遙測 | 停用 |
| Plugin | Context7 |
| 拒絕存取清單 | `~/.ssh`、`~/.aws`、`~/.kube`、`~/.gnupg`、憑證檔、鑰匙圈、Shell 設定檔 |

---

## Rules（規則）

依 glob 匹配自動套用至對應檔案。

| 規則 | Glob | 說明 |
|------|------|------|
| `python` | `**/*.py` | 型別提示、`pathlib`、`ruff`、dataclass/Pydantic、`from __future__ import annotations` |
| `typescript` | `**/*.{ts,tsx,js,jsx,mjs,cjs}` | 預設 `const`、`interface` 優先、`unknown` 取代 `any`、命名匯出、`satisfies` |
| `sql` | `**/*.sql` | 參數化查詢、明確欄位、`IF EXISTS` 防護、交易包裝 |
| `dotenv` | `**/.env*`、credentials、secrets | 禁止提交/輸出機密，使用環境變數或密鑰管理服務 |

---

## Agents（代理人）

透過 Agent 工具委派任務的專業子代理人。

| Agent | 說明 |
|-------|------|
| `architect-review` | 架構模式、Clean Architecture、微服務、DDD |
| `code-reviewer` | 程式碼分析、安全漏洞、效能、生產可靠性 |
| `database-optimizer` | 查詢優化、索引、快取、分區策略 |
| `debugger` | 錯誤診斷、測試失敗、非預期行為 |
| `deployment-engineer` | CI/CD 流水線、GitOps、漸進式交付、容器安全 |
| `devops-troubleshooter` | 事件回應、日誌分析、分散式追蹤、K8s 除錯 |
| `legacy-modernizer` | 框架遷移、技術債、依賴更新 |
| `performance-engineer` | 回應時間、記憶體使用、查詢效率、可擴展性 |
| `security-auditor` | DevSecOps、弱點評估、OWASP、合規（GDPR/HIPAA/SOC2） |
| `tdd-orchestrator` | 紅-綠-重構紀律、多代理人 TDD 協調 |
| `test-automator` | 單元、整合、E2E 測試，TDD/BDD 工作流 |

---

## Commands（斜線指令）

在 Claude Code 中以 `/command-name` 呼叫。

| 指令 | 說明 |
|------|------|
| `/code-explain` | 透過敘述、圖表、逐步拆解來解釋複雜程式碼 |
| `/pr-enhance` | 產生完整 PR 描述並優化審查流程 |
| `/debug-trace` | 建立除錯環境、分散式追蹤與診斷工具 |
| `/error-analysis` | 分析並解決錯誤，自動路由至合適代理人 |
| `/full-review` | 多代理人全面審查（程式碼、安全、架構、TDD） |
| `/git-workflow` | 端到端 Git 工作流：審查變更、提交、推送 |
| `/refactor-clean` | 依 Clean Code 原則與 SOLID 模式重構程式碼 |
| `/smart-fix` | 自動選擇最佳專家代理人修復問題 |

---

## Hooks

| Hook | 事件 | 說明 |
|------|------|------|
| `guard-bash.sh` | PreToolUse (Bash) | 攔截危險指令（`rm -rf /`、`chmod 777` 等） |
| `format-on-edit.sh` | PostToolUse (Write/Edit) | 以 prettier / ruff / gofmt 自動格式化（未安裝則跳過） |
| `stop-notify.sh` | Stop | macOS 通知（「任務完成」）+ Glass 音效 |

---

## Status Line（狀態列）

`statusline-p10k.sh` 渲染 Powerlevel10k 風格的狀態列，顯示：

- 當前目錄 + Git 分支
- 模型名稱
- Context Window 剩餘比例（依比例變色：綠/黃/紅）
- 思考力度 + Thinking 模式
- 輸出風格
- 5 小時速率限制用量 + 重置倒數

---

## License

[MIT](LICENSE)
