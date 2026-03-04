# Sorting Center Management System - User Guide

## 📋 Table of Contents
1. [System Overview](#system-overview)
2. [Navigation Guide](#navigation-guide)
3. [Business Operations](#business-operations)
4. [Daily Workflows](#daily-workflows)
5. [Quick Reference](#quick-reference)

---

## 🎯 System Overview

The Sorting Center Management System helps you manage your logistics operations including parcels, riders, cash-on-delivery (COD), and settlements.

### Main Modules:
- **Dashboard** - Real-time overview and analytics
- **Parcels** - Track and manage all parcels
- **Riders** - Manage delivery riders
- **COD Management** - Handle cash collections
- **Routing** - Configure delivery routing rules
- **Centers** - Manage sorting centers
- **Settlements** - Financial settlements with merchants

---

## 🧭 Navigation Guide

### Sidebar Menu (Left Side)

```
┌─────────────────────────────┐
│ 🏠 Dashboard                │ ← Overview & analytics
├─────────────────────────────┤
│ 📦 Parcels                  │ ← Manage all parcels
├─────────────────────────────┤
│ 🚴 Riders                   │ ← Manage delivery riders
├─────────────────────────────┤
│ 💰 COD Management           │ ← Cash collections
├─────────────────────────────┤
│ 💳 Settlements              │ ← Financial settlements
├─────────────────────────────┤
│ 🗺️  Routing                 │ ← Delivery routing rules
├─────────────────────────────┤
│ 🏢 Centers                  │ ← Sorting centers
└─────────────────────────────┘
```

### Top Navigation Bar
- **Company Name** (left) - Returns to dashboard
- **User Menu** (right) - Click your name → Logout

---

## 💼 Business Operations

### 1. 📊 Dashboard (Home Page)

**Purpose**: Get a real-time overview of your business

**What You See**:
- **Total Parcels** - All parcels in system + today's count
- **Active Riders** - Riders currently on duty
- **COD Collected** - Total cash collected + pending amounts
- **Delivery Success Rate** - Performance metric

**Charts**:
- **Parcel Trends** - 7-day trend (Total, Delivered, In Transit)
- **Top Riders** - Leaderboard of best performing riders
- **Recent Activity** - Latest system events

**How to Use**:
1. Check stats cards for quick overview
2. Review trends to spot patterns
3. Monitor top riders for performance
4. Scan recent activity for issues

---

### 2. 📦 Parcels Management

**URL**: `/parcels`

**Purpose**: Manage all parcel operations

#### What You Can Do:

##### View All Parcels
- See complete list of parcels
- Filter by status (Pending, In Transit, Delivered, Failed)
- Search by tracking number, sender, or recipient
- Sort by date, status, or amount

##### Parcel Statuses:
- 🟡 **Pending** - Awaiting pickup
- 🔵 **Received** - At sorting center
- 🟣 **Sorted** - Sorted for delivery
- 🟠 **Out for Delivery** - With rider
- 🟢 **Delivered** - Successfully delivered
- 🔴 **Failed** - Delivery failed
- ⚫ **Returned** - Returned to sender

##### Create New Parcel
**Click: "Create Parcel" button**

Required Information:
1. **Sender Details**
   - Name, Phone, Address

2. **Recipient Details**
   - Name, Phone, Address
   - District, Area, Postal Code

3. **Parcel Details**
   - Description (what's inside)
   - Weight (kg)
   - Declared value
   - COD amount (if applicable)
   - Delivery type (Standard/Express)

4. **Special Instructions**
   - Fragile handling
   - Time preferences
   - Additional notes

##### View Parcel Details
**Click: Any parcel row**

See:
- Complete tracking history
- Current status and location
- Assigned rider (if any)
- Payment status
- Timeline of events
- Print shipping label

##### Track Parcel
- Use tracking number
- Real-time status updates
- Location history
- Estimated delivery time

---

### 3. 🚴 Riders Management

**URL**: `/riders`

**Purpose**: Manage your delivery team

#### What You Can Do:

##### View All Riders
- See complete list of riders
- Filter by status (Active, On Break, Offline)
- View performance metrics
- Check current location (if GPS enabled)

##### Rider Information:
- Name and contact details
- Current status (On Duty / Off Duty / On Break)
- Today's deliveries
- Success rate
- Total parcels delivered
- Average rating
- Current location

##### Add New Rider
**Click: "Add Rider" button**

Required Information:
1. **Personal Details**
   - Full name
   - Phone number
   - Email
   - National ID

2. **Work Details**
   - Employee ID
   - Assigned sorting center
   - Vehicle type (Motorcycle, Bicycle, Van)
   - Vehicle registration

3. **Account Setup**
   - Username
   - Password
   - Assigned areas

##### Rider Performance
- View individual rider statistics
- Delivery success rate
- Average delivery time
- Customer ratings
- COD collection accuracy

##### Assign Parcels to Riders
1. Go to Parcels page
2. Select parcels to assign
3. Choose rider from dropdown
4. Click "Assign to Rider"
5. Rider gets notification on their app

---

### 4. 💰 COD Management

**URL**: `/cod`

**Purpose**: Manage Cash-on-Delivery collections

#### What You Can Do:

##### View COD Collections
- All cash collections by riders
- Filter by status (Pending, Verified, Deposited)
- Search by rider, date, or amount
- Track pending deposits

##### COD Statuses:
- 🟡 **Pending Verification** - Rider collected, needs verification
- 🔵 **Verified** - Amount verified, pending deposit
- 🟢 **Deposited** - Money deposited to company
- 🔴 **Discrepancy** - Amount mismatch

##### Daily COD Process:

**Step 1: Rider Collects Cash**
- Rider delivers parcel
- Collects COD amount
- Records in mobile app

**Step 2: Verification**
1. Rider returns to sorting center
2. Supervisor counts cash
3. Click "Verify" on collection
4. Enter actual amount
5. System flags if mismatch

**Step 3: Deposit**
1. Cash verified
2. Rider deposits to cashier
3. Click "Mark as Deposited"
4. Enter receipt number
5. Amount ready for settlement

##### View COD Summary
- Total collected today
- Pending verification
- Pending deposit
- Deposited amount
- By rider breakdown

---

### 5. 💳 Settlements

**URL**: `/settlements`

**Purpose**: Financial settlements with merchants/clients

#### What You Can Do:

##### Create Settlement
1. Select date range
2. Choose merchant/client
3. System calculates:
   - Total deliveries
   - Delivery charges
   - COD collected
   - Amount payable
4. Generate settlement report

##### Settlement Process:

**Step 1: Generate**
- Click "Create Settlement"
- Select merchant and period
- Review auto-calculated amounts
- Adjust if needed (with approval)

**Step 2: Approve**
- Manager reviews settlement
- Clicks "Approve"
- Locks amounts
- Generates invoice

**Step 3: Process Payment**
- Finance team processes payment
- Clicks "Mark as Paid"
- Enters payment reference
- System sends confirmation

##### Settlement Statuses:
- 🟡 **Pending** - Created, awaiting approval
- 🔵 **Approved** - Approved, awaiting payment
- 🟢 **Paid** - Payment completed
- 🔴 **Cancelled** - Settlement cancelled

---

### 6. 🗺️ Routing

**URL**: `/routing`

**Purpose**: Configure automatic delivery routing rules

#### What You Can Do:

##### View Routing Rules
- See all active routing rules
- Rules determine which sorting center handles which areas
- Priority-based routing

##### Create Routing Rule
1. **Define Area**
   - Select district
   - Specify postal codes
   - Define coverage area

2. **Set Destination**
   - Assign to sorting center
   - Set priority (1-10)
   - Define handling time

3. **Special Conditions**
   - Weight limits
   - Value limits
   - Service type rules

##### How Routing Works:
```
New Parcel → Check recipient address
           → Match routing rules
           → Assign to sorting center
           → Auto-assign to available rider
```

---

### 7. 🏢 Centers

**URL**: `/centers`

**Purpose**: Manage sorting center locations

#### What You Can Do:

##### View All Centers
- See all sorting center locations
- Check capacity and current load
- Monitor performance metrics

##### Center Information:
- Location and address
- Operating hours
- Contact details
- Coverage areas
- Current parcel count
- Assigned riders
- Performance stats

##### Add New Center
- Location details
- Coverage areas
- Capacity limits
- Operating schedule

---

## 🔄 Daily Workflows

### Morning Workflow (Sorting Center Staff)

**8:00 AM - System Check**
```
1. Login to dashboard
2. Check yesterday's pending items
3. Review today's expected parcels
4. Verify rider availability
```

**9:00 AM - Parcel Receiving**
```
1. Go to Parcels → Create
2. Scan/enter incoming parcels
3. System auto-assigns to riders based on routing
4. Print shipping labels
```

**10:00 AM - Rider Assignment**
```
1. Go to Riders
2. Check active riders
3. Go to Parcels
4. Assign parcels to riders
5. Riders receive notifications
```

---

### Midday Workflow (Operations Manager)

**12:00 PM - Performance Check**
```
1. Check Dashboard
2. Review delivery success rate
3. Check rider leaderboard
4. Monitor parcel trends
```

**2:00 PM - Issue Resolution**
```
1. Check "Recent Activity" for failed deliveries
2. Go to Parcels → Filter "Failed"
3. Contact customers or reschedule
4. Reassign to riders if needed
```

---

### Evening Workflow (Finance Team)

**6:00 PM - COD Reconciliation**
```
1. Go to COD Management
2. Verify all pending collections
3. Count physical cash
4. Mark as "Verified"
5. Process deposits
```

**7:00 PM - Settlement Generation**
```
1. Go to Settlements
2. Create daily/weekly settlements
3. Review amounts
4. Submit for approval
```

---

## 📱 Quick Reference

### Common Tasks

| Task | Navigate To | Action |
|------|-------------|--------|
| Add new parcel | Parcels → Create | Fill form & submit |
| Track parcel | Parcels → Search | Enter tracking # |
| Add rider | Riders → Create | Fill form & submit |
| Assign parcel to rider | Parcels → Select → Assign | Choose rider |
| Verify COD | COD → Pending | Click Verify |
| Create settlement | Settlements → Create | Select period |
| Check performance | Dashboard | View stats & charts |

### Keyboard Shortcuts (Coming Soon)
- `Ctrl + /` - Search parcels
- `Ctrl + N` - New parcel
- `Ctrl + R` - Refresh data

### Status Color Guide
- 🟢 **Green** - Success/Completed
- 🟡 **Yellow** - Pending/Warning
- 🔵 **Blue** - In Progress/Info
- 🔴 **Red** - Failed/Error
- ⚫ **Gray** - Cancelled/Inactive

---

## 💡 Tips & Best Practices

### For Sorting Center Staff
1. **Always verify parcel details** before accepting
2. **Scan barcodes** when available for accuracy
3. **Update status immediately** when changes occur
4. **Check rider availability** before assignment
5. **Verify COD amounts** carefully

### For Operations Managers
1. **Review dashboard daily** at start of day
2. **Monitor failed deliveries** and resolve quickly
3. **Track rider performance** weekly
4. **Optimize routing rules** based on trends
5. **Generate reports** for decision making

### For Finance Team
1. **Reconcile COD daily** to avoid discrepancies
2. **Generate settlements** on schedule
3. **Keep payment records** updated
4. **Monitor pending amounts** regularly
5. **Verify amounts** before approving settlements

---

## 🆘 Need Help?

### Common Questions

**Q: How do I reset my password?**
A: Click your name → Logout → "Forgot Password?" link

**Q: Can I edit a parcel after creation?**
A: Yes, go to Parcels → Click parcel → Edit button

**Q: How do I know if a rider is available?**
A: Go to Riders → Check status column (Green = Available)

**Q: What if COD amount doesn't match?**
A: System will flag it as "Discrepancy" - contact supervisor

**Q: How do I print shipping labels?**
A: Go to Parcel details → Click "Print Label" button

---

## 📞 Support

For technical support or questions:
- **Email**: support@sortingcenter.com
- **Phone**: [Your support number]
- **Hours**: 24/7

---

**Last Updated**: March 2, 2026
**Version**: 1.0
