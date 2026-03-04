# Laravel + Livewire Claude Code Template

**Use this template to quickly set up new Laravel + Livewire projects with Claude Code.**

---

## 🎯 What's Included

This template provides:
- ✅ **claude.md** - Main Claude Code instructions (generic, customizable)
- ✅ **.claude/settings.json** - Auto-approved commands (no permission prompts)
- ✅ **.claude/skills/** - 4 pre-built skills (Laravel, Blade, Business Logic, Testing)
- ✅ **docs/** - Documentation structure (components, patterns, tasks)
- ✅ **Modular code guidelines** - Keep files small (<300 lines)
- ✅ **Auto-maintenance rules** - Claude keeps docs in sync

---

## 🚀 Quick Start (New Project)

### Option 1: From Template Branch

```bash
# Clone specific branch
cd /path/to/workspace
git clone <your-repo-url> -b claude-template my-new-project
cd my-new-project

# Customize for your project
1. Rename claude-template.md to claude.md
2. Edit claude.md:
   - Replace [YOUR PROJECT NAME]
   - Update working directory path
   - Customize business model section
   - Define your color schemes
   - Add domain-specific rules
3. Customize .claude/skills/business-logic/SKILL.md
4. Update docs/business-rules.md

# Start coding!
composer create-project laravel/laravel .
# ... install Livewire, etc.
```

### Option 2: From Separate Template Repo

```bash
# Clone template
git clone https://github.com/you/claude-laravel-template /tmp/template

# Start your new project
cd /path/to/your-new-project
cp /tmp/template/claude.md .
cp -r /tmp/template/.claude .
cp -r /tmp/template/docs .

# Customize (same as Option 1)

# Clean up
rm -rf /tmp/template
```

---

## 📋 Customization Checklist

After copying the template, customize these files:

### 1. **claude.md**
- [ ] Replace `[YOUR PROJECT NAME]` with actual name
- [ ] Update working directory path
- [ ] Define your business model
- [ ] Set feature color schemes
- [ ] Add domain-specific critical rules
- [ ] Delete setup instructions section

### 2. **.claude/skills/business-logic/SKILL.md**
- [ ] Replace two-sided marketplace with your domain
- [ ] Update partner types with your entities
- [ ] Define your business rules
- [ ] Update code examples

### 3. **docs/business-rules.md**
- [ ] Document your business logic
- [ ] Define entity relationships
- [ ] Specify workflows

### 4. **docs/components-guide.md**
- [ ] Keep as-is initially
- [ ] Add project-specific components as you build

### 5. **docs/development-patterns.md**
- [ ] Keep Laravel/Livewire patterns
- [ ] Add project-specific patterns as needed

---

## 🎨 Included Components

**19 Pre-built Blade Components:**
1. x-table (data tables with pagination)
2. x-status-badge (smart status badges)
3. x-icon (40+ SVG icons)
4. x-button (5 variants)
5. x-empty-state (empty state messages)
6. x-page-header (page headers with actions)
7. x-card (content cards)
8. x-input (form inputs)
9. x-select (dropdowns)
10. x-textarea (text areas)
11. x-checkbox (checkboxes)
12. x-radio (radio buttons)
13. x-badge (generic badges)
14. x-alert (alert messages)
15. x-stats-card (statistics cards)
16. x-modal (modal dialogs)
17. x-dropdown (dropdown menus)
18. x-tabs (tab navigation)
19. x-loading (loading spinners)

**See:** `docs/components-guide.md` for usage

---

## 🛠️ Included Skills

### 1. `/laravel-livewire`
- Laravel 11.x + Livewire 4.2 conventions
- Component patterns (list, detail, form)
- Routing with slug-based URLs
- Model auto-generation
- Migration patterns

### 2. `/blade-components`
- All 19 Blade components with examples
- Component props and usage
- Icon library (40+ icons)
- Standard view patterns

### 3. `/business-logic`
- **Customize this for your domain!**
- Template includes two-sided marketplace example
- Replace with your business rules

### 4. `/testing`
- Livewire component testing
- Model testing
- Business logic testing
- API testing patterns

---

## 📁 File Structure

```
your-project/
├── claude.md                    # Main instructions (customize!)
├── .claude/
│   ├── settings.json           # Auto-approved commands
│   ├── settings.local.json     # Personal (gitignored)
│   └── skills/
│       ├── laravel-livewire/   # Laravel + Livewire patterns
│       ├── blade-components/   # Component library
│       ├── business-logic/     # Your domain logic (customize!)
│       └── testing/            # Testing patterns
├── docs/
│   ├── README.md               # Documentation index
│   ├── components-guide.md     # Component library docs
│   ├── business-rules.md       # Your business rules (customize!)
│   ├── development-patterns.md # Laravel/Livewire patterns
│   └── common-tasks.md         # How-to guides
├── app/
│   ├── Livewire/               # Livewire components
│   ├── Services/               # Business logic services
│   └── Models/
└── resources/
    └── views/
        └── components/         # Blade components (copy from template)
```

---

## 🎯 Key Features

### 1. **Modular Code Enforcement**
- PHP: Max 300 lines
- Blade: Max 200 lines
- JS/CSS: Max 250 lines
- Claude auto-splits large files

### 2. **Auto-Maintenance**
- Claude updates docs automatically
- No permission needed
- Code ↔ Docs always in sync

### 3. **Token Efficiency**
- Simple tasks: ~2K tokens
- Medium tasks: ~3-4K tokens
- Complex tasks: ~5-7K tokens
- 25-30% savings vs monolithic docs

### 4. **Skills System**
- Auto-loaded when needed
- Manual invoke: `/skill-name`
- Team-shared via git

### 5. **No Permission Prompts**
- Auto-approved: `git`, `composer`, `artisan`, `npm`, `ls`, `cd`, etc.
- Blocked: `.env` files, `curl`, `wget`

---

## 🔄 Keeping Template Updated

### Update Template from Project Improvements

If you make improvements in a project that should be in the template:

```bash
# In your project
cd /path/to/your-project

# Switch to template branch
git checkout claude-template

# Update generic files
# - Generalize improvements in claude.md
# - Update skills if needed
# - Update docs templates

git add .
git commit -m "Template: Add improved pattern for X"
git push origin claude-template

# Switch back to project
git checkout main
```

### Pull Template Updates into Existing Project

```bash
# In your project
git checkout main

# Merge template changes (carefully!)
git merge claude-template --no-commit

# Review changes, keep project-specific customizations
# Resolve conflicts manually

git commit -m "Update Claude Code setup from template"
```

---

## 🎁 Example Projects Using This Template

1. **Sorting Center** (original) - Two-sided parcel marketplace
2. **Your Project 1** - Description
3. **Your Project 2** - Description

---

## 📚 Resources

- [Laravel Documentation](https://laravel.com/docs)
- [Livewire Documentation](https://livewire.laravel.com)
- [Tailwind CSS](https://tailwindcss.com)
- [Claude Code Documentation](https://docs.anthropic.com/claude-code)

---

## 🤝 Contributing

Improvements to the template are welcome!

1. Make improvements in your project
2. Generalize them
3. Update template branch
4. Share with team

---

**Last Updated:** March 5, 2026
**Version:** 1.0
**Maintainer:** Your Team
