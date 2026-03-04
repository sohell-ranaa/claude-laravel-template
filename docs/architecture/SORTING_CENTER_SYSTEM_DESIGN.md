# Sorting Center System Design
**Date**: March 2, 2026
**Version**: 1.0
**Focus**: Sorting Center Component Only

---

## 1. Business Story (Corrected)

### Overview
Digibox Logistics operates sorting centers that organize and sort parcels for the Digibox Kiosk network. Sorting centers do NOT deliver parcels to customers - they only process, sort, and prepare parcels for kiosk collection.

### The Journey

#### Forward Flow (Bank → Customer)

**Step 1: Bank to Kiosk Notification**
- BRAC Bank receives parcel for customer
- Bank notifies Digibox Kiosk system via notification

**Step 2: Kiosk Pre-Data to Sorting Center**
- Kiosk system sends parcel data to Sorting Center via API (BEFORE physical parcels arrive)
- Data includes: tracking number, customer address, size, weight, destination info
- Sorting Center receives and stores this pre-data

**Step 3: Physical Parcel Transfer**
- Kiosk sends rider to pick up physical parcels from bank
- Rider delivers physical parcels to Sorting Center
- Sorting Center receives bulk delivery from kiosk rider

**Step 4: Sorting Center Processing**
- Staff scans QR code on each parcel
- AI-based routing system analyzes:
  - Customer address
  - Lat/Long coordinates
  - Nearby landmarks
  - Destination analysis
- System assigns destination KIOSK location (NOT customer address)
- System assigns BOX NUMBER based on destination kiosk
- Parcels are physically organized into boxes grouped by kiosk location

**Step 5: Sorted Data to Kiosk System**
- Sorting Center sends sorted information to Kiosk system via API
- Data includes: tracking numbers, assigned kiosk locations, box numbers, parcel groupings
- Kiosk system now knows which parcels are in which boxes at which sorting center

**Step 6: Kiosk Collection**
- Kiosk sends rider to Sorting Center
- Rider collects specific boxes for their kiosk location
- Takes boxes back to kiosk facility

**Step 7: Final Delivery**
- Kiosk system handles final customer delivery
- Customer picks up from kiosk or kiosk delivers to customer
- Sorting Center is NOT involved in this step

#### Return Flow (Customer → Sorting Center)

**Step 1: Return Request**
- Customer wants to return parcel
- Customer goes to nearest kiosk with parcel

**Step 2: Kiosk to Sorting Center API**
- Kiosk system sends return parcel data to Sorting Center via API
- Data includes: parcel ID, kiosk location, return reason
- System identifies nearest sorting center (pre-stored in QR code data)

**Step 3: Return Collection**
- Sorting Center sends rider to kiosk location
- Rider collects return parcels
- Returns to sorting center for processing

**Step 4: Return Processing**
- Sorting Center scans return parcel
- Routes to nearest return center (data from QR code)
- Updates status in system

---

## 2. Sorting Center Core Functions

### Primary Responsibilities
1. ✅ Receive pre-data from Kiosk system (API)
2. ✅ Receive physical parcels from kiosk riders
3. ✅ Scan and process parcels with AI routing
4. ✅ Organize parcels into boxes by destination KIOSK
5. ✅ Send sorted data back to Kiosk system (API)
6. ✅ Prepare boxes for kiosk rider collection
7. ✅ Handle return parcel requests from kiosks
8. ✅ Collect and process return parcels

### What Sorting Center Does NOT Do
- ❌ Deliver parcels to customers directly
- ❌ Store parcels long-term
- ❌ Handle customer complaints
- ❌ Manage kiosk inventory
- ❌ Process customer payments

---

## 3. Database Schema Design

### 3.1 Kiosk Locations Table
**Purpose**: Store all Digibox Kiosk locations for box-to-kiosk mapping

