# Sorting Center - Complete Process Flow Diagram

## Overall System Flow

```
┌─────────────┐
│ BRAC Bank   │ Collects parcels from merchants
│   Dhaka     │
└──────┬──────┘
       │ Daily bulk delivery
       ↓
┌─────────────────┐
│  Digibox Kiosk  │ Receives from bank
│   (Multiple     │ Sends pre-data via API
│   Locations)    │
└──────┬──────────┘
       │ API 1: Pre-Data
       ↓
┌────────────────────┐
│ SORTING CENTER     │ ← YOU ARE HERE
│ (Organize & Sort)  │
└──────┬─────────────┘
       │ Physical boxes + API 2: Sorted Data
       ↓
┌─────────────────┐
│  Digibox Kiosk  │ Receives sorted boxes
│   (Same/Other   │ Delivers to customers
│   Locations)    │
└──────┬──────────┘
       │ Direct delivery
       ↓
┌─────────────┐
│  Customer   │
└─────────────┘

       │ If rejected/return
       ↓ API 3: Return Request

┌────────────────────┐
│ SORTING CENTER     │ Rider picks up from kiosk
│ (Return Handling)  │
└────────────────────┘
```

---

## Detailed Sorting Center Workflow

### PHASE 1: Pre-Data Arrival (Morning)

```
┌──────────────────────────────────────┐
│         KIOSK SYSTEM                 │
│  (Has received parcels from bank)    │
└───────────────┬──────────────────────┘
                │
                │ 📡 API Call: POST /api/v1/sorting-centers/1/parcels/pre-data
                │ Sends: tracking#, customer info, address, lat/long, COD
                ↓
┌───────────────────────────────────────────────────────────┐
│  SORTING CENTER - Pre-Data Dashboard                      │
│                                                            │
│  📊 Statistics:                                            │
│  ┌────────┬────────┬────────┬───────────┐                │
│  │ Total  │ Rcvd   │ Sorted │ Dispatch  │                │
│  │  150   │  120   │   80   │    40     │                │
│  └────────┴────────┴────────┴───────────┘                │
│                                                            │
│  📋 Upcoming Parcels:                                      │
│  ┌──────────┬─────────────┬──────────────┬────────┐      │
│  │ Track#   │ Customer    │ Address      │ COD    │      │
│  ├──────────┼─────────────┼──────────────┼────────┤      │
│  │ TRK-001  │ Ahmed Khan  │ Mirpur-10    │ ৳500   │      │
│  │ TRK-002  │ Fatima Ali  │ Dhanmondi-15 │ ৳1,200 │      │
│  │ TRK-003  │ Karim Shah  │ Gulshan-2    │ ৳800   │      │
│  └──────────┴─────────────┴──────────────┴────────┘      │
│                                                            │
│  ℹ️  Info only - parcels not physically here yet           │
└───────────────────────────────────────────────────────────┘
```

**What Staff Do**: Review the list, note high-COD items, plan staffing

---

### PHASE 2: Physical Parcel Sorting (Main Activity)

```
Physical Parcels Arrive at Center
        ↓
┌───────────────────────────────────────────────────────────┐
│  SORTING CENTER - Scanning Interface                      │
│                                                            │
│  🔍 Scan QR Code                                           │
│  ┌────────────────────────────────────┐                   │
│  │ [TRK-001234_____________] [SCAN]   │                   │
│  └────────────────────────────────────┘                   │
│                                                            │
│         ↓ System looks up pre-data                        │
│         ↓ Calculates distance to all kiosks               │
│                                                            │
│  🤖 AI Routing Result:                                     │
│  ┌────────────────────────────────────────────────┐       │
│  │ ✅ RECOMMENDED: Mirpur Kiosk                   │       │
│  │    📍 Distance: 2.3 km                         │       │
│  │    🎯 Confidence: 95% (HIGH)                   │       │
│  │                                                 │       │
│  │ Alternative Options:                            │       │
│  │    Dhanmondi Kiosk (5.1 km, 49% confidence)    │       │
│  │    Uttara Kiosk (8.3 km, 17% confidence)       │       │
│  └────────────────────────────────────────────────┘       │
│                                                            │
│  📦 Select Box for Mirpur Kiosk:                           │
│  ┌─────────┬─────────┬─────────┬─────────┐               │
│  │ BOX-A1  │ BOX-A2  │ BOX-A3  │ BOX-A4  │               │
│  │ 🟢      │ 🟡      │ 🔴      │ 🔵      │               │
│  │ 25/100  │ 85/100  │ 100/100 │ SENT    │               │
│  │ Mirpur  │ Mirpur  │ Mirpur  │ Mirpur  │               │
│  └─────────┴─────────┴─────────┴─────────┘               │
│                                                            │
│  [📥 Assign to BOX-A1]                                     │
└───────────────────────────────────────────────────────────┘
        ↓
Parcel Assigned to Box A1
        ↓
Box Counter: 25 → 26
Status: Sorted
QR Data Generated (includes return_center_id)
```

