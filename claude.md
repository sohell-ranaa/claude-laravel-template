# Claude Code - Laravel Project Template

**Project:** [YOUR PROJECT NAME]
**Tech:** Laravel 11.x, Livewire 4.2, Tailwind CSS
**Working Dir:** `/path/to/your/project/`

> **Setup Instructions:**
> 1. Replace [YOUR PROJECT NAME] with your actual project name
> 2. Update working directory path
> 3. Customize CRITICAL RULES for your domain
> 4. Update business model description
> 5. Adjust color schemes for your features
> 6. Delete this setup section

---

## 🚨 CRITICAL RULES (Never Violate)

1. **ALWAYS use components** - Never write `<table>`, `<svg>`, or status badge HTML
2. **Use `{slug}` not `{id}`** - URLs must be `/resource/{slug}` for SEO
3. **Livewire only** - No Alpine.js, use Livewire for all interactivity
4. **Empty states required** - Every list must have `<x-empty-state>` when empty
5. **Consistent colors** - Define your color scheme below
6. **Modular files only** - No large files (PHP/JS/CSS). Split into small, reusable modules (<300 lines)

**Add your domain-specific rules here:**
- [ ] Your critical business rule 1
- [ ] Your critical business rule 2

---

## 🧩 Modular Code Guidelines

### File Size Limits
- **PHP files:** Max 300 lines per file
- **Blade views:** Max 200 lines per file
- **JS/CSS files:** Max 250 lines per file
- **If exceeding limits:** Split into smaller, reusable modules/components

### How to Keep Files Modular

**❌ DON'T:**
```php
// One huge controller with 800 lines
class ResourceController {
    public function create() { /* 200 lines */ }
    public function update() { /* 200 lines */ }
    // ... more methods
}
```

**✅ DO:**
```php
// Split into services
class ResourceController {
    public function create() {
        return (new ResourceCreationService())->handle($request);
    }
}

// app/Services/ResourceCreationService.php (100 lines)
// app/Services/ResourceUpdateService.php (100 lines)
```

**Blade Components:**
```blade
{{-- DON'T: 400-line view --}}
{{-- DO: Split into components --}}
<x-page-header />
<x-filters-card />
<x-data-table />
<x-pagination />
```

---

## 🎯 Skills System

**Skills** = Specialized knowledge modules loaded on-demand

**Available Skills:**
- `/laravel-livewire` - Laravel + Livewire conventions
- `/blade-components` - Blade components library
- `/business-logic` - Your domain-specific business rules
- `/testing` - Laravel/Livewire testing patterns

**Auto-loaded when needed** - Claude decides when to invoke

**Manual invoke:** Type `/skill-name` in Claude session

📖 **Skills location:** `.claude/skills/` (team-shared via git)

---

## 🏗️ Business Model (Quick)

**Describe your business model here:**
- What does your application do?
- Who are the main user types?
- What are the core entities/resources?

📖 **Details:** `/business-logic` skill or `docs/business-rules.md`

---

## 🎨 Component Quick Reference

### Most Used:

```blade
{{-- Table --}}
<x-table :headers="['Name', 'Status']" :paginator="$items">
    @foreach($items as $item)
        <tr>
            <td class="px-6 py-4">{{ $item->name }}</td>
            <td class="px-6 py-4"><x-status-badge :status="$item->status" /></td>
        </tr>
    @endforeach
</x-table>

{{-- Status Badge --}}
<x-status-badge :status="$resource->status" />

{{-- Icon --}}
<x-icon name="plus|edit|trash|check" size="sm|md|lg" />

{{-- Button --}}
<x-button variant="primary|secondary|success|danger" size="md">
    <x-icon name="plus" size="sm" class="mr-2" />
    Action
</x-button>

{{-- Empty State --}}
@if($items->count() > 0)
    <x-table>...</x-table>
@else
    <x-empty-state title="No items yet" description="Get started...">
        <x-button variant="primary" href="#">Add Item</x-button>
    </x-empty-state>
@endif
```

📖 **All components:** `/blade-components` skill or `docs/components-guide.md`

---

## 📛 Naming Conventions

```
Livewire Component:  ResourceList.php           (PascalCase)
View File:          resource-list.blade.php    (kebab-case)
Route Name:         resources.index            (kebab-case)
URL:                /resources/{slug}          (slug, not id)
Model:              Resource                   (PascalCase, singular)
Table:              resources                  (snake_case, plural)
Service:            ResourceCreationService.php (PascalCase + Service suffix)
```

---

## 🎨 Color Schemes

**Define your feature colors:**
- Feature A: `blue`, `indigo`
- Feature B: `teal`, `emerald`
- Feature C: `purple`, `violet`

**Status colors (standard):**
- Active: `green`, `emerald`
- Inactive: `red`, `rose`
- Pending: `amber`, `yellow`

---

## 🔧 Quick Patterns

