# Sorting Center Operations Workflow

## Business Process Flow After Center Creation

### Phase 1: Initial Setup (Super Admin)

#### 1.1 Create Sorting Center
✅ **Status**: Implemented

**Actions**:
- Navigate to **Centers** → Click **"Add Center"**
- Fill in center details:
  - Basic info: Name, Code, Type, Status
  - Location: Address, Coordinates, Coverage radius
  - Contact: Phone, Email
  - Capacity: Daily parcel capacity
  - Operating hours

**Result**: New sorting center created with unique code

#### 1.2 Assign Center Manager
✅ **Status**: Implemented

**Actions**:
- Navigate to **User Management** → **Users Tab**
- Click **"Add User"**
- Fill in manager details:
  - Name, Email, Phone
  - Password (temporary - manager should change)
  - Assign Role: **"Center Manager"** or **"Manager"**
  - Assign Sorting Center: Select the created center
  - Status: Active

**Result**: Manager account created and linked to sorting center

#### 1.3 Create Initial Riders
**Status**: ⚠️ Needs Implementation

**What Needs to Be Done**:
- Create a Riders management interface similar to Users
- Fields needed:
  - Name, Phone, Email
  - Vehicle Type (motorcycle, van, truck)
  - Vehicle Number
  - Max parcels per trip
  - Max weight capacity (kg)
  - Assigned sorting center
  - Status (active, on_duty, off_duty, suspended)

**Next Actions**:
- [ ] Create `RiderController` with CRUD operations
- [ ] Create riders management UI
- [ ] Add riders to navigation menu
- [ ] Link riders to sorting centers

---

### Phase 2: Manager Configuration (Center Manager)

#### 2.1 Manager First Login
**Status**: ⚠️ Needs Implementation

**What Should Happen**:
1. Manager receives login credentials via email
2. Manager logs in with temporary password
3. System prompts to change password
4. Manager sees onboarding checklist:
   - ☐ Review center information
   - ☐ Add riders
   - ☐ Configure coverage areas
   - ☐ Set up routing rules
   - ☐ Test parcel reception

#### 2.2 Review & Configure Center
**Status**: ✅ Partially Implemented

**Actions**:
- Manager reviews center details
- Updates operational hours if needed
- Verifies coverage areas
- Updates contact information

#### 2.3 Add More Riders
**Status**: ⚠️ Needs Implementation

**Actions**:
- Manager navigates to **Riders** section
- Adds riders specific to their center
- Assigns vehicle types and capacities
- Sets rider availability schedules

#### 2.4 Configure Routing Rules
**Status**: ⚠️ Needs Implementation

**What Needs to Be Done**:
- Create routing rules management interface
- Define rules based on:
  - Postcode/area mapping
  - Parcel weight/size
  - Priority levels
  - Rider capabilities

---

### Phase 3: Daily Operations

#### 3.1 Parcel Reception
**Status**: ✅ Implemented (API exists)

**Workflow**:
1. Parcels arrive at sorting center
2. Operator scans barcode/tracking number
3. System records:
   - Received time
   - Origin center
   - Destination center
   - Parcel details (weight, dimensions, COD amount)
4. Parcel status: **"Received"**

**UI Needed**:
- [ ] Bulk parcel reception interface
- [ ] Barcode scanner integration
- [ ] Quick receive form

#### 3.2 Parcel Sorting
**Status**: ⚠️ Needs Implementation

**Workflow**:
1. Operator sorts parcels by:
   - Destination area/postcode
   - Delivery route
   - Priority
2. System suggests rider assignment based on:
   - Rider location
   - Capacity
   - Route optimization
3. Parcel status: **"Sorted"**

**UI Needed**:
- [ ] Sorting dashboard
- [ ] Route visualization
- [ ] Batch assignment interface

#### 3.3 Rider Assignment & Dispatch
**Status**: ⚠️ Needs Implementation

