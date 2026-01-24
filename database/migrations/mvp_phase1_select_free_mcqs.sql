-- ================================================================
-- MVP PHASE 1 - SELECT 50 FREE MCQs
-- Date: 2026-01-18
-- Purpose: Randomly select 50 MCQs to mark as FREE access
-- Distribution: ~8-9 questions per subject (total 50)
-- ================================================================

USE cpale_explained;

-- ================================================================
-- STEP 1: First, mark ALL questions as PAID (default)
-- ================================================================
UPDATE questions 
SET access_type = 'PAID' 
WHERE access_type IS NULL OR access_type = '';

-- ================================================================
-- STEP 2: Select random FREE MCQs per subject
-- Distribution across 6 CPALE subjects:
--   FAR: 9 questions
--   AFAR: 9 questions
--   AUD: 8 questions
--   TAX: 8 questions
--   MS: 8 questions
--   RFBT: 8 questions
-- Total: 50 questions
-- ================================================================

-- FAR (Financial Accounting and Reporting) - 9 questions
UPDATE questions q
JOIN topics t ON q.topic_id = t.topic_id
JOIN subjects s ON t.subject_id = s.subject_id
SET q.access_type = 'FREE'
WHERE s.subject_code = 'FAR'
  AND q.is_active = TRUE
  AND q.difficulty_level IN ('EASY', 'MEDIUM')
ORDER BY RAND()
LIMIT 9;

-- AFAR (Advanced Financial Accounting and Reporting) - 9 questions
UPDATE questions q
JOIN topics t ON q.topic_id = t.topic_id
JOIN subjects s ON t.subject_id = s.subject_id
SET q.access_type = 'FREE'
WHERE s.subject_code = 'AFAR'
  AND q.is_active = TRUE
  AND q.difficulty_level IN ('EASY', 'MEDIUM')
  AND q.access_type != 'FREE'
ORDER BY RAND()
LIMIT 9;

-- AUD (Auditing) - 8 questions
UPDATE questions q
JOIN topics t ON q.topic_id = t.topic_id
JOIN subjects s ON t.subject_id = s.subject_id
SET q.access_type = 'FREE'
WHERE s.subject_code = 'AUD'
  AND q.is_active = TRUE
  AND q.difficulty_level IN ('EASY', 'MEDIUM')
  AND q.access_type != 'FREE'
ORDER BY RAND()
LIMIT 8;

-- TAX (Taxation) - 8 questions
UPDATE questions q
JOIN topics t ON q.topic_id = t.topic_id
JOIN subjects s ON t.subject_id = s.subject_id
SET q.access_type = 'FREE'
WHERE s.subject_code = 'TAX'
  AND q.is_active = TRUE
  AND q.difficulty_level IN ('EASY', 'MEDIUM')
  AND q.access_type != 'FREE'
ORDER BY RAND()
LIMIT 8;

-- MS (Management Services) - 8 questions
UPDATE questions q
JOIN topics t ON q.topic_id = t.topic_id
JOIN subjects s ON t.subject_id = s.subject_id
SET q.access_type = 'FREE'
WHERE s.subject_code = 'MS'
  AND q.is_active = TRUE
  AND q.difficulty_level IN ('EASY', 'MEDIUM')
  AND q.access_type != 'FREE'
ORDER BY RAND()
LIMIT 8;

-- RFBT (Regulatory Framework for Business Transactions) - 8 questions
UPDATE questions q
JOIN topics t ON q.topic_id = t.topic_id
JOIN subjects s ON t.subject_id = s.subject_id
SET q.access_type = 'FREE'
WHERE s.subject_code = 'RFBT'
  AND q.is_active = TRUE
  AND q.difficulty_level IN ('EASY', 'MEDIUM')
  AND q.access_type != 'FREE'
ORDER BY RAND()
LIMIT 8;

-- ================================================================
-- STEP 3: Verification - Show FREE MCQs distribution
-- ================================================================
SELECT '=== FREE MCQs DISTRIBUTION BY SUBJECT ===' as section;

SELECT 
    s.subject_code,
    s.subject_name,
    COUNT(*) as free_mcqs
FROM questions q
JOIN topics t ON q.topic_id = t.topic_id
JOIN subjects s ON t.subject_id = s.subject_id
WHERE q.access_type = 'FREE'
  AND q.is_active = TRUE
GROUP BY s.subject_id, s.subject_code, s.subject_name
ORDER BY s.subject_code;

SELECT '=== TOTAL FREE vs PAID ===' as section;

SELECT 
    access_type,
    COUNT(*) as count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM questions WHERE is_active = TRUE), 2) as percentage
FROM questions
WHERE is_active = TRUE
GROUP BY access_type;

SELECT '=== FREE MCQs BY DIFFICULTY ===' as section;

SELECT 
    difficulty_level,
    COUNT(*) as count
FROM questions
WHERE access_type = 'FREE'
  AND is_active = TRUE
GROUP BY difficulty_level;

-- ================================================================
-- STEP 4: Sample FREE questions (first 10)
-- ================================================================
SELECT '=== SAMPLE FREE QUESTIONS ===' as section;

SELECT 
    q.question_id,
    q.question_code,
    s.subject_code,
    t.topic_name,
    q.difficulty_level,
    LEFT(q.question_text, 100) as question_preview
FROM questions q
JOIN topics t ON q.topic_id = t.topic_id
JOIN subjects s ON t.subject_id = s.subject_id
WHERE q.access_type = 'FREE'
  AND q.is_active = TRUE
ORDER BY s.subject_code, q.question_id
LIMIT 10;

SELECT '=== FREE MCQ SELECTION COMPLETE ===' as message;

-- ================================================================
-- NOTES:
-- 1. Selection is random each time this script runs
-- 2. Favors EASY/MEDIUM difficulty for free users
-- 3. Total should be approximately 50 questions
-- 4. Run verification queries to confirm distribution
-- ================================================================
