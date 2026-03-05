# Hooks Guide - Token Control for Sorting Center

**Purpose:** Prevent expensive operations and reduce token consumption

---

## 🎯 What Are Hooks?

Hooks are **shell scripts** that run automatically at specific points:
- **Before** tools execute (block expensive ops)
- **On** permission requests (auto-approve safe ops)
- **At** session start (show reminders)

**Key benefit:** Block operations **before** they consume tokens!

---

## 📁 Installed Hooks

### 1. **block-expensive-ops.sh** (PreToolUse)
**When:** Before any Bash command runs
**Purpose:** Block expensive Laravel/Composer operations

**Blocked operations:**
- ❌ `migrate:fresh` - Destroys database
- ❌ `migrate:reset` - Drops all tables
- ❌ `db:wipe` - Wipes database
- ❌ `composer update` - Updates all packages (slow)
- ❌ `composer require` - Installs new packages
- ❌ `npm audit fix` - Auto-fixes vulnerabilities
- ❌ `npm update` - Updates packages
- ❌ `artisan tinker` - Interactive shell (can hang)
- ❌ `DROP TABLE` - SQL destructive
- ❌ `TRUNCATE` - SQL destructive

**Warned operations** (allowed but warned):
- ⚠️  `composer install` - May be slow
- ⚠️  `npm install` - May be slow
- ⚠️  `artisan migrate` - Database changes
- ⚠️  `artisan db:seed` - Data insertion
- ⚠️  `npm run build` - Build process

**Override:** Run blocked commands directly in terminal if needed

---

### 2. **auto-approve-safe.sh** (PermissionRequest)
**When:** Before permission prompts appear
**Purpose:** Auto-approve safe read-only commands

**Auto-approved commands:**
- ✅ `ls`, `pwd`, `cat`, `head`, `tail`
- ✅ `grep`, `find`, `wc`, `echo`, `which`
- ✅ `git status`, `git log`, `git diff`, `git branch`
- ✅ `php artisan list`, `php artisan route:list`
- ✅ `composer --version`, `npm --version`
- ✅ `npm run test`, `npm run lint`

**Result:** No permission prompts for safe operations!

---

### 3. **warn-web-operations.sh** (PreToolUse)
**When:** Before WebSearch or WebFetch runs
**Purpose:** Remind that web operations consume tokens

**Output:**
```
⚠️  WEB OPERATION: This will consume tokens
   Tool: WebSearch
   Query: laravel livewire documentation...
```

**Still allowed** - just a reminder

---

### 4. **session-start.sh** (SessionStart)
**When:** Every time you start/resume session
**Purpose:** Show token-aware mode status

**Output:**
```
🎯 Sorting Center Project - Token-Aware Mode Active

✅ Safe operations auto-approved
🚫 Expensive ops blocked
⚠️  Web operations warned

To override: Run blocked commands directly in terminal
```

---

## 🔧 How Hooks Work

### Hook Execution Flow

```
User asks Claude to run command
        ↓
[PreToolUse Hook Fires]
        ↓
Hook script checks command
        ↓
Exit code 0 = Allow ✅
Exit code 2 = Block ❌
        ↓
Claude proceeds or stops
```

### Exit Codes

| Code | Meaning | Effect |
|------|---------|--------|
| **0** | Success | Tool executes normally |
| **2** | Blocking error | Tool blocked, error shown to Claude |
| **Other** | Non-blocking error | Tool proceeds, error logged |

---

## 🧪 Testing Hooks

### Test block-expensive-ops.sh

```bash
# Simulate blocked command
echo '{"tool_name":"Bash","tool_input":{"command":"php artisan migrate:fresh"}}' \
  | ./.claude/hooks/block-expensive-ops.sh
echo "Exit code: $?"
# Should exit 2 (blocked)

# Simulate allowed command
echo '{"tool_name":"Bash","tool_input":{"command":"ls -la"}}' \
  | ./.claude/hooks/block-expensive-ops.sh
echo "Exit code: $?"
# Should exit 0 (allowed)
```

### Test auto-approve-safe.sh

```bash
# Simulate safe command
echo '{"tool_name":"Bash","tool_input":{"command":"git status"}}' \
  | ./.claude/hooks/auto-approve-safe.sh
# Should output JSON with "allow"

# Simulate unsafe command
echo '{"tool_name":"Bash","tool_input":{"command":"rm -rf /"}}' \
  | ./.claude/hooks/auto-approve-safe.sh
# Should exit 0 without JSON (let normal prompt handle it)
```

---

## 📝 Customizing Hooks

### Add More Blocked Commands

Edit `.claude/hooks/block-expensive-ops.sh`:

```bash
BLOCKED_PATTERNS=(
  "migrate:fresh"
  "composer update"
  # Add your custom patterns:
  "artisan cache:clear"
  "npm ci"
)
```

### Add More Auto-Approved Commands

Edit `.claude/hooks/auto-approve-safe.sh`:

```bash
SAFE_PATTERNS=(
  "^ls "
  "^git status"
  # Add your custom patterns:
  "^php artisan routes$"
  "^composer show"
)
```

---

## 🚨 Troubleshooting

### Hook not firing?
1. Check hooks are executable: `ls -la .claude/hooks/`
2. Verify settings.json syntax: `cat .claude/settings.json | jq`
3. Restart Claude Code session

### "jq: command not found"?
Install jq:
```bash
# Ubuntu/Debian
apt-get install jq

# macOS
brew install jq
```

### Hook errors in transcript?
Test manually:
```bash
echo '{"tool_name":"Bash","tool_input":{"command":"ls"}}' | ./hook.sh
echo $?
```

### Want to disable hooks temporarily?
Rename settings.json:
```bash
mv .claude/settings.json .claude/settings.json.bak
# Restart Claude session
# Restore later:
mv .claude/settings.json.bak .claude/settings.json
```

---

## 💡 Token Savings

**Before hooks:**
- Permission prompts for every command: ~50 tokens each
- Expensive operations run unnecessarily: 500-5000 tokens
- Web searches without warning: 1000-3000 tokens

**After hooks:**
- No prompts for safe commands: **50 tokens saved per command**
- Blocked expensive ops: **500-5000 tokens saved**
- Warned before web searches: **Conscious token usage**

**Estimated savings: 30-50% reduction in token consumption**

---

## 🎯 Best Practices

1. **Review blocked commands** - Adjust patterns for your workflow
2. **Test hooks manually** - Verify they work before relying on them
3. **Keep hooks simple** - Fast execution (< 5 seconds)
4. **Use exit code 2** - Always use code 2 for blocking
5. **Log to stderr** - Error messages go to stderr, not stdout

---

## 📚 Resources

- Claude Code Hooks Documentation: [Official Docs](https://docs.anthropic.com/claude-code)
- Project Settings: `.claude/settings.json`
- Hook Scripts: `.claude/hooks/`

---

## 🔄 Maintenance

**When adding new expensive operations:**
1. Edit `block-expensive-ops.sh`
2. Add pattern to BLOCKED_PATTERNS array
3. Test manually
4. Restart Claude session

**When adding new safe operations:**
1. Edit `auto-approve-safe.sh`
2. Add pattern to SAFE_PATTERNS array
3. Test manually
4. Restart Claude session

---

**Last Updated:** March 5, 2026 (Auto-updated by Claude)
**Hooks Active:** 4 hooks installed
**Status:** Production-ready, token-efficient
