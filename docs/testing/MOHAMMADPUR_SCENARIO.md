# Mohammadpur Sorting Center - Complete Test Scenario

## Overview
This document provides a complete operational scenario for the Mohammadpur Sorting Center, including routing rules, riders, and sample parcels for testing the sorting center management system.

---

## 1. Sorting Center Details

**Mohammadpur Sorting Center (ID: 1)**
- **Code**: MDP-SC-001
- **Type**: Primary Sorting Center
- **Status**: Active
- **Address**: Mohammadpur, Dhaka-1207
- **Manager**: Nazia Islam (nazia@digibox.com)
- **Daily Capacity**: 500 parcels/day

---

## 2. Routing Rules Configuration

The Mohammadpur center has **6 routing rules** configured to handle different delivery scenarios. Rules are prioritized by the `priority` field (lower number = higher priority).

### Rule 1: Mohammadpur Local Delivery
- **Type**: `direct_delivery`
- **Priority**: 10
- **Coverage**: Mohammadpur, Shyamoli, Adabor
- **Postcodes**: 1207, 1205, 1206
- **Action**: Direct delivery from Mohammadpur center
- **Estimated Delivery**: 4 hours
- **Use Case**: Fast local delivery within the center's immediate coverage area

### Rule 2: Dhanmondi-Green Road Route
- **Type**: `direct_delivery`
- **Priority**: 20
- **Coverage**: Dhanmondi, Green Road, Kalabagan
- **Postcodes**: 1209, 1205, 1215
- **Action**: Direct delivery from Mohammadpur center
- **Estimated Delivery**: 6 hours
- **Use Case**: Nearby areas that can be served directly without hub transfer

### Rule 3: Mirpur Area Transfer
- **Type**: `hub_transfer`
- **Priority**: 30
- **Coverage**: Mirpur, Pallabi, Kazipara
- **Postcodes**: 1216
- **Action**: Transfer to Mirpur hub for delivery
- **Estimated Delivery**: 12 hours
- **Use Case**: Areas requiring hub transfer for efficient routing

### Rule 4: North Dhaka Transfer
- **Type**: `hub_transfer`
- **Priority**: 35
- **Coverage**: Uttara, Tongi, Banani
- **Postcodes**: 1230, 1229, 1213
- **Action**: Transfer to Uttara hub for delivery
- **Estimated Delivery**: 12 hours
- **Use Case**: Long-distance transfers to northern Dhaka areas

### Rule 5: Heavy Parcel Special Handling
- **Type**: `sub_center`
- **Priority**: 15
- **Condition**: Weight > 25kg
- **Action**: Route to sub-center with heavy parcel handling capacity
- **Estimated Delivery**: 24 hours
- **Use Case**: Furniture, appliances, and other heavy items requiring special handling

### Rule 6: Express Priority Delivery
- **Type**: `direct_delivery`
- **Priority**: 5 (HIGHEST)
- **Condition**: Client reference contains "EXPRESS"
- **Coverage**: All areas within 10km radius
- **Action**: Immediate priority routing for express delivery
- **Estimated Delivery**: 2 hours
- **Use Case**: Urgent documents, medical supplies, time-sensitive deliveries

---

## 3. Riders Configuration

The Mohammadpur center has **5 active riders** with different vehicle types and capacities:

### Rider 1: Abdul Karim (MDP-R001)
- **Vehicle**: Motorcycle (Dhaka Metro-Ka-11-2345)
- **Status**: On Duty
- **Capacity**: 15 parcels/trip, 30kg max
- **Best For**: Light parcels, local deliveries

### Rider 2: Abdur Rahim (MDP-R002)
- **Vehicle**: Motorcycle (Dhaka Metro-Ka-11-2346)
- **Status**: On Duty
- **Capacity**: 15 parcels/trip, 30kg max
- **Best For**: Light parcels, local deliveries

### Rider 3: Jalal Uddin (MDP-R003)
- **Vehicle**: Van (Dhaka Metro-Ga-14-5678)
- **Status**: On Duty
- **Capacity**: 40 parcels/trip, 150kg max
- **Best For**: Medium to heavy parcels, bulk deliveries

