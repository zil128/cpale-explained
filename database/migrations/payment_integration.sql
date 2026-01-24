-- ============================================================================
-- PAYMENT INTEGRATION MIGRATION
-- Creates payment_transactions table and related structures
-- ============================================================================

-- Create payment_transactions table
CREATE TABLE IF NOT EXISTS payment_transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    plan_code VARCHAR(50) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method ENUM('GCASH', 'PAYMAYA', 'BANK_TRANSFER') NOT NULL,
    payment_status ENUM('PENDING', 'VERIFYING', 'COMPLETED', 'FAILED', 'REFUNDED') DEFAULT 'PENDING',
    reference_number VARCHAR(100) UNIQUE,
    
    -- Payment details
    payment_proof_url VARCHAR(500), -- URL to uploaded payment proof image
    payer_name VARCHAR(255),
    payer_contact VARCHAR(100),
    payment_notes TEXT,
    
    -- Admin verification
    verified_by INT NULL, -- Admin user_id who verified
    verified_at DATETIME NULL,
    verification_notes TEXT,
    
    -- Timestamps
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    paid_at DATETIME NULL,
    
    -- Indexes
    INDEX idx_user_id (user_id),
    INDEX idx_payment_status (payment_status),
    INDEX idx_reference_number (reference_number),
    INDEX idx_created_at (created_at),
    
    -- Foreign keys
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (verified_by) REFERENCES users(user_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create payment_methods_config table (for storing GCash/Maya account details)
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
2. Send P149 to 09171234567 (CPALE Explained)
3. Take a screenshot of the confirmation
4. Upload the screenshot below
5. Wait for verification (usually within 24 hours)'),

('PAYMAYA', TRUE, 'CPALE Explained', '09181234567',
'1. Open your Maya app
2. Send P149 to 09181234567 (CPALE Explained)
3. Take a screenshot of the confirmation
4. Upload the screenshot below
5. Wait for verification (usually within 24 hours)'),

('BANK_TRANSFER', TRUE, 'CPALE Explained Inc.', '1234567890', 
'1. Transfer P149 to:
   Bank: BDO
   Account Name: CPALE Explained Inc.
   Account Number: 1234567890
2. Take a photo of the deposit slip or transfer confirmation
3. Upload the photo below
4. Include your reference number in the notes
5. Wait for verification (usually within 24 hours)');

-- Create subscription_history table for tracking all subscription changes
CREATE TABLE IF NOT EXISTS subscription_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    subscription_id INT NOT NULL,
    
    -- Change details
    action_type ENUM('CREATED', 'UPGRADED', 'RENEWED', 'EXPIRED', 'CANCELLED', 'REFUNDED') NOT NULL,
    previous_plan_code VARCHAR(50),
    new_plan_code VARCHAR(50),
    
    -- Payment reference (if applicable)
    transaction_id INT NULL,
    
    -- Additional info
    notes TEXT,
    
    -- Who made the change
    changed_by INT NULL, -- user_id (NULL = system automated)
    
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
    FOREIGN KEY (transaction_id) REFERENCES payment_transactions(transaction_id) ON DELETE SET NULL,
    FOREIGN KEY (changed_by) REFERENCES users(user_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create conversion_tracking table for analytics
CREATE TABLE IF NOT EXISTS conversion_tracking (
    tracking_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    
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
    COALESCE(COUNT(DISTINCT ua.answer_id), 0) AS total_mcqs_attempted,
    0 AS total_sessions
FROM users u
LEFT JOIN user_answers ua ON u.user_id = ua.user_id
GROUP BY u.user_id
ON DUPLICATE KEY UPDATE
    registration_date = VALUES(registration_date),
    total_mcqs_attempted = VALUES(total_mcqs_attempted);

-- Create admin_users table (for payment verification)
CREATE TABLE IF NOT EXISTS admin_users (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    role ENUM('SUPER_ADMIN', 'ADMIN', 'MODERATOR') DEFAULT 'ADMIN',
    permissions JSON, -- e.g., {"verify_payments": true, "manage_users": true}
    
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert a default admin (you can change this later)
-- Note: You'll need to create an admin user first or update an existing user
-- INSERT INTO admin_users (user_id, role, permissions) VALUES
-- (1, 'SUPER_ADMIN', '{"verify_payments": true, "manage_users": true, "manage_content": true, "view_analytics": true}');

COMMIT;
