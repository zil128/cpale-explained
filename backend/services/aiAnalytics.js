/**
 * AI Analytics Service
 * Provides intelligent analysis of user performance and recommendations
 */

const pool = require('../db');

// Exam weight factors for CPALE subjects (based on typical exam coverage)
const EXAM_WEIGHTS = {
  FAR: 1.2,   // Financial Accounting - heavily weighted
  AFAR: 1.1,  // Advanced Financial Accounting
  AUD: 1.0,   // Auditing
  TAX: 1.1,   // Taxation - frequently tested
  MS: 0.9,    // Management Services
  RFBT: 1.0   // Regulatory Framework
};

// Difficulty weights for weakness calculation
const DIFFICULTY_WEIGHTS = {
  EASY: 0.5,
  MEDIUM: 1.0,
  HARD: 1.5
};

/**
 * Analyze user's overall performance and update learning patterns
 * @param {number} userId 
 * @returns {Object} Complete analysis results
 */
async function analyzeUserPerformance(userId) {
  try {
    // Get topic performance summary
    const [topicPerformance] = await pool.query(`
      SELECT 
        tps.*,
        t.topic_name,
        s.subject_code,
        s.subject_name
      FROM topic_performance_summary tps
      JOIN topics t ON tps.topic_id = t.topic_id
      JOIN subjects s ON t.subject_id = s.subject_id
      WHERE tps.user_id = ?
      ORDER BY tps.accuracy_percent ASC
    `, [userId]);

    if (topicPerformance.length === 0) {
      return {
        hasData: false,
        message: 'No performance data available yet. Start practicing to see your analytics!'
      };
    }

    // Calculate overall metrics
    const overallMetrics = calculateOverallMetrics(topicPerformance);
    
    // Identify weak points
    const weakPoints = identifyWeakPoints(topicPerformance);
    
    // Calculate accuracy by difficulty
    const difficultyBreakdown = calculateDifficultyBreakdown(topicPerformance);
    
    // Calculate subject scores
    const subjectScores = calculateSubjectScores(topicPerformance);
    
    // Generate AI recommendations
    const recommendations = generateRecommendations(weakPoints, overallMetrics, subjectScores);
    
    // Calculate exam readiness
    const examReadiness = calculateExamReadiness(overallMetrics, subjectScores, weakPoints);
    
    // Generate study plan
    const studyPlan = generateStudyPlan(weakPoints, subjectScores);

    // Update user_learning_patterns table
    await updateLearningPatterns(userId, {
      overallMetrics,
      difficultyBreakdown,
      weakPoints,
      subjectScores,
      recommendations,
      examReadiness,
      studyPlan
    });

    return {
      hasData: true,
      overallMetrics,
      difficultyBreakdown,
      weakPoints,
      subjectScores,
      recommendations,
      examReadiness,
      studyPlan,
      lastAnalyzedAt: new Date()
    };
  } catch (error) {
    console.error('Error analyzing user performance:', error);
    throw error;
  }
}

/**
 * Calculate overall performance metrics
 */
function calculateOverallMetrics(topicPerformance) {
  const totals = topicPerformance.reduce((acc, topic) => {
    acc.attempted += topic.total_attempted;
    acc.correct += topic.total_correct;
    acc.totalTime += topic.total_time_seconds || 0;
    acc.easyAttempted += topic.easy_attempted;
    acc.easyCorrect += topic.easy_correct;
    acc.mediumAttempted += topic.medium_attempted;
    acc.mediumCorrect += topic.medium_correct;
    acc.hardAttempted += topic.hard_attempted;
    acc.hardCorrect += topic.hard_correct;
    return acc;
  }, {
    attempted: 0, correct: 0, totalTime: 0,
    easyAttempted: 0, easyCorrect: 0,
    mediumAttempted: 0, mediumCorrect: 0,
    hardAttempted: 0, hardCorrect: 0
  });

  return {
    totalQuestionsAttempted: totals.attempted,
    totalCorrect: totals.correct,
    overallAccuracy: totals.attempted > 0 
      ? Math.round((totals.correct / totals.attempted) * 100 * 100) / 100 
      : 0,
    avgTimePerQuestion: totals.attempted > 0 
      ? Math.round(totals.totalTime / totals.attempted) 
      : 0,
    topicsAttempted: topicPerformance.length,
    totalStudyTimeMinutes: Math.round(totals.totalTime / 60)
  };
}

