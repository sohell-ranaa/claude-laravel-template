# Master TODO List - DigiBox Sorting Center

**Last Updated:** March 1, 2026
**Status:** 📋 ACTIVE DEVELOPMENT
**Progress:** 6/30 issues fixed (20% complete)

---

## 📊 OVERVIEW

This is the comprehensive todo list for completing all remaining features and fixes identified in the second audit (`SECOND_AUDIT_REPORT.md`).

### Progress Summary:
- ✅ **Completed:** 6 issues (Quick wins - Phase 1)
- 🔴 **Critical:** 2 remaining (out of 8)
- 🟠 **High:** 7 remaining
- 🟡 **Medium:** 9 remaining
- 🟢 **Low:** 6 remaining
- **Total Remaining:** 24 issues

---

## 🎯 PHASE 2: CRITICAL FEATURES (Week 1-2)

### 🔴 F2 - Complete Riders Management UI
**Priority:** CRITICAL | **Estimated Time:** 8-10 hours

**Subtasks:**
- [ ] **F2.1** - Build `⚡riders-list.blade.php` Livewire component
  - Table with columns: Code, Name, Phone, Vehicle Type, Status, Actions
  - Filters: Sorting center, status, vehicle type, search
  - Pagination (use config for per_page)
  - Real-time search with debounce
  - Loading states
  - Empty state with "Add Rider" CTA

- [ ] **F2.2** - Create `riders/create.blade.php` form
  - Fields: Code, Name, Phone, Email, Sorting Center, Vehicle Type, Vehicle Number
  - Max parcels/trip, Max weight
  - Client-side validation
  - Submit to `/api/riders`
  - Error handling with field-level messages

- [ ] **F2.3** - Create `riders/show.blade.php` detail view
  - Rider information card
  - Statistics (deliveries, success rate, rating)
  - COD collections summary
  - Recent deliveries list
  - Location on map (if available)
  - Edit/Delete actions
  - Status update buttons

**Acceptance Criteria:**
- ✅ Can list all riders with filters
- ✅ Can create new rider
- ✅ Can view rider details
- ✅ Can update rider status
- ✅ Responsive on mobile

---

### 🔴 F3 - Build COD Management Interface
**Priority:** CRITICAL | **Estimated Time:** 6-8 hours

**Subtasks:**
- [ ] **F3.1** - Replace "Coming soon" in `cod/index.blade.php`
  - Create Alpine.js component
  - COD collections table
  - Columns: Tracking #, Rider, Amount, Method, Status, Collected At, Actions

- [ ] **F3.2** - Add filtering system
  - Filter by: Status, Rider, Sorting Center, Date Range
  - Search by tracking number
  - Per page selector

- [ ] **F3.3** - Implement verification workflow
  - "Verify" button for collected status
  - Modal/inline form for verification notes
  - Update to verified status

- [ ] **F3.4** - Add deposit tracking
  - "Mark as Deposited" action
  - Deposit notes/reference
  - Update status to deposited

- [ ] **F3.5** - Display summary statistics
  - Total collected (by status)
  - Total amount
  - By collection method breakdown
  - Pending settlement amount

**Acceptance Criteria:**
- ✅ Can view all COD collections
- ✅ Can filter by multiple criteria
- ✅ Can verify collections
- ✅ Can mark as deposited
- ✅ Summary stats display correctly

---

### 🔴 F4 - Create Routing Management Interface
**Priority:** CRITICAL | **Estimated Time:** 8-10 hours

**Subtasks:**
- [ ] **F4.1** - Replace "Coming soon" in `routing/index.blade.php`
  - Create tabbed interface: Rules | Analytics | Bulk Routing

- [ ] **F4.2** - Build Routing Rules tab
  - Table of existing rules
  - Columns: Name, Type, Priority, Status, Effective Dates, Actions
  - Create/Edit rule modal
  - Rule form fields: Name, Type, Conditions (JSON builder), Action Config
  - Delete confirmation

- [ ] **F4.3** - Build Analytics tab
  - Routing success rate chart
  - Average routing confidence score
  - Most used rules
  - Failed routing attempts

- [ ] **F4.4** - Build Bulk Routing tab
  - Upload CSV or select parcels
  - Calculate routes for multiple parcels
  - Preview routing results
  - Apply routing button
  - Results summary

**Acceptance Criteria:**
- ✅ Can create/edit/delete routing rules
- ✅ Can view routing analytics
- ✅ Can bulk route parcels
- ✅ Rules apply correctly

