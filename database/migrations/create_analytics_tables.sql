-- =====================================================
-- AI Analytics Tables Migration
-- Creates tables for tracking user performance and AI analysis
-- =====================================================

SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS;
SET FOREIGN_KEY_CHECKS=0;

-- =====================================================
-- TABLE 1: user_answer_history
-- Purpose: Track every question attempt for pattern analysis
-- =====================================================

CREATE TABLE IF NOT EXISTS user_answer_history (
  history_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  question_id BIGINT NOT NULL,
  attempt_number INT DEFAULT 1,
  selected_choice_id BIGINT,
  is_correct TINYINT(1) NOT NULL,
  time_spent_seconds INT DEFAULT 0,
  context ENUM('PRACTICE', 'MOCK_EXAM', 'REVIEW') DEFAULT 'PRACTICE',
  answered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  INDEX idx_user_question (user_id, question_id),
  INDEX idx_user_answered (user_id, answered_at),
  INDEX idx_answered_at (answered_at),
  INDEX idx_context (context),
  
  CONSTRAINT fk_answer_history_user FOREIGN KEY (user_id) 
    REFERENCES users(user_id) ON DELETE CASCADE,
  CONSTRAINT fk_answer_history_question FOREIGN KEY (question_id) 
    REFERENCES questions(question_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- =====================================================
-- TABLE 2: topic_performance_summary
-- Purpose: Aggregated performance per topic for quick lookups
-- =====================================================

CREATE TABLE IF NOT EXISTS topic_performance_summary (
  summary_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  topic_id INT NOT NULL,
  subject_id INT NOT NULL,
  
  -- Overall metrics
  total_attempted INT DEFAULT 0,
  total_correct INT DEFAULT 0,
  accuracy_percent DECIMAL(5,2) DEFAULT 0.00,
  
  -- Breakdown by difficulty
  easy_attempted INT DEFAULT 0,
  easy_correct INT DEFAULT 0,
  medium_attempted INT DEFAULT 0,
  medium_correct INT DEFAULT 0,
  hard_attempted INT DEFAULT 0,
  hard_correct INT DEFAULT 0,
  
  -- Time metrics
  avg_time_seconds INT DEFAULT 0,
  total_time_seconds INT DEFAULT 0,
  
  -- Timestamps
  last_attempted_at TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  UNIQUE KEY unique_user_topic (user_id, topic_id),
  INDEX idx_user_subject (user_id, subject_id),
  INDEX idx_accuracy (accuracy_percent),
  
  CONSTRAINT fk_topic_perf_user FOREIGN KEY (user_id) 
    REFERENCES users(user_id) ON DELETE CASCADE,
  CONSTRAINT fk_topic_perf_topic FOREIGN KEY (topic_id) 
    REFERENCES topics(topic_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- =====================================================
-- TABLE 3: user_learning_patterns
-- Purpose: AI-generated insights and recommendations
-- =====================================================

CREATE TABLE IF NOT EXISTS user_learning_patterns (
  pattern_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL UNIQUE,
  
  -- Accuracy by difficulty
  easy_accuracy DECIMAL(5,2) DEFAULT 0.00,
  medium_accuracy DECIMAL(5,2) DEFAULT 0.00,
  hard_accuracy DECIMAL(5,2) DEFAULT 0.00,
  overall_accuracy DECIMAL(5,2) DEFAULT 0.00,
  
  -- Time patterns
  avg_time_per_question INT DEFAULT 0,
  avg_time_easy INT DEFAULT 0,
  avg_time_medium INT DEFAULT 0,
  avg_time_hard INT DEFAULT 0,
  
  -- Volume metrics
  total_questions_attempted INT DEFAULT 0,
  total_correct INT DEFAULT 0,
  
  -- Trend analysis
  improvement_rate DECIMAL(5,2) DEFAULT 0.00,
  consistency_score DECIMAL(5,2) DEFAULT 0.00,
  
  -- JSON fields for flexible data
  weakest_topics JSON,          -- Array of {topic_id, topic_name, accuracy, subject_code}
  critical_topics JSON,         -- Topics < 40% accuracy
  needs_attention_topics JSON,  -- Topics 40-60% accuracy
  mastered_topics JSON,         -- Topics > 80% accuracy
  
  -- AI recommendations
  ai_recommendations JSON,      -- Array of recommendations with priority
  study_plan JSON,             -- Suggested study hours per topic
  practice_set_suggestions JSON, -- Recommended practice sets
  
  -- Exam readiness
  exam_readiness_score DECIMAL(5,2) DEFAULT 0.00,
  predicted_exam_score DECIMAL(5,2) DEFAULT 0.00,
  estimated_days_to_ready INT DEFAULT 0,
  
  -- Subject breakdown
  subject_scores JSON,         -- {FAR: 75, AFAR: 60, ...}
  
  -- Timestamps
  last_analyzed_at TIMESTAMP NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  CONSTRAINT fk_learning_patterns_user FOREIGN KEY (user_id) 
    REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- =====================================================
-- TABLE 4: daily_performance_log
-- Purpose: Track daily performance for trend analysis
-- =====================================================

CREATE TABLE IF NOT EXISTS daily_performance_log (
  log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT NOT NULL,
  log_date DATE NOT NULL,
  
  questions_attempted INT DEFAULT 0,
  questions_correct INT DEFAULT 0,
  accuracy_percent DECIMAL(5,2) DEFAULT 0.00,
  
  time_spent_minutes INT DEFAULT 0,
  
  -- Breakdown by subject
  subject_breakdown JSON,  -- {FAR: {attempted: 10, correct: 8}, ...}
  
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  UNIQUE KEY unique_user_date (user_id, log_date),
  INDEX idx_user_date (user_id, log_date),
  
  CONSTRAINT fk_daily_log_user FOREIGN KEY (user_id) 
    REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- =====================================================
-- SECTION 5: GENERATE TEST DATA (500+ answer history records for user_id=1)
-- =====================================================

-- Create stored procedure to generate test answer history
DELIMITER //

DROP PROCEDURE IF EXISTS generate_test_answer_history//

CREATE PROCEDURE generate_test_answer_history()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE q_id BIGINT;
    DECLARE q_topic_id INT;
    DECLARE q_difficulty VARCHAR(10);
    DECLARE is_correct_val TINYINT;
    DECLARE time_spent INT;
    DECLARE choice_id BIGINT;
    DECLARE correct_choice_id BIGINT;
    DECLARE random_accuracy DECIMAL(5,2);
    
    -- Loop through to create 500+ answer history records
    WHILE i < 600 DO
        -- Pick a random question (mix of FREE and PAID)
        IF i < 300 THEN
            -- First 300: more focus on FREE questions (1-50)
            SET q_id = FLOOR(1 + RAND() * 50);
        ELSE
            -- Next 300: mix in PAID questions (1001-1225)
            SET q_id = FLOOR(1001 + RAND() * 225);
        END IF;
        
        -- Get question details
        SELECT topic_id, difficulty_level INTO q_topic_id, q_difficulty
        FROM questions WHERE question_id = q_id LIMIT 1;
        
        -- Skip if question doesn't exist
        IF q_topic_id IS NOT NULL THEN
            -- Get correct choice for this question
            SELECT choice_id INTO correct_choice_id
            FROM question_choices 
            WHERE question_id = q_id AND is_correct = 1 
            LIMIT 1;
            
            -- Determine if answer is correct based on difficulty and some deliberate weak points
            -- Create weak points for specific subjects (FAR topics 1-10, TAX topics 91-100)
            IF q_topic_id BETWEEN 1 AND 10 THEN
                -- FAR weak point: 45% accuracy
                SET random_accuracy = 0.45;
            ELSEIF q_topic_id BETWEEN 91 AND 100 THEN
                -- TAX weak point: 35% accuracy
                SET random_accuracy = 0.35;
            ELSEIF q_difficulty = 'EASY' THEN
                SET random_accuracy = 0.85;
            ELSEIF q_difficulty = 'MEDIUM' THEN
                SET random_accuracy = 0.70;
            ELSE
                SET random_accuracy = 0.55;
            END IF;
            
            SET is_correct_val = IF(RAND() < random_accuracy, 1, 0);
            
            -- Set choice based on correctness
            IF is_correct_val = 1 THEN
                SET choice_id = correct_choice_id;
            ELSE
                -- Pick a wrong choice
                SELECT qc.choice_id INTO choice_id
                FROM question_choices qc
                WHERE qc.question_id = q_id AND qc.is_correct = 0
                ORDER BY RAND() LIMIT 1;
            END IF;
            
            -- Time spent varies by difficulty
            IF q_difficulty = 'EASY' THEN
                SET time_spent = FLOOR(30 + RAND() * 60);  -- 30-90 seconds
            ELSEIF q_difficulty = 'MEDIUM' THEN
                SET time_spent = FLOOR(45 + RAND() * 90);  -- 45-135 seconds
            ELSE
                SET time_spent = FLOOR(60 + RAND() * 120); -- 60-180 seconds
            END IF;
            
            -- Insert answer history with varied timestamps (last 30 days)
            INSERT INTO user_answer_history 
                (user_id, question_id, attempt_number, selected_choice_id, is_correct, time_spent_seconds, context, answered_at)
            VALUES 
                (1, q_id, 1, choice_id, is_correct_val, time_spent, 'PRACTICE', 
                 DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 30) DAY) - INTERVAL FLOOR(RAND() * 86400) SECOND);
        END IF;
        
        SET i = i + 1;
    END WHILE;
END//

DELIMITER ;

-- Execute the procedure
CALL generate_test_answer_history();

-- Drop the procedure after use
DROP PROCEDURE IF EXISTS generate_test_answer_history;


-- =====================================================
-- SECTION 6: Populate topic_performance_summary from answer history
-- =====================================================

INSERT INTO topic_performance_summary 
  (user_id, topic_id, subject_id, total_attempted, total_correct, accuracy_percent,
   easy_attempted, easy_correct, medium_attempted, medium_correct, hard_attempted, hard_correct,
   avg_time_seconds, total_time_seconds, last_attempted_at)
SELECT 
  h.user_id,
  t.topic_id,
  t.subject_id,
  COUNT(*) as total_attempted,
  SUM(h.is_correct) as total_correct,
  ROUND(SUM(h.is_correct) / COUNT(*) * 100, 2) as accuracy_percent,
  SUM(CASE WHEN q.difficulty_level = 'EASY' THEN 1 ELSE 0 END) as easy_attempted,
  SUM(CASE WHEN q.difficulty_level = 'EASY' AND h.is_correct = 1 THEN 1 ELSE 0 END) as easy_correct,
  SUM(CASE WHEN q.difficulty_level = 'MEDIUM' THEN 1 ELSE 0 END) as medium_attempted,
  SUM(CASE WHEN q.difficulty_level = 'MEDIUM' AND h.is_correct = 1 THEN 1 ELSE 0 END) as medium_correct,
  SUM(CASE WHEN q.difficulty_level = 'HARD' THEN 1 ELSE 0 END) as hard_attempted,
  SUM(CASE WHEN q.difficulty_level = 'HARD' AND h.is_correct = 1 THEN 1 ELSE 0 END) as hard_correct,
  ROUND(AVG(h.time_spent_seconds)) as avg_time_seconds,
  SUM(h.time_spent_seconds) as total_time_seconds,
  MAX(h.answered_at) as last_attempted_at
FROM user_answer_history h
JOIN questions q ON h.question_id = q.question_id
JOIN topics t ON q.topic_id = t.topic_id
GROUP BY h.user_id, t.topic_id, t.subject_id
ON DUPLICATE KEY UPDATE
  total_attempted = VALUES(total_attempted),
  total_correct = VALUES(total_correct),
  accuracy_percent = VALUES(accuracy_percent),
  easy_attempted = VALUES(easy_attempted),
  easy_correct = VALUES(easy_correct),
  medium_attempted = VALUES(medium_attempted),
  medium_correct = VALUES(medium_correct),
  hard_attempted = VALUES(hard_attempted),
  hard_correct = VALUES(hard_correct),
  avg_time_seconds = VALUES(avg_time_seconds),
  total_time_seconds = VALUES(total_time_seconds),
  last_attempted_at = VALUES(last_attempted_at);


-- =====================================================
-- SECTION 7: Initialize user_learning_patterns for user_id=1
-- =====================================================

INSERT INTO user_learning_patterns (user_id, last_analyzed_at)
VALUES (1, NULL)
ON DUPLICATE KEY UPDATE updated_at = NOW();


-- =====================================================
-- RESTORE FOREIGN KEY CHECKS
-- =====================================================
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;


-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================

-- Check answer history count
-- SELECT COUNT(*) as answer_history_count FROM user_answer_history WHERE user_id = 1;
-- Expected: ~600 records

-- Check topic performance summary
-- SELECT COUNT(*) as topics_with_data FROM topic_performance_summary WHERE user_id = 1;

-- Check accuracy distribution
-- SELECT 
--   CASE 
--     WHEN accuracy_percent < 40 THEN 'Critical (<40%)'
--     WHEN accuracy_percent < 60 THEN 'Needs Attention (40-60%)'
--     WHEN accuracy_percent < 80 THEN 'Good (60-80%)'
--     ELSE 'Mastered (>80%)'
--   END as category,
--   COUNT(*) as topic_count
-- FROM topic_performance_summary
-- WHERE user_id = 1
-- GROUP BY category;

-- Check deliberate weak points (FAR and TAX)
-- SELECT t.topic_name, s.subject_code, tps.accuracy_percent
-- FROM topic_performance_summary tps
-- JOIN topics t ON tps.topic_id = t.topic_id
-- JOIN subjects s ON t.subject_id = s.subject_id
-- WHERE tps.user_id = 1 AND tps.accuracy_percent < 50
-- ORDER BY tps.accuracy_percent;
