-- ================================================================
-- MVP PHASE 1 - BACKUP SCRIPT
-- Date: 2026-01-18
-- Purpose: Backup current database state before migration
-- ================================================================

USE cpale_explained;

-- Backup questions table
DROP TABLE IF EXISTS questions_backup_20260118;
CREATE TABLE questions_backup_20260118 AS SELECT * FROM questions;

-- Backup practice_sets table
DROP TABLE IF EXISTS practice_sets_backup_20260118;
CREATE TABLE practice_sets_backup_20260118 AS SELECT * FROM practice_sets;

-- Backup user_subscriptions table
DROP TABLE IF EXISTS user_subscriptions_backup_20260118;
CREATE TABLE user_subscriptions_backup_20260118 AS SELECT * FROM user_subscriptions;

-- Backup users table
DROP TABLE IF EXISTS users_backup_20260118;
CREATE TABLE users_backup_20260118 AS SELECT * FROM users;

-- Verify backups created
SELECT 
    'questions_backup_20260118' as table_name, 
    COUNT(*) as row_count 
FROM questions_backup_20260118
UNION ALL
SELECT 
    'practice_sets_backup_20260118' as table_name, 
    COUNT(*) as row_count 
FROM practice_sets_backup_20260118
UNION ALL
SELECT 
    'user_subscriptions_backup_20260118' as table_name, 
    COUNT(*) as row_count 
FROM user_subscriptions_backup_20260118
UNION ALL
SELECT 
    'users_backup_20260118' as table_name, 
    COUNT(*) as row_count 
FROM users_backup_20260118;

-- ================================================================
-- BACKUP COMPLETE
-- ================================================================
