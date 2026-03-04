---
name: laravel-livewire
description: Laravel 11.x and Livewire 4.2 conventions for the Sorting Center project. Use when creating components, models, routes, or working with Livewire.
---

# Laravel 11.x + Livewire 4.2 Conventions

**Project:** Two-Sided Parcel Sorting Marketplace
**Tech Stack:** Laravel 11.x, Livewire 4.2, Tailwind CSS
**Working Directory:** `/home/rana-workspace/sorting-center/backend/`

## Critical Rules

1. **ALWAYS use components** - Never write raw `<table>`, `<svg>`, or status badge HTML
2. **Use `{slug}` not `{id}`** - URLs must be `/partners/{slug}` for SEO
3. **Internal partners = NO invoices** - Track only, no money transfers (DigiBox Kiosk Network)
4. **Livewire only** - No Alpine.js, use Livewire for all interactivity
5. **Empty states required** - Every list must have `<x-empty-state>` when empty
6. **Consistent colors** - Sender=blue, Delivery=teal, Active=green, Inactive=red

## Livewire Component Pattern

### Standard List Component
```php
<?php
namespace App\Livewire\Partners;

use Livewire\Component;
use Livewire\WithPagination;

class SenderClients extends Component
{
    use WithPagination;

    public $search = '';
    public $statusFilter = '';
    public $perPage = 15;

    protected $queryString = ['search', 'statusFilter'];

    public function updatingSearch()
    {
        $this->resetPage();
    }

    public function render()
    {
        $query = SenderClient::query();

        if ($this->search) {
            $query->where(function ($q) {
                $q->where('name', 'like', '%' . $this->search . '%')
                    ->orWhere('code', 'like', '%' . $this->search . '%');
            });
        }

        if ($this->statusFilter) {
            $query->where('status', $this->statusFilter);
        }

        $clients = $query->latest()->paginate($this->perPage);

        return view('livewire.partners.sender-clients', compact('clients'))
            ->layout('layouts.app', ['title' => 'Sender Clients']);
    }
}
```

### Standard Detail/View Component
```php
<?php
namespace App\Livewire\Partners;

use Livewire\Component;

class SenderClientView extends Component
{
    public SenderClient $client;

    public function mount($slug)
    {
        $this->client = SenderClient::where('slug', $slug)->firstOrFail();
    }

    public function editClient()
    {
        return redirect()->route('partners.sender-clients.edit', $this->client->slug);
    }

    public function confirmDisable()
    {
        $this->client->update(['status' => 'inactive']);
        $this->client->refresh();
        session()->flash('success', "Client disabled.");
    }

    public function render()
    {
        return view('livewire.partners.sender-client-view')
            ->layout('layouts.app', ['title' => $this->client->name]);
    }
}
```

## Routing Pattern

```php
// Use slug in URL, not ID
Route::prefix('partners')->name('partners.')->group(function () {
    Route::prefix('sender-clients')->name('sender-clients.')->group(function () {
        Route::get('/', App\Livewire\Partners\SenderClients::class)->name('index');
        Route::get('/create', App\Livewire\Partners\SenderClientCreate::class)->name('create');
        Route::get('/{slug}', App\Livewire\Partners\SenderClientView::class)->name('view');
        Route::get('/{slug}/edit', App\Livewire\Partners\SenderClientEdit::class)->name('edit');
    });
});
```

## Model Pattern (Auto-Generated Code/Slug)

```php
<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class SenderClient extends Model
{
    protected $fillable = ['code', 'slug', 'name', ...];

    protected static function boot()
    {
        parent::boot();

        static::creating(function ($client) {
            if (empty($client->code)) {
                $client->code = self::generateCode();
            }

            if (empty($client->slug)) {
                $client->slug = Str::slug($client->name . '-' . $client->code);
            }
        });
    }

    private static function generateCode()
    {
        do {
            $code = 'SNDR-' . strtoupper(Str::random(3)) . '-' . str_pad(rand(1, 999), 3, '0', STR_PAD_LEFT);
        } while (self::where('code', $code)->exists());

        return $code;
    }
}
```

## Migration Pattern

```php
Schema::create('sender_clients', function (Blueprint $table) {
    $table->id();

    // Auto-generated fields
    $table->string('code', 20)->unique();
    $table->string('slug', 255)->unique();

    // Basic info
    $table->string('name');
    $table->string('email')->unique();

    // Enums for status and types
    $table->enum('status', ['active', 'inactive', 'suspended', 'pending_approval', 'archived'])
        ->default('pending_approval');

    $table->enum('partner_relationship_type', ['external', 'internal', 'subsidiary'])
        ->default('external');

    // Foreign keys
    $table->foreignId('assigned_sorting_center_id')->nullable()
        ->constrained('sorting_centers')->nullOnDelete();

    $table->timestamps();
});
```

## Validation Pattern

```php
protected $rules = [
    'name' => 'required|string|max:255',
    'email' => 'required|email|unique:sender_clients,email',
    'phone' => 'required|string|max:20',
];

public function updated($propertyName)
{
    $this->validateOnly($propertyName);
}

public function save()
{
    $validated = $this->validate();
    $client = SenderClient::create($validated);
    session()->flash('success', "Client '{$client->name}' created.");
    return redirect()->route('partners.sender-clients.view', $client->slug);
}
```

## Best Practices

✅ DO:
- Use Livewire for all interactivity
- Use `{slug}` in routes, not `{id}`
- Auto-generate code and slug in model boot
- Use query string for filter persistence
- Reset pagination when filters change
- Use enums for fixed value sets
- Add flash messages after actions
- Use wire:confirm for destructive actions

❌ DON'T:
- Use Alpine.js for page logic (Livewire only)
- Expose IDs in URLs
- Forget to validate input
- Mix internal/external partner logic
- Skip empty states
- Hardcode values (use enums/config)

## Quick Commands

```bash
# Create Livewire component
php artisan make:livewire Partners/ComponentName

# Clear caches
php artisan optimize:clear

# Run migrations
php artisan migrate

# Tinker
php artisan tinker
```

**Reference:** See `/docs/development-patterns.md` for complete patterns
