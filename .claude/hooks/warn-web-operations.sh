#!/bin/bash
# Warn before web operations that consume significant tokens

INPUT=$(cat)
TOOL=$(echo "$INPUT" | jq -r '.tool_name')
QUERY=$(echo "$INPUT" | jq -r '.tool_input.query // .tool_input.url // empty')

# Warn about web operations
echo "⚠️  WEB OPERATION: This will consume tokens" >&2
echo "   Tool: $TOOL" >&2
echo "   Query: ${QUERY:0:100}..." >&2

# Allow but warn
exit 0
