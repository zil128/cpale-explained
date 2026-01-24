
## ACCESS LEVEL

let us analyze the 'users' table to align `access_level` column and the `is_paid` column in the 'questions' table and other table that will be affected. Analyze the tables in MySQL let us clean up and Drop a table if necessary and create the required table for this purpose

purpose : to remove the redundancy and align tables dynamically with the USER SUBSCRIPTION

## USER SUBSCRIPTION

read user-subscription.md


## USER SUBSCRIPTION

- FREE
- PAID
    30 DAYS
    60 DAYS
    90 DAYS
    120 DAYS
    180 DAYS

this will be displayed in the UI as selection to choose a PAID plan, showing the plan and the corresponding pricing

## ACCESS MCQ

- FREE - 50 FREE MCQ only
- PAID
    30 DAYS - all MCQ with different practice sets and mock exam
    60 DAYS - all MCQ with different practice sets and mock exam
    90 DAYS - all MCQ with different practice sets and mock exam
    120 DAYS - all MCQ with different practice sets and mock exam
    180 DAYS - all MCQ with different practice sets and mock exam

## PRICING

- FREE - 0
- PAID
    30 DAYS - php149
    60 DAYS - php288
    90 DAYS - php429
    120 DAYS - php549
    150 DAYS - php699
    180 DAYS - php799

## PRICING HTML AND LANDING PAGE

UPDATE affected html
    - pricing.html
    - index.html
    - dashboard.html
    - quiz.html
    - register.html


## FOR MVP

let us establish and test the functionality of FREE vs PAIN in MVP

## PHASE 2

apply the tierred pricing after MVP testing on user subscription for FREE vs PAID is completed

## PHASE 3

apply and test functionalities of AI analytics for the uses, spot weak point on subject / topics, then automatically introduce MCQ that is applicable to the uses based on the result of AI analytics



Based on my analysis, I've identified the current state and created a comprehensive plan to align the access level system with the tiered subscription model. Here's what I found and what needs to be done:
---
Current State Analysis
Database Schema Issues:
1. questions table has BOTH is_paid (tinyint) AND access_level (ENUM) columns - REDUNDANT
   - Current access_level values: 'FREE','BASIC','PRO','PREMIUM'
   - is_paid is a boolean flag (0/1)
2. practice_sets table also has BOTH is_paid AND access_level columns - REDUNDANT
   - Current access_level values: 'FREE','BASIC','ADVANCE'
