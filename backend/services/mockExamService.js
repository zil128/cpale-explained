/**
 * Mock Exam Service
 * Handles mock exam generation, scoring, and results
 */

const pool = require('../db');

// Subject question distribution for comprehensive exams
const COMPREHENSIVE_DISTRIBUTION = {
  FAR: { count: 20, easy: 8, medium: 8, hard: 4 },
  AFAR: { count: 15, easy: 6, medium: 6, hard: 3 },
  AUD: { count: 15, easy: 6, medium: 6, hard: 3 },
  TAX: { count: 15, easy: 6, medium: 6, hard: 3 },
  MS: { count: 15, easy: 6, medium: 6, hard: 3 },
  RFBT: { count: 20, easy: 8, medium: 8, hard: 4 }
};

/**
 * Get list of available mock exams
 */
async function getExamList(userId) {
  const [exams] = await pool.query(`
    SELECT 
      e.exam_id,
      e.exam_code,
      e.exam_name,
      e.exam_description,
      e.exam_type,
      e.total_questions,
      e.time_limit_minutes,
      e.passing_score_percent,
      s.subject_code,
      s.subject_name
    FROM mock_preboard_exams e
    LEFT JOIN subjects s ON e.subject_id = s.subject_id
    WHERE e.is_active = TRUE
    ORDER BY e.exam_type DESC, e.exam_id
  `);

  // Get user's attempts for each exam
  const [attempts] = await pool.query(`
    SELECT 
      exam_id,
      COUNT(*) as attempt_count,
      MAX(score_percent) as best_score,
      MAX(CASE WHEN passed = 1 THEN 1 ELSE 0 END) as has_passed
    FROM user_mock_attempts
    WHERE user_id = ?
    GROUP BY exam_id
  `, [userId]);

  const attemptMap = {};
  attempts.forEach(a => {
    attemptMap[a.exam_id] = {
      attemptCount: a.attempt_count,
      bestScore: a.best_score,
      hasPassed: a.has_passed === 1
    };
  });

  return exams.map(exam => ({
    ...exam,
    userAttempts: attemptMap[exam.exam_id] || { attemptCount: 0, bestScore: null, hasPassed: false }
  }));
}

/**
 * Generate exam questions for a new attempt
 */
async function generateExamQuestions(examId, userId) {
  // Get exam details
  const [examRows] = await pool.query(`
    SELECT * FROM mock_preboard_exams WHERE exam_id = ? AND is_active = TRUE
  `, [examId]);

  if (examRows.length === 0) {
    throw new Error('Exam not found');
  }

  const exam = examRows[0];
  let questions = [];

  if (exam.exam_type === 'COMPREHENSIVE') {
    // Generate questions from all subjects
    questions = await generateComprehensiveQuestions(userId);
  } else {
    // Generate questions from single subject
    questions = await generateSubjectQuestions(exam.subject_id, exam.total_questions, userId);
  }

  // Shuffle final question order
  questions = shuffleArray(questions);

  return {
    exam,
    questions: questions.map((q, index) => ({
      questionId: q.question_id,
      order: index + 1
    }))
  };
}

/**
 * Generate questions for comprehensive exam (all subjects)
 */
