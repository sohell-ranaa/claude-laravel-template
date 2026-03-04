# Admin Dashboard - Complete User Guide

## Menu Overview

Your admin dashboard has 6 main sections:

### 1. **Main Navigation**
- Dashboard (Home)
- Parcels
- Riders
- COD Management
- Routing
- Settlements

### 2. **Kiosk Integration** (NEW)
- Pre-Data Dashboard
- Scanning Interface
- Box Management
- Dispatch Preparation
- Return Parcels

### 3. **Admin Only** (Super Admin Only)
- Sorting Centers
- User Management

### 4. **My Center** (For Center Managers)
- My Center (view your assigned center)

---

## COMPLETE OPERATIONAL WORKFLOW

Follow this sequence for daily operations:

---

## PHASE 1: SETUP (One-Time Configuration)

### Step 1.1: Configure Sorting Centers
**Menu**: Sorting Centers → Create Center
**Who**: Super Admin only
**When**: Initial setup

**What to do**:
1. Click "Sorting Centers" in sidebar
2. Click "Create Center" button
3. Fill in:
   - Center Name (e.g., "Dhaka Main Center")
   - Center Code (e.g., "DHK-001")
   - Address
   - Latitude/Longitude (for AI routing)
   - Contact Person
   - Phone
   - Email
4. Click "Save"

**Why**: Every operation is linked to a sorting center. You need at least one center.

---

### Step 1.2: Create User Accounts
**Menu**: User Management
**Who**: Super Admin only
**When**: Initial setup

**What to do**:
1. Click "User Management"
2. Click "Create User"
3. Fill in user details
4. Assign Role:
   - **Super Admin**: Can see all centers, manage everything
   - **Center Manager**: Can only see their assigned center
   - **Staff**: Limited permissions
5. For Center Managers: Select their assigned sorting center
6. Click "Save"

**Why**: Different staff need different access levels.

---

### Step 1.3: Configure Box-to-Kiosk Mapping
**Menu**: Kiosk Integration → Box Management
**Who**: Center Manager or Super Admin
**When**: Initial setup or when adding new kiosks

**What to do**:
1. Click "Box Management" under Kiosk Integration
2. You'll see a visual grid of boxes (empty initially)
3. Click "Create Box" button
4. Fill in:
   - **Box Number**: Physical box identifier (e.g., "BOX-A1", "BOX-A2")
   - **Assigned Kiosk**: Select destination kiosk from dropdown
   - **Max Capacity**: How many parcels can fit (e.g., 100)
   - **Status**: Available
5. Click "Save"
6. Repeat for all your physical boxes

**Visual Guide**:
```
Box A1 → Mirpur Kiosk (50 parcels max)
Box A2 → Dhanmondi Kiosk (100 parcels max)
Box B1 → Gulshan Kiosk (75 parcels max)
Box B2 → Uttara Kiosk (100 parcels max)
```

**Why**: Each box is assigned to a specific kiosk location. When you sort parcels, you assign them to boxes based on destination kiosk.

---

### Step 1.4: Add Riders
**Menu**: Riders → Create Rider
**Who**: Center Manager
**When**: As needed

**What to do**:
1. Click "Riders" in sidebar
2. Click "Create Rider"
3. Fill in:
   - Name
   - Phone
   - Vehicle Type (motorcycle/van/truck)
   - License Number
   - Assigned Sorting Center (auto-selected for center managers)
   - Status: Active
4. Click "Save"

**Why**: Riders are needed for picking up return parcels from kiosks.

---

### Step 1.5: Configure Routing Rules (Optional)
**Menu**: Routing
**Who**: Center Manager or Super Admin
**When**: For advanced automation

**What to do**:
1. Click "Routing" in sidebar
2. Click "Create Rule"
3. Configure conditions (e.g., "If destination is Mirpur area")
4. Set action (e.g., "Route to Mirpur Kiosk")
5. Set priority (lower number = higher priority)
6. Click "Save"

**Why**: This helps automate routing decisions, but the AI already suggests kiosks based on distance.

---

## PHASE 2: DAILY OPERATIONS (Main Workflow)

Now follow this sequence EVERY DAY:

---