/**
 * Calculate accuracy breakdown by difficulty level
 */
function calculateDifficultyBreakdown(topicPerformance) {
  const totals = topicPerformance.reduce((acc, topic) => {
    acc.easyAttempted += topic.easy_attempted;
    acc.easyCorrect += topic.easy_correct;
    acc.mediumAttempted += topic.medium_attempted;
    acc.mediumCorrect += topic.medium_correct;
    acc.hardAttempted += topic.hard_attempted;
    acc.hardCorrect += topic.hard_correct;
    return acc;
  }, {
    easyAttempted: 0, easyCorrect: 0,
    mediumAttempted: 0, mediumCorrect: 0,
    hardAttempted: 0, hardCorrect: 0
  });

  return {
    easy: {
      attempted: totals.easyAttempted,
      correct: totals.easyCorrect,
      accuracy: totals.easyAttempted > 0 
        ? Math.round((totals.easyCorrect / totals.easyAttempted) * 100 * 100) / 100 
        : 0
    },
    medium: {
      attempted: totals.mediumAttempted,
      correct: totals.mediumCorrect,
      accuracy: totals.mediumAttempted > 0 
        ? Math.round((totals.mediumCorrect / totals.mediumAttempted) * 100 * 100) / 100 
        : 0
    },
    hard: {
      attempted: totals.hardAttempted,
      correct: totals.hardCorrect,
      accuracy: totals.hardAttempted > 0 
        ? Math.round((totals.hardCorrect / totals.hardAttempted) * 100 * 100) / 100 
        : 0
    }
  };
}

/**
 * Identify weak points categorized by severity
 */
function identifyWeakPoints(topicPerformance) {
  const critical = [];      // < 40% accuracy
  const needsAttention = []; // 40-60% accuracy
  const mastered = [];      // > 80% accuracy

  topicPerformance.forEach(topic => {
    const topicData = {
      topicId: topic.topic_id,
      topicName: topic.topic_name,
      subjectCode: topic.subject_code,
      subjectName: topic.subject_name,
      accuracy: topic.accuracy_percent,
      attempted: topic.total_attempted,
      correct: topic.total_correct,
      avgTime: topic.avg_time_seconds,
      lastAttempted: topic.last_attempted_at,
      weaknessScore: calculateWeaknessScore(topic)
    };

    if (topic.accuracy_percent < 40) {
      critical.push(topicData);
    } else if (topic.accuracy_percent < 60) {
      needsAttention.push(topicData);
    } else if (topic.accuracy_percent >= 80) {
      mastered.push(topicData);
    }
  });

  // Sort by weakness score (higher = more urgent)
  critical.sort((a, b) => b.weaknessScore - a.weaknessScore);
  needsAttention.sort((a, b) => b.weaknessScore - a.weaknessScore);

  return {
    critical: critical.slice(0, 10),  // Top 10 critical topics
    needsAttention: needsAttention.slice(0, 10),
    mastered: mastered.slice(0, 10),
    summary: {
      criticalCount: critical.length,
      needsAttentionCount: needsAttention.length,
      masteredCount: mastered.length,
      totalTopicsAttempted: topicPerformance.length
    }
  };
}

/**
 * Calculate weakness score for prioritization
 * Formula: (wrong_rate) × difficulty_weight × exam_weight × recency_factor
 */