async function generateComprehensiveQuestions(userId) {
  const allQuestions = [];

  for (const [subjectCode, dist] of Object.entries(COMPREHENSIVE_DISTRIBUTION)) {
    // Get subject ID
    const [subjects] = await pool.query(
      'SELECT subject_id FROM subjects WHERE subject_code = ?',
      [subjectCode]
    );
    
    if (subjects.length === 0) continue;
    const subjectId = subjects[0].subject_id;

    // Get recently used question IDs to avoid repetition
    const [recentQuestions] = await pool.query(`
      SELECT DISTINCT meq.question_id
      FROM mock_exam_questions meq
      JOIN user_mock_attempts uma ON meq.attempt_id = uma.attempt_id
      WHERE uma.user_id = ? AND uma.started_at > DATE_SUB(NOW(), INTERVAL 7 DAY)
    `, [userId]);
    
    const excludeIds = recentQuestions.map(r => r.question_id);
    const excludeClause = excludeIds.length > 0 
      ? `AND q.question_id NOT IN (${excludeIds.join(',')})` 
      : '';

    // Get questions by difficulty for this subject
    for (const difficulty of ['EASY', 'MEDIUM', 'HARD']) {
      const count = dist[difficulty.toLowerCase()];
      
      const [subjectQuestions] = await pool.query(`
        SELECT q.question_id
        FROM questions q
        JOIN topics t ON q.topic_id = t.topic_id
        WHERE t.subject_id = ?
          AND q.difficulty_level = ?
          AND q.is_active = TRUE
          ${excludeClause}
        ORDER BY RAND()
        LIMIT ?
      `, [subjectId, difficulty, count]);

      allQuestions.push(...subjectQuestions);
    }
  }

  return allQuestions;
}

/**
 * Generate questions for single subject exam
 */
async function generateSubjectQuestions(subjectId, totalQuestions, userId) {
  // Get recently used question IDs
  const [recentQuestions] = await pool.query(`
    SELECT DISTINCT meq.question_id
    FROM mock_exam_questions meq
    JOIN user_mock_attempts uma ON meq.attempt_id = uma.attempt_id
    WHERE uma.user_id = ? AND uma.started_at > DATE_SUB(NOW(), INTERVAL 7 DAY)
  `, [userId]);
  
  const excludeIds = recentQuestions.map(r => r.question_id);
  const excludeClause = excludeIds.length > 0 
    ? `AND q.question_id NOT IN (${excludeIds.join(',')})` 
    : '';

  // Distribution: 30% easy, 40% medium, 30% hard
  const easyCount = Math.floor(totalQuestions * 0.3);
  const mediumCount = Math.floor(totalQuestions * 0.4);
  const hardCount = totalQuestions - easyCount - mediumCount;

  const questions = [];

  for (const [difficulty, count] of [['EASY', easyCount], ['MEDIUM', mediumCount], ['HARD', hardCount]]) {
    const [diffQuestions] = await pool.query(`
      SELECT q.question_id
      FROM questions q
      JOIN topics t ON q.topic_id = t.topic_id
      WHERE t.subject_id = ?
        AND q.difficulty_level = ?
        AND q.is_active = TRUE
        ${excludeClause}
      ORDER BY RAND()
      LIMIT ?
    `, [subjectId, difficulty, count]);

    questions.push(...diffQuestions);
  }

  return questions;
}

/**
 * Start a new exam attempt
 */
async function startExam(examId, userId) {
  const { exam, questions } = await generateExamQuestions(examId, userId);

  // Create attempt record
  const [result] = await pool.query(`
    INSERT INTO user_mock_attempts 
      (user_id, exam_id, total_questions, status, answers)
    VALUES (?, ?, ?, 'IN_PROGRESS', '[]')
  `, [userId, examId, questions.length]);

  const attemptId = result.insertId;

  // Insert questions for this attempt
  for (const q of questions) {
    await pool.query(`
      INSERT INTO mock_exam_questions (attempt_id, question_id, question_order)
      VALUES (?, ?, ?)
    `, [attemptId, q.questionId, q.order]);
  }

  // Calculate expiration time
  const expiresAt = new Date(Date.now() + exam.time_limit_minutes * 60 * 1000);

  return {
    attemptId,
    examId: exam.exam_id,
    examName: exam.exam_name,
    totalQuestions: questions.length,
    timeLimitMinutes: exam.time_limit_minutes,
    passingScore: exam.passing_score_percent,
    startedAt: new Date(),
    expiresAt
  };
}

/**
 * Get questions for an in-progress exam
 */