3. user_subscriptions table has:
   - plan_type: 'FREE', 'MONTHLY', 'YEARLY', 'LIFETIME' (doesn't match doc requirements)
   - Missing tiered day-based plans (30, 60, 90, 120, 150, 180 days)
4. Pricing in HTML shows:
   - BASIC: P149/month, P800/6-month
   - ADVANCE: P299/month, P1599/6-month
   - Doesn't match doc requirements (PHP149 for 30 days, etc.)



   Recommended Plan (Phased Approach)
PHASE 1: MVP - FREE vs PAID (SIMPLIFY FIRST)
Database Changes:
1. Standardize Access Levels
   - REMOVE is_paid column from questions and practice_sets tables
   - UPDATE access_level ENUM to: 'FREE', 'PAID' (MVP simplification)
   - Migrate existing data:
     - access_level IN ('FREE') → stays 'FREE'
     - access_level IN ('BASIC', 'PRO', 'PREMIUM', 'ADVANCE') OR is_paid = 1 → becomes 'PAID'
2. Simplify User Subscriptions
   - Update plan_type ENUM to: 'FREE', 'PAID'
   - Add duration_days column (INT) for future use
   - Add price_php column (DECIMAL) for future use
3. Update Questions Access Control
   - FREE users: Access to questions WHERE access_level = 'FREE' (limit 50 MCQs)
   - PAID users: Access to ALL questions
   Backend Changes:
4. Update API Endpoints (server.js):
   - /api/questions/free - already filters by access_level = 'FREE' ✓
   - /api/practice-sets - update to check user subscription and filter by access_level
   - Add middleware to check user subscription status
5. Access Control Logic:
   if (userSubscription === 'FREE') {
     // Limit to 50 MCQs with access_level = 'FREE'
   } else if (userSubscription === 'PAID') {
     // Access to ALL MCQs
   }

Frontend Changes:
6. Update HTML Files:
   - pricing.html - Simplify to show FREE (P0) vs PAID (single price)
   - dashboard.html - Show subscription status and upgrade prompt
   - quiz.html - Display locked content for FREE users
   - index.html - Update pricing section
   - register.html - Update plan selection

PHASE 2: TIERED PRICING (After MVP Testing)
Database Changes:
1. Expand Access Levels
   - Update access_level ENUM to match requirements based on performance
   - Consider: 'FREE', 'BASIC', 'PREMIUM', 'PRO' or day-based tiers
2. Subscription Plans Table
   - Already exists in payment_schema.sql ✓
   - Update plan codes to match day-based tiers:
     - PAID_30 - P149 (30 days)
     - PAID_60 - P288 (60 days)
     - PAID_90 - P429 (90 days)
     - PAID_120 - P549 (120 days)
     - PAID_150 - P699 (150 days)  
     - PAID_180 - P799 (180 days)
3. User Subscriptions
   - Link to subscription_plans table via plan_id
   - Track start_date and end_date
   - Auto-expire subscriptions based on duration
Frontend Changes:
4. Update Pricing HTML:
   - Display all 6 tiered plans with durations
   - Show pricing from subscription_plans table
   - Highlight "Best Value" for longer durations
PHASE 3: AI ANALYTICS (Future)
1. Track User Performance:
   - Already have user_progress table ✓
   - Add AI analytics to identify weak topics
   - Recommend targeted MCQs based on performance
2. Adaptive Learning:
   - Generate personalized practice sets
   - Focus on weak areas identified by AI

DETAILED EXECUTION PLAN - MVP Phase 1
Based on your decisions:
- Pricing: P149/month for PAID plan
- Access Levels: 'FREE', 'PAID' (simple)
- Free MCQs: 50 questions
- Migration: Gradual (new tables alongside old)
- Payment: Keep GCash, Maya, Bank Transfer


EXECUTION ROADMAP
Pre-Migration (Safety First)
Files to Create:
1. database/migrations/backup_current_state.sql
   - Backup script for current database state
   - Can rollback if needed
2. database/migrations/mvp_phase1_migration.sql
   - Create new simplified tables
   - Migrate data from old to new
   - Keep old tables as _old suffix for safety


Database Changes
New/Modified Tables:
1. subscription_plans_v2 (new clean table)
      - plan_id
   - plan_code: 'FREE', 'PAID_MONTHLY'
   - plan_name: 'Free Plan', 'Paid Monthly'
   - price_php: 0.00, 149.00
   - duration_days: NULL, 30
   - features: JSON
   - is_active
   
2. user_subscriptions_v2 (simplified)
      - subscription_id
   - user_id
   - plan_id (FK to subscription_plans_v2)
   - subscription_type: ENUM('FREE', 'PAID')
   - start_date
   - end_date (NULL for FREE, calculated for PAID)
   - is_active
   - payment_reference
3. questions - Add new column alongside old
      - ADD COLUMN access_type ENUM('FREE', 'PAID') DEFAULT 'FREE'
   - Migrate: UPDATE based on existing access_level and is_paid
   - Keep old columns for now (can drop after testing)
   
4. practice_sets - Same approach
      - ADD COLUMN access_type ENUM('FREE', 'PAID') DEFAULT 'FREE'
   - Migrate data
   - Keep old columns

Backend Changes
Files to Create/Modify:
1. backend/middleware/subscriptionCheck.js (NEW)
   - Middleware to check user subscription status
   - Returns user's current plan type (FREE/PAID)
   - Checks expiration for PAID users
2. backend/routes/subscription.js (NEW)
   - /api/subscription/status - Get current user subscription
   - /api/subscription/plans - Get available plans
   - /api/subscription/upgrade - Upgrade from FREE to PAID
3. backend/server.js (MODIFY)
   - Update /api/questions/free to use access_type = 'FREE'
   - Add /api/questions/paid endpoint
   - Update /api/practice-sets to filter by subscription
   - Add subscription middleware to protected routes
4. backend/config/plans.js (NEW)
   - Central config for MVP plans
      FREE: { price: 0, duration: null, mcq_limit: 50 }
   PAID: { price: 149, duration: 30, mcq_limit: null }

Frontend Changes
Files to Modify:
1. landing-page/pricing.html
   - Simplify to 2 cards: FREE and PAID
   - FREE: P0, 50 MCQs
   - PAID: P149/month, ALL MCQs + Practice Sets
   - Remove 6-month option for MVP
   - Update JavaScript to use new plan codes
2. landing-page/dashboard.html
   - Add subscription status widget
   - Show "Upgrade to PAID" banner for FREE users
   - Display remaining days for PAID users
   - Lock premium features with upgrade prompts
3. landing-page/quiz.html
   - Check user subscription before loading practice sets
   - Show lock icon on PAID-only content
   - Redirect to pricing on attempted access
4. landing-page/index.html
   - Update pricing section to match new pricing.html
   - Simplify to FREE vs PAID comparison
5. landing-page/register.html
   - Default to FREE plan on registration
   - Option to select PAID during registration


Migration Script Structure
File: database/migrations/mvp_phase1_migration.sql
-- ================================================================
-- MVP PHASE 1 MIGRATION: FREE vs PAID
-- Date: 2026-01-18
-- Purpose: Simplify access levels, remove redundancy
-- Strategy: Create new tables alongside old (gradual migration)
-- ================================================================
-- STEP 1: Create new subscription plans table
CREATE TABLE subscription_plans_v2 (...)
-- STEP 2: Insert MVP plans (FREE, PAID_MONTHLY)
INSERT INTO subscription_plans_v2 VALUES (...)
-- STEP 3: Add new access_type column to questions
ALTER TABLE questions ADD COLUMN access_type ENUM('FREE','PAID') DEFAULT 'FREE'
-- STEP 4: Migrate data to new column
UPDATE questions SET access_type = 'PAID' WHERE is_paid = 1 OR access_level != 'FREE'
-- STEP 5: Same for practice_sets
ALTER TABLE practice_sets ADD COLUMN access_type ENUM('FREE','PAID') DEFAULT 'FREE'
UPDATE practice_sets SET access_type = 'PAID' WHERE is_paid = 1 OR access_level != 'FREE'
-- STEP 6: Create user_subscriptions_v2
CREATE TABLE user_subscriptions_v2 (...)
-- STEP 7: Migrate existing users (all start as FREE)
INSERT INTO user_subscriptions_v2 SELECT ... FROM users
-- STEP 8: Create indexes for performance
CREATE INDEX idx_access_type ON questions(access_type)
CREATE INDEX idx_practice_access ON practice_sets(access_type)
-- STEP 9: Rename old tables (safety backup)
-- (Will do this AFTER confirming new system works)
-- RENAME TABLE user_subscriptions TO user_subscriptions_old

API Endpoint Changes
New Endpoints:
1. GET /api/subscription/status
   - Returns user's current plan, expiration, MCQ count used
2. GET /api/subscription/plans
   - Returns available plans (FREE, PAID)
3. POST /api/subscription/upgrade
   - Body: { plan_code: 'PAID_MONTHLY', payment_method: 'GCASH' }
   - Creates payment transaction, updates subscription
Modified Endpoints:
4. GET /api/questions/free
   - Change WHERE clause: access_type = 'FREE' (was access_level = 'FREE')
5. GET /api/practice-sets/:setId/start
   - Add subscription check middleware
   - Return 403 if FREE user accessing PAID content


Testing Checklist
Database Testing:
- [ ] Verify 50 questions marked as FREE
- [ ] Verify remaining questions marked as PAID
- [ ] Verify all practice sets properly classified
- [ ] Test subscription plan data
Backend Testing:
- [ ] FREE user can fetch 50 FREE questions
- [ ] FREE user blocked from PAID questions
- [ ] PAID user can access ALL questions
- [ ] Subscription status endpoint works
- [ ] Payment creation works with new plans
Frontend Testing:
- [ ] pricing.html shows 2 plans correctly
- [ ] dashboard.html shows subscription status
- [ ] Upgrade flow works end-to-end
- [ ] Locked content shows upgrade prompt
- [ ] Payment modal works with GCash/Maya/Bank
Integration Testing:
- [ ] Register as FREE → verify 50 MCQ limit
- [ ] Upgrade to PAID → verify full access
- [ ] Subscription expiration works
- [ ] Payment reference generated correctly

Execution Order (When You're Ready)
1. Create backup → mvp_phase1_backup.sql
2. Run migration → mvp_phase1_migration.sql
3. Create backend files → middleware, routes, config
4. Update server.js → new endpoints, middleware
5. Update frontend files → pricing, dashboard, quiz, index, register
6. Insert test data → mvp_phase1_test_data.sql
7. Run tests → Follow testing checklist
8. Verify in browser → Full user flow testing
9. Clean up → Drop old columns after 1 week of stable operation
---
Phase 2 Preparation
After MVP is tested and stable, we'll be ready for:
- Tiered pricing (30/60/90/120/150/180 days)
- Update access_type to support tiers if needed
- Expand subscription_plans_v2 with new plans
- Update pricing.html to show all tiers

FINAL COMPREHENSIVE IMPLEMENTATION PLAN
Requirements Confirmed:
- ✓ FREE MCQ Selection: Random 50 from all questions
- ✓ PAID Plan: P149 for 30 days, manual renewal
- ✓ Practice Sets: FREE users only see FREE practice sets (hide PAID)
- ✓ Payment: Auto-activation after payment verification

COMPLETE FILE-BY-FILE IMPLEMENTATION PLAN
📁 PHASE 1: DATABASE MIGRATION
File 1: database/migrations/mvp_phase1_backup.sql
Purpose: Backup current database before migration
-- Backup all tables that will be modified
CREATE TABLE questions_backup_20260118 AS SELECT * FROM questions;
CREATE TABLE practice_sets_backup_20260118 AS SELECT * FROM practice_sets;
CREATE TABLE user_subscriptions_backup_20260118 AS SELECT * FROM user_subscriptions;
File 2: database/migrations/mvp_phase1_migration.sql
Purpose: Main migration script
Actions:
1. Create subscription_plans_v2 table with 2 plans:
   - FREE: P0, unlimited duration, 50 MCQ limit
   - PAID_MONTHLY: P149, 30 days, unlimited MCQs
2. Add access_type ENUM('FREE','PAID') to questions table
3. Randomly select 50 questions and mark as access_type='FREE'
4. Mark remaining questions as access_type='PAID'
5. Add access_type to practice_sets table
6. Mark practice sets based on their current access_level
7. Create user_subscriptions_v2 table with simplified structure
8. Migrate all existing users to FREE plan by default
9. Create indexes for performance

File 3: database/migrations/mvp_phase1_select_free_mcqs.sql
Purpose: Logic to randomly select 50 FREE MCQs across all 6 subjects
Strategy:
-- Select ~8-9 questions per subject (total 50)
-- Ensure variety: mix of EASY/MEDIUM difficulty
-- Distribution:
  FAR: 9 questions
  AFAR: 9 questions
  AUD: 8 questions
  TAX: 8 questions
  MS: 8 questions
  RFBT: 8 questions
-- Total: 50 questions marked as FREE

File 4: database/migrations/mvp_phase1_test_data.sql
Purpose: Create test users and subscriptions for testing
-- Test User 1: FREE plan
-- Test User 2: PAID plan (active)
-- Test User 3: PAID plan (expired)
File 5: database/migrations/mvp_phase1_rollback.sql
Purpose: Rollback script if migration fails
-- Drop new columns
-- Drop new tables
-- Restore from backup tables

PHASE 2: BACKEND IMPLEMENTATION
File 6: backend/config/plans.js (NEW)
Purpose: Central configuration for MVP subscription plans
module.exports = {
  FREE: {
    code: 'FREE',
    name: 'Free Plan',
    price: 0,
    duration_days: null,
    mcq_limit: 50,
    features: {
      practice_sets: false,
      mock_exams: false,
      analytics: 'basic'
    }
  },
  PAID_MONTHLY: {
    code: 'PAID_MONTHLY',
    name: 'Paid Monthly',
    price: 149,
    duration_days: 30,
    mcq_limit: null,
    features: {
      practice_sets: true,
      mock_exams: false,
      analytics: 'basic'
    }
  }
};


File 7: backend/middleware/subscriptionCheck.js (NEW)
Purpose: Middleware to verify user subscription status
Functions:
1. authenticateSubscription(req, res, next) - Check if user has valid subscription
2. requirePaidPlan(req, res, next) - Block if user is FREE
3. getUserSubscriptionStatus(userId) - Helper to get subscription details
4. isSubscriptionExpired(subscription) - Check expiration
Logic:
// Check subscription from user_subscriptions_v2
// If PAID: verify end_date > TODAY
// If expired: downgrade to FREE automatically
// Attach subscription to req.user.subscription


File 8: backend/routes/subscription.js (NEW)
Purpose: Subscription management endpoints
Endpoints:
1. GET /api/subscription/status - Get current user subscription
2. GET /api/subscription/plans - List available plans
3. POST /api/subscription/upgrade - Upgrade to PAID
4. POST /api/subscription/verify-payment - Auto-activate after payment
File 9: backend/routes/payment.js (MODIFY)
Purpose: Update payment routes for auto-activation
Changes:
1. After payment creation → trigger auto-activation
2. Update payment_transactions with webhook/callback
3. On successful payment → update user_subscriptions_v2
4. Calculate end_date = start_date + 30 days

File 10: backend/server.js (MODIFY)
Purpose: Integrate new routes and middleware
Changes:
Line ~10: Add new imports
const subscriptionRoutes = require('./routes/subscription');
const subscriptionCheck = require('./middleware/subscriptionCheck');
const planConfig = require('./config/plans');

Line ~50: Register routes
app.use('/api/subscription', subscriptionRoutes);
Line ~282: Update FREE questions endpoint
// CHANGE: WHERE q.access_level = 'FREE'
// TO: WHERE q.access_type = 'FREE'
Line ~370: Update practice sets endpoint
// ADD subscription check
app.get('/api/practice-sets', authenticateToken, subscriptionCheck, async (req, res) => {
  const userPlan = req.user.subscription.subscription_type;
  
  // If FREE: only return practice sets with access_type='FREE'
  let query = 'SELECT * FROM practice_sets WHERE is_active = TRUE';
  if (userPlan === 'FREE') {
    query += " AND access_type = 'FREE'";
  }
  // If PAID: return all practice sets
});

New Endpoint: Add question count tracker
// GET /api/questions/usage
// Returns: { attempted: 25, limit: 50, remaining: 25 }
// Only for FREE users

PHASE 3: FRONTEND IMPLEMENTATION
File 11: landing-page/pricing.html (MODIFY)
Purpose: Simplify to FREE vs PAID pricing
Changes:
Lines 220-231: Remove billing period tabs
<!-- DELETE the Monthly/6-Month tabs section -->
<!-- Keep only simple 2-column layout -->
Lines 234-396: Update pricing cards
<!-- CARD 1: FREE (keep as is) -->
<!-- CARD 2: PAID - REMOVE BASIC, rename to "Paid Plan" -->
<!-- CARD 3: DELETE ADVANCE card -->
<!-- Update PAID card -->
<div class="pricing-card featured glass rounded-3xl p-8">
  <h3>Paid Plan</h3>
  <div class="mb-6">
    <span class="text-5xl font-bold">P149</span>
    <span class="text-gray-500">/month (30 days)</span>
  </div>
  <ul>
    <li>ALL MCQs (1000+)</li>
    <li>All 6 CPALE subjects</li>
    <li>Practice Sets (75 MCQs each)</li>
    <li>Basic analytics dashboard</li>
    <li>Email support</li>
  </ul>
  <button onclick="selectPlan('PAID_MONTHLY')">Get Paid Plan</button>
</div>

Lines 507-716: Update JavaScript
// Remove plansData object complexity
const plansData = {
  FREE: { code: 'FREE', price: 0 },
  PAID_MONTHLY: { code: 'PAID_MONTHLY', price: 149 }
};
// Remove switchBillingPeriod function
// Simplify selectPlan function
File 12: landing-page/dashboard.html (MODIFY)
Purpose: Add subscription status widget and upgrade prompts
Add at top (~line 50):
<!-- Subscription Status Widget -->
<div id="subscriptionWidget" class="glass rounded-3xl p-6 mb-6">
  <div class="flex justify-between items-center">
    <div>
      <h3 class="text-lg font-bold">Your Plan: <span id="planName">Free</span></h3>
      <p class="text-sm text-gray-600" id="planDetails">50 FREE MCQs available</p>
    </div>
    <div id="upgradeButton" class="hidden">
      <a href="pricing.html" class="px-6 py-3 bg-gradient-to-r from-primary to-accent text-white rounded-xl">
        Upgrade to Paid
      </a>
    </div>
  </div>
  <!-- Progress bar for FREE users showing MCQ usage -->
  <div id="mcqUsageBar" class="hidden mt-4">
    <div class="flex justify-between text-sm mb-2">
      <span>MCQs Used</span>
      <span id="mcqCount">0/50</span>
    </div>
    <div class="w-full bg-gray-200 rounded-full h-2">
      <div id="mcqProgress" class="bg-primary h-2 rounded-full" style="width: 0%"></div>
    </div>
  </div>
</div>
Add JavaScript (~line 200):
// Fetch and display subscription status
async function loadSubscriptionStatus() {
  const token = localStorage.getItem('token');
  const res = await fetch('/api/subscription/status', {
    headers: { 'Authorization': `Bearer ${token}` }
  });
  const data = await res.json();
  
  document.getElementById('planName').textContent = data.plan_name;
  
  if (data.subscription_type === 'FREE') {
    document.getElementById('upgradeButton').classList.remove('hidden');
    document.getElementById('mcqUsageBar').classList.remove('hidden');
    document.getElementById('mcqCount').textContent = `${data.mcqs_used}/50`;
    document.getElementById('mcqProgress').style.width = `${(data.mcqs_used/50)*100}%`;
  } else {
    document.getElementById('planDetails').textContent = 
      `Valid until ${new Date(data.end_date).toLocaleDateString()}`;
  }
}

loadSubscriptionStatus();
File 13: landing-page/quiz.html (MODIFY)
Purpose: Add access control for practice sets
Update loadPracticeSets function (~line 150):
async function loadPracticeSets() {
  const token = localStorage.getItem('token');
  const res = await fetch('/api/practice-sets', {
    headers: { 'Authorization': `Bearer ${token}` }
  });
  
  const data = await res.json();
  
  // Backend already filters based on subscription
  // FREE users only see FREE practice sets
  // PAID users see all practice sets
  
  displayPracticeSets(data.practiceSets);
}
Add access check before starting quiz:
async function startPracticeSet(setId) {
  const token = localStorage.getItem('token');
  
  const res = await fetch(`/api/practice-sets/${setId}/start`, {
    method: 'POST',
    headers: { 
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json'
    }
  });
  
  if (res.status === 403) {
    // User doesn't have access
    alert('This practice set requires a PAID subscription. Upgrade to access!');
    window.location.href = 'pricing.html';
    return;
  }
  
  // Continue with quiz...
}
File 14: landing-page/index.html (MODIFY)
Purpose: Update pricing section on landing page
Find pricing section (~line 300):
<!-- Update to show 2 columns: FREE vs PAID -->
<!-- Match the simplified pricing.html structure -->
<!-- Remove 3-tier layout -->
File 15: landing-page/register.html (MODIFY)
Purpose: Default to FREE plan on registration
Update registration form (~line 100):
<!-- Remove plan selection dropdown -->
<!-- All new users default to FREE -->
<!-- Add note: "Start with FREE plan, upgrade anytime" -->

Update JavaScript (~line 200):
async function handleRegister(e) {
  e.preventDefault();
  
  // After successful user registration
  // Automatically create FREE subscription in backend
  
  const userData = {
    email: ...,
    password: ...,
    display_name: ...,
    plan_code: 'FREE' // Always FREE for new users
  };
  
  // Backend will create user + FREE subscription
}

EXECUTION SEQUENCE
When ready to implement, follow this exact order:
Step 1: Database Migration (Estimated: 15 minutes)
# 1. Backup current database
mysql -u root -p cpale_explained < database/migrations/mvp_phase1_backup.sql
# 2. Run migration
mysql -u root -p cpale_explained < database/migrations/mvp_phase1_migration.sql
# 3. Select 50 FREE MCQs
mysql -u root -p cpale_explained < database/migrations/mvp_phase1_select_free_mcqs.sql
# 4. Insert test data
mysql -u root -p cpale_explained < database/migrations/mvp_phase1_test_data.sql
# 5. Verify migration
mysql -u root -p -e "USE cpale_explained; 
  SELECT access_type, COUNT(*) FROM questions GROUP BY access_type;
  SELECT * FROM subscription_plans_v2;"
Step 2: Backend Implementation (Estimated: 30 minutes)
# 1. Create new files
touch backend/config/plans.js
touch backend/middleware/subscriptionCheck.js
touch backend/routes/subscription.js
# 2. Implement each file (use planned code)
# 3. Update server.js
# 4. Test backend
npm start
# Test endpoints with Postman/Thunder Client
Step 3: Frontend Implementation (Estimated: 45 minutes)
# 1. Update pricing.html
# 2. Update dashboard.html
# 3. Update quiz.html
# 4. Update index.html
# 5. Update register.html
# Test in browser
Step 4: Integration Testing (Estimated: 30 minutes)
# Follow testing guide
# Test complete user flows
Step 5: Verification & Deployment (Estimated: 15 minutes)
# 1. Final smoke tests
# 2. Check all payment flows
# 3. Monitor for errors
# 4. Document any issues


POST-MVP: PHASE 2 PREPARATION
After MVP is stable (1-2 weeks), prepare for tiered pricing:
1. Add new plans to subscription_plans_v2:
   - PAID_30 (P149)
   - PAID_60 (P288)
   - PAID_90 (P429)
   - PAID_120 (P549)
   - PAID_150 (P699)
   - PAID_180 (P799)
2. Update pricing.html to show all 6 tiers with duration selector
3. Keep access control simple: All PAID plans get same access (no content tiers)








