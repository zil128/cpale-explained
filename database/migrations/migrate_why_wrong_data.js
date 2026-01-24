/**
 * Migration Script: Parse why_wrong_choices and populate why_wrong column
 * 
 * This script:
 * 1. Reads the choice_labels_backup.tsv to map original labels to choice_id
 * 2. Reads the why_wrong_choices_backup.tsv to get the text data
 * 3. Parses the text format "X is wrong - reason" 
 * 4. Generates UPDATE statements to populate the why_wrong column
 */

const fs = require('fs');
const path = require('path');

// Read and parse TSV file
function parseTSV(filepath) {
  const content = fs.readFileSync(filepath, 'utf8');
  const lines = content.trim().split('\n');
  const headers = lines[0].split('\t');
  const rows = [];
  
  for (let i = 1; i < lines.length; i++) {
    const values = lines[i].split('\t');
    const row = {};
    headers.forEach((h, idx) => {
      row[h] = values[idx];
    });
    rows.push(row);
  }
  return rows;
}

// Parse why_wrong_choices text into label -> reason mapping
function parseWhyWrongText(text) {
  const mapping = {};
  
  // Handle literal \n in the TSV (it's escaped)
  const normalized = text.replace(/\\n/g, '\n');
  
  // Pattern: "X is wrong - reason" where X is A, B, C, or D
  // Also handle "A, B, D are wrong - reason" format
  const lines = normalized.split('\n');
  
  for (const line of lines) {
    // Skip lines that mention "is correct"
    if (line.includes('is correct')) continue;
    
    // Match single label: "B is wrong - reason"
    const singleMatch = line.match(/^([A-D]) is wrong - (.+)$/);
    if (singleMatch) {
      mapping[singleMatch[1]] = singleMatch[2].trim();
      continue;
    }
    
    // Match multiple labels: "A, B, D are wrong - reason"
    const multiMatch = line.match(/^([A-D](?:,\s*[A-D])*) are wrong - (.+)$/);
    if (multiMatch) {
      const labels = multiMatch[1].split(/,\s*/);
      const reason = multiMatch[2].trim();
      labels.forEach(label => {
        mapping[label] = reason;
      });
    }
  }
  
  return mapping;
}

// Main migration logic
function generateMigrationSQL() {
  const backupDir = path.join(__dirname, '..', 'backups');
  
  // Load choice labels backup (maps question_id + choice_label -> choice_id)
  const choiceLabels = parseTSV(path.join(backupDir, 'choice_labels_backup.tsv'));
  
  // Build lookup: { "55_B": 230, "55_C": 231, ... }
  const labelToChoiceId = {};
  choiceLabels.forEach(row => {
    const key = `${row.question_id}_${row.choice_label}`;
    labelToChoiceId[key] = row.choice_id;
  });
  
  // Load why_wrong_choices backup
  const whyWrongData = parseTSV(path.join(backupDir, 'why_wrong_choices_backup.tsv'));
  
  // Generate UPDATE statements
  const updates = [];
  let successCount = 0;
  let skipCount = 0;
  
  for (const row of whyWrongData) {
    const questionId = row.question_id;
    const whyWrongText = row.why_wrong_choices;
    
    // Parse the text into label -> reason mapping
    const labelReasons = parseWhyWrongText(whyWrongText);
    
    for (const [label, reason] of Object.entries(labelReasons)) {
      const key = `${questionId}_${label}`;
      const choiceId = labelToChoiceId[key];
      
      if (choiceId) {
        // Escape single quotes for SQL
        const escapedReason = reason.replace(/'/g, "''");
        updates.push(`UPDATE question_choices SET why_wrong = '${escapedReason}' WHERE choice_id = ${choiceId};`);
        successCount++;
      } else {
        console.warn(`Warning: No choice_id found for question ${questionId}, label ${label}`);
        skipCount++;
      }
    }
  }
  
  console.log(`Generated ${successCount} UPDATE statements`);
  console.log(`Skipped ${skipCount} (no matching choice_id)`);
  
  // Write to SQL file
  const sqlContent = `-- Migration: Populate why_wrong column from why_wrong_choices data
-- Generated: ${new Date().toISOString()}
-- Records: ${successCount}

${updates.join('\n')}
`;
  
  const outputPath = path.join(__dirname, 'why_wrong_data_updates.sql');
  fs.writeFileSync(outputPath, sqlContent);
  console.log(`SQL written to: ${outputPath}`);
  
  return updates;
}

// Run
generateMigrationSQL();
