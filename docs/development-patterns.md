# Development Patterns

**Code patterns, conventions, and best practices**

---

## =' Livewire Component Pattern

### Standard List Component

```php
<?php

namespace App\Livewire\Resources;

use App\Models\Resource;
use Livewire\Component;
use Livewire\WithPagination;

class ResourceList extends Component
{
    use WithPagination;

    // Public properties (reactive)
    public $search = '';
    public $statusFilter = '';
    public $perPage = 15;

    // Query string persistence
    protected $queryString = ['search', 'statusFilter'];

    // Reset pagination when searching
    public function updatingSearch()
    {
        $this->resetPage();
    }

    public function updatingStatusFilter()
    {
        $this->resetPage();
    }

    public function render()
    {
        // Build query
        $query = Resource::query();

        // Apply filters
        if ($this->search) {
            $query->where(function ($q) {
                $q->where('name', 'like', '%' . $this->search . '%')
                    ->orWhere('code', 'like', '%' . $this->search . '%')
                    ->orWhere('email', 'like', '%' . $this->search . '%');
            });
        }

        if ($this->statusFilter) {
            $query->where('status', $this->statusFilter);
        }

        // Get paginated results
        $clients = $query->latest()->paginate($this->perPage);

        // Calculate stats
        $stats = [
            'total' => Resource::count(),
            'active' => Resource::where('status', 'active')->count(),
            'pending' => Resource::where('status', 'pending')->count(),
        ];

        return view('livewire.resources', [
            'clients' => $clients,
            'stats' => $stats,
        ])->layout('layouts.app', ['title' => 'Resources']);
    }
}
```

---

### Standard Detail/View Component

```php
<?php

namespace App\Livewire\Partners;

use App\Models\Resource;
use Livewire\Component;

class ResourceView extends Component
{
    public Resource $client;

    // Mount with slug
    public function mount($slug)
    {
        $this->client = Resource::where('slug', $slug)->firstOrFail();
    }

    // Edit action
    public function editClient()
    {
        return redirect()->route('resources.edit', $this->client->slug);
    }

    // Disable action
    public function confirmDisable()
    {
        $this->client->update(['status' => 'inactive']);
        $this->client->refresh();
        session()->flash('success', "Client '{$this->client->name}' has been disabled.");
    }

    // Activate action
    public function activateClient()
    {
        $this->client->update(['status' => 'active']);
        $this->client->refresh();
        session()->flash('success', "Client '{$this->client->name}' has been activated.");
    }

    // Archive action with redirect
    public function confirmArchive()
    {
        $this->client->update(['status' => 'archived']);
        session()->flash('success', "Client '{$this->client->name}' has been archived.");
        return redirect()->route('resources.index');
    }

    public function render()
    {
        return view('livewire.partners.sender-client-view')
            ->layout('layouts.app', ['title' => $this->client->name]);
    }
}
```

---

## =� Model Patterns

### Auto-Generated Fields

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class Resource extends Model
{
    protected $fillable = [
        'code',
        'slug',
        'name',
        // ... other fields
    ];

    // Auto-generate code and slug
    protected static function boot()
    {
        parent::boot();

        static::creating(function ($client) {
            // Generate unique code
            if (empty($client->code)) {
                $client->code = self::generateCode();
            }

            // Generate slug from name + code
            if (empty($client->slug)) {
                $client->slug = Str::slug($client->name . '-' . $client->code);
            }
        });
    }

    // Generate unique code
    private static function generateCode()
    {
        do {
            $code = 'SNDR-' . strtoupper(Str::random(3)) . '-' . str_pad(rand(1, 999), 3, '0', STR_PAD_LEFT);
        } while (self::where('code', $code)->exists());

        return $code;
    }

    // Relationships
    public function sortingCenter()
    {
        return $this->belongsTo(SortingCenter::class, 'assigned_sorting_center_id');
    }

    public function accountManager()
    {
        return $this->belongsTo(User::class, 'account_manager_user_id');
    }
}
```

---

## =� Routing Patterns

### Web Routes (Livewire)

```php
<?php

