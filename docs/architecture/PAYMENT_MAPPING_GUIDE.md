# Payment Terms & Collection Method Mapping Guide

## Overview
This guide explains how **Partner Relationship Type**, **Payment Terms**, and **Payment Collection Method** work together to define business relationships and money flow.

---

## For Sender Clients (Parcel IN Partners)

### Valid Combinations Matrix

| Payment Terms | Valid Collection Methods | Auto-Selected | Use Case |
|---------------|-------------------------|---------------|----------|
| **Prepaid** | `direct_billing`, `internal_transfer` | `direct_billing` | Partner pays upfront, we deduct as we process |
| **Postpaid** | `direct_billing`, `cod_collection`, `internal_transfer`, `mixed` | `direct_billing` | Invoice after service |
| **COD** | `cod_collection`, `mixed` | `cod_collection` | All parcels are COD |

### Payment Terms Explained

#### 1. Prepaid
- **When**: Partner pays BEFORE we provide service
- **Compatible Methods**:
  - ✅ `direct_billing` - Bank transfer to our account upfront
  - ✅ `internal_transfer` - Internal book entry (for internal partners)
  - ❌ `cod_collection` - Invalid (no COD in prepaid)

**Example**: E-commerce company deposits ₹50,000 monthly, we deduct ₹500/day for sorting

#### 2. Postpaid
- **When**: Partner pays AFTER we provide service
- **Compatible Methods**:
  - ✅ `direct_billing` - We invoice monthly, they pay via bank
  - ✅ `cod_collection` - Riders collect COD, we settle with partner
  - ✅ `internal_transfer` - Internal accounting (for internal partners)
  - ✅ `mixed` - Some direct billing + some COD collection

**Example**: We sort 1000 parcels, invoice ₹10,000 + settle ₹50,000 COD collected

#### 3. COD (Cash on Delivery)
- **When**: All transactions are COD-based
- **Compatible Methods**:
  - ✅ `cod_collection` - Riders collect all cash from customers
  - ✅ `mixed` - COD + occasional direct billing
  - ❌ `direct_billing` - Invalid (contradicts COD nature)

**Example**: Traditional COD seller, riders collect ₹100,000, we settle ₹95,000 after fees

---

## For Delivery Partners (Parcel OUT Partners)

### Valid Combinations Matrix

| Payment Terms | Valid Collection Methods | Auto-Selected | Use Case |
|---------------|-------------------------|---------------|----------|
| **Prepaid** | `direct_payment`, `internal_transfer` | `direct_payment` | We pay them upfront |
| **Postpaid** | `direct_payment`, `cod_settlement`, `internal_transfer`, `mixed` | `direct_payment` | We pay after delivery |
| **Commission-Based** | `commission_deduction`, `cod_settlement`, `mixed` | `commission_deduction` | Deduct from their earnings |

### Payment Terms Explained

#### 1. Prepaid
- **When**: We pay delivery partner BEFORE they deliver
- **Compatible Methods**:
  - ✅ `direct_payment` - Bank transfer to them upfront
  - ✅ `internal_transfer` - Internal book entry (for internal partners)
  - ❌ `commission_deduction` - Invalid (we already paid)

**Example**: Premium courier, we pay ₹50/parcel upfront for guaranteed capacity

#### 2. Postpaid
- **When**: We pay delivery partner AFTER they complete delivery
- **Compatible Methods**:
  - ✅ `direct_payment` - Bank transfer after delivery confirmation
  - ✅ `cod_settlement` - They collect COD, we settle net amount
  - ✅ `internal_transfer` - Internal accounting (for internal partners)
  - ✅ `mixed` - Some direct payment + some COD settlement

**Example**: Monthly invoice of ₹100,000 for 2000 deliveries

#### 3. Commission-Based
- **When**: Partner earns from COD/revenue, we deduct commission
- **Compatible Methods**:
  - ✅ `commission_deduction` - Deduct our % from their COD collections
  - ✅ `cod_settlement` - They collect COD, we pay net after commission
  - ✅ `mixed` - Commission + occasional direct payment
  - ❌ `direct_payment` - Invalid (contradicts commission model)

**Example**: Partner collects ₹200,000 COD, we keep ₹30,000 (15%), pay ₹170,000

---

## Partner Relationship Type Impact

### External Partner
```php
partner_relationship_type = 'external'
billing_enabled = true
```
- ✅ Generate invoices
- ✅ Actual money transfers
- ✅ Full payment processing
- All payment terms available

### Internal Partner (e.g., DigiBox Kiosk)
```php
partner_relationship_type = 'internal'
billing_enabled = false
payment_collection_method = 'internal_transfer' (forced)
```
- ❌ No invoices generated
- ❌ No actual money transfers
- ✅ Track all transactions in database
- ✅ Accounting book entries only
- Payment terms can be any, but ignored

