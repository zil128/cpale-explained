-- ============================================================================
-- PAYMENT ENHANCEMENT MIGRATION
-- Enhances existing payment_transactions and adds supporting tables
-- ============================================================================

-- Add columns to existing payment_transactions for manual verification
ALTER TABLE payment_transactions
ADD COLUMN IF NOT EXISTS payment_proof_url VARCHAR(500) AFTER webhook_data,
ADD COLUMN IF NOT EXISTS payer_name VARCHAR(255) AFTER payment_proof_url,
ADD COLUMN IF NOT EXISTS payer_contact VARCHAR(100) AFTER payer_name,
ADD COLUMN IF NOT EXISTS payment_notes TEXT AFTER payer_contact,
ADD COLUMN IF NOT EXISTS verified_by BIGINT(20) NULL AFTER payment_notes,
ADD COLUMN IF NOT EXISTS verified_at DATETIME NULL AFTER verified_by,
ADD COLUMN IF NOT EXISTS verification_notes TEXT AFTER verified_at,
ADD COLUMN IF NOT EXISTS updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER created_at;

-- Update payment_status enum to include more statuses
ALTER TABLE payment_transactions
MODIFY COLUMN payment_status ENUM('PENDING', 'VERIFYING', 'SUCCESS', 'FAILED', 'REFUNDED') NOT NULL DEFAULT 'PENDING';

-- Update payment_method enum to include BANK_TRANSFER
ALTER TABLE payment_transactions
MODIFY COLUMN payment_method ENUM('GCASH', 'PAYMAYA', 'BANK_TRANSFER', 'CARD', 'PAYPAL') NOT NULL;

-- Add index for verified_by
ALTER TABLE payment_transactions
ADD INDEX IF NOT EXISTS idx_verified_by (verified_by);

-- Create payment_methods_config table (for storing payment account details)
CREATE TABLE IF NOT EXISTS payment_methods_config (
    config_id INT AUTO_INCREMENT PRIMARY KEY,
    payment_method ENUM('GCASH', 'PAYMAYA', 'BANK_TRANSFER') NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    
    -- Account details
    account_name VARCHAR(255),
    account_number VARCHAR(100),
    bank_name VARCHAR(255), -- For bank transfers
    qr_code_url VARCHAR(500), -- URL to QR code image
    
    -- Instructions
    instructions TEXT,
    
    -- Timestamps
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    UNIQUE KEY unique_payment_method (payment_method)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default payment method configurations
INSERT INTO payment_methods_config (payment_method, is_active, account_name, account_number, instructions) VALUES
('GCASH', TRUE, 'CPALE Explained', '09171234567', 
'1. Open your GCash app
2. Send the exact amount to 09171234567 (CPALE Explained)
3. Take a screenshot of the confirmation
4. Upload the screenshot below
5. Wait for verification (usually within 24 hours)'),

('PAYMAYA', TRUE, 'CPALE Explained', '09181234567',
'1. Open your Maya app
2. Send the exact amount to 09181234567 (CPALE Explained)
3. Take a screenshot of the confirmation
4. Upload the screenshot below
5. Wait for verification (usually within 24 hours)'),

('BANK_TRANSFER', TRUE, 'CPALE Explained Inc.', '1234567890', 
'Bank: BDO
Account Name: CPALE Explained Inc.
Account Number: 1234567890

Instructions:
1. Transfer the exact amount to the account above
2. Take a photo of the deposit slip or transfer confirmation
3. Upload the photo below
4. Include your reference number in the notes
5. Wait for verification (usually within 24 hours)')
ON DUPLICATE KEY UPDATE
    account_name = VALUES(account_name),
    account_number = VALUES(account_number),
    instructions = VALUES(instructions);

-- Create subscription_history table for tracking all subscription changes
CREATE TABLE IF NOT EXISTS subscription_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT(20) NOT NULL,
    subscription_id INT NOT NULL,
    
    -- Change details
    action_type ENUM('CREATED', 'UPGRADED', 'RENEWED', 'EXPIRED', 'CANCELLED', 'REFUNDED') NOT NULL,
    previous_plan_code VARCHAR(50),
    new_plan_code VARCHAR(50),
    
    -- Payment reference (if applicable)
    payment_id BIGINT(20) NULL,
    
    -- Additional info
    notes TEXT,
    
    -- Who made the change
    changed_by BIGINT(20) NULL, -- user_id (NULL = system automated)
    
    -- Timestamps
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    -- Indexes
    INDEX idx_user_id (user_id),
    INDEX idx_subscription_id (subscription_id),
    INDEX idx_action_type (action_type),
    INDEX idx_created_at (created_at),
    
    -- Foreign keys
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (subscription_id) REFERENCES user_subscriptions_v2(subscription_id) ON DELETE CASCADE,
    FOREIGN KEY (payment_id) REFERENCES payment_transactions(payment_id) ON DELETE SET NULL,
    FOREIGN KEY (changed_by) REFERENCES users(user_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create conversion_tracking table for analytics
CREATE TABLE IF NOT EXISTS conversion_tracking (
    tracking_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT(20) NOT NULL,
    
    -- User journey
    registration_date DATETIME,
    first_login_date DATETIME,
    first_mcq_attempt_date DATETIME,
    first_upgrade_click_date DATETIME,
    conversion_date DATETIME NULL, -- When they became PAID
    
    -- Engagement metrics
    total_mcqs_attempted INT DEFAULT 0,
    total_sessions INT DEFAULT 0,
    days_until_conversion INT NULL,
    
    -- Source tracking
    referral_source VARCHAR(255),
    landing_page VARCHAR(255),
    
    -- Timestamps
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Indexes
    INDEX idx_user_id (user_id),
    INDEX idx_conversion_date (conversion_date),
    
    -- Foreign key
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Populate conversion_tracking for existing users
INSERT INTO conversion_tracking (user_id, registration_date, total_mcqs_attempted, total_sessions)
SELECT 
    u.user_id,
    u.created_at AS registration_date,
    COALESCE((SELECT COUNT(*) FROM exam_attempts ea WHERE ea.user_id = u.user_id), 0) AS total_mcqs_attempted,
    0 AS total_sessions
FROM users u
ON DUPLICATE KEY UPDATE
    registration_date = VALUES(registration_date),
    total_mcqs_attempted = VALUES(total_mcqs_attempted);

-- Create admin_users table (for payment verification)
CREATE TABLE IF NOT EXISTS admin_users (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT(20) NOT NULL UNIQUE,
    role ENUM('SUPER_ADMIN', 'ADMIN', 'MODERATOR') DEFAULT 'ADMIN',
    permissions JSON, -- e.g., {"verify_payments": true, "manage_users": true}
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

COMMIT;