use Illuminate\Support\Facades\Route;

// Partners Management
Route::prefix('partners')->name('partners.')->group(function () {

    // Resources (IN Partners)
    Route::prefix('sender-clients')->name('sender-clients.')->group(function () {
        Route::get('/', App\Livewire\Partners\Resources::class)->name('index');
        Route::get('/create', App\Livewire\Partners\ResourceCreate::class)->name('create');
        Route::get('/{slug}', App\Livewire\Partners\ResourceView::class)->name('view');
        Route::get('/{slug}/edit', App\Livewire\Partners\ResourceEdit::class)->name('edit');
    });

    // Delivery Partners (OUT Partners)
    Route::prefix('delivery-partners')->name('delivery-partners.')->group(function () {
        Route::get('/', App\Livewire\Partners\DeliveryPartners::class)->name('index');
        Route::get('/create', App\Livewire\Partners\DeliveryPartnerCreate::class)->name('create');
        Route::get('/{slug}', App\Livewire\Partners\DeliveryPartnerView::class)->name('view');
        Route::get('/{slug}/edit', App\Livewire\Partners\DeliveryPartnerEdit::class)->name('edit');
    });
});
```

**Key Points:**
- Use slug in URL: `/{slug}` not `/{id}`
- Class-based routing for Livewire
- Consistent naming: prefix � name
- RESTful structure

---

## =� Database Patterns

### Migration with Enums

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('resources', function (Blueprint $table) {
            $table->id();

            // Auto-generated fields
            $table->string('code', 20)->unique();
            $table->string('slug', 255)->unique();

            // Basic info
            $table->string('name');
            $table->string('email')->unique();
            $table->string('phone', 20);

            // Enums for status and types
            $table->enum('status', [
                'active',
                'inactive',
                'suspended',
                'pending_approval',
                'archived'
            ])->default('pending_approval');

            $table->enum('business_type', [
                'ecommerce',
                'kiosk',
                'retail',
                'marketplace'
            ]);

            $table->enum('partner_relationship_type', [
                'external',
                'internal',
                'subsidiary'
            ])->default('external');

            $table->enum('payment_terms', [
                'prepaid',
                'postpaid',
                'cod',
                'credit'
            ])->default('postpaid');

            // Foreign keys
            $table->foreignId('assigned_sorting_center_id')->nullable()
                ->constrained('sorting_centers')->nullOnDelete();

            $table->foreignId('account_manager_user_id')->nullable()
                ->constrained('users')->nullOnDelete();

            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('resources');
    }
};
```

---

## =� View Patterns

### Standard List View

```blade
<div>
    {{-- Page Header --}}
    <x-page-header
        title="Resources"
        subtitle="Manage parcel IN partners"
        icon-color="blue">
        <x-button variant="primary" href="{{ route('resources.create') }}">
            <x-icon name="plus" size="sm" class="mr-2" />
            Add Client
        </x-button>
    </x-page-header>

    {{-- Stats Cards --}}
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
        <x-stats-card label="Total" :value="$stats['total']" color="blue" />
        <x-stats-card label="Active" :value="$stats['active']" color="emerald" />
    </div>

    {{-- Filters --}}
    <x-card title="Filters" icon-color="cyan" padding="compact">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
            <x-input
                label="Search"
                wire:model.debounce.500ms="search"
                placeholder="Name, code, email..."
            />

            <x-select
                label="Status"
                wire:model="statusFilter"
                :options="[
                    '' => 'All',
                    'active' => 'Active',
                    'inactive' => 'Inactive'
                ]"
            />
        </div>
    </x-card>

    {{-- Data Table or Empty State --}}
    @if($clients->count() > 0)
        <x-card class="mt-6">
            <x-table :headers="['Client', 'Status', 'Actions']" :paginator="$clients">
                @foreach($clients as $client)
                    <tr>
                        <td class="px-6 py-4">
                            <div class="text-sm font-medium">{{ $client->name }}</div>
                            <div class="text-xs text-gray-500">{{ $client->code }}</div>
                        </td>
                        <td class="px-6 py-4">
                            <x-status-badge :status="$client->status" />
                        </td>
                        <td class="px-6 py-4">
                            <a href="{{ route('resources.view', $client->slug) }}">
                                View
                            </a>
                        </td>
                    </tr>
                @endforeach
            </x-table>
        </x-card>
    @else
        <x-card class="mt-6">
            <x-empty-state
                title="No Clients Yet"
                description="Get started by adding your first client.">
                <x-button variant="primary" href="{{ route('resources.create') }}">
                    Add Client
                </x-button>
            </x-empty-state>
        </x-card>
    @endif
</div>
```