### Subsidiary Partner
```php
partner_relationship_type = 'subsidiary'
billing_enabled = true
```
- ✅ Generate invoices (for audit trail)
- ⚠️ Simplified settlement (intercompany)
- ✅ Full tracking in database
- All payment terms available

---

## Real-World Examples

### Example 1: External E-commerce (Sender Client)
```
Partner Relationship: external
Payment Terms: postpaid
Collection Method: mixed
Billing Enabled: true
COD Settlement Enabled: true
```

**Monthly Activity:**
- Sent 500 parcels
- 300 parcels with COD (₹150,000 collected by riders)
- 200 parcels prepaid by customers
- Sorting fees: ₹25,000

**Settlement:**
- We owe them: ₹150,000 (COD)
- They owe us: ₹25,000 (fees)
- **Net: We pay ₹125,000**

---

### Example 2: DigiBox Kiosk (Internal Sender Client)
```
Partner Relationship: internal
Payment Terms: (any, ignored)
Collection Method: internal_transfer (forced)
Billing Enabled: false
COD Settlement Enabled: false
```

**Monthly Activity:**
- Sent 1000 parcels
- COD collected: ₹500,000
- Sorting fees: ₹50,000

**Settlement:**
- No invoice generated
- No money transferred
- **Accounting entry:** "Kiosk Division to Sorting Division: ₹50,000 service charge"

---

### Example 3: Third-Party Courier (Delivery Partner)
```
Partner Relationship: external
Payment Terms: commission_based
Collection Method: commission_deduction
Billing Enabled: true
COD Collection Enabled: true
Commission Rate: 15%
```

**Monthly Activity:**
- Delivered 2000 parcels
- Collected COD: ₹400,000
- Our commission (15%): ₹60,000

**Settlement:**
- They deposit: ₹400,000 (to our bank)
- We pay them: ₹340,000 (₹400k - ₹60k commission)

---

### Example 4: DigiBox Kiosk Network (Internal Delivery Partner)
```
Partner Relationship: internal
Payment Terms: (any, ignored)
Collection Method: internal_transfer (forced)
Billing Enabled: false
COD Collection Enabled: true
Commission Rate: 0%
```

**Monthly Activity:**
- Delivered 5000 parcels to kiosks
- COD collected at kiosks: ₹1,000,000

**Settlement:**
- No commission charged (internal)
- No money transferred between divisions
- **Accounting entry:** "Kiosk Division revenue: ₹1,000,000"

---

## Validation Rules

### Sender Clients
```php
$validCombinations = [
    'prepaid' => ['direct_billing', 'internal_transfer'],
    'postpaid' => ['direct_billing', 'cod_collection', 'internal_transfer', 'mixed'],
    'cod' => ['cod_collection', 'mixed'],
];
```

### Delivery Partners
```php
$validCombinations = [
    'prepaid' => ['direct_payment', 'internal_transfer'],
    'postpaid' => ['direct_payment', 'cod_settlement', 'internal_transfer', 'mixed'],
    'commission_based' => ['commission_deduction', 'cod_settlement', 'mixed'],
];
```

---

## Auto-Mapping Logic

When user selects payment terms, system automatically suggests collection method:

### Sender Clients
- `prepaid` → `direct_billing`
- `postpaid` → `direct_billing`
- `cod` → `cod_collection`

### Delivery Partners
- `prepaid` → `direct_payment`
- `postpaid` → `direct_payment`
- `commission_based` → `commission_deduction`

### Internal Partners (Override)
- Any payment terms → `internal_transfer` (forced)
- `billing_enabled` → `false` (forced)

---

## Database Queries

### Get COD owed to external sender clients:
```sql
SELECT
    sc.name,
    sc.payment_terms,
    sc.payment_collection_method,
    SUM(cc.amount) as total_cod_owed
FROM cod_collections cc
JOIN sender_clients sc ON cc.sender_client_id = sc.id
WHERE sc.partner_relationship_type = 'external'
  AND sc.cod_settlement_enabled = true
  AND cc.status = 'verified'
GROUP BY sc.id;
```

### Track internal partner transactions (no settlement):
```sql
SELECT
    sc.name,
    COUNT(*) as parcel_count,
    SUM(cc.amount) as total_tracked
FROM cod_collections cc
JOIN sender_clients sc ON cc.sender_client_id = sc.id
WHERE sc.partner_relationship_type = 'internal'
  AND sc.billing_enabled = false
GROUP BY sc.id;
-- Used for management reports, no invoices/payments
```

---

## Summary

1. **Partner Relationship** determines IF money moves
2. **Payment Terms** determines WHEN money moves
3. **Collection Method** determines HOW money moves

**Internal Partners** = Track everything, bill nothing
**External Partners** = Track and bill everything
**Subsidiary Partners** = Track and bill for audit, simplified settlement

The system ensures logical combinations through validation and provides auto-suggestions to guide users.