---

### 🔴 F5 - Build Sorting Centers Management UI
**Priority:** CRITICAL | **Estimated Time:** 8-10 hours

**Subtasks:**
- [ ] **F5.1** - Replace "Coming soon" in `centers/index.blade.php`
  - Grid/list view toggle
  - Card-based layout for centers
  - Show: Name, Code, Type, Status, Capacity, Manager

- [ ] **F5.2** - Create center creation/edit form
  - Modal or separate page
  - Fields: Code, Name, Type, Address, Lat/Lng
  - Contact info, Manager selection
  - Capacity, Operational hours (JSON editor)
  - Status selector

- [ ] **F5.3** - Create center detail view
  - Center information
  - Coverage areas (list or map)
  - Performance metrics (from API endpoint)
  - Assigned riders list
  - Active parcels count
  - Edit/Delete actions

- [ ] **F5.4** - Add coverage area management
  - Add/remove coverage areas
  - Postal codes or area names
  - Visual feedback

**Acceptance Criteria:**
- ✅ Can view all sorting centers
- ✅ Can create/edit centers
- ✅ Can view center details
- ✅ Can manage coverage areas
- ✅ Performance metrics display

---

### 🔴 S4/F7 - Implement Proper RBAC
**Priority:** CRITICAL | **Estimated Time:** 10-12 hours

**Subtasks:**
- [ ] **F7.1** - Create database structure
  - Migration for `roles` table (id, name, description)
  - Migration for `permissions` table (id, name, description)
  - Migration for `role_permission` pivot
  - Migration for `user_roles` pivot
  - Migration for `user_sorting_centers` pivot

- [ ] **F7.2** - Create Role and Permission models
  - `app/Models/Role.php` with permissions relationship
  - `app/Models/Permission.php` with roles relationship
  - Update User model with roles and hasRole/hasPermission methods

- [ ] **F7.3** - Create roles seeder
  - Super Admin (all permissions)
  - Manager (sorting center management)
  - Operator (parcel operations)
  - Rider (delivery operations)
  - Client (view own parcels)

- [ ] **F7.4** - Fix SortingCenterPolicy TODOs
  - Replace email pattern check with role check
  - Implement user-sorting center relationship check
  - Add proper authorization for riders/operators
  - Line 14: Replace with `$user->hasRole('admin')`
  - Line 27: Implement `$user->sortingCenters->contains($sortingCenter->id)`
  - Line 32: Check user assignment
  - Line 62: Check rider assignment

- [ ] **F7.5** - Create additional policies
  - ParcelPolicy (view, create, update, delete based on role)
  - RiderPolicy
  - CodCollectionPolicy

- [ ] **F7.6** - Add authorization checks to all controllers
  - Check existing controllers for missing authorize() calls
  - Add to routes where needed

**Acceptance Criteria:**
- ✅ Roles and permissions tables exist
- ✅ All TODOs in SortingCenterPolicy resolved
- ✅ Users have role-based access
- ✅ Managers only see their centers
- ✅ No more email pattern checks

---

### 🔴 F8 - Create Settlement Feature
**Priority:** CRITICAL (for production) | **Estimated Time:** 12-15 hours

**Subtasks:**
- [ ] **F8.1** - Create Settlement model and migration
  - Migration: `settlements` table
  - Columns: id, settlement_number, client_id, total_amount, status, settlement_date, notes, created_at, updated_at
  - Status enum: pending, processing, completed, cancelled

- [ ] **F8.2** - Add settlement relationship to CodCollection
  - Add `settlement_id` column to cod_collections
  - Remove TODO comment in CodCollection model
  - Add `settlement()` relationship

- [ ] **F8.3** - Create SettlementController
  - CRUD operations
  - Calculate settlement amount (sum of COD collections)
  - Generate settlement report
  - Mark as completed

- [ ] **F8.4** - Create settlement UI
  - List all settlements with filters
  - Create settlement from pending CODs
  - Settlement detail view
  - COD collections included in settlement
  - Mark as completed/cancelled
  - Export settlement report (PDF)

- [ ] **F8.5** - Add to navigation
  - Add "Settlements" to sidebar menu
  - Route configuration

**Acceptance Criteria:**
- ✅ Settlement model exists
- ✅ Can create settlements from COD collections
- ✅ Can view settlement details
- ✅ Can mark as completed
- ✅ Settlement reports generate

---

## 🟠 PHASE 3: HIGH PRIORITY FIXES (Week 3)