### Livewire Component:
```php
<?php
namespace App\Livewire\Resources;

use Livewire\Component;
use Livewire\WithPagination;

class ResourceList extends Component
{
    use WithPagination;

    public $search = '';
    public $statusFilter = '';
    protected $queryString = ['search', 'statusFilter'];

    public function updatingSearch() {
        $this->resetPage();
    }

    public function render() {
        $resources = Resource::query()
            ->when($this->search, fn($q) => $q->where('name', 'like', "%{$this->search}%"))
            ->latest()
            ->paginate(15);

        return view('livewire.resources.resource-list', compact('resources'))
            ->layout('layouts.app');
    }
}
```

### Routes:
```php
Route::get('/resources', App\Livewire\Resources\ResourceList::class)
    ->name('resources.index');
Route::get('/resources/{slug}', App\Livewire\Resources\ResourceView::class)
    ->name('resources.view');
```

📖 **More patterns:** `/laravel-livewire` skill or `docs/development-patterns.md`

---

## ✅ Feature Completion Checklist

Every feature must have:
- [ ] Used components (no raw HTML tables, SVG, badges)
- [ ] Empty state for lists
- [ ] Slug-based URLs (not ID)
- [ ] Proper status badges with correct types
- [ ] Consistent colors
- [ ] `wire:confirm` for destructive actions
- [ ] Success flash messages after actions
- [ ] Files are modular (<300 lines)
- [ ] Reusable services extracted

**Add your domain-specific checklist items:**
- [ ] Your requirement 1
- [ ] Your requirement 2

---

## 📚 Reference Documentation

**Core Docs (Load on-demand):**
- Components → `docs/components-guide.md` (~2.5K tokens)
- Business rules → `docs/business-rules.md` (~1.8K tokens)
- Code patterns → `docs/development-patterns.md` (~2.2K tokens)
- How-to guides → `docs/common-tasks.md` (~1.5K tokens)

**Quick Decision Guide:**
- Building UI? → Load `/blade-components` skill
- Business logic? → Load `/business-logic` skill
- New feature? → Load `/laravel-livewire` skill
- Testing? → Load `/testing` skill

---

## 🤖 Auto-Maintenance Rules

**Claude has FULL AUTONOMY to:**
- ✅ Add/update/delete files as needed
- ✅ Update this file (claude.md) when making changes
- ✅ Update docs when code changes
- ✅ Update skills when patterns change
- ✅ Refactor code to stay modular
- ✅ Split large files into smaller modules
- ✅ No permission required

**Auto-update triggers:**

| When you... | Claude updates... |
|-------------|-------------------|
| Add new component | `docs/components-guide.md` + this file |
| Change business logic | `docs/business-rules.md` + `/business-logic` skill |
| Add new pattern | `docs/development-patterns.md` + `/laravel-livewire` skill |
| Solve common issue | `docs/common-tasks.md` |
| Change critical rule | This file's CRITICAL RULES section |
| Add/modify skill | This file's Skills section |
| Change settings | This file + `.claude/settings.json` |
| Create large file | Auto-split into modular files |

**Update protocol:**
1. Make the change
2. Update relevant documentation
3. Update this file if needed
4. Update skills if patterns changed
5. Commit together (code + docs)

**Keep these in sync:**
- Code ↔ Documentation
- Skills ↔ Actual patterns
- claude.md ↔ Project state
- Settings ↔ Team workflow

---

## 🎯 Token Usage Strategy

| Task Type | Load | Est. Tokens |
|-----------|------|-------------|
| Simple (add button, fix typo) | This file only | ~2K |
| Medium (add table, new page) | This + 1 skill | ~3-4K |
| Complex (new feature) | This + 2-3 skills/docs | ~5-7K |

**Savings: 25-30% vs single large file**

---

## 📋 Project Configuration

**Settings:** `.claude/settings.json` (team-shared)
**Skills:** `.claude/skills/` (customize for your domain)
**Hooks:** `.claude/hooks/` (4 hooks, token-control)
**Components:** `resources/views/components/`
**Livewire:** `app/Livewire/` (organized by feature)

**Permissions configured:** File ops, git, composer, artisan, npm (auto-approved)
**Blocked:** `.env` files, curl, wget (security)

### 🎯 Token Control (Hooks Active)

**Hooks automatically:**
- ✅ Auto-approve safe commands (no prompts)
- 🚫 Block expensive operations (migrate:fresh, composer update, etc.)
- ⚠️  Warn before web searches
- 📊 Show token-aware mode on session start

**Estimated token savings: 30-50%**

**See:** `.claude/HOOKS_GUIDE.md` for complete documentation
**Quick ref:** `.claude/HOOKS_QUICK_REF.md` (1-page cheatsheet)

---

**Last Updated:** [DATE] (Auto-updated by Claude)
**Component System:** Blade components
**Skills:** Customized for [YOUR PROJECT]
**Status:** Production-ready, modular, token-efficient

**Quick Links:**
- Components: `resources/views/components/`
- Livewire: `app/Livewire/`
- Services: `app/Services/`
- Skills: `.claude/skills/`
- Docs: `docs/`
