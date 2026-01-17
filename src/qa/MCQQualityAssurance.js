const fs = require('fs');
const path = require('path');

class MCQQualityAssurance {
    constructor() {
        this.validationRules = {
            questionCode: /^[A-Z]{3,4}-\d{2}-\d{3}-[EMH]$/,
            subjects: ['FAR', 'AFAR', 'MS', 'RFBT', 'TAX', 'AUD'],
            difficultyLevels: ['EASY', 'MEDIUM', 'HARD'],
            accessLevels: ['FREE', 'BASIC', 'ADVANCE'],
            choiceLabels: ['A', 'B', 'C', 'D'],
            minExplanationLength: 20,
            maxExplanationLength: 2000
        };
        
        this.issues = [];
        this.stats = {
            totalQuestions: 0,
            validQuestions: 0,
            invalidQuestions: 0,
            warnings: 0,
            errors: 0
        };
    }

    validateMCQ(mcq) {
        const issues = [];
        
        // Validate question code format
        if (!this.validationRules.questionCode.test(mcq.question_code)) {
            issues.push({
                type: 'ERROR',
                field: 'question_code',
                message: `Invalid question code format: ${mcq.question_code}`,
                expected: 'Format: SUBJECT-TOPIC-QUESTION-DIFFICULTY (e.g., FAR-01-001-E)'
            });
        }
        
        // Validate subject
        if (!this.validationRules.subjects.includes(mcq.subject)) {
            issues.push({
                type: 'ERROR',
                field: 'subject',
                message: `Invalid subject: ${mcq.subject}`,
                expected: this.validationRules.subjects.join(', ')
            });
        }
        
        // Validate difficulty level
        if (!this.validationRules.difficultyLevels.includes(mcq.difficulty_level)) {
            issues.push({
                type: 'ERROR',
                field: 'difficulty_level',
                message: `Invalid difficulty level: ${mcq.difficulty_level}`,
                expected: this.validationRules.difficultyLevels.join(', ')
            });
        }
        
        // Validate access level
        if (!this.validationRules.accessLevels.includes(mcq.access_level)) {
            issues.push({
                type: 'ERROR',
                field: 'access_level',
                message: `Invalid access level: ${mcq.access_level}`,
                expected: this.validationRules.accessLevels.join(', ')
            });
        }
        
        // Validate question text
        if (!mcq.question_text || mcq.question_text.trim().length < 10) {
            issues.push({
                type: 'ERROR',
                field: 'question_text',
                message: 'Question text too short or empty',
                expected: 'Minimum 10 characters'
            });
        }
        
        // Validate choices
        if (!mcq.choices || !Array.isArray(mcq.choices) || mcq.choices.length !== 4) {
            issues.push({
                type: 'ERROR',
                field: 'choices',
                message: 'Must have exactly 4 choices',
                expected: 'Array of 4 choices'
            });
        } else {
            const choiceLabels = mcq.choices.map(c => c.label);
            const correctChoices = mcq.choices.filter(c => c.is_correct);
            
            // Check choice labels
            for (const label of this.validationRules.choiceLabels) {
                if (!choiceLabels.includes(label)) {
                    issues.push({
                        type: 'ERROR',
                        field: 'choices',
                        message: `Missing choice label: ${label}`,
                        expected: 'Must have choices A, B, C, D'
                    });
                }
            }
            
            // Check exactly one correct answer
            if (correctChoices.length !== 1) {
                issues.push({
                    type: 'ERROR',
                    field: 'choices',
                    message: `Must have exactly 1 correct answer, found ${correctChoices.length}`,
                    expected: 'Exactly 1 correct choice'
                });
            }
            
            // Validate choice text
            for (const choice of mcq.choices) {
                if (!choice.text || choice.text.trim().length < 3) {
                    issues.push({
                        type: 'ERROR',
                        field: 'choices',
                        message: `Choice ${choice.label} text too short or empty`,
                        expected: 'Minimum 3 characters'
                    });
                }
            }
        }
        
        // Validate correct_answer matches choices
        if (mcq.choices && mcq.correct_answer) {
            const correctChoice = mcq.choices.find(c => c.is_correct);
            if (!correctChoice || correctChoice.label !== mcq.correct_answer) {
                issues.push({
                    type: 'ERROR',
                    field: 'correct_answer',
                    message: `correct_answer (${mcq.correct_answer}) doesn't match the actual correct choice (${correctChoice ? correctChoice.label : 'none'})`,
                    expected: 'correct_answer should match the label of the correct choice'
                });
            }
        }
        
        // Validate explanations
        if (!mcq.short_explanation || mcq.short_explanation.length < this.validationRules.minExplanationLength) {
            issues.push({
                type: 'WARNING',
                field: 'short_explanation',
                message: 'Short explanation too brief',
                expected: `Minimum ${this.validationRules.minExplanationLength} characters`
            });
        }
        
        if (!mcq.detailed_explanation || mcq.detailed_explanation.length < this.validationRules.minExplanationLength) {
            issues.push({
                type: 'WARNING',
                field: 'detailed_explanation',
                message: 'Detailed explanation too brief',
                expected: `Minimum ${this.validationRules.minExplanationLength} characters`
            });
        }
        
        if (mcq.detailed_explanation && mcq.detailed_explanation.length > this.validationRules.maxExplanationLength) {
            issues.push({
                type: 'WARNING',
                field: 'detailed_explanation',
                message: 'Detailed explanation too long',
                expected: `Maximum ${this.validationRules.maxExplanationLength} characters`
            });
        }
        
        // Validate why_wrong_choices
        if (!mcq.why_wrong_choices || typeof mcq.why_wrong_choices !== 'object') {
            issues.push({
                type: 'WARNING',
                field: 'why_wrong_choices',
                message: 'Missing or invalid why_wrong_choices',
                expected: 'Object with explanations for wrong choices'
            });
        }
        
        // Validate memory tip
        if (!mcq.memory_tip || mcq.memory_tip.length < 5) {
            issues.push({
                type: 'WARNING',
                field: 'memory_tip',
                message: 'Memory tip too short or missing',
                expected: 'Minimum 5 characters'
            });
        }
        
        // Validate legal reference
        if (!mcq.legal_reference || mcq.legal_reference.length < 3) {
            issues.push({
                type: 'WARNING',
                field: 'legal_reference',
                message: 'Legal reference too short or missing',
                expected: 'Minimum 3 characters'
            });
        }
        
        // Check for duplicate choice texts
        if (mcq.choices) {
            const choiceTexts = mcq.choices.map(c => c.text.trim().toLowerCase());
            const duplicates = choiceTexts.filter((text, index) => choiceTexts.indexOf(text) !== index);
            if (duplicates.length > 0) {
                issues.push({
                    type: 'ERROR',
                    field: 'choices',
                    message: 'Duplicate choice texts found',
                    expected: 'All choices should have unique text'
                });
            }
        }
        
        // Check for generic or placeholder content
        const genericPatterns = [
            /correct treatment/gi,
            /incorrect approach/gi,
            /common misconception/gi,
            /outdated treatment/gi,
            /violates/gi,
            /specified in/gi,
            /key principle/gi
        ];
        
        if (mcq.question_text) {
            for (const pattern of genericPatterns) {
                if (pattern.test(mcq.question_text)) {
                    issues.push({
                        type: 'WARNING',
                        field: 'question_text',
                        message: 'Contains generic placeholder text',
                        expected: 'Specific, meaningful content'
                    });
                    break;
                }
            }
        }
        
        return issues;
    }

