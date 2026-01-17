-- ============================================================================
-- CPALE Explained - Payment & Subscription Schema Updates
-- ============================================================================

-- Drop existing tables if they need restructuring
-- (keeping payment_transactions as it has good structure)

-- ============================================================================
-- Subscription Plans Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS subscription_plans (
    plan_id INT PRIMARY KEY AUTO_INCREMENT,
    plan_code VARCHAR(20) NOT NULL UNIQUE,
    plan_name VARCHAR(100) NOT NULL,
    plan_description TEXT,
    billing_period ENUM('MONTHLY', 'SEMI_ANNUAL', 'ANNUAL', 'LIFETIME') NOT NULL,
    price_php DECIMAL(10,2) NOT NULL,
    original_price_php DECIMAL(10,2) DEFAULT NULL COMMENT 'For showing discounts',
    mcq_limit INT DEFAULT NULL COMMENT 'NULL = unlimited',
    features JSON,
    is_active TINYINT(1) DEFAULT 1,
    display_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert subscription plans (IGNORE duplicates)
INSERT IGNORE INTO subscription_plans (plan_code, plan_name, plan_description, billing_period, price_php, original_price_php, mcq_limit, features, display_order) VALUES
-- FREE Plan
('FREE', 'Free Plan', '50 FREE MCQs across all 6 subjects with unlimited repetition', 'LIFETIME', 0.00, NULL, 50,
 '{"mcqs": 50, "subjects": 6, "practice_sets": false, "mock_preboard": false, "analytics": "basic", "support": "community"}', 1),

-- BASIC Plans
('BASIC_MONTHLY', 'Basic Monthly', '500 MCQs with basic analytics - billed monthly', 'MONTHLY', 149.00, NULL, 500,
 '{"mcqs": 500, "subjects": 6, "practice_sets": true, "practice_set_size": 75, "mock_preboard": false, "analytics": "basic", "support": "email"}', 2),

('BASIC_SEMI', 'Basic 6-Month', '500 MCQs with basic analytics - 6 months (Save P94!)', 'SEMI_ANNUAL', 800.00, 894.00, 500,
 '{"mcqs": 500, "subjects": 6, "practice_sets": true, "practice_set_size": 75, "mock_preboard": false, "analytics": "basic", "support": "email", "savings": 94}', 3),

-- ADVANCE Plans
('ADVANCE_MONTHLY', 'Advance Monthly', '10,000+ MCQs with AI-powered analytics - billed monthly', 'MONTHLY', 299.00, NULL, 10000,
 '{"mcqs": 10000, "subjects": 6, "practice_sets": true, "practice_set_size": 75, "mock_preboard": true, "mock_preboard_questions": 100, "mock_preboard_time_minutes": 180, "analytics": "advanced_ai", "support": "priority"}', 4),

('ADVANCE_SEMI', 'Advance 6-Month', '10,000+ MCQs with AI-powered analytics - 6 months (Save P195!)', 'SEMI_ANNUAL', 1599.00, 1794.00, 10000,
 '{"mcqs": 10000, "subjects": 6, "practice_sets": true, "practice_set_size": 75, "mock_preboard": true, "mock_preboard_questions": 100, "mock_preboard_time_minutes": 180, "analytics": "advanced_ai", "support": "priority", "savings": 195}', 5);

-- ============================================================================
-- Update user_subscriptions table structure
-- ============================================================================
-- Note: Using separate ALTER statements for MySQL 8.0 compatibility
-- First check if columns exist before adding

SET @dbname = 'cpale_explained';
SET @tablename = 'user_subscriptions';

-- Add plan_id column if not exists
SET @preparedStatement = (SELECT IF(
  (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = @dbname AND TABLE_NAME = @tablename AND COLUMN_NAME = 'plan_id') > 0,
  'SELECT 1',
  'ALTER TABLE user_subscriptions ADD COLUMN plan_id INT DEFAULT NULL'
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- Add billing_period column if not exists
SET @preparedStatement = (SELECT IF(
  (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = @dbname AND TABLE_NAME = @tablename AND COLUMN_NAME = 'billing_period') > 0,
  'SELECT 1',
  'ALTER TABLE user_subscriptions ADD COLUMN billing_period ENUM(''MONTHLY'', ''SEMI_ANNUAL'', ''ANNUAL'', ''LIFETIME'') DEFAULT ''MONTHLY'''
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- Add amount_paid column if not exists
SET @preparedStatement = (SELECT IF(
  (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = @dbname AND TABLE_NAME = @tablename AND COLUMN_NAME = 'amount_paid') > 0,
  'SELECT 1',
  'ALTER TABLE user_subscriptions ADD COLUMN amount_paid DECIMAL(10,2) DEFAULT 0.00'
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- Add payment_reference column if not exists
SET @preparedStatement = (SELECT IF(
  (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = @dbname AND TABLE_NAME = @tablename AND COLUMN_NAME = 'payment_reference') > 0,
  'SELECT 1',
  'ALTER TABLE user_subscriptions ADD COLUMN payment_reference VARCHAR(100) DEFAULT NULL'
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- Add payment_provider column if not exists
SET @preparedStatement = (SELECT IF(
  (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = @dbname AND TABLE_NAME = @tablename AND COLUMN_NAME = 'payment_provider') > 0,
  'SELECT 1',
  'ALTER TABLE user_subscriptions ADD COLUMN payment_provider ENUM(''GCASH'', ''PAYMAYA'', ''BANK_TRANSFER'', ''PAYPAL'', ''STRIPE'', ''MANUAL'') DEFAULT NULL'
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- ============================================================================
-- Payment Transactions Table (Enhanced)
-- ============================================================================
DROP TABLE IF EXISTS payment_transactions_new;
CREATE TABLE payment_transactions_new (
    transaction_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    plan_id INT NOT NULL,

    -- Amount details
    amount_php DECIMAL(10,2) NOT NULL,
    discount_amount DECIMAL(10,2) DEFAULT 0.00,
    final_amount DECIMAL(10,2) NOT NULL,

    -- Payment provider details
    payment_provider ENUM('GCASH', 'PAYMAYA', 'BANK_TRANSFER', 'PAYPAL', 'STRIPE', 'MANUAL') NOT NULL,
    payment_method_details JSON COMMENT 'Provider-specific details like last 4 digits, account name',

    -- Reference numbers
    internal_reference VARCHAR(50) NOT NULL UNIQUE COMMENT 'Our internal reference (CPALE-YYYYMMDD-XXXXX)',
    external_reference VARCHAR(100) DEFAULT NULL COMMENT 'Payment provider reference',

    -- Status tracking
    status ENUM('PENDING', 'PROCESSING', 'COMPLETED', 'FAILED', 'REFUNDED', 'CANCELLED') DEFAULT 'PENDING',
    status_message TEXT,

    -- Subscription details
    subscription_start DATE,
    subscription_end DATE,

    -- Timestamps
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL,

    -- Indexes
    INDEX idx_user_transactions (user_id),
    INDEX idx_status (status),
    INDEX idx_provider (payment_provider),
    INDEX idx_reference (internal_reference),

    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (plan_id) REFERENCES subscription_plans(plan_id)
);

-- ============================================================================
-- Payment Provider Configs (for admin management)
-- ============================================================================
CREATE TABLE IF NOT EXISTS payment_provider_configs (
    provider_id INT PRIMARY KEY AUTO_INCREMENT,
    provider_code ENUM('GCASH', 'PAYMAYA', 'BANK_TRANSFER', 'PAYPAL', 'STRIPE') NOT NULL UNIQUE,
    provider_name VARCHAR(50) NOT NULL,
    is_active TINYINT(1) DEFAULT 1,
    display_order INT DEFAULT 0,
    config JSON COMMENT 'Provider-specific config (account numbers, API keys reference)',
    instructions TEXT COMMENT 'Payment instructions for users',
    icon_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert payment provider configurations (IGNORE duplicates)
INSERT IGNORE INTO payment_provider_configs (provider_code, provider_name, is_active, display_order, instructions, icon_url) VALUES
('GCASH', 'GCash', 1, 1,
 'Send payment to GCash number: 0917-XXX-XXXX (CPALE Explained). Include your email as reference.',
 '/landing-page/images/gcash-logo.png'),

('PAYMAYA', 'PayMaya / Maya', 1, 2,
 'Send payment to Maya number: 0917-XXX-XXXX (CPALE Explained). Include your email as reference.',
 '/landing-page/images/paymaya-logo.png'),

('BANK_TRANSFER', 'Bank Transfer', 1, 3,
 'Transfer to BDO Account: 1234-5678-9012 (CPALE Explained Inc.). Send proof of payment to payment@cpaleexplained.com',
 '/landing-page/images/bank-logo.png');

-- ============================================================================
-- Promo Codes Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS promo_codes (
    promo_id INT PRIMARY KEY AUTO_INCREMENT,
    code VARCHAR(20) NOT NULL UNIQUE,
    description VARCHAR(255),
    discount_type ENUM('PERCENTAGE', 'FIXED_AMOUNT') NOT NULL,
    discount_value DECIMAL(10,2) NOT NULL,
    min_purchase DECIMAL(10,2) DEFAULT 0.00,
    max_uses INT DEFAULT NULL COMMENT 'NULL = unlimited',
    times_used INT DEFAULT 0,
    valid_from DATE,
    valid_until DATE,
    applicable_plans JSON COMMENT 'Array of plan_codes this promo applies to',
    is_active TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample promo codes (IGNORE duplicates)
INSERT IGNORE INTO promo_codes (code, description, discount_type, discount_value, valid_from, valid_until, applicable_plans) VALUES
('CPALE2026', 'New Year 2026 Promo - 10% off', 'PERCENTAGE', 10.00, '2026-01-01', '2026-03-31', '["BASIC_MONTHLY", "BASIC_SEMI", "ADVANCE_MONTHLY", "ADVANCE_SEMI"]'),
('FIRSTMONTH', 'First month 20% discount', 'PERCENTAGE', 20.00, '2026-01-01', '2026-12-31', '["BASIC_MONTHLY", "ADVANCE_MONTHLY"]');

-- ============================================================================
-- Practice Sets for Paid Plans
-- ============================================================================
-- Update existing practice_sets to support the 75-question structure

SET @tablename = 'practice_sets';

-- Add questions_per_set column if not exists
SET @preparedStatement = (SELECT IF(
  (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = @dbname AND TABLE_NAME = @tablename AND COLUMN_NAME = 'questions_per_set') > 0,
  'SELECT 1',
  'ALTER TABLE practice_sets ADD COLUMN questions_per_set INT DEFAULT 50'
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- Add access_level column if not exists
SET @preparedStatement = (SELECT IF(
  (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = @dbname AND TABLE_NAME = @tablename AND COLUMN_NAME = 'access_level') > 0,
  'SELECT 1',
  'ALTER TABLE practice_sets ADD COLUMN access_level ENUM(''FREE'', ''BASIC'', ''ADVANCE'') DEFAULT ''FREE'''
));
PREPARE alterIfNotExists FROM @preparedStatement;
EXECUTE alterIfNotExists;
DEALLOCATE PREPARE alterIfNotExists;

-- ============================================================================
-- Mock Preboard Exams Table
-- ============================================================================
CREATE TABLE IF NOT EXISTS mock_preboard_exams (
    exam_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    subject_id INT NOT NULL,
    exam_name VARCHAR(100) NOT NULL,
    exam_description TEXT,
    total_questions INT DEFAULT 100,
    time_limit_minutes INT DEFAULT 180 COMMENT '3 hours like actual CPALE',
    passing_score_percent DECIMAL(5,2) DEFAULT 75.00,
    access_level ENUM('ADVANCE') DEFAULT 'ADVANCE',
    is_active TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

-- Insert mock preboard exams for each subject (IGNORE duplicates)
INSERT IGNORE INTO mock_preboard_exams (subject_id, exam_name, exam_description, total_questions, time_limit_minutes) VALUES
(1, 'FAR Mock Preboard', 'Financial Accounting and Reporting - 100 questions, 3 hours', 100, 180),
(2, 'AFAR Mock Preboard', 'Advanced Financial Accounting and Reporting - 100 questions, 3 hours', 100, 180),
(3, 'AUD Mock Preboard', 'Auditing - 100 questions, 3 hours', 100, 180),
(4, 'TAX Mock Preboard', 'Taxation - 100 questions, 3 hours', 100, 180),
(5, 'MS Mock Preboard', 'Management Services - 100 questions, 3 hours', 100, 180),
(6, 'RFBT Mock Preboard', 'Regulatory Framework for Business Transactions - 100 questions, 3 hours', 100, 180);

-- ============================================================================
-- User Mock Preboard Attempts
-- ============================================================================
CREATE TABLE IF NOT EXISTS user_mock_attempts (
    attempt_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    exam_id BIGINT NOT NULL,

    -- Timing
    started_at TIMESTAMP NOT NULL,
    ended_at TIMESTAMP NULL,
    time_spent_seconds INT DEFAULT 0,

    -- Results
    total_questions INT NOT NULL,
    correct_answers INT DEFAULT 0,
    wrong_answers INT DEFAULT 0,
    unanswered INT DEFAULT 0,
    score_percent DECIMAL(5,2) DEFAULT 0.00,
    passed TINYINT(1) DEFAULT 0,

    -- Status
    status ENUM('IN_PROGRESS', 'COMPLETED', 'TIMED_OUT', 'ABANDONED') DEFAULT 'IN_PROGRESS',

    -- Detailed answers stored as JSON
    answers JSON COMMENT 'Array of {question_id, selected_choice, is_correct, time_spent}',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (exam_id) REFERENCES mock_preboard_exams(exam_id)
);

-- ============================================================================
-- Update questions table for access levels
-- ============================================================================
-- Update questions to have proper access levels
UPDATE questions SET access_level = 'FREE' WHERE access_level IS NULL OR access_level = '';