### Step 2.1: View Pre-Data (Parcels Coming Soon)
**Menu**: Kiosk Integration → Pre-Data Dashboard
**Who**: Center Manager/Staff
**When**: Morning - Check what's coming today

**What happens**:
- Kiosk system sends parcel information BEFORE physical parcels arrive
- This is API 1: Kiosk → Sorting Center (pre-data)

**What you see**:
- Statistics cards showing:
  - Total pre-data received
  - Parcels physically received
  - Parcels sorted
  - Parcels dispatched
- Table with upcoming parcels:
  - Tracking number
  - Customer name
  - Customer address
  - COD amount
  - Status

**What to do**:
1. Click "Pre-Data Dashboard"
2. Review the list of incoming parcels
3. Check COD amounts (cash on delivery)
4. Use filters if needed:
   - Search by tracking number or customer name
   - Filter by status
   - Filter by date range

**Actions available**:
- **Mark as Received**: When physical parcel arrives at your center
- **Flag as Missing**: If pre-data exists but physical parcel never arrives

**Why**: This gives you advance notice of what's coming, so you can plan staffing and box allocation.

---

### Step 2.2: Scan & Sort Parcels (Main Activity)
**Menu**: Kiosk Integration → Scanning Interface
**Who**: Sorting Staff
**When**: When physical parcels arrive

**This is the CORE operation of your sorting center!**

**What to do**:

1. Click "Scanning Interface"

2. **Scan QR Code**:
   - Each parcel has a QR code
   - Use QR scanner or manually enter tracking number
   - Click "Scan"

3. **AI Analyzes & Recommends**:
   - System calculates distance from customer address to all kiosks
   - Uses Haversine formula (lat/long distance calculation)
   - Shows recommended kiosk with confidence score:
     - 🟢 **Green (80-100%)**: High confidence, safe to use
     - 🟡 **Yellow (60-79%)**: Medium confidence, review recommended
     - 🟠 **Orange (<60%)**: Low confidence, manual check needed
   - Shows distance in kilometers
   - Shows alternative kiosks if available

4. **Select Box**:
   - System shows available boxes for the recommended kiosk
   - You'll see a visual grid:
     ```
     BOX-A1 (Mirpur Kiosk)    ✅ Available [25/100 parcels]
     BOX-A2 (Dhanmondi)       🟡 In Use [80/100 parcels]
     BOX-B1 (Gulshan)         🔴 Full [100/100 parcels]
     ```
   - Click on the box to assign parcel
   - Box status colors:
     - Green: Available (<70% full)
     - Yellow: In Use (70-90% full)
     - Red: Full (90-100% full)
     - Blue: Dispatched (already sent)

5. **Confirm Assignment**:
   - Review: Tracking number → Kiosk → Box
   - Click "Assign to Box"
   - System creates sorted_parcel record
   - Box current_count increments
   - QR code data is generated (includes return center info)

6. **Repeat** for all parcels

**Example Workflow**:
```
SCAN: TRK-001234
↓
AI SUGGESTS: Mirpur Kiosk (95% confidence, 2.3 km)
↓
SELECT BOX: BOX-A1 (for Mirpur Kiosk)
↓
CONFIRM: Parcel TRK-001234 → Box A1 → Mirpur Kiosk
↓
NEXT PARCEL
```

**Why**: This organizes parcels by destination kiosk and assigns them to physical boxes for transport.

---

### Step 2.3: Monitor Box Status
**Menu**: Kiosk Integration → Box Management
**Who**: Center Manager/Supervisor
**When**: Throughout the day

**What you see**:
- Visual grid of all boxes with real-time status:
  - Box number
  - Assigned kiosk
  - Current count / Max capacity
  - Utilization percentage
  - Status (Available/In Use/Full/Dispatched)

**What to do**:
1. Monitor which boxes are filling up
2. When a box reaches 90-100%, it's ready for dispatch
3. Coordinate with dispatch team
4. If needed, create more boxes for same kiosk

**Why**: Ensures you don't overfill boxes and know when boxes are ready for pickup.

---

### Step 2.4: Dispatch to Kiosk (Send Data)
**Menu**: Kiosk Integration → Dispatch Preparation
**Who**: Dispatch Supervisor
**When**: When boxes are full and ready to send

**This is API 2: Sorting Center → Kiosk System (sorted data)**