async function getExamQuestions(attemptId, userId) {
  // Verify attempt belongs to user and is in progress
  const [attempts] = await pool.query(`
    SELECT uma.*, mpe.exam_name, mpe.time_limit_minutes, mpe.passing_score_percent
    FROM user_mock_attempts uma
    JOIN mock_preboard_exams mpe ON uma.exam_id = mpe.exam_id
    WHERE uma.attempt_id = ? AND uma.user_id = ?
  `, [attemptId, userId]);

  if (attempts.length === 0) {
    throw new Error('Attempt not found');
  }

  const attempt = attempts[0];
  
  if (attempt.status !== 'IN_PROGRESS') {
    throw new Error('Exam already completed');
  }

  // Check if time has expired
  const startedAt = new Date(attempt.started_at);
  const expiresAt = new Date(startedAt.getTime() + attempt.time_limit_minutes * 60 * 1000);
  
  if (new Date() > expiresAt) {
    // Auto-submit the exam
    await submitExam(attemptId, userId, [], true);
    throw new Error('Exam time has expired');
  }

  // Get questions with choices
  const [questionRows] = await pool.query(`
    SELECT 
      meq.question_order,
      meq.selected_choice_id,
      meq.is_marked,
      q.question_id,
      q.question_text,
      q.difficulty_level,
      t.topic_name,
      s.subject_code
    FROM mock_exam_questions meq
    JOIN questions q ON meq.question_id = q.question_id
    JOIN topics t ON q.topic_id = t.topic_id
    JOIN subjects s ON t.subject_id = s.subject_id
    WHERE meq.attempt_id = ?
    ORDER BY meq.question_order
  `, [attemptId]);

  // Get choices for each question
  const questions = [];
  for (const q of questionRows) {
    const [choices] = await pool.query(`
      SELECT choice_id, choice_text
      FROM question_choices
      WHERE question_id = ? AND is_active = TRUE
    `, [q.question_id]);

    // Shuffle choices
    const shuffledChoices = shuffleArray(choices).map((c, i) => ({
      choiceId: c.choice_id,
      choiceText: c.choice_text,
      label: String.fromCharCode(65 + i) // A, B, C, D
    }));

    questions.push({
      order: q.question_order,
      questionId: q.question_id,
      questionText: q.question_text,
      difficulty: q.difficulty_level,
      topic: q.topic_name,
      subject: q.subject_code,
      selectedChoiceId: q.selected_choice_id,
      isMarked: q.is_marked === 1,
      choices: shuffledChoices
    });
  }

  // Calculate time remaining
  const timeRemainingSeconds = Math.max(0, Math.floor((expiresAt - new Date()) / 1000));

  return {
    attemptId,
    examName: attempt.exam_name,
    totalQuestions: questions.length,
    timeLimitMinutes: attempt.time_limit_minutes,
    passingScore: attempt.passing_score_percent,
    startedAt,
    expiresAt,
    timeRemainingSeconds,
    questions
  };
}

/**
 * Save answer for a question (auto-save)
 */
async function saveAnswer(attemptId, userId, questionId, selectedChoiceId, timeSpent, isMarked) {
  // Verify attempt
  const [attempts] = await pool.query(`
    SELECT status FROM user_mock_attempts WHERE attempt_id = ? AND user_id = ?
  `, [attemptId, userId]);

  if (attempts.length === 0 || attempts[0].status !== 'IN_PROGRESS') {
    throw new Error('Cannot save answer - exam not in progress');
  }

  await pool.query(`
    UPDATE mock_exam_questions
    SET selected_choice_id = ?,
        time_spent_seconds = ?,
        is_marked = ?,
        answered_at = NOW()
    WHERE attempt_id = ? AND question_id = ?
  `, [selectedChoiceId, timeSpent || 0, isMarked ? 1 : 0, attemptId, questionId]);

  return { saved: true };
}

/**
 * Submit exam and calculate results
 */
