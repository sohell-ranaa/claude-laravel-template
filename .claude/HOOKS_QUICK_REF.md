# Hooks Quick Reference Card

## 🚫 Blocked Operations (Exit 2)
```
migrate:fresh, migrate:reset, db:wipe
composer update, composer require
npm audit fix, npm update
artisan tinker
DROP TABLE, TRUNCATE
```

## ✅ Auto-Approved (No Prompt)
```
ls, pwd, cat, head, tail, grep, find, wc
git status, git log, git diff, git branch
php artisan list, artisan route:list
composer --version, npm --version
npm run test, npm run lint
```

## ⚠️  Warned (Still Allowed)
```
WebSearch, WebFetch
composer install, npm install
artisan migrate, artisan db:seed
npm run build
```

## 🔧 Quick Commands

### Test hook manually
```bash
echo '{"tool_name":"Bash","tool_input":{"command":"YOUR_COMMAND"}}' | ./.claude/hooks/block-expensive-ops.sh
echo $?  # 0=allow, 2=block
```

### Add blocked command
```bash
vim .claude/hooks/block-expensive-ops.sh
# Add to BLOCKED_PATTERNS array
```

### Add auto-approved command
```bash
vim .claude/hooks/auto-approve-safe.sh
# Add to SAFE_PATTERNS array
```

### Disable hooks temporarily
```bash
mv .claude/settings.json .claude/settings.json.bak
# Restart Claude
```

### Re-enable hooks
```bash
mv .claude/settings.json.bak .claude/settings.json
# Restart Claude
```

## 📊 Token Savings
- Permission prompts: **50 tokens saved per command**
- Blocked expensive ops: **500-5000 tokens saved**
- Conscious web usage: **1000-3000 tokens saved**

**Total: 30-50% token reduction**

## 📖 Full Documentation
See: `.claude/HOOKS_GUIDE.md`
