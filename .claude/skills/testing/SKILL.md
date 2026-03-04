---
name: testing
description: Laravel and Livewire testing patterns. Use when writing tests, debugging test failures, or discussing test coverage.
---

# Testing Strategy

**Framework:** Laravel 11.x + Pest PHP / PHPUnit
**Livewire:** Livewire 4.2 testing helpers
**Target:** >80% code coverage

## Test Directory Structure

```
tests/
├── Feature/
│   ├── Livewire/
│   │   ├── SenderClientListTest.php
│   │   ├── DeliveryPartnerViewTest.php
│   │   └── ParcelTrackingTest.php
│   ├── Api/
│   │   └── KioskApiTest.php
│   └── Services/
│       ├── InvoiceGenerationTest.php
│       └── PartnerValidationTest.php
├── Unit/
│   ├── Models/
│   │   ├── SenderClientTest.php
│   │   ├── DeliveryPartnerTest.php
│   │   └── ParcelTest.php
│   └── Helpers/
│       └── CodeGeneratorTest.php
└── Pest.php (or TestCase.php)
```

---

## Livewire Component Testing

### List Component Test
```php
use App\Livewire\Partners\SenderClients;
use App\Models\SenderClient;

test('can render sender clients list', function () {
    SenderClient::factory(3)->create();

    $this->get('/partners/sender-clients')
        ->assertSeeLivewire(SenderClients::class);
});

test('can search sender clients', function () {
    SenderClient::factory()->create(['name' => 'ABC Company']);
    SenderClient::factory()->create(['name' => 'XYZ Company']);

    livewire(SenderClients::class)
        ->set('search', 'ABC')
        ->assertSee('ABC Company')
        ->assertDontSee('XYZ Company');
});

test('can filter by status', function () {
    SenderClient::factory()->create(['status' => 'active']);
    SenderClient::factory()->create(['status' => 'inactive']);

    livewire(SenderClients::class)
        ->set('statusFilter', 'active')
        ->assertSee('Active')
        ->call('render')
        ->assertCount('clients', 1);
});
```

### Detail/View Component Test
```php
use App\Livewire\Partners\SenderClientView;

test('can view sender client details', function () {
    $client = SenderClient::factory()->create(['name' => 'Test Client']);

    livewire(SenderClientView::class, ['slug' => $client->slug])
        ->assertSee('Test Client')
        ->assertSee($client->code);
});

test('can disable active client', function () {
    $client = SenderClient::factory()->create(['status' => 'active']);

    livewire(SenderClientView::class, ['slug' => $client->slug])
        ->call('confirmDisable')
        ->assertHasNoErrors();

    expect($client->fresh()->status)->toBe('inactive');
});

test('can activate inactive client', function () {
    $client = SenderClient::factory()->create(['status' => 'inactive']);

    livewire(SenderClientView::class, ['slug' => $client->slug])
        ->call('activateClient')
        ->assertHasNoErrors();

    expect($client->fresh()->status)->toBe('active');
});
```

### Form Validation Test
```php
use App\Livewire\Partners\SenderClientCreate;

test('validates required fields', function () {
    livewire(SenderClientCreate::class)
        ->call('save')
        ->assertHasErrors(['name', 'email', 'phone']);
});

test('validates email format', function () {
    livewire(SenderClientCreate::class)
        ->set('email', 'invalid-email')
        ->call('save')
        ->assertHasErrors(['email']);
});

test('validates unique email', function () {
    SenderClient::factory()->create(['email' => 'test@example.com']);

    livewire(SenderClientCreate::class)
        ->set('email', 'test@example.com')
        ->call('save')
        ->assertHasErrors(['email']);
});

test('can create sender client', function () {
    livewire(SenderClientCreate::class)
        ->set('name', 'New Client')
        ->set('email', 'new@example.com')
        ->set('phone', '01700000000')
        ->set('business_type', 'ecommerce')
        ->call('save')
        ->assertHasNoErrors()
        ->assertRedirect();

    expect(SenderClient::where('email', 'new@example.com')->exists())->toBeTrue();
});
```

---

## Model Testing

### Model Relationships
```php
use App\Models\SenderClient;
use App\Models\SortingCenter;
use App\Models\User;

test('sender client belongs to sorting center', function () {
    $center = SortingCenter::factory()->create();
    $client = SenderClient::factory()->create([
        'assigned_sorting_center_id' => $center->id
    ]);

    expect($client->sortingCenter)->toBeInstanceOf(SortingCenter::class);
    expect($client->sortingCenter->id)->toBe($center->id);
});

test('sender client belongs to account manager', function () {
    $manager = User::factory()->create();
    $client = SenderClient::factory()->create([
        'account_manager_user_id' => $manager->id
    ]);

    expect($client->accountManager)->toBeInstanceOf(User::class);
});
```

### Auto-Generated Fields
```php
test('generates code on creation', function () {
    $client = SenderClient::factory()->create(['code' => null]);

    expect($client->code)->not->toBeNull();
    expect($client->code)->toStartWith('SNDR-');
});

test('generates slug on creation', function () {
    $client = SenderClient::factory()->create([
        'name' => 'Test Company',
        'code' => 'SNDR-ABC-123'
    ]);

    expect($client->slug)->toBe('test-company-sndr-abc-123');
});

test('generates unique codes', function () {
    $client1 = SenderClient::factory()->create();
    $client2 = SenderClient::factory()->create();

    expect($client1->code)->not->toBe($client2->code);
});
```