### Rider 4: Mohammad Hasan (MDP-R004)
- **Vehicle**: Van (Dhaka Metro-Ga-14-5679)
- **Status**: Active (Available for assignment)
- **Capacity**: 40 parcels/trip, 150kg max
- **Best For**: Medium to heavy parcels, bulk deliveries

### Rider 5: Sumon Ahmed (MDP-R005)
- **Vehicle**: Motorcycle Express (Dhaka Metro-Ka-11-2347)
- **Status**: On Duty
- **Capacity**: 10 parcels/trip, 20kg max
- **Best For**: Express deliveries, urgent documents

---

## 4. Sample Parcels Dataset

The system contains **21 total parcels** for Mohammadpur Sorting Center, with **14 newly created** for this scenario.

### Parcel Distribution by Type:

#### Mohammadpur Local Delivery (3 parcels)
1. **MDP20260302XXXX** - Fatema Akter, Mohammadpur
   - Weight: 2.5kg | COD: BDT 1,500 | Status: Received

2. **MDP20260302XXXX** - Rahim Mia, Shyamoli Square
   - Weight: 1.8kg | Prepaid | Status: Received

3. **MDP20260302XXXX** - Nasrin Begum, Adabor
   - Weight: 3.2kg | COD: BDT 2,500 | Status: Sorted

#### Dhanmondi-Green Road Route (2 parcels)
4. **MDP20260302XXXX** - Salma Khatun, Dhanmondi Road 12
   - Weight: 1.5kg | COD: BDT 850 | Status: Received

5. **MDP20260302XXXX** - Jahangir Alam, Green Road Panthapath
   - Weight: 4.2kg | COD: BDT 3,200 | Status: Received

#### Mirpur Area Transfer (2 parcels)
6. **MDP20260302XXXX** - Mizanur Rahman, Mirpur Section 10
   - Weight: 5.8kg | COD: BDT 4,500 | Status: Received

7. **MDP20260302XXXX** - Shafiq Ahmed, Pallabi Mirpur-12
   - Weight: 2.3kg | Prepaid | Status: Sorted

#### North Dhaka Transfer (2 parcels)
8. **MDP20260302XXXX** - Kamrul Islam, Uttara Sector 7
   - Weight: 0.8kg | COD: BDT 12,500 | Status: Received

9. **MDP20260302XXXX** - Taslima Akter, Banani Block E
   - Weight: 1.2kg | COD: BDT 1,800 | Status: Received

#### Heavy Parcels (2 parcels)
10. **MDP20260302XXXX** - Abdul Karim, Mohammadpur (Furniture)
    - Weight: 32.5kg | COD: BDT 8,500 | Status: Received

11. **MDP20260302XXXX** - Hafizur Rahman, Green Road (Appliance)
    - Weight: 28kg | Prepaid | Status: Received

#### Express Priority (3 parcels)
12. **MDP20260302XXXX** - Dr. Mahmud, Mohammadpur (Medical Supplies)
    - Ref: EXPRESS-001 | Weight: 1kg | Prepaid | Status: Received

13. **MDP20260302XXXX** - Advocate Hasan, Dhanmondi (Legal Documents)
    - Ref: EXPRESS-002 | Weight: 0.5kg | Prepaid | Status: Sorted

14. **MDP20260302XXXX** - Farhan Ahmed, Uttara (Courier Express)
    - Ref: EXPRESS-003 | Weight: 0.8kg | COD: BDT 500 | Status: Received

### Summary Statistics:
- **Total Parcels**: 21
- **Received**: 12 parcels
- **Sorted**: 4 parcels
- **Weight Distribution**:
  - Light (<5kg): 16 parcels
  - Medium (5-25kg): 3 parcels
  - Heavy (>25kg): 2 parcels
- **Payment**:
  - COD: 14 parcels (Total: BDT 45,850.00)
  - Prepaid: 7 parcels

