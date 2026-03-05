# Git Worktrees Quick Reference

## 🎯 What & Why

**Work on multiple branches simultaneously without switching**

---

## ⚡ Essential Commands

```bash
# Create worktree
git worktree add ../project-feature feature/name

# List all
git worktree list

# Remove
git worktree remove ../project-feature

# Clean up deleted
git worktree prune
```

---

## 🚀 Standard Workflow

```bash
# 1. Create feature worktree
cd /path/to/your-project
git worktree add ../your-project-feature-name feature/feature-name

# 2. Work on feature
cd ../your-project-feature-name
composer install && npm install
php artisan serve --port=8001

# 3. Open separate Claude session
claude  # Independent context!

# 4. After merging, cleanup
cd /path/to/your-project
git worktree remove ../your-project-feature-name
git branch -d feature/feature-name
```

---

## 💡 Key Benefits

- ✅ No stashing/switching branches
- ✅ Separate Claude sessions (isolated context)
- ✅ Test multiple approaches in parallel
- ✅ Keep main branch running while developing
- ✅ Shared .claude/ settings across worktrees

---

## ⚠️ Important Notes

1. **Each worktree needs own:**
   - `composer install` / `npm install`
   - Different port: `--port=8001`, `8002`, etc.
   - Optional: Different DB in .env

2. **Shared across worktrees:**
   - `.claude/` folder (settings, hooks, commands)
   - `claude.md`
   - `docs/`

3. **Naming:** `project-name-feature-name`

---

## 🎯 Common Scenarios

**Urgent Hotfix:** Create worktree for hotfix while keeping feature work intact

**Parallel Features:** Multiple worktrees for different features

**Testing Approaches:** Try different implementations in separate worktrees

---

**See claude.md** for more details on worktrees section
