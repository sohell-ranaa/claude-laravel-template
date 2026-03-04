# Testing Guide: Payment Terms & Collection Method Scenarios

## How to Test

Visit:
- **Sender Clients**: http://172.16.0.89:8000/partners/sender-clients/create
- **Delivery Partners**: http://172.16.0.89:8000/partners/delivery-partners/create

---

## Test Scenarios for Sender Clients

### ✅ Test 1: External Partner with Postpaid
1. Select **Partner Relationship**: `External Partner`
2. Select **Payment Terms**: `Postpaid`
3. **Expected Result**:
   - ✅ Collection Method auto-selects to: `Direct Billing`
   - ✅ "Billing Enabled" checkbox: `checked` and `enabled`
   - ✅ "COD Settlement Enabled" checkbox: `checked` and `enabled`
   - ✅ Collection Method dropdown: `enabled` (can change)
   - ✅ Can manually change to: `COD Collection` or `Mixed`

---

### ✅ Test 2: Internal Partner (DigiBox Kiosk)
1. Select **Partner Relationship**: `Internal (Same Company - e.g., DigiBox Kiosk)`
2. **Expected Result**:
   - ✅ Collection Method auto-locks to: `Internal Transfer`
   - ✅ "Billing Enabled" checkbox: `unchecked` and `disabled` (grayed out)
   - ✅ "COD Settlement Enabled" checkbox: `unchecked` and `disabled` (grayed out)
   - ✅ Collection Method dropdown: `disabled` (grayed out)
   - ✅ Warning message appears: "🔒 Auto-locked to Internal Transfer for internal partners"
   - ✅ Checkboxes show: "🔒 Disabled for internal partners"

---

### ✅ Test 3: Prepaid Partner
1. Select **Partner Relationship**: `External Partner`
2. Select **Payment Terms**: `Prepaid`
3. **Expected Result**:
   - ✅ Collection Method auto-selects to: `Direct Billing`
   - ✅ Can change to: `Internal Transfer` (if needed)
   - ❌ Cannot select: `COD Collection` or `Mixed` (validation error if tried)

---

### ✅ Test 4: COD-Only Partner
1. Select **Partner Relationship**: `External Partner`
2. Select **Payment Terms**: `COD`
3. **Expected Result**:
   - ✅ Collection Method auto-selects to: `COD Collection`
   - ✅ Can change to: `Mixed`
   - ❌ Cannot select: `Direct Billing` (validation error if tried)

---

### ✅ Test 5: Change from External to Internal
1. Select **Partner Relationship**: `External Partner`
2. Select **Payment Terms**: `Postpaid`
3. Select **Collection Method**: `COD Collection`
4. Now change **Partner Relationship** to: `Internal`
5. **Expected Result**:
   - ✅ Collection Method immediately changes to: `Internal Transfer`
   - ✅ Both checkboxes auto-uncheck and disable
   - ✅ Dropdown becomes disabled with warning message

---

### ✅ Test 6: Change Payment Terms (External Partner)
1. Select **Partner Relationship**: `External Partner`
2. Select **Payment Terms**: `Prepaid`
   - ✅ Should auto-select `Direct Billing`
3. Change **Payment Terms** to: `COD`
   - ✅ Should auto-change to `COD Collection`
4. Change **Payment Terms** to: `Postpaid`
   - ✅ Should auto-change to `Direct Billing`

---

## Test Scenarios for Delivery Partners

### ✅ Test 7: External Delivery Partner - Commission Based
1. Select **Partner Relationship**: `External Partner`
2. Select **Payment Terms**: `Commission-Based`
3. **Expected Result**:
   - ✅ Collection Method auto-selects to: `Commission Deduction`
   - ✅ "Billing Enabled" checkbox: `checked` and `enabled`
   - ✅ Collection Method dropdown: `enabled`
   - ✅ Can change to: `COD Settlement` or `Mixed`

---

### ✅ Test 8: Internal Delivery Partner (DigiBox Kiosk Network)
1. Select **Partner Relationship**: `Internal (Same Company)`
2. **Expected Result**:
   - ✅ Collection Method auto-locks to: `Internal Transfer`
   - ✅ "Billing Enabled" checkbox: `unchecked` and `disabled` (grayed out)
   - ✅ Collection Method dropdown: `disabled` (grayed out)
   - ✅ Warning message appears: "🔒 Auto-locked to Internal Transfer"
   - ✅ Commission Rate can be set to `0%`