---

## 5. Testing Scenarios

### Scenario 1: Local Delivery Assignment
**Objective**: Test direct delivery for local area parcels

1. Login as manager (nazia@digibox.com)
2. Navigate to Parcels page
3. Select a parcel with Mohammadpur/Shyamoli/Adabor address
4. Use routing calculator to verify Rule 1 is applied
5. Assign to Rider: Abdul Karim or Abdur Rahim (motorcycle)
6. Update status to "Out for Delivery"
7. Verify delivery within 4-hour window

**Expected Result**: Parcel routed directly for same-day delivery

---

### Scenario 2: Hub Transfer for Distant Areas
**Objective**: Test hub transfer routing for Mirpur/Uttara areas

1. Select a parcel with Mirpur or Uttara address
2. Use routing calculator
3. Verify Rule 3 or Rule 4 is applied (hub_transfer)
4. System should suggest transfer to appropriate hub
5. Assign to van rider: Jalal Uddin or Mohammad Hasan
6. Update status to "In Transit" to hub

**Expected Result**: Parcel routed through hub for efficient delivery

---

### Scenario 3: Heavy Parcel Handling
**Objective**: Test special handling for heavy parcels

1. Select a parcel with weight > 25kg
2. Use routing calculator
3. Verify Rule 5 (Heavy Parcel) is applied with priority 15
4. System should route to sub-center with capacity
5. Assign to van rider with sufficient capacity
6. Verify special handling requirements

**Expected Result**: Heavy parcel routed to appropriate facility

---

### Scenario 4: Express Priority Routing
**Objective**: Test highest priority routing for express parcels

1. Select parcel with client_reference containing "EXPRESS"
2. Use routing calculator
3. Verify Rule 6 is applied with priority 5 (highest)
4. System should recommend immediate dispatch
5. Assign to Express Rider: Sumon Ahmed (motorcycle express)
6. Update status to "Out for Delivery"
7. Target delivery within 2 hours

**Expected Result**: Express parcel gets highest priority

---

### Scenario 5: Batch Routing
**Objective**: Test batch routing for multiple parcels

1. Navigate to Routing page
2. Select multiple parcels from different areas
3. Use "Batch Calculate" feature
4. Review routing recommendations for all parcels
5. Apply routing to all parcels at once
6. Verify each parcel is routed according to its matching rule

**Expected Result**: Multiple parcels routed efficiently based on their destinations

---

### Scenario 6: COD Collection Management
**Objective**: Test COD collection workflow

1. Mark COD parcels as delivered
2. Navigate to COD Management page
3. Verify COD amounts are recorded for each rider
4. Create COD collection for the day
5. Total should match: BDT 45,850.00 for all 14 COD parcels
6. Update collection status

**Expected Result**: Accurate COD tracking and settlement

---

## 6. Manager vs Super Admin Access

### Center Manager (nazia@digibox.com) Can:
- View only Mohammadpur center data
- Manage routing rules for Mohammadpur center only
- View and assign riders from Mohammadpur
- View parcels originating from or destined to Mohammadpur
- Update their center's operational details (status, contact, capacity)
- Manage COD collections for their center
- View settlements for their center

### Center Manager CANNOT:
- View or manage other sorting centers
- Create new sorting centers
- Access user management
- View system-wide analytics
- Modify center name, code, or type

### Super Admin (admin@digibox.com) Can:
- View all sorting centers
- Create and manage all centers
- View system-wide analytics
- Access user management
- Manage roles and permissions
- View all parcels across all centers
- Configure routing rules for any center

---

## 7. Role-Based UI Differences

### Manager Dashboard:
```
Navigation Menu:
- Dashboard (Mohammadpur data only)
- Parcels (Mohammadpur parcels only)
- Riders (Mohammadpur riders only)
- COD Management (Mohammadpur COD only)
- Routing (Mohammadpur rules only)
- My Center (View/Edit Mohammadpur details)
- Settlements (Mohammadpur settlements only)
- Help
```

