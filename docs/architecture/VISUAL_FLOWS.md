# DigiBox Logistics - Visual Business Flows
## Simple Flow Diagrams for Stakeholders

---

## 1. COMPLETE PARCEL JOURNEY (End-to-End)

```
┌─────────────────────────────────────────────────────────────────────┐
│                         CUSTOMER JOURNEY                            │
└─────────────────────────────────────────────────────────────────────┘

[Customer]
    │
    │ Orders product from online store
    ↓
[DigiBox Kiosk Store]
    │
    │ Packs item, creates parcel
    │ Generates QR code
    ↓
[DBK Rider Pickup]
    │
    │ Collects parcels from DBK store
    │ Delivers to Sorting Center
    ↓
┌────────────────────────────────────┐
│   MOHAMMADPUR SORTING CENTER       │
│   (Layer 1 - Primary Hub)          │
├────────────────────────────────────┤
│  1. Scan QR → Receive              │
│  2. AI Routing → Uttara            │
│  3. Print Label                    │
│  4. Sort into Uttara bin           │
│  5. Create manifest                │
└────────────────────────────────────┘
    │
    │ Hub Transfer Rider
    │ (40 parcels to Uttara)
    ↓
┌────────────────────────────────────┐
│   UTTARA SORTING CENTER            │
│   (Layer 2 - Delivery Hub)         │
├────────────────────────────────────┤
│  1. Scan manifest → Receive        │
│  2. Re-sort by delivery zones      │
│  3. Assign to delivery rider       │
│  4. Create delivery manifest       │
└────────────────────────────────────┘
    │
    │ Delivery Rider
    │ (30 parcels, optimized route)
    ↓
[Customer Location - House 23, Sector 10, Uttara]
    │
    │ ✓ Parcel delivered
    │ ✓ COD collected: ৳500
    │ ✓ Photo taken
    │ ✓ Signature captured
    ↓
[Rider Returns to Uttara SC]
    │
    │ Deposits COD cash
    ↓
[Accountant Settlement]
    │
    │ Verifies & reconciles
    │ Processes rider commission
    ↓
[Client Payout - Weekly]
    │
    │ DigiBox Kiosk receives payment
    │ (COD - fees)
    ↓
[COMPLETE] ✅

Timeline: 24-48 hours from pickup to delivery
```

---

## 2. THREE ROUTING SCENARIOS

### Scenario A: Direct Delivery (Fastest)

```
┌───────────────┐
│ Mohammadpur   │
│ Sorting Center│
└───────┬───────┘
        │
        │ Distance: 3 km
        │ Time: Same day
        │
        ↓
    🏠 Customer
    (Mohammadpur area)

✓ No intermediate centers
✓ Same-day delivery
✓ Lowest cost
```

### Scenario B: Hub Transfer (Most Common)

```
┌───────────────┐
│ Mohammadpur   │
│ Sorting Center│
└───────┬───────┘
        │
        │ 12 km
        │ Hub rider
        │
        ↓
┌───────────────┐
│ Uttara        │
│ Sorting Center│
└───────┬───────┘
        │
        │ 2 km
        │ Delivery rider
        │
        ↓
    🏠 Customer
    (Uttara area)

✓ Two-center routing
✓ Next-day delivery
✓ Optimized for zones
```

### Scenario C: Third-Party Handover

```
┌───────────────┐
│ Dhaka         │
│ Sorting Center│
└───────┬───────┘
        │
        │ Handover
        │
        ↓
┌───────────────┐
│ Sundarban     │
│ Courier       │
└───────┬───────┘
        │
        │ 250 km
        │ Long haul
        │
        ↓
    🏠 Customer
    (Chittagong)

✓ Partner logistics
✓ 2-3 day delivery
✓ Extended coverage
```

---

## 3. DAILY OPERATIONS TIMELINE