---

### ✅ Test 9: Postpaid Delivery Partner
1. Select **Partner Relationship**: `External Partner`
2. Select **Payment Terms**: `Postpaid`
3. **Expected Result**:
   - ✅ Collection Method auto-selects to: `Direct Payment`
   - ✅ Can change to: `COD Settlement`, `Internal Transfer`, or `Mixed`

---

### ✅ Test 10: Prepaid Delivery Partner
1. Select **Partner Relationship**: `External Partner`
2. Select **Payment Terms**: `Prepaid`
3. **Expected Result**:
   - ✅ Collection Method auto-selects to: `Direct Payment`
   - ✅ Can change to: `Internal Transfer`
   - ❌ Cannot select: `Commission Deduction` or `COD Settlement` (validation error)

---

## Validation Testing

### ❌ Test 11: Invalid Combination - Sender Client
1. Fill form with:
   - Partner Relationship: `External`
   - Payment Terms: `Prepaid`
   - Collection Method: `COD Collection` (manually select)
2. Click **Create Sender Client**
3. **Expected Result**:
   - ❌ Form shows error: "Collection method 'cod_collection' is not compatible with payment terms 'prepaid'"
   - ❌ Form does not submit

---

### ❌ Test 12: Invalid Combination - Delivery Partner
1. Fill form with:
   - Partner Relationship: `External`
   - Payment Terms: `Commission-Based`
   - Collection Method: `Direct Payment` (manually select)
2. Click **Create Delivery Partner**
3. **Expected Result**:
   - ❌ Form shows error: "Collection method 'direct_payment' is not compatible with payment terms 'commission_based'"
   - ❌ Form does not submit

---

## Visual Feedback Checklist

### When Partner Relationship = Internal:
- ✅ Collection Method dropdown has gray background
- ✅ Collection Method dropdown shows `cursor-not-allowed`
- ✅ Amber warning text appears below dropdown
- ✅ Billing Enabled checkbox is grayed out (opacity-50)
- ✅ COD Settlement checkbox is grayed out (opacity-50)
- ✅ Lock icon (🔒) appears in warning messages

### When Partner Relationship = External:
- ✅ All fields are enabled and interactive
- ✅ Normal cursor on all controls
- ✅ No warning messages about auto-locking
- ✅ Checkboxes have normal opacity

---

## Expected Auto-Mapping Behavior

### Sender Clients:
| Payment Terms | Auto-Selected Method |
|--------------|---------------------|
| Prepaid | Direct Billing |
| Postpaid | Direct Billing |
| COD | COD Collection |

### Delivery Partners:
| Payment Terms | Auto-Selected Method |
|--------------|---------------------|
| Prepaid | Direct Payment |
| Postpaid | Direct Payment |
| Commission-Based | Commission Deduction |

### Override for Internal:
| Partner Relationship | Forced Method |
|---------------------|---------------|
| Internal | Internal Transfer (always) |

---

## Common Issues to Check

### Issue 1: Auto-mapping not working
- **Cause**: `wire:model.live` not present
- **Fix**: Already fixed - all dropdowns use `wire:model.live`

### Issue 2: Checkboxes not auto-disabling
- **Cause**: Not using `wire:model.live` on checkboxes
- **Fix**: Already fixed - checkboxes use `wire:model.live`

### Issue 3: Dropdown not locking for internal
- **Cause**: Missing `@if($partner_relationship_type === 'internal') disabled @endif`
- **Fix**: Already fixed - conditional disabled attribute added

### Issue 4: Visual feedback not showing
- **Cause**: Livewire not re-rendering
- **Fix**: Using `wire:model.live` ensures real-time updates

---

## Success Criteria

All tests should pass with:
- ✅ Instant UI updates (no page refresh needed)
- ✅ Clear visual feedback (disabled states, warnings)
- ✅ Validation prevents invalid combinations
- ✅ Auto-mapping works immediately on dropdown change
- ✅ Internal partners always locked to proper settings

If any test fails, check browser console for JavaScript errors and verify Livewire is working correctly.