```sql
CREATE TABLE kiosk_locations (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    kiosk_code VARCHAR(50) UNIQUE NOT NULL,
    kiosk_name VARCHAR(255) NOT NULL,
    address TEXT NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    district VARCHAR(100),
    zone VARCHAR(100),
    contact_phone VARCHAR(20),
    contact_email VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    operating_hours JSON, -- {"monday": "9:00-18:00", ...}
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_district (district),
    INDEX idx_zone (zone),
    INDEX idx_active (is_active)
);
```

### 3.2 Parcel Pre-Data Table
**Purpose**: Store parcel information received from Kiosk API before physical parcels arrive

```sql
CREATE TABLE parcel_pre_data (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    tracking_number VARCHAR(100) UNIQUE NOT NULL,
    sorting_center_id BIGINT UNSIGNED NOT NULL,

    -- Customer info from kiosk
    customer_name VARCHAR(255) NOT NULL,
    customer_phone VARCHAR(20) NOT NULL,
    customer_address TEXT NOT NULL,
    customer_latitude DECIMAL(10, 8),
    customer_longitude DECIMAL(11, 8),
    customer_landmarks TEXT,

    -- Parcel details
    weight_kg DECIMAL(8, 2),
    dimensions_cm VARCHAR(50), -- "30x20x15"
    parcel_type VARCHAR(50), -- document, package, fragile
    cod_amount DECIMAL(10, 2) DEFAULT 0,

    -- Source info
    source_kiosk_code VARCHAR(50),
    source_bank_branch VARCHAR(255),

    -- Status tracking
    received_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    physical_received_at TIMESTAMP NULL, -- When actual parcel scanned
    status ENUM('pre_data_received', 'physical_received', 'sorted', 'dispatched') DEFAULT 'pre_data_received',

    -- Foreign keys
    FOREIGN KEY (sorting_center_id) REFERENCES sorting_centers(id) ON DELETE CASCADE,

    INDEX idx_tracking (tracking_number),
    INDEX idx_center (sorting_center_id),
    INDEX idx_status (status),
    INDEX idx_received (received_at)
);
```

### 3.3 Box Configuration Table
**Purpose**: Configure boxes and their assigned destination kiosks

```sql
CREATE TABLE box_configurations (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    sorting_center_id BIGINT UNSIGNED NOT NULL,
    box_number VARCHAR(50) NOT NULL,
    box_label VARCHAR(100), -- "Box A1 - Dhaka Central Kiosk"

    -- Destination kiosk assignment
    assigned_kiosk_id BIGINT UNSIGNED,
    assigned_kiosk_code VARCHAR(50),
    assigned_kiosk_name VARCHAR(255),

    -- Box capacity
    max_capacity INT DEFAULT 100,
    current_count INT DEFAULT 0,

    -- Box status
    status ENUM('available', 'in_use', 'full', 'dispatched') DEFAULT 'available',
    last_used_at TIMESTAMP NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (sorting_center_id) REFERENCES sorting_centers(id) ON DELETE CASCADE,
    FOREIGN KEY (assigned_kiosk_id) REFERENCES kiosk_locations(id) ON DELETE SET NULL,

    UNIQUE KEY unique_box_per_center (sorting_center_id, box_number),
    INDEX idx_kiosk (assigned_kiosk_id),
    INDEX idx_status (status)
);
```

### 3.4 AI Routing Results Table
**Purpose**: Store AI analysis results for parcel routing

