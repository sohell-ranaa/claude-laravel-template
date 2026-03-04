# Routing Rules Guide - Mohammadpur Sorting Center

## Overview

The routing system has **11 rules** configured for **Mohammadpur Sorting Center (MDP-001)**. These rules demonstrate different routing scenarios based on area, postcode, and service type.

---

## How Routing Works

### Rule Priority System

Rules are evaluated in **priority order** (lower number = higher priority):
- **Priority 5:** Highest priority (processed first)
- **Priority 10-15:** High priority
- **Priority 20-30:** Medium priority
- **Priority 35+:** Lower priority

When a parcel arrives, the system:
1. Checks conditions starting from highest priority rule
2. If conditions match, applies that rule's action
3. If no match, moves to next priority rule
4. Continues until a rule matches or all rules checked

---

## Routing Rule Types

### 1. **Direct Delivery** 🚚
Parcel is delivered directly from this sorting center.
- Used for: Local areas, nearby locations
- Action: Assign to rider for delivery

### 2. **Hub Transfer** 🔄
Parcel is transferred to another major sorting center.
- Used for: Long-distance deliveries, major cities
- Action: Send to destination hub, then local delivery

### 3. **Sub-Center** 📦
Parcel is sent to a smaller distribution center.
- Used for: Medium-distance areas, suburban zones
- Action: Transfer to sub-center for final delivery

### 4. **Third Party** 🤝
Parcel is handed to external courier service.
- Used for: Remote areas, international shipments
- Action: Transfer to third-party provider

---

## Current Rules for Mohammadpur Center

### Priority 5 - Highest Priority

#### 1. Express Priority Delivery
- **Type:** Direct Delivery
- **Conditions:** Service Type = same_day
- **Action:** Deliver from Mohammadpur (Center ID: 1)
- **Use Case:** Same-day delivery requests get highest priority

#### 2. Gulshan Express Delivery ⭐ (NEW)
- **Type:** Direct Delivery
- **Conditions:**
  - Area = Gulshan
  - Postcodes = 1212, 1213
  - Service = express
- **Action:** Assign for delivery from Mohammadpur
- **Use Case:** Express deliveries to Gulshan area (high-value commercial zone)

---

### Priority 10 - High Priority

#### 3. Mohammadpur Local Delivery (Original)
- **Type:** Direct Delivery
- **Conditions:** Area = Mohammadpur
- **Action:** Deliver from Mohammadpur
- **Use Case:** Parcels within the same area as sorting center

#### 4. Mohammadpur Local Delivery ⭐ (NEW - Detailed)
- **Type:** Direct Delivery
- **Conditions:**
  - Area = Mohammadpur
  - Postcodes = 1207, 1208
- **Action:** Assign for delivery
- **Notes:** Local area - direct delivery
- **Use Case:** Specific Mohammadpur postcodes for precise routing

---

### Priority 15 - Medium-High Priority

#### 5. Heavy Parcel Special Handling
- **Type:** Sub-Center
- **Conditions:** (Special weight/size conditions)
- **Action:** Route to Center ID: 1
- **Use Case:** Oversized or heavy parcels requiring special handling

#### 6. Dhanmondi Direct Delivery ⭐ (NEW)
- **Type:** Direct Delivery
- **Conditions:**
  - Area = Dhanmondi
  - Postcodes = 1205, 1209
- **Action:** Assign for delivery from Mohammadpur
- **Notes:** Nearby area - direct delivery from Mohammadpur
- **Use Case:** Dhanmondi is adjacent to Mohammadpur, cost-effective to deliver directly

---

### Priority 20 - Medium Priority

#### 7. Dhanmondi-Green Road Route
- **Type:** Direct Delivery
- **Conditions:** Area = Central Dhaka
- **Action:** Deliver from Mohammadpur
- **Use Case:** Central Dhaka areas accessible from Mohammadpur

#### 8. Transfer to Uttara Hub ⭐ (NEW)
- **Type:** Hub Transfer
- **Conditions:**
  - Area = Uttara
  - Postcodes = 1230, 1231
- **Action:** Transfer to Uttara Sorting Center (ID: 2)
- **Notes:** Long distance - transfer to Uttara hub for local delivery
- **Use Case:** Uttara is far from Mohammadpur. More efficient to transfer to Uttara center for local delivery there.

---

### Priority 25 - Lower Priority

#### 9. Mirpur Sub-Center Routing ⭐ (NEW)
- **Type:** Sub-Center
- **Conditions:**
  - Area = Mirpur
  - Postcodes = 1216, 1212
- **Action:** Transfer to Mirpur Sorting Center (ID: 3)
- **Notes:** Medium distance - transfer to Mirpur sub-center
- **Use Case:** Mirpur is moderately far. Transfer to Mirpur center which has local knowledge and riders for that area.

---

### Priority 30 - Lower Priority

#### 10. Mirpur Area Transfer
- **Type:** Hub Transfer
- **Conditions:** Area = Mirpur (general)
- **Action:** Transfer to Mirpur Center (ID: 3)
- **Use Case:** Catch-all for any Mirpur parcels not caught by more specific rules

---

### Priority 35 - Lowest Priority

#### 11. North Dhaka Transfer
- **Type:** Hub Transfer
- **Conditions:** Area = North Dhaka
- **Action:** Transfer to Uttara Center (ID: 2)
- **Use Case:** General North Dhaka areas route through Uttara

---

## Example Routing Scenarios

