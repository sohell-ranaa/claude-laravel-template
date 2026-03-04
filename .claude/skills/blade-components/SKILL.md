---
name: blade-components
description: Blade component library (19 components) for the Sorting Center UI. Use when building views, tables, forms, or UI elements.
---

# Blade Component Library

**Location:** `backend/resources/views/components/`
**Total Components:** 19 unified components
**Style:** Tailwind CSS utility-first

## Most Used Components

### Table Component
```blade
<x-table :headers="['Name', 'Status', 'Actions']" :paginator="$items">
    @foreach($items as $item)
        <tr>
            <td class="px-6 py-4">{{ $item->name }}</td>
            <td class="px-6 py-4"><x-status-badge :status="$item->status" /></td>
        </tr>
    @endforeach
</x-table>
```

**Props:**
- `headers` (array, required) - Table column headers
- `paginator` (object, optional) - Laravel paginator for auto-pagination
- `striped` (bool, default: true) - Zebra striping
- `hoverable` (bool, default: true) - Row hover effect

---

### Status Badge Component
```blade
<x-status-badge :status="$client->status" />
<x-status-badge :status="$partner->partner_type" type="partner-type" />
<x-status-badge :status="$partner->partner_relationship_type" type="relationship" />
```

**Props:**
- `status` (string, required) - Status value
- `type` (string, default: 'default') - Badge type: `default`, `partner-type`, `relationship`
- `size` (string, default: 'md') - Size: `sm`, `md`, `lg`
- `dot` (bool, default: false) - Show status dot

**Auto Color Mapping:**
- `active` → green
- `inactive` → red
- `pending` → yellow
- `internal` → purple
- `external` → gray

---

### Icon Component
```blade
<x-icon name="plus" size="sm" class="mr-2" />
<x-icon name="edit" />
<x-icon name="trash" class="text-red-500" />
```

**Props:**
- `name` (string, required) - Icon name (40+ available)
- `size` (string, default: 'md') - Size: `xs`, `sm`, `md`, `lg`, `xl`

**Available Icons:**
Actions: `plus`, `edit`, `trash`, `archive`, `check`, `x-circle`, `check-circle`
Navigation: `arrow-left`, `arrow-right`, `chevron-down`, `chevron-up`
Business: `truck`, `package`, `users`, `user`, `building`, `currency-dollar`
Status: `clock`, `calendar`, `chart-bar`, `eye`, `download`, `upload`
And 20+ more...

---

### Button Component
```blade
<x-button variant="primary" size="md">
    <x-icon name="plus" size="sm" class="mr-2" />
    Add Item
</x-button>

<x-button variant="danger" wire:click="delete" wire:confirm="Are you sure?">
    Delete
</x-button>
```

**Props:**
- `variant` (string) - `primary`, `secondary`, `success`, `danger`, `warning`
- `size` (string) - `sm`, `md`, `lg`
- `href` (string, optional) - Makes button a link
- `type` (string, default: 'button') - Button type

---

### Empty State Component
```blade
@if($items->count() > 0)
    <x-table>...</x-table>
@else
    <x-empty-state
        title="No items yet"
        description="Get started by adding your first item.">
        <x-button variant="primary" href="{{ route('items.create') }}">
            Add Item
        </x-button>
    </x-empty-state>
@endif
```

**Props:**
- `title` (string, required)
- `description` (string, optional)
- Slot for action buttons

---

### Page Header Component
```blade
<x-page-header
    title="Sender Clients"
    subtitle="Manage parcel IN partners"
    icon-color="blue">
    <x-button variant="primary" href="{{ route('partners.sender-clients.create') }}">
        <x-icon name="plus" size="sm" class="mr-2" />
        Add Client
    </x-button>
</x-page-header>
```

**Props:**
- `title` (string, required)
- `subtitle` (string, optional)
- `icon-color` (string) - Tailwind color name
- Slot for action buttons

---

### Card Component
```blade
<x-card title="Basic Information" icon-color="blue" padding="normal">
    <p>Card content here</p>
</x-card>
```

**Props:**
- `title` (string, optional)
- `icon-color` (string, optional)
- `padding` (string) - `compact`, `normal`, `large`

---

