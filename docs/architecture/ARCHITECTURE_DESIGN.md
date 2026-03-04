# DigiBox Logistics - Sorting Center System
## Comprehensive Microservice Architecture Design

**Version:** 1.0
**Date:** March 2026
**Technology Stack:** Laravel 11, MySQL 8.0, Redis, Laravel Queue

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [System Overview](#system-overview)
3. [Microservices Architecture](#microservices-architecture)
4. [Queue Architecture](#queue-architecture-laravel-queue--horizon)
5. [Database Design](#database-design)
6. [API Design](#api-design)
7. [Routing & Sorting Algorithm](#routing--sorting-algorithm)
8. [Label & Sticker Printing](#label--sticker-printing)
9. [Integration Architecture](#integration-architecture)
10. [Reporting & Analytics](#reporting--analytics)
11. [Security & Compliance](#security--compliance)
12. [Deployment Architecture](#deployment-architecture)
13. [Implementation Roadmap](#implementation-roadmap)

---

## Executive Summary

This document outlines a comprehensive microservice-based logistics sorting center system for DigiBox Logistics. The system supports multi-tenant sorting centers across Bangladesh, intelligent routing, multi-layer sorting, third-party logistics integration, and comprehensive tracking capabilities.

### Key Features
- Multi-tenant sorting center management
- AI-powered intelligent routing
- Multi-layer sorting (hub-to-hub, hub-to-delivery)
- QR-based parcel tracking
- Automated label generation
- Third-party logistics integration
- COD payment management
- Real-time analytics and reporting

---

## System Overview

### Business Flow

```
DigiBox Kiosk (DBK) → Sorting Center (Layer 1) → Sub-Sorting Center (Layer 2) → Delivery
                                                → Third-Party Logistics
                                                → Direct Delivery
```

### Core Components

1. **Sorting Center Management** - Multi-tenant center deployment
2. **Parcel Tracking** - End-to-end parcel lifecycle management
3. **Routing Engine** - AI-powered intelligent routing
4. **Label Generation** - QR code and routing label creation
5. **Rider Management** - Assignment and tracking
6. **Integration Hub** - External client APIs
7. **Accounting** - COD and payment reconciliation
8. **Analytics** - Real-time reporting and insights

---

## Microservices Architecture

### 1. Sorting Center Management Service

**Responsibility:** Manage sorting center lifecycle, configuration, and operations

**Key Features:**
- Create/deploy new sorting centers
- Manage geo-boundaries and coverage areas
- Configure multi-layer sorting rules
- Manage employees, managers, and access control
- Center-specific settings and workflows

**Technology:**
- Laravel 11 (API)
- MySQL (primary data)
- Redis (caching)

**Database Tables:**
```sql
- sorting_centers
- sorting_center_coverage_areas
- sorting_center_employees
- sorting_center_configurations
- sorting_center_routing_rules
```

---

### 2. Parcel Tracking Service

**Responsibility:** Track parcel lifecycle from intake to delivery

**Key Features:**
- Parcel registration and validation
- Status tracking (received, sorted, in-transit, delivered, returned)
- Event logging and audit trail
- Real-time location tracking
- Customer notifications

**Technology:**
- Laravel 11 (API)
- MySQL (transactional data)
- Redis (real-time status cache)
- Laravel Queue (event streaming)

**Database Tables:**
```sql
- parcels
- parcel_events
- parcel_tracking_history
- parcel_metadata
- parcel_validations
```

**Event Flow:**
```
RECEIVED → VALIDATED → SORTED → IN_TRANSIT →
  ├─ DELIVERED
  ├─ RETURNED
  ├─ TRANSFERRED_TO_THIRD_PARTY
  └─ TRANSFERRED_TO_SUB_CENTER
```

---

### 3. Routing & Sorting Engine Service

**Responsibility:** Intelligent routing and sorting decisions

**Key Features:**
- AI-powered destination matching
- Landmark-based geo-location matching
- Multi-layer routing logic
- Dynamic route optimization
- Sorting center capacity management

**Technology:**
- Laravel 11 (API)
- Python/FastAPI (AI/ML service)
- MySQL (routing rules)
- Redis (geo-cache)
- Google Maps API / Barikoi API (Bangladesh-specific)

**Database Tables:**
```sql
- routing_rules
- destination_landmarks
- sorting_zones
- geo_boundaries
- routing_history
```

**AI Algorithm:**
```
1. Parse destination address
2. Extract landmarks using NLP
3. Match against known landmarks database
4. Calculate geo-distance to sorting centers
5. Check coverage boundaries
6. Apply routing rules (direct/sub-center/third-party)
7. Return optimal route
```

---

### 4. Label & Sticker Generation Service

**Responsibility:** Generate printable labels and QR codes

**Key Features:**
- QR code generation with embedded routing data
- Thermal printer-compatible labels (4x6 inch)
- Routing instruction labels
- Return address labels
- Batch printing support

**Technology:**
- Laravel 11 (API)
- barryvdh/laravel-dompdf (PDF generation)
- simplesoftwareio/simple-qrcode (QR codes)
- TCPDF (thermal printer format)

**Database Tables:**
```sql
- labels
- label_templates
- print_jobs
- print_history
```

**Label Format:**
```
┌────────────────────────────┐
│ QR Code    [DigiBox Logo]  │
│                            │
│ Tracking: DBL-2026-001234  │
│ From: Mohammadpur SC       │
│ To: Uttara SC / Direct     │
│                            │
│ Destination:               │
│ House 12, Road 5           │
│ Uttara, Dhaka-1230         │
│                            │
│ Return: Mohammadpur SC     │
│ COD: ৳500 [if applicable]  │
└────────────────────────────┘
```

---

### 5. Rider Management Service

**Responsibility:** Manage riders and delivery assignments

**Key Features:**
- Rider registration and profiles
- Zone-based rider assignment
- Capacity and availability management
- Performance tracking
- Route optimization

**Technology:**
- Laravel 11 (API)
- MySQL (rider data)
- Redis (availability cache)

**Database Tables:**
```sql
- riders
- rider_assignments
- rider_zones
- rider_performance
- delivery_attempts
```

---

### 6. Integration Hub Service

**Responsibility:** External client integration (DBK, third-party logistics)

**Key Features:**
- Webhook management
- API authentication and rate limiting
- Data transformation and mapping
- Event publishing (parcel status updates)
- Third-party logistics API integration

**Technology:**
- Laravel 11 (API Gateway)
- Laravel Queue (async messaging)
- Redis (rate limiting, queue backend)

**Integrations:**
```
1. DigiBox Kiosk (DBK) API
   - Validate incoming parcels
   - Send status updates
   - Delivery confirmations

2. Third-Party Logistics
   - Sundarban Courier
   - SA Paribahan
   - Pathao Courier

3. Payment Gateways (for COD)
   - bKash
   - Nagad
   - Bank transfers
```

**Database Tables:**
```sql
- api_clients
- webhooks
- api_logs
- integration_configs
- third_party_shipments
```

---

### 7. Accounting Service

**Responsibility:** COD payment management and reconciliation

**Key Features:**
- COD collection tracking
- Rider settlement
- Client payout management
- Transaction ledger
- Reconciliation reports

**Technology:**
- Laravel 11 (API)
- MySQL (financial data - encrypted)
- Redis (session cache)

**Database Tables:**
```sql
- cod_collections
- rider_settlements
- client_payouts
- transactions
- ledger_entries
- reconciliation_records
```

**COD Flow:**
```
1. Parcel delivered with COD
2. Rider collects cash
3. Record collection in app
4. Rider deposits at sorting center
5. Sorting center verifies
6. Settlement processed
7. Client payout initiated
```

---

### 8. Notification Service

**Responsibility:** Multi-channel notifications

**Key Features:**
- SMS notifications (Bulk SMS BD)
- Email notifications
- Push notifications
- WhatsApp Business API
- Configurable templates

**Technology:**
- Laravel 11 (API)
- Laravel Queue (async processing)
- Redis (queue backend)

**Database Tables:**
```sql
- notifications
- notification_templates
- notification_logs
- user_preferences
```

---

### 9. Reporting & Analytics Service

**Responsibility:** Business intelligence and insights

**Key Features:**
- Real-time dashboards
- Sorting center performance metrics
- Delivery success rates
- Revenue analytics
- SLA monitoring
- Custom report generation

**Technology:**
- Laravel 11 (API)
- MySQL (analytical queries)
- Redis (metrics cache)
- Chart.js / ApexCharts (frontend)

**Database Tables:**
```sql
- daily_metrics
- sorting_center_performance
- delivery_analytics
- revenue_reports
- sla_tracking
```

**Key Metrics:**
```
- Parcels received per day/center
- Sorting time averages
- Delivery success rate
- Return rate
- COD collection rate
- Rider performance
- Center capacity utilization
```

---

### 10. Queue Architecture (Laravel Queue + Horizon)

**Responsibility:** Asynchronous job processing and event handling

**Key Features:**
- Background job processing
- Event-driven communication between services
- Failed job retry mechanism
- Queue monitoring and metrics
- Auto-scaling workers based on load

**Technology:**
- Laravel Queue (core framework)
- Laravel Horizon (monitoring and management)
- Redis (queue backend)

**Queue Configuration:**
```php
// config/queue.php
'connections' => [
    'redis' => [
        'driver' => 'redis',
        'connection' => 'default',
        'queue' => env('REDIS_QUEUE', 'default'),
        'retry_after' => 90,
        'block_for' => null,
    ],
],

// config/horizon.php
'defaults' => [
    'supervisor-1' => [
        'connection' => 'redis',
        'queue' => ['default', 'high', 'low'],
        'balance' => 'auto',
        'processes' => 10,
        'tries' => 3,
        'timeout' => 60,
    ],
],
```

**Queue Types:**
```
1. high - Critical operations
   - Parcel status updates
   - Webhook deliveries
   - Payment processing

2. default - Standard operations
   - Label generation
   - Email notifications
   - Report generation

3. low - Background tasks
   - Analytics processing
   - Data cleanup
   - Log archiving
```

**Example Jobs:**
```php
// Send webhook notification
dispatch(new SendWebhookJob($parcel, 'delivered'))->onQueue('high');

// Generate label in background
dispatch(new GenerateLabelJob($parcel))->onQueue('default');

// Process analytics
dispatch(new ProcessDailyAnalytics($date))->onQueue('low');

// Chain jobs
Bus::chain([
    new ReceiveParcel($tracking),
    new CalculateRoute($tracking),
    new GenerateLabel($tracking),
    new NotifyClient($tracking),
])->dispatch();
```

**Event-Driven Architecture:**
```php
// Dispatch events
event(new ParcelReceived($parcel));
event(new ParcelSorted($parcel));
event(new ParcelDelivered($parcel));

// Listeners (automatically queued)
class SendClientWebhook implements ShouldQueue
{
    public function handle(ParcelDelivered $event)
    {
        // Send webhook to client
        Http::post($webhookUrl, $event->parcel->toArray());
    }
}
```

**Monitoring with Horizon:**
- Real-time queue metrics
- Job throughput monitoring
- Failed job management
- Worker supervision
- Auto-scaling based on queue depth

**Database Tables:**
```sql
- jobs
- failed_jobs
- job_batches
```

---

## Database Design

### Core Schema Design

#### 1. Sorting Centers

```sql
CREATE TABLE sorting_centers (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    type ENUM('primary', 'secondary', 'delivery_hub') NOT NULL,
    address TEXT NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    contact_phone VARCHAR(20),
    contact_email VARCHAR(255),
    manager_id BIGINT UNSIGNED,
    capacity_per_day INT DEFAULT 1000,
    status ENUM('active', 'inactive', 'maintenance') DEFAULT 'active',
    operational_hours JSON,
    settings JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_status (status),
    INDEX idx_type (type),
    SPATIAL INDEX idx_location (latitude, longitude)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

#### 2. Coverage Areas (Geo-Boundaries)

```sql
CREATE TABLE sorting_center_coverage_areas (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    sorting_center_id BIGINT UNSIGNED NOT NULL,
    area_name VARCHAR(255) NOT NULL,
    area_type ENUM('district', 'upazila', 'thana', 'postcode', 'custom') NOT NULL,
    boundary_polygon POLYGON NOT NULL,
    postcodes JSON,
    landmarks JSON,
    priority INT DEFAULT 1,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (sorting_center_id) REFERENCES sorting_centers(id) ON DELETE CASCADE,
    SPATIAL INDEX idx_boundary (boundary_polygon),
    INDEX idx_sorting_center (sorting_center_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

#### 3. Parcels

```sql
CREATE TABLE parcels (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    tracking_number VARCHAR(50) UNIQUE NOT NULL,
    client_id BIGINT UNSIGNED NOT NULL,
    client_reference VARCHAR(100),

    -- Sender Information
    sender_name VARCHAR(255) NOT NULL,
    sender_phone VARCHAR(20) NOT NULL,
    sender_address TEXT NOT NULL,

    -- Recipient Information
    recipient_name VARCHAR(255) NOT NULL,
    recipient_phone VARCHAR(20) NOT NULL,
    recipient_address TEXT NOT NULL,
    recipient_latitude DECIMAL(10, 8),
    recipient_longitude DECIMAL(11, 8),
    recipient_landmark VARCHAR(255),

    -- Parcel Details
    weight_kg DECIMAL(8, 2),
    dimensions_cm VARCHAR(50),
    package_type ENUM('document', 'parcel', 'fragile', 'perishable') DEFAULT 'parcel',
    declared_value DECIMAL(10, 2),

    -- Payment
    payment_type ENUM('prepaid', 'cod') DEFAULT 'prepaid',
    cod_amount DECIMAL(10, 2) DEFAULT 0,
    cod_collected BOOLEAN DEFAULT FALSE,

    -- Status
    current_status ENUM('pending_validation', 'validated', 'received', 'sorted',
                        'in_transit', 'out_for_delivery', 'delivered',
                        'returned', 'cancelled') NOT NULL,
    current_location_id BIGINT UNSIGNED,
    current_location_type ENUM('sorting_center', 'rider', 'third_party'),

    -- Routing
    origin_sorting_center_id BIGINT UNSIGNED,
    destination_sorting_center_id BIGINT UNSIGNED,
    final_delivery_center_id BIGINT UNSIGNED,
    routing_path JSON,

    -- Timestamps
    received_at TIMESTAMP NULL,
    sorted_at TIMESTAMP NULL,
    delivered_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX idx_tracking (tracking_number),
    INDEX idx_status (current_status),
    INDEX idx_client (client_id),
    INDEX idx_origin (origin_sorting_center_id),
    INDEX idx_destination (destination_sorting_center_id),
    INDEX idx_received_at (received_at),
    FULLTEXT idx_addresses (sender_address, recipient_address)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

#### 4. Parcel Events

```sql
CREATE TABLE parcel_events (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    parcel_id BIGINT UNSIGNED NOT NULL,
    event_type VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL,
    description TEXT,
    location_id BIGINT UNSIGNED,
    location_type ENUM('sorting_center', 'rider', 'third_party'),
    user_id BIGINT UNSIGNED,
    metadata JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (parcel_id) REFERENCES parcels(id) ON DELETE CASCADE,
    INDEX idx_parcel (parcel_id),
    INDEX idx_event_type (event_type),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

#### 5. Routing Rules

```sql
CREATE TABLE routing_rules (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    sorting_center_id BIGINT UNSIGNED NOT NULL,
    rule_name VARCHAR(255) NOT NULL,
    rule_type ENUM('direct_delivery', 'sub_center', 'third_party', 'hub_transfer') NOT NULL,

    -- Conditions
    conditions JSON NOT NULL, -- distance, weight, destination, etc.
    priority INT DEFAULT 1,

    -- Actions
    action_config JSON NOT NULL, -- route_to, assign_to, etc.

    is_active BOOLEAN DEFAULT TRUE,
    effective_from DATE,
    effective_to DATE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (sorting_center_id) REFERENCES sorting_centers(id) ON DELETE CASCADE,
    INDEX idx_sorting_center (sorting_center_id),
    INDEX idx_priority (priority)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

#### 6. Labels

```sql
CREATE TABLE labels (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    parcel_id BIGINT UNSIGNED NOT NULL,
    label_type ENUM('shipping', 'return', 'routing', 'cod') NOT NULL,
    qr_code_data TEXT NOT NULL,
    qr_code_path VARCHAR(255),
    label_data JSON NOT NULL,
    template_id BIGINT UNSIGNED,
    generated_by BIGINT UNSIGNED,
    printed_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (parcel_id) REFERENCES parcels(id) ON DELETE CASCADE,
    INDEX idx_parcel (parcel_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

#### 7. Riders

```sql
CREATE TABLE riders (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(255),
    assigned_sorting_center_id BIGINT UNSIGNED,
    vehicle_type ENUM('bicycle', 'motorcycle', 'van', 'truck') NOT NULL,
    vehicle_number VARCHAR(50),

    -- Capacity
    max_parcels_per_trip INT DEFAULT 50,
    max_weight_kg DECIMAL(8, 2) DEFAULT 100,

    -- Status
    status ENUM('active', 'inactive', 'on_duty', 'off_duty') DEFAULT 'active',
    current_location_lat DECIMAL(10, 8),
    current_location_lng DECIMAL(11, 8),

    -- Performance
    total_deliveries INT DEFAULT 0,
    successful_deliveries INT DEFAULT 0,
    rating DECIMAL(3, 2) DEFAULT 5.00,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (assigned_sorting_center_id) REFERENCES sorting_centers(id) ON DELETE SET NULL,
    INDEX idx_status (status),
    INDEX idx_sorting_center (assigned_sorting_center_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

#### 8. COD Collections

```sql
CREATE TABLE cod_collections (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    parcel_id BIGINT UNSIGNED NOT NULL,
    rider_id BIGINT UNSIGNED NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    collection_method ENUM('cash', 'bkash', 'nagad', 'card') NOT NULL,
    collected_at TIMESTAMP NOT NULL,
    deposited_at TIMESTAMP NULL,
    sorting_center_id BIGINT UNSIGNED,
    verified_by BIGINT UNSIGNED,
    settlement_id BIGINT UNSIGNED,
    status ENUM('collected', 'deposited', 'verified', 'settled') NOT NULL,
    notes TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (parcel_id) REFERENCES parcels(id) ON DELETE CASCADE,
    FOREIGN KEY (rider_id) REFERENCES riders(id) ON DELETE CASCADE,
    INDEX idx_status (status),
    INDEX idx_rider (rider_id),
    INDEX idx_collected_at (collected_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

---

## API Design

### REST API Standards

**Base URL:** `https://api.digibox-logistics.com/v1`

**Authentication:** Bearer Token (Laravel Sanctum)

**Response Format:**
```json
{
  "success": true,
  "data": {},
  "message": "Success message",
  "meta": {
    "timestamp": "2026-03-01T10:00:00Z",
    "version": "1.0"
  }
}
```

### Core API Endpoints

#### 1. Sorting Center Management

```http
POST   /sorting-centers
GET    /sorting-centers
GET    /sorting-centers/{id}
PUT    /sorting-centers/{id}
DELETE /sorting-centers/{id}
POST   /sorting-centers/{id}/coverage-areas
GET    /sorting-centers/{id}/performance
```

#### 2. Parcel Operations

```http
POST   /parcels/validate
POST   /parcels/receive
GET    /parcels/{tracking_number}
PUT    /parcels/{id}/status
POST   /parcels/{id}/sort
POST   /parcels/bulk-receive
GET    /parcels/search
```

**Example: Receive Parcel**
```http
POST /api/v1/parcels/receive
Content-Type: application/json
Authorization: Bearer {token}

{
  "tracking_number": "DBK-2026-001234",
  "scanning_center_id": 1,
  "scanned_by": 101,
  "qr_code_data": "encrypted_qr_string",
  "notes": "Package in good condition"
}

Response:
{
  "success": true,
  "data": {
    "parcel_id": 12345,
    "tracking_number": "DBK-2026-001234",
    "status": "received",
    "routing_recommendation": {
      "destination_center_id": 5,
      "destination_center_name": "Uttara Sorting Center",
      "route_type": "hub_transfer",
      "estimated_distance_km": 12.5
    }
  }
}
```

#### 3. Routing & Sorting

```http
POST   /routing/calculate
POST   /routing/sort-batch
GET    /routing/rules
POST   /routing/rules
PUT    /routing/rules/{id}
```

**Example: Calculate Route**
```http
POST /api/v1/routing/calculate
Content-Type: application/json

{
  "parcel_id": 12345,
  "destination_address": "House 12, Road 5, Sector 10, Uttara, Dhaka-1230",
  "current_center_id": 1
}

Response:
{
  "success": true,
  "data": {
    "recommended_route": {
      "type": "hub_transfer",
      "next_hop": {
        "center_id": 5,
        "center_name": "Uttara Sorting Center",
        "distance_km": 12.5
      },
      "final_destination": {
        "type": "direct_delivery",
        "center_id": 5
      },
      "ai_confidence": 0.95,
      "matched_landmarks": ["Uttara Sector 10", "Rajlakshmi Complex"]
    }
  }
}
```

#### 4. Label Generation

```http
POST   /labels/generate
POST   /labels/bulk-generate
GET    /labels/{id}/download
POST   /labels/print
```

#### 5. Rider Management

```http
POST   /riders/assign
GET    /riders/available
PUT    /riders/{id}/location
GET    /riders/{id}/deliveries
POST   /riders/{id}/collect-cod
```

#### 6. Integration APIs (for DBK)

```http
POST   /integrations/dbk/validate-parcel
POST   /integrations/dbk/webhooks/delivery-update
GET    /integrations/third-party/tracking/{awb}
POST   /integrations/third-party/handover
```

#### 7. Analytics & Reports

```http
GET    /analytics/dashboard
GET    /analytics/sorting-centers/{id}/performance
GET    /reports/daily-summary
GET    /reports/cod-collections
POST   /reports/custom
```

---

## Routing & Sorting Algorithm

### AI-Powered Intelligent Routing

**Algorithm Flow:**

```python
def calculate_optimal_route(parcel):
    # Step 1: Parse destination address
    parsed_address = parse_address_nlp(parcel.recipient_address)

    # Step 2: Extract landmarks and location identifiers
    landmarks = extract_landmarks(parsed_address)
    district = parsed_address.district
    upazila = parsed_address.upazila
    postcode = parsed_address.postcode

    # Step 3: Geocode if coordinates not available
    if not parcel.recipient_latitude:
        coords = geocode_address(parcel.recipient_address)
        parcel.recipient_latitude = coords.lat
        parcel.recipient_longitude = coords.lng

    # Step 4: Find matching sorting centers
    matching_centers = find_centers_by_coverage(
        latitude=parcel.recipient_latitude,
        longitude=parcel.recipient_longitude,
        district=district,
        postcode=postcode
    )

    # Step 5: Apply routing rules
    current_center = parcel.current_location
    routing_rules = get_routing_rules(current_center.id)

    # Step 6: Calculate optimal route
    if matching_centers:
        # Check if multi-layer routing needed
        if matching_centers[0].id != current_center.id:
            # Hub transfer needed
            return {
                'type': 'hub_transfer',
                'next_hop': matching_centers[0],
                'final_destination': matching_centers[0]
            }
        else:
            # Direct delivery
            return {
                'type': 'direct_delivery',
                'next_hop': current_center,
                'assign_rider': True
            }
    else:
        # Check third-party logistics rules
        third_party = check_third_party_coverage(district)
        if third_party:
            return {
                'type': 'third_party_handover',
                'partner': third_party
            }

        # Fallback: nearest center
        nearest = find_nearest_center(
            parcel.recipient_latitude,
            parcel.recipient_longitude
        )
        return {
            'type': 'hub_transfer',
            'next_hop': nearest
        }
```

### AI/ML Components

**Technology Stack:**
- **NLP:** spaCy with custom Bangladesh address corpus
- **Geocoding:** Barikoi API (Bangladesh-specific) + Google Maps API
- **ML Model:** TensorFlow/Keras for address classification
- **Training Data:** Historical delivery data, Bangladesh postal codes

**Features:**
```
1. Address parsing and normalization
2. Landmark extraction (Dhaka University, Bashundhara City, etc.)
3. District/Upazila classification
4. Postcode prediction for incomplete addresses
5. Similar address matching
6. Route optimization based on traffic patterns
```

---

## Label & Sticker Printing

### QR Code Structure

```json
{
  "tracking": "DBL-2026-001234",
  "origin_sc": "MDP-001",
  "dest_sc": "UTT-005",
  "routing": "MDP→UTT→DIRECT",
  "cod": 500,
  "return_sc": "MDP-001",
  "checksum": "a4f32c9b"
}
```

### Label Templates

**1. Shipping Label (4x6 inch)**
```php
// Laravel Controller
public function generateShippingLabel(Parcel $parcel)
{
    $qrCode = QrCode::size(200)
        ->generate(json_encode([
            'tracking' => $parcel->tracking_number,
            'origin_sc' => $parcel->originSortingCenter->code,
            'dest_sc' => $parcel->destinationSortingCenter->code,
            'routing' => $parcel->routing_path,
            'cod' => $parcel->cod_amount,
        ]));

    $pdf = PDF::loadView('labels.shipping', [
        'parcel' => $parcel,
        'qrCode' => $qrCode
    ]);

    return $pdf->setPaper([0, 0, 288, 432], 'portrait') // 4x6 inch
               ->download("label-{$parcel->tracking_number}.pdf");
}
```

**2. Thermal Printer Integration**
```php
// ZPL (Zebra Programming Language) for thermal printers
public function generateZPLLabel(Parcel $parcel)
{
    $zpl = "^XA
        ^FO50,50^BQN,2,10^FDQA,{$parcel->tracking_number}^FS
        ^FO300,50^FD{$parcel->tracking_number}^FS
        ^FO50,250^FDFrom: {$parcel->originSortingCenter->name}^FS
        ^FO50,300^FDTo: {$parcel->destinationSortingCenter->name}^FS
        ^FO50,400^FD{$parcel->recipient_name}^FS
        ^FO50,450^FD{$parcel->recipient_phone}^FS
        ^FO50,500^FD{$parcel->recipient_address}^FS
        ^FO50,600^FDCOD: BDT {$parcel->cod_amount}^FS
        ^XZ";

    return response($zpl)->header('Content-Type', 'application/x-zpl');
}
```

---

## Integration Architecture

### 1. DigiBox Kiosk (DBK) Integration

**Authentication:** API Key + HMAC Signature

**Webhook Events:**
```
parcel.validated
parcel.received
parcel.sorted
parcel.in_transit
parcel.out_for_delivery
parcel.delivered
parcel.returned
cod.collected
```

**Example Webhook Payload:**
```json
{
  "event": "parcel.delivered",
  "timestamp": "2026-03-01T15:30:00Z",
  "data": {
    "tracking_number": "DBK-2026-001234",
    "client_reference": "DBK-ORDER-9876",
    "status": "delivered",
    "delivered_at": "2026-03-01T15:25:00Z",
    "delivered_to": "Mr. Rahman",
    "signature_url": "https://cdn.digibox.com/signatures/xyz.jpg",
    "rider": {
      "name": "Karim Ahmed",
      "phone": "01712345678"
    },
    "cod": {
      "collected": true,
      "amount": 500,
      "method": "cash"
    }
  },
  "signature": "sha256_hmac_signature"
}
```

### 2. Third-Party Logistics Integration

**Supported Partners:**
```
- Sundarban Courier
- SA Paribahan
- Pathao Courier
- Paperfly
- Steadfast
```

**Integration Flow:**
```
1. Check if destination outside coverage
2. Find partner with coverage
3. Create shipment via partner API
4. Get partner AWB number
5. Print partner label
6. Handover parcel
7. Track via partner API
8. Sync status updates
```

---

## Reporting & Analytics

### Real-Time Dashboards

**1. Sorting Center Dashboard**
```
- Parcels received today
- Parcels sorted today
- Parcels in-transit
- Pending deliveries
- Average sorting time
- Center capacity utilization
- Top destinations
```

**2. Operations Dashboard**
```
- Active sorting centers
- Total parcels in system
- Delivery success rate
- Return rate
- Average delivery time
- SLA compliance
- Rider performance
```

**3. Financial Dashboard**
```
- COD collected today
- Pending settlements
- Revenue by client
- Revenue by center
- Outstanding payments
```

### Standard Reports

```sql
-- Daily Summary Report
SELECT
    sc.name AS sorting_center,
    DATE(p.received_at) AS date,
    COUNT(*) AS total_received,
    SUM(CASE WHEN p.current_status = 'delivered' THEN 1 ELSE 0 END) AS delivered,
    SUM(CASE WHEN p.current_status = 'returned' THEN 1 ELSE 0 END) AS returned,
    SUM(p.cod_amount) AS total_cod,
    SUM(CASE WHEN p.cod_collected THEN p.cod_amount ELSE 0 END) AS cod_collected
FROM parcels p
JOIN sorting_centers sc ON p.origin_sorting_center_id = sc.id
WHERE DATE(p.received_at) = CURDATE()
GROUP BY sc.id, DATE(p.received_at);
```

---

## Security & Compliance

### Security Measures

**1. API Security**
```
- JWT/Sanctum token authentication
- Rate limiting (100 req/min)
- IP whitelisting for integrations
- HMAC signature verification
- Request validation and sanitization
```

**2. Data Security**
```
- Encryption at rest (AES-256)
- Encryption in transit (TLS 1.3)
- PII data masking in logs
- Role-based access control (RBAC)
- Audit logging
```

**3. Compliance**
```
- Data retention policy (7 years)
- GDPR-like privacy controls
- PCI DSS for payment data
- Regular security audits
- Penetration testing
```

### Role-Based Access Control

```php
// Roles
- super_admin (full access)
- center_manager (center-specific)
- sorting_operator (receive, sort)
- rider (delivery, collection)
- accountant (financial data)
- api_client (integration)

// Permissions
- parcels.receive
- parcels.sort
- parcels.deliver
- labels.generate
- reports.view
- reports.financial
- settings.manage
```

---

## Deployment Architecture

### Infrastructure

```
┌─────────────────────────────────────────────────┐
│               Load Balancer (Nginx)             │
└─────────────────────────────────────────────────┘
                       │
        ┌──────────────┴──────────────┐
        │                             │
┌───────▼────────┐           ┌────────▼───────┐
│  API Gateway   │           │  Web Frontend  │
│   (Laravel)    │           │   (React/Vue)  │
└───────┬────────┘           └────────────────┘
        │
┌───────▼─────────────────────────────────────────┐
│              Microservices Layer                │
├─────────────────────────────────────────────────┤
│ • Sorting Center Service                        │
│ • Parcel Tracking Service                       │
│ • Routing Engine Service                        │
│ • Label Generation Service                      │
│ • Rider Management Service                      │
│ • Integration Hub Service                       │
│ • Accounting Service                            │
│ • Notification Service                          │
│ • Analytics Service                             │
└───────┬─────────────────────────────────────────┘
        │
┌───────▼─────────────────────────────────────────┐
│              Data Layer                         │
├─────────────────────────────────────────────────┤
│ • MySQL 8.0 (Primary Database)                  │
│ • Redis (Cache + Queue Backend)                 │
│ • Laravel Queue + Horizon (Queue Management)    │
│ • S3/MinIO (Object Storage)                     │
└─────────────────────────────────────────────────┘
```

### Technology Stack Details

**Backend:**
```
- PHP 8.2+
- Laravel 11
- Laravel Octane (performance)
- Laravel Horizon (queue monitoring)
- Laravel Sanctum (auth)
```

**Database:**
```
- MySQL 8.0 (primary)
- Redis 7.0 (cache, queue backend, sessions)
```

**Frontend:**
```
- Vue.js 3 / React 18
- Inertia.js (Laravel integration)
- TailwindCSS
- ApexCharts (analytics)
```

**DevOps:**
```
- Docker + Docker Compose
- Kubernetes (production)
- GitHub Actions (CI/CD)
- Prometheus + Grafana (monitoring)
- ELK Stack (logging)
```

### Deployment Strategy

**Environment Setup:**
```yaml
# docker-compose.yml
version: '3.8'

services:
  app:
    build: .
    volumes:
      - ./:/var/www
    environment:
      - APP_ENV=production
      - CACHE_DRIVER=redis
      - QUEUE_CONNECTION=redis
    depends_on:
      - mysql
      - redis

  mysql:
    image: mysql:8.0
    environment:
      MYSQL_DATABASE: digibox_logistics
      MYSQL_ROOT_PASSWORD: secret
    volumes:
      - mysql-data:/var/lib/mysql

  redis:
    image: redis:7-alpine
    volumes:
      - redis-data:/data

  horizon:
    build: .
    command: php artisan horizon
    volumes:
      - ./:/var/www
    environment:
      - APP_ENV=production
      - QUEUE_CONNECTION=redis
    depends_on:
      - mysql
      - redis

  nginx:
    image: nginx:alpine
    volumes:
      - ./:/var/www
      - ./docker/nginx.conf:/etc/nginx/nginx.conf
    ports:
      - "80:80"
      - "443:443"

volumes:
  mysql-data:
  redis-data:
```

---

## Implementation Roadmap

### Phase 1: Foundation (Weeks 1-4)

**Week 1-2: Infrastructure & Core Services**
```
✓ Setup Laravel microservices structure
✓ Database schema implementation
✓ Authentication & authorization
✓ API gateway setup
✓ Redis + Laravel Queue + Horizon integration
```

**Week 3-4: Core Functionality**
```
✓ Sorting Center Management Service
✓ Parcel Tracking Service (basic)
✓ QR code scanning implementation
✓ Basic label generation
✓ Admin dashboard (basic)
```

### Phase 2: Routing & Sorting (Weeks 5-8)

**Week 5-6: Intelligent Routing**
```
✓ Routing Engine Service
✓ Coverage area management
✓ Basic routing algorithm
✓ Multi-layer sorting logic
✓ Routing rules configuration
```

**Week 7-8: AI Integration**
```
✓ Address parsing NLP model
✓ Landmark extraction
✓ Geocoding integration (Barikoi + Google)
✓ ML-based destination matching
✓ Route optimization
```

### Phase 3: Operations (Weeks 9-12)

**Week 9-10: Rider & Delivery**
```
✓ Rider Management Service
✓ Assignment algorithm
✓ Mobile app for riders
✓ Delivery proof capture
✓ Return handling
```

**Week 11-12: Label & Printing**
```
✓ Advanced label templates
✓ Thermal printer integration
✓ Bulk printing
✓ Label tracking and audit
```

### Phase 4: Integration & Payments (Weeks 13-16)

**Week 13-14: External Integrations**
```
✓ DBK API integration
✓ Webhook system
✓ Third-party logistics APIs
✓ Payment gateway integration
```

**Week 15-16: COD & Accounting**
```
✓ Accounting Service
✓ COD collection workflow
✓ Settlement processing
✓ Reconciliation reports
✓ Financial dashboards
```

### Phase 5: Analytics & Optimization (Weeks 17-20)

**Week 17-18: Reporting**
```
✓ Analytics Service
✓ Real-time dashboards
✓ Standard reports
✓ Custom report builder
✓ Export functionality
```

**Week 19-20: Optimization & Polish**
```
✓ Performance optimization
✓ Caching strategies
✓ Load testing
✓ Security audit
✓ Documentation
```

### Phase 6: Testing & Launch (Weeks 21-24)

**Week 21-22: Testing**
```
✓ Unit tests
✓ Integration tests
✓ End-to-end tests
✓ User acceptance testing
✓ Pilot launch (1 sorting center)
```

**Week 23-24: Production Launch**
```
✓ Production deployment
✓ Training materials
✓ Operator training
✓ Monitoring setup
✓ Support system
```

---

## Performance Targets

### System Performance

```
- API response time: < 200ms (p95)
- Parcel receive processing: < 2 seconds
- Label generation: < 1 second
- Dashboard load time: < 1 second
- Concurrent users: 500+
- Parcels per day: 50,000+
- Database query time: < 100ms (p95)
```

### Business KPIs

```
- Sorting accuracy: > 99%
- Delivery success rate: > 95%
- Average sorting time: < 5 minutes
- SLA compliance: > 98%
- Return rate: < 5%
- COD collection rate: > 90%
- Customer satisfaction: > 4.5/5
```

---

## Monitoring & Observability

### Application Monitoring

```yaml
# Prometheus metrics
- http_requests_total
- http_request_duration_seconds
- parcels_received_total
- parcels_sorted_total
- parcels_delivered_total
- routing_calculation_duration
- label_generation_duration
- database_query_duration
```

### Logging Strategy

```
- Application logs: ELK Stack
- Access logs: Nginx
- Audit logs: MySQL (separate table)
- Error tracking: Sentry
- Performance: New Relic / DataDog
```

---

## Disaster Recovery

### Backup Strategy

```
- Database: Daily full backup + hourly incremental
- Files: Daily backup to S3
- Retention: 30 days online, 1 year archive
- RTO: 4 hours
- RPO: 1 hour
```

### High Availability

```
- Database: Master-slave replication
- Application: Multi-instance with load balancer
- Cache: Redis Sentinel
- Queue: Redis with Horizon (auto-scaling workers)
- Uptime target: 99.9%
```

---

## Documentation Requirements

### Technical Documentation

```
1. API Documentation (OpenAPI/Swagger)
2. Database Schema Documentation
3. Deployment Guide
4. Development Setup Guide
5. Integration Guide
6. Troubleshooting Guide
```

### User Documentation

```
1. Sorting Center Operator Manual
2. Manager Dashboard Guide
3. Rider Mobile App Guide
4. API Client Integration Guide
5. Report Generation Guide
6. System Configuration Guide
```

---

## Cost Estimation

### Infrastructure (Monthly)

```
- AWS EC2 / DigitalOcean: $500
- Database (RDS): $300
- Redis/Cache: $100
- Load Balancer: $100
- S3 Storage: $50
- Monitoring: $100
- Total: ~$1,150/month
```

### External Services

```
- SMS Gateway: BDT 0.25/SMS
- Barikoi API: $50/month
- Google Maps API: Pay-as-you-go
- SSL Certificate: $100/year
```

---

## Success Metrics

### Launch Criteria

```
✓ All core features implemented
✓ 95% test coverage
✓ Security audit passed
✓ Performance targets met
✓ Documentation completed
✓ Pilot successful (1 center, 1 week)
✓ Training completed
✓ Support system ready
```

### Post-Launch Monitoring

```
- Daily active users
- Parcels processed per day
- System uptime
- Error rates
- Customer complaints
- Revenue per center
```

---

## Conclusion

This comprehensive design provides a robust, scalable, and feature-rich logistics sorting center system for DigiBox Logistics. The microservice architecture ensures:

1. **Scalability:** Easy to add new sorting centers
2. **Flexibility:** Configurable routing and sorting rules
3. **Intelligence:** AI-powered routing decisions
4. **Integration:** Seamless client and third-party connections
5. **Visibility:** Comprehensive tracking and analytics
6. **Reliability:** High availability and disaster recovery

The phased implementation approach allows for iterative development and testing, ensuring a stable and production-ready system.

---

## Next Steps

1. Review and approve architecture
2. Setup development environment
3. Create detailed user stories
4. Begin Phase 1 implementation
5. Setup CI/CD pipeline
6. Establish monitoring and alerting

---

**Document Version:** 1.0
**Last Updated:** March 2026
**Author:** DigiBox Logistics Engineering Team