async function submitExam(attemptId, userId, answers = [], isTimedOut = false) {
  // Get attempt
  const [attempts] = await pool.query(`
    SELECT uma.*, mpe.exam_name, mpe.passing_score_percent, mpe.exam_type
    FROM user_mock_attempts uma
    JOIN mock_preboard_exams mpe ON uma.exam_id = mpe.exam_id
    WHERE uma.attempt_id = ? AND uma.user_id = ?
  `, [attemptId, userId]);

  if (attempts.length === 0) {
    throw new Error('Attempt not found');
  }

  const attempt = attempts[0];

  if (attempt.status === 'COMPLETED') {
    throw new Error('Exam already submitted');
  }

  // Save any pending answers
  if (answers && answers.length > 0) {
    for (const answer of answers) {
      await saveAnswer(attemptId, userId, answer.questionId, answer.selectedChoiceId, answer.timeSpent, answer.isMarked);
    }
  }

  // Calculate results
  const [questions] = await pool.query(`
    SELECT 
      meq.*,
      qc.is_correct,
      q.difficulty_level,
      t.topic_name,
      s.subject_code
    FROM mock_exam_questions meq
    JOIN questions q ON meq.question_id = q.question_id
    JOIN topics t ON q.topic_id = t.topic_id
    JOIN subjects s ON t.subject_id = s.subject_id
    LEFT JOIN question_choices qc ON meq.selected_choice_id = qc.choice_id AND qc.question_id = meq.question_id
    WHERE meq.attempt_id = ?
  `, [attemptId]);

  let correct = 0;
  let wrong = 0;
  let unanswered = 0;
  let totalTime = 0;

  const subjectBreakdown = {};
  const difficultyBreakdown = { EASY: { total: 0, correct: 0 }, MEDIUM: { total: 0, correct: 0 }, HARD: { total: 0, correct: 0 } };

  for (const q of questions) {
    totalTime += q.time_spent_seconds || 0;
    
    // Update is_correct in mock_exam_questions
    const isCorrect = q.is_correct === 1;
    await pool.query(
      'UPDATE mock_exam_questions SET is_correct = ? WHERE id = ?',
      [q.selected_choice_id ? (isCorrect ? 1 : 0) : null, q.id]
    );

    if (!q.selected_choice_id) {
      unanswered++;
    } else if (isCorrect) {
      correct++;
    } else {
      wrong++;
    }

    // Subject breakdown
    if (!subjectBreakdown[q.subject_code]) {
      subjectBreakdown[q.subject_code] = { total: 0, correct: 0 };
    }
    subjectBreakdown[q.subject_code].total++;
    if (isCorrect) subjectBreakdown[q.subject_code].correct++;

    // Difficulty breakdown
    difficultyBreakdown[q.difficulty_level].total++;
    if (isCorrect) difficultyBreakdown[q.difficulty_level].correct++;
  }

  const totalQuestions = questions.length;
  const scorePercent = totalQuestions > 0 ? Math.round((correct / totalQuestions) * 100 * 100) / 100 : 0;
  const passed = scorePercent >= attempt.passing_score_percent;

  // Calculate accuracy for each breakdown
  Object.keys(subjectBreakdown).forEach(key => {
    subjectBreakdown[key].accuracy = subjectBreakdown[key].total > 0 
      ? Math.round((subjectBreakdown[key].correct / subjectBreakdown[key].total) * 100 * 100) / 100 
      : 0;
  });

  Object.keys(difficultyBreakdown).forEach(key => {
    difficultyBreakdown[key].accuracy = difficultyBreakdown[key].total > 0 
      ? Math.round((difficultyBreakdown[key].correct / difficultyBreakdown[key].total) * 100 * 100) / 100 
      : 0;
  });

  // Find weak subjects
  const weakSubjects = Object.entries(subjectBreakdown)
    .filter(([_, data]) => data.accuracy < 60)
    .sort((a, b) => a[1].accuracy - b[1].accuracy)
    .map(([code, data]) => ({ subjectCode: code, accuracy: data.accuracy }));

  // Update attempt record
  await pool.query(`
    UPDATE user_mock_attempts
    SET ended_at = NOW(),
        time_spent_seconds = ?,
        correct_answers = ?,
        wrong_answers = ?,
        unanswered = ?,
        score_percent = ?,
        passed = ?,
        status = ?,
        answers = ?
    WHERE attempt_id = ?
  `, [
    totalTime,
    correct,
    wrong,
    unanswered,
    scorePercent,
    passed ? 1 : 0,
    isTimedOut ? 'TIMED_OUT' : 'COMPLETED',
    JSON.stringify(answers),
    attemptId
  ]);

  // Insert detailed results
  await pool.query(`
    INSERT INTO mock_exam_results 
      (attempt_id, user_id, exam_id, total_questions, correct_answers, wrong_answers, unanswered,
       score_percent, passed, total_time_seconds, avg_time_per_question,
       subject_breakdown, difficulty_breakdown, weak_subjects, recommendations)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ON DUPLICATE KEY UPDATE
      correct_answers = VALUES(correct_answers),
      wrong_answers = VALUES(wrong_answers),
      score_percent = VALUES(score_percent),
      passed = VALUES(passed),
      subject_breakdown = VALUES(subject_breakdown),
      difficulty_breakdown = VALUES(difficulty_breakdown),
      weak_subjects = VALUES(weak_subjects)
  `, [
    attemptId,
    userId,
    attempt.exam_id,
    totalQuestions,
    correct,
    wrong,
    unanswered,
    scorePercent,
    passed ? 1 : 0,
    totalTime,
    totalQuestions > 0 ? Math.round(totalTime / totalQuestions) : 0,
    JSON.stringify(subjectBreakdown),
    JSON.stringify(difficultyBreakdown),
    JSON.stringify(weakSubjects),
    JSON.stringify(generateExamRecommendations(subjectBreakdown, difficultyBreakdown, scorePercent))
  ]);

  // Record answers for AI analytics
  try {
    const aiAnalytics = require('./aiAnalytics');
    for (const q of questions) {
      if (q.selected_choice_id) {
        await aiAnalytics.recordAnswer(
          userId,
          q.question_id,
          q.selected_choice_id,
          q.is_correct === 1,
          q.time_spent_seconds || 60,
          'MOCK_EXAM'
        );
      }
    }
  } catch (err) {
    console.error('Analytics recording error:', err.message);
  }

  return {
    attemptId,
    examName: attempt.exam_name,
    score: scorePercent,
    passed,
    passingScore: attempt.passing_score_percent,
    correct,
    wrong,
    unanswered,
    total: totalQuestions,
    timeSpent: totalTime,
    subjectBreakdown,
    difficultyBreakdown,
    weakSubjects
  };
}

