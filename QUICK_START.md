# Quick Start - Using This Template

## 🚀 Start New Project (5 Steps)

### 1. Copy Template
```bash
cp -r /home/rana-workspace/claude-laravel-template /path/to/new-project
cd /path/to/new-project
```

### 2. Customize `claude.md`
```bash
vim claude.md
```

**Replace:**
- `[YOUR PROJECT NAME]` → Your actual project name
- Working directory path
- Business model description
- Feature color schemes

**Example:**
```markdown
**Project:** E-Commerce Platform
**Working Dir:** `/home/user/my-ecommerce/`

**Two-sided marketplace:** → **Online store:**
- Products
- Orders
- Customers
```

### 3. Customize Business Logic Skill
```bash
vim .claude/skills/business-logic/SKILL.md
```

**Replace:**
- "Two-sided marketplace" with your domain
- "Partners" with your main entities
- Update business rules

**Example:**
```markdown
# E-Commerce Business Logic

## Products
- Inventory management
- Pricing rules
- Stock levels

## Orders
- Order processing
- Payment handling
- Fulfillment
```

### 4. Start Laravel
```bash
composer create-project laravel/laravel backend
cd backend
composer require livewire/livewire
```

### 5. Start Coding!
```bash
claude
# Claude now knows all your conventions!
```

---

## 📝 Customization Checklist

In `claude.md`, update:
- [ ] Project name
- [ ] Working directory path
- [ ] Business model description
- [ ] Feature colors
- [ ] Domain-specific critical rules

In `.claude/skills/business-logic/SKILL.md`, update:
- [ ] Business domain description
- [ ] Entity names (replace "partners")
- [ ] Business rules
- [ ] Code examples

In `docs/business-rules.md`, update:
- [ ] Business logic documentation
- [ ] Workflows
- [ ] Entity relationships

---

## 🎯 What You Get

✅ Auto-approved commands (no permission prompts)
✅ 4 pre-configured skills
✅ Modular code guidelines (<300 lines per file)
✅ Complete documentation structure
✅ 19 Blade components ready to use
✅ Token-efficient setup (25-30% savings)

---

## 💡 Tips

**Keep template updated:**
When you make improvements in a project:
1. Update the template with generic version
2. Other projects benefit from improvements

**Share with team:**
Push template to GitHub/GitLab so team can use it

**Protect from changes:**
Keep original template clean, copy for each project

---

## 🆘 Need Help?

- Full guide: `README.md`
- Setup details: `/home/rana-workspace/sorting-center/SETUP_TEMPLATE_BRANCH.md`
- Template docs: `/home/rana-workspace/sorting-center/TEMPLATE_README.md`

---

**Happy coding! 🚀**
