# Component Library Reference

**All 19 Blade components with examples and props**

---

## =Ê Data Display

### x-table
**Purpose:** Data table with headers, pagination, hover effects

**Props:**
- `headers` (array): Column headers
- `paginator` (optional): Laravel paginator for auto-pagination
- `striped` (bool, default true): Striped rows
- `hoverable` (bool, default true): Hover effect

**Example:**
```blade
<x-card>
    <x-table
        :headers="['Name', 'Email', 'Status', 'Actions']"
        :paginator="$clients">
        @foreach($clients as $client)
            <tr>
                <td class="px-6 py-4">{{ $client->name }}</td>
                <td class="px-6 py-4">{{ $client->email }}</td>
                <td class="px-6 py-4">
                    <x-status-badge :status="$client->status" />
                </td>
                <td class="px-6 py-4">
                    <a href="{{ route('clients.view', $client->slug) }}">View</a>
                </td>
            </tr>
        @endforeach
    </x-table>
</x-card>
```

---

### x-status-badge
**Purpose:** Smart status badge with auto-coloring based on type

**Props:**
- `status` (required): Status value
- `type` (optional): 'default', 'partner-type', 'relationship', 'business-type'
- `size` (optional): 'sm', 'md', 'lg'
- `dot` (bool): Animated pulse dot

**Color Mapping:**
- **default**: active’green, inactive/suspended’red, pending’yellow, archived’gray
- **partner-type**: all’teal
- **relationship**: internal’purple, external’gray, subsidiary’indigo
- **business-type**: all’blue

**Examples:**
```blade
{{-- Entity status --}}
<x-status-badge :status="$client->status" />

{{-- Partner type --}}
<x-status-badge :status="$partner->partner_type" type="partner-type" />

{{-- With dot --}}
<x-status-badge :status="$client->status" size="lg" :dot="true" />
```

---

### x-stats-card
**Purpose:** Metric display with icon, label, value

**Props:**
- `label` (required): Metric label
- `value` (required): Metric value
- `color` (optional): blue, teal, emerald, amber, violet, etc.
- `icon` (optional): SVG icon HTML
- `trend` (optional): '+10%'
- `trend-up` (bool): Is trend positive

**Example:**
```blade
<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
    <x-stats-card
        label="Total Clients"
        :value="$stats['total']"
        color="blue"
        :icon="'<svg>...</svg>'"
    />
</div>
```

---

## <¨ Layout

### x-card
**Purpose:** Container with optional title, icon

**Props:**
- `title` (optional): Card title
- `icon` (optional): SVG icon HTML
- `icon-color` (optional): blue, teal, cyan, etc.
- `padding` (optional): 'none', 'compact', 'default', 'loose'
- `shadow` (optional): 'none', 'sm', 'md', 'lg'

**Example:**
```blade
<x-card title="Filters" icon-color="cyan" padding="compact">
    <div class="grid grid-cols-4 gap-4">
        <!-- Content -->
    </div>
</x-card>
```

---

### x-page-header
**Purpose:** Page title with subtitle, breadcrumbs, action buttons

**Props:**
- `title` (required): Page title
- `subtitle` (optional): Description
- `icon` (optional): SVG icon
- `icon-color` (optional): Color
- `breadcrumbs` (optional): Array

**Example:**
```blade
<x-page-header
    title="Sender Clients"
    subtitle="Manage IN partners"
    icon-color="blue">
    <x-button variant="primary" href="{{ route('clients.create') }}">
        <x-icon name="plus" size="sm" class="mr-2" />
        Add Client
    </x-button>
</x-page-header>
```

---

### x-empty-state
**Purpose:** Empty list placeholder

**Props:**
- `title` (required): Empty state title
- `description` (optional): Description
- `icon` (optional): SVG icon
- `icon-color` (optional): Color

**Example:**
```blade
@if($items->count() > 0)
    <x-table :headers="[]" :paginator="$items">...</x-table>
@else
    <x-empty-state
        title="No Clients Yet"
        description="Get started by adding your first client."
        icon-color="blue">
        <x-button variant="primary" href="#">Add Client</x-button>
    </x-empty-state>
@endif
```

---

## <¯ UI Elements

### x-icon
**Purpose:** SVG icons (40+ available)

**Props:**
- `name` (required): Icon name
- `size` (optional): xs, sm, md, lg, xl

**Available Icons:**
- **Actions:** plus, edit, trash, archive, check, x, refresh
- **Navigation:** chevron-right, chevron-down, arrow-left
- **Status:** check-circle, x-circle, exclamation, info, clock
- **Business:** building, truck, package, users, user, mail, phone, location
- **Finance:** money, credit-card, chart
- **Misc:** search, filter, cog, eye, document, calendar, shield