**What you see**:
- Parcels grouped by destination kiosk
- Summary for each kiosk:
  - Kiosk name
  - Total parcels
  - Boxes being dispatched
  - Total COD amount
- Dispatch status filters

**What to do**:

1. Click "Dispatch Preparation"

2. **Review Summary**:
   - See which kiosks have parcels ready
   - Example:
     ```
     📦 Mirpur Kiosk: 45 parcels in 2 boxes (BOX-A1, BOX-A2)
        Total COD: ৳12,500

     📦 Dhanmondi Kiosk: 32 parcels in 1 box (BOX-B1)
        Total COD: ৳8,200
     ```

3. **Click "Send to Kiosk"** for a specific kiosk:
   - Modal opens showing full details
   - Lists all parcels with tracking numbers
   - Shows QR code data for each parcel
   - Kiosk API URL (from config)

4. **Confirm Dispatch**:
   - Click "Confirm & Send"
   - System calls Kiosk API with sorted data
   - Kiosk system receives:
     - List of parcels
     - Which box each parcel is in
     - Customer delivery details
     - QR code data
   - Parcels marked as "Dispatched"
   - Boxes marked as "Dispatched"

5. **Physical Handoff**:
   - Print dispatch manifest (if needed)
   - Load boxes onto delivery vehicle
   - Send to respective kiosk locations
   - Kiosk staff receives boxes and data simultaneously

**API Payload Sent to Kiosk**:
```json
{
  "sorting_center_id": 1,
  "dispatch_date": "2026-03-03T10:30:00Z",
  "kiosk_code": "MIR-01",
  "parcels": [
    {
      "tracking_number": "TRK-001234",
      "box_number": "BOX-A1",
      "customer_name": "Ahmed Khan",
      "customer_phone": "01712345678",
      "customer_address": "123 Main St, Mirpur",
      "cod_amount": 500.00,
      "qr_code_data": {
        "tracking": "TRK-001234",
        "destination_kiosk": "MIR-01",
        "box": "BOX-A1",
        "return_center_id": 1
      }
    }
  ]
}
```

**Why**: Kiosk system needs to know what parcels are coming so they can prepare for customer delivery.

---

## PHASE 3: RETURN MANAGEMENT

---

### Step 3.1: Receive Return Requests
**Menu**: Kiosk Integration → Return Parcels
**Who**: Center Manager/Staff
**When**: When kiosk system reports returns

**This is API 3: Kiosk → Sorting Center (return requests)**

**What happens**:
- Customer refuses delivery or wants to return
- Kiosk system creates return request
- API sends return data to your sorting center
- Return routing uses the return_center_id from original QR code

**What you see**:
- Statistics showing:
  - Total returns
  - Requested (new returns)
  - Pickup Scheduled (rider assigned)
  - Collected (picked up from kiosk)
  - Received (arrived at center)
  - Processed (completed)
- Table with return details:
  - Original tracking number
  - Return tracking number
  - Return from which kiosk
  - Reason for return
  - Assigned rider
  - Status

**What to do**:

1. Click "Return Parcels"

2. **View New Returns** (Status: Requested):
   - See which parcels need pickup
   - Note the kiosk location

3. **Assign Rider**:
   - Click "Assign Rider" for a return
   - Select available rider from dropdown
   - Click "Assign"
   - Status changes to "Pickup Scheduled"
   - Rider receives notification (if implemented)

4. **Mark as Collected**:
   - When rider picks up from kiosk
   - Click "Mark Collected"
   - Status → "Collected"
   - Records collection timestamp

5. **Mark as Received**:
   - When rider brings parcel to sorting center
   - Click "Mark Received"
   - Status → "Received"
   - Records receipt timestamp

6. **Mark as Processed**:
   - After you handle the return (refund, restock, etc.)
   - Click "Mark Processed"
   - Status → "Processed"
   - Records who processed it

**5-State Workflow**:
```
Requested → Pickup Scheduled → Collected → Received → Processed
   ↓              ↓                ↓           ↓          ↓
  New      Rider Assigned    At Kiosk    At Center   Complete
```

**Why**: Manages the reverse logistics flow when customers return parcels.

---

## PHASE 4: FINANCIAL MANAGEMENT

---

### Step 4.1: Track COD Collections
**Menu**: COD Management
**Who**: Accounts/Finance Staff
**When**: Daily reconciliation