/**
 * Get detailed exam results
 */
async function getExamResults(attemptId, userId) {
  // Get result summary
  const [results] = await pool.query(`
    SELECT 
      mer.*,
      mpe.exam_name,
      mpe.exam_type,
      mpe.passing_score_percent
    FROM mock_exam_results mer
    JOIN mock_preboard_exams mpe ON mer.exam_id = mpe.exam_id
    WHERE mer.attempt_id = ? AND mer.user_id = ?
  `, [attemptId, userId]);

  if (results.length === 0) {
    throw new Error('Results not found');
  }

  const result = results[0];

  // Get question-by-question review
  const [questions] = await pool.query(`
    SELECT 
      meq.question_order,
      meq.selected_choice_id,
      meq.is_correct,
      meq.time_spent_seconds,
      q.question_id,
      q.question_text,
      q.difficulty_level,
      t.topic_name,
      s.subject_code
    FROM mock_exam_questions meq
    JOIN questions q ON meq.question_id = q.question_id
    JOIN topics t ON q.topic_id = t.topic_id
    JOIN subjects s ON t.subject_id = s.subject_id
    WHERE meq.attempt_id = ?
    ORDER BY meq.question_order
  `, [attemptId]);

  // Get choices and explanations for each question
  const questionReview = [];
  for (const q of questions) {
    const [choices] = await pool.query(`
      SELECT choice_id, choice_text, is_correct, why_wrong
      FROM question_choices
      WHERE question_id = ? AND is_active = TRUE
    `, [q.question_id]);

    const [explanations] = await pool.query(`
      SELECT short_explanation, exam_explanation
      FROM question_explanations
      WHERE question_id = ?
    `, [q.question_id]);

    questionReview.push({
      order: q.question_order,
      questionId: q.question_id,
      questionText: q.question_text,
      difficulty: q.difficulty_level,
      topic: q.topic_name,
      subject: q.subject_code,
      selectedChoiceId: q.selected_choice_id,
      isCorrect: q.is_correct === 1,
      timeSpent: q.time_spent_seconds,
      choices: choices.map(c => ({
        choiceId: c.choice_id,
        choiceText: c.choice_text,
        isCorrect: c.is_correct === 1,
        whyWrong: c.why_wrong,
        isSelected: c.choice_id === q.selected_choice_id
      })),
      explanation: explanations[0] || null
    });
  }

  // Get user's historical performance on this exam
  const [history] = await pool.query(`
    SELECT 
      attempt_id,
      score_percent,
      passed,
      started_at
    FROM user_mock_attempts
    WHERE user_id = ? AND exam_id = ? AND status IN ('COMPLETED', 'TIMED_OUT')
    ORDER BY started_at DESC
    LIMIT 10
  `, [userId, result.exam_id]);

  return {
    attemptId,
    examName: result.exam_name,
    examType: result.exam_type,
    
    // Score summary
    score: result.score_percent,
    passed: result.passed === 1,
    passingScore: result.passing_score_percent,
    
    // Counts
    totalQuestions: result.total_questions,
    correct: result.correct_answers,
    wrong: result.wrong_answers,
    unanswered: result.unanswered,
    
    // Time
    timeSpent: result.total_time_seconds,
    avgTimePerQuestion: result.avg_time_per_question,
    
    // Breakdowns (handle both string and parsed object)
    subjectBreakdown: typeof result.subject_breakdown === 'string' 
      ? JSON.parse(result.subject_breakdown || '{}') 
      : (result.subject_breakdown || {}),
    difficultyBreakdown: typeof result.difficulty_breakdown === 'string' 
      ? JSON.parse(result.difficulty_breakdown || '{}') 
      : (result.difficulty_breakdown || {}),
    
    // Recommendations (handle both string and parsed object)
    weakSubjects: typeof result.weak_subjects === 'string' 
      ? JSON.parse(result.weak_subjects || '[]') 
      : (result.weak_subjects || []),
    recommendations: typeof result.recommendations === 'string' 
      ? JSON.parse(result.recommendations || '[]') 
      : (result.recommendations || []),
    
    // Question review
    questions: questionReview,
    
    // History
    history: history.map(h => ({
      attemptId: h.attempt_id,
      score: h.score_percent,
      passed: h.passed === 1,
      date: h.started_at
    })),
    
    // Metadata
    completedAt: result.created_at
  };
}