function calculateWeaknessScore(topic) {
  const wrongRate = topic.total_attempted > 0 
    ? (topic.total_attempted - topic.total_correct) / topic.total_attempted 
    : 0;
  
  // Calculate weighted difficulty based on attempts
  const totalDiffAttempts = topic.easy_attempted + topic.medium_attempted + topic.hard_attempted;
  let avgDifficultyWeight = 1.0;
  if (totalDiffAttempts > 0) {
    avgDifficultyWeight = (
      (topic.easy_attempted * DIFFICULTY_WEIGHTS.EASY) +
      (topic.medium_attempted * DIFFICULTY_WEIGHTS.MEDIUM) +
      (topic.hard_attempted * DIFFICULTY_WEIGHTS.HARD)
    ) / totalDiffAttempts;
  }

  const examWeight = EXAM_WEIGHTS[topic.subject_code] || 1.0;
  
  // Recency factor: more recent attempts are weighted higher
  let recencyFactor = 1.0;
  if (topic.last_attempted_at) {
    const daysSinceAttempt = Math.floor((Date.now() - new Date(topic.last_attempted_at)) / (1000 * 60 * 60 * 24));
    recencyFactor = daysSinceAttempt < 7 ? 1.2 : (daysSinceAttempt < 30 ? 1.0 : 0.8);
  }

  return Math.round(wrongRate * avgDifficultyWeight * examWeight * recencyFactor * 100);
}

/**
 * Calculate subject-level scores
 */
function calculateSubjectScores(topicPerformance) {
  const subjectStats = {};
  
  topicPerformance.forEach(topic => {
    if (!subjectStats[topic.subject_code]) {
      subjectStats[topic.subject_code] = {
        subjectCode: topic.subject_code,
        subjectName: topic.subject_name,
        attempted: 0,
        correct: 0,
        topicsAttempted: 0,
        totalTime: 0
      };
    }
    
    subjectStats[topic.subject_code].attempted += topic.total_attempted;
    subjectStats[topic.subject_code].correct += topic.total_correct;
    subjectStats[topic.subject_code].topicsAttempted++;
    subjectStats[topic.subject_code].totalTime += topic.total_time_seconds || 0;
  });

  const subjects = Object.values(subjectStats).map(subject => ({
    ...subject,
    accuracy: subject.attempted > 0 
      ? Math.round((subject.correct / subject.attempted) * 100 * 100) / 100 
      : 0,
    avgTimePerQuestion: subject.attempted > 0 
      ? Math.round(subject.totalTime / subject.attempted) 
      : 0,
    status: getSubjectStatus(subject.attempted > 0 ? (subject.correct / subject.attempted) * 100 : 0)
  }));

  // Sort by accuracy (lowest first for improvement focus)
  subjects.sort((a, b) => a.accuracy - b.accuracy);

  return subjects;
}

function getSubjectStatus(accuracy) {
  if (accuracy >= 80) return 'mastered';
  if (accuracy >= 60) return 'good';
  if (accuracy >= 40) return 'needs_attention';
  return 'critical';
}

/**
 * Generate AI-powered recommendations
 */
