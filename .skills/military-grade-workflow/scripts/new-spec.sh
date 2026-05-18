#!/bin/bash
# new-spec.sh — 從 template 快速建立新 spec 文件
# 用法：bash .skills/military-grade-workflow/scripts/new-spec.sh <feature-name> <domain> <action>
#
# 例：bash .skills/military-grade-workflow/scripts/new-spec.sh user-avatar user upload-avatar

set -euo pipefail

FEATURE="${1:-}"
DOMAIN="${2:-}"
ACTION="${3:-}"

if [[ -z "$FEATURE" || -z "$DOMAIN" || -z "$ACTION" ]]; then
  echo "用法：$0 <feature-name> <domain> <action>"
  echo "例：  $0 user-avatar user upload-avatar"
  exit 1
fi

TEMPLATE=".skills/military-grade-workflow/assets/spec.template.md"
TARGET="openspec/changes/${FEATURE}/specs/${DOMAIN}/${ACTION}.spec.md"

if [[ ! -f "$TEMPLATE" ]]; then
  echo "Template not found: $TEMPLATE"
  exit 1
fi

if [[ -f "$TARGET" ]]; then
  echo "Spec already exists: $TARGET"
  echo "Edit it directly instead of overwriting."
  exit 1
fi

mkdir -p "$(dirname "$TARGET")"
sed \
  -e "s/REPLACE_ME/${DOMAIN}/1" \
  -e "s/REPLACE_ME/${ACTION}/1" \
  "$TEMPLATE" > "$TARGET"

echo "Created: $TARGET"
echo ""
echo "Next steps:"
echo "  1. Edit $TARGET — fill in actual fields, constraints, examples"
echo "  2. npm run guard:specs"
echo "  3. npm run gen:contracts"
echo "  4. npm run guard:contracts"
