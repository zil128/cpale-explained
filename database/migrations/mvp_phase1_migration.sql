-- ================================================================
-- MVP PHASE 1 - MAIN MIGRATION SCRIPT
-- Date: 2026-01-18
-- Purpose: Migrate to simplified FREE vs PAID access levels
-- Strategy: Create new tables alongside old (gradual migration)
-- ================================================================

USE cpale_explained;

-- ================================================================
-- STEP 1: Create subscription_plans_v2 table
-- ================================================================
DROP TABLE IF EXISTS subscription_plans_v2;
CREATE TABLE subscription_plans_v2 (
    plan_id INT AUTO_INCREMENT PRIMARY KEY,
    plan_code VARCHAR(20) NOT NULL UNIQUE,
    plan_name VARCHAR(100) NOT NULL,
    plan_description TEXT,
    price_php DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    duration_days INT DEFAULT NULL COMMENT 'NULL = unlimited',
    mcq_limit INT DEFAULT NULL COMMENT 'NULL = unlimited MCQs',
    features JSON,
    is_active TINYINT(1) DEFAULT 1,
    display_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_plan_code (plan_code),
    INDEX idx_is_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ================================================================
-- STEP 2: Insert MVP Plans (FREE and PAID_MONTHLY)
-- ================================================================
INSERT INTO subscription_plans_v2 
(plan_code, plan_name, plan_description, price_php, duration_days, mcq_limit, features, display_order) 
VALUES
-- FREE Plan
('FREE', 
 'Free Plan', 
 '50 FREE MCQs across all 6 subjects with unlimited repetition',
 0.00,
 NULL,
 50,
 JSON_OBJECT(
    'mcqs', 50,
    'subjects', 6,
    'practice_sets', false,
    'mock_preboard', false,
    'analytics', 'basic',
    'support', 'community'
 ),
 1),

-- PAID Monthly Plan
('PAID_MONTHLY',
 'Paid Monthly',
 'Access to ALL MCQs, Practice Sets, and Basic Analytics for 30 days',
 149.00,
 30,
 NULL,
 JSON_OBJECT(
    'mcqs', 'unlimited',
    'subjects', 6,
    'practice_sets', true,
    'practice_set_size', 75,
    'mock_preboard', false,
    'analytics', 'basic',
    'support', 'email'
 ),
 2);

-- ================================================================
-- STEP 3: Add access_type column to questions table
-- ================================================================
-- Check if column exists, if not add it
SET @dbname = 'cpale_explained';
SET @tablename = 'questions';
SET @columnname = 'access_type';

SET @preparedStatement = (SELECT IF(
  (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
   WHERE TABLE_SCHEMA = @dbname 
   AND TABLE_NAME = @tablename 
   AND COLUMN_NAME = @columnname) > 0,
  'SELECT "Column already exists" as message',
  'ALTER TABLE questions ADD COLUMN access_type ENUM(''FREE'', ''PAID'') DEFAULT ''PAID'' AFTER access_level'
));

PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- ================================================================
-- STEP 4: Add access_type column to practice_sets table
-- ================================================================
SET @tablename = 'practice_sets';

SET @preparedStatement = (SELECT IF(
  (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
   WHERE TABLE_SCHEMA = @dbname 
   AND TABLE_NAME = @tablename 
   AND COLUMN_NAME = @columnname) > 0,
  'SELECT "Column already exists" as message',
  'ALTER TABLE practice_sets ADD COLUMN access_type ENUM(''FREE'', ''PAID'') DEFAULT ''PAID'' AFTER access_level'
));

PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- ================================================================
-- STEP 5: Migrate existing data for practice_sets
-- ================================================================
-- Mark practice sets as FREE or PAID based on existing access_level
UPDATE practice_sets 
SET access_type = 'FREE' 
WHERE access_level = 'FREE' OR is_paid = 0;

UPDATE practice_sets 
SET access_type = 'PAID' 
WHERE access_level IN ('BASIC', 'ADVANCE') OR is_paid = 1;

-- ================================================================
-- STEP 6: Create user_subscriptions_v2 table
-- ================================================================
DROP TABLE IF EXISTS user_subscriptions_v2;
CREATE TABLE user_subscriptions_v2 (
    subscription_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNSIGNED NOT NULL,
    plan_id INT NOT NULL,
    subscription_type ENUM('FREE', 'PAID') DEFAULT 'FREE',
    start_date DATE NOT NULL,
    end_date DATE NULL COMMENT 'NULL for FREE plan',
    is_active BOOLEAN DEFAULT TRUE,
    payment_reference VARCHAR(100) DEFAULT NULL,
    payment_provider ENUM('GCASH', 'PAYMAYA', 'BANK_TRANSFER', 'PAYPAL', 'STRIPE', 'MANUAL') DEFAULT NULL,
    amount_paid DECIMAL(10,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (plan_id) REFERENCES subscription_plans_v2(plan_id),
    INDEX idx_user_id (user_id),
    INDEX idx_subscription_type (subscription_type),
    INDEX idx_is_active (is_active),
    INDEX idx_end_date (end_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ================================================================
-- STEP 7: Migrate existing users to FREE plan
-- ================================================================
-- All existing users start with FREE plan
INSERT INTO user_subscriptions_v2 
(user_id, plan_id, subscription_type, start_date, end_date, is_active)
SELECT 
    u.user_id,
    (SELECT plan_id FROM subscription_plans_v2 WHERE plan_code = 'FREE'),
    'FREE',
    CURDATE(),
    NULL,
    TRUE
FROM users u
WHERE NOT EXISTS (
    SELECT 1 FROM user_subscriptions_v2 usv2 WHERE usv2.user_id = u.user_id
);

-- ================================================================
-- STEP 8: Create MCQ usage tracking table
-- ================================================================
DROP TABLE IF EXISTS user_mcq_usage;
CREATE TABLE user_mcq_usage (
    usage_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNSIGNED NOT NULL,
    mcqs_attempted INT UNSIGNED DEFAULT 0,
    last_reset_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_usage (user_id),
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Initialize usage tracking for all users
INSERT INTO user_mcq_usage (user_id, mcqs_attempted, last_reset_date)
SELECT 
    user_id,
    0,
    CURDATE()
FROM users
WHERE NOT EXISTS (
    SELECT 1 FROM user_mcq_usage umu WHERE umu.user_id = users.user_id
);

-- ================================================================
-- STEP 9: Create indexes for performance
-- ================================================================
CREATE INDEX IF NOT EXISTS idx_questions_access_type ON questions(access_type, is_active);
CREATE INDEX IF NOT EXISTS idx_practice_sets_access_type ON practice_sets(access_type, is_active);

-- ================================================================
-- STEP 10: Verification queries
-- ================================================================
SELECT '=== SUBSCRIPTION PLANS ===' as section;
SELECT * FROM subscription_plans_v2;

SELECT '=== PRACTICE SETS MIGRATION ===' as section;
SELECT 
    access_type,
    COUNT(*) as count
FROM practice_sets
GROUP BY access_type;

SELECT '=== USER SUBSCRIPTIONS ===' as section;
SELECT 
    subscription_type,
    COUNT(*) as user_count
FROM user_subscriptions_v2
GROUP BY subscription_type;

SELECT '=== MIGRATION COMPLETE ===' as message;

-- ================================================================
-- NOTES:
-- 1. questions.access_type will be set by separate script (50 random FREE)
-- 2. Old columns (is_paid, access_level) retained for rollback safety
-- 3. Can drop old columns after 1 week of stable operation
-- ================================================================