function generateRecommendations(weakPoints, overallMetrics, subjectScores) {
  const recommendations = [];
  
  // Priority 1: Critical topics
  if (weakPoints.critical.length > 0) {
    const topCritical = weakPoints.critical.slice(0, 3);
    recommendations.push({
      priority: 1,
      type: 'critical_topics',
      title: 'Focus on Critical Topics',
      description: `You have ${weakPoints.summary.criticalCount} topics below 40% accuracy. Prioritize these:`,
      topics: topCritical.map(t => ({
        name: t.topicName,
        subject: t.subjectCode,
        accuracy: t.accuracy
      })),
      actionText: 'Practice these topics now'
    });
  }

  // Priority 2: Subject-level focus
  const weakSubjects = subjectScores.filter(s => s.accuracy < 60);
  if (weakSubjects.length > 0) {
    recommendations.push({
      priority: 2,
      type: 'weak_subjects',
      title: 'Strengthen Weak Subjects',
      description: `These subjects need more attention:`,
      subjects: weakSubjects.map(s => ({
        name: s.subjectName,
        code: s.subjectCode,
        accuracy: s.accuracy
      })),
      actionText: 'Review subject materials'
    });
  }

  // Priority 3: Difficulty progression
  const diffBreakdown = calculateDifficultyBreakdown(weakPoints.critical.concat(weakPoints.needsAttention));
  if (diffBreakdown.easy.accuracy < 70) {
    recommendations.push({
      priority: 3,
      type: 'difficulty_progression',
      title: 'Master Easy Questions First',
      description: `Your accuracy on EASY questions is ${diffBreakdown.easy.accuracy}%. Focus on fundamentals before moving to harder questions.`,
      actionText: 'Practice easy questions'
    });
  }

  // Priority 4: Study time recommendation
  if (overallMetrics.totalQuestionsAttempted < 100) {
    recommendations.push({
      priority: 4,
      type: 'increase_practice',
      title: 'Increase Practice Volume',
      description: `You've attempted ${overallMetrics.totalQuestionsAttempted} questions. Aim for at least 500 questions for comprehensive preparation.`,
      targetQuestions: 500,
      currentQuestions: overallMetrics.totalQuestionsAttempted,
      actionText: 'Continue practicing'
    });
  }

  // Priority 5: Time management
  if (overallMetrics.avgTimePerQuestion > 120) {
    recommendations.push({
      priority: 5,
      type: 'time_management',
      title: 'Improve Time Management',
      description: `Your average time per question is ${Math.round(overallMetrics.avgTimePerQuestion / 60)} minutes. Aim for 1-2 minutes per question for exam readiness.`,
      currentAvg: overallMetrics.avgTimePerQuestion,
      targetAvg: 90,
      actionText: 'Practice timed quizzes'
    });
  }

  // Priority 6: Maintain mastery
  if (weakPoints.mastered.length > 0) {
    recommendations.push({
      priority: 6,
      type: 'maintain_mastery',
      title: 'Maintain Your Strengths',
      description: `Great job! You've mastered ${weakPoints.summary.masteredCount} topics. Do periodic reviews to maintain.`,
      masteredTopics: weakPoints.mastered.slice(0, 5).map(t => t.topicName),
      actionText: 'Review mastered topics'
    });
  }

  return recommendations;
}

/**
 * Calculate exam readiness score and prediction
 */
function calculateExamReadiness(overallMetrics, subjectScores, weakPoints) {
  // Base score from overall accuracy (40% weight)
  let readinessScore = overallMetrics.overallAccuracy * 0.4;

  // Subject coverage score (30% weight)
  const avgSubjectScore = subjectScores.length > 0
    ? subjectScores.reduce((sum, s) => sum + s.accuracy, 0) / subjectScores.length
    : 0;
  readinessScore += avgSubjectScore * 0.3;

  // Low critical topics bonus (20% weight)
  const criticalPenalty = Math.min(weakPoints.summary.criticalCount * 2, 20);
  readinessScore += (20 - criticalPenalty);

  // Practice volume bonus (10% weight)
  const volumeBonus = Math.min(overallMetrics.totalQuestionsAttempted / 50, 10);
  readinessScore += volumeBonus;

  readinessScore = Math.round(Math.min(Math.max(readinessScore, 0), 100) * 100) / 100;

  // Predicted exam score (slightly conservative)
  const predictedScore = Math.round(readinessScore * 0.9 * 100) / 100;

  // Estimate days to ready (target: 75% readiness)
  let daysToReady = 0;
  if (readinessScore < 75) {
    const gap = 75 - readinessScore;
    daysToReady = Math.ceil(gap * 2); // Roughly 2 days per percentage point
  }

  // Determine status
  let status, statusColor;
  if (readinessScore >= 80) {
    status = 'Ready';
    statusColor = 'green';
  } else if (readinessScore >= 60) {
    status = 'Almost Ready';
    statusColor = 'yellow';
  } else if (readinessScore >= 40) {
    status = 'Need More Practice';
    statusColor = 'orange';
  } else {
    status = 'Not Ready';
    statusColor = 'red';
  }

  return {
    readinessScore,
    predictedScore,
    passingScore: 75,
    status,
    statusColor,
    daysToReady,
    subjectReadiness: subjectScores.map(s => ({
      subject: s.subjectCode,
      score: s.accuracy,
      isReady: s.accuracy >= 75
    }))
  };
}