/**
 * Resume an in-progress exam
 */
async function resumeExam(attemptId, userId) {
  const [attempts] = await pool.query(`
    SELECT uma.*, mpe.time_limit_minutes
    FROM user_mock_attempts uma
    JOIN mock_preboard_exams mpe ON uma.exam_id = mpe.exam_id
    WHERE uma.attempt_id = ? AND uma.user_id = ? AND uma.status = 'IN_PROGRESS'
  `, [attemptId, userId]);

  if (attempts.length === 0) {
    throw new Error('No in-progress exam found');
  }

  const attempt = attempts[0];
  const startedAt = new Date(attempt.started_at);
  const expiresAt = new Date(startedAt.getTime() + attempt.time_limit_minutes * 60 * 1000);

  // Check if expired
  if (new Date() > expiresAt) {
    await submitExam(attemptId, userId, [], true);
    throw new Error('Exam time has expired');
  }

  return getExamQuestions(attemptId, userId);
}

/**
 * Generate recommendations based on exam results
 */
function generateExamRecommendations(subjectBreakdown, difficultyBreakdown, overallScore) {
  const recommendations = [];

  // Weak subjects
  const weakSubjects = Object.entries(subjectBreakdown)
    .filter(([_, data]) => data.accuracy < 60)
    .sort((a, b) => a[1].accuracy - b[1].accuracy);

  if (weakSubjects.length > 0) {
    recommendations.push({
      type: 'weak_subjects',
      title: 'Focus on Weak Subjects',
      description: `Review these subjects: ${weakSubjects.map(([s]) => s).join(', ')}`,
      subjects: weakSubjects.map(([code, data]) => ({ code, accuracy: data.accuracy }))
    });
  }

  // Difficulty analysis
  if (difficultyBreakdown.EASY?.accuracy < 80) {
    recommendations.push({
      type: 'fundamentals',
      title: 'Strengthen Fundamentals',
      description: `Your EASY question accuracy is ${difficultyBreakdown.EASY.accuracy}%. Review basic concepts.`
    });
  }

  if (difficultyBreakdown.HARD?.accuracy < 40) {
    recommendations.push({
      type: 'advanced',
      title: 'Practice Advanced Topics',
      description: `Focus on challenging topics to improve HARD question performance.`
    });
  }

  // Overall score recommendations
  if (overallScore < 50) {
    recommendations.push({
      type: 'comprehensive_review',
      title: 'Comprehensive Review Needed',
      description: 'Consider going through all subjects systematically before retaking the exam.'
    });
  } else if (overallScore < 75) {
    recommendations.push({
      type: 'targeted_practice',
      title: 'Targeted Practice',
      description: 'Focus on your weak areas to reach the passing score of 75%.'
    });
  } else {
    recommendations.push({
      type: 'maintain',
      title: 'Great Performance!',
      description: 'Continue practicing to maintain your knowledge.'
    });
  }

  return recommendations;
}

