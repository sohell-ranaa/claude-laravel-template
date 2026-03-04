# 🏢 Multi-Tenant Sorting Center Workflow

## Complete Step-by-Step Guide

This guide shows how to set up and manage multiple independent sorting centers, each with their own managers, staff, and operations.

---

## 📋 Table of Contents

1. [System Architecture](#system-architecture)
2. [Initial Setup (One Time)](#initial-setup)
3. [Creating a Sorting Center](#creating-a-sorting-center)
4. [Center Manager Login & Operations](#center-manager-operations)
5. [User Roles & Permissions](#user-roles--permissions)
6. [Complete Workflow Example](#complete-workflow-example)

---

## 🏗️ System Architecture

### User Hierarchy

```
┌─────────────────────────────────────┐
│      SUPER ADMIN (You)              │ ← Full system access
│  superadmin@sortingcenter.com       │    Create/manage all centers
└──────────────┬──────────────────────┘
               │
       ┌───────┴───────┬───────────────┬─────────────┐
       │               │               │             │
   ┌───▼────┐      ┌───▼────┐      ┌───▼────┐   ┌───▼────┐
   │ CENTER │      │ CENTER │      │ CENTER │   │ CENTER │
   │  DHA   │      │  CHT   │      │  SYL   │   │  RAJ   │
   └───┬────┘      └───┬────┘      └───┬────┘   └───┬────┘
       │               │               │             │
   ┌───▼────┐      ┌───▼────┐      ┌───▼────┐   ┌───▼────┐
   │Manager │      │Manager │      │Manager │   │Manager │
   │  ↓     │      │  ↓     │      │  ↓     │   │  ↓     │
   │ Staff  │      │ Staff  │      │ Staff  │   │ Staff  │
   │ Riders │      │ Riders │      │ Riders │   │ Riders │
   └────────┘      └────────┘      └────────┘   └────────┘
```

### Access Scoping

- **Super Admin** - Can see and manage ALL centers
- **Center Manager** - Can ONLY see/manage their assigned center
- **Center Staff** - Can ONLY work within their assigned center
- **Riders** - Can ONLY see parcels assigned to them from their center

---

## 🚀 Initial Setup (One Time)

### Step 1: Create Super Admin Account

Run this command in your terminal:

```bash
cd /home/rana-workspace/sorting-center/backend
php artisan db:seed --class=SuperAdminSeeder
```

**Output:**
```
Super Admin created successfully!
Email: superadmin@sortingcenter.com
Password: superadmin123
```

### Step 2: Login as Super Admin

1. Go to: `http://your-domain.com/login`
2. Enter credentials:
   - **Email**: `superadmin@sortingcenter.com`
   - **Password**: `superadmin123`
3. Click "Sign in"

**✅ You're now logged in as Super Admin!**

---

## 🏢 Creating a Sorting Center

### Overview

As Super Admin, you'll create each sorting center with:
- ✓ Basic information (name, location, contact)
- ✓ Coverage area and radius
- ✓ Nearby landmarks
- ✓ Center manager account (auto-created)
- ✓ Initial riders (optional)

### Step-by-Step Process

#### **Step 1: Navigate to Centers**

```
Dashboard → Sidebar → Centers → "Create Center" button
```

Or directly: `http://your-domain.com/centers/create`

---

#### **Step 2: Fill Basic Information**

You'll see a 4-step wizard:

```
┌─────────────────────────────────────────────────┐
│ ● Basic Info → ○ Location → ○ Staff → ○ Review │
└─────────────────────────────────────────────────┘
```

**Fill these fields:**

| Field | Example | Description |
|-------|---------|-------------|
| Center Name | `Dhaka Central Sorting Center` | Full name of the facility |
| Code | `DCC-001` | Unique identifier |
| Phone | `+880 1712-345678` | Center contact number |
| Email | `dhaka.center@sortingcenter.com` | Center email |
| Capacity | `500` | Max parcels/day this center can handle |
| Operating Hours | `9:00 AM - 9:00 PM` | Working hours |

**Click: "Next: Location & Coverage →"**

---

#### **Step 3: Set Location & Coverage Area**

```
┌─────────────────────────────────────────────────┐
│ ○ Basic Info → ● Location → ○ Staff → ○ Review │
└─────────────────────────────────────────────────┘
```

**Fill these fields:**

| Field | Example | Description |
|-------|---------|-------------|
| Full Address | `House 123, Road 45, Dhanmondi, Dhaka 1205` | Complete address |
| Latitude | `23.7461` | GPS coordinates (optional) |
| Longitude | `90.3742` | GPS coordinates (optional) |
| Coverage Radius | `5.0` | Service area in kilometers |

**Add Landmarks:**
Click "+ Add Landmark" for each nearby landmark:
- `Near Dhanmondi Lake`
- `Opposite City Hospital`
- `Behind Shopping Mall`

**Add Coverage Areas/Districts:**
Click "+ Add Coverage Area" for each area this center serves:
- `Dhanmondi`
- `Mohammadpur`
- `Lalmatia`
- `New Market`
- `Azimpur`

**Visual Reference:**
```
        Coverage Radius = 5km
             ↓
    ┌───────────────────┐
    │                   │
    │    ┌─────┐        │
    │    │ SC  │←───────┼── Sorting Center
    │    └─────┘        │
    │                   │
    │  [All parcels in  │
    │   this radius are │
    │   handled by this │
    │   center]         │
    │                   │
    └───────────────────┘
```

**Click: "Next: Manager & Staff →"**

---

#### **Step 4: Create Center Manager & Initial Riders**

```
┌─────────────────────────────────────────────────┐
│ ○ Basic Info → ○ Location → ● Staff → ○ Review │
└─────────────────────────────────────────────────┘
```

##### **A) Center Manager Account**

**This creates a new user account** who will manage this center:

| Field | Example | Important Notes |
|-------|---------|----------------|
| Manager Name | `Ahmed Rahman` | Full name |
| Manager Phone | `+880 1712-999888` | Contact number |
| Manager Email | `ahmed@sortingcenter.com` | **This becomes their login username** |
| Password | `SecurePass123!` | **They'll use this to login** |

**What happens:**
1. System creates a new user account
2. Assigns "Center Manager" role
3. Links them to THIS sorting center only
4. Sends welcome email with login credentials
5. They can login immediately after center is created

##### **B) Initial Riders (Optional)**

You can add riders now or later. Click "+ Add Rider" for each:

**Rider 1:**
- Name: `Karim Mia`
- Phone: `+880 1712-111222`
- Vehicle Type: `Motorcycle`

**Rider 2:**
- Name: `Rahim Khan`
- Phone: `+880 1712-333444`
- Vehicle Type: `Bicycle`

**Note:** More riders can be added later by the Center Manager.

**Click: "Next: Review →"**

---

#### **Step 5: Review & Create**

```
┌─────────────────────────────────────────────────┐
│ ○ Basic Info → ○ Location → ○ Staff → ● Review │
└─────────────────────────────────────────────────┘
```

Review all information:

```
✓ Basic Information
  - Dhaka Central Sorting Center (DCC-001)
  - Capacity: 500 parcels/day

✓ Location & Coverage
  - Dhanmondi, Dhaka
  - Coverage: 5.0 km radius
  - Areas: Dhanmondi, Mohammadpur, Lalmatia, New Market, Azimpur

✓ Manager & Staff
  - Manager: Ahmed Rahman (ahmed@sortingcenter.com)
  - Initial Riders: 2 rider(s)
```

**Click: "✓ Create Sorting Center"**

---

### What Happens After Creation?

```
1. ✓ Sorting center record created in database
2. ✓ Coverage areas saved
3. ✓ Manager user account created
4. ✓ Manager assigned to this center
5. ✓ Rider accounts created (if added)
6. ✓ Riders assigned to this center
7. ✓ Email sent to manager with login credentials
8. ✓ Center appears in centers list
9. ✓ Ready for operations!
```

---

## 👤 Center Manager Operations

### Step 1: Manager Receives Login Credentials

The center manager receives an email:

```
Subject: Your Sorting Center Manager Account

Hello Ahmed Rahman,

You have been assigned as the manager of:
Dhaka Central Sorting Center (DCC-001)

Login Credentials:
Email: ahmed@sortingcenter.com
Password: SecurePass123!

Login URL: http://your-domain.com/login

Please change your password after first login.

Best regards,
Sorting Center System
```

---

### Step 2: Manager Logs In

1. Go to: `http://your-domain.com/login`
2. Enter:
   - Email: `ahmed@sortingcenter.com`
   - Password: `SecurePass123!`
3. Click "Sign in"

**What the manager sees:**

```
┌──────────────────────────────────────────────┐
│  Dhaka Central Sorting Center  [Ahmed ▼]    │ ← Their center name
├──────────────────────────────────────────────┤
│                                              │
│  Dashboard showing ONLY their center's data: │
│                                              │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐     │
│  │ Parcels │  │ Riders  │  │   COD   │     │
│  │   45    │  │    5    │  │ 12,500  │     │
│  │ (Today) │  │ Active  │  │  ৳      │     │
│  └─────────┘  └─────────┘  └─────────┘     │
│                                              │
│  [Their center's parcels only]              │
│  [Their center's riders only]               │
│  [Their center's COD only]                  │
│                                              │
└──────────────────────────────────────────────┘

Sidebar:
├─ 🏠 Dashboard (their center's stats)
├─ 📦 Parcels (their center's parcels)
├─ 🚴 Riders (their center's riders)
├─ 💰 COD (their center's collections)
├─ 💳 Settlements (their center's settlements)
└─ 🗺️  Routing (their center's routes)
```

**Key Point:** Manager can ONLY see and manage data for their assigned center!

---

### Step 3: Manager's Daily Operations

#### **A) Receive New Parcels**

```
1. Go to: Parcels → Create Parcel
2. Fill sender/recipient details
3. Click "Create"
4. System automatically:
   - Assigns to THEIR center
   - Creates tracking number
   - Adds to their center's parcel list
```

#### **B) Assign Parcels to Riders**

```
1. Go to: Parcels
2. See only parcels in THEIR center
3. Filter: Status = "Ready for Delivery"
4. Select parcels
5. Click "Assign to Rider"
6. Choose from THEIR center's riders only
7. Rider gets notification
```

#### **C) Manage Their Riders**

```
1. Go to: Riders
2. See only riders assigned to THEIR center
3. Can:
   - Add new riders (auto-assigned to their center)
   - View rider performance
   - Update rider status
   - Check current location
```

#### **D) Handle COD Collections**

```
1. Go to: COD Management
2. See only collections from THEIR center's riders
3. Verify cash
4. Mark as deposited
5. All amounts scoped to their center
```

---

## 🔐 User Roles & Permissions

### Role Hierarchy

```
1. Super Admin (Level 1)
   ├─ Can create/delete/edit all centers
   ├─ Can see all centers' data
   ├─ Can create center managers
   └─ Has no assigned center (sees everything)

2. Center Manager (Level 2)
   ├─ Can manage only their assigned center
   ├─ Can add staff and riders to their center
   ├─ Can create/manage parcels in their center
   └─ Cannot see other centers' data

3. Center Staff (Level 3)
   ├─ Can receive parcels for their center
   ├─ Can assign parcels to riders
   ├─ Can verify COD
   └─ Cannot manage riders or settings

4. Rider (Level 4)
   ├─ Can see only parcels assigned to them
   ├─ Can update delivery status
   ├─ Can record COD collection
   └─ Mobile app access only
```

---

## 📖 Complete Workflow Example

### Scenario: Setting Up Two Sorting Centers

#### **Center 1: Dhaka Central**

**Step 1: Super Admin Creates Center**
```
Login as: superadmin@sortingcenter.com

Go to: Centers → Create Center

Fill:
- Name: Dhaka Central Sorting Center
- Code: DCC-001
- Coverage: Dhanmondi, Mohammadpur, Lalmatia
- Manager: Ahmed Rahman (ahmed@sortingcenter.com)
- Password: ahmed123

Create → Success!
```

**Step 2: Manager Logs In**
```
Login as: ahmed@sortingcenter.com
Password: ahmed123

Sees:
- Dashboard for Dhaka Central only
- Can manage only Dhaka Central operations
```

**Step 3: Manager Adds Riders**
```
Go to: Riders → Add Rider

Add:
1. Karim (motorcycle)
2. Rahim (bicycle)
3. Jalal (van)

All automatically assigned to Dhaka Central center
```

**Step 4: Manager Receives Parcel**
```
Go to: Parcels → Create

Enter:
- Sender: Customer A (Dhanmondi)
- Recipient: Customer B (Mohammadpur)
- COD: ৳500

Create → Parcel automatically assigned to Dhaka Central
```

**Step 5: Manager Assigns to Rider**
```
Go to: Parcels → Select parcel
Assign to: Karim

Karim sees it on his mobile app
```

---

#### **Center 2: Chittagong Port**

**Step 1: Super Admin Creates Second Center**
```
Still logged in as: superadmin@sortingcenter.com

Go to: Centers → Create Center

Fill:
- Name: Chittagong Port Sorting Center
- Code: CPC-001
- Coverage: Agrabad, Panchlaish, Khulshi
- Manager: Fatima Begum (fatima@sortingcenter.com)
- Password: fatima123

Create → Success!
```

**Step 2: Chittagong Manager Logs In**
```
Login as: fatima@sortingcenter.com
Password: fatima123

Sees:
- Dashboard for Chittagong Port only
- Cannot see Dhaka Central's data
- Completely separate operations
```

---

### Data Isolation Visualization

```
┌─────────────────────────┐    ┌─────────────────────────┐
│  Dhaka Central Center   │    │ Chittagong Port Center  │
├─────────────────────────┤    ├─────────────────────────┤
│ Manager: Ahmed          │    │ Manager: Fatima         │
│ Parcels: 150            │    │ Parcels: 75             │
│ Riders: 10              │    │ Riders: 6               │
│ COD: ৳50,000            │    │ COD: ৳30,000            │
└─────────────────────────┘    └─────────────────────────┘
         ↑                              ↑
         │                              │
         └──────────────┬───────────────┘
                        │
                  ┌─────▼─────┐
                  │   SUPER   │
                  │   ADMIN   │ ← Can see both
                  └───────────┘
```

---

## 🔧 Technical Implementation

### How Data Scoping Works

**When Center Manager logs in:**

```php
// System checks user's assigned center
if (auth()->user()->sorting_center_id) {
    // All queries automatically filtered
    $parcels = Parcel::where('sorting_center_id', auth()->user()->sorting_center_id)->get();
    $riders = Rider::where('sorting_center_id', auth()->user()->sorting_center_id)->get();
    $cod = CodCollection::whereHas('rider', function($q) {
        $q->where('sorting_center_id', auth()->user()->sorting_center_id);
    })->get();
}
```

**When Super Admin logs in:**

```php
// System checks if user is super admin
if (auth()->user()->hasRole('Super Admin')) {
    // No filtering - sees all data
    $parcels = Parcel::all();
    $riders = Rider::all();
    $centers = SortingCenter::all();
}
```

---

## ✅ Setup Checklist

### Initial System Setup

- [ ] Run SuperAdminSeeder to create super admin account
- [ ] Login as super admin
- [ ] Verify you can access all sections

### For Each Sorting Center

- [ ] Fill basic information (name, code, contact)
- [ ] Set location and coverage area
- [ ] Add nearby landmarks
- [ ] Create manager account
- [ ] Add initial riders (optional)
- [ ] Review and create
- [ ] Test manager login
- [ ] Verify manager sees only their center's data

### Manager Onboarding

- [ ] Manager receives login credentials
- [ ] Manager logs in successfully
- [ ] Manager can create test parcel
- [ ] Manager can add riders
- [ ] Manager can assign parcels to riders
- [ ] Manager can verify COD
- [ ] All data scoped to their center only

---

## 🆘 Troubleshooting

### Issue: Manager can see other centers' data

**Solution:**
- Check user's `sorting_center_id` in database
- Ensure middleware is applying center scope
- Verify role is "Center Manager" not "Super Admin"

### Issue: Manager cannot add riders

**Solution:**
- Check manager's permissions
- Verify "Center Manager" role has rider creation permission

### Issue: Parcels not showing for manager

**Solution:**
- Check parcel's `sorting_center_id` matches manager's center
- Verify query scoping is applied

---

## 📞 Next Steps

After setup:

1. **Create your first center** as Super Admin
2. **Login as center manager** to test isolation
3. **Add riders** through manager account
4. **Create test parcels** to verify workflow
5. **Repeat** for each additional center

---

**Ready to start?** Login as Super Admin and create your first sorting center!

**Login URL:** http://your-domain.com/login
**Email:** superadmin@sortingcenter.com
**Password:** superadmin123