### 🟠 S5/U3 - Add Toast Notification System
**Priority:** HIGH | **Estimated Time:** 3-4 hours

**Subtasks:**
- [ ] **U3.1** - Create toast notification component
  - Alpine.js based
  - Support: success, error, warning, info
  - Auto-dismiss after 5 seconds
  - Close button
  - Stack multiple notifications

- [ ] **U3.2** - Add to layouts/app.blade.php
  - Include component in layout
  - Global $toast object

- [ ] **U3.3** - Replace all alert() calls
  - Dashboard: error handling
  - Parcels: CRUD operations
  - All other views

- [ ] **U3.4** - Add server-side flash to toast
  - Convert session()->flash() to toast
  - Success/error messages

**Acceptance Criteria:**
- ✅ Toast notifications display properly
- ✅ No more alert() calls
- ✅ Better UX for all operations

---

### 🟠 S6/U2 - Add Form Validation Error Display
**Priority:** HIGH | **Estimated Time:** 4-5 hours

**Subtasks:**
- [ ] **S6.1** - Create validation error component
  - Reusable Alpine.js validation mixin
  - Field-level error display
  - Error state styling (red border)

- [ ] **S6.2** - Update parcel creation form
  - Add error display for each field
  - Real-time validation
  - Server validation error display

- [ ] **S6.3** - Update all other forms
  - Riders create/edit
  - Sorting centers create/edit
  - COD verification
  - Routing rules

- [ ] **S6.4** - Add validation rules documentation
  - Show required fields
  - Show field format (phone, email, etc.)
  - Show character limits

**Acceptance Criteria:**
- ✅ All forms show validation errors
- ✅ Field-level error messages
- ✅ Clear indication of required fields

---

### 🟠 R1 - Convert Tables to Mobile Card View
**Priority:** HIGH | **Estimated Time:** 6-8 hours

**Subtasks:**
- [ ] **R1.1** - Create responsive table wrapper component
  - Desktop: Table view
  - Mobile: Card view
  - Breakpoint: md (768px)

- [ ] **R1.2** - Update parcels table
  - Card layout for mobile
  - Show key info: tracking #, status, recipient
  - Tap to view details

- [ ] **R1.3** - Update riders table
  - Card layout with photo placeholder
  - Show: name, status, vehicle type

- [ ] **R1.4** - Update COD collections table
  - Card layout
  - Show: amount, status, rider

- [ ] **R1.5** - Update dashboard tables
  - Leaderboard in cards
  - Activity timeline remains list

- [ ] **R1.6** - Test on real devices
  - iPhone/Android
  - iPad/Tablets
  - Various screen sizes

**Acceptance Criteria:**
- ✅ All tables work on mobile
- ✅ No horizontal scroll
- ✅ Card view is readable
- ✅ Touch targets are large enough

---

### 🟠 U1 - Add Consistent Loading States
**Priority:** HIGH | **Estimated Time:** 2-3 hours

**Subtasks:**
- [ ] **U1.1** - Create loading skeleton components
  - Table skeleton
  - Card skeleton
  - Detail page skeleton

- [ ] **U1.2** - Add to riders management
  - List loading skeleton
  - Detail loading skeleton

- [ ] **U1.3** - Add to COD management
  - Table loading skeleton

- [ ] **U1.4** - Add to routing management
  - Rules table skeleton

- [ ] **U1.5** - Add to centers management
  - Grid skeleton

**Acceptance Criteria:**
- ✅ All new views have loading states
- ✅ Consistent with existing patterns
- ✅ Smooth transitions

---

### 🟠 C1 - Move Currency/Locale to Config (DONE ✅)
**Status:** COMPLETED in Phase 1

---

### 🟠 Others - General High Priority
- [ ] **H1** - Add 401/403 interceptor testing
- [ ] **H2** - Add request/response logging for debugging
- [ ] **H3** - Implement optimistic UI updates

---

## 🟡 PHASE 4: MEDIUM PRIORITY UX (Week 4)

### 🟡 F11 - Add Breadcrumb Navigation
**Priority:** MEDIUM | **Estimated Time:** 2-3 hours

**Subtasks:**
- [ ] **F11.1** - Create breadcrumb component
  - Alpine.js component
  - Dynamic based on route
  - Clickable links

- [ ] **F11.2** - Add to layouts/app.blade.php
  - Below header, above content
  - Hide on mobile if needed

