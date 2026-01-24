/**
 * YAML to SQL Converter for CPALE MCQ Questions
 * 
 * This script reads all YAML files from MCQ/sets/hard/ directory
 * and generates SQL INSERT statements for:
 * - practice_sets (one per subject for FREE MCQs)
 * - questions
 * - question_choices
 * - question_explanations
 * 
 * Usage: node database/migrations/yaml_to_sql_converter.js
 * Output: database/migrations/insert_50_hard_mcqs.sql
 */

const fs = require('fs');
const path = require('path');
const yaml = require('yaml');

// Configuration
const YAML_DIR = path.join(__dirname, '../../MCQ/sets/free');
const OUTPUT_FILE = path.join(__dirname, 'insert_50_free_mcqs.sql');

// Subject to topic mapping (for practice set creation)
// Using first topic of each subject (match actual topic IDs from database)
const SUBJECT_TOPICS = {
    'FAR': { topic_id: 1, name: 'FAR Free MCQs' },
    'AFAR': { topic_id: 36, name: 'AFAR Free MCQs' },
    'AUD': { topic_id: 68, name: 'AUD Free MCQs' },
    'TAX': { topic_id: 91, name: 'TAX Free MCQs' },
    'MS': { topic_id: 112, name: 'MS Free MCQs' },
    'RFBT': { topic_id: 133, name: 'RFBT Free MCQs' }
};

// Helper function to escape SQL strings
function escapeSql(str) {
    if (str === null || str === undefined) return 'NULL';
    return `'${str.toString().replace(/'/g, "''").replace(/\\/g, '\\\\')}'`;
}

