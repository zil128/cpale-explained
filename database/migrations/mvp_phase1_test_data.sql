-- ================================================================
-- MVP PHASE 1 - TEST DATA SCRIPT
-- Date: 2026-01-18
-- Purpose: Create test users for testing FREE vs PAID functionality
-- ================================================================

USE cpale_explained;

-- ================================================================
-- STEP 1: Create Test Users
-- Password for all test users: Test123!
-- (bcrypt hash: $2b$10$abcdefghijklmnopqrstuv)
-- ================================================================

-- Test User 1: FREE Plan (never upgraded)
INSERT IGNORE INTO users 
(email, password, display_name, user_type, is_active, created_at)
VALUES
('testfree@cpale.com', '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhQW', 
 'Free Test User', 'FREE', TRUE, NOW());

-- Test User 2: PAID Plan (active subscription)
INSERT IGNORE INTO users 
(email, password, display_name, user_type, is_active, created_at)
VALUES
('testpaid@cpale.com', '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhQW', 
 'Paid Test User', 'PREMIUM', TRUE, NOW());

-- Test User 3: PAID Plan (expired subscription)
INSERT IGNORE INTO users 
(email, password, display_name, user_type, is_active, created_at)
VALUES
('testexpired@cpale.com', '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhQW', 
 'Expired Test User', 'FREE', TRUE, NOW());

-- ================================================================
-- STEP 2: Create Subscriptions for Test Users
-- ================================================================

-- Get user IDs
SET @free_user_id = (SELECT user_id FROM users WHERE email = 'testfree@cpale.com');
SET @paid_user_id = (SELECT user_id FROM users WHERE email = 'testpaid@cpale.com');
SET @expired_user_id = (SELECT user_id FROM users WHERE email = 'testexpired@cpale.com');

-- Get plan IDs
SET @free_plan_id = (SELECT plan_id FROM subscription_plans_v2 WHERE plan_code = 'FREE');
SET @paid_plan_id = (SELECT plan_id FROM subscription_plans_v2 WHERE plan_code = 'PAID_MONTHLY');

-- Test User 1: FREE subscription
INSERT IGNORE INTO user_subscriptions_v2 
(user_id, plan_id, subscription_type, start_date, end_date, is_active, payment_reference)
VALUES
(@free_user_id, @free_plan_id, 'FREE', CURDATE(), NULL, TRUE, NULL);

-- Test User 2: PAID subscription (active, expires in 25 days)
INSERT IGNORE INTO user_subscriptions_v2 
(user_id, plan_id, subscription_type, start_date, end_date, is_active, payment_reference, payment_provider, amount_paid)
VALUES
(@paid_user_id, @paid_plan_id, 'PAID', DATE_SUB(CURDATE(), INTERVAL 5 DAY), DATE_ADD(CURDATE(), INTERVAL 25 DAY), 
 TRUE, 'CPALE-TEST-00001', 'GCASH', 149.00);

-- Test User 3: PAID subscription (expired 5 days ago)
INSERT IGNORE INTO user_subscriptions_v2 
(user_id, plan_id, subscription_type, start_date, end_date, is_active, payment_reference, payment_provider, amount_paid)
VALUES
(@expired_user_id, @paid_plan_id, 'PAID', DATE_SUB(CURDATE(), INTERVAL 35 DAY), DATE_SUB(CURDATE(), INTERVAL 5 DAY), 
 FALSE, 'CPALE-TEST-00002', 'PAYMAYA', 149.00);

-- ================================================================
-- STEP 3: Initialize MCQ usage tracking for test users
-- ================================================================

-- FREE user: used 15 MCQs (out of 50 limit)
INSERT IGNORE INTO user_mcq_usage (user_id, mcqs_attempted, last_reset_date)
VALUES (@free_user_id, 15, CURDATE());

-- PAID user: used 120 MCQs (no limit)
INSERT IGNORE INTO user_mcq_usage (user_id, mcqs_attempted, last_reset_date)
VALUES (@paid_user_id, 120, CURDATE());

-- EXPIRED user: used 80 MCQs during paid period
INSERT IGNORE INTO user_mcq_usage (user_id, mcqs_attempted, last_reset_date)
VALUES (@expired_user_id, 80, DATE_SUB(CURDATE(), INTERVAL 10 DAY));

-- ================================================================
-- STEP 4: Create sample payment transactions
-- ================================================================

-- Payment for Test User 2 (active paid)
INSERT IGNORE INTO payment_transactions_new
(user_id, plan_id, amount_php, discount_amount, final_amount, payment_provider, 
 internal_reference, external_reference, status, subscription_start, subscription_end, completed_at)
VALUES
(@paid_user_id, @paid_plan_id, 149.00, 0.00, 149.00, 'GCASH',
 'CPALE-TEST-00001', 'GCASH-REF-12345', 'COMPLETED', 
 DATE_SUB(CURDATE(), INTERVAL 5 DAY), DATE_ADD(CURDATE(), INTERVAL 25 DAY), 
 DATE_SUB(NOW(), INTERVAL 5 DAY));

-- Payment for Test User 3 (expired)
INSERT IGNORE INTO payment_transactions_new
(user_id, plan_id, amount_php, discount_amount, final_amount, payment_provider, 
 internal_reference, external_reference, status, subscription_start, subscription_end, completed_at)
VALUES
(@expired_user_id, @paid_plan_id, 149.00, 0.00, 149.00, 'PAYMAYA',
 'CPALE-TEST-00002', 'MAYA-REF-67890', 'COMPLETED', 
 DATE_SUB(CURDATE(), INTERVAL 35 DAY), DATE_SUB(CURDATE(), INTERVAL 5 DAY), 
 DATE_SUB(NOW(), INTERVAL 35 DAY));

-- ================================================================
-- STEP 5: Verification - Show test data
-- ================================================================

SELECT '=== TEST USERS CREATED ===' as section;

SELECT 
    u.user_id,
    u.email,
    u.display_name,
    u.user_type,
    usv.subscription_type,
    usv.start_date,
    usv.end_date,
    usv.is_active as subscription_active,
    CASE 
        WHEN usv.end_date IS NULL THEN 'No expiration'
        WHEN usv.end_date < CURDATE() THEN 'EXPIRED'
        WHEN usv.end_date >= CURDATE() THEN CONCAT(DATEDIFF(usv.end_date, CURDATE()), ' days remaining')
    END as subscription_status,
    umu.mcqs_attempted
FROM users u
LEFT JOIN user_subscriptions_v2 usv ON u.user_id = usv.user_id
LEFT JOIN user_mcq_usage umu ON u.user_id = umu.user_id
WHERE u.email LIKE 'test%@cpale.com'
ORDER BY u.email;

SELECT '=== TEST CREDENTIALS ===' as section;

SELECT 
    'All test users' as info,
    'Password: Test123!' as password,
    'Use these for testing login and subscription features' as note;

SELECT '=== TEST DATA CREATION COMPLETE ===' as message;

-- ================================================================
-- NOTES:
-- Test User Scenarios:
-- 1. testfree@cpale.com - FREE plan, 15/50 MCQs used
-- 2. testpaid@cpale.com - PAID plan (active), 25 days remaining
-- 3. testexpired@cpale.com - PAID plan (expired 5 days ago)
-- 
-- Use these to test:
-- - FREE user MCQ limits
-- - PAID user full access
-- - Expired subscription handling
-- - Upgrade flow
-- - Payment processing
-- ================================================================
