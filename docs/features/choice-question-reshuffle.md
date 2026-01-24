
## QUESTION CHOICES DISPLAY TO USER VIEW

Shuffle choices randomly each time they are fetched to prevent answer memorization.

## Approach
Shuffle randomly each time - Choices will be shuffled on every API fetch, preventing users from memorizing answer positions.

## How It Works

### Choice Shuffling
1. On every API request, choices are fetched from database (without labels)
2. Backend shuffles choices randomly using Fisher-Yates algorithm
3. Labels (A, B, C, D) are assigned dynamically based on shuffled order
4. Frontend receives the shuffled choices with dynamically assigned labels
5. Each quiz attempt shows choices in a different order, preventing memorization

### Why Wrong Explanations
The `why_wrong` explanation is now stored per-choice in the `question_choices` table instead of in `question_explanations.why_wrong_choices`. This ensures that when choices are shuffled, the "why wrong" explanation follows each choice and displays with the correct dynamic label.

**Before (deprecated):**
```
question_explanations.why_wrong_choices:
"B is wrong - reason\nC is wrong - reason\nD is wrong - reason"
```

**After (current):**
```
question_choices.why_wrong:
choice_id=230: "tax determination is a separate objective..."
choice_id=231: "management performance assessment is secondary..."
choice_id=232: "regulatory compliance is a consequence..."
```

## Database Schema Changes

### Removed from `question_choices`:
- `choice_label CHAR(1)` - Now generated dynamically at runtime

### Added to `question_choices`:
- `why_wrong TEXT` - Per-choice explanation for incorrect answers

### Deprecated in `question_explanations`:
- `why_wrong_choices` - Still exists for backward compatibility but no longer used

## Implementation Details

### Backend (`backend/server.js`)
- `shuffleArray()` - Fisher-Yates shuffle algorithm
- `assignChoiceLabels()` - Assigns A/B/C/D to shuffled choices
- All choice queries now include `why_wrong` column

### Frontend (`landing-page/quiz.html`)
- Builds "why wrong" display from per-choice data with dynamic labels
- Labels match the shuffled order shown to the user

## Migration
- Backup: `database/backups/choice_labels_backup.tsv`
- Backup: `database/backups/why_wrong_choices_backup.tsv`
- Migration: `database/migrations/20260118_remove_choice_label.sql`
- Migration: `database/migrations/20260118_add_why_wrong_column.sql`
- Data migration: `database/migrations/why_wrong_data_updates.sql`