**What you see**:
- All parcels with COD (Cash on Delivery)
- COD amounts
- Collection status
- Payment reconciliation

**What to do**:
1. Click "COD Management"
2. View COD parcels delivered to kiosks
3. Track which COD amounts have been collected
4. Reconcile with kiosk system payments
5. Mark collections as received

**Why**: Track cash flow and ensure all COD is accounted for.

---

### Step 4.2: Process Settlements
**Menu**: Settlements
**Who**: Finance Manager
**When**: Weekly/Monthly

**What you see**:
- Financial settlements between:
  - Sorting Center ↔ Kiosk System
  - Sorting Center ↔ BRAC Bank
- Settlement amounts
- Outstanding balances
- Payment status

**What to do**:
1. Click "Settlements"
2. Review settlement periods
3. Verify amounts
4. Process payments
5. Mark settlements as completed

**Why**: Financial reconciliation and payment processing.

---

## PHASE 5: MONITORING & ANALYTICS

---

### Step 5.1: Dashboard Overview
**Menu**: Dashboard (Home)
**Who**: Everyone
**When**: Daily morning check

**What you see**:
- **Key Metrics**:
  - Total parcels today
  - Parcels in transit
  - Parcels delivered
  - Active riders
  - Pending returns
  - COD pending

- **Charts**:
  - Parcel trends (7-day graph)
  - Rider performance leaderboard
  - Activity timeline (recent events)

- **Quick Stats**:
  - Today's receiving rate
  - Today's dispatch rate
  - Box utilization
  - Return rate

**What to do**:
1. Start your day here
2. Check overall health of operations
3. Identify bottlenecks
4. Plan staffing accordingly

**Why**: Real-time operational visibility.

---

### Step 5.2: Parcel Management
**Menu**: Parcels
**Who**: Center Manager/Staff
**When**: As needed for tracking

**What you see**:
- Complete list of all parcels
- Advanced filtering:
  - By status
  - By date range
  - By tracking number
  - By customer
  - By kiosk destination

**What to do**:
1. Search for specific parcels
2. View parcel history
3. Track status changes
4. View timeline of events

**Why**: Detailed parcel tracking and customer service.

---

### Step 5.3: Rider Management
**Menu**: Riders
**Who**: Center Manager
**When**: Daily monitoring

**What you see**:
- All riders assigned to your center
- Rider details:
  - Name, phone
  - Vehicle type
  - Active/Inactive status
  - Current assignments
  - Performance metrics

**What to do**:
1. Monitor rider availability
2. Update rider information
3. Deactivate riders (if they leave)
4. View rider performance

**Why**: Manage your delivery/pickup team.

---

## PHASE 6: SYSTEM ADMINISTRATION (Super Admin Only)

---

### Step 6.1: Manage Sorting Centers
**Menu**: Sorting Centers
**Who**: Super Admin only
**When**: As needed

**What you see**:
- All sorting centers in the system
- Center details
- Active/Inactive status

**What to do**:
1. Create new centers (expansion)
2. Edit center information
3. View center performance
4. Assign managers to centers

**Why**: Multi-center management for company growth.

---

### Step 6.2: User Management
**Menu**: User Management
**Who**: Super Admin only
**When**: When adding/removing staff

**What you see**:
- All users in system
- User roles (Super Admin, Center Manager, Staff)
- Assigned centers
- Active/Inactive status

**What to do**:
1. Create new users
2. Assign roles and permissions
3. Assign users to sorting centers
4. Deactivate users
5. Reset passwords

**Why**: Access control and security.

---

## DAILY WORKFLOW SUMMARY

**Morning (8:00 AM)**:
1. ✅ Dashboard → Check overnight metrics
2. ✅ Pre-Data Dashboard → See what's coming today
3. ✅ Box Management → Ensure boxes are ready

**During Day (9:00 AM - 5:00 PM)**:
4. ✅ Scanning Interface → Scan and sort incoming parcels
5. ✅ Box Management → Monitor box fill rates
6. ✅ Dispatch Preparation → Send full boxes to kiosks
7. ✅ Return Parcels → Manage any returns

