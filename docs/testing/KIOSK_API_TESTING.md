# Kiosk API Testing Guide
**Created**: March 2, 2026
**Version**: 1.0

## Overview
This guide provides examples and instructions for testing the three Kiosk API endpoints.

---

## Setup

### 1. Configure API Keys

Add to your `.env` file:

```env
# Kiosk API Keys (Incoming - multiple keys supported, comma-separated)
KIOSK_API_KEYS_INCOMING="test-key-123,prod-key-456,kiosk-primary-789"

# Kiosk System URL (Outgoing - for sending sorted data to kiosk)
KIOSK_SYSTEM_API_URL="https://kiosk.digibox.com/api/v1"
KIOSK_API_KEY_OUTGOING="sorting-center-api-key-xyz"
```

### 2. Create Test Kiosk Location

```sql
INSERT INTO kiosk_locations (kiosk_code, kiosk_name, address, latitude, longitude, district, zone, is_active, created_at, updated_at)
VALUES
('KIOSK-DHK-01', 'Dhaka Central Kiosk', '123 Main Street, Dhanmondi, Dhaka', 23.7461, 90.3742, 'Dhaka', 'Central', 1, NOW(), NOW());
```

### 3. Get Sorting Center ID

```sql
SELECT id, code, name FROM sorting_centers LIMIT 1;
```

Note the ID for testing (e.g., `1`).

---

## API 1: Receive Pre-Data from Kiosk

### Endpoint
```
POST /api/v1/sorting-centers/{center_id}/parcels/pre-data
```

### Headers
```
X-Kiosk-Api-Key: test-key-123
Content-Type: application/json
Accept: application/json
```

### Request Body
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

### cURL Example
```bash
curl -X POST \
  http://localhost:8000/api/v1/sorting-centers/1/parcels/pre-data \
  -H 'X-Kiosk-Api-Key: test-key-123' \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -d '{
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
  }
}'
```

### Expected Response (201 Created)
```json
{
  "success": true,
  "message": "Pre-data received successfully",
  "data": {
    "pre_data_id": 1,
    "tracking_number": "DGX2024030200001",
    "status": "pre_data_received",
    "sorting_center": {
      "id": 1,
      "code": "SC-DHK-01",
      "name": "Dhaka Central Sorting Center"
    },
    "received_at": "2026-03-02T10:30:00+00:00"
  }
}
```

### Error Response (401 Unauthorized)
```json
{
  "success": false,
  "message": "Unauthorized. Invalid or missing API key."
}
```

### Error Response (400 Bad Request)
```json
{
  "success": false,
  "message": "Validation failed",
  "errors": {
    "tracking_number": ["The tracking number has already been taken."],
    "customer.name": ["The customer name field is required."]
  }
}
```

---

## API 2: Send Sorted Data to Kiosk (Internal)

### Endpoint
```
POST /api/sorting-centers/{center_id}/send-sorted-data
```

### Authentication
Requires Sanctum token (staff login)

### Headers
```
Authorization: Bearer {sanctum_token}
Content-Type: application/json
Accept: application/json
```

### Request Body
None (automatically gathers all sorted parcels)

### cURL Example
```bash
curl -X POST \
  http://localhost:8000/api/sorting-centers/1/send-sorted-data \
  -H 'Authorization: Bearer 1|abcd1234...' \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json'
```

### Expected Response (200 OK)
```json
{
  "success": true,
  "message": "Sorted data sent to Kiosk system successfully",
  "data": {
    "total_parcels_sent": 145,
    "kiosk_count": 3,
    "response_time_ms": 432,
    "kiosk_response": {
      "batch_id": "BATCH-2024030215",
      "total_parcels_accepted": 145,
      "total_boxes": 5,
      "pickup_scheduled_at": "2026-03-02T18:00:00Z"
    }
  }
}
```

### Error Response (400 Bad Request)
```json
{
  "success": false,
  "message": "No sorted parcels ready for dispatch"
}
```

### Get Summary Before Sending
```
GET /api/sorting-centers/{center_id}/sorted-parcels-summary
```

Response:
```json
{
  "success": true,
  "data": {
    "total_parcels": 145,
    "by_kiosk": [
      {
        "kiosk_code": "KIOSK-DHK-CENTRAL",
        "kiosk_name": "Dhaka Central Kiosk",
        "parcel_count": 45,
        "boxes": ["A1", "A2"]
      },
      {
        "kiosk_code": "KIOSK-DHK-NORTH",
        "kiosk_name": "Dhaka North Kiosk",
        "parcel_count": 50,
        "boxes": ["B1", "B2", "B3"]
      }
    ]
  }
}
```

