#!/bin/bash
# Auto-approve safe read-only operations to reduce permission prompts

INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '.tool_name')
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Exit if no command
if [ -z "$COMMAND" ]; then
  exit 0
fi

# Safe read-only commands - AUTO-APPROVE
SAFE_PATTERNS=(
  "^ls "
  "^ls$"
  "^pwd"
  "^cat "
  "^head "
  "^tail "
  "^grep "
  "^find "
  "^wc "
  "^echo "
  "^which "
  "^git status"
  "^git log"
  "^git diff"
  "^git branch"
  "^php artisan list"
  "^php artisan route:list"
  "^php artisan --version"
  "^composer --version"
  "^npm --version"
  "^npm run test"
  "^npm run lint"
)

for pattern in "${SAFE_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -Eq "$pattern"; then
    # Auto-approve with JSON response
    cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PermissionRequest",
    "decision": {
      "behavior": "allow"
    }
  }
}
EOF
    exit 0
  fi
done

# Let other commands prompt normally
exit 0
