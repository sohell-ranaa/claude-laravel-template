# Common Development Tasks

**Step-by-step guides for frequent operations**

---

## =Ä Adding a New Page

### Step 1: Create Livewire Component

```bash
php artisan make:livewire Partners/NewFeature
```

**Creates:**
- `app/Livewire/Partners/NewFeature.php`
- `resources/views/livewire/partners/new-feature.blade.php`

---

### Step 2: Add Route

Edit `routes/web.php`:

```php
Route::get('/partners/new-feature', App\Livewire\Partners\NewFeature::class)
    ->name('partners.new-feature');
```

---

### Step 3: Implement Component

`app/Livewire/Partners/NewFeature.php`:

```php
<?php

namespace App\Livewire\Partners;

use Livewire\Component;

class NewFeature extends Component
{
    public function render()
    {
        return view('livewire.partners.new-feature')
            ->layout('layouts.app', ['title' => 'New Feature']);
    }
}
```

---

### Step 4: Build View

`resources/views/livewire/partners/new-feature.blade.php`:

```blade
<div>
    <x-page-header
        title="New Feature"
        subtitle="Description"
        icon-color="blue">
        <x-button variant="primary" href="#">
            <x-icon name="plus" size="sm" class="mr-2" />
            Action
        </x-button>
    </x-page-header>

    <x-card class="mt-6">
        <p>Content here</p>
    </x-card>
</div>
```

---

### Step 5: Add to Menu (Optional)

Edit `resources/views/layouts/app.blade.php` sidebar section.

---

## • Adding Management Actions

### Step 1: Add Methods to Component

```php
class SenderClientView extends Component
{
    public SenderClient $client;

    // Edit
    public function editClient()
    {
        return redirect()->route('partners.sender-clients.edit', $this->client->slug);
    }

    // Disable
    public function confirmDisable()
    {
        $this->client->update(['status' => 'inactive']);
        $this->client->refresh();
        session()->flash('success', "Client disabled.");
    }

    // Activate
    public function activateClient()
    {
        $this->client->update(['status' => 'active']);
        $this->client->refresh();
        session()->flash('success', "Client activated.");
    }

    // Archive (with redirect)
    public function confirmArchive()
    {
        $this->client->update(['status' => 'archived']);
        session()->flash('success', "Client archived.");
        return redirect()->route('partners.sender-clients.index');
    }
}
```

---

### Step 2: Add Buttons to View

```blade
<x-page-header :title="$client->name">
    <div class="flex space-x-3">
        <x-button variant="primary" wire:click="editClient">
            <x-icon name="edit" size="sm" class="mr-2" />
            Edit
        </x-button>

        @if($client->status === 'active')
            <x-button variant="warning" wire:click="confirmDisable"
                wire:confirm="Are you sure you want to disable this client?">
                <x-icon name="x-circle" size="sm" class="mr-2" />
                Disable
            </x-button>
        @else
            <x-button variant="success" wire:click="activateClient"
                wire:confirm="Are you sure you want to activate this client?">
                <x-icon name="check-circle" size="sm" class="mr-2" />
                Activate
            </x-button>
        @endif

        <x-button variant="danger" wire:click="confirmArchive"
            wire:confirm="This action cannot be undone easily. Continue?">
            <x-icon name="archive" size="sm" class="mr-2" />
            Archive
        </x-button>
    </div>
</x-page-header>
```

---

## >ê Creating Test Data

### Using Tinker

```bash
php artisan tinker
```

**Create Sender Client:**
```php
$client = App\Models\SenderClient::create([
    'name' => 'Test E-commerce',
    'email' => 'test@ecommerce.com',
    'phone' => '01700000000',
    'business_type' => 'ecommerce',
    'partner_relationship_type' => 'external',
    'expected_volume_per_day' => 100,
    'assigned_sorting_center_id' => 1,
    'billing_enabled' => true,
]);
```

**Create Delivery Partner:**
```php
$partner = App\Models\DeliveryPartner::create([
    'name' => 'Test Courier',
    'email' => 'test@courier.com',
    'phone' => '01700000001',
    'partner_type' => 'courier_service',
    'partner_relationship_type' => 'external',
    'delivery_capacity_per_day' => 200,
    'commission_rate' => 5.5,
    'assigned_sorting_center_id' => 1,
]);
```