**AI Routing Logic**:
```
1. Get customer lat/long from pre-data
2. For each kiosk:
   a. Calculate distance using Haversine formula
   b. Score = max(20, 100 - (distance_km × 10))
3. Recommend closest kiosk
4. Staff clicks box for that kiosk
```

**What Staff Do**:
1. Scan QR code
2. Review AI recommendation (usually green = trust it)
3. Click available box for that kiosk
4. Repeat for next parcel

---

### PHASE 3: Box Monitoring (Throughout Day)

```
┌───────────────────────────────────────────────────────────┐
│  SORTING CENTER - Box Management                          │
│                                                            │
│  📦 Visual Box Grid:                                       │
│                                                            │
│  Mirpur Kiosk Boxes:                                       │
│  ┌──────────────┬──────────────┬──────────────┐          │
│  │   BOX-A1     │   BOX-A2     │   BOX-A3     │          │
│  │   🟢 25%     │   🟡 85%     │   🔴 100%    │          │
│  │   25/100     │   85/100     │   100/100    │          │
│  │   Available  │   In Use     │   FULL ⚠️     │          │
│  └──────────────┴──────────────┴──────────────┘          │
│                                                            │
│  Dhanmondi Kiosk Boxes:                                    │
│  ┌──────────────┬──────────────┐                          │
│  │   BOX-B1     │   BOX-B2     │                          │
│  │   🟢 32%     │   🟡 78%     │                          │
│  │   32/100     │   78/100     │                          │
│  │   Available  │   In Use     │                          │
│  └──────────────┴──────────────┘                          │
│                                                            │
│  ⚠️  BOX-A3 is FULL - Ready for dispatch!                 │
│  ⚠️  BOX-A2 is 85% - Almost ready!                        │
└───────────────────────────────────────────────────────────┘
```

**What Staff Do**: Monitor throughout day, alert supervisor when boxes are 90%+ full

---

### PHASE 4: Dispatch to Kiosk (When Boxes Full)

```
┌───────────────────────────────────────────────────────────┐
│  SORTING CENTER - Dispatch Preparation                    │
│                                                            │
│  📊 Ready for Dispatch (Grouped by Kiosk):                │
│                                                            │
│  ┌────────────────────────────────────────────────┐       │
│  │ 📍 Mirpur Kiosk (MIR-01)                       │       │
│  │    Total Parcels: 185                          │       │
│  │    Boxes: BOX-A2, BOX-A3                       │       │
│  │    Total COD: ৳45,600                          │       │
│  │    Status: Ready                               │       │
│  │                                                 │       │
│  │    [📤 Send to Kiosk]                          │       │
│  └────────────────────────────────────────────────┘       │
│                                                            │
│  ┌────────────────────────────────────────────────┐       │
│  │ 📍 Dhanmondi Kiosk (DHN-01)                    │       │
│  │    Total Parcels: 110                          │       │
│  │    Boxes: BOX-B1                               │       │
│  │    Total COD: ৳28,900                          │       │
│  │    Status: Ready                               │       │
│  │                                                 │       │
│  │    [📤 Send to Kiosk]                          │       │
│  └────────────────────────────────────────────────┘       │
└───────────────────────────────────────────────────────────┘
        ↓ Click "Send to Kiosk"
        ↓
┌────────────────────────────────────────────────────┐
│  Modal: Confirm Dispatch                          │
│                                                    │
│  Sending to: Mirpur Kiosk (MIR-01)                │
│  Boxes: BOX-A2, BOX-A3                            │
│                                                    │
│  Parcels (185 total):                             │
│  ┌──────────┬──────────┬─────────────┬─────┐     │
│  │ Track#   │ Box      │ Customer    │ COD │     │
│  ├──────────┼──────────┼─────────────┼─────┤     │
│  │ TRK-001  │ BOX-A2   │ Ahmed Khan  │ ৳500│     │
│  │ TRK-002  │ BOX-A3   │ Fatima Ali  │ ৳1.2K│    │
│  │ ...      │ ...      │ ...         │ ... │     │
│  └──────────┴──────────┴─────────────┴─────┘     │
│                                                    │
│  Kiosk API: https://kiosk-api.digibox.com        │
│                                                    │
│  [Cancel]  [✅ Confirm & Send]                    │
└────────────────────────────────────────────────────┘
        ↓ Click "Confirm & Send"
        ↓
┌────────────────────────────────────────────────────┐
│  System Actions:                                   │
│  1. ✅ API call to kiosk system                    │
│  2. ✅ Send JSON with all parcel details           │
│  3. ✅ Kiosk receives data                         │
│  4. ✅ Update parcel status → Dispatched           │
│  5. ✅ Update box status → Dispatched              │
│  6. ✅ Log API call in kiosk_api_logs              │
└────────────────────────────────────────────────────┘
        ↓
Physical Process:
1. Print manifest (optional)
2. Load BOX-A2 and BOX-A3 onto truck
3. Drive to Mirpur Kiosk
4. Kiosk staff receives boxes
5. Kiosk staff already has data in their system
6. Kiosk prepares for customer delivery
```