```
TIME        MOHAMMADPUR SC              UTTARA SC               RIDERS
────────────────────────────────────────────────────────────────────────

8:00 AM     ┌─────────────┐
            │ Center Opens│
            │ Staff Login │
            └─────────────┘

8:30 AM     ┌─────────────┐
            │First Parcels│             ┌─────────────┐
            │ Arrive (DBK)│             │ Center Opens│
            │Scan & Receive             └─────────────┘
            └─────────────┘

9:00 AM     ┌─────────────┐
            │Sort Session 1                           ┌──────────┐
            │ 50 parcels  │                           │Check In  │
            │Route to:    │                           │Get Tasks │
            │• Uttara: 20 │                           └──────────┘
            │• Mirpur: 15 │
            │• Direct: 15 │
            └─────────────┘

10:00 AM    ┌─────────────┐             ┌─────────────┐
            │Hub Transfer │             │Receive from │
            │Dispatch to  │────────────→│Mohammadpur  │
            │Uttara (20)  │             │Scan & Verify│
            └─────────────┘             └─────────────┘

11:00 AM    ┌─────────────┐             ┌─────────────┐
            │Direct       │             │Re-sort for  │
            │Deliveries   │             │ Delivery    │
            │Load riders  │             │Assign riders│
            └─────────────┘             └─────────────┘

12:00 PM    ┌─────────────┐                            ┌──────────┐
            │Second Batch │                            │Deliveries│
            │ 70 parcels  │                            │In        │
            │Receive-Sort │                            │Progress  │
            └─────────────┘                            └──────────┘

2:00 PM     ┌─────────────┐             ┌─────────────┐
            │Afternoon    │             │Monitor      │
            │Operations   │             │Riders       │
            │Ongoing      │             │Track Issues │
            └─────────────┘             └─────────────┘

5:00 PM                                                ┌──────────┐
                                                       │Riders    │
                                                       │Return    │
                                                       │Deposit   │
                                                       │COD       │
                                                       └──────────┘

6:00 PM     ┌─────────────┐             ┌─────────────┐
            │COD          │             │COD          │
            │Settlement   │             │Settlement   │
            │Daily Report │             │Daily Report │
            └─────────────┘             └─────────────┘

10:00 PM    ┌─────────────┐             ┌─────────────┐
            │Center Closes│             │Center Closes│
            └─────────────┘             └─────────────┘
```

---

## 4. COD (CASH ON DELIVERY) FLOW

```
┌──────────────────────────────────────────────────────────────┐
│                      COD JOURNEY                             │
└──────────────────────────────────────────────────────────────┘

[Customer Orders Product - ৳500 COD]
    │
    ↓
[DigiBox Kiosk packs & ships]
    │
    ↓
[Parcel travels through sorting centers]
    │
    ↓
┌─────────────────────────────────┐
│  DELIVERY MOMENT                │
│  • Rider delivers parcel        │
│  • Customer inspects            │
│  • Customer pays ৳500 cash      │
│  • Rider records in app         │
│  • Customer signs               │
└─────────────────────────────────┘
    │
    │ Rider continues route
    │ Collects multiple CODs
    ↓
┌─────────────────────────────────┐
│  RIDER RETURNS - END OF DAY     │
│  Total collected: ৳12,500       │
│  (25 deliveries × avg ৳500)     │
└─────────────────────────────────┘
    │
    ↓
┌─────────────────────────────────┐
│  ACCOUNTANT VERIFICATION        │
│  • Counts cash: ৳12,500 ✓       │
│  • Matches app records ✓        │
│  • Records in system            │
└─────────────────────────────────┘
    │
    ↓
┌─────────────────────────────────┐
│  RIDER SETTLEMENT               │
│  COD Collected:    ৳12,500      │
│  Rider Commission:  ৳1,250 (10%)│
│  To Company:       ৳11,250      │
└─────────────────────────────────┘
    │
    ↓ (Weekly)
┌─────────────────────────────────┐
│  CLIENT PAYOUT (DBK)            │
│  Week's COD:       ৳50,000      │
│  Delivery Fee:     -৳5,000      │
│  Other Charges:      -৳250      │
│  ────────────────────────────   │
│  Net Payout:       ৳44,750      │
│  (Bank Transfer)                │
└─────────────────────────────────┘
    │
    ↓
[DigiBox Kiosk receives payment]
    │
    ↓
[DBK pays their supplier/merchant]

💰 COD CYCLE COMPLETE
```

---

## 5. MULTI-LAYER SORTING DECISION TREE