```sql
CREATE TABLE ai_routing_results (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    parcel_pre_data_id BIGINT UNSIGNED NOT NULL,
    tracking_number VARCHAR(100) NOT NULL,

    -- AI Analysis input
    customer_address TEXT NOT NULL,
    customer_latitude DECIMAL(10, 8),
    customer_longitude DECIMAL(11, 8),
    customer_landmarks TEXT,

    -- AI Analysis output
    recommended_kiosk_id BIGINT UNSIGNED,
    recommended_kiosk_code VARCHAR(50),
    confidence_score DECIMAL(5, 2), -- 0-100%
    analysis_details JSON, -- AI reasoning, nearby landmarks, distance calculations

    -- Alternative options (if any)
    alternative_kiosks JSON, -- [{"kiosk_id": 2, "distance": 1.5}, ...]

    -- Final assignment
    assigned_box_id BIGINT UNSIGNED,
    assigned_box_number VARCHAR(50),

    -- Timestamps
    analyzed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    assigned_at TIMESTAMP NULL,

    FOREIGN KEY (parcel_pre_data_id) REFERENCES parcel_pre_data(id) ON DELETE CASCADE,
    FOREIGN KEY (recommended_kiosk_id) REFERENCES kiosk_locations(id) ON DELETE SET NULL,
    FOREIGN KEY (assigned_box_id) REFERENCES box_configurations(id) ON DELETE SET NULL,

    INDEX idx_parcel (parcel_pre_data_id),
    INDEX idx_tracking (tracking_number),
    INDEX idx_kiosk (recommended_kiosk_id)
);
```

### 3.5 Sorted Parcels Table
**Purpose**: Track parcels after sorting is complete

```sql
CREATE TABLE sorted_parcels (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    tracking_number VARCHAR(100) UNIQUE NOT NULL,
    sorting_center_id BIGINT UNSIGNED NOT NULL,

    -- Box assignment
    box_id BIGINT UNSIGNED NOT NULL,
    box_number VARCHAR(50) NOT NULL,

    -- Destination kiosk
    destination_kiosk_id BIGINT UNSIGNED NOT NULL,
    destination_kiosk_code VARCHAR(50) NOT NULL,
    destination_kiosk_name VARCHAR(255) NOT NULL,

    -- Sorting details
    sorted_by_user_id BIGINT UNSIGNED,
    sorted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Dispatch tracking
    dispatch_status ENUM('sorted', 'ready_for_pickup', 'dispatched', 'delivered_to_kiosk') DEFAULT 'sorted',
    dispatched_at TIMESTAMP NULL,
    delivered_to_kiosk_at TIMESTAMP NULL,

    -- QR code data
    qr_code_data TEXT, -- JSON with all parcel info including return center
    return_center_id BIGINT UNSIGNED, -- Nearest sorting center for returns

    FOREIGN KEY (sorting_center_id) REFERENCES sorting_centers(id) ON DELETE CASCADE,
    FOREIGN KEY (box_id) REFERENCES box_configurations(id) ON DELETE RESTRICT,
    FOREIGN KEY (destination_kiosk_id) REFERENCES kiosk_locations(id) ON DELETE RESTRICT,
    FOREIGN KEY (sorted_by_user_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (return_center_id) REFERENCES sorting_centers(id) ON DELETE SET NULL,

    INDEX idx_tracking (tracking_number),
    INDEX idx_box (box_id),
    INDEX idx_kiosk (destination_kiosk_id),
    INDEX idx_dispatch_status (dispatch_status),
    INDEX idx_sorted_at (sorted_at)
);
```

### 3.6 Return Parcels Table
**Purpose**: Track return parcels from kiosks

