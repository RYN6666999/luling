# Spec 文件格式規範

每個 spec 文件必須嚴格符合以下結構，否則 `guard:specs` 會擋下來。

---

## 檔案路徑

```
openspec/changes/<feature-name>/specs/<domain>/<action>.spec.md
```

- `feature-name`：kebab-case，描述這次改動，例如 `user-avatar`、`payment-flow`
- `domain`：業務領域，例如 `auth`、`user`、`billing`、`notification`
- `action`：動作動詞，例如 `login`、`create`、`update`、`delete`

---

## 完整結構範例

```markdown
---
domain: auth
action: login
version: 1
---

## input

```json
{
  "email": "string (required, valid email)",
  "password": "string (required, min 8 chars)"
}
` `` `

## success

` `` `json
{
  "token": "string (JWT)",
  "expiresAt": "string (ISO 8601)"
}
` `` `

## error

` `` `json
{
  "code": "INVALID_CREDENTIALS | ACCOUNT_LOCKED | RATE_LIMITED",
  "message": "string"
}
` `` `

## examples

### valid-standard-login
` `` `json
{
  "email": "user@example.com",
  "password": "securepassword123"
}
` `` `

### invalid-missing-email
` `` `json
{
  "password": "securepassword123"
}
` `` `

### invalid-bad-email-format
` `` `json
{
  "email": "not-an-email",
  "password": "securepassword123"
}
` `` `
```

---

## Frontmatter 規則

| 欄位 | 型別 | 必填 | 說明 |
|------|------|------|------|
| `domain` | string | ✓ | 業務領域，kebab-case |
| `action` | string | ✓ | 動作名稱，kebab-case |
| `version` | number | ✓ | 從 1 開始，每次 breaking change +1 |

---

## Section 規則

每個 section 標題必須是 `## input`、`## success`、`## error`、`## examples`（完全一致，含大小寫）。

每個 section 必須包含至少一個 ` ```json ` 區塊。空的 section 不合法。

---

## Examples Section 規則

- `valid-` 前綴：應該成功 parse 的資料
- `invalid-` 前綴：應該失敗 parse 的資料（用於負向測試）
- 每種 case 至少一個 valid，一個 invalid
- 命名用 kebab-case 描述場景，例如 `valid-standard-login`、`invalid-missing-email`

---

## 常見錯誤

| 錯誤訊息 | 原因 |
|----------|------|
| `missing frontmatter key: domain` | YAML 頂部少了 domain |
| `missing section: ## examples` | 沒有 examples section |
| `invalid JSON in ## input` | JSON 格式錯誤（注意引號、逗號） |
| `example name must start with valid- or invalid-` | example 命名不符規則 |