// Helper function to escape SQL strings for TEXT fields (handle multiline)
function escapeSqlText(str) {
    if (str === null || str === undefined) return 'NULL';
    // Normalize line endings and escape
    const normalized = str.toString()
        .replace(/\r\n/g, '\n')
        .replace(/'/g, "''")
        .replace(/\\/g, '\\\\');
    return `'${normalized}'`;
}

// Read and parse all YAML files
function readYamlFiles() {
    const files = fs.readdirSync(YAML_DIR).filter(f => f.endsWith('.yml'));
    const questions = [];
    
    for (const file of files) {
        const filePath = path.join(YAML_DIR, file);
        const content = fs.readFileSync(filePath, 'utf8');
        try {
            const data = yaml.parse(content);
            data._filename = file;
            // Extract subject from code (e.g., "FAR-HARD-001" -> "FAR")
            data._subject = data.code.split('-')[0];
            questions.push(data);
        } catch (err) {
            console.error(`Error parsing ${file}:`, err.message);
        }
    }
    
    // Sort by code for consistent ordering
    questions.sort((a, b) => a.code.localeCompare(b.code));
    
    return questions;
}

// Generate SQL
function generateSql(questions) {
    let sql = `-- ============================================================================
-- CPALE Explained - 50 HARD MCQ Questions
-- Generated: ${new Date().toISOString()}
-- ============================================================================

SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================================
-- CREATE PRACTICE SETS FOR FREE MCQs (starting at ID 100 to avoid conflicts)
-- ============================================================================

`;

    // Group questions by subject
    const bySubject = {};
    for (const q of questions) {
        if (!bySubject[q._subject]) bySubject[q._subject] = [];
        bySubject[q._subject].push(q);
    }

    // Create practice sets (IDs 100-105)
    let practiceSetId = 100;
    const practiceSetMap = {}; // subject -> practice_set_id
    
    for (const [subject, info] of Object.entries(SUBJECT_TOPICS)) {
        practiceSetMap[subject] = practiceSetId;
        const qCount = bySubject[subject]?.length || 0;
        
        sql += `INSERT INTO practice_sets (practice_set_id, topic_id, set_code, set_name, set_type, is_paid, display_order, is_active, questions_per_set, access_level)
VALUES (${practiceSetId}, ${info.topic_id}, '${subject}-FREE-50', '${info.name}', 'PRACTICE', 0, ${practiceSetId}, 1, ${qCount}, 'FREE')
ON DUPLICATE KEY UPDATE set_name = VALUES(set_name), questions_per_set = VALUES(questions_per_set);

`;
        practiceSetId++;
    }

    sql += `
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================================
-- INSERT QUESTIONS
-- ============================================================================

`;

    // Track question IDs for foreign key references
    let questionId = 1;
    const questionMap = new Map(); // code -> id
    
    for (const q of questions) {
        questionMap.set(q.code, questionId);
        
        const accessLevel = (q['access-level'] || 'FREE').toUpperCase();
        const difficulty = (q.difficulty || 'HARD').toUpperCase();
        const psId = practiceSetMap[q._subject];
        
        sql += `-- Question ${questionId}: ${q.code}
INSERT INTO questions (question_id, practice_set_id, topic_id, question_code, question_text, difficulty_level, access_level, is_active, is_paid)
VALUES (${questionId}, ${psId}, ${q.topic}, ${escapeSql(q.code)}, ${escapeSqlText(q.text)}, '${difficulty}', '${accessLevel}', ${q.active ? 1 : 0}, 0);

`;
        questionId++;
    }

    sql += `
-- ============================================================================
-- INSERT QUESTION CHOICES
-- ============================================================================

`;

    let choiceId = 1;
    for (const q of questions) {
        const qId = questionMap.get(q.code);
        const choices = q.choices;
        let displayOrder = 1;
        
        sql += `-- Choices for ${q.code}\n`;
        
        for (const [key, choice] of Object.entries(choices)) {
            const isCorrect = choice.correct === true ? 1 : 0;
            const whyWrong = choice['why-wrong-choice'] || null;
            
            sql += `INSERT INTO question_choices (choice_id, question_id, choice_text, is_correct, why_wrong, display_order, is_active)
VALUES (${choiceId}, ${qId}, ${escapeSqlText(choice.label)}, ${isCorrect}, ${whyWrong ? escapeSqlText(whyWrong) : 'NULL'}, ${displayOrder}, 1);
`;
            choiceId++;
            displayOrder++;
        }
        sql += '\n';
    }

    sql += `
-- ============================================================================
-- INSERT QUESTION EXPLANATIONS
-- ============================================================================

`;

    let explanationId = 1;
    for (const q of questions) {
        const qId = questionMap.get(q.code);
        const exp = q.explanation || {};
        
        // short_explanation is NOT NULL in actual schema
        const shortExp = exp.short || 'See detailed explanation.';
        
        sql += `-- Explanation for ${q.code}
INSERT INTO question_explanations (explanation_id, question_id, short_explanation, exam_explanation, memory_tip, is_active, explanation_level)
VALUES (${explanationId}, ${qId}, ${escapeSqlText(shortExp)}, ${escapeSqlText(exp.long || '')}, ${escapeSqlText(q.tip || '')}, 1, 'EXAM');

`;
        explanationId++;
    }

    sql += `
-- ============================================================================
-- UPDATE legal_reference in a separate column (if needed) - using memory_tip for now
-- Note: The schema has reference_id (FK) not legal_reference text
-- ============================================================================

-- Store legal references in why_wrong_choices column temporarily
`;

    for (const q of questions) {
        const qId = questionMap.get(q.code);
        if (q.reference) {
            sql += `UPDATE question_explanations SET why_wrong_choices = ${escapeSqlText(q.reference)} WHERE question_id = ${qId};
`;
        }
    }

    sql += `

-- ============================================================================
-- VERIFY COUNTS
-- ============================================================================
SELECT 'Practice Sets' as table_name, COUNT(*) as count FROM practice_sets WHERE practice_set_id >= 100
UNION ALL
SELECT 'Questions', COUNT(*) FROM questions WHERE question_id <= 50
UNION ALL
SELECT 'Choices', COUNT(*) FROM question_choices WHERE question_id <= 50
UNION ALL
SELECT 'Explanations', COUNT(*) FROM question_explanations WHERE question_id <= 50;

-- Expected: Practice Sets: 6, Questions: 50, Choices: 200 (50x4), Explanations: 50
`;

    return sql;
}

// Main execution
function main() {
    console.log('Reading YAML files from:', YAML_DIR);
    
    const questions = readYamlFiles();
    console.log(`Found ${questions.length} questions`);
    
    if (questions.length !== 50) {
        console.warn(`WARNING: Expected 50 questions, found ${questions.length}`);
    }
    
    // Count by subject prefix
    const counts = {};
    for (const q of questions) {
        const prefix = q.code.split('-')[0];
        counts[prefix] = (counts[prefix] || 0) + 1;
    }
    console.log('Questions by subject:', counts);
    
    const sql = generateSql(questions);
    
    fs.writeFileSync(OUTPUT_FILE, sql, 'utf8');
    console.log(`SQL written to: ${OUTPUT_FILE}`);
    console.log(`Total questions: ${questions.length}`);
}

main();
