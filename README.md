# Military-Grade Vibe Coding Template ｜ 軍工級 Vibe Coding 通用模板框架

A monorepo template that brings high-reliability engineering guardrails into AI-assisted frontend development — without the overhead.

一個將高可靠工程思維以低成本方式嵌入 AI 輔助前端開發流程的 Monorepo 模板框架。

---

## Tech Stack ｜ 技術棧

Next.js 16 · React 19.2 · TypeScript strict · Tailwind CSS · Turborepo · npm workspaces

Default deployment target: **Vercel**

---

## Core Philosophy ｜ 核心哲學

1. **No spec, no code** — 不寫 spec 不寫碼
2. **Runtime contracts for all external I/O** — 所有外部 I/O 必須有 runtime contract
3. **AI output must be traceable** — AI 產出可追溯
4. **Fault isolation per section** — 區塊故障不拖垮整頁
5. **Guard pipeline: local + CI, fail = block** — Guard 管線可本地跑、可 CI 跑、失敗即阻斷
6. **Reducers over useState sprawl** — 超過 3 個相關 useState 時考慮 reducer / state machine
7. **Minimal, auditable, extensible** — 最小、可審核、可擴充，不做過度工程

---

## Project Phases ｜ 專案階段

| Phase | Topic | Status |
|-------|-------|--------|
| 0 | Monorepo Skeleton | ✅ Done |
| 1 | AI / Cursor Rules | ✅ Done |
| 2 | UI Core | ✅ Done |
| 3 | Contracts Baseline | ✅ Done |
| 4 | CI Guards | ✅ Done |
| 5 | OpenSpec Integration | ✅ Done |
| 6 | Page Generator CLI | ✅ Done |
| 7 | AI Audit Log Baseline | ✅ Done |
| 8 | Production Pipeline | ✅ Done |

> Phases above track **template infrastructure readiness**. The active development phase for projects built from this template is defined in `openspec/project.md`.

---

## Quick Start ｜ 快速開始

```bash
npm install
npm run dev
```

---

## Common Commands ｜ 常用指令

**Development ｜ 開發**

```bash
npm run dev              # Start dev server
npm run build            # Production build
```

**Guards ｜ 品質檢查**

```bash
npm run guard:all        # Run all guards (specs + types + lint + contracts + ppr)
npm run guard:specs      # Spec format validation
npm run guard:types      # TypeScript strict check
npm run guard:lint       # ESLint check
npm run guard:contracts  # Contract schema verification
npm run guard:ppr        # Verify cacheComponents: true
```

**Generators ｜ 產生器**

```bash
npm run gen:contracts                        # Generate contracts from specs
npm run gen:page -- <group> <name> <mode>    # Generate page (static|dynamic|ppr)
```

`<group>` uses `_root` for no route group. Otherwise the CLI converts it to `(group)`.

**Audit ｜ 稽核**

```bash
npm run audit:gen:contracts                       # gen:contracts with audit log
npm run audit:gen:page -- <group> <name> <mode>   # gen:page with audit log
npm run audit:guard:all                           # guard:all with audit log
npm run audit:verify                              # Verify audit log integrity
```

**Deploy ｜ 部署**

```bash
npm run verify:env       # Check required env vars against .env.example
npm run deploy:check     # Full deploy readiness check (guards + build + env)
```

---

## Environment Variables ｜ 環境變數

Copy `.env.example` to `.env` and fill in values.

```bash
cp .env.example .env
```

Keys marked `# required` in `.env.example` will cause `deploy:check` to fail if missing. Keys marked `# optional` are informational only.

---

## Deploy Workflow ｜ 部署流程

The repo includes a GitHub Actions workflow at `.github/workflows/deploy.yml`:

- Trigger: **manual dispatch only** (`workflow_dispatch`)
- Steps: install → deploy-check (guards + build + env) → provider deploy
- The provider deploy step is a placeholder — configure it for your target (Vercel, Cloudflare Pages, AWS, etc.)

---

## Design Documentation ｜ 設計文件

Detailed design lives in OpenSpec:

```
openspec/project.md
```

This README is the quick-start entry point. For architecture decisions, phase details, and contract design, refer to `openspec/project.md`.

