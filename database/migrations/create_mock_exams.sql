-- =====================================================
-- Mock Exam System Migration
-- Creates comprehensive mock exams with 100 questions each
-- =====================================================

SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS;
SET FOREIGN_KEY_CHECKS=0;

-- =====================================================
-- TABLE 1: mock_exam_questions (tracks which questions are in each attempt)
-- =====================================================

CREATE TABLE IF NOT EXISTS mock_exam_questions (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  attempt_id BIGINT NOT NULL,
  question_id BIGINT NOT NULL,
  question_order INT NOT NULL,
  selected_choice_id BIGINT NULL,
  is_correct TINYINT(1) NULL,
  time_spent_seconds INT DEFAULT 0,
  is_marked TINYINT(1) DEFAULT 0,
  answered_at TIMESTAMP NULL,
  
  INDEX idx_attempt (attempt_id),
  INDEX idx_question (question_id),
  
  CONSTRAINT fk_meq_attempt FOREIGN KEY (attempt_id) 
    REFERENCES user_mock_attempts(attempt_id) ON DELETE CASCADE,
  CONSTRAINT fk_meq_question FOREIGN KEY (question_id) 
    REFERENCES questions(question_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- =====================================================
-- TABLE 2: Update mock_preboard_exams to support comprehensive exams
-- =====================================================

-- Add exam_code column if it doesn't exist
SET @column_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
  WHERE TABLE_SCHEMA = 'cpale_explained' AND TABLE_NAME = 'mock_preboard_exams' AND COLUMN_NAME = 'exam_code');
SET @sql = IF(@column_exists = 0, 
  'ALTER TABLE mock_preboard_exams ADD COLUMN exam_code VARCHAR(50) NULL AFTER exam_id', 
  'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Add exam_type column if it doesn't exist
SET @column_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
  WHERE TABLE_SCHEMA = 'cpale_explained' AND TABLE_NAME = 'mock_preboard_exams' AND COLUMN_NAME = 'exam_type');
SET @sql = IF(@column_exists = 0, 
  'ALTER TABLE mock_preboard_exams ADD COLUMN exam_type ENUM(''SUBJECT'', ''COMPREHENSIVE'') DEFAULT ''SUBJECT'' AFTER exam_description', 
  'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Add questions_per_subject column if it doesn't exist
SET @column_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
  WHERE TABLE_SCHEMA = 'cpale_explained' AND TABLE_NAME = 'mock_preboard_exams' AND COLUMN_NAME = 'questions_per_subject');
SET @sql = IF(@column_exists = 0, 
  'ALTER TABLE mock_preboard_exams ADD COLUMN questions_per_subject JSON NULL AFTER total_questions', 
  'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Update existing exams with codes
UPDATE mock_preboard_exams SET exam_code = CONCAT('MOCK-', (SELECT subject_code FROM subjects WHERE subject_id = mock_preboard_exams.subject_id)) WHERE exam_code IS NULL AND exam_id <= 6;

-- =====================================================
-- SECTION 3: INSERT COMPREHENSIVE MOCK EXAMS
-- =====================================================

-- Insert 3 comprehensive mock exams (IDs 101-103 to avoid conflicts)
INSERT INTO mock_preboard_exams (exam_id, exam_code, subject_id, exam_name, exam_description, exam_type, total_questions, questions_per_subject, time_limit_minutes, passing_score_percent, access_level, is_active)
VALUES
(101, 'MOCK-COMP-001', 1, 'Comprehensive Mock Exam 1', 'Full CPALE simulation with all 6 subjects - 100 questions, 3 hours', 'COMPREHENSIVE', 100, 
 '{"FAR": 20, "AFAR": 15, "AUD": 15, "TAX": 15, "MS": 15, "RFBT": 20}', 
 180, 75.00, 'ADVANCE', 1),

(102, 'MOCK-COMP-002', 1, 'Comprehensive Mock Exam 2', 'Full CPALE simulation with all 6 subjects - 100 questions, 3 hours', 'COMPREHENSIVE', 100, 
 '{"FAR": 20, "AFAR": 15, "AUD": 15, "TAX": 15, "MS": 15, "RFBT": 20}', 
 180, 75.00, 'ADVANCE', 1),

(103, 'MOCK-COMP-003', 1, 'Comprehensive Mock Exam 3', 'Full CPALE simulation with all 6 subjects - 100 questions, 3 hours', 'COMPREHENSIVE', 100, 
 '{"FAR": 20, "AFAR": 15, "AUD": 15, "TAX": 15, "MS": 15, "RFBT": 20}', 
 180, 75.00, 'ADVANCE', 1)
ON DUPLICATE KEY UPDATE 
  exam_code = VALUES(exam_code),
  exam_type = VALUES(exam_type),
  questions_per_subject = VALUES(questions_per_subject);


-- =====================================================
-- TABLE 3: mock_exam_results (detailed results breakdown)
-- =====================================================

CREATE TABLE IF NOT EXISTS mock_exam_results (
  result_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  attempt_id BIGINT NOT NULL UNIQUE,
  user_id BIGINT NOT NULL,
  exam_id BIGINT NOT NULL,
  
  -- Overall metrics
  total_questions INT NOT NULL,
  correct_answers INT DEFAULT 0,
  wrong_answers INT DEFAULT 0,
  unanswered INT DEFAULT 0,
  score_percent DECIMAL(5,2) DEFAULT 0.00,
  passed TINYINT(1) DEFAULT 0,
  
  -- Time metrics
  total_time_seconds INT DEFAULT 0,
  avg_time_per_question INT DEFAULT 0,
  
  -- Subject breakdown (JSON)
  subject_breakdown JSON,
  -- Format: {"FAR": {"total": 20, "correct": 15, "accuracy": 75.00}, ...}
  
  -- Difficulty breakdown (JSON)
  difficulty_breakdown JSON,
  -- Format: {"EASY": {"total": 30, "correct": 25}, "MEDIUM": {...}, "HARD": {...}}
  
  -- Percentile ranking (compared to other users)
  percentile_rank DECIMAL(5,2) NULL,
  
  -- Recommendations (JSON)
  weak_subjects JSON,
  recommendations JSON,
  
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  INDEX idx_user (user_id),
  INDEX idx_exam (exam_id),
  
  CONSTRAINT fk_mer_attempt FOREIGN KEY (attempt_id) 
    REFERENCES user_mock_attempts(attempt_id) ON DELETE CASCADE,
  CONSTRAINT fk_mer_user FOREIGN KEY (user_id) 
    REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- =====================================================
-- RESTORE FOREIGN KEY CHECKS
-- =====================================================
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;


-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================

-- Check comprehensive exams
-- SELECT exam_id, exam_code, exam_name, exam_type, total_questions FROM mock_preboard_exams WHERE exam_type = 'COMPREHENSIVE';
-- Expected: 3 comprehensive exams

-- Check all mock exams
-- SELECT exam_id, exam_code, exam_name, exam_type FROM mock_preboard_exams ORDER BY exam_id;