/**
 * Generate personalized study plan
 */
function generateStudyPlan(weakPoints, subjectScores) {
  const studyPlan = [];
  const totalWeeklyHours = 20; // Assume 20 hours/week study time
  
  // Distribute hours based on weakness
  const weakSubjects = subjectScores.filter(s => s.accuracy < 75);
  const totalDeficit = weakSubjects.reduce((sum, s) => sum + (75 - s.accuracy), 0);

  weakSubjects.forEach(subject => {
    const deficit = 75 - subject.accuracy;
    const proportionalHours = totalDeficit > 0 
      ? Math.round((deficit / totalDeficit) * totalWeeklyHours * 10) / 10
      : 0;
    
    if (proportionalHours > 0) {
      studyPlan.push({
        subjectCode: subject.subjectCode,
        subjectName: subject.subjectName,
        currentAccuracy: subject.accuracy,
        targetAccuracy: 75,
        weeklyHours: Math.max(proportionalHours, 1), // Minimum 1 hour
        priorityTopics: weakPoints.critical
          .filter(t => t.subjectCode === subject.subjectCode)
          .slice(0, 3)
          .map(t => t.topicName),
        focusAreas: getSubjectFocusAreas(subject.subjectCode)
      });
    }
  });

  // Sort by priority (lowest accuracy first)
  studyPlan.sort((a, b) => a.currentAccuracy - b.currentAccuracy);

  return {
    weeklyHours: totalWeeklyHours,
    subjects: studyPlan,
    tips: [
      'Focus on understanding concepts, not just memorizing answers',
      'Review explanations for incorrect answers',
      'Take practice quizzes daily for consistency',
      'Schedule mock exams weekly to track progress'
    ]
  };
}

function getSubjectFocusAreas(subjectCode) {
  const focusAreas = {
    FAR: ['Conceptual Framework', 'Financial Statements', 'Assets & Liabilities'],
    AFAR: ['Business Combinations', 'Consolidated Statements', 'Revenue Recognition'],
    AUD: ['Audit Risk', 'Internal Control', 'Audit Reports'],
    TAX: ['Income Tax', 'VAT', 'Estate & Donor\'s Tax'],
    MS: ['Cost Accounting', 'Capital Budgeting', 'Financial Analysis'],
    RFBT: ['Corporation Law', 'Contracts', 'Banking Laws']
  };
  return focusAreas[subjectCode] || ['Core Concepts'];
}

/**
 * Update learning patterns in database
 */
async function updateLearningPatterns(userId, analysis) {
  const {
    overallMetrics,
    difficultyBreakdown,
    weakPoints,
    subjectScores,
    recommendations,
    examReadiness,
    studyPlan
  } = analysis;

  await pool.query(`
    INSERT INTO user_learning_patterns (
      user_id,
      easy_accuracy, medium_accuracy, hard_accuracy, overall_accuracy,
      avg_time_per_question, avg_time_easy, avg_time_medium, avg_time_hard,
      total_questions_attempted, total_correct,
      weakest_topics, critical_topics, needs_attention_topics, mastered_topics,
      ai_recommendations, study_plan, practice_set_suggestions,
      exam_readiness_score, predicted_exam_score, estimated_days_to_ready,
      subject_scores, last_analyzed_at
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())
    ON DUPLICATE KEY UPDATE
      easy_accuracy = VALUES(easy_accuracy),
      medium_accuracy = VALUES(medium_accuracy),
      hard_accuracy = VALUES(hard_accuracy),
      overall_accuracy = VALUES(overall_accuracy),
      avg_time_per_question = VALUES(avg_time_per_question),
      avg_time_easy = VALUES(avg_time_easy),
      avg_time_medium = VALUES(avg_time_medium),
      avg_time_hard = VALUES(avg_time_hard),
      total_questions_attempted = VALUES(total_questions_attempted),
      total_correct = VALUES(total_correct),
      weakest_topics = VALUES(weakest_topics),
      critical_topics = VALUES(critical_topics),
      needs_attention_topics = VALUES(needs_attention_topics),
      mastered_topics = VALUES(mastered_topics),
      ai_recommendations = VALUES(ai_recommendations),
      study_plan = VALUES(study_plan),
      practice_set_suggestions = VALUES(practice_set_suggestions),
      exam_readiness_score = VALUES(exam_readiness_score),
      predicted_exam_score = VALUES(predicted_exam_score),
      estimated_days_to_ready = VALUES(estimated_days_to_ready),
      subject_scores = VALUES(subject_scores),
      last_analyzed_at = NOW()
  `, [
    userId,
    difficultyBreakdown.easy.accuracy,
    difficultyBreakdown.medium.accuracy,
    difficultyBreakdown.hard.accuracy,
    overallMetrics.overallAccuracy,
    overallMetrics.avgTimePerQuestion,
    0, 0, 0, // Individual time metrics can be calculated if needed
    overallMetrics.totalQuestionsAttempted,
    overallMetrics.totalCorrect,
    JSON.stringify(weakPoints.critical.slice(0, 5)),
    JSON.stringify(weakPoints.critical),
    JSON.stringify(weakPoints.needsAttention),
    JSON.stringify(weakPoints.mastered),
    JSON.stringify(recommendations),
    JSON.stringify(studyPlan),
    JSON.stringify([]), // Practice set suggestions
    examReadiness.readinessScore,
    examReadiness.predictedScore,
    examReadiness.daysToReady,
    JSON.stringify(subjectScores)
  ]);
}

