---
description: 軍工級 Vibe Coding — 強制 spec→contract→guard 開發流程
when_to_use: When user wants to add a feature, create a page, implement something, or run the military-grade dev workflow
user_invocable: true
argument_hint: "[功能描述 / feature description]"
allowed_tools:
  - Bash
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - TodoWrite
priority: 8
---

# Military-Grade Workflow — 軍工級開發流程

你是一個工作在高可靠工程環境裡的程式代理人。  
你不即興設計架構。你不繞過 guard。你不碰當前 phase 範圍外的檔案。  
**Guard 失敗 → 讀錯誤 → 修根因 → 重跑。永遠不跳過。**

---

## 按需加載的附屬資源

以下資源在需要時用 Read 工具讀入，不要一開始就全部加載：

| 情境 | 讀取路徑 |
|------|----------|
| 需要確認 spec 格式規範 | `references/spec-format.md` |
| guard 失敗，需要診斷 | `references/guard-signals.md` |
| 確認當前 phase 邊界 | `references/phase-boundaries.md` |
| 需要新建 spec 的起點模板 | `assets/spec.template.md` |

路徑相對於本 skill 目錄（`~/.claude/skills/military-grade-workflow/`）。

---

## 啟動前確認（每次必做）

1. 讀專案的 `openspec/project.md` — 了解架構限制
2. **按需加載** `references/phase-boundaries.md` — 確認當前 phase
3. 請求觸碰未來 phase 的內容 → **停止並告知使用者**，不實作

---

## 完整工作流程

```
SPEC → guard:specs → gen:contracts → guard:contracts → IMPL → guard:all → DONE
```

每一步都是阻斷點。上一步沒過，下一步不走。

---

### Step 1 — 寫 Spec

在以下路徑建立 spec 文件：

```
openspec/changes/<feature-name>/specs/<domain>/<action>.spec.md
```

**不確定格式時**：先讀 `references/spec-format.md` 再動筆。  
**快速建立**：

```bash
bash scripts/new-spec.sh <feature-name> <domain> <action>
```

Spec 必填 frontmatter：`domain`、`action`、`version`  
Spec 必填 sections：`## input`、`## success`、`## error`、`## examples`  
每個 section 必須有 ` ```json ` 區塊。

---

### Step 2 — 驗 Spec 格式

```bash
npm run guard:specs
```

`N passed, 0 failed` → 繼續。  
任何 `✗` → **讀 `references/guard-signals.md` 的 `guard:specs` 區段** → 修 spec → 重跑。  
不得繼續到 gen:contracts。

---

### Step 3 — 產生 Contract

```bash
npm run gen:contracts
```

成功：`✓ generated packages/contracts/<domain>/<action>.contract.ts`  
**永遠不要手動編輯 `*.contract.ts`。Source of truth 是 spec。**

---

### Step 4 — 驗 Contract

```bash
npm run guard:contracts
```

失敗 → **讀 `references/guard-signals.md` 的 `guard:contracts` 區段** → 對照診斷 → 修 spec examples → 重跑 step 3–4。

---

### Step 5 — 產生頁面（需要時）

```bash
npm run gen:page -- <name> <type>
```

`type`：`static` | `dynamic` | `ppr`  
目標已存在 → **不覆蓋，詢問使用者。**

---

### Step 6 — 實作

```
✓ 從 @vibe/contracts import 型別
✓ 所有外部 I/O 用 schema.safeParse(raw)
✓ 非同步區塊用 <DynamicSection> 包
✓ 風險區塊用 <FaultIsolatedSection> 包
✗ 不用 any
✗ 不用 as 強轉型
✗ 不加不需要的 'use client'
✗ 3+ useState → 改用 useReducer
```

---

### Step 7 — 全 Guard 通過

```bash
npm run guard:all
# 或用快速腳本（含精簡錯誤輸出）
bash scripts/guard-check.sh
```

任何失敗 → **讀 `references/guard-signals.md`** 對照錯誤 → 修根因 → 重跑。  
不得用 `|| true` 繞過。

---

### Step 8 — 完成摘要

```
✓ Spec:     openspec/changes/<name>/specs/<domain>/<action>.spec.md
✓ Contract: packages/contracts/<domain>/<action>.contract.ts
✓ Page:     apps/web/app/(dashboard)/<name>/page.tsx  (若有產生)
✓ Guards:   all passed
```

---

## 絕對禁止清單

| 禁止 | 原因 |
|------|------|
| 沒 spec 就寫 code | 破壞可追溯性 |
| 手編 `*.contract.ts` | 會被下次 gen 覆蓋 |
| 用 `as` 轉型外部 I/O | 繞過 runtime 驗證 |
| 使用 `any` | 破壞 TypeScript strict |
| 用 `\|\| true` 靜音 guard | 隱藏真實失敗 |
| 未核准就實作鎖定 phase | 超出 scope |

---

## 使用者請求

$ARGUMENTS
