# DigiBox Logistics - Security & Code Audit Report

**Date:** March 1, 2026  
**Auditor:** Automated Code Analysis  
**Status:** CRITICAL ISSUES FOUND

---

## 🔴 CRITICAL ISSUES

### 1. **Hardcoded Secrets & Fallback Values**

**Location:** `app/Http/Controllers/Api/WebhookController.php:76`
```php
$secret = config('app.webhook_secret', 'default_secret');
```

**Location:** `app/Services/WebhookService.php:243`
```php
$secret = config('app.webhook_secret', 'default_secret');
```

**Issue:** Using `'default_secret'` as fallback is a SECURITY VULNERABILITY!

**Risk:** HIGH
- If `webhook_secret` is not set in config, uses predictable secret
- Attackers can forge webhook signatures
- Compromises entire webhook security

**Fix Required:**
```php
$secret = config('app.webhook_secret');
if (empty($secret)) {
    throw new \RuntimeException('Webhook secret not configured. Set APP_WEBHOOK_SECRET in .env');
}
```

---

### 2. **Hardcoded Test Credentials in Seeders**

**Location:** `database/seeders/UserSeeder.php:19-20`
```php
'email' => 'admin@digibox.com',
'password' => Hash::make('password123'),
```

**Issue:** ALL users use same password 'password123'

**Risk:** CRITICAL
- If seeders run in production, creates weak passwords
- Predictable admin credentials
- Security breach waiting to happen

**Fix Required:**
- Use environment variables for passwords
- Add warning in seeder about production use
- Use strong random passwords via Faker in dev

```php
'password' => Hash::make(env('ADMIN_PASSWORD', Str::random(32))),
```

---

### 3. **Hardcoded Company Name**

**Locations:**
- `app/Services/NotificationService.php:47,57`
- All Blade views titles
- `routes/api.php:19`

**Issue:** "DigiBox Logistics" hardcoded everywhere

**Risk:** LOW (Maintenance issue, not security)
- Difficult to white-label or rebrand
- Hard to maintain consistency

**Fix Required:**
```php
// config/app.php
'company_name' => env('COMPANY_NAME', 'DigiBox Logistics'),

// Usage
config('app.company_name')
```

---

### 4. **Hardcoded Limits in Livewire Components**

**Location:** `resources/views/components/⚡dashboard.blade.php:25-29`
```php
$this->trends = $analytics->getParcelTrends(7);  // Hardcoded 7 days
$this->leaderboard = $analytics->getRiderLeaderboard(10);  // Hardcoded 10
->limit(20)  // Hardcoded 20 activities
```

**Issue:** No user control over dashboard display

**Risk:** LOW (UX issue)
- Users can't customize their dashboard
- Performance issues if data grows

**Fix Required:**
```php
public $trendDays = 7;
public $leaderboardLimit = 10;
public $activityLimit = 20;

// Allow users to customize via dropdown
```

---

### 5. **Missing Relationships in Models**

**Location:** Multiple Model files

**Issues Found:**

#### Parcel Model:
```php
// MISSING RELATIONSHIPS:
- belongsTo('client') // Missing!
- hasMany('events') // Exists but events might not inverse
- hasMany('labels') // Missing!
```

#### CodCollection Model:
```php
// MISSING RELATIONSHIPS:
- belongsTo('sortingCenter') // Missing!
- belongsTo('verifier', User::class) // Missing!
- belongsTo('settlement') // Missing!
```

#### SortingCenter Model:
```php
// MISSING RELATIONSHIPS:
- hasMany('parcels', 'origin_sorting_center_id') // Missing!
- hasMany('riders') // Missing!
- belongsTo('manager', User::class) // Missing!
```

**Risk:** MEDIUM
- Causes N+1 query problems
- Cannot eager load related data
- Poor performance at scale

---

### 6. **No Input Sanitization**

**Location:** `app/Http/Controllers/Api/ParcelController.php` and others

**Issue:** Direct database queries without sanitization

**Example:**
```php
// Line 206 - Potential SQL injection if not using Eloquent correctly
$query->latest()->limit(20);
```