**API Payload Sent**:
```json
{
  "sorting_center_id": 1,
  "sorting_center_code": "DHK-001",
  "dispatch_date": "2026-03-03T14:30:00Z",
  "destination_kiosk_code": "MIR-01",
  "total_parcels": 185,
  "total_cod_amount": 45600.00,
  "boxes": [
    {
      "box_number": "BOX-A2",
      "parcel_count": 85,
      "parcels": [
        {
          "tracking_number": "TRK-001234",
          "customer_name": "Ahmed Khan",
          "customer_phone": "01712345678",
          "customer_address": "House 123, Road 5, Mirpur-10, Dhaka",
          "customer_latitude": 23.8069,
          "customer_longitude": 90.3685,
          "customer_landmarks": "Near Mirpur-10 Roundabout",
          "cod_amount": 500.00,
          "qr_code_data": {
            "tracking_number": "TRK-001234",
            "destination_kiosk_code": "MIR-01",
            "box_number": "BOX-A2",
            "return_center_id": 1,
            "return_center_code": "DHK-001"
          }
        }
      ]
    },
    {
      "box_number": "BOX-A3",
      "parcel_count": 100,
      "parcels": [...]
    }
  ]
}
```

**What Staff Do**:
1. Click "Send to Kiosk"
2. Review parcel list
3. Click "Confirm & Send"
4. Load physical boxes on truck
5. Deliver to kiosk

---

### PHASE 5: Return Flow (When Customer Rejects)

```
Customer at Kiosk Location
        ↓
Refuses Delivery / Wants Return
        ↓
┌──────────────────────────────┐
│   KIOSK SYSTEM               │
│   Scans QR Code              │
│   Reads: return_center_id: 1 │
│   (Dhaka Sorting Center)     │
└───────────────┬──────────────┘
                │
                │ 📡 API Call: POST /api/v1/sorting-centers/1/parcels/return-requests
                │ Sends: original tracking#, return reason, kiosk location
                ↓
┌───────────────────────────────────────────────────────────┐
│  SORTING CENTER - Return Parcels                          │
│                                                            │
│  📊 Statistics:                                            │
│  ┌───────┬──────────┬───────────┬──────────┬──────────┐  │
│  │ Total │Requested │ Scheduled │Collected │ Processed│  │
│  │  45   │   12     │     8     │    15    │    10    │  │
│  └───────┴──────────┴───────────┴──────────┴──────────┘  │
│                                                            │
│  🆕 New Return Requests:                                   │
│  ┌──────────┬─────────────┬────────────┬──────────┐      │
│  │ Track#   │ From Kiosk  │ Reason     │ Action   │      │
│  ├──────────┼─────────────┼────────────┼──────────┤      │
│  │ TRK-001  │ Mirpur      │ Damaged    │[Assign   │      │
│  │          │ MIR-01      │ package    │ Rider]   │      │
│  ├──────────┼─────────────┼────────────┼──────────┤      │
│  │ TRK-045  │ Dhanmondi   │ Wrong      │[Assign   │      │
│  │          │ DHN-01      │ address    │ Rider]   │      │
│  └──────────┴─────────────┴────────────┴──────────┘      │
└───────────────────────────────────────────────────────────┘
        ↓ Click "Assign Rider"
        ↓
┌────────────────────────────────────┐
│  Modal: Assign Rider for Pickup   │
│                                    │
│  Select Rider:                     │
│  ┌─────────────────────────────┐  │
│  │ ▼ Karim (Motorcycle)        │  │
│  │   Rashid (Van)              │  │
│  │   Saiful (Truck)            │  │
│  └─────────────────────────────┘  │
│                                    │
│  Pickup Location: Mirpur Kiosk    │
│  Address: Mirpur-10, Road 5       │
│                                    │
│  [Cancel]  [Assign Rider]         │
└────────────────────────────────────┘
        ↓ Click "Assign Rider"
        ↓
Status: Requested → Pickup Scheduled
Rider notified (if SMS enabled)
        ↓
Rider goes to Mirpur Kiosk
Picks up parcel from kiosk staff
        ↓
Back in system: Click "Mark as Collected"
Status: Pickup Scheduled → Collected
        ↓
Rider brings parcel to sorting center
        ↓
Staff: Click "Mark as Received"
Status: Collected → Received
        ↓
Process return (refund/restock/etc.)
        ↓
Staff: Click "Mark as Processed"
Status: Received → Processed
DONE ✅
```

