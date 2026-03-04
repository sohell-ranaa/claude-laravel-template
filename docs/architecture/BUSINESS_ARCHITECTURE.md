# DigiBox Logistics - Sorting Center System
## Business Architecture & Functional Overview

**Version:** 1.0
**Date:** March 2026
**Audience:** Business Stakeholders, Operations Team, Management

---

## Table of Contents

1. [Business Overview](#business-overview)
2. [User Roles](#user-roles)
3. [Core Business Flows](#core-business-flows)
4. [Feature Breakdown](#feature-breakdown)
5. [Operational Workflows](#operational-workflows)
6. [User Journeys](#user-journeys)
7. [Business Rules](#business-rules)
8. [Key Performance Indicators](#key-performance-indicators)

---

## Business Overview

### What is DigiBox Logistics Sorting Center?

DigiBox Logistics Sorting Center is a comprehensive parcel management system that handles the entire journey of packages from receipt to delivery. It acts as the central hub that:

- **Receives parcels** from DigiBox Kiosk (DBK) clients
- **Sorts parcels** intelligently based on destination
- **Routes parcels** through single or multiple sorting centers
- **Manages riders** for parcel delivery
- **Tracks everything** in real-time
- **Handles payments** including Cash on Delivery (COD)
- **Provides analytics** for business decisions

### Business Problem Solved

**Before:**
- Manual parcel sorting (time-consuming, error-prone)
- No visibility of parcel location
- Difficult to manage multiple sorting centers
- Manual COD accounting (reconciliation nightmares)
- No data for business insights

**After:**
- Automated intelligent routing
- Real-time tracking for customers and operators
- Multi-center network with seamless handoffs
- Automated COD tracking and settlement
- Rich analytics and reporting

---

## User Roles

### 1. Super Administrator
**Who:** System owner, senior management
**Responsibilities:**
- Create and deploy new sorting centers
- Manage all sorting centers across Bangladesh
- Configure system-wide settings
- View consolidated reports across all centers
- Manage user accounts and permissions

### 2. Sorting Center Manager
**Who:** Manager of a specific sorting center
**Responsibilities:**
- Oversee daily operations of their center
- Manage center employees and riders
- Configure routing rules for their center
- Monitor center performance metrics
- Handle escalations and exceptions
- Manage COD collections and settlements

### 3. Sorting Operator
**Who:** Ground staff at sorting center
**Responsibilities:**
- Scan and receive incoming parcels
- Perform parcel sorting based on system recommendations
- Generate and print labels
- Create handover manifests for riders
- Record parcel conditions and damages
- Handle customer inquiries

### 4. Rider
**Who:** Delivery personnel
**Responsibilities:**
- Collect parcels from sorting center
- Deliver parcels to customers
- Collect COD payments
- Update delivery status via mobile app
- Capture delivery proof (photo/signature)
- Return undelivered parcels to sorting center

### 5. Accountant
**Who:** Finance staff
**Responsibilities:**
- Verify COD collections from riders
- Process rider settlements
- Initiate client payouts
- Generate financial reconciliation reports
- Monitor outstanding payments
- Audit financial transactions

### 6. Client (DigiBox Kiosk)
**Who:** External business using the logistics service
**Responsibilities:**
- Submit parcels to sorting center
- Receive parcel status updates via webhook
- Track parcels on behalf of their customers
- Receive delivery confirmations
- Request returns when needed

---

## Core Business Flows

### Flow 1: Parcel Lifecycle (Happy Path)

```
┌─────────────────────────────────────────────────────────────────┐
│                    PARCEL JOURNEY                               │
└─────────────────────────────────────────────────────────────────┘

1. ORIGIN: DigiBox Kiosk collects parcel from customer
   ↓
2. SUBMISSION: DBK rider brings parcel to Mohammadpur Sorting Center
   ↓
3. RECEIVE: Operator scans QR code
   │ → System validates parcel with DBK
   │ → System records receipt timestamp
   │ → Webhook sent to DBK: "Parcel Received"
   ↓
4. ROUTE CALCULATION: System analyzes destination address
   │ → AI identifies landmarks and area
   │ → Checks routing rules
   │ → Destination: Uttara (has sub-sorting center)
   │ → Decision: Send to Uttara Sorting Center first
   ↓
5. LABEL GENERATION: System generates routing label
   │ → From: Mohammadpur SC
   │ → To: Uttara SC
   │ → Final Destination: Customer in Uttara
   │ → QR code with routing info
   │ → COD amount: ৳500
   ↓
6. SORTING: Operator pastes label and places in "Uttara" bin
   │ → System marks parcel as "Sorted"
   │ → Webhook sent to DBK: "Parcel Sorted"
   ↓
7. MANIFEST: Create handover manifest for Uttara
   │ → List of all parcels going to Uttara
   │ → Assign to hub-transfer rider
   │ → Generate manifest QR code
   ↓
8. TRANSFER: Rider transports parcels to Uttara SC
   │ → Scans each parcel during loading
   │ → System marks as "In Transit to Uttara SC"
   │ → Webhook sent to DBK: "In Transit"
   ↓
9. RECEIVE AT UTTARA: Uttara operator scans parcels
   │ → Validates against manifest
   │ → Records any discrepancies
   │ → System updates location to Uttara SC
   ↓
10. RE-SORT: Uttara operator sorts for final delivery
    │ → Destination: Sector 10, Uttara
    │ → Assign to local delivery rider
    ↓
11. OUT FOR DELIVERY: Rider takes parcels
    │ → Scans all parcels during loading
    │ → System marks as "Out for Delivery"
    │ → Webhook sent to DBK: "Out for Delivery"
    │ → Customer receives SMS notification
    ↓
12. DELIVERY: Rider delivers to customer
    │ → Customer verifies parcel
    │ → Rider collects COD: ৳500 cash
    │ → Rider records in mobile app
    │ → Captures customer signature/photo
    │ → System marks as "Delivered"
    │ → Webhook sent to DBK: "Delivered"
    │ → Customer receives delivery confirmation SMS
    ↓
13. COD SETTLEMENT: Rider returns to Uttara SC
    │ → Deposits ৳500 to accountant
    │ → Accountant verifies and records
    │ → System updates COD status
    ↓
14. CLIENT PAYOUT: Finance processes payout to DBK
    │ → DBK receives ৳500 (minus service fee)
    │ → Transaction completed

✅ JOURNEY COMPLETE
```

---

### Flow 2: Direct Delivery (No Sub-Center)

```
┌─────────────────────────────────────────────────────────────────┐
│              DIRECT DELIVERY FLOW                               │
└─────────────────────────────────────────────────────────────────┘

1. Parcel received at Mohammadpur SC
   ↓
2. Destination: Nearby area (within 5km)
   ↓
3. System decides: DIRECT DELIVERY
   ↓
4. Label printed: Direct delivery from Mohammadpur SC
   ↓
5. Sorted and assigned to local rider
   ↓
6. Rider delivers same day
   ↓
7. COD collected and settled at Mohammadpur SC

⚡ FASTER PATH
```

---

### Flow 3: Third-Party Logistics Handover

```
┌─────────────────────────────────────────────────────────────────┐
│           THIRD-PARTY LOGISTICS FLOW                            │
└─────────────────────────────────────────────────────────────────┘

1. Parcel received at Dhaka sorting center
   ↓
2. Destination: Chittagong (outside coverage area)
   ↓
3. System checks routing rules
   │ → No DigiBox SC in Chittagong
   │ → Rule: Use Sundarban Courier for Chittagong
   ↓
4. System creates shipment with Sundarban API
   │ → Receives Sundarban AWB number
   │ → Generates Sundarban label
   ↓
5. Operator prints Sundarban label and pastes on parcel
   ↓
6. Parcel handed over to Sundarban Courier
   │ → Manifest created for handover
   │ → Sundarban representative signs
   │ → System marks as "Transferred to Third Party"
   │ → Webhook sent to DBK
   ↓
7. Tracking synced with Sundarban API
   │ → System polls Sundarban for status updates
   │ → Updates forwarded to DBK
   ↓
8. Sundarban delivers parcel in Chittagong
   ↓
9. Sundarban updates status to "Delivered"
   │ → System receives update via API
   │ → Webhook sent to DBK: "Delivered"
   ↓
10. COD settled with Sundarban
    │ → Sundarban remits COD to DigiBox
    │ → DigiBox pays out to client

🤝 PARTNER INTEGRATION
```

---

### Flow 4: Return Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    RETURN FLOW                                  │
└─────────────────────────────────────────────────────────────────┘

SCENARIO: Customer refuses delivery (not home, wrong item, etc.)

1. Rider attempts delivery
   │ → Customer not available / refuses
   │ → Rider marks as "Delivery Failed"
   │ → Records reason in app
   ↓
2. Rider brings parcel back to Uttara SC
   ↓
3. Uttara operator scans parcel
   │ → System marks as "Return Initiated"
   │ → Webhook sent to DBK: "Return in Progress"
   ↓
4. System determines return destination
   │ → Check parcel data for "return_address"
   │ → Usually returns to original DBK kiosk
   │ → Could be different than pickup location
   ↓
5. Generate return label
   │ → From: Uttara SC
   │ → To: Mohammadpur SC (near DBK kiosk)
   │ → Return reason printed on label
   ↓
6. Sort for return journey
   │ → Reverse of delivery route
   ↓
7. Transfer back to Mohammadpur SC
   ↓
8. Deliver to DBK kiosk
   │ → DBK receives returned parcel
   │ → DBK contacts their customer
   │ → Webhook sent to DBK: "Returned"
   ↓
9. No COD collected (failed delivery)

🔄 RETURN COMPLETE
```

---

## Feature Breakdown

### 1. Sorting Center Management

#### 1.1 Create New Sorting Center
**What it does:**
Allows super admin to set up a new sorting center anywhere in Bangladesh.

**Features:**
- Define center name and unique code (e.g., "UTT-001")
- Set physical address and GPS coordinates
- Assign center manager
- Set operational hours
- Configure daily capacity (e.g., 1000 parcels/day)
- Choose center type:
  - **Primary Hub:** Main sorting facility
  - **Secondary Hub:** Regional distribution center
  - **Delivery Hub:** Last-mile delivery station

**Example:**
```
Creating "Uttara Sorting Center"
- Code: UTT-001
- Address: House 45, Road 12, Sector 7, Uttara, Dhaka
- Coordinates: 23.8759° N, 90.3795° E
- Manager: Mr. Kamal Ahmed
- Hours: 8 AM - 10 PM
- Capacity: 800 parcels/day
- Type: Secondary Hub
```

#### 1.2 Coverage Area Definition
**What it does:**
Defines which geographical areas each sorting center serves.

**Features:**
- Draw coverage boundaries on map
- List postal codes covered
- Add landmarks for better routing
- Set priority (if areas overlap)

**Example:**
```
Uttara SC covers:
- Uttara Sector 1-18
- Postal codes: 1230, 1231
- Landmarks: Rajlakshmi Complex, Uttara University
- Priority: 1 (highest)
```

#### 1.3 Multi-Layer Sorting Configuration
**What it does:**
Configure whether parcels go direct to delivery or through sub-centers.

**Settings:**
- **Direct Delivery:** For nearby areas (< 5km)
- **Single Transfer:** Through one sub-center
- **Multi Transfer:** Through multiple hubs
- **Third-Party:** Hand off to partner logistics

**Example Configuration:**
```
For Mohammadpur Sorting Center:

Rule 1: Distance < 5km → Direct Delivery
Rule 2: Destination = Uttara → Transfer to Uttara SC
Rule 3: Destination = Chittagong → Sundarban Courier
Rule 4: Weight > 25kg → SA Paribahan (freight)
```

---

### 2. Parcel Operations

#### 2.1 QR Code Scanning & Receipt
**What it does:**
When a parcel arrives, operators scan the QR code to log it into the system.

**Process:**
1. Operator uses handheld scanner or mobile app
2. Scans QR code on parcel
3. System validates with DigiBox Kiosk API
4. If valid, parcel marked as "Received"
5. Receipt timestamp recorded
6. Notification sent to client

**Validation Checks:**
- Is this parcel expected?
- Does tracking number exist in DBK system?
- Is parcel information correct?
- Any special handling required?

**Screen Shows:**
```
✅ PARCEL RECEIVED

Tracking: DBL-2026-001234
From: Green Leaf Store (DBK Dhanmondi)
To: Mr. Rahman, Uttara Sector 10
Weight: 2.5 kg
COD: ৳500
Special: Fragile

Next Step: Sort to Uttara SC
```

#### 2.2 Intelligent Routing
**What it does:**
System automatically determines the best path for each parcel.

**How it works:**
1. Reads destination address
2. Extracts key information:
   - District, Upazila, Thana
   - Postal code
   - Landmarks (AI-powered)
3. Finds matching sorting centers
4. Applies routing rules
5. Recommends next destination

**AI Features:**
- Recognizes landmarks: "Near Bashundhara City"
- Understands local names: "Mohammadiya Housing, Mohammadpur"
- Handles incomplete addresses
- Learns from historical data

**Example:**
```
Address: "House 23, Road 5, Sector 10, Uttara, Dhaka"

AI Analysis:
✓ District: Dhaka
✓ Area: Uttara, Sector 10
✓ Landmark Detected: Near Sector 10 Market
✓ Postal Code: 1230

Routing Decision:
→ Uttara Sorting Center (UTT-001)
  Distance: 12.5 km
  Confidence: 95%
```

#### 2.3 Sorting Process
**What it does:**
Guides operators to physically sort parcels into correct bins.

**Workflow:**
1. Operator scans parcel
2. System shows destination on screen
3. System highlights which bin to use
4. Operator places parcel in bin
5. System confirms sorting

**Sorting Bins:**
```
Bin A → Uttara SC
Bin B → Mirpur SC
Bin C → Direct Delivery (Mohammadpur)
Bin D → Third-Party (Sundarban)
Bin E → Returns
```

#### 2.4 Bulk Operations
**What it does:**
Handle many parcels quickly.

**Features:**
- Bulk receive (scan multiple parcels)
- Batch sorting
- Bulk label printing
- Manifest generation for groups

---

### 3. Label & Sticker System

#### 3.1 QR Code Label
**What it contains:**
- Tracking number (human-readable)
- QR code (machine-readable)
- Origin sorting center
- Destination sorting center
- Recipient details
- COD amount (if applicable)
- Return address
- Routing instructions

**Sample Label:**
```
┌─────────────────────────────────────┐
│  [QR CODE]    [DigiBox Logo]        │
│                                     │
│  DBL-2026-001234                    │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│                                     │
│  FROM: Mohammadpur SC (MDP-001)     │
│  TO: Uttara SC (UTT-001)            │
│                                     │
│  FINAL DESTINATION:                 │
│  Mr. Abdur Rahman                   │
│  01712-345678                       │
│  House 23, Road 5, Sector 10        │
│  Uttara, Dhaka-1230                 │
│                                     │
│  💰 COD: ৳500                        │
│                                     │
│  RETURN TO:                         │
│  Green Leaf Store                   │
│  Dhanmondi, Dhaka                   │
│                                     │
│  🔄 Route: MDP → UTT → DELIVER      │
└─────────────────────────────────────┘
```

#### 3.2 Thermal Printer Support
**What it does:**
Print labels directly on thermal printers (like Zebra, POSTEK).

**Benefits:**
- Faster printing (no ink needed)
- Waterproof labels
- Barcode/QR code quality
- Cost-effective

#### 3.3 Batch Printing
**What it does:**
Print labels for multiple parcels at once.

**Use case:**
After sorting 50 parcels for Uttara, print all 50 labels in one batch.

---

### 4. Rider Management

#### 4.1 Rider Assignment
**What it does:**
Assign parcels to riders for delivery or transfer.

**Assignment Options:**

**A. Manual Assignment:**
```
Manager selects:
- Rider: Karim (Motorcycle)
- Parcels: 30 items for Uttara delivery
- Route: Optimized by system
- Expected completion: 5 hours
```

**B. Automatic Assignment:**
```
System considers:
- Rider availability
- Rider location (closest)
- Rider capacity (50 parcels max)
- Rider vehicle type
- Delivery zones
- Current workload
```

#### 4.2 Rider Mobile App
**What riders see:**
- Assigned parcels list
- Customer addresses on map
- Optimized route
- Customer contact numbers
- COD amounts to collect
- Delivery proof capture

**Key Features:**
- Scan parcel on pickup
- Navigate to customer
- Call customer
- Capture delivery photo
- Get customer signature
- Record COD payment
- Mark delivery status
- Handle returns

#### 4.3 Rider Performance Tracking
**Metrics:**
- Total deliveries
- Success rate
- Average delivery time
- Customer ratings
- COD collection accuracy
- Return rate

---

### 5. COD (Cash on Delivery) Management

#### 5.1 COD Collection
**Workflow:**
```
1. Rider delivers parcel
   ↓
2. Customer pays ৳500 cash
   ↓
3. Rider records in mobile app:
   - Parcel tracking number
   - Amount: ৳500
   - Payment method: Cash
   - Timestamp
   ↓
4. System logs collection
   ↓
5. Rider returns to sorting center
```

#### 5.2 COD Deposit & Verification
**What happens:**
```
1. Rider arrives at sorting center
   ↓
2. Hands over cash to accountant
   ↓
3. Accountant counts and verifies:
   - Total amount matches app records
   - Check each parcel's COD
   - Reconcile any discrepancies
   ↓
4. Accountant confirms in system
   ↓
5. System updates COD status to "Deposited"
```

#### 5.3 Settlement Process
**Daily Settlement:**
```
1. End of day: System calculates rider dues

2. Rider collected: ৳5,000 COD
   - Commission: ৳500 (10%)
   - Net payable to company: ৳4,500

3. Accountant settles:
   - Rider keeps ৳500 commission
   - Company receives ৳4,500

4. System generates settlement report
```

#### 5.4 Client Payout
**Weekly Payout to DBK:**
```
1. Week's COD collections for DBK: ৳50,000

2. Deductions:
   - Delivery fee: ৳5,000 (10%)
   - Transaction charges: ৳250
   - Total deductions: ৳5,250

3. Net payout to DBK: ৳44,750

4. Payment methods:
   - Bank transfer
   - bKash/Nagad
   - Manual check

5. Invoice generated
```

---

### 6. Tracking & Visibility

#### 6.1 Real-Time Tracking
**Who can track:**
- Clients (DBK)
- End customers (via DBK)
- Sorting center operators
- Managers
- Super admins

**Tracking Information:**
```
Tracking: DBL-2026-001234

📍 Current Status: Out for Delivery
📦 Current Location: With Rider Karim, Uttara
⏰ Last Update: 2 hours ago

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 JOURNEY HISTORY

✅ Mar 1, 9:00 AM - Received at Mohammadpur SC
✅ Mar 1, 9:30 AM - Sorted for Uttara SC
✅ Mar 1, 10:00 AM - In transit to Uttara SC
✅ Mar 1, 11:30 AM - Received at Uttara SC
✅ Mar 1, 12:00 PM - Sorted for delivery
✅ Mar 1, 2:00 PM - Out for delivery
🔄 Mar 1, 4:00 PM - Expected delivery

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Estimated Delivery: Today by 6 PM
```

#### 6.2 Customer Notifications
**SMS Notifications:**
- Parcel received at sorting center
- Out for delivery
- Delivered successfully
- Delivery failed (with retry info)
- Return initiated

**Sample SMS:**
```
DigiBox Logistics: Your parcel DBL-2026-001234
is out for delivery. Rider Karim (01712345678)
will deliver today by 6 PM. Track: bit.ly/xyz
```

---

### 7. Integration Features

#### 7.1 DigiBox Kiosk Integration
**Webhooks sent to DBK:**
```
parcel.validated    → Parcel info verified
parcel.received     → Logged into system
parcel.sorted       → Ready for next step
parcel.in_transit   → Moving between centers
parcel.out_for_delivery → Rider has parcel
parcel.delivered    → Successfully delivered
parcel.returned     → Customer refused/unavailable
cod.collected       → Payment received
```

#### 7.2 Third-Party Logistics APIs
**Partners:**
- Sundarban Courier
- SA Paribahan
- Pathao Courier
- Paperfly
- Steadfast

**What we do:**
- Create shipment via their API
- Get their tracking number
- Sync status updates
- Handle COD settlements

---

### 8. Reporting & Analytics

#### 8.1 Daily Operations Report
**What it shows:**
```
MOHAMMADPUR SORTING CENTER
Daily Report - March 1, 2026

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

RECEIVED
Total: 450 parcels
- From DBK: 380
- Returns: 70

SORTED
Total: 420 parcels
- To Uttara SC: 150
- To Mirpur SC: 100
- Direct delivery: 120
- Third-party: 50

IN TRANSIT
Current: 200 parcels

DELIVERED
Today: 180 parcels
Success rate: 92%

PENDING
End of day: 90 parcels

COD COLLECTED
Total: ৳45,000
Deposited: ৳42,000
Pending: ৳3,000

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

TOP DESTINATIONS
1. Uttara - 150 parcels
2. Mirpur - 100 parcels
3. Dhanmondi - 80 parcels

PERFORMANCE
Avg sorting time: 4.2 minutes
Center utilization: 45% (450/1000)
```

#### 8.2 Rider Performance Report
```
RIDER: Karim Ahmed (KRM-001)
Period: March 2026

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

DELIVERIES
Total attempts: 250
Successful: 230 (92%)
Failed: 20 (8%)

AVERAGE TIME
Pickup to delivery: 2.5 hours
Per parcel: 12 minutes

COD COLLECTION
Collected: ৳25,000
Accuracy: 100%

CUSTOMER RATING
⭐⭐⭐⭐⭐ 4.8/5.0

ZONES COVERED
- Uttara Sector 1-10
- Dakshinkhan
```

#### 8.3 Financial Report
```
CLIENT PAYOUT REPORT
Client: DigiBox Kiosk - Dhanmondi
Period: March 1-7, 2026

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

DELIVERIES
Total delivered: 350 parcels
Delivery fee (৳20/parcel): ৳7,000

COD COLLECTED
Total: ৳87,500
Transaction fee (1%): ৳875

RETURNS
Total: 15 parcels
Return handling fee: ৳300

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CALCULATION
COD collected: ৳87,500
Less: Delivery fees: (৳7,000)
Less: Transaction fees: (৳875)
Less: Return fees: (৳300)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
NET PAYOUT: ৳79,325

Payment Status: Paid on March 8
Payment Method: Bank Transfer
```

#### 8.4 Analytics Dashboard
**Live Metrics:**
- Parcels in system (real-time)
- Active riders on map
- Today's delivery success rate
- Revenue today
- Pending COD amount
- Center capacity utilization
- Average delivery time
- Customer satisfaction score

**Visualizations:**
- Parcel flow heatmap
- Delivery success trends
- Revenue charts
- Rider performance graphs

---

## Operational Workflows

### Workflow 1: Opening Shift (Morning)

**Time:** 8:00 AM

```
1. SORTING CENTER MANAGER
   □ Opens center
   □ Logs into system
   □ Reviews yesterday's pending items
   □ Checks rider attendance
   □ Briefs team on today's priorities

2. SORTING OPERATORS
   □ Log into workstations
   □ Check equipment (scanners, printers)
   □ Prepare sorting bins
   □ Review pending parcels from yesterday

3. RIDERS
   □ Check in via mobile app
   □ Collect assigned devices
   □ Review delivery assignments
   □ Load vehicles if early deliveries

4. ACCOUNTANT
   □ Review yesterday's unsettled COD
   □ Prepare cash float for today
   □ Check pending settlements

5. SYSTEM TASKS
   □ Generate overnight reports
   □ Sync third-party tracking updates
   □ Send morning summary to managers
```

---

### Workflow 2: Parcel Receiving (Throughout Day)

```
1. DBK RIDER ARRIVES
   Time: Varies throughout day

2. HANDOVER
   □ DBK rider presents manifest
   □ Operator receives parcels
   □ Count verification

3. SCANNING
   □ Operator scans each QR code
   □ System validates each parcel
   □ Any issues flagged immediately
   □ Print receipt for DBK rider

4. INITIAL SORTING
   □ Parcels placed in receiving area
   □ Grouped by scanning operator
   □ Ready for main sorting process

Average time: 5-10 minutes per batch of 20 parcels
```

---

### Workflow 3: Main Sorting Session

```
BATCH SORTING (Every 2 hours)

1. PREPARATION
   □ Gather all received parcels
   □ Ensure all bins are ready
   □ Printers loaded with labels

2. SCAN & ROUTE
   For each parcel:
   □ Scan QR code
   □ System shows destination
   □ System shows which bin
   □ Print label

3. LABEL APPLICATION
   □ Paste label on parcel
   □ Ensure QR code visible
   □ Cover old labels if any

4. BINNING
   □ Place in designated bin
   □ System confirms placement
   □ Move to next parcel

5. COMPLETION
   □ All parcels sorted
   □ Generate bin reports
   □ Ready for rider assignment

Time: 3-5 minutes per parcel (including labeling)
```

---

### Workflow 4: Rider Dispatch

```
OUTBOUND DISPATCH

1. CREATE MANIFEST
   □ Select bin (e.g., "Uttara SC")
   □ Review parcel list
   □ Assign to rider
   □ Print manifest with QR code

2. RIDER LOADING
   □ Rider scans manifest QR
   □ Scans each parcel during loading
   □ System validates against manifest
   □ Any missing parcel flagged

3. DEPARTURE
   □ Rider confirms all loaded
   □ Signs manifest
   □ Departs for destination
   □ System tracks journey

4. HANDOVER AT DESTINATION
   □ Receiving center scans manifest
   □ Scans each parcel
   □ Reports any discrepancies
   □ Signs receipt
   □ Original rider marked complete

Average loading time: 15-20 minutes for 50 parcels
```

---

### Workflow 5: Last-Mile Delivery

```
DELIVERY TO CUSTOMER

1. MORNING ASSIGNMENT
   □ Rider checks app
   □ Reviews assigned deliveries
   □ Route optimized by system

2. PICKUP FROM SC
   □ Arrives at sorting center
   □ Scans assigned parcels
   □ Loads vehicle
   □ Departs on route

3. DELIVERY ATTEMPT
   For each stop:
   □ Navigate to address
   □ Call customer if needed
   □ Customer verifies parcel
   □ Rider scans parcel
   □ Collect COD if applicable
   □ Capture proof:
     - Photo of parcel with customer
     - Digital signature
     - ID verification
   □ Mark as delivered in app
   □ Move to next delivery

4. FAILED DELIVERY
   If customer unavailable:
   □ Mark as "Delivery Failed"
   □ Select reason (not home, wrong address, etc.)
   □ Take photo of premises
   □ Add notes
   □ Return to sorting center

5. END OF ROUTE
   □ Return to sorting center
   □ Deposit COD cash
   □ Return undelivered parcels
   □ Submit delivery proofs
   □ Log off from app

Typical route: 30-40 deliveries, 4-6 hours
```

---

### Workflow 6: COD Settlement (Evening)

```
END-OF-DAY COD PROCESS

1. RIDER RETURNS (4-6 PM)
   □ Arrives at sorting center
   □ Requests COD settlement

2. ACCOUNTANT VERIFICATION
   □ Pulls rider's COD report from system
   □ Expected COD: ৳5,000 (40 deliveries)

3. CASH COUNT
   □ Rider hands over cash
   □ Accountant counts
   □ Actual: ৳5,000 ✓

4. RECONCILIATION
   If matches:
   □ Accountant confirms in system
   □ Rider settlement processed
   □ Rider commission calculated

   If mismatch:
   □ Review each delivery
   □ Identify discrepancies
   □ Resolve issues
   □ Adjust records

5. SETTLEMENT
   □ System calculates rider commission (10%)
   □ Rider receives ৳500
   □ Company receives ৳4,500
   □ Receipt printed
   □ Cash secured in safe

6. DAILY CLOSE
   □ All riders settled
   □ Total COD tallied
   □ Bank deposit prepared
   □ Report generated

Daily average: 15-20 rider settlements
```

---

## User Journeys

### Journey 1: New Sorting Center Manager - First Day

**Persona:** Kamal Ahmed, newly appointed manager of Uttara Sorting Center

**Day 1:**

```
9:00 AM - ONBOARDING
□ Receives login credentials from HQ
□ Logs into system for first time
□ Sees dashboard specific to Uttara SC
□ Reviews coverage area on map
□ Notes: Uttara Sectors 1-18, nearby areas

9:30 AM - MEET THE TEAM
□ Introduces himself to 5 operators
□ Meets 10 riders assigned to center
□ Reviews accountant's role

10:00 AM - SYSTEM TRAINING
□ Super admin trains him on:
  - Receiving parcels
  - Sorting process
  - Rider assignment
  - Report generation
  - Handling exceptions

11:00 AM - FIRST PARCEL BATCH
□ 20 parcels arrive from Mohammadpur SC
□ Guides operator through receiving
□ Watches scanning process
□ Observes routing recommendations
□ Learns label printing

12:00 PM - LUNCH BREAK

1:00 PM - RIDER ASSIGNMENT
□ 50 parcels ready for delivery
□ Opens rider assignment screen
□ Sees list of available riders
□ Assigns parcels based on zones
□ Generates manifest
□ Oversees loading process

3:00 PM - MONITORING
□ Checks dashboard
□ Sees real-time rider locations
□ Monitors delivery progress
□ Handles customer call (address unclear)
□ Updates address in system

5:00 PM - END OF DAY
□ Reviews daily report
□ Checks pending deliveries
□ Oversees COD settlements
□ Plans for tomorrow

6:00 PM - DEBRIEF
□ Conference call with HQ
□ Shares learnings
□ Asks questions
□ Receives feedback
```

**Reflection:** "The system is intuitive. The routing AI is impressive - it even recognized local landmarks!"

---

### Journey 2: Sorting Operator - Typical Day

**Persona:** Fatima, sorting operator at Mohammadpur SC

**Daily Routine:**

```
8:00 AM - START SHIFT
□ Arrives at center
□ Logs into workstation
□ Tests scanner
□ Prepares label printer
□ Reviews pending items

8:30 AM - FIRST BATCH ARRIVAL
□ 30 parcels from DBK Dhanmondi
□ Receives manifest from DBK rider
□ Starts scanning each parcel
□ System validates each one
□ Prints receipt for rider
□ Rider departs

9:00 AM - SORTING SESSION 1
□ Scans first parcel: DBL-2026-001234
□ Screen shows: "Route to Uttara SC"
□ Screen highlights: "BIN A"
□ Prints label
□ Pastes on parcel
□ Places in Bin A
□ Repeats for all 30 parcels

10:30 AM - TEA BREAK

11:00 AM - SECOND BATCH
□ 50 parcels arrive
□ Repeats receiving process
□ One parcel fails validation
□ Calls manager
□ Manager contacts DBK
□ Issue resolved
□ Continues scanning

12:00 PM - SORTING SESSION 2
□ Mix of destinations:
  - 20 to Uttara SC (Bin A)
  - 15 to Mirpur SC (Bin B)
  - 10 direct delivery (Bin C)
  - 5 to Sundarban (Bin D)
□ All sorted by 12:45 PM

1:00 PM - LUNCH

2:00 PM - MANIFEST CREATION
□ Manager asks for Uttara manifest
□ Selects all parcels in Bin A
□ System generates manifest
□ Prints with QR code
□ Rider scans and loads
□ 40 parcels dispatched

3:00 PM - RETURN PROCESSING
□ Rider returns with 5 undelivered parcels
□ Scans each parcel
□ Marks as "Return"
□ Prints return labels
□ Sorts for return journey

4:00 PM - THIRD BATCH
□ 25 evening parcels
□ Rush deliveries
□ Prioritizes sorting
□ Labels printed
□ Ready in 30 minutes

5:00 PM - HANDOVER
□ Briefs evening shift operator
□ Shares pending issues
□ Logs out
□ Goes home
```

**Average:** 150-200 parcels processed per day per operator

---

### Journey 3: Delivery Rider - Full Cycle

**Persona:** Karim, delivery rider on motorcycle

**Delivery Day:**

```
8:00 AM - ARRIVAL
□ Arrives at Uttara SC
□ Opens mobile app
□ Checks in (GPS tracked)
□ Sees assignment: 35 parcels
□ Reviews delivery map

8:30 AM - LOADING
□ Goes to assigned area
□ Scans manifest QR
□ App shows list of 35 parcels
□ Scans each parcel while loading
□ App confirms each scan
□ All 35 loaded
□ Departure confirmed in app

9:00 AM - ROUTE STARTS
□ App shows optimized route
□ First stop: Sector 10, House 23
□ 10 minutes away
□ Navigates using app

9:10 AM - FIRST DELIVERY
□ Arrives at address
□ Calls customer: "I'm here"
□ Customer comes down
□ Verifies parcel number
□ COD: ৳500
□ Customer pays cash
□ Karim counts
□ Scans parcel in app
□ Records COD: ৳500, Cash
□ Takes photo of customer with parcel
□ Customer signs on phone screen
□ App marks "Delivered"
□ Customer gets SMS confirmation
□ Karim moves to next stop

10:00 AM - DELIVERY #5
□ Customer not home
□ Calls customer
□ No answer
□ Tries again
□ Still no answer
□ Marks "Delivery Failed"
□ Reason: "Customer not available"
□ Takes photo of gate
□ Adds note: "Will retry tomorrow"
□ Keeps parcel for return

11:30 AM - MIDWAY REVIEW
□ 20 delivered
□ 1 failed
□ 14 remaining
□ COD collected: ৳7,500
□ On schedule

12:30 PM - LUNCH BREAK
□ 30 minutes

1:00 PM - AFTERNOON DELIVERIES
□ Continues route
□ Some areas farther
□ Traffic moderate
□ All go smoothly

3:00 PM - PROBLEM DELIVERY
□ Address unclear
□ Landmark mentioned doesn't exist
□ Calls customer
□ Customer guides over phone
□ Finds correct address
□ Updates address in app
□ Completes delivery
□ AI learns from correction

4:30 PM - ROUTE COMPLETE
□ 34 delivered successfully
□ 1 failed delivery
□ Total COD: ৳12,500
□ Returns to sorting center

5:00 PM - COD SETTLEMENT
□ Meets accountant
□ Hands over ৳12,500
□ Accountant counts
□ Verifies against app
□ Matches ✓
□ Commission: ৳1,250 (10%)
□ Karim receives commission
□ Returns failed delivery parcel
□ Logs off from app

5:30 PM - DAY COMPLETE
□ Reviews performance in app
□ Success rate: 97% (34/35)
□ Customer rating: 4.9/5
□ Goes home
```

**Monthly:** ~800 deliveries, ৳80,000 COD handled, ৳8,000 commission earned

---

## Business Rules

### Rule 1: Parcel Acceptance
```
ACCEPT if:
✓ Valid QR code
✓ Tracking number exists in DBK system
✓ Not marked as delivered already
✓ Within weight/size limits
✓ Proper packaging
✓ Address is readable

REJECT if:
✗ Invalid tracking number
✗ Damaged beyond acceptable limit
✗ Hazardous materials
✗ Prohibited items
✗ Missing or unclear address
```

### Rule 2: Routing Priority
```
1. DIRECT DELIVERY (Highest Priority)
   - Distance < 5km
   - Same-day delivery possible
   - No intermediate center

2. SINGLE HOP
   - Distance 5-20km
   - Sub-center exists
   - Next-day delivery

3. MULTI HOP
   - Distance > 20km
   - Multiple centers involved
   - 2-3 day delivery

4. THIRD-PARTY
   - Outside coverage area
   - Specialized handling (heavy/fragile)
   - Partner has better service
```

### Rule 3: COD Limits
```
Maximum COD per parcel: ৳50,000
Minimum COD: ৳50

Special approvals required for:
- COD > ৳50,000
- Jewelry/valuables
- Electronics > ৳30,000
```

### Rule 4: Delivery Attempts
```
First Attempt: Same day or next day
Second Attempt: +1 day (if first fails)
Third Attempt: +1 day (if second fails)

After 3 Failed Attempts:
→ Mark as "Return to Sender"
→ Notify client
→ Start return process
```

### Rule 5: Return Policy
```
Return if:
- Customer refuses
- Address incorrect
- Customer not available (3 attempts)
- Customer requests return
- Parcel damaged during transit

Return within: 7 days of original receipt
Return to: Address specified by client (usually DBK kiosk)
```

### Rule 6: Working Hours
```
Sorting Centers:
Primary Hubs: 6 AM - 11 PM (7 days)
Secondary Hubs: 8 AM - 10 PM (7 days)
Delivery Hubs: 8 AM - 8 PM (6 days, closed Friday)

Delivery Hours:
9 AM - 7 PM (avoid early morning/late evening)
Friday: 2 PM - 7 PM (after Jummah prayer)
```

---

## Key Performance Indicators (KPIs)

### Operational KPIs

```
1. PARCEL THROUGHPUT
   Target: 50,000 parcels/day (system-wide)
   Current: Track daily

2. SORTING ACCURACY
   Target: > 99%
   Measure: Correct destination / Total sorted

3. AVERAGE SORTING TIME
   Target: < 5 minutes per parcel
   Measure: From scan to bin placement

4. DELIVERY SUCCESS RATE
   Target: > 95%
   Measure: Delivered / Total attempted
   First-attempt success: > 85%

5. AVERAGE DELIVERY TIME
   Same area: < 24 hours
   Different city: < 48 hours
   Long distance: < 72 hours
```

### Financial KPIs

```
1. COD COLLECTION RATE
   Target: > 90%
   Measure: Collected / Expected

2. SETTLEMENT ACCURACY
   Target: 100%
   Measure: Discrepancies / Total settlements

3. REVENUE PER PARCEL
   Target: ৳30 average
   Measure: Total revenue / Parcels delivered

4. COST PER DELIVERY
   Target: < ৳20
   Measure: Operating costs / Deliveries
```

### Customer Satisfaction KPIs

```
1. CUSTOMER RATING
   Target: > 4.5 / 5.0
   Measure: Customer feedback

2. COMPLAINT RATE
   Target: < 2%
   Measure: Complaints / Total deliveries

3. RETURN RATE
   Target: < 5%
   Measure: Returns / Total deliveries

4. ON-TIME DELIVERY
   Target: > 92%
   Measure: Delivered on time / Total delivered
```

### System Performance KPIs

```
1. SYSTEM UPTIME
   Target: > 99.5%
   Measure: Available time / Total time

2. TRACKING ACCURACY
   Target: 100%
   Measure: Correct status updates

3. RESPONSE TIME
   Target: < 2 seconds per scan
   Measure: Scan to confirmation time
```

---

## Conclusion

This business architecture provides a complete view of how the DigiBox Logistics Sorting Center system operates from a functional and operational perspective. The system is designed to:

1. **Simplify Operations** - Guided workflows for all users
2. **Increase Efficiency** - Automated routing, intelligent sorting
3. **Ensure Accuracy** - Validation at every step, barcode tracking
4. **Provide Visibility** - Real-time tracking for all stakeholders
5. **Enable Scaling** - Easy to add new centers and areas
6. **Support Growth** - Analytics-driven decision making

The modular design allows for phased implementation, starting with core features and adding advanced capabilities over time.

---

**Next Steps for Stakeholders:**

1. **Management:** Review business flows and approve approach
2. **Operations:** Provide feedback on workflows
3. **Finance:** Validate COD and settlement processes
4. **IT Team:** Begin technical implementation based on this blueprint
5. **Training Team:** Develop training materials based on user journeys

---

**Document Version:** 1.0
**Last Updated:** March 2026
**Prepared by:** DigiBox Logistics Business Analysis Team