**Risk:** MEDIUM
- While Eloquent protects against most SQL injection
- Raw queries or DB::raw() could be vulnerable
- Need audit of all controllers

---

### 7. **Missing Validation Rules**

**Location:** `app/Http/Controllers/Api/WebhookController.php:22-45`

**Issue:** Webhook validation insufficient

```php
$validated = $request->validate([
    'client_id' => 'required|integer|exists:users,id',
    'reference_number' => 'nullable|string|max:100',
    'sender.name' => 'required|string|max:255',
    'sender.phone' => 'required|string|max:20',
    // Missing: Phone format validation
    // Missing: Weight range validation
    // Missing: COD amount validation (min/max)
]);
```

**Risk:** MEDIUM
- Invalid data could enter database
- No business logic validation
- Potential data corruption

---

### 8. **No Authorization Middleware**

**Location:** Multiple controllers

**Issue:** API endpoints missing authorization checks

**Example:**
```php
// DashboardController.php - No check if user can access this center's data
public function overview(Request $request): JsonResponse
{
    // Missing: Check if user has permission to view this data
    $sortingCenterId = $request->get('sorting_center_id');
}
```

**Risk:** HIGH
- Users might access data from other sorting centers
- No role-based access control
- Privacy breach

**Fix Required:**
```php
// Add policy
$this->authorize('view', SortingCenter::find($sortingCenterId));
```

---

### 9. **Missing Database Indexes**

**Location:** Migration files

**Issues:**
```sql
-- parcels table
-- MISSING: Index on client_id (foreign key, frequently queried)
-- MISSING: Compound index on (current_status, sorting_center_id)
-- MISSING: Index on recipient_phone (for lookup)

-- parcel_events table
-- MISSING: Compound index on (parcel_id, created_at)

-- cod_collections table
-- MISSING: Compound index on (rider_id, status)
-- MISSING: Index on collected_at (for date range queries)
```

**Risk:** HIGH (Performance)
- Slow queries as data grows
- Database CPU spikes
- Poor user experience

---

### 10. **No Error Handling in Services**

**Location:** `app/Services/AnalyticsService.php`, `app/Services/WebhookService.php`

**Issue:** Services don't catch or handle exceptions

**Example:**
```php
public function getDashboardStats(?int $sortingCenterId = null): array
{
    // No try-catch block
    // If database fails, entire request crashes
    return Cache::remember($cacheKey, 300, function() {
        // What if this fails?
    });
}
```

**Risk:** MEDIUM
- Poor error messages to users
- Application crashes
- No logging of failures

---

### 11. **Environment-Specific Code**

**Location:** `app/Http/Controllers/Api/ParcelController.php:77`

```php
// In production, this would call the DigiBox Kiosk API to validate
// TODO: Implement actual validation
```

**Issue:** Production code path not implemented!

**Risk:** CRITICAL
- Feature doesn't work in production
- Validation bypassed
- Data integrity issues

---

### 12. **Hardcoded Pagination Defaults**

**Location:** `resources/views/components/⚡parcels-list.blade.php:13`
```php
public $perPage = 25;  // Hardcoded
```

**Issue:** Should be configurable

**Fix Required:**
```php
public $perPage;

public function mount()
{
    $this->perPage = config('app.default_pagination', 25);
}
```

---

## 🟡 MEDIUM PRIORITY ISSUES

### 13. **No Rate Limiting on Webhooks**

**Location:** `routes/api.php`

**Issue:** Webhook endpoints have no rate limiting

**Risk:** MEDIUM
- DDoS vulnerability
- Resource exhaustion
- Server crashes

**Fix Required:**
```php
Route::post('webhooks/kiosk/parcel', [WebhookController::class, 'receiveKioskParcel'])
    ->middleware('throttle:webhook');
```

---

### 14. **Missing API Versioning**

**Location:** `routes/api.php`

**Issue:** No API versioning strategy

**Current:**
```
/api/parcels
```

**Should be:**
```
/api/v1/parcels
```