---

## API 3: Receive Return Requests from Kiosk

### Endpoint
```
POST /api/v1/sorting-centers/{center_id}/parcels/return-requests
```

### Headers
```
X-Kiosk-Api-Key: test-key-123
Content-Type: application/json
Accept: application/json
```

### Request Body
```json
{
  "original_tracking_number": "DGX2024030200001",
  "return_tracking_number": "RET-DGX2024030200001",
  "return_from": {
    "kiosk_id": 1,
    "kiosk_code": "KIOSK-DHK-01",
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

### cURL Example
```bash
curl -X POST \
  http://localhost:8000/api/v1/sorting-centers/1/parcels/return-requests \
  -H 'X-Kiosk-Api-Key: test-key-123' \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json' \
  -d '{
  "original_tracking_number": "DGX2024030200001",
  "return_tracking_number": "RET-DGX2024030200001",
  "return_from": {
    "kiosk_id": 1,
    "kiosk_code": "KIOSK-DHK-01",
    "kiosk_name": "Dhaka Central Kiosk",
    "address": "123 Main Street, Dhaka",
    "latitude": 23.7461,
    "longitude": 90.3742
  },
  "return_reason": "Customer refused delivery",
  "requested_at": "2026-03-02T16:00:00Z",
  "return_center_id": 1,
  "pickup_required": true
}'
```

### Expected Response (201 Created)
```json
{
  "success": true,
  "message": "Return request received",
  "data": {
    "return_id": 1,
    "return_tracking_number": "RET-DGX2024030200001",
    "status": "requested",
    "pickup_scheduled_at": null,
    "assigned_rider": null,
    "note": "Return request received. Pickup will be scheduled by the sorting center."
  }
}
```

---

## Testing Workflow

### Step 1: Test API 1 (Pre-Data)
```bash
# Send pre-data for a parcel
curl -X POST http://localhost:8000/api/v1/sorting-centers/1/parcels/pre-data \
  -H 'X-Kiosk-Api-Key: test-key-123' \
  -H 'Content-Type: application/json' \
  -d '{"tracking_number":"TEST001","customer":{"name":"Test User","phone":"+8801711111111","address":"Test Address"},"parcel":{"cod_amount":1000},"source":{"kiosk_code":"KIOSK-DHK-01"}}'
```

### Step 2: Verify Pre-Data in Database
```sql
SELECT * FROM parcel_pre_data WHERE tracking_number = 'TEST001';
SELECT * FROM kiosk_api_logs WHERE api_type = 'receive_pre_data' ORDER BY id DESC LIMIT 1;
```

### Step 3: Simulate Sorting Process
(This would normally be done through the scanning interface)
```sql
-- Update pre-data status to physical_received
UPDATE parcel_pre_data SET status = 'physical_received', physical_received_at = NOW() WHERE tracking_number = 'TEST001';

-- Create sorted parcel record
INSERT INTO sorted_parcels (tracking_number, sorting_center_id, box_id, box_number, destination_kiosk_id, destination_kiosk_code, destination_kiosk_name, dispatch_status, return_center_id, created_at, updated_at)
VALUES ('TEST001', 1, 1, 'A1', 1, 'KIOSK-DHK-01', 'Dhaka Central Kiosk', 'sorted', 1, NOW(), NOW());
```

### Step 4: Test API 2 (Send Sorted Data)
```bash
# Get staff token first (login)
TOKEN=$(curl -X POST http://localhost:8000/api/auth/login \
  -H 'Content-Type: application/json' \
  -d '{"email":"admin@example.com","password":"password"}' \
  | jq -r '.token')

# Get summary
curl -X GET http://localhost:8000/api/sorting-centers/1/sorted-parcels-summary \
  -H "Authorization: Bearer $TOKEN"

# Send sorted data to kiosk
curl -X POST http://localhost:8000/api/sorting-centers/1/send-sorted-data \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Content-Type: application/json'
```

### Step 5: Test API 3 (Return Request)
```bash
curl -X POST http://localhost:8000/api/v1/sorting-centers/1/parcels/return-requests \
  -H 'X-Kiosk-Api-Key: test-key-123' \
  -H 'Content-Type: application/json' \
  -d '{"original_tracking_number":"TEST001","return_tracking_number":"RET-TEST001","return_from":{"kiosk_id":1,"kiosk_code":"KIOSK-DHK-01","kiosk_name":"Test Kiosk","address":"Test"},"return_reason":"Test return","return_center_id":1}'