---

## Business Logic Testing

### Internal Partner Logic (CRITICAL)
```php
use App\Services\InvoiceService;

test('does not generate invoice for internal partner', function () {
    $internalClient = SenderClient::factory()->create([
        'partner_relationship_type' => 'internal'
    ]);

    $service = new InvoiceService();
    $invoice = $service->generateMonthlyInvoice($internalClient);

    expect($invoice)->toBeNull();
});

test('generates invoice for external partner', function () {
    $externalClient = SenderClient::factory()->create([
        'partner_relationship_type' => 'external'
    ]);

    $service = new InvoiceService();
    $invoice = $service->generateMonthlyInvoice($externalClient);

    expect($invoice)->not->toBeNull();
    expect($invoice->partner_id)->toBe($externalClient->id);
});
```

### Payment Terms Testing
```php
test('prepaid client deducts from balance', function () {
    $client = SenderClient::factory()->create([
        'payment_terms' => 'prepaid',
        'balance' => 1000.00
    ]);

    $service = new PaymentService();
    $service->deductParcelCharge($client, 50.00);

    expect($client->fresh()->balance)->toBe(950.00);
});

test('postpaid client generates invoice', function () {
    $client = SenderClient::factory()->create([
        'payment_terms' => 'postpaid'
    ]);

    $service = new PaymentService();
    $invoice = $service->processParcelCharge($client, 50.00);

    expect($invoice)->not->toBeNull();
});
```

---

## API Testing

### Kiosk API Test
```php
use App\Models\SenderClient;

test('can submit parcel via kiosk API', function () {
    $client = SenderClient::factory()->create([
        'business_type' => 'kiosk',
        'api_key' => 'test-api-key'
    ]);

    $response = $this->postJson('/api/kiosk/parcels', [
        'tracking_number' => 'TEST123',
        'weight' => 2.5,
        'description' => 'Test parcel'
    ], [
        'Authorization' => 'Bearer test-api-key'
    ]);

    $response->assertStatus(201)
        ->assertJsonStructure(['data' => ['id', 'tracking_number']]);
});

test('rejects invalid API key', function () {
    $response = $this->postJson('/api/kiosk/parcels', [
        'tracking_number' => 'TEST123'
    ], [
        'Authorization' => 'Bearer invalid-key'
    ]);

    $response->assertStatus(401);
});
```

---

## Database Testing

### Using Factories
```php
use Database\Factories\SenderClientFactory;

test('can create sender client with factory', function () {
    $client = SenderClient::factory()->create();

    expect(SenderClient::find($client->id))->not->toBeNull();
});

test('can create multiple clients', function () {
    SenderClient::factory(5)->create();

    expect(SenderClient::count())->toBe(5);
});

test('can create client with specific attributes', function () {
    $client = SenderClient::factory()->create([
        'status' => 'active',
        'partner_relationship_type' => 'internal'
    ]);

    expect($client->status)->toBe('active');
    expect($client->partner_relationship_type)->toBe('internal');
});
```

---

## Running Tests

```bash
# Run all tests
php artisan test

# Run specific test file
php artisan test tests/Feature/Livewire/SenderClientListTest.php

# Run tests with coverage
php artisan test --coverage

# Run specific test
php artisan test --filter=can_search_sender_clients

# Run tests in parallel
php artisan test --parallel

# Stop on first failure
php artisan test --stop-on-failure
```

---

## Best Practices

### DO:
- ✅ Test database isolation (use transactions or SQLite :memory:)
- ✅ Use descriptive test names
- ✅ Follow Arrange-Act-Assert pattern
- ✅ Mock external services (payment gateways, APIs)
- ✅ Aim for >80% code coverage
- ✅ Run tests before commits
- ✅ Test both happy path and edge cases

### DON'T:
- ❌ Test framework functionality (test your code, not Laravel)
- ❌ Skip testing critical business logic (internal partner logic!)
- ❌ Write dependent tests (each test should be independent)
- ❌ Test implementation details (test behavior, not code)
- ❌ Ignore failing tests
- ❌ Skip edge cases

---

## Test Data Setup

### Using Tinker for Manual Testing
```bash
php artisan tinker
```

```php
// Create test sender client
$client = App\Models\SenderClient::create([
    'name' => 'Test E-commerce',
    'email' => 'test@example.com',
    'phone' => '01700000000',
    'business_type' => 'ecommerce',
    'partner_relationship_type' => 'external',
    'expected_volume_per_day' => 100
]);

// Create internal partner
$internal = App\Models\SenderClient::create([
    'name' => 'DigiBox Kiosk Network',
    'email' => 'digibox@example.com',
    'phone' => '01700000001',
    'business_type' => 'kiosk',
    'partner_relationship_type' => 'internal'
]);
```

---

**Reference:** See `/docs/common-tasks.md` for test data creation examples