**Evening (5:00 PM - 6:00 PM)**:
8. ✅ COD Management → Reconcile cash collections
9. ✅ Dashboard → Review day's performance
10. ✅ Riders → Check rider assignments for tomorrow

**Weekly**:
11. ✅ Settlements → Process weekly payments
12. ✅ Routing → Optimize routing rules if needed

---

## ROLE-BASED MENU ACCESS

### Super Admin Sees:
- ✅ Dashboard
- ✅ Parcels
- ✅ Riders
- ✅ COD Management
- ✅ Routing
- ✅ Settlements
- ✅ Kiosk Integration (all 5 screens)
- ✅ **Sorting Centers** (admin only)
- ✅ **User Management** (admin only)
- ❌ My Center (not needed, can access all centers)

### Center Manager Sees:
- ✅ Dashboard (only their center data)
- ✅ Parcels (only their center)
- ✅ Riders (only their center)
- ✅ COD Management (only their center)
- ✅ Routing (only their center)
- ✅ Settlements (only their center)
- ✅ Kiosk Integration (all 5 screens, scoped to their center)
- ✅ **My Center** (view their assigned center)
- ❌ Sorting Centers (can't create new centers)
- ❌ User Management (can't create users)

### Staff Sees:
- ✅ Dashboard (read-only)
- ✅ Kiosk Integration → Scanning Interface (main work)
- ✅ Kiosk Integration → Box Management (read-only)
- ✅ Parcels (read-only)
- ❌ Everything else (limited access)

---

## IMPORTANT NOTES

### Data Flow Direction:
1. **Kiosk → Sorting Center**: Pre-data API (parcels coming)
2. **Sorting Center → Kiosk**: Sorted data API (boxes ready)
3. **Kiosk → Sorting Center**: Return requests API (parcels returning)

### QR Code Structure:
Every parcel gets a QR code containing:
```json
{
  "tracking_number": "TRK-001234",
  "destination_kiosk_code": "MIR-01",
  "box_number": "BOX-A1",
  "return_center_id": 1,
  "customer_name": "Ahmed Khan",
  "customer_phone": "01712345678",
  "cod_amount": 500.00
}
```

The **return_center_id** is critical - it tells kiosk which sorting center to return to if customer refuses delivery.

### Box Assignment Logic:
- ❌ NOT based on customer address
- ✅ Based on destination KIOSK
- Each box is pre-assigned to ONE kiosk
- Parcels going to same kiosk go in same box

### AI Routing Confidence:
- Formula: `max(20, 100 - (distance_in_km × 10))`
- Examples:
  - 1 km away = 90% confidence (green)
  - 3 km away = 70% confidence (yellow)
  - 5 km away = 50% confidence (orange)
  - 8 km away = 20% confidence (orange - manual review!)

---

## TROUBLESHOOTING

**Problem**: Can't see Pre-Data Dashboard
- **Check**: Are you logged in?
- **Check**: Does your user have a sorting_center_id assigned?
- **Solution**: Contact super admin to assign you to a center

**Problem**: No boxes showing in Scanning Interface
- **Solution**: Go to Box Management → Create boxes first
- **Assign**: Each box to a kiosk

**Problem**: AI routing shows 0% confidence
- **Check**: Does kiosk location have latitude/longitude?
- **Check**: Does parcel pre-data have customer latitude/longitude?
- **Solution**: Update kiosk_locations table with coordinates

**Problem**: Can't dispatch to kiosk
- **Check**: Is KIOSK_SYSTEM_API_URL configured in .env?
- **Check**: Are parcels in "sorted" status?
- **Check**: Kiosk API logs for errors

**Problem**: Return parcels not showing
- **Check**: Is kiosk system sending return requests to correct API?
- **Check**: Kiosk API logs table for incoming requests

---

## NEXT STEPS FOR YOU

1. **Login** as Super Admin
2. **Create** your first sorting center
3. **Add** box configurations (start with 5-10 boxes)
4. **Assign** boxes to kiosks
5. **Test** the scanning interface with sample tracking number
6. **Review** the dashboard to see stats update

---

**Need Help?**
- Check `COMPLETE_SYSTEM_SUMMARY.md` for technical details
- Check `KIOSK_API_TESTING.md` for API testing
- Check `USER_GUIDE.md` for end-user documentation

**Your sorting center is ready for production! 🚀**