### Super Admin Dashboard:
```
Navigation Menu:
- Dashboard (All centers)
- Parcels (All centers)
- Riders (All centers)
- COD Management (All centers)
- Routing (All centers)
- Centers (Manage all centers)
- Settlements (All centers)
- User Management
- Help
```

---

## 8. API Endpoints for Testing

All endpoints use session-based authentication with `/ajax/` prefix.

### Calculate Route for Single Parcel
```http
POST /ajax/routing/calculate
Content-Type: application/json

{
  "parcel_id": 1,
  "apply_routing": false
}
```

### Calculate and Apply Routing
```http
POST /ajax/routing/calculate
Content-Type: application/json

{
  "parcel_id": 1,
  "apply_routing": true
}
```

### Batch Calculate Routes
```http
POST /ajax/routing/batch-calculate
Content-Type: application/json

{
  "parcel_ids": [1, 2, 3, 4, 5],
  "apply_routing": true
}
```

### Get Routing Rules for Center
```http
GET /ajax/routing/rules?sorting_center_id=1
```

### Create Routing Rule
```http
POST /ajax/routing/rules
Content-Type: application/json

{
  "sorting_center_id": 1,
  "rule_name": "Test Rule",
  "rule_type": "direct_delivery",
  "conditions": {
    "area": "Test Area",
    "postcodes": ["1200"]
  },
  "action_config": {
    "destination_center_id": 1,
    "delivery_center_id": 1,
    "route_type": "direct"
  },
  "priority": 50
}
```

---

## 9. Expected Routing Outcomes

Based on the configured rules, here's how each parcel type should be routed:

| Parcel Type | Matching Rule | Priority | Expected Action | ETA |
|-------------|---------------|----------|-----------------|-----|
| Mohammadpur Local | Rule 1 | 10 | Direct delivery | 4h |
| Dhanmondi/Green Road | Rule 2 | 20 | Direct delivery | 6h |
| Mirpur Area | Rule 3 | 30 | Hub transfer | 12h |
| North Dhaka | Rule 4 | 35 | Hub transfer | 12h |
| Heavy (>25kg) | Rule 5 | 15 | Sub-center | 24h |
| Express | Rule 6 | 5 | Priority direct | 2h |

**Priority Resolution**: When multiple rules match, the rule with the LOWEST priority number wins. For example, an express parcel to Mohammadpur would match both Rule 1 (priority 10) and Rule 6 (priority 5), but Rule 6 would be applied.

---

## 10. Next Steps for Implementation

### Immediate Priorities:
1. **Rider Management UI** - Create CRUD interface for managing riders
2. **Parcel Assignment** - Allow managers to assign parcels to riders
3. **Route Optimization** - Implement algorithms to suggest optimal rider assignments
4. **Real-time Tracking** - Add GPS tracking for riders and parcels

### Future Enhancements:
1. **Automated Routing** - Automatically route parcels based on rules when received
2. **Performance Analytics** - Track rider efficiency and delivery success rates
3. **Customer Notifications** - SMS/Email updates for parcel status changes
4. **Mobile App** - Android/iOS app for riders to update parcel status
5. **Label Printing** - Generate and print parcel labels with routing information

---

## 11. Testing Checklist

- [ ] Manager can only see Mohammadpur data
- [ ] Super admin can see all centers
- [ ] Routing rules are applied in correct priority order
- [ ] Heavy parcels trigger special handling rule
- [ ] Express parcels get highest priority
- [ ] Hub transfer rules work for distant areas
- [ ] Local delivery rules work for nearby areas
- [ ] COD amounts are tracked correctly
- [ ] Riders can be assigned to parcels
- [ ] Batch routing works for multiple parcels
- [ ] Manager can edit operational fields only
- [ ] Manager cannot create new centers
- [ ] API endpoints respect authorization
- [ ] Dashboard shows center-specific data

---

## Document Information
- **Created**: March 2, 2026
- **Scenario Name**: Mohammadpur Complete Test Scenario
- **Version**: 1.0
- **Status**: Complete and Ready for Testing