**Return Flow States**:
```
1. Requested        (🟡 New return, need rider)
   ↓
2. Pickup Scheduled (🟠 Rider assigned, going to kiosk)
   ↓
3. Collected        (🔵 Rider picked up from kiosk)
   ↓
4. Received         (🟢 Parcel at sorting center)
   ↓
5. Processed        (🟣 Return handled, refund done)
```

---

## Daily Timeline Example

```
08:00 AM ─────────────────────────────────────
         │ Check Dashboard
         │ Review Pre-Data (150 parcels coming)
         │ Ensure boxes are empty/ready
         │
09:00 AM ─────────────────────────────────────
         │ Physical parcels arrive
         │ Start scanning (Scanning Interface)
         │ Scan → AI routes → Assign to box
         │ Repeat, repeat, repeat...
         │
12:00 PM ─────────────────────────────────────
         │ Lunch break
         │ Check Box Management
         │ BOX-A3 is 90% full (Mirpur)
         │
01:00 PM ─────────────────────────────────────
         │ Continue scanning
         │ BOX-A3 reaches 100% (Mirpur)
         │ BOX-B1 reaches 95% (Dhanmondi)
         │
02:00 PM ─────────────────────────────────────
         │ DISPATCH TIME
         │ Go to Dispatch Preparation
         │ Send Mirpur boxes (API call)
         │ Send Dhanmondi boxes (API call)
         │ Load boxes on trucks
         │
03:00 PM ─────────────────────────────────────
         │ Continue scanning remaining parcels
         │ New return request arrives
         │ Assign rider for pickup
         │
05:00 PM ─────────────────────────────────────
         │ Dispatch partial boxes (even if not full)
         │ Check COD Management
         │ Review rider collections
         │
06:00 PM ─────────────────────────────────────
         │ Check Dashboard for day summary
         │ Parcels processed: 150 ✅
         │ Boxes dispatched: 8 ✅
         │ Returns handled: 5 ✅
         │ Tomorrow's pre-data: 175 (preview)
         │
END DAY ──────────────────────────────────────
```

---

## API Communication Flow

```
┌──────────────┐                 ┌──────────────────┐                ┌──────────────┐
│   KIOSK      │                 │ SORTING CENTER   │                │   KIOSK      │
│   SYSTEM     │                 │   (Your System)  │                │   SYSTEM     │
└──────┬───────┘                 └────────┬─────────┘                └──────┬───────┘
       │                                  │                                  │
       │ API 1: Pre-Data                  │                                  │
       │ POST /parcels/pre-data           │                                  │
       ├─────────────────────────────────>│                                  │
       │ {tracking#, customer, address}   │                                  │
       │                                  │                                  │
       │                                  │ Staff sorts parcels              │
       │                                  │ throughout the day               │
       │                                  │                                  │
       │                                  │ API 2: Sorted Data               │
       │                                  │ POST to kiosk API                │
       │                                  ├─────────────────────────────────>│
       │                                  │ {parcels, boxes, QR data}        │
       │                                  │                                  │
       │                                  │                                  │
       │ API 3: Return Request            │                                  │
       │ POST /parcels/return-requests    │                                  │
       │<─────────────────────────────────┤                                  │
       │ (Initiated by kiosk on left)     │                                  │
       │ {tracking#, reason, location}    │                                  │
       │                                  │                                  │
       │                                  │ Rider picks up return            │
       │                                  │ from kiosk                       │
       │                                  │                                  │
```