```sql
CREATE TABLE return_parcels (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    original_tracking_number VARCHAR(100) NOT NULL,
    return_tracking_number VARCHAR(100) UNIQUE NOT NULL,

    -- Source information
    return_from_kiosk_id BIGINT UNSIGNED NOT NULL,
    return_from_kiosk_code VARCHAR(50) NOT NULL,
    return_reason VARCHAR(255),

    -- Destination (nearest sorting center from QR)
    return_to_center_id BIGINT UNSIGNED NOT NULL,

    -- Return status
    status ENUM('requested', 'pickup_scheduled', 'collected', 'received', 'processed') DEFAULT 'requested',
    requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    collected_at TIMESTAMP NULL,
    received_at TIMESTAMP NULL,
    processed_at TIMESTAMP NULL,

    -- Staff tracking
    collected_by_rider_id BIGINT UNSIGNED,
    processed_by_user_id BIGINT UNSIGNED,

    FOREIGN KEY (return_from_kiosk_id) REFERENCES kiosk_locations(id) ON DELETE CASCADE,
    FOREIGN KEY (return_to_center_id) REFERENCES sorting_centers(id) ON DELETE CASCADE,
    FOREIGN KEY (collected_by_rider_id) REFERENCES riders(id) ON DELETE SET NULL,
    FOREIGN KEY (processed_by_user_id) REFERENCES users(id) ON DELETE SET NULL,

    INDEX idx_original_tracking (original_tracking_number),
    INDEX idx_return_tracking (return_tracking_number),
    INDEX idx_kiosk (return_from_kiosk_id),
    INDEX idx_center (return_to_center_id),
    INDEX idx_status (status)
);
```

### 3.7 Kiosk API Logs Table
**Purpose**: Log all API communications with Kiosk system

```sql
CREATE TABLE kiosk_api_logs (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    sorting_center_id BIGINT UNSIGNED NOT NULL,

    -- API details
    api_type ENUM('receive_pre_data', 'send_sorted_data', 'receive_return_request', 'other') NOT NULL,
    endpoint VARCHAR(255),
    http_method VARCHAR(10),

    -- Request/Response
    request_payload JSON,
    response_payload JSON,
    http_status_code INT,

    -- Timing
    requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    response_time_ms INT,

    -- Status
    success BOOLEAN DEFAULT FALSE,
    error_message TEXT,

    FOREIGN KEY (sorting_center_id) REFERENCES sorting_centers(id) ON DELETE CASCADE,

    INDEX idx_center (sorting_center_id),
    INDEX idx_api_type (api_type),
    INDEX idx_requested_at (requested_at),
    INDEX idx_success (success)
);
```

---

## 4. API Specifications

### 4.1 API 1: Receive Pre-Data from Kiosk System

**Endpoint**: `POST /api/v1/sorting-centers/{center_id}/parcels/pre-data`

**Purpose**: Kiosk system sends parcel information BEFORE physical parcels arrive

**Authentication**: API Key from Kiosk system

**Request Payload**:
```json
{
  "tracking_number": "DGX2024030200001",
  "customer": {
    "name": "Abdul Rahman",
    "phone": "+8801712345678",
    "address": "House 45, Road 12, Dhanmondi, Dhaka",
    "latitude": 23.7461,
    "longitude": 90.3742,
    "landmarks": "Near Dhanmondi Lake, Opposite Shanta Tower"
  },
  "parcel": {
    "weight_kg": 2.5,
    "dimensions_cm": "30x20x15",
    "type": "package",
    "cod_amount": 1500.00
  },
  "source": {
    "kiosk_code": "KIOSK-DHK-01",
    "bank_branch": "BRAC Bank, Dhanmondi Branch"
  },
  "expected_arrival": "2026-03-02T14:00:00Z"
}
```

**Response**:
```json
{
  "success": true,
  "message": "Pre-data received successfully",
  "data": {
    "pre_data_id": 12345,
    "tracking_number": "DGX2024030200001",
    "status": "pre_data_received",
    "sorting_center": {
      "id": 1,
      "code": "SC-DHK-01",
      "name": "Dhaka Central Sorting Center"
    },
    "received_at": "2026-03-02T10:30:00Z"
  }
}
```

**Error Responses**:
- `400`: Invalid payload
- `401`: Unauthorized (invalid API key)
- `409`: Duplicate tracking number
- `500`: Server error

---

### 4.2 API 2: Send Sorted Data to Kiosk System

**Endpoint**: `POST /api/v1/kiosk/parcels/sorted-data`

**Purpose**: Sorting Center sends sorted information after processing parcels

**Authentication**: API Key from Sorting Center