/**
 * Shuffle array (Fisher-Yates)
 */
function shuffleArray(array) {
  const shuffled = [...array];
  for (let i = shuffled.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]];
  }
  return shuffled;
}

/**
 * Check if user has in-progress exam
 */
async function getInProgressExam(userId) {
  const [attempts] = await pool.query(`
    SELECT uma.attempt_id, uma.exam_id, mpe.exam_name, uma.started_at, mpe.time_limit_minutes
    FROM user_mock_attempts uma
    JOIN mock_preboard_exams mpe ON uma.exam_id = mpe.exam_id
    WHERE uma.user_id = ? AND uma.status = 'IN_PROGRESS'
    ORDER BY uma.started_at DESC
    LIMIT 1
  `, [userId]);

  if (attempts.length === 0) return null;

  const attempt = attempts[0];
  const startedAt = new Date(attempt.started_at);
  const expiresAt = new Date(startedAt.getTime() + attempt.time_limit_minutes * 60 * 1000);

  // Auto-submit if expired
  if (new Date() > expiresAt) {
    await submitExam(attempt.attempt_id, userId, [], true);
    return null;
  }

  return {
    attemptId: attempt.attempt_id,
    examId: attempt.exam_id,
    examName: attempt.exam_name,
    startedAt,
    expiresAt,
    timeRemainingSeconds: Math.floor((expiresAt - new Date()) / 1000)
  };
}

module.exports = {
  getExamList,
  startExam,
  getExamQuestions,
  saveAnswer,
  submitExam,
  getExamResults,
  resumeExam,
  getInProgressExam
};