**Internal Partner (DigiBox):**
```php
// As Sender
$digiboxSender = App\Models\SenderClient::create([
    'name' => 'DigiBox Kiosk Network',
    'email' => 'sender@digibox.com',
    'phone' => '01700000002',
    'business_type' => 'kiosk',
    'partner_relationship_type' => 'internal', //  
    'expected_volume_per_day' => 500,
    'assigned_sorting_center_id' => 1,
]);

// As Delivery Partner
$digiboxDelivery = App\Models\DeliveryPartner::create([
    'name' => 'DigiBox Kiosk Network',
    'email' => 'delivery@digibox.com',
    'phone' => '01700000003',
    'partner_type' => 'kiosk_network',
    'partner_relationship_type' => 'internal', //  
    'delivery_capacity_per_day' => 500,
    'commission_rate' => 0, // Internal partner
    'assigned_sorting_center_id' => 1,
]);
```

---

## =Ä Adding Database Column

### Step 1: Create Migration

```bash
php artisan make:migration add_new_field_to_sender_clients_table
```

---

### Step 2: Write Migration

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('sender_clients', function (Blueprint $table) {
            $table->string('new_field')->nullable()->after('existing_field');
        });
    }

    public function down(): void
    {
        Schema::table('sender_clients', function (Blueprint $table) {
            $table->dropColumn('new_field');
        });
    }
};
```

---

### Step 3: Run Migration

```bash
php artisan migrate
```

---

### Step 4: Update Model

Add to `$fillable` in model:

```php
protected $fillable = [
    // ... existing fields
    'new_field',
];
```

---

## <¨ Adding New Icon

### Step 1: Edit Icon Component

Edit `resources/views/components/icon.blade.php`:

```php
$icons = [
    // ... existing icons
    'new-icon' => '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M..." />',
];
```

---

### Step 2: Use Icon

```blade
<x-icon name="new-icon" size="sm" />
```

---

### Step 3: Update Docs

Update `docs/components-guide.md` icon list.

---

## = Adding Status Badge Type

### Step 1: Edit Status Badge Component

Edit `resources/views/components/status-badge.blade.php`:

```php
// Add to appropriate mapping
$partnerTypeColors = [
    // ... existing types
    'new_type' => 'bg-indigo-100 text-indigo-800',
];
```

---

### Step 2: Use Badge

```blade
<x-status-badge :status="$partner->new_type" type="partner-type" />
```

---

## = Debugging Common Issues

### Empty List Shows But Has Data

**Check:**
1. Is Livewire component querying database?
2. Is pagination working?
3. Are filters applied correctly?

```php
// Debug query
$clients = $query->latest()->paginate($this->perPage);
logger($clients->total()); // Check count
```

---

### Routes Not Working

**Fix:**
```bash
php artisan route:clear
php artisan route:cache
```

**Check:**
```bash
php artisan route:list --name=partners
```

---

### Components Not Showing

**Fix:**
```bash
php artisan optimize:clear
php artisan view:clear
```

---

### Livewire Not Updating

**Check:**
1. Is property public?
2. Is wire:model correct?
3. Are you using $this->property in methods?

```php
// L Wrong
private $search;

//  Correct
public $search = '';
```

---

## =æ Clearing Caches

### All Caches

```bash
php artisan optimize:clear
```

**Or individually:**

```bash
php artisan cache:clear        # Application cache
php artisan config:clear       # Config cache
php artisan route:clear        # Route cache
php artisan view:clear         # View cache
php artisan livewire:clear     # Livewire cache
```

---

## = Checking What Changed

### Git Status

```bash
git status
git diff
git log -5 --oneline
```

---

### Database Changes

```bash
php artisan migrate:status     # Check migrations
php artisan db:show           # Show database info
```

---

## =¡ Quick Tips

### Testing Internal Partner Logic

```php
// In tinker
$client = App\Models\SenderClient::find(1);

// Check if internal
if ($client->partner_relationship_type === 'internal') {
    echo "  This is an internal partner - NO invoices!";
}
```

---

### Quick Data Seeding

```bash
# Run specific seeder
php artisan db:seed --class=SenderClientSeeder

# Or all seeders
php artisan db:seed
```

---

### Checking Logs

```bash
tail -f storage/logs/laravel.log
```

---

**Last Updated:** March 5, 2026
**Tip:** Bookmark this file for quick reference!