**Request Payload**:
```json
{
  "sorting_center": {
    "id": 1,
    "code": "SC-DHK-01",
    "name": "Dhaka Central Sorting Center"
  },
  "sorted_at": "2026-03-02T15:30:00Z",
  "total_parcels": 150,
  "boxes": [
    {
      "box_number": "A1",
      "destination_kiosk": {
        "id": 5,
        "code": "KIOSK-DHK-CENTRAL",
        "name": "Dhaka Central Kiosk",
        "address": "123 Main Street, Dhaka"
      },
      "parcel_count": 45,
      "parcels": [
        {
          "tracking_number": "DGX2024030200001",
          "customer_name": "Abdul Rahman",
          "customer_phone": "+8801712345678",
          "cod_amount": 1500.00,
          "sorted_at": "2026-03-02T15:25:00Z"
        }
        // ... more parcels
      ]
    }
    // ... more boxes
  ],
  "ready_for_pickup": true,
  "pickup_instructions": "Please collect boxes A1-A5 from loading bay 2"
}
```

**Response**:
```json
{
  "success": true,
  "message": "Sorted data received successfully",
  "data": {
    "batch_id": "BATCH-2024030215",
    "total_parcels_accepted": 150,
    "total_boxes": 5,
    "pickup_scheduled_at": "2026-03-02T18:00:00Z",
    "rider_assigned": {
      "rider_id": 23,
      "rider_name": "Kamal Hossain",
      "rider_phone": "+8801798765432"
    }
  }
}
```

---

### 4.3 API 3: Receive Return Requests from Kiosk System

**Endpoint**: `POST /api/v1/sorting-centers/{center_id}/parcels/return-requests`

**Purpose**: Kiosk system notifies Sorting Center about return parcels

**Authentication**: API Key from Kiosk system

**Request Payload**:
```json
{
  "original_tracking_number": "DGX2024030200001",
  "return_tracking_number": "RET-DGX2024030200001",
  "return_from": {
    "kiosk_id": 5,
    "kiosk_code": "KIOSK-DHK-CENTRAL",
    "kiosk_name": "Dhaka Central Kiosk",
    "address": "123 Main Street, Dhaka",
    "latitude": 23.7461,
    "longitude": 90.3742
  },
  "return_reason": "Customer refused delivery",
  "customer_notes": "Address was incorrect",
  "requested_at": "2026-03-02T16:00:00Z",
  "return_center_id": 1,
  "pickup_required": true
}
```

**Response**:
```json
{
  "success": true,
  "message": "Return request received",
  "data": {
    "return_id": 789,
    "return_tracking_number": "RET-DGX2024030200001",
    "status": "pickup_scheduled",
    "pickup_scheduled_at": "2026-03-03T10:00:00Z",
    "assigned_rider": {
      "rider_id": 12,
      "rider_name": "Rahim Miah",
      "rider_phone": "+8801756789012"
    }
  }
}
```

---

## 5. UI/Feature Specifications

### 5.1 Pre-Data Dashboard
**Route**: `/sorting-centers/{id}/pre-data`

**Features**:
- Real-time list of parcels with pre-data received from kiosk API
- Filter by: date, kiosk source, status
- Color coding:
  - 🟡 Yellow: Pre-data received, waiting for physical parcel
  - 🟢 Green: Physical parcel received and scanned
  - 🔵 Blue: Sorted and assigned to box
- Click to view full customer address and landmarks
- Bulk actions: Mark as received, flag missing parcels

**Columns**:
- Tracking Number
- Customer Name
- Source Kiosk
- Expected Arrival
- Status
- Actions

---

### 5.2 Scanning Interface
**Route**: `/sorting-centers/{id}/scan`

**Features**:
- QR code scanner (camera or barcode reader)
- Real-time feedback on scan
- Display customer address immediately after scan
- Show AI routing recommendation:
  - Recommended destination kiosk
  - Confidence score
  - Alternative options (if confidence < 80%)
