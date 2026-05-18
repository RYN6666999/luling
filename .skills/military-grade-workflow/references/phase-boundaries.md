# Phase 邊界定義

當前 phase 定義在 `skill.md` 的 `phases.current` 欄位。  
**超出當前 phase 的實作需要明確核准，不可自行推進。**

---

## Phase 列表

| Phase | 主題 | 狀態 | 說明 |
|-------|------|------|------|
| 0 | Monorepo Skeleton | ✅ Done | 基礎 monorepo 結構、Turborepo、workspace |
| 1 | AI / Cursor Rules | ✅ Done | `.skills/` + `.cursor/rules/` 行為規則 |
| 2 | UI Core | ✅ Done | `FaultIsolatedSection`、`DynamicSection`、`DefaultSkeleton` |
| 3 | Contracts Baseline | ✅ Done | spec → gen → contract 管線建立 |
| 4 | CI Guards | ✅ Done | GitHub Actions：`guard.yml`（PR 阻斷）、`deploy.yml`（手動部署） |
| 5 | OpenSpec Integration | ✅ Done | `openspec/` 目錄、`project.md`、change 目錄結構 |
| 6 | Page Generator CLI | 🔒 需核准 | `gen:page` CLI、Handlebars 模板、三種 page 模式 |
| 7 | AI Audit Log | 🔒 需核准 | `audit:*` 指令、`audit.jsonl`、`verify:audit` |
| 8 | Production Pipeline | 🔒 需核准 | `deploy:check`、`verify:env`、完整部署流程 |

---

## 邊界規則

**Phase N 完成不代表 Phase N+1 自動開放。**  
每個鎖定的 phase 需要明確的使用者指令才能開始。

當代理人被要求實作鎖定 phase 的內容時，回應格式：

```
⚠️ Phase [N] 內容（[主題]）目前鎖定，需要核准才能開始。
目前 Phase：[current]
請求的 Phase：[N]
如需開放，請明確確認。
```

不猜測使用者意圖。不偷跑鎖定 phase。

---

## 當前 Phase 在哪裡確認

1. `skill.md` → `phases.current` 欄位
2. `openspec/project.md` → 最新的 phase 記錄

兩個衝突時，`openspec/project.md` 為準（它是人工維護的設計文件）。
