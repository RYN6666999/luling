# Guard 失敗訊號速查表

當 guard 失敗時，讀 stderr 找到對應列，修根因，重跑。**不猜，不略過。**

---

## guard:specs

| stderr 訊息 | 根因 | 修法 |
|-------------|------|------|
| `missing frontmatter key: "domain"` | YAML 頂部少 domain | 加 `domain: <your-domain>` |
| `missing frontmatter key: "action"` | YAML 頂部少 action | 加 `action: <your-action>` |
| `missing frontmatter key: "version"` | YAML 頂部少 version | 加 `version: 1` |
| `missing section: ## input` | 沒有 input section | 加 `## input` + JSON 區塊 |
| `missing section: ## success` | 沒有 success section | 加 `## success` + JSON 區塊 |
| `missing section: ## error` | 沒有 error section | 加 `## error` + JSON 區塊 |
| `missing section: ## examples` | 沒有 examples section | 加 `## examples` + 至少一個 valid/invalid |
| `invalid JSON in ## input: ...` | input section 的 JSON 格式錯誤 | 修 JSON（檢查引號、逗號、括號） |
| `example name must start with valid- or invalid-` | example 命名不符規則 | 改成 `valid-xxx` 或 `invalid-xxx` |

---

## guard:contracts

| stderr 訊息 | 根因 | 修法 |
|-------------|------|------|
| `valid example failed parse` | `valid-` 的資料不符合產生的 schema | 修 spec 的 `## examples` valid 區塊；重跑 gen:contracts |
| `invalid example passed (expected failure)` | `invalid-` 的資料實際上合法 | 讓 invalid 資料真正違反 schema（少欄位、錯型別等） |
| `contract file not found` | gen:contracts 沒跑或失敗 | 先跑 `npm run gen:contracts` |
| `schema mismatch: field X` | spec 的 input 結構和 contract 不一致 | 修 spec input section，重跑 gen:contracts |

---

## guard:types

TypeScript 編譯器直接輸出。常見原因：

| 情境 | 修法 |
|------|------|
| `Type 'any' is not assignable` | 移除 any，加正確型別 |
| `Property X does not exist on type Y` | 從 `@vibe/contracts` import 正確型別 |
| `Argument of type X is not assignable to parameter of type Y` | 不要用 `as` 強轉；讓型別正確 |
| `Object is possibly undefined` | 加 null check 或用 optional chaining |

---

## guard:lint

ESLint 直接輸出。常見規則：

| 規則 | 觸發條件 | 修法 |
|------|----------|------|
| `@typescript-eslint/no-explicit-any` | 使用了 `any` | 換正確型別 |
| `react-hooks/rules-of-hooks` | Hook 在條件句裡 | 把 Hook 移到頂層 |
| `no-console` | 有 `console.log` | 移除或換成 logger |
| `import/no-unused-modules` | Import 了但沒用 | 移除未使用的 import |

---

## guard:ppr

| stderr 訊息 | 根因 | 修法 |
|-------------|------|------|
| `cacheComponents not found in next.config.ts` | PPR 設定被移除或拼錯 | 確認 `next.config.ts` 有 `experimental: { ppr: true, cacheComponents: true }` |

---

## guard:all 的執行順序

```
1. guard:specs      ← 格式層
2. guard:types      ← 型別層
3. guard:lint       ← 風格層
4. guard:contracts  ← 合約層
5. guard:ppr        ← 設定層
```

第一個失敗的 guard 會停止整個 pipeline。修完後必須從 `guard:all` 重跑，不是只跑失敗的那一個。
