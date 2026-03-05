#!/bin/bash
# Block expensive Laravel/Composer operations that consume tokens

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Exit if no command
if [ -z "$COMMAND" ]; then
  exit 0
fi

# Expensive operations that burn tokens - BLOCKED
BLOCKED_PATTERNS=(
  "migrate:fresh"
  "migrate:reset"
  "db:wipe"
  "composer update"
  "composer require"
  "npm audit fix"
  "npm update"
  "artisan tinker"
  "DROP TABLE"
  "TRUNCATE"
  "DELETE FROM.*WHERE 1=1"
)

for pattern in "${BLOCKED_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qi "$pattern"; then
    echo "🚫 BLOCKED: '$pattern' is expensive and requires explicit approval" >&2
    echo "   To allow this operation, run it directly in your terminal" >&2
    exit 2
  fi
done

# Warn about potentially expensive operations - ALLOW but WARN
WARN_PATTERNS=(
  "composer install"
  "npm install"
  "artisan migrate"
  "artisan db:seed"
  "vendor/bin/phpunit"
  "npm run build"
)

for pattern in "${WARN_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qi "$pattern"; then
    echo "⚠️  WARNING: '$pattern' may consume tokens" >&2
    # Allow but warn
    exit 0
  fi
done

# Allow everything else
exit 0
