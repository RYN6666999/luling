---
domain: REPLACE_ME
action: REPLACE_ME
version: 1
---

## input

```json
{
  "field1": "string (required, describe constraint)",
  "field2": "number (optional, default: 0)"
}
```

## success

```json
{
  "id": "string (UUID)",
  "createdAt": "string (ISO 8601)"
}
```

## error

```json
{
  "code": "ERROR_CODE_A | ERROR_CODE_B",
  "message": "string"
}
```

## examples

### valid-standard
```json
{
  "field1": "example value",
  "field2": 42
}
```

### valid-optional-omitted
```json
{
  "field1": "example value"
}
```

### invalid-missing-required
```json
{
  "field2": 42
}
```

### invalid-wrong-type
```json
{
  "field1": 12345,
  "field2": "not-a-number"
}
```
