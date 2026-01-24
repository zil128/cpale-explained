-- ================================================================
-- MVP PHASE 1 - ROLLBACK SCRIPT
-- Date: 2026-01-18
-- Purpose: Rollback migration if issues occur
-- WARNING: Run this ONLY if migration fails or issues arise
-- ================================================================

USE cpale_explained;

SELECT '=== STARTING ROLLBACK ===' as message;

-- ================================================================
-- STEP 1: Drop new tables created during migration
-- ================================================================

SELECT 'Dropping new tables...' as step;

DROP TABLE IF EXISTS user_mcq_usage;
DROP TABLE IF EXISTS user_subscriptions_v2;
DROP TABLE IF EXISTS subscription_plans_v2;

-- ================================================================
-- STEP 2: Remove new columns from existing tables
-- ================================================================

SELECT 'Removing access_type column from questions...' as step;

SET @dbname = 'cpale_explained';
SET @tablename = 'questions';
SET @columnname = 'access_type';

SET @preparedStatement = (SELECT IF(
  (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
   WHERE TABLE_SCHEMA = @dbname 
   AND TABLE_NAME = @tablename 
   AND COLUMN_NAME = @columnname) > 0,
  'ALTER TABLE questions DROP COLUMN access_type',
  'SELECT "Column does not exist" as message'
));

PREPARE alterIfExists FROM @preparedStatement;
EXECUTE alterIfExists;
DEALLOCATE PREPARE alterIfExists;

SELECT 'Removing access_type column from practice_sets...' as step;

SET @tablename = 'practice_sets';

SET @preparedStatement = (SELECT IF(
  (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
   WHERE TABLE_SCHEMA = @dbname 
   AND TABLE_NAME = @tablename 
   AND COLUMN_NAME = @columnname) > 0,
  'ALTER TABLE practice_sets DROP COLUMN access_type',
  'SELECT "Column does not exist" as message'
));

PREPARE alterIfExists FROM @preparedStatement;
EXECUTE alterIfExists;
DEALLOCATE PREPARE alterIfExists;

-- ================================================================
-- STEP 3: Drop indexes if they exist
-- ================================================================

SELECT 'Dropping indexes...' as step;

-- Drop indexes (ignore errors if they don't exist)
DROP INDEX IF EXISTS idx_questions_access_type ON questions;
DROP INDEX IF EXISTS idx_practice_sets_access_type ON practice_sets;

-- ================================================================
-- STEP 4: Restore from backup tables (if they exist)
-- ================================================================

SELECT 'Checking for backup tables...' as step;

SET @backup_exists = (SELECT COUNT(*) 
                      FROM INFORMATION_SCHEMA.TABLES 
                      WHERE TABLE_SCHEMA = @dbname 
                      AND TABLE_NAME = 'questions_backup_20260118');

-- If backups exist, optionally restore (commented out for safety)
-- Uncomment these if you need to restore original data
/*
TRUNCATE TABLE questions;
INSERT INTO questions SELECT * FROM questions_backup_20260118;

TRUNCATE TABLE practice_sets;
INSERT INTO practice_sets SELECT * FROM practice_sets_backup_20260118;

TRUNCATE TABLE user_subscriptions;
INSERT INTO user_subscriptions SELECT * FROM user_subscriptions_backup_20260118;
*/

-- ================================================================
-- STEP 5: Delete test users (if they exist)
-- ================================================================

SELECT 'Removing test users...' as step;

DELETE FROM users WHERE email IN (
    'testfree@cpale.com',
    'testpaid@cpale.com',
    'testexpired@cpale.com'
);

-- ================================================================
-- STEP 6: Verification
-- ================================================================

SELECT '=== ROLLBACK VERIFICATION ===' as section;

-- Check if new tables still exist
SELECT 
    TABLE_NAME,
    'Should be 0 if rollback successful' as status
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'cpale_explained'
AND TABLE_NAME IN ('subscription_plans_v2', 'user_subscriptions_v2', 'user_mcq_usage');

-- Check if access_type columns still exist
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    'Should be empty if rollback successful' as status
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'cpale_explained'
AND COLUMN_NAME = 'access_type';

-- Check current state of questions table
SELECT 
    'questions' as table_name,
    COUNT(*) as total_questions,
    COUNT(DISTINCT access_level) as access_levels
FROM questions;

-- Check current state of practice_sets table
SELECT 
    'practice_sets' as table_name,
    COUNT(*) as total_sets,
    COUNT(DISTINCT access_level) as access_levels
FROM practice_sets;

SELECT '=== ROLLBACK COMPLETE ===' as message;

-- ================================================================
-- NOTES:
-- 1. This script removes all MVP Phase 1 changes
-- 2. Original tables and columns are preserved
-- 3. Backup tables remain for safety (can delete manually later)
-- 4. To fully restore data, uncomment restoration section in STEP 4
-- 5. After rollback, system reverts to original state
-- 
-- Post-Rollback Actions:
-- - Check application still works with old schema
-- - Review logs to identify why rollback was needed
-- - Fix issues before attempting migration again
-- - Consider keeping backup tables for 1 week
-- ================================================================