- Box assignment interface:
  - Auto-suggest box based on kiosk
  - Show current box capacity
  - Allow manual override
- Print box label after assignment
- Bulk scanning mode (scan multiple parcels rapidly)

**UI Flow**:
1. Scan QR code
2. System displays customer details + AI recommendation
3. Staff confirms or selects different kiosk
4. System assigns box number
5. Print label
6. Parcel placed in box
7. Ready for next scan

---

### 5.3 Box Management Dashboard
**Route**: `/sorting-centers/{id}/boxes`

**Features**:
- Visual grid of all boxes with status colors:
  - 🟢 Green: Available
  - 🟡 Yellow: In use (< 80% full)
  - 🔴 Red: Full (≥ 80% or max capacity)
  - 🔵 Blue: Dispatched
- Click box to see:
  - Assigned destination kiosk
  - Current parcel count
  - List of tracking numbers in box
  - Estimated pickup time
- Configure boxes:
  - Assign/reassign kiosks to boxes
  - Set capacity limits
  - Create new boxes
  - Deactivate boxes
- Export box contents as PDF for kiosk rider

**Box Card Design**:
```
┌─────────────────────────┐
│  Box A1                 │
│  ✓ Dhaka Central Kiosk  │
│  📦 45 / 100 parcels    │
│  [View Details]         │
└─────────────────────────┘
```

---

### 5.4 Kiosk-to-Box Mapping Configuration
**Route**: `/sorting-centers/{id}/kiosk-mapping`

**Features**:
- Table showing all kiosk locations
- Drag-and-drop interface to assign kiosks to boxes
- Multi-box assignment for high-volume kiosks
- Visual map showing kiosk locations relative to sorting center
- Set default boxes for frequently used kiosks
- History of previous assignments

**Table Columns**:
- Kiosk Code
- Kiosk Name
- District/Zone
- Assigned Boxes
- Average Daily Volume
- Last Used
- Actions (Edit, View History)

---

### 5.5 Dispatch Preparation Dashboard
**Route**: `/sorting-centers/{id}/dispatch`

**Features**:
- Group parcels by destination kiosk
- Show which boxes are ready for pickup
- Generate dispatch report:
  - Box list
  - Parcel count per box
  - COD total per box
  - Destination kiosk details
- Print labels for kiosk rider
- Mark boxes as "Dispatched" after pickup
- Record rider details who collected
- Send sorted data to Kiosk API (with confirmation)

**Dispatch Report Format**:
```
Dispatch Report - Batch #BATCH-2024030215
Sorting Center: Dhaka Central (SC-DHK-01)
Date: March 2, 2026 - 3:30 PM

Destination: Dhaka Central Kiosk (KIOSK-DHK-CENTRAL)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Boxes: A1, A2, A3
Total Parcels: 145
Total COD Amount: BDT 89,500.00

Box A1 (50 parcels):
  - DGX2024030200001, Abdul Rahman, COD: 1,500
  - DGX2024030200002, Fatima Begum, COD: 2,200
  ... (list continues)

Rider: Kamal Hossain (+8801798765432)
Pickup Time: 6:00 PM
```

---

### 5.6 Return Parcels Dashboard
**Route**: `/sorting-centers/{id}/returns`

**Features**:
- List of return requests received from kiosk API
- Filter by: status, kiosk, date range
- Assign rider for return collection
- Track return pickup status
- Scan return parcels when received
- Route to appropriate return center (from QR data)
- Generate return reports

**Return Status Flow**:
1. 🟡 Requested (from kiosk API)
2. 🟠 Pickup Scheduled (rider assigned)
3. 🔵 Collected (rider picked up from kiosk)
4. 🟢 Received (scanned at sorting center)
5. ✅ Processed (routed to return center)

---

### 5.7 AI Routing Analytics Dashboard
**Route**: `/sorting-centers/{id}/analytics/routing`

**Features**:
- AI routing accuracy metrics:
  - Success rate (% correctly routed)
  - Average confidence score
  - Manual override rate