```

### Step 6: Verify Return in Database
```sql
SELECT * FROM return_parcels WHERE return_tracking_number = 'RET-TEST001';
SELECT * FROM kiosk_api_logs WHERE api_type = 'receive_return_request' ORDER BY id DESC LIMIT 1;
```

---

## Monitoring API Logs

### View All API Logs
```sql
SELECT
  id,
  api_type,
  success,
  http_status_code,
  response_time_ms,
  requested_at,
  error_message
FROM kiosk_api_logs
ORDER BY requested_at DESC
LIMIT 20;
```

### View Failed API Calls
```sql
SELECT * FROM kiosk_api_logs
WHERE success = 0
ORDER BY requested_at DESC;
```

### API Performance Statistics
```sql
SELECT
  api_type,
  COUNT(*) as total_calls,
  SUM(CASE WHEN success = 1 THEN 1 ELSE 0 END) as successful,
  SUM(CASE WHEN success = 0 THEN 1 ELSE 0 END) as failed,
  ROUND(AVG(response_time_ms), 2) as avg_response_time_ms,
  MAX(response_time_ms) as max_response_time_ms
FROM kiosk_api_logs
GROUP BY api_type;
```

---

## Postman Collection

Import this JSON to Postman for easy testing:

```json
{
  "info": {
    "name": "Kiosk API - Sorting Center",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "API 1: Receive Pre-Data",
      "request": {
        "method": "POST",
        "header": [
          {
            "key": "X-Kiosk-Api-Key",
            "value": "test-key-123"
          },
          {
            "key": "Content-Type",
            "value": "application/json"
          }
        ],
        "url": {
          "raw": "{{base_url}}/api/v1/sorting-centers/1/parcels/pre-data",
          "host": ["{{base_url}}"],
          "path": ["api", "v1", "sorting-centers", "1", "parcels", "pre-data"]
        },
        "body": {
          "mode": "raw",
          "raw": "{\n  \"tracking_number\": \"DGX2024030200001\",\n  \"customer\": {\n    \"name\": \"Abdul Rahman\",\n    \"phone\": \"+8801712345678\",\n    \"address\": \"House 45, Road 12, Dhanmondi, Dhaka\",\n    \"latitude\": 23.7461,\n    \"longitude\": 90.3742\n  },\n  \"parcel\": {\n    \"weight_kg\": 2.5,\n    \"cod_amount\": 1500\n  },\n  \"source\": {\n    \"kiosk_code\": \"KIOSK-DHK-01\"\n  }\n}"
        }
      }
    },
    {
      "name": "API 2: Send Sorted Data",
      "request": {
        "method": "POST",
        "header": [
          {
            "key": "Authorization",
            "value": "Bearer {{sanctum_token}}"
          }
        ],
        "url": {
          "raw": "{{base_url}}/api/sorting-centers/1/send-sorted-data",
          "host": ["{{base_url}}"],
          "path": ["api", "sorting-centers", "1", "send-sorted-data"]
        }
      }
    },
    {
      "name": "API 3: Return Request",
      "request": {
        "method": "POST",
        "header": [
          {
            "key": "X-Kiosk-Api-Key",
            "value": "test-key-123"
          }
        ],
        "url": {
          "raw": "{{base_url}}/api/v1/sorting-centers/1/parcels/return-requests",
          "host": ["{{base_url}}"],
          "path": ["api", "v1", "sorting-centers", "1", "parcels", "return-requests"]
        },
        "body": {
          "mode": "raw",
          "raw": "{\n  \"original_tracking_number\": \"DGX2024030200001\",\n  \"return_tracking_number\": \"RET-DGX2024030200001\",\n  \"return_from\": {\n    \"kiosk_id\": 1,\n    \"kiosk_code\": \"KIOSK-DHK-01\",\n    \"kiosk_name\": \"Dhaka Central Kiosk\",\n    \"address\": \"123 Main Street\"\n  },\n  \"return_reason\": \"Customer refused\",\n  \"return_center_id\": 1\n}"
        }
      }
    }
  ],
  "variable": [
    {
      "key": "base_url",
      "value": "http://localhost:8000"
    },
    {
      "key": "sanctum_token",
      "value": ""
    }
  ]
}
```

---

## Troubleshooting

### Issue: 401 Unauthorized
**Solution**: Check that `KIOSK_API_KEYS_INCOMING` is set in `.env` and matches the header value.

### Issue: 404 Not Found
**Solution**: Verify sorting center ID exists in database.

### Issue: API logs not created
**Solution**: Check `sorting_center_id` is valid and database connection is working.

### Issue: Validation errors
**Solution**: Ensure all required fields are present in request body with correct data types.

---

**End of Testing Guide**