/**
 * Get cached learning patterns (fast endpoint)
 */
async function getLearningPatterns(userId) {
  const [patterns] = await pool.query(`
    SELECT * FROM user_learning_patterns WHERE user_id = ?
  `, [userId]);

  if (patterns.length === 0) {
    return null;
  }

  const pattern = patterns[0];
  
  // Parse JSON fields
  return {
    overallAccuracy: pattern.overall_accuracy,
    difficultyBreakdown: {
      easy: { accuracy: pattern.easy_accuracy },
      medium: { accuracy: pattern.medium_accuracy },
      hard: { accuracy: pattern.hard_accuracy }
    },
    totalQuestionsAttempted: pattern.total_questions_attempted,
    totalCorrect: pattern.total_correct,
    avgTimePerQuestion: pattern.avg_time_per_question,
    examReadiness: {
      readinessScore: pattern.exam_readiness_score,
      predictedScore: pattern.predicted_exam_score,
      daysToReady: pattern.estimated_days_to_ready
    },
    weakPoints: {
      critical: safeJsonParse(pattern.critical_topics, []),
      needsAttention: safeJsonParse(pattern.needs_attention_topics, []),
      mastered: safeJsonParse(pattern.mastered_topics, [])
    },
    subjectScores: safeJsonParse(pattern.subject_scores, []),
    recommendations: safeJsonParse(pattern.ai_recommendations, []),
    studyPlan: safeJsonParse(pattern.study_plan, {}),
    lastAnalyzedAt: pattern.last_analyzed_at
  };
}

function safeJsonParse(jsonString, defaultValue) {
  try {
    return jsonString ? JSON.parse(jsonString) : defaultValue;
  } catch (e) {
    return defaultValue;
  }
}

/**
 * Record a single answer for analytics tracking
 */
async function recordAnswer(userId, questionId, selectedChoiceId, isCorrect, timeSpentSeconds, context = 'PRACTICE') {
  try {
    // Get current attempt number for this question
    const [existing] = await pool.query(`
      SELECT MAX(attempt_number) as max_attempt 
      FROM user_answer_history 
      WHERE user_id = ? AND question_id = ?
    `, [userId, questionId]);
    
    const attemptNumber = (existing[0]?.max_attempt || 0) + 1;

    // Insert answer history
    await pool.query(`
      INSERT INTO user_answer_history 
        (user_id, question_id, attempt_number, selected_choice_id, is_correct, time_spent_seconds, context)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    `, [userId, questionId, attemptNumber, selectedChoiceId, isCorrect ? 1 : 0, timeSpentSeconds, context]);

    // Update topic performance summary
    const [questionInfo] = await pool.query(`
      SELECT q.topic_id, t.subject_id, q.difficulty_level
      FROM questions q
      JOIN topics t ON q.topic_id = t.topic_id
      WHERE q.question_id = ?
    `, [questionId]);

    if (questionInfo.length > 0) {
      const { topic_id, subject_id, difficulty_level } = questionInfo[0];
      await updateTopicPerformance(userId, topic_id, subject_id, difficulty_level, isCorrect, timeSpentSeconds);
    }

    return { success: true, attemptNumber };
  } catch (error) {
    console.error('Error recording answer:', error);
    throw error;
  }
}