**Risk:** MEDIUM
- Breaking changes affect all clients
- No migration path
- Can't maintain backwards compatibility

---

### 15. **No Logging in Critical Operations**

**Location:** All controllers

**Issue:** No audit trail for:
- User actions
- Data modifications
- Authorization failures
- System errors

**Fix Required:**
```php
Log::info('Parcel created', [
    'parcel_id' => $parcel->id,
    'user_id' => auth()->id(),
    'ip' => $request->ip(),
]);
```

---

### 16. **Missing Soft Deletes**

**Location:** All models

**Issue:** No soft deletes on critical tables

**Tables needing soft deletes:**
- parcels
- riders
- sorting_centers
- users

**Risk:** MEDIUM
- Data loss
- No recovery option
- Audit trail gaps

---

### 17. **No Request/Response Logging**

**Location:** Middleware

**Issue:** No HTTP request/response logging

**Risk:** MEDIUM
- Debugging difficult
- No audit trail
- Performance issues hard to track

---

## 🟢 LOW PRIORITY ISSUES

### 18. **Inconsistent Naming Conventions**

**Examples:**
- `perPage` vs `per_page`
- `sortingCenterId` vs `sorting_center_id`
- Mix of camelCase and snake_case

---

### 19. **No API Documentation**

**Issue:** No Swagger/OpenAPI documentation

**Impact:**
- Integration difficult
- No API spec
- Manual testing required

---

### 20. **Missing Test Coverage**

**Issue:** NO tests written!

**Directories empty:**
- `tests/Feature/`
- `tests/Unit/`

**Risk:** HIGH
- No confidence in code changes
- Regressions not caught
- Difficult to refactor

---

## 📊 AUDIT SUMMARY

| Severity | Count | Percentage |
|----------|-------|------------|
| 🔴 Critical | 3 | 15% |
| 🔴 High | 4 | 20% |
| 🟡 Medium | 8 | 40% |
| 🟢 Low | 5 | 25% |
| **Total** | **20** | **100%** |

---

## ✅ IMMEDIATE ACTION ITEMS (Priority Order)

1. **CRITICAL:** Remove `'default_secret'` fallback
2. **CRITICAL:** Fix seeder passwords
3. **HIGH:** Add authorization middleware
4. **HIGH:** Add database indexes
5. **HIGH:** Implement production validation
6. **MEDIUM:** Add rate limiting
7. **MEDIUM:** Implement error handling
8. **MEDIUM:** Add logging
9. **MEDIUM:** Add soft deletes
10. **LOW:** Move hardcoded values to config

---

## 📋 RECOMMENDED FIXES

### Create Config File for Dashboard

```php
// config/dashboard.php
return [
    'default_trend_days' => env('DASHBOARD_TREND_DAYS', 7),
    'default_leaderboard_limit' => env('DASHBOARD_LEADERBOARD_LIMIT', 10),
    'default_activity_limit' => env('DASHBOARD_ACTIVITY_LIMIT', 20),
];
```

### Create Config File for App Branding

```php
// config/branding.php
return [
    'company_name' => env('COMPANY_NAME', 'DigiBox Logistics'),
    'company_email' => env('COMPANY_EMAIL', 'support@digibox.com'),
    'support_phone' => env('SUPPORT_PHONE', '+880 1234567890'),
];
```

### Add Missing Indexes Migration

```php
// database/migrations/YYYY_MM_DD_add_missing_indexes.php
public function up()
{
    Schema::table('parcels', function (Blueprint $table) {
        $table->index('client_id');
        $table->index(['current_status', 'origin_sorting_center_id']);
        $table->index('recipient_phone');
    });
    
    Schema::table('parcel_events', function (Blueprint $table) {
        $table->index(['parcel_id', 'created_at']);
    });
    
    Schema::table('cod_collections', function (Blueprint $table) {
        $table->index(['rider_id', 'status']);
        $table->index('collected_at');
    });
}
```

---

**Last Updated:** March 1, 2026  
**Next Review:** Before Production Deployment  
**Status:** ⚠️ NOT PRODUCTION READY