### Scenario 1: Parcel to Mohammadpur 1207
```
1. ❌ Priority 5 - Express Priority Delivery (no match - not same_day service)
2. ❌ Priority 5 - Gulshan Express (no match - area is not Gulshan)
3. ❌ Priority 10 - Mohammadpur Local (no match - no postcode specified)
4. ✅ Priority 10 - Mohammadpur Local Delivery (MATCH!)
   → Action: Assign for delivery from Mohammadpur center
```

### Scenario 2: Express Parcel to Gulshan 1212
```
1. ❌ Priority 5 - Express Priority Delivery (no match - not same_day)
2. ✅ Priority 5 - Gulshan Express Delivery (MATCH!)
   → Action: Assign for delivery with HIGH PRIORITY
```

### Scenario 3: Regular Parcel to Uttara 1230
```
1. ❌ Priority 5 rules (no match)
2. ❌ Priority 10 rules (no match - not Mohammadpur)
3. ❌ Priority 15 rules (no match)
4. ✅ Priority 20 - Transfer to Uttara Hub (MATCH!)
   → Action: Transfer to Uttara Sorting Center (ID: 2)
   → Uttara center then handles local delivery
```

### Scenario 4: Parcel to Mirpur 1216
```
1-4. ❌ Higher priority rules (no match)
5. ✅ Priority 25 - Mirpur Sub-Center Routing (MATCH!)
   → Action: Transfer to Mirpur Sorting Center (ID: 3)
   → Mirpur center then handles local delivery
```

---

## Rule Benefits

### 1. **Cost Optimization**
- Local deliveries (Mohammadpur, Dhanmondi) = Direct delivery = Lower cost
- Long distance (Uttara, Mirpur) = Transfer = Shared transport cost

### 2. **Delivery Speed**
- High priority for express and same-day services
- Local deliveries processed faster
- Hub transfers ensure local expertise at destination

### 3. **Scalability**
- Easy to add new areas by creating new rules
- Priority system allows fine-tuning
- Can activate/deactivate rules without deletion

### 4. **Flexibility**
- Conditions can include area, postcode, service type, weight, etc.
- Actions can route to different centers based on need
- Rules can have date ranges (effective_from/to)

---

## Testing the Rules

### Via Routing Page:

1. **Navigate to:** `http://172.16.0.89:8000/routing`
2. **Go to "Rules" tab**
3. **Filter by:** Mohammadpur Sorting Center
4. **You should see:** All 11 rules listed with priority order

### Via Bulk Routing Tab:

1. **Create test parcels** with different addresses:
   - Mohammadpur 1207
   - Gulshan 1212 (with express service)
   - Uttara 1230
   - Mirpur 1216
   - Dhanmondi 1205

2. **Go to "Bulk Routing" tab**
3. **Select parcels** and click "Calculate Routes"
4. **See results:** System will show which center each parcel should route to

### Via API (for testing):

```bash
curl -X POST http://172.16.0.89:8000/ajax/routing/calculate \
  -H "Content-Type: application/json" \
  -d '{
    "recipient_address": "House 10, Road 5, Mohammadpur, Dhaka 1207",
    "sorting_center_id": 1
  }'
```

---

## Adding New Rules

### Example: Add rule for Banani area

1. **Go to routing page** → Click "Create Rule"
2. **Fill in:**
   - Rule Name: "Banani Direct Delivery"
   - Sorting Center: Mohammadpur
   - Rule Type: Direct Delivery
   - Priority: 15
   - Conditions: `{"area": "Banani", "postcode": ["1213", "1214"]}`
   - Action Config: `{"action": "assign_for_delivery", "delivery_center_id": 1}`
3. **Save**

---

## Rule Management Best Practices

### Priority Guidelines:
- **1-10:** Emergency, express, high-priority services
- **11-20:** Local area direct deliveries
- **21-30:** Medium-distance transfers
- **31-50:** Long-distance hub transfers
- **51+:** Catch-all and backup rules

### Condition Design:
- **Be specific:** More specific rules get higher priority
- **Use postcodes:** More accurate than just area names
- **Combine conditions:** Area + Postcode + Service Type = Most precise

### Action Configuration:
- **Direct delivery:** Same sorting center ID as delivery center
- **Hub transfer:** Different destination_center_id and delivery_center_id
- **Sub-center:** Typically closer centers for intermediate routing

---

## Troubleshooting

### Issue: Parcel not routing correctly

**Check:**
1. Is there a matching rule?
2. Is the rule active?
3. Are conditions matching parcel data?
4. Is a higher-priority rule catching it first?

**Solution:**
- Review rule priorities
- Check condition JSON format
- Test with bulk routing calculator

### Issue: Multiple rules matching

**Answer:** This is normal! The system uses the **first matching rule** (highest priority).

**Example:**
- Rule A (Priority 10): Area = "Mohammadpur"
- Rule B (Priority 20): Area = "Mohammadpur", Postcode = "1207"

A parcel to Mohammadpur 1207 will match Rule A first (lower priority number = higher priority).

---

## Next Steps

1. ✅ Test the routing page to see all 11 rules
2. ✅ Try creating a new rule via the UI
3. ✅ Test bulk routing with sample parcels
4. ✅ Review analytics tab for routing statistics
5. ✅ Add more centers and create inter-center routing rules

---

**Created:** March 2, 2026
**Mohammadpur Sorting Center Rules:** 11 active
**Status:** ✅ Ready for production use