### Input Component
```blade
<x-input
    label="Email Address"
    wire:model="email"
    type="email"
    placeholder="Enter email..."
    required
/>
```

**Props:**
- `label` (string, optional)
- `type` (string, default: 'text')
- `placeholder` (string, optional)
- `required` (bool, default: false)

---

### Select Component
```blade
<x-select
    label="Status"
    wire:model="statusFilter"
    :options="[
        '' => 'All',
        'active' => 'Active',
        'inactive' => 'Inactive'
    ]"
/>
```

**Props:**
- `label` (string, optional)
- `options` (array, required) - Key-value pairs

---

### Alert Component
```blade
<x-alert variant="success">
    Operation completed successfully!
</x-alert>

<x-alert variant="warning">
    <strong>Warning:</strong> This action cannot be undone.
</x-alert>

@if($client->partner_relationship_type === 'internal')
    <x-alert variant="info">
        <strong>Internal Partner:</strong> Transactions tracked for reporting only.
        No invoices generated.
    </x-alert>
@endif
```

**Props:**
- `variant` (string) - `success`, `danger`, `warning`, `info`
- `dismissible` (bool, default: false)

---

### Stats Card Component
```blade
<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
    <x-stats-card label="Total" :value="$stats['total']" color="blue" />
    <x-stats-card label="Active" :value="$stats['active']" color="emerald" />
    <x-stats-card label="Pending" :value="$stats['pending']" color="amber" />
</div>
```

**Props:**
- `label` (string, required)
- `value` (mixed, required)
- `color` (string) - Tailwind color
- `icon` (string, optional)

---

## Color Scheme (Consistent Usage)

**Features:**
- Sender Clients (IN): `blue`, `indigo`
- Delivery Partners (OUT): `teal`, `emerald`
- Riders: `emerald`
- COD: `amber`
- Settlements: `sky`

**Status:**
- Active: `green`, `emerald`
- Inactive: `red`, `rose`
- Pending: `amber`, `yellow`

---

## Standard View Pattern

```blade
<div>
    {{-- Page Header --}}
    <x-page-header
        title="Page Title"
        subtitle="Description"
        icon-color="blue">
        <x-button variant="primary" href="#">
            <x-icon name="plus" size="sm" class="mr-2" />
            Action
        </x-button>
    </x-page-header>

    {{-- Stats Cards --}}
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
        <x-stats-card label="Total" :value="$stats['total']" color="blue" />
    </div>

    {{-- Filters --}}
    <x-card title="Filters" icon-color="cyan" padding="compact">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
            <x-input
                label="Search"
                wire:model.debounce.500ms="search"
                placeholder="Search..."
            />
        </div>
    </x-card>

    {{-- Data Table or Empty State --}}
    @if($items->count() > 0)
        <x-card class="mt-6">
            <x-table :headers="['Name', 'Status']" :paginator="$items">
                @foreach($items as $item)
                    <tr>
                        <td class="px-6 py-4">{{ $item->name }}</td>
                        <td class="px-6 py-4">
                            <x-status-badge :status="$item->status" />
                        </td>
                    </tr>
                @endforeach
            </x-table>
        </x-card>
    @else
        <x-card class="mt-6">
            <x-empty-state
                title="No Items Yet"
                description="Get started by adding your first item.">
                <x-button variant="primary" href="#">Add Item</x-button>
            </x-empty-state>
        </x-card>
    @endif
</div>
```

---

## All 19 Components

1. `x-table` - Data tables with pagination
2. `x-status-badge` - Status indicators
3. `x-icon` - SVG icons (40+ icons)
4. `x-button` - Buttons (5 variants)
5. `x-empty-state` - Empty state messages
6. `x-page-header` - Page headers
7. `x-card` - Content cards
8. `x-input` - Text inputs
9. `x-select` - Dropdowns
10. `x-textarea` - Text areas
11. `x-checkbox` - Checkboxes
12. `x-radio` - Radio buttons
13. `x-badge` - Generic badges
14. `x-alert` - Alert messages
15. `x-stats-card` - Statistics cards
16. `x-modal` - Modal dialogs
17. `x-dropdown` - Dropdown menus
18. `x-tabs` - Tab navigation
19. `x-loading` - Loading spinners

**Reference:** See `/docs/components-guide.md` for complete documentation