```
                        [PARCEL RECEIVED]
                               │
                               ↓
                    ┌──────────────────┐
                    │  AI ANALYZES     │
                    │  DESTINATION     │
                    └──────────────────┘
                               │
                ┌──────────────┼──────────────┐
                ↓                             ↓
        ┌─────────────┐               ┌─────────────┐
        │ Within 5km? │               │ Far Away?   │
        └─────────────┘               └─────────────┘
                │                             │
               YES                           YES
                │                             │
                ↓                             ↓
        ┌─────────────┐               ┌─────────────┐
        │   DIRECT    │               │  Check Sub- │
        │  DELIVERY   │               │   Centers   │
        └─────────────┘               └─────────────┘
                │                             │
                ↓                      ┌──────┴──────┐
        [Assign local               SUB-CENTER    NO SUB-CENTER
         delivery rider]            EXISTS?       EXISTS?
                                       │              │
                                      YES            YES
                                       │              │
                                       ↓              ↓
                               ┌─────────────┐  ┌─────────────┐
                               │  TRANSFER   │  │ CHECK 3RD   │
                               │  TO SUB-SC  │  │  PARTY      │
                               └─────────────┘  └─────────────┘
                                       │              │
                                       ↓              ↓
                               [Create hub     [Use Sundarban/
                                transfer        Pathao/etc.]
                                manifest]

EXAMPLES:

Uttara (15 km) → Transfer to Uttara SC → Deliver
Mohammadpur (2 km) → Direct delivery
Chittagong (250 km) → Sundarban Courier
Sylhet (300 km) → SA Paribahan
```

---

## 6. SORTING CENTER CAPACITY MANAGEMENT

```
┌─────────────────────────────────────────────────────────────┐
│            MOHAMMADPUR SORTING CENTER                       │
│            Daily Capacity: 1,000 parcels                    │
└─────────────────────────────────────────────────────────────┘

8 AM        10 AM       12 PM       2 PM        4 PM       6 PM
│           │           │           │           │          │
├───────────┼───────────┼───────────┼───────────┼──────────┤
│ ███       │ ██████    │ █████████ │ ███████   │ ████     │
│ 150       │ 300       │ 450       │ 350       │ 200      │
└───────────┴───────────┴───────────┴───────────┴──────────┘

Total received: 450 parcels (45% capacity) ✓ Normal
Peak time: 12 PM (225 parcels in system)

CAPACITY ZONES:
Green (0-60%):   Normal operations ✓
Yellow (60-80%): Busy, monitor closely ⚠
Red (80-100%):   Near capacity, alert management ⚠️
Critical (>100%): Overflow, redirect incoming ❌

ACTIONS WHEN NEAR CAPACITY:
1. Expedite sorting
2. Add extra staff
3. Extend operating hours
4. Redirect new parcels to nearby centers
5. Alert management
```

---

## 7. RIDER ASSIGNMENT & OPTIMIZATION

```
┌─────────────────────────────────────────────────────────────┐
│              SMART RIDER ASSIGNMENT                         │
└─────────────────────────────────────────────────────────────┘

                    [50 Parcels Ready]
                           │
                           ↓
              ┌────────────────────────┐
              │   SYSTEM ANALYZES:     │
              │  • Destination zones   │
              │  • Delivery addresses  │
              │  • Rider availability  │
              └────────────────────────┘
                           │
                           ↓
        ┌──────────────────┼──────────────────┐
        ↓                  ↓                  ↓
   ┌────────┐         ┌────────┐        ┌────────┐
   │RIDER A │         │RIDER B │        │RIDER C │
   │Karim   │         │Rahim   │        │Salim   │
   ├────────┤         ├────────┤        ├────────┤
   │Zone:   │         │Zone:   │        │Zone:   │
   │Sector  │         │Sector  │        │Sector  │
   │1-6     │         │7-12    │        │13-18   │
   ├────────┤         ├────────┤        ├────────┤
   │Status: │         │Status: │        │Status: │
   │READY ✓ │         │READY ✓ │        │ON ROUTE│
   ├────────┤         ├────────┤        ├────────┤
   │Capacity│         │Capacity│        │Capacity│
   │15/50   │         │20/50   │        │45/50   │
   │parcels │         │parcels │        │parcels │
   └────────┘         └────────┘        └────────┘
        │                  │                  │
        ↓                  ↓                  ↓
   ┌────────┐         ┌────────┐        ┌────────┐
   │Assigned│         │Assigned│        │ SKIP   │
   │  20    │         │  25    │        │(Busy)  │
   │parcels │         │parcels │        │        │
   └────────┘         └────────┘        └────────┘

Remaining 5 parcels → Queued for next available rider

OPTIMIZATION FACTORS:
✓ Zone matching (highest priority)
✓ Current location (closest first)
✓ Capacity available
✓ Performance rating
✓ Vehicle type (for heavy items)
```