---

## QR Code Journey

```
Parcel arrives at Sorting Center
         ↓
Staff scans existing QR code (from bank/kiosk)
         ↓
System reads: {tracking_number: "TRK-001234"}
         ↓
Looks up pre-data in database
         ↓
AI calculates routing
         ↓
Staff assigns to box
         ↓
System GENERATES new QR code:
{
  tracking_number: "TRK-001234",
  destination_kiosk_code: "MIR-01",
  box_number: "BOX-A2",
  return_center_id: 1,        ← CRITICAL for returns!
  return_center_code: "DHK-001"
}
         ↓
QR code sent to kiosk in API 2
         ↓
Kiosk prints/uses this QR for customer delivery
         ↓
If customer refuses → kiosk scans QR → reads return_center_id
         ↓
Knows to send return to Dhaka Sorting Center (ID: 1)
```

---

## Box-to-Kiosk Mapping Example

```
Your Sorting Center: "Dhaka Main Center"
You serve: 6 kiosk locations

Box Configuration:
┌──────────┬───────────────────┬──────────┬────────┐
│ Box      │ Assigned Kiosk    │ Capacity │ Status │
├──────────┼───────────────────┼──────────┼────────┤
│ BOX-A1   │ Mirpur Kiosk      │ 100      │ 🟢     │
│ BOX-A2   │ Mirpur Kiosk      │ 100      │ 🟡     │
│ BOX-A3   │ Mirpur Kiosk      │ 100      │ 🔴     │
├──────────┼───────────────────┼──────────┼────────┤
│ BOX-B1   │ Dhanmondi Kiosk   │ 100      │ 🟢     │
│ BOX-B2   │ Dhanmondi Kiosk   │ 100      │ 🟡     │
├──────────┼───────────────────┼──────────┼────────┤
│ BOX-C1   │ Gulshan Kiosk     │ 75       │ 🟢     │
│ BOX-C2   │ Gulshan Kiosk     │ 75       │ 🟢     │
├──────────┼───────────────────┼──────────┼────────┤
│ BOX-D1   │ Uttara Kiosk      │ 100      │ 🟢     │
│ BOX-D2   │ Uttara Kiosk      │ 100      │ 🟢     │
├──────────┼───────────────────┼──────────┼────────┤
│ BOX-E1   │ Banani Kiosk      │ 50       │ 🟢     │
│ BOX-E2   │ Banani Kiosk      │ 50       │ 🟢     │
├──────────┼───────────────────┼──────────┼────────┤
│ BOX-F1   │ Mohakhali Kiosk   │ 100      │ 🟢     │
│ BOX-F2   │ Mohakhali Kiosk   │ 100      │ 🟡     │
└──────────┴───────────────────┴──────────┴────────┘

When AI suggests "Mirpur Kiosk":
  → Staff picks from: BOX-A1, BOX-A2, or BOX-A3
  → Usually picks greenest box (most available)

When AI suggests "Dhanmondi Kiosk":
  → Staff picks from: BOX-B1 or BOX-B2
```

---

## Success Indicators

After following this flow, you should see:

```
✅ Dashboard shows real-time stats
✅ Pre-data parcels → Physical received → Sorted → Dispatched
✅ AI routing gives 80%+ green confidence scores
✅ Boxes fill up evenly
✅ Dispatch happens 2-3 times daily
✅ Kiosk receives data instantly via API
✅ Returns are tracked through 5 states
✅ No parcels "lost" in system
✅ COD amounts tracked accurately
```

---

## Troubleshooting Workflow

**Problem**: Parcel in pre-data but can't scan it
```
Pre-Data Dashboard → Find tracking# → Click "Mark as Received"
Then go scan it in Scanning Interface
```

**Problem**: AI shows low confidence (orange)
```
Check customer address manually
Look at map
Use your judgment
Override if needed
```

**Problem**: All boxes for a kiosk are full
```
Box Management → Create new box for same kiosk
OR dispatch current boxes immediately
```

**Problem**: Dispatch API fails
```
Check: Dispatch Preparation → View error message
Check: KIOSK_SYSTEM_API_URL in .env
Check: Kiosk API is online
Check: kiosk_api_logs table for details
Retry dispatch after fixing
```

**Problem**: Return parcel but no rider available
```
Riders → Create Rider
OR manually handle (drive to kiosk yourself)
OR schedule for tomorrow
```

---

**This is your complete operational guide! Follow the flow from top to bottom daily. 🚀**