---

### Standard Detail View

```blade
<div>
    {{-- Page Header with Actions --}}
    <x-page-header :title="$client->name" subtitle="Client Details">
        <div class="flex space-x-3">
            <x-button variant="secondary" href="{{ route('resources.index') }}">
                Back
            </x-button>
            <x-button variant="primary" wire:click="editClient">
                <x-icon name="edit" size="sm" class="mr-2" />
                Edit
            </x-button>
            @if($client->status === 'active')
                <x-button variant="warning" wire:click="confirmDisable" wire:confirm="Sure?">
                    <x-icon name="x-circle" size="sm" class="mr-2" />
                    Disable
                </x-button>
            @else
                <x-button variant="success" wire:click="activateClient" wire:confirm="Sure?">
                    <x-icon name="check-circle" size="sm" class="mr-2" />
                    Activate
                </x-button>
            @endif
        </div>
    </x-page-header>

    {{-- Status Badges --}}
    <div class="mt-4 flex flex-wrap gap-2">
        <x-status-badge :status="$client->status" size="lg" />
        @if($client->partner_relationship_type === 'internal')
            <x-badge variant="purple" size="lg">Internal Partner</x-badge>
        @endif
    </div>

    {{-- Content Cards --}}
    <x-card title="Basic Information" class="mt-6">
        <div class="grid grid-cols-2 gap-4">
            <div>
                <label class="text-sm font-medium text-gray-500">Code</label>
                <p class="mt-1 font-mono">{{ $client->code }}</p>
            </div>
            <div>
                <label class="text-sm font-medium text-gray-500">Email</label>
                <p class="mt-1">{{ $client->email }}</p>
            </div>
        </div>
    </x-card>

    {{-- Internal Partner Alert --}}
    @if($client->partner_relationship_type === 'internal')
        <x-alert variant="info" class="mt-6">
            <strong>Internal Partner:</strong> Transactions tracked for reporting only.
            No invoices generated.
        </x-alert>
    @endif
</div>
```

---

## = Form Validation Pattern

```php
class ResourceCreate extends Component
{
    public $name = '';
    public $email = '';
    public $phone = '';

    protected $rules = [
        'name' => 'required|string|max:255',
        'email' => 'required|email|unique:resources,email',
        'phone' => 'required|string|max:20',
    ];

    protected $messages = [
        'name.required' => 'Resource name is required',
        'email.email' => 'Please enter a valid email',
        'email.unique' => 'This email is already registered',
    ];

    // Real-time validation
    public function updated($propertyName)
    {
        $this->validateOnly($propertyName);
    }

    // Submit
    public function save()
    {
        $validated = $this->validate();

        $client = Resource::create($validated);

        session()->flash('success', "Client '{$client->name}' created successfully.");

        return redirect()->route('resources.view', $client->slug);
    }
}
```

---

## =� Best Practices

### DO:
-  Use Livewire for all interactivity
-  Use `{slug}` in routes, not `{id}`
-  Auto-generate code and slug in model boot
-  Use query string for filter persistence
-  Reset pagination when filters change
-  Use enums for fixed value sets
-  Add flash messages after actions
-  Use wire:confirm for destructive actions

### DON'T:
- L Use Alpine.js for page logic (Livewire only)
- L Expose IDs in URLs
- L Forget to validate input
- L Mix internal/external partner logic
- L Skip empty states
- L Hardcode values (use enums/config)

---

**Last Updated:** March 5, 2026
**Framework:** Laravel 11.x + Livewire 4.2