- Top destination kiosks (by volume)
- Geographic heat map of customer addresses
- Routing time trends (how long sorting takes)
- Box utilization metrics
- Bottleneck identification (which kiosks cause delays)

**Charts**:
- Line chart: Daily parcel volume by kiosk
- Pie chart: Distribution across kiosks
- Bar chart: AI confidence scores distribution
- Heat map: Customer address clustering

---

### 5.8 API Integration Logs
**Route**: `/sorting-centers/{id}/api-logs`

**Features**:
- Real-time log of all API calls with kiosk system
- Filter by: API type, status, date range
- Color coding:
  - 🟢 Green: Success (200-299)
  - 🔴 Red: Error (400-599)
  - 🟡 Yellow: Pending/Retry
- View request/response payloads
- Retry failed API calls
- Error rate dashboard
- API performance metrics (response time)

---

## 6. QR Code Data Structure

### QR Code JSON Format
Each parcel QR code must contain:

```json
{
  "tracking_number": "DGX2024030200001",
  "sorting_center": {
    "id": 1,
    "code": "SC-DHK-01",
    "name": "Dhaka Central Sorting Center"
  },
  "customer": {
    "name": "Abdul Rahman",
    "phone": "+8801712345678",
    "address": "House 45, Road 12, Dhanmondi, Dhaka",
    "latitude": 23.7461,
    "longitude": 90.3742
  },
  "destination_kiosk": {
    "id": 5,
    "code": "KIOSK-DHK-CENTRAL",
    "name": "Dhaka Central Kiosk"
  },
  "box_assignment": {
    "box_id": 12,
    "box_number": "A1",
    "assigned_at": "2026-03-02T15:25:00Z"
  },
  "return_center": {
    "id": 1,
    "code": "SC-DHK-01",
    "name": "Dhaka Central Sorting Center",
    "distance_km": 0,
    "note": "Same as origin center"
  },
  "cod_amount": 1500.00,
  "weight_kg": 2.5,
  "created_at": "2026-03-02T10:30:00Z"
}
```

**Critical Field**: `return_center` - Pre-stored during sorting for efficient returns

---

## 7. System Workflows

### Workflow 1: Normal Forward Processing

```
1. Kiosk API → Sorting Center API (pre-data)
   ↓ Store in parcel_pre_data table

2. Kiosk Rider → Sorting Center (physical parcels)
   ↓ Bulk delivery

3. Staff scans QR code
   ↓ Match with pre-data
   ↓ Update physical_received_at

4. AI Routing Engine analyzes address
   ↓ Recommend destination kiosk
   ↓ Store in ai_routing_results table

5. Staff confirms/overrides kiosk selection
   ↓ Assign box number
   ↓ Update box_configurations (increment count)
   ↓ Create record in sorted_parcels table

6. Generate QR code with return_center data
   ↓ Print box label

7. Staff places parcel in assigned box
   ↓ Mark status as 'sorted'

8. When box is full or end of shift:
   ↓ Generate dispatch report
   ↓ Call API 2: Send sorted data to Kiosk
   ↓ Mark boxes as 'ready_for_pickup'

9. Kiosk rider arrives
   ↓ Verify boxes against dispatch report
   ↓ Mark boxes as 'dispatched'
   ↓ Update sorted_parcels status to 'delivered_to_kiosk'
   ↓ Reset box_configurations (current_count = 0)
```

### Workflow 2: Return Processing

```
1. Kiosk API → Sorting Center API (return request)
   ↓ Store in return_parcels table
   ↓ Status: 'requested'

2. Manager assigns rider for pickup
   ↓ Update status to 'pickup_scheduled'

3. Rider goes to kiosk location
   ↓ Collects return parcel
   ↓ Updates status to 'collected' (via mobile app)

4. Rider returns to sorting center
   ↓ Staff scans return parcel QR code
   ↓ System reads return_center data from QR
   ↓ Update status to 'received'

5. Route to return center
   ↓ If same center: process locally
   ↓ If different center: prepare for transfer
   ↓ Update status to 'processed'

6. Update original parcel status
   ↓ Notify kiosk system via API
```

