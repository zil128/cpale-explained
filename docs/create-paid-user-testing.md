# Create Paid User for E2E Testing

This document explains how to create a paid user for end-to-end testing, including access to AI Analytics features.

## Quick Start

Run the automated script:

```bash
cd backend
node scripts/create-paid-user.js
```

This will create/login a paid test user and verify access to all features.

---

## Test User Credentials

| Field | Value |
|-------|-------|
| Email | `testpaid@example.com` |
| Password | `Test123!` |
| Subscription | PAID_MONTHLY (30 days) |

---

## Manual Process via API

If you need to create a paid user manually, follow these steps:

### Step 1: Register a New User

```bash
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "testpaid@example.com",
    "password": "Test123!",
    "displayName": "Test Paid User"
  }'
```

**Response:**
```json
{
  "message": "Registration successful",
  "token": "eyJhbGc...",
  "user": {
    "userId": 6,
    "email": "testpaid@example.com",
    "displayName": "Test Paid User",
    "userType": "FREE"
  }
}
```

Save the `token` and `userId` for the next steps.

### Step 2: Activate PAID Subscription

```bash
curl -X POST http://localhost:5000/api/subscription/activate \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -d '{
    "user_id": 6,
    "plan_code": "PAID_MONTHLY",
    "payment_reference": "TEST-MANUAL-001",
    "payment_provider": "MANUAL",
    "amount_paid": 149.00
  }'
```

**Response:**
```json
{
  "message": "Subscription activated successfully",
  "subscription": {
    "type": "PAID",
    "plan_code": "PAID_MONTHLY",
    "start_date": "2026-01-24",
    "end_date": "2026-02-23",
    "payment_reference": "TEST-MANUAL-001"
  }
}
```

### Step 3: Verify Subscription Status

```bash
curl http://localhost:5000/api/subscription/status \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

**Expected Response:**
```json
{
  "subscription_type": "PAID",
  "plan_code": "PAID_MONTHLY",
  "plan_name": "Paid Monthly",
  "is_active": true,
  "days_remaining": 30,
  "mcq_limit": null,
  "features": {
    "practice_sets": true,
    "unlimited_mcqs": true,
    "analytics": "basic",
    "support": "email"
  }
}
```

---

## AI Analytics Endpoints

Once you have a paid user (or any authenticated user), these endpoints are available:

| Endpoint | Description |
|----------|-------------|
| `GET /api/analytics/user/dashboard` | Full analytics dashboard |
| `GET /api/analytics/user/weak-points` | Critical topics needing attention |
| `GET /api/analytics/user/learning-patterns` | Learning patterns by difficulty/subject |
| `GET /api/analytics/user/recommendations` | AI-generated study recommendations |
| `GET /api/analytics/user/exam-readiness` | Exam readiness score & predictions |
| `GET /api/analytics/user/trend` | Performance trend over time |
| `GET /api/analytics/user/topics` | Detailed topic-level performance |
| `POST /api/analytics/user/recalculate` | Trigger fresh AI analysis |

### Example: Get AI Recommendations

```bash
curl http://localhost:5000/api/analytics/user/recommendations \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

---

## Subscription Plans

| Plan Code | Type | MCQ Limit | Duration | Price |
|-----------|------|-----------|----------|-------|
| `FREE` | Free | 50 MCQs | Unlimited | Free |
| `PAID_MONTHLY` | Paid | Unlimited | 30 days | PHP 149 |

---

## Database Tables

The following tables are involved in subscription management:

- `users` - User accounts
- `subscription_plans_v2` - Available plans (FREE, PAID_MONTHLY)
- `user_subscriptions_v2` - User subscription records
- `user_mcq_usage` - MCQ usage tracking

### Direct SQL: Upgrade Existing User to PAID

```sql
-- Get plan ID
SET @paid_plan_id = (SELECT plan_id FROM subscription_plans_v2 WHERE plan_code = 'PAID_MONTHLY');

-- Upgrade user
UPDATE user_subscriptions_v2 
SET 
  plan_id = @paid_plan_id,
  subscription_type = 'PAID',
  start_date = CURDATE(),
  end_date = DATE_ADD(CURDATE(), INTERVAL 30 DAY),
  is_active = TRUE,
  payment_reference = 'MANUAL-TEST',
  payment_provider = 'MANUAL',
  amount_paid = 149.00,
  updated_at = NOW()
WHERE user_id = YOUR_USER_ID;

-- Reset MCQ usage
UPDATE user_mcq_usage
SET mcqs_attempted = 0, last_reset_date = CURDATE()
WHERE user_id = YOUR_USER_ID;
```

---

## E2E Testing Flow

1. **Start the backend server:**
   ```bash
   cd backend && npm start
   ```

2. **Run the paid user script:**
   ```bash
   node scripts/create-paid-user.js
   ```

3. **Login to the frontend:**
   - Open `http://localhost:3000`
   - Login with `testpaid@example.com` / `Test123!`

4. **Generate analytics data:**
   - Answer MCQ questions
   - Complete at least 10-20 questions for meaningful analytics

5. **Access AI Analytics:**
   - Navigate to Analytics/Dashboard section
   - Verify weak points, recommendations, and exam readiness display

---

## Troubleshooting

### "ECONNREFUSED" Error
The backend server is not running. Start it with:
```bash
cd backend && npm start
```

### "Email already registered" Error
The user already exists. The script will automatically login instead.

### "Failed to activate subscription" Error
The user may already have an active PAID subscription. Check status first:
```bash
curl http://localhost:5000/api/subscription/status \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### No Analytics Data
The user needs to answer MCQ questions first. Analytics are generated from the `user_answer_history` table.

---

## Files Reference

| File | Description |
|------|-------------|
| `backend/scripts/create-paid-user.js` | Automated paid user creation script |
| `backend/routes/subscription.js` | Subscription API endpoints |
| `backend/routes/userAnalytics.js` | AI Analytics API endpoints |
| `backend/services/aiAnalytics.js` | AI analytics engine |
| `backend/middleware/subscriptionCheck.js` | Subscription verification middleware |
| `database/migrations/mvp_phase1_migration.sql` | Subscription schema |
| `database/migrations/mvp_phase1_test_data.sql` | Pre-made test users |

---

## Pre-Made Test Users (Alternative)

If you prefer to use pre-made test users from the migration script:

```bash
mysql -u root -p cpale_explained < database/migrations/mvp_phase1_test_data.sql
```

This creates:

| Email | Password | Subscription |
|-------|----------|--------------|
| `testfree@cpale.com` | `Test123!` | FREE (15/50 MCQs used) |
| `testpaid@cpale.com` | `Test123!` | PAID (25 days remaining) |
| `testexpired@cpale.com` | `Test123!` | PAID (expired 5 days ago) |
