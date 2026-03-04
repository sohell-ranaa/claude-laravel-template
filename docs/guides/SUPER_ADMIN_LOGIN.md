# Super Admin Login - Quick Reference

## 🔐 Login Credentials

**URL:** http://172.16.0.89:8000/login

**Email:** `superadmin@sortingcenter.com`
**Password:** `admin123`

---

## 📋 After Login - Testing Routing Rules

### Step 1: Navigate to Routing Page
After successful login, go to:
**http://172.16.0.89:8000/routing**

### Step 2: What You Should See

The **Rules** tab should immediately show **11 routing rules** for Mohammadpur Sorting Center:

| Priority | Rule Name | Type | Status |
|----------|-----------|------|--------|
| 5 | Express Priority Delivery | Direct Delivery | ✅ Active |
| 5 | Gulshan Express Delivery | Direct Delivery | ✅ Active |
| 10 | Mohammadpur Local Delivery (x2) | Direct Delivery | ✅ Active |
| 15 | Heavy Parcel Special Handling | Sub-Center | ✅ Active |
| 15 | Dhanmondi Direct Delivery | Direct Delivery | ✅ Active |
| 20 | Dhanmondi-Green Road Route | Direct Delivery | ✅ Active |
| 20 | Transfer to Uttara Hub | Hub Transfer | ✅ Active |
| 25 | Mirpur Sub-Center Routing | Sub-Center | ✅ Active |
| 30 | Mirpur Area Transfer | Hub Transfer | ✅ Active |
| 35 | North Dhaka Transfer | Hub Transfer | ✅ Active |

### Step 3: Filter Rules

Use the **"Sorting Center"** dropdown at the top:
- **"All Sorting Centers"** → Shows all 11 rules
- **"Mohammadpur Sorting Center (MDP-001)"** → Shows only Mohammadpur rules
- **"Uttara Sorting Center (UTT-001)"** → Shows Uttara rules (none yet)
- **"Mirpur Sorting Center (MIR-001)"** → Shows Mirpur rules (none yet)

### Step 4: Test Creating a New Rule

1. Click **"Create Rule"** button
2. Fill in the form:
   - **Rule Name:** "Test Rule"
   - **Sorting Center:** Select any center
   - **Rule Type:** Direct Delivery
   - **Priority:** 50
   - **Conditions JSON:** `{"area": "Test Area", "postcode": ["1111"]}`
   - **Action Config JSON:** `{"action": "assign_for_delivery", "delivery_center_id": 1}`
3. Click **"Create Rule"**
4. New rule should appear in the table

### Step 5: Test Other Tabs

**Analytics Tab:**
- Shows routing statistics (currently placeholder data)
- Stats cards: Total Routes, Success Rate, Avg Confidence, Active Rules

**Bulk Routing Tab:**
- Select parcels for bulk routing
- Calculate routes for multiple parcels at once
- Apply routing or just calculate

---

## ✅ Expected Behavior (Version 5.3)

### Console Output
Open browser console (F12) and you should see:
```
=== ROUTING COMPONENT VERSION 5.3 REGISTERING ===
=== ROUTING COMPONENT VERSION 5.3 INITIALIZED ===
Config loaded: {userCenterId: null, isSuperAdmin: true, defaultCenterId: ""}
Is Super Admin: true
```

### No Errors
- ✅ No "Unexpected token '&'" syntax errors
- ✅ No "savingRule is not defined" errors
- ✅ No 404 API errors
- ✅ Rules load immediately on page load

### Functionality Works
- ✅ Tab switching (Rules, Analytics, Bulk Routing)
- ✅ "Create Rule" modal opens and works
- ✅ Edit/Delete buttons work on existing rules
- ✅ Sorting center dropdown filters rules correctly
- ✅ Rule type dropdown filters rules correctly

---

## 🔍 Troubleshooting

### Issue: Not seeing any rules

**Check:**
1. Open browser console (F12) - any JavaScript errors?
2. Check Network tab - is `/ajax/routing/rules` returning 200?
3. What version shows in console? Should be **5.3**

**Solution:**
```bash
# Clear caches
php artisan optimize:clear

# Hard refresh browser
Ctrl + Shift + R (Windows/Linux)
Cmd + Shift + R (Mac)
```

### Issue: "Unauthorized" or 403 errors

**Check:** Are you logged in as super admin?

**Verify in console:**
```javascript
// Should show true
Alpine.$data(document.querySelector('[x-data]')).isSuperAdmin
```

### Issue: Old version showing (5.2 or 5.1)

**Solution:**
1. Clear browser cache completely
2. Use incognito/private mode
3. Force refresh with Ctrl+Shift+R

---

## 📚 Documentation Files

Located in `/home/rana-workspace/sorting-center/backend/`:

1. **ROUTING_RULES_GUIDE.md**
   Complete guide explaining all 11 rules, how routing works, examples

2. **FIX_SUMMARY_V5.md**
   Version history and technical fixes (v4.0 → v5.3)

3. **QUICK_TEST_V5.2.md**
   Quick testing checklist

4. **ROUTING_FIX_VERIFICATION.md**
   Detailed troubleshooting guide

5. **COMPONENTS.md**
   Reusable components library documentation

---

## 🎯 Quick Test Checklist

After logging in, verify:

- [ ] Can access routing page without errors
- [ ] See all 11 rules in the table
- [ ] Console shows "VERSION 5.3"
- [ ] Can switch between tabs
- [ ] Can open "Create Rule" modal
- [ ] Dropdown filters work
- [ ] Can view rule details (Edit button)
- [ ] No JavaScript errors in console

---

## 🔄 Alternative Admin Accounts

If needed, there are other admin accounts:

**Email:** `admin@digibox.com`
**Password:** `admin123`
**Note:** This is also a super admin account

---

**Created:** March 2, 2026
**Version:** 5.3
**Status:** ✅ Ready for testing
**Last Password Reset:** Just now