---

## 8. EXCEPTION HANDLING FLOWS

### Exception 1: Invalid Parcel

```
[Operator Scans Parcel]
        │
        ↓
   ┌────────┐
   │ ERROR! │
   │ Invalid│
   │Tracking│
   └────────┘
        │
        ↓
[Operator Actions]
        │
        ├─→ Check QR code damaged?
        │       └→ Re-print from DBK
        │
        ├─→ Wrong tracking number?
        │       └→ Contact DBK
        │
        └─→ System issue?
                └→ Manual entry + flag for IT
```

### Exception 2: Customer Unavailable

```
[Rider Attempts Delivery]
        │
        ↓
   ┌────────┐
   │Customer│
   │Not Home│
   └────────┘
        │
        ├─→ Call customer
        │       │
        │       ├─→ Answers: Reschedule
        │       └─→ No answer: Leave note
        │
        ↓
[Record in App]
        │
        ├─→ Attempt 1: Will retry tomorrow
        ├─→ Attempt 2: Customer to collect
        └─→ Attempt 3: Return to sender
```

### Exception 3: COD Mismatch

```
[Rider Returns with COD]
        │
        ↓
[Accountant Counts Cash]
        │
        ↓
   ┌────────┐
   │MISMATCH│
   │Expected│
   │৳5,000  │
   │Actual  │
   │৳4,800  │
   └────────┘
        │
        ↓
[Reconciliation Process]
        │
        ├─→ Review each delivery in app
        ├─→ Check customer gave correct amount
        ├─→ Verify rider recorded correctly
        └─→ Find discrepancy source
        │
        ↓
   ┌────────┐
   │ FOUND! │
   │1 parcel│
   │recorded│
   │wrongly │
   └────────┘
        │
        ↓
[Correction]
        │
        ├─→ Adjust records
        ├─→ Settlement processed
        └─→ Note for training
```

---

## 9. SYSTEM INTEGRATION MAP

```
┌─────────────────────────────────────────────────────────────┐
│               SYSTEM INTEGRATION OVERVIEW                   │
└─────────────────────────────────────────────────────────────┘

External Systems                DigiBox Logistics SC
────────────────                ────────────────────

┌──────────────┐                ┌──────────────┐
│  DigiBox     │◄──────────────►│  Integration │
│  Kiosk (DBK) │   Webhooks     │     Hub      │
│              │   REST API     │              │
└──────────────┘                └──────────────┘
                                       │
┌──────────────┐                       │
│  Sundarban   │◄──────────────────────┤
│  Courier     │   API Integration     │
└──────────────┘                       │
                                       │
┌──────────────┐                       │
│  Pathao      │◄──────────────────────┤
│  Courier     │   API Integration     │
└──────────────┘                       │
                                       │
┌──────────────┐                       │
│  bKash /     │◄──────────────────────┤
│  Nagad       │   Payment Gateway     │
└──────────────┘                       │
                                       │
┌──────────────┐                       │
│  Google Maps │◄──────────────────────┤
│  Barikoi API │   Geocoding           │
└──────────────┘                       │
                                       │
┌──────────────┐                       │
│  SMS Gateway │◄──────────────────────┤
│  (Bulk SMS)  │   Notifications       │
└──────────────┘                       │
                                       ↓
                                ┌──────────────┐
                                │    Core      │
                                │   Services   │
                                └──────────────┘
```

---

## 10. USER ROLES & PERMISSIONS MATRIX

