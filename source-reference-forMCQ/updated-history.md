Phase 1: Drop all MCQs from database
# Truncate all MCQ-related tables
$ docker exec b4a44a780e827aa23caa2c0af327ee5f05f8cdbad58fd454b876701adbc6d010 mysql -u root -pcpale2026 cpale_explained -e "SET FOREIGN_KEY_CHECKS = 0; TRUNCATE TABLE attempt_answers; TRUNCATE TABLE question_choices; TRUNCATE TABLE question_explanations; TRUNCATE TABLE questions; SET FOREIGN_KEY_CHECKS = 1; SELECT 'Tables truncated successfully' as status;"
mysql: [Warning] Using a password on the command line interface can be insecure.
status
Tables truncated successfully
# Verify tables are empty
$ docker exec b4a44a780e827aa23caa2c0af327ee5f05f8cdbad58fd454b876701adbc6d010 mysql -u root -pcpale2026 cpale_explained -e "SELECT (SELECT COUNT(*) FROM questions) as questions, (SELECT COUNT(*) FROM question_choices) as choices, (SELECT COUNT(*) FROM question_explanations) as explanations;"
mysql: [Warning] Using a password on the command line interface can be insecure.
questions	choices	explanations
0	0	0

# Todos
[✓] 
Drop all MCQs from question tables (questions, question_choices, question_explanations)
[•] 
Run Drizzle introspect to sync schema with database
[ ] 
Generate 50 HARD MCQs as YAML files (8-9 per subject across 6 subjects)
[ ] 
Convert YAML files to SQL INSERT statements
[ ] 
Insert 50 MCQs into Docker database
[ ] 
Review and update landing-page/index.html
[ ] 
Review and update landing-page/dashboard.html
[ ] 
Review and update landing-page/quiz.html
[ ] 
Review and update landing-page/pricing.html
[ ] 
Verify all pages work correctly with new MCQ data
Phase 2: Run Drizzle introspect
# Run Drizzle introspect to sync schema
$ npx drizzle-kit introspect 2>&1
No config path provided, using default 'drizzle.config.ts'
Reading config file 'C:\Users\LD3\Desktop\cpale-explained\drizzle.config.ts'
Pulling from ['public'] list of schemas
[⣷] 0 tables fetching
[⣷] 0 columns fetching
[⣷] 0 indexes fetching
[⣷] 0 foreign keys fetching
[⣷] 0 policies fetching
[⣷] 0 check constraints fetching