- [ ] **F11.3** - Configure breadcrumbs for all pages
  - Home → Dashboard
  - Home → Parcels → [Tracking #]
  - Home → Riders → [Rider Name]
  - Etc.

**Acceptance Criteria:**
- ✅ Breadcrumbs on all pages
- ✅ Clickable and functional
- ✅ Shows current location

---

### 🟡 F9 - Implement Bulk Operations
**Priority:** MEDIUM | **Estimated Time:** 6-8 hours

**Subtasks:**
- [ ] **F9.1** - Add checkbox selection to parcels table
  - Select all checkbox
  - Individual checkboxes
  - Selected count display

- [ ] **F9.2** - Add bulk actions dropdown
  - Update status
  - Generate labels
  - Calculate routing
  - Export selected

- [ ] **F9.3** - Implement bulk API calls
  - Batch update status
  - Batch label generation
  - Batch routing calculation

- [ ] **F9.4** - Add to riders table
  - Bulk status update
  - Bulk export

- [ ] **F9.5** - Add to COD table
  - Bulk verification
  - Bulk deposit

**Acceptance Criteria:**
- ✅ Can select multiple items
- ✅ Bulk actions work correctly
- ✅ Clear feedback on success/failure

---

### 🟡 F10 - Add Data Export Functionality
**Priority:** MEDIUM | **Estimated Time:** 4-6 hours

**Subtasks:**
- [ ] **F10.1** - Install Laravel Excel package
  - `composer require maatwebsite/excel`

- [ ] **F10.2** - Create export classes
  - ParcelsExport
  - RidersExport
  - CodCollectionsExport

- [ ] **F10.3** - Add export buttons to tables
  - "Export to CSV" button
  - "Export to Excel" button
  - Respect current filters

- [ ] **F10.4** - Create export API endpoints
  - `/api/parcels/export`
  - `/api/riders/export`
  - `/api/cod-collections/export`

- [ ] **F10.5** - Add export to dashboard
  - Export trends data
  - Export leaderboard

**Acceptance Criteria:**
- ✅ Can export to CSV/Excel
- ✅ Exports respect filters
- ✅ File downloads properly

---

### 🟡 U4 - Add Empty State CTAs
**Priority:** MEDIUM | **Estimated Time:** 1-2 hours

**Subtasks:**
- [ ] **U4.1** - Update empty states with CTAs
  - Parcels: "Create First Parcel" button
  - Riders: "Add Rider" button
  - COD: "View All Parcels" link
  - Centers: "Add Sorting Center" button

**Acceptance Criteria:**
- ✅ All empty states have CTAs
- ✅ CTAs are actionable
- ✅ Good UX

---

### 🟡 U5 - Implement Filter Persistence
**Priority:** MEDIUM | **Estimated Time:** 2-3 hours

**Subtasks:**
- [ ] **U5.1** - Add URL query parameter sync
  - Update URL when filters change
  - Read filters from URL on load

- [ ] **U5.2** - Add to parcels list
- [ ] **U5.3** - Add to riders list
- [ ] **U5.4** - Add to COD list

**Alternative:** Use localStorage instead of URL

**Acceptance Criteria:**
- ✅ Filters persist on page refresh
- ✅ Shareable URLs with filters

---

### 🟡 U6 - Make Auto-Refresh Configurable
**Priority:** MEDIUM | **Estimated Time:** 1 hour

**Subtasks:**
- [ ] **U6.1** - Use config value in dashboard
  - Already in config, just not used
  - Change line 212 to use config value

- [ ] **U6.2** - Add UI toggle
  - Checkbox to enable/disable
  - Store preference in localStorage

**Acceptance Criteria:**
- ✅ Respects config value
- ✅ Can be toggled by user

---

### 🟡 Others - Medium Priority
- [ ] **M1** - Add keyboard shortcuts (/, n for new, etc.)
- [ ] **M2** - Add notification center/bell icon
- [ ] **M3** - Improve chart responsiveness

---

## 🟢 PHASE 5: LOW PRIORITY POLISH (Week 5+)

### 🟢 R2 - Improve Sidebar Mobile UX
**Priority:** LOW | **Estimated Time:** 2 hours

**Subtasks:**
- [ ] **R2.1** - Add backdrop overlay
- [ ] **R2.2** - Click outside to close
- [ ] **R2.3** - Better z-index management

---

### 🟢 F15 - Add Dark Mode
**Priority:** LOW | **Estimated Time:** 8-10 hours

**Subtasks:**
- [ ] **F15.1** - Add dark mode toggle
- [ ] **F15.2** - Apply dark: classes to all components
- [ ] **F15.3** - Store preference in localStorage
- [ ] **F15.4** - System preference detection

---

### 🟢 F14 - Build PWA Capabilities
**Priority:** LOW | **Estimated Time:** 6-8 hours

**Subtasks:**
- [ ] **F14.1** - Create manifest.json
- [ ] **F14.2** - Add service worker
- [ ] **F14.3** - Enable offline mode
- [ ] **F14.4** - Add "Add to Home Screen" prompt

---

### 🟢 U7 - Add Page Meta Tags
**Priority:** LOW | **Estimated Time:** 1 hour

**Subtasks:**
- [ ] **U7.1** - Add meta descriptions
- [ ] **U7.2** - Add Open Graph tags
- [ ] **U7.3** - Add favicon

---

### 🟢 Others - Low Priority
- [ ] **L1** - Add print styles for labels/reports
- [ ] **L2** - Add changelog/version display
- [ ] **L3** - Add user preferences page

---

## 📊 ESTIMATED TIMELINE

### Week 1-2: Critical Features (Phase 2)
- **Total Hours:** 52-65 hours
- **Focus:** Riders, COD, Routing, Centers, RBAC, Settlement
- **Expected Completion:** 80% of critical features

### Week 3: High Priority Fixes (Phase 3)
- **Total Hours:** 21-28 hours
- **Focus:** Error handling, validation, mobile responsiveness
- **Expected Completion:** All high priority items

### Week 4: Medium Priority UX (Phase 4)
- **Total Hours:** 18-25 hours
- **Focus:** Breadcrumbs, bulk ops, exports, UX polish
- **Expected Completion:** 70% of medium priority items

### Week 5+: Low Priority Polish (Phase 5)
- **Total Hours:** 17-21 hours
- **Focus:** Dark mode, PWA, final polish
- **Expected Completion:** Nice-to-have features

**Total Estimated Time:** 108-139 hours (3-4 weeks full-time)

---

## 🎯 DAILY BREAKDOWN (Example)

### Day 1-2: Riders Management
- Build Livewire component
- Create/show forms
- Test thoroughly

### Day 3: COD Management
- Replace placeholder
- Add filters and actions
- Test verification workflow

### Day 4-5: Routing Interface
- Build tabs
- Create rules UI
- Analytics display

### Day 6-7: Sorting Centers
- Build grid view
- Create forms
- Coverage areas

### Week 2: RBAC + Settlement
- Database migrations
- Models and relationships
- Policies
- Settlement UI

### Week 3: Polish & Mobile
- Toast notifications
- Form validation
- Mobile responsive tables
- Testing

### Week 4: UX Enhancements
- Breadcrumbs
- Bulk operations
- Data export
- Filter persistence

---

## ✅ COMPLETION CRITERIA

The project will be considered **feature-complete** when:

### Must Have (100% Complete):
- [x] All API endpoints functional
- [x] Dashboard works
- [x] Parcel CRUD complete
- [ ] Riders CRUD complete
- [ ] COD management complete
- [ ] Routing management complete
- [ ] Centers management complete
- [ ] RBAC properly implemented
- [ ] Settlement feature working
- [ ] Mobile responsive

### Should Have (80% Complete):
- [ ] Error handling with toasts
- [ ] Form validation on all forms
- [ ] Bulk operations on tables
- [ ] Data export functionality
- [ ] Loading states everywhere

### Nice to Have (50% Complete):
- [ ] Breadcrumbs
- [ ] Dark mode
- [ ] PWA capabilities
- [ ] Keyboard shortcuts

---

## 📋 TRACKING PROGRESS

Update this file as tasks are completed:
- Change `[ ]` to `[x]` when done
- Update progress percentages
- Move completed items to a "Done" section
- Add notes/blockers if needed

---

## 🚀 GETTING STARTED

**To start working on this list:**

1. Pick a phase (recommend starting with Phase 2)
2. Pick a specific task (e.g., F2 - Riders Management)
3. Read the subtasks carefully
4. Estimate your own time
5. Start coding!
6. Mark subtasks complete as you go
7. Test thoroughly before moving on

---

## 📝 NOTES

- Prioritize user-facing features over internal polish
- Test on real devices frequently
- Get user feedback early and often
- Don't over-engineer - YAGNI principle
- Focus on completing features fully, not half-done multiple features
- Commit often with clear messages

---

**Last Updated:** March 1, 2026
**Next Review:** After Phase 2 completion (2 weeks)

---

**END OF MASTER TODO LIST**
