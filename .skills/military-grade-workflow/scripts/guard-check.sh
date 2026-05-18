#!/bin/bash
# guard-check.sh — 快速全 guard 檢查，失敗時輸出精簡錯誤
# 用法：bash .skills/military-grade-workflow/scripts/guard-check.sh

set -euo pipefail

PASS="\033[0;32m✓\033[0m"
FAIL="\033[0;31m✗\033[0m"

run_guard() {
  local name="$1"
  local cmd="$2"
  printf "  %-20s" "$name"
  if output=$(npm run "$cmd" 2>&1); then
    echo -e "$PASS"
  else
    echo -e "$FAIL"
    echo "$output" | grep -E "✗|error|Error|failed" | head -10
    echo ""
    echo "Guard failed: $name. Fix the errors above and re-run."
    exit 1
  fi
}

echo ""
echo "=== Military-Grade Guard Pipeline ==="
echo ""

run_guard "guard:specs"     "guard:specs"
run_guard "guard:types"     "guard:types"
run_guard "guard:lint"      "guard:lint"
run_guard "guard:contracts" "guard:contracts"
run_guard "guard:ppr"       "guard:ppr"

echo ""
echo -e "${PASS} All guards passed. Change is complete."
echo ""