---

## Agent Skill ｜ Claude 可安裝技能

This repo ships a Claude-installable skill that enforces the military-grade workflow for any AI coding agent.

### Install

Copy the skill to your Claude skills directory:

```bash
cp -r .skills/military-grade-workflow ~/.claude/skills/military-grade-workflow
```

Then invoke it in any Claude Code session:

```
/military-grade-workflow
```

### What the skill does

Enforces the full **spec → contract → implement → guard** pipeline and blocks any shortcut:

| File | Purpose |
|------|---------|
| `skill.md` | Entry point — workflow steps + on-demand loading table |
| `references/spec-format.md` | Spec file format rules, loaded when writing a new spec |
| `references/guard-signals.md` | Guard failure diagnosis table, loaded when a guard fails |
| `references/phase-boundaries.md` | Phase lock definitions, loaded on startup |
| `assets/spec.template.md` | Blank spec template to copy from |
| `scripts/new-spec.sh` | CLI scaffold: creates a spec from template |
| `scripts/guard-check.sh` | Runs all guards with concise error output |

---

## Monorepo Structure ｜ Repo 結構

```
apps/
  web/                → Next.js 16 App Router application
packages/
  ui/                 → Shared UI components (FaultIsolatedSection, DynamicSection, etc.)
  contracts/          → Runtime contracts (domain-folder structure)
  machines/           → State machines
scripts/              → Guard, generator, audit, and deploy scripts
templates/            → Handlebars page templates (static, dynamic, ppr)
openspec/             → OpenSpec design documentation
.skills/
  military-grade-workflow/  → Claude-installable skill (spec→contract→guard pipeline)
.cursor/rules/        → Cursor adapter (single bridge file pointing to .skills/)
.ai-audit/            → AI audit log (runtime artifact, not committed)
.github/workflows/    → CI guard + deploy workflows
```

---

## Python Version ｜ Python 版

The same military-grade pipeline is available for Python LLM agent projects.
No TypeScript, no npm — pure Python guards using the same SPEC → guard → contract → IMPL flow.

**Skill file:** [`python-military-grade.md`](https://github.com/RYN6666999/military-grade-dev-skills/blob/main/python-military-grade.md)

### Python Pipeline

```
SPEC → guard:specs → gen:contracts → guard:contracts → IMPL → guard:all → DONE
```

```bash
python3 openspec/scripts/guard_specs.py     # validate spec format
python3 openspec/scripts/gen_contracts.py   # generate TypedDict + validators
python3 openspec/scripts/guard_contracts.py # run all examples through validators
```

### Python Coding Rules

```python
# ✓ from __future__ import annotations  (Python 3.9 compatible)
# ✓ All external I/O through validate_*_input()
# ✓ All output through build_*_success() / build_*_error()
# ✓ import path: from tools.xxx import  (not from xxx import)
# ✓ Catch specific exceptions (ValueError, KeyError), no bare except:
# ✓ Functions < 50 lines, files < 400 lines
# ✗ No type: ignore without explanation comment
# ✗ No bare except: (hides real errors)
# ✗ No cross-scope mutation
```

### Common Python Guard Errors

| Error | Root Cause | Fix |
|-------|-----------|-----|
| `ModuleNotFoundError: No module named 'xxx'` | Missing `tools.` prefix | Change to `from tools.xxx import` |
| `union type syntax` / `str \| None` at module top level | Python 3.9 unsupported | Add `from __future__ import annotations` |
| `no validator for domain=X action=Y` | Missing entry in gen_contracts.py | Add TypedDict + validator + add to `_VALIDATORS` |
| Parallel tool call PRIMARY KEY conflict | INSERT not atomic | Use `INSERT ... SELECT COALESCE(MAX(...)+1, 0)` |

### Real-World Usage

The Python version is actively used in the [gbrain harness](https://github.com/RYN6666999/gbrain) — a 18-tool Python LLM agent with 3 spec domains (skills, inbox) and full guard pipeline. Every new tool goes through: spec file → `guard_specs.py` → `gen_contracts.py` → `guard_contracts.py` → implementation → `guard:all`.