    validateBatch(mcqs) {
        console.log('🔍 Starting MCQ Quality Assurance...');
        console.log(`📊 Validating ${Object.keys(mcqs).length} subjects`);
        
        const results = {
            subjects: {},
            summary: {
                totalQuestions: 0,
                validQuestions: 0,
                invalidQuestions: 0,
                warnings: 0,
                errors: 0,
                issues: []
            }
        };
        
        for (const [subject, accessLevels] of Object.entries(mcqs)) {
            console.log(`\n📖 Validating ${subject}...`);
            
            results.subjects[subject] = {
                total: 0,
                valid: 0,
                invalid: 0,
                warnings: 0,
                errors: 0,
                issues: []
            };
            
            for (const [accessLevel, questions] of Object.entries(accessLevels)) {
                console.log(`   ${accessLevel}: ${questions.length} questions`);
                
                for (let i = 0; i < questions.length; i++) {
                    const question = questions[i];
                    const issues = this.validateMCQ(question);
                    
                    results.subjects[subject].total++;
                    results.summary.totalQuestions++;
                    
                    if (issues.length === 0) {
                        results.subjects[subject].valid++;
                        results.summary.validQuestions++;
                    } else {
                        results.subjects[subject].invalid++;
                        results.summary.invalidQuestions++;
                        
                        // Count errors and warnings
                        const errorCount = issues.filter(issue => issue.type === 'ERROR').length;
                        const warningCount = issues.filter(issue => issue.type === 'WARNING').length;
                        
                        results.subjects[subject].errors += errorCount;
                        results.subjects[subject].warnings += warningCount;
                        results.summary.errors += errorCount;
                        results.summary.warnings += warningCount;
                        
                        // Add to issues list
                        results.subjects[subject].issues.push({
                            question_code: question.question_code,
                            index: i,
                            issues: issues
                        });
                        
                        results.summary.issues.push({
                            subject: subject,
                            access_level: accessLevel,
                            question_code: question.question_code,
                            index: i,
                            issues: issues
                        });
                    }
                }
            }
            
            console.log(`   ✅ Valid: ${results.subjects[subject].valid}`);
            console.log(`   ❌ Invalid: ${results.subjects[subject].invalid}`);
            console.log(`   ⚠️  Warnings: ${results.subjects[subject].warnings}`);
            console.log(`   🚫 Errors: ${results.subjects[subject].errors}`);
        }
        
        return results;
    }