**Workflow**:
1. Manager/Operator assigns parcels to rider
2. Rider receives notification
3. Rider picks up parcels
4. System generates:
   - Delivery manifest
   - Route map
   - COD collection summary
5. Parcel status: **"Out for Delivery"**

**UI Needed**:
- [ ] Rider assignment interface
- [ ] Delivery manifest generation
- [ ] Real-time tracking dashboard

#### 3.4 Delivery & COD Collection
**Status**: ✅ API Implemented, UI Needed

**Workflow**:
1. Rider delivers parcel
2. Collects COD (if applicable)
3. Updates status via mobile app:
   - **"Delivered"** (success)
   - **"Failed"** (customer unavailable, wrong address)
   - **"Returned"** (rejected by customer)
4. System records:
   - Delivery time
   - COD amount collected
   - Customer signature/proof

**UI Needed**:
- [ ] Rider mobile app interface
- [ ] Delivery status update screen
- [ ] COD recording

#### 3.5 COD Deposit
**Status**: ✅ Implemented

**Workflow**:
1. Rider returns to sorting center
2. Deposits COD cash
3. Manager/Operator verifies amount
4. System records COD deposit
5. Generates receipt

**Current Status**: COD collection tracking exists via API

#### 3.6 Settlements
**Status**: ✅ Implemented

**Workflow**:
1. System aggregates COD collections
2. Calculates:
   - Total COD collected
   - Delivery fees
   - Net amount to merchant
3. Manager reviews and approves settlement
4. Finance processes payment

---

## Immediate Next Steps

### Priority 1: Rider Management
**Why**: Essential for operations, currently missing

**Tasks**:
1. Create `RiderController` API
2. Build riders management UI (similar to users)
3. Add rider assignment to centers
4. Implement rider status tracking

### Priority 2: Parcel Reception UI
**Why**: Core daily operation

**Tasks**:
1. Build bulk parcel reception interface
2. Add barcode scanner support
3. Create quick receive form
4. Implement received parcels dashboard

### Priority 3: Sorting & Assignment
**Why**: Link between reception and delivery

**Tasks**:
1. Build sorting dashboard
2. Create rider assignment interface
3. Implement route optimization
4. Add batch assignment feature

### Priority 4: Delivery Tracking
**Why**: Real-time visibility

**Tasks**:
1. Create rider tracking interface
2. Build delivery status updates
3. Add real-time map tracking
4. Implement notification system

---

## Current System Capabilities

### ✅ Fully Implemented
- User & Role Management
- Sorting Center Management
- COD Collection Tracking (API)
- Settlement Processing (API)
- Dashboard Analytics
- Multi-tenant Architecture

### ⚙️ Partially Implemented
- Parcel Management (API exists, UI limited)
- Rider Management (Model exists, no UI)
- Routing Rules (API exists, no UI)

### ❌ Not Implemented
- Bulk parcel reception interface
- Sorting dashboard
- Rider assignment interface
- Real-time tracking
- Mobile app for riders
- Barcode scanning
- Route optimization UI

---

## Recommended Implementation Order

1. **Week 1**: Rider Management UI
   - CRUD interface for riders
   - Rider assignment to centers
   - Rider status management

2. **Week 2**: Parcel Reception
   - Bulk reception interface
   - Barcode scanner integration
   - Received parcels dashboard

3. **Week 3**: Sorting & Assignment
   - Sorting dashboard
   - Rider assignment interface
   - Delivery manifest generation

4. **Week 4**: Tracking & Updates
   - Real-time tracking
   - Delivery status updates
   - Notifications

5. **Week 5**: Mobile App
   - Rider mobile interface
   - GPS tracking
   - Delivery proof capture

---

## Next Immediate Action

**After setting up a center with a manager, the next business step is**:

👉 **Add Riders to the Sorting Center**

Without riders, parcels cannot be delivered. This is the critical next step in the workflow.

**Implementation Required**:
- Riders management interface (similar to users)
- Rider assignment to centers
- Vehicle and capacity management
- Rider status tracking

Would you like me to implement the Riders Management UI next?
