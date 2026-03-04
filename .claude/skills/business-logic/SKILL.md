---
name: business-logic
description: Two-sided marketplace business rules and partner logic. Use when working with partners, payments, invoicing, or financial operations.
---

# Business Logic & Rules

**Business Model:** Two-Sided Parcel Sorting Marketplace
**Critical:** Always check `partner_relationship_type` before financial operations

## ⚠️ CRITICAL RULE: Internal Partners

**Internal partners = NO invoices, NO payments**

### Internal Partner Logic
```php
// ALWAYS check before generating invoice/payment
if ($partner->partner_relationship_type === 'internal') {
    // DO: Record transaction for reporting
    // DON'T: Generate invoice
    // DON'T: Create payment record
    // DON'T: Charge commission

    $this->recordInternalTransaction($partner, $amount);
    return; // Skip invoicing logic
}

// For external partners only
$this->generateInvoice($partner, $amount);
$this->processPayment($partner);
```

### Display Internal Partner Alert
```blade
@if($partner->partner_relationship_type === 'internal')
    <x-alert variant="info">
        <strong>Internal Partner:</strong> Transactions tracked for reporting only.
        No invoices or payments are generated.
    </x-alert>
@endif
```

---

## Two-Sided Marketplace

### Parcel IN Partners (SenderClient)
- E-commerce platforms
- Kiosk networks
- Retailers
- Marketplaces
- **Send parcels TO sorting centers**

**Key Fields:**
- `partner_relationship_type`: `external`, `internal`, `subsidiary`
- `business_type`: `ecommerce`, `kiosk`, `retail`, `marketplace`
- `expected_volume_per_day`
- `total_parcels_sent`
- `billing_enabled`
- `cod_settlement_enabled`

### Parcel OUT Partners (DeliveryPartner)
- Courier services
- Kiosk networks
- Last-mile delivery providers
- **Receive sorted parcels FROM sorting centers**

**Key Fields:**
- `partner_relationship_type`: `external`, `internal`, `subsidiary`
- `partner_type`: `courier_service`, `kiosk_network`, `last_mile_provider`, `freight_forwarder`
- `delivery_capacity_per_day`
- `total_parcels_received`
- `commission_rate`
- `cod_collection_enabled`

---

## Partner Relationship Types

### 1. External Partners
**Characteristics:**
- ✅ Invoices are generated monthly
- ✅ Actual money transfers occur
- ✅ Payment terms apply (prepaid, postpaid, COD)
- ✅ Commission/fees are charged
- ✅ Tax calculations apply

**Code Check:**
```php
if ($partner->partner_relationship_type === 'external') {
    // Generate invoice
    // Process payment
    // Charge commission
}
```

### 2. Internal Partners ⚠️
**Definition:** Own divisions/departments (e.g., DigiBox Kiosk Network)

**Characteristics:**
- ❌ **NO invoices generated**
- ❌ **NO money transfers**
- ❌ **NO commission charged**
- ✅ Transactions tracked for reporting only
- ✅ All entries are "book entries"
- ✅ Used for internal analytics

**Example:** DigiBox Kiosk Network (both sender and delivery)

### 3. Subsidiary Partners
**Characteristics:**
- ✅ Invoices generated but with special terms
- ✅ Preferential rates
- ✅ Consolidated billing
- ✅ Simplified payment flows

---

## DigiBox Kiosk Network Scenario

**Special Case:** Acts as BOTH sender AND delivery partner

### Database Records
```php
// Two separate records
SenderClient: {
    code: 'DIGI-SND-001',
    name: 'DigiBox Kiosk Network',
    partner_relationship_type: 'internal', // ⚠️
    business_type: 'kiosk'
}

DeliveryPartner: {
    code: 'DIGI-DEL-001',
    name: 'DigiBox Kiosk Network',
    partner_relationship_type: 'internal', // ⚠️
    partner_type: 'kiosk_network'
}
```

**Both marked as `internal` → NO invoices, NO payments**

---

## Payment Terms

### 1. Prepaid
- Client pays BEFORE service
- Balance deducted from credit
- No invoices generated

### 2. Postpaid
- Client pays AFTER service (monthly)
- Invoices generated at month-end
- Payment due based on terms (7 days, 15 days, etc.)

### 3. COD (Cash on Delivery)
- Delivery partner collects cash from end customer
- Delivery partner remits to sorting center
- Sorting center settles with sender client

### 4. Credit
- Client has credit limit
- Balance tracked
- Auto-invoice when credit used

---

## Status Workflows

### Partner Status Lifecycle
```
pending_approval → active → inactive
                    ↓
                suspended
                    ↓
                archived (soft delete)
```

**Status Meanings:**
- `pending_approval`: Awaiting verification
- `active`: Operational
- `inactive`: Temporarily disabled (can reactivate)
- `suspended`: Frozen due to issues (requires review)
- `archived`: No longer in use (soft delete)

---

## Business Rules Summary

### DO:
- ✅ Track ALL transactions (internal and external)
- ✅ Generate invoices for external partners only
- ✅ Check `partner_relationship_type` before invoicing
- ✅ Use consistent status workflows
- ✅ Calculate commission for external delivery partners
- ✅ Validate API keys for external partners

### DON'T:
- ❌ Generate invoices for internal partners
- ❌ Create payment records for internal partners
- ❌ Charge commission to internal partners
- ❌ Mix internal and external payment logic
- ❌ Skip tracking internal transactions (still need reporting)

---

## Code Examples

### Creating External Partner
```php
$client = SenderClient::create([
    'name' => 'Test E-commerce',
    'email' => 'test@ecommerce.com',
    'phone' => '01700000000',
    'business_type' => 'ecommerce',
    'partner_relationship_type' => 'external', // ✅ External
    'expected_volume_per_day' => 100,
    'billing_enabled' => true,
]);
```

### Creating Internal Partner (DigiBox)
```php
$digiboxSender = SenderClient::create([
    'name' => 'DigiBox Kiosk Network',
    'email' => 'sender@digibox.com',
    'phone' => '01700000002',
    'business_type' => 'kiosk',
    'partner_relationship_type' => 'internal', // ⚠️ Internal
    'expected_volume_per_day' => 500,
    'billing_enabled' => false, // NO billing for internal
]);
```

### Invoice Generation Logic
```php
public function generateMonthlyInvoices()
{
    $partners = SenderClient::where('status', 'active')->get();

    foreach ($partners as $partner) {
        // CRITICAL: Check relationship type
        if ($partner->partner_relationship_type === 'internal') {
            // Skip invoice generation for internal partners
            Log::info("Skipping invoice for internal partner: {$partner->name}");
            continue;
        }

        // Generate invoice for external partners only
        $invoice = $this->createInvoice($partner);
        $this->sendInvoiceEmail($partner, $invoice);
    }
}
```

### Checking in Tinker
```php
// In tinker
$client = App\Models\SenderClient::find(1);

// Check if internal
if ($client->partner_relationship_type === 'internal') {
    echo "⚠️ This is an internal partner - NO invoices!";
}
```

---

**Reference:** See `/docs/business-rules.md` for complete business logic documentation