/**
 * Update topic performance summary incrementally
 */
async function updateTopicPerformance(userId, topicId, subjectId, difficulty, isCorrect, timeSpent) {
  const difficultyColumn = difficulty.toLowerCase();
  
  await pool.query(`
    INSERT INTO topic_performance_summary (
      user_id, topic_id, subject_id,
      total_attempted, total_correct, accuracy_percent,
      ${difficultyColumn}_attempted, ${difficultyColumn}_correct,
      total_time_seconds, avg_time_seconds, last_attempted_at
    ) VALUES (
      ?, ?, ?,
      1, ?, ?,
      1, ?,
      ?, ?, NOW()
    )
    ON DUPLICATE KEY UPDATE
      total_attempted = total_attempted + 1,
      total_correct = total_correct + ?,
      accuracy_percent = ROUND((total_correct + ?) / (total_attempted + 1) * 100, 2),
      ${difficultyColumn}_attempted = ${difficultyColumn}_attempted + 1,
      ${difficultyColumn}_correct = ${difficultyColumn}_correct + ?,
      total_time_seconds = total_time_seconds + ?,
      avg_time_seconds = ROUND((total_time_seconds + ?) / (total_attempted + 1)),
      last_attempted_at = NOW()
  `, [
    userId, topicId, subjectId,
    isCorrect ? 1 : 0, isCorrect ? 100 : 0,
    isCorrect ? 1 : 0,
    timeSpent, timeSpent,
    isCorrect ? 1 : 0, isCorrect ? 1 : 0,
    isCorrect ? 1 : 0,
    timeSpent, timeSpent
  ]);
}

/**
 * Get performance trend over time
 */
async function getPerformanceTrend(userId, days = 30) {
  const [dailyStats] = await pool.query(`
    SELECT 
      DATE(answered_at) as date,
      COUNT(*) as attempted,
      SUM(is_correct) as correct,
      ROUND(SUM(is_correct) / COUNT(*) * 100, 2) as accuracy
    FROM user_answer_history
    WHERE user_id = ? AND answered_at >= DATE_SUB(NOW(), INTERVAL ? DAY)
    GROUP BY DATE(answered_at)
    ORDER BY date ASC
  `, [userId, days]);

  return dailyStats;
}

/**
 * Get subject breakdown for charts
 */
async function getSubjectBreakdown(userId) {
  const [breakdown] = await pool.query(`
    SELECT 
      s.subject_code,
      s.subject_name,
      COUNT(DISTINCT tps.topic_id) as topics_attempted,
      SUM(tps.total_attempted) as questions_attempted,
      SUM(tps.total_correct) as questions_correct,
      ROUND(SUM(tps.total_correct) / SUM(tps.total_attempted) * 100, 2) as accuracy
    FROM topic_performance_summary tps
    JOIN topics t ON tps.topic_id = t.topic_id
    JOIN subjects s ON t.subject_id = s.subject_id
    WHERE tps.user_id = ?
    GROUP BY s.subject_id, s.subject_code, s.subject_name
    ORDER BY accuracy ASC
  `, [userId]);

  return breakdown;
}

module.exports = {
  analyzeUserPerformance,
  getLearningPatterns,
  recordAnswer,
  getPerformanceTrend,
  getSubjectBreakdown,
  calculateExamReadiness,
  updateTopicPerformance
};