# Verify questionChoices schema has why_wrong
$ grep -A 15 "questionChoices = mysqlTable" drizzle/schema.ts
export const questionChoices = mysqlTable("question_choices", {
	choiceId: bigint("choice_id", { mode: "number" }).autoincrement().notNull(),
	questionId: bigint("question_id", { mode: "number" }).notNull().references(() => questions.questionId, { onDelete: "cascade" } ),
	choiceText: longtext("choice_text").notNull(),
	isCorrect: tinyint("is_correct").default(0),
	whyWrong: text("why_wrong"),
	isActive: tinyint("is_active").default(1),
	displayOrder: int("display_order"),
	createdAt: timestamp("created_at", { mode: 'string' }).defaultNow(),
},
(table) => [
	index("idx_question_id").on(table.questionId),
	primaryKey({ columns: [table.choiceId], name: "question_choices_choice_id"}),
]);
export const questionExplanations = mysqlTable("question_explanations", {



    The schema now includes whyWrong. Let me copy this to the src/db/schema folder:
# Copy updated schema to src folder
$ cp drizzle/schema.ts src/db/schema/schema.ts && cp drizzle/relations.ts src/db/schema/relations.ts 2>/dev/null || echo "relations.ts not found in src/db/schema"


# Todos
[✓] 
Drop all MCQs from question tables (questions, question_choices, question_explanations)
[✓] 
Run Drizzle introspect to sync schema with database
[✓] 
Generate 50 HARD MCQs as YAML files (8-9 per subject across 6 subjects)
[✓] 
Convert YAML files to SQL INSERT statements
[✓] 
Insert 50 MCQs into Docker database
[ ] 
Review and update landing-page/index.html
[ ] 
Review and update landing-page/dashboard.html
[ ] 
Review and update landing-page/quiz.html
[ ] 
Review and update landing-page/pricing.html
[ ] 
Verify all pages work correctly with new MCQ data



Conversation Summary: CPALE Explained - MCQ System Refactoring
What We Did
Task 1: Remove choice_label Column from question_choices Table
Purpose: Enable dynamic shuffling of choices on each quiz attempt to prevent answer memorization.
Completed Actions:
1. Backed up data: database/backups/choice_labels_backup.tsv (120 rows)
2. Created migration: database/migrations/20260118_remove_choice_label.sql
3. Updated database schema files:
   - database/schema.sql - Removed choice_label CHAR(1) column and unique constraint
   - drizzle/schema.ts - Removed choiceLabel field
   - src/db/schema/schema.ts - Removed choiceLabel field
4. Updated backend: backend/server.js - Added shuffleArray() and assignChoiceLabels() utility functions; updated 5 SQL queries to remove choice_label and shuffle choices dynamically
5. Ran migration on Docker container: b4a44a780e827aa23caa2c0af327ee5f05f8cdbad58fd454b876701adbc6d010
Task 2: Add why_wrong Column to question_choices Table
Purpose: Store per-choice "why wrong" explanations instead of in question_explanations.why_wrong_choices (which had hardcoded labels like "B is wrong").


Completed Actions:
1. Backed up data: database/backups/why_wrong_choices_backup.tsv (30 records)
2. Created migration: database/migrations/20260118_add_why_wrong_column.sql
3. Created data migration script: database/migrations/migrate_why_wrong_data.js
4. Generated SQL updates: database/migrations/why_wrong_data_updates.sql (90 UPDATE statements)
5. Updated schema files to add whyWrong field
6. Updated backend to include why_wrong in queries
7. Updated frontend: landing-page/quiz.html - Now builds "why wrong" display from per-choice data with dynamic labels
8. Updated generator: src/generators/MCQGenerator.js
9. Updated documentation: docs/features/choice-question-reshuffle.md
Task 3: Insert 50 Free HARD MCQs (COMPLETED)
Purpose: Insert 50 exam-level HARD MCQs with FREE access across all 6 subjects.

Completed Actions:
1. Updated yaml_to_sql_converter.js to read from MCQ/sets/free/ (instead of MCQ/sets/hard/)
2. Fixed SUBJECT_TOPICS mapping: AUD topic_id from 63 to 68 (matches database)
3. Generated SQL: database/migrations/insert_50_free_mcqs.sql from 50 YAML files
4. Applied schema migrations to Docker container (cpale-mysql):
   - 20260118_remove_choice_label.sql - Removed choice_label column
   - 20260118_add_why_wrong_column.sql - Added why_wrong TEXT column
5. Truncated all MCQ tables (questions, question_choices, question_explanations, practice_sets, exam_attempt_questions, attempt_answers)
6. Executed SQL insertion successfully

Final Database State:
- Practice Sets: 6 (one per subject: FAR-FREE-50, AFAR-FREE-50, AUD-FREE-50, TAX-FREE-50, MS-FREE-50, RFBT-FREE-50)
- Questions: 50 (FAR: 9, AFAR: 8, AUD: 8, TAX: 9, MS: 8, RFBT: 8)
- Question Choices: 200 (4 per question, all with why_wrong explanations for incorrect answers)
- Question Explanations: 50 (with short, long, and tip content)
- Access Level: All questions are FREE
- Difficulty Level: All questions are HARD

Schema Verification:
✅ question_choices table has NO choice_label column
✅ question_choices table has why_wrong TEXT column
✅ All correct answers have why_wrong = NULL
✅ All incorrect answers have detailed why_wrong explanations
✅ All questions have exactly 4 choices and 1 correct answer
✅ Backend shuffleArray() and assignChoiceLabels() functions ready for dynamic shuffling

Docker Container: cpale-mysql (810d2d953d40)
Date Completed: 2026-01-23



