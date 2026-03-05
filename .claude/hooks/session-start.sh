#!/bin/bash
# Display token-aware mode message on session start

cat << 'EOF'
{
  "systemMessage": "🎯 Sorting Center Project - Token-Aware Mode Active\n\n✅ Safe operations auto-approved\n🚫 Expensive ops blocked (migrate:fresh, composer update, etc.)\n⚠️  Web operations warned\n\nTo override: Run blocked commands directly in terminal"
}
EOF

exit 0
