-- ============================================================================
-- Migration: Add why_wrong column to question_choices table
-- Date: 2026-01-18
-- Status: EXECUTED
-- Purpose: Store per-choice "why wrong" explanations to support dynamic
--          choice shuffling. Labels (A/B/C/D) in explanations now follow
--          the shuffled order instead of being hardcoded.
-- ============================================================================

-- Backup was exported to: database/backups/why_wrong_choices_backup.tsv

-- Step 1: Add why_wrong column to question_choices table
ALTER TABLE question_choices ADD COLUMN why_wrong TEXT NULL AFTER is_correct;

-- ============================================================================
-- Data Migration Notes:
-- The existing why_wrong_choices data in question_explanations was in format:
--   "B is wrong - reason\nC is wrong - reason\nD is wrong - reason"
-- 
-- This data was parsed and migrated to individual choice records using
-- the choice_labels_backup.tsv to map original labels to choice_id.
-- 
-- After migration, the why_wrong_choices column in question_explanations
-- can be deprecated (kept for backward compatibility).
-- ============================================================================