    generateReport(results) {
        let report = '\n' + '='.repeat(80) + '\n';
        report += '                    CPALE MCQ QUALITY ASSURANCE REPORT\n';
        report += '='.repeat(80) + '\n\n';
        
        // Summary
        report += '📊 SUMMARY STATISTICS:\n';
        report += `   Total Questions: ${results.summary.totalQuestions}\n`;
        report += `   Valid Questions: ${results.summary.validQuestions} (${((results.summary.validQuestions / results.summary.totalQuestions) * 100).toFixed(1)}%)\n`;
        report += `   Invalid Questions: ${results.summary.invalidQuestions} (${((results.summary.invalidQuestions / results.summary.totalQuestions) * 100).toFixed(1)}%)\n`;
        report += `   Total Warnings: ${results.summary.warnings}\n`;
        report += `   Total Errors: ${results.summary.errors}\n\n`;
        
        // Subject breakdown
        report += '📚 SUBJECT BREAKDOWN:\n';
        for (const [subject, data] of Object.entries(results.subjects)) {
            const validityRate = ((data.valid / data.total) * 100).toFixed(1);
            report += `\n   ${subject}:\n`;
            report += `     Total: ${data.total}\n`;
            report += `     Valid: ${data.valid} (${validityRate}%)\n`;
            report += `     Invalid: ${data.invalid}\n`;
            report += `     Warnings: ${data.warnings}\n`;
            report += `     Errors: ${data.errors}\n`;
            
            if (data.issues.length > 0) {
                report += `     Issues: ${data.issues.length} questions have problems\n`;
            }
        }
        
        // Top issues
        if (results.summary.issues.length > 0) {
            report += '\n🚨 TOP ISSUES FOUND:\n';
            
            // Group issues by type and field
            const issueGroups = {};
            for (const issue of results.summary.issues) {
                for (const problem of issue.issues) {
                    const key = `${problem.type}: ${problem.field}`;
                    if (!issueGroups[key]) {
                        issueGroups[key] = {
                            type: problem.type,
                            field: problem.field,
                            count: 0,
                            examples: []
                        };
                    }
                    issueGroups[key].count++;
                    if (issueGroups[key].examples.length < 3) {
                        issueGroups[key].examples.push(issue.question_code);
                    }
                }
            }
            
            // Sort by count
            const sortedIssues = Object.values(issueGroups).sort((a, b) => b.count - a.count);
            
            for (const issue of sortedIssues.slice(0, 10)) {
                report += `   ${issue.type}: ${issue.field} (${issue.count} occurrences)\n`;
                report += `     Examples: ${issue.examples.join(', ')}\n`;
            }
        }
        
        // Recommendations
        report += '\n💡 RECOMMENDATIONS:\n';
        
        if (results.summary.errors > 0) {
            report += '   🚫 CRITICAL ISSUES TO FIX:\n';
            report += '     - Review question code formats\n';
            report += '     - Ensure exactly one correct answer per question\n';
            report += '     - Validate all required fields are present\n';
            report += '     - Check for duplicate choice texts\n\n';
        }
        
        if (results.summary.warnings > 0) {
            report += '   ⚠️  IMPROVEMENTS NEEDED:\n';
            report += '     - Enhance explanation quality and length\n';
            report += '     - Add more specific memory tips\n';
            report += '     - Include proper legal references\n';
            report += '     - Replace generic placeholder text\n\n';
        }
        
        const validityRate = (results.summary.validQuestions / results.summary.totalQuestions) * 100;
        if (validityRate >= 95) {
            report += '   ✅ EXCELLENT QUALITY: Ready for production!\n';
        } else if (validityRate >= 85) {
            report += '   ⚠️  GOOD QUALITY: Minor improvements needed\n';
        } else {
            report += '   🚨 POOR QUALITY: Significant improvements required\n';
        }
        
        report += '\n' + '='.repeat(80) + '\n';
        
        return report;
    }

    saveReport(report, filename) {
        const filePath = path.join(__dirname, '..', 'data', filename);
        fs.writeFileSync(filePath, report);
        console.log(`📄 Quality assurance report saved to: ${filename}`);
    }

    saveDetailedResults(results, filename) {
        const filePath = path.join(__dirname, '..', 'data', filename);
        fs.writeFileSync(filePath, JSON.stringify(results, null, 2));
        console.log(`📄 Detailed results saved to: ${filename}`);
    }
}

module.exports = MCQQualityAssurance;