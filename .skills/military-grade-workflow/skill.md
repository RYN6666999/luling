---
name: military-grade-workflow
version: "1.0.0"
description: >
  軍工級 Vibe Coding 開發流程。強制執行「先寫 spec → 產生 contract → 實作 → guard 全過」的
  不可跳過管線。適用任何 Next.js / TypeScript monorepo 專案。
  當使用者說「新增功能」、「建頁面」、「加 API」、「加路由」、「實作」、「建合約」時啟動。
trigger:
  - "新增功能"
  - "建頁面"
  - "加 API"
  - "加路由"
  - "實作"
  - "add feature"
  - "create page"
  - "build something"
  - "add contract"
  - "implement"
allowed-tools: >
  Bash(npm run *) Read Write Edit Glob Grep TodoWrite
phases:
  current: 5
  locked: [6, 7, 8]
guard-policy: fail-fast
spec-root: openspec/changes
contract-root: packages/contracts
page-root: "apps/web/app/(dashboard)"
---

# Military-Grade Workflow — 軍工級開發流程

你是一個工作在高可靠工程環境裡的程式代理人。  
你不即興設計架構。你不繞過 guard。你不碰當前 phase 範圍外的檔案。  
**Guard 失敗 → 讀錯誤 → 修根因 → 重跑。永遠不跳過。**

---

## 啟動前確認（每次必做）

1. 讀 `openspec/project.md` — 了解架構限制
2. 確認當前 phase（見 [references/phase-boundaries.md](references/phase-boundaries.md)）
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

Spec 格式見 [references/spec-format.md](references/spec-format.md)。  
不確定格式時，用 [assets/spec.template.md](assets/spec.template.md) 作為起點。

**必填 frontmatter：** `domain`、`action`、`version`  
**必填 section：** `## input`、`## success`、`## error`、`## examples`  
每個 section 必須有 ` ```json ` 區塊。

---

### Step 2 — 驗 Spec 格式

```bash
npm run guard:specs
```

| 結果 | 代表 |
|------|------|
| `N passed, 0 failed` | 繼續 |
| 任何 `✗` | 讀錯誤、修 spec、重跑。**不得繼續到 gen:contracts** |

---

### Step 3 — 產生 Contract

```bash
npm run gen:contracts
```

成功訊號：`✓ generated packages/contracts/<domain>/<action>.contract.ts`  
**永遠不要手動編輯 `*.contract.ts` 檔案。** Source of truth 是 spec。

---

### Step 4 — 驗 Contract

```bash
npm run guard:contracts
```

| 失敗訊息 | 代表什麼 | 怎麼修 |
|----------|----------|--------|
| `valid example failed parse` | `## examples` 的 valid 欄位資料不符 schema | 修 spec examples，重跑 step 3–4 |
| `invalid example passed` | invalid 欄位實際上合法 | 修成真正違反 schema 的資料 |

詳細診斷見 [references/guard-signals.md](references/guard-signals.md)。

---

### Step 5 — 產生頁面（需要時）

```bash
npm run gen:page -- <name> <type>
```

- `name`：kebab-case 路由名，例如 `analytics`
- `type`：`static` | `dynamic` | `ppr`

成功：`apps/web/app/(dashboard)/<name>/page.tsx` 出現  
目標已存在 → **不覆蓋，詢問使用者**

---

### Step 6 — 實作

規則：

```
✓ 從 @vibe/contracts import 型別，不自己手寫 Zod schema
✓ 所有外部 I/O 用 schema.safeParse(raw)，不用 as 強型別轉換
✓ 非同步區塊用 <DynamicSection> 包
✓ 風險區塊用 <FaultIsolatedSection> 包
✓ 沒有真正客戶端需求不加 'use client'
✓ 3+ 個相關 useState → 改用 useReducer + 型別化 actions
✗ 不用 any
✗ 不跨 phase 邊界
```

元件 API 速查：

```tsx
// 風險隔離（一塊壞不拖垮整頁）
<FaultIsolatedSection
  enabled={true}
  errorFallback={<ErrorUI />}
>
  <DynamicSection fallback={<Skeleton />}>
    <YourAsyncComponent />
  </DynamicSection>
</FaultIsolatedSection>
```

---

### Step 7 — 全 Guard 通過

```bash
npm run guard:all
```

依序執行：specs → types → lint → contracts → ppr

全過 → 完成。  
任何失敗 → 讀 stderr → 修根因 → 重跑。不得 `|| true` 繞過。

---

### Step 8 — 完成摘要

Guard 全過後，輸出：

```
✓ Spec:     openspec/changes/<name>/specs/<domain>/<action>.spec.md
✓ Contract: packages/contracts/<domain>/<action>.contract.ts
✓ Page:     apps/web/app/(dashboard)/<name>/page.tsx  (若有產生)
✓ Guards:   all passed
```

---

## 絕對禁止清單

| 禁止行為 | 強制原因 |
|----------|----------|
| 沒 spec 就寫 code | 破壞可追溯性 |
| 手編 `*.contract.ts` | 會被下次 gen 覆蓋 |
| 用 `as` 轉型外部 I/O | 繞過 runtime 驗證 |
| 使用 `any` | 破壞 TypeScript strict |
| 未核准就實作 Phase 6+ | 超出 scope |
| 用 `|| true` 靜音 guard | 隱藏真實失敗 |
| 3+ useState 不換 reducer | 狀態機管理破碎 |

---

## 狀態機（簡化）

```
IDLE
  → 寫 spec → SPEC_WRITTEN
SPEC_WRITTEN
  → guard:specs ✓ → SPEC_VALID
  → guard:specs ✗ → SPEC_WRITTEN（修再跑）
SPEC_VALID
  → gen:contracts → CONTRACT_GENERATED
CONTRACT_GENERATED
  → guard:contracts ✓ → CONTRACT_VALID
  → guard:contracts ✗ → SPEC_VALID（修 examples，重 gen）
CONTRACT_VALID
  → 實作 → IMPL_DONE
IMPL_DONE
  → guard:all ✓ → DONE
  → guard:all ✗ → IMPL_DONE（修再跑）
```