```
┌──────────────────────────────────────────────────────────────┐
│                   PERMISSION MATRIX                          │
└──────────────────────────────────────────────────────────────┘

FEATURE                 Super  Center  Sorting  Rider  Accountant
                        Admin  Manager Operator
────────────────────────────────────────────────────────────────
Create Sorting Center    ✓      ✗       ✗       ✗        ✗
Manage Users            ✓      ✓       ✗       ✗        ✗
Receive Parcels         ✓      ✓       ✓       ✗        ✗
Sort Parcels            ✓      ✓       ✓       ✗        ✗
Assign Riders           ✓      ✓       ✗       ✗        ✗
Deliver Parcels         ✗      ✗       ✗       ✓        ✗
Collect COD             ✗      ✗       ✗       ✓        ✗
Verify COD              ✓      ✓       ✗       ✗        ✓
Process Settlements     ✓      ✗       ✗       ✗        ✓
View All Reports        ✓      ✗       ✗       ✗        ✗
View Center Reports     ✓      ✓       ✗       ✗        ✓
View Own Performance    ✗      ✗       ✗       ✓        ✗
Configure Routing       ✓      ✓       ✗       ✗        ✗
Manage Integrations     ✓      ✗       ✗       ✗        ✗
Financial Reports       ✓      ✗       ✗       ✗        ✓
```

---

## 11. REPORTING HIERARCHY

```
                    ┌────────────────┐
                    │  Super Admin   │
                    │  (HQ)          │
                    └────────────────┘
                            │
                            │ Views all centers
                            │
        ┌───────────────────┼───────────────────┐
        ↓                   ↓                   ↓
┌───────────────┐   ┌───────────────┐   ┌───────────────┐
│ Mohammadpur   │   │    Uttara     │   │    Mirpur     │
│ SC Manager    │   │  SC Manager   │   │  SC Manager   │
└───────────────┘   └───────────────┘   └───────────────┘
        │                   │                   │
        │                   │                   │
    ┌───┴───┐           ┌───┴───┐           ┌───┴───┐
    ↓       ↓           ↓       ↓           ↓       ↓
┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐
│Sorting│ │Riders │ │Sorting│ │Riders │ │Sorting│ │Riders │
│Ops    │ │       │ │Ops    │ │       │ │Ops    │ │       │
└───────┘ └───────┘ └───────┘ └───────┘ └───────┘ └───────┘
   (5)      (10)       (5)      (10)       (5)      (10)

REPORTING FLOW:
Daily  → Operators report to Center Manager
Daily  → Riders report to Center Manager
Weekly → Center Managers report to Super Admin
Monthly→ Super Admin consolidates all reports
```

---

## 12. GROWTH & SCALING PLAN

```
┌──────────────────────────────────────────────────────────────┐
│                    EXPANSION TIMELINE                        │
└──────────────────────────────────────────────────────────────┘

MONTH 1-3: PILOT PHASE
┌─────────────────┐
│  Mohammadpur SC │  (Single center)
└─────────────────┘
   500 parcels/day
   5 operators, 10 riders

MONTH 4-6: DHAKA EXPANSION
┌─────────────────┐   ┌─────────────────┐   ┌─────────────────┐
│  Mohammadpur SC │   │    Uttara SC    │   │    Mirpur SC    │
└─────────────────┘   └─────────────────┘   └─────────────────┘
   1,000/day            800/day               600/day
   Total: 2,400 parcels/day

MONTH 7-12: NATIONAL NETWORK
┌─────────────────────────────────────────────────────────────┐
│                        DHAKA                                │
│  • Mohammadpur  • Uttara  • Mirpur  • Dhanmondi  • Gulshan │
└─────────────────────────────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        ↓                   ↓                   ↓
┌───────────────┐   ┌───────────────┐   ┌───────────────┐
│  CHITTAGONG   │   │    SYLHET     │   │  KHULNA       │
│  (Secondary)  │   │  (Secondary)  │   │  (Secondary)  │
└───────────────┘   └───────────────┘   └───────────────┘

Total: 10,000 parcels/day nationwide

YEAR 2: FULL COVERAGE
• 20+ sorting centers
• 200+ delivery hubs
• 50,000 parcels/day
• All major cities covered
• 1,000+ employees
```

---

## Summary

These visual flows provide a clear, non-technical understanding of:

1. **How parcels move** through the system
2. **Who does what** at each stage
3. **When things happen** in the daily operations
4. **What decisions** are made automatically
5. **How money flows** in COD scenarios
6. **What happens** when problems occur
7. **How systems integrate** with external partners
8. **How the business scales** over time

Perfect for presentations to:
- Management teams
- Investors
- Operations staff
- Training sessions
- Client onboarding

---

**Document Version:** 1.0
**Last Updated:** March 2026