---

## 8. Livewire Components to Build

### Priority: HIGH (Core Functionality)

1. **PreDataDashboard.php**
   - Route: `/sorting-centers/{id}/pre-data`
   - Shows parcels with pre-data received
   - Real-time updates via Livewire polling

2. **ScanningInterface.php**
   - Route: `/sorting-centers/{id}/scan`
   - QR scanner integration
   - AI routing display
   - Box assignment

3. **BoxManagement.php**
   - Route: `/sorting-centers/{id}/boxes`
   - Visual box grid
   - Configuration interface
   - Box-to-kiosk mapping

4. **DispatchPreparation.php**
   - Route: `/sorting-centers/{id}/dispatch`
   - Group by kiosk
   - Generate reports
   - API integration to send sorted data

5. **ReturnParcels.php**
   - Route: `/sorting-centers/{id}/returns`
   - Return requests list
   - Rider assignment
   - Status tracking

### Priority: MEDIUM (Analytics & Management)

6. **KioskMapping.php**
   - Route: `/sorting-centers/{id}/kiosk-mapping`
   - Kiosk configuration
   - Default box assignments

7. **RoutingAnalytics.php**
   - Route: `/sorting-centers/{id}/analytics/routing`
   - Charts and metrics
   - AI performance tracking

8. **ApiLogs.php**
   - Route: `/sorting-centers/{id}/api-logs`
   - API call history
   - Error monitoring

---

## 9. Migration Files Needed

1. `create_kiosk_locations_table.php`
2. `create_parcel_pre_data_table.php`
3. `create_box_configurations_table.php`
4. `create_ai_routing_results_table.php`
5. `create_sorted_parcels_table.php`
6. `create_return_parcels_table.php`
7. `create_kiosk_api_logs_table.php`

---

## 10. Next Steps

### Phase 1: Database Setup (Days 1-2)
- [ ] Create all migration files
- [ ] Run migrations
- [ ] Create Eloquent models
- [ ] Set up model relationships

### Phase 2: API Development (Days 3-5)
- [ ] Build API controller for receiving pre-data (API 1)
- [ ] Build API controller for sending sorted data (API 2)
- [ ] Build API controller for return requests (API 3)
- [ ] Add API authentication middleware
- [ ] Create API log service

### Phase 3: Core Livewire Components (Days 6-10)
- [ ] Build PreDataDashboard component
- [ ] Build ScanningInterface component
- [ ] Build BoxManagement component
- [ ] Build DispatchPreparation component
- [ ] Build ReturnParcels component

### Phase 4: AI Routing Integration (Days 11-13)
- [ ] Design AI routing algorithm
- [ ] Integrate geocoding service
- [ ] Build confidence scoring system
- [ ] Add manual override capability

### Phase 5: Testing & Refinement (Days 14-15)
- [ ] Test full workflow end-to-end
- [ ] Test API integrations
- [ ] Load testing for scanning interface
- [ ] Fix bugs and optimize

---

## 11. Technical Stack

**Backend**:
- Laravel 11.x
- Livewire v4.2
- MySQL 8.0+
- Queue system (for API calls)

**Frontend**:
- Tailwind CSS
- Alpine.js (minimal, only for scanner)
- Chart.js (for analytics)

**APIs**:
- RESTful JSON APIs
- API Key authentication
- Rate limiting
- Request/Response logging

**QR Code**:
- QR code generation library
- JSON payload in QR
- Scanner integration (HTML5 camera API)

**AI Routing** (Future):
- Geocoding API (Google Maps / Mapbox)
- Distance calculation algorithms
- Machine learning model (optional enhancement)

---

**End of Document**
