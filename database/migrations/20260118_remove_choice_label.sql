-- ============================================================================
-- Migration: Remove choice_label column from question_choices table
-- Date: 2026-01-18
-- Status: EXECUTED
-- Purpose: Allow dynamic shuffling of choices on each quiz attempt
--          to prevent answer memorization
-- ============================================================================

-- Backup was already exported to: database/backups/choice_labels_backup.tsv

-- Step 1: Create a new index on question_id first (needed before dropping unique constraint
--         because the FK constraint fk_choices_question requires an index on question_id)
CREATE INDEX idx_question_id ON question_choices(question_id);

-- Step 2: Drop the unique constraint that depends on choice_label
ALTER TABLE question_choices DROP INDEX uq_question_choice;

-- Step 3: Drop the choice_label column
ALTER TABLE question_choices DROP COLUMN choice_label;

-- ============================================================================
-- Notes:
-- - Labels (A, B, C, D) will now be generated dynamically at runtime
-- - Choices will be shuffled randomly on each API fetch
-- - The display_order column can still be used if consistent ordering is needed
-- ============================================================================