**Examples:**
```blade
<x-icon name="truck" />
<x-icon name="plus" size="sm" class="mr-2 text-blue-500" />

{{-- In button --}}
<x-button variant="primary">
    <x-icon name="edit" size="sm" class="mr-2" />
    Edit
</x-button>
```

---

### x-button
**Purpose:** Styled button with variants

**Props:**
- `variant` (optional): primary, secondary, success, danger, warning, ghost
- `size` (optional): sm, md, lg
- `href` (optional): Link URL (renders as <a>)
- `type` (optional): button, submit, reset

**Examples:**
```blade
{{-- Primary action --}}
<x-button variant="primary" size="md">
    <x-icon name="plus" size="sm" class="mr-2" />
    Add Item
</x-button>

{{-- Link --}}
<x-button variant="secondary" href="/back">Back</x-button>

{{-- Danger with Livewire --}}
<x-button variant="danger" wire:click="delete" wire:confirm="Sure?">
    <x-icon name="trash" size="sm" class="mr-2" />
    Delete
</x-button>
```

---

### x-badge
**Purpose:** General badge

**Props:**
- `variant` (optional): default, primary, success, danger, warning, info, purple
- `size` (optional): sm, md, lg
- `dot` (bool): Animated dot

**Example:**
```blade
<x-badge variant="success">Active</x-badge>
<x-badge variant="warning" :dot="true">Pending</x-badge>
```

---

### x-alert
**Purpose:** Alert messages

**Props:**
- `variant` (optional): info, success, warning, danger

**Example:**
```blade
<x-alert variant="info">
    <strong>Note:</strong> This is important.
</x-alert>
```

---

## =Ý Form Components

### x-input
**Purpose:** Text input with label, icon

**Props:**
- `label` (optional): Label text
- `name` (optional): Name attribute
- `type` (optional): text, email, password, number, etc.
- `placeholder` (optional)
- `icon` (optional): SVG HTML
- `required` (bool)

**Example:**
```blade
<x-input
    label="Email"
    name="email"
    type="email"
    placeholder="user@example.com"
    wire:model="email"
    required
/>
```

---

### x-select
**Purpose:** Dropdown select

**Props:**
- `label` (optional): Label
- `name` (optional): Name
- `options` (required): Array of key=>value
- `required` (bool)

**Example:**
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

---

### x-textarea
**Purpose:** Multi-line text

**Props:**
- `label`, `name`, `placeholder`, `rows`, `required`

**Example:**
```blade
<x-textarea
    label="Description"
    wire:model="description"
    rows="4"
/>
```

---

### x-checkbox
**Purpose:** Checkbox

**Example:**
```blade
<x-checkbox
    label="Enable billing"
    wire:model="billing_enabled"
/>
```

---

### x-radio
**Purpose:** Radio button

**Example:**
```blade
<x-radio
    label="External"
    name="type"
    value="external"
    wire:model="relationship_type"
/>
```

---

## = Interactive

### x-modal
**Purpose:** Modal dialog

**Props:**
- `name` (required): Modal identifier
- `title` (optional)
- `size` (optional): sm, md, lg, xl, 2xl

**Example:**
```blade
<x-modal name="createModal" title="Create Item" size="lg">
    <form wire:submit="save">
        <x-input label="Name" wire:model="name" />
        <div class="mt-4 flex justify-end gap-2">
            <x-button variant="secondary" @click="$dispatch('close-modal', 'createModal')">
                Cancel
            </x-button>
            <x-button variant="primary" type="submit">Save</x-button>
        </div>
    </form>
</x-modal>

{{-- Open modal --}}
<x-button @click="$dispatch('open-modal', 'createModal')">Open</x-button>
```

---

### x-loading
**Purpose:** Loading spinner

**Example:**
```blade
<div wire:loading>
    <x-loading />
</div>
```

---

### x-tabs
**Purpose:** Tab navigation

**Example:**
```blade
<x-tabs>
    <x-slot:tab1><button>Tab 1</button></x-slot:tab1>
    <x-slot:tab2><button>Tab 2</button></x-slot:tab2>
</x-tabs>
```

---

## =¡ Best Practices

### 1. Always use components
```blade
L <table class="min-w-full">...</table>
 <x-table :headers="[]" :paginator="$items">...</x-table>
```

### 2. Use x-icon instead of SVG
```blade
L <svg class="h-5 w-5"><path d="..."/></svg>
 <x-icon name="plus" size="sm" />
```

### 3. Use x-status-badge for status
```blade
L <span class="{{ $status === 'active' ? 'bg-green-100' : 'bg-red-100' }}">...</span>
 <x-status-badge :status="$status" />
```

### 4. Always provide empty states
```blade
@if($items->count() > 0)
    <x-table>...</x-table>
@else
    <x-empty-state>...</x-empty-state>
@endif
```

---

**Last Updated:** March 5, 2026
**Total Components:** 19
**Location:** `backend/resources/views/components/`
