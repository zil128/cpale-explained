/**
 * User Analytics Routes
 * API endpoints for AI-powered performance analysis
 */

const express = require('express');
const router = express.Router();
const aiAnalytics = require('../services/aiAnalytics');

// Middleware is applied in server.js (authenticateToken)

/**
 * GET /api/analytics/user/weak-points
 * Returns categorized weak points: critical, needs attention, mastered
 */
router.get('/weak-points', async (req, res) => {
  try {
    const userId = req.user.userId;
    
    // Try to get cached patterns first
    let patterns = await aiAnalytics.getLearningPatterns(userId);
    
    // If no cached data or stale, run fresh analysis
    if (!patterns || !patterns.weakPoints || patterns.weakPoints.critical.length === 0) {
      const analysis = await aiAnalytics.analyzeUserPerformance(userId);
      if (!analysis.hasData) {
        return res.json({
          hasData: false,
          message: analysis.message,
          critical: [],
          needsAttention: [],
          mastered: []
        });
      }
      patterns = analysis;
    }

    res.json({
      hasData: true,
      critical: patterns.weakPoints.critical,
      needsAttention: patterns.weakPoints.needsAttention,
      mastered: patterns.weakPoints.mastered,
      summary: {
        criticalCount: patterns.weakPoints.critical.length,
        needsAttentionCount: patterns.weakPoints.needsAttention.length,
        masteredCount: patterns.weakPoints.mastered.length
      }
    });
  } catch (error) {
    console.error('Error getting weak points:', error);
    res.status(500).json({ error: 'Failed to get weak points analysis' });
  }
});

/**
 * GET /api/analytics/user/learning-patterns
 * Returns learning patterns: by difficulty, by subject, time patterns, improvement
 */
router.get('/learning-patterns', async (req, res) => {
  try {
    const userId = req.user.userId;
    
    let patterns = await aiAnalytics.getLearningPatterns(userId);
    
    if (!patterns) {
      const analysis = await aiAnalytics.analyzeUserPerformance(userId);
      if (!analysis.hasData) {
        return res.json({
          hasData: false,
          message: analysis.message
        });
      }
      patterns = analysis;
    }

    // Get performance trend
    const trend = await aiAnalytics.getPerformanceTrend(userId, 30);
    
    // Get subject breakdown
    const subjectBreakdown = await aiAnalytics.getSubjectBreakdown(userId);

    res.json({
      hasData: true,
      byDifficulty: patterns.difficultyBreakdown,
      bySubject: subjectBreakdown,
      timePatterns: {
        avgTimePerQuestion: patterns.avgTimePerQuestion,
        totalStudyTimeMinutes: Math.round((patterns.totalQuestionsAttempted * patterns.avgTimePerQuestion) / 60)
      },
      overallStats: {
        totalQuestionsAttempted: patterns.totalQuestionsAttempted,
        totalCorrect: patterns.totalCorrect,
        overallAccuracy: patterns.overallAccuracy
      },
      trend: trend,
      lastAnalyzedAt: patterns.lastAnalyzedAt
    });
  } catch (error) {
    console.error('Error getting learning patterns:', error);
    res.status(500).json({ error: 'Failed to get learning patterns' });
  }
});

/**
 * GET /api/analytics/user/recommendations
 * Returns AI-generated recommendations and study plan
 */
router.get('/recommendations', async (req, res) => {
  try {
    const userId = req.user.userId;
    
    let patterns = await aiAnalytics.getLearningPatterns(userId);
    
    if (!patterns || !patterns.recommendations) {
      const analysis = await aiAnalytics.analyzeUserPerformance(userId);
      if (!analysis.hasData) {
        return res.json({
          hasData: false,
          message: analysis.message,
          recommendations: [],
          studyPlan: null
        });
      }
      patterns = analysis;
    }

    res.json({
      hasData: true,
      recommendations: patterns.recommendations,
      studyPlan: patterns.studyPlan,
      priorityTopics: patterns.weakPoints?.critical?.slice(0, 5) || [],
      practiceSetSuggestions: getPracticeSetSuggestions(patterns)
    });
  } catch (error) {
    console.error('Error getting recommendations:', error);
    res.status(500).json({ error: 'Failed to get recommendations' });
  }
});

/**
 * GET /api/analytics/user/exam-readiness
 * Returns exam readiness score and predictions
 */
router.get('/exam-readiness', async (req, res) => {
  try {
    const userId = req.user.userId;
    
    let patterns = await aiAnalytics.getLearningPatterns(userId);
    
    if (!patterns) {
      const analysis = await aiAnalytics.analyzeUserPerformance(userId);
      if (!analysis.hasData) {
        return res.json({
          hasData: false,
          message: analysis.message,
          readinessScore: 0,
          predictedScore: 0,
          status: 'No Data'
        });
      }
      patterns = analysis;
    }

    const examReadiness = patterns.examReadiness || {
      readinessScore: patterns.exam_readiness_score || 0,
      predictedScore: patterns.predicted_exam_score || 0,
      daysToReady: patterns.estimated_days_to_ready || 0
    };

    // Determine status
    let status, statusColor;
    if (examReadiness.readinessScore >= 80) {
      status = 'Ready';
      statusColor = 'green';
    } else if (examReadiness.readinessScore >= 60) {
      status = 'Almost Ready';
      statusColor = 'yellow';
    } else if (examReadiness.readinessScore >= 40) {
      status = 'Need More Practice';
      statusColor = 'orange';
    } else {
      status = 'Not Ready';
      statusColor = 'red';
    }

    res.json({
      hasData: true,
      readinessScore: examReadiness.readinessScore,
      predictedScore: examReadiness.predictedScore,
      passingScore: 75,
      status,
      statusColor,
      daysToReady: examReadiness.daysToReady,
      subjectReadiness: patterns.subjectScores?.map(s => ({
        subject: s.subjectCode,
        subjectName: s.subjectName,
        score: s.accuracy,
        isReady: s.accuracy >= 75
      })) || [],
      breakdown: {
        overallAccuracy: patterns.overallAccuracy,
        questionsAttempted: patterns.totalQuestionsAttempted,
        topicsWithData: patterns.weakPoints ? 
          (patterns.weakPoints.critical.length + patterns.weakPoints.needsAttention.length + patterns.weakPoints.mastered.length) : 0
      }
    });
  } catch (error) {
    console.error('Error getting exam readiness:', error);
    res.status(500).json({ error: 'Failed to get exam readiness' });
  }
});

/**
 * POST /api/analytics/user/recalculate
 * Triggers full AI analysis and returns updated patterns
 */
router.post('/recalculate', async (req, res) => {
  try {
    const userId = req.user.userId;
    
    console.log(`Recalculating analytics for user ${userId}...`);
    const analysis = await aiAnalytics.analyzeUserPerformance(userId);
    
    if (!analysis.hasData) {
      return res.json({
        success: false,
        message: analysis.message
      });
    }

    res.json({
      success: true,
      message: 'Analysis complete',
      summary: {
        overallAccuracy: analysis.overallMetrics.overallAccuracy,
        totalQuestions: analysis.overallMetrics.totalQuestionsAttempted,
        examReadiness: analysis.examReadiness.readinessScore,
        criticalTopics: analysis.weakPoints.summary.criticalCount,
        masteredTopics: analysis.weakPoints.summary.masteredCount
      },
      lastAnalyzedAt: analysis.lastAnalyzedAt
    });
  } catch (error) {
    console.error('Error recalculating analytics:', error);
    res.status(500).json({ error: 'Failed to recalculate analytics' });
  }
});

/**
 * GET /api/analytics/user/dashboard
 * Returns comprehensive dashboard data in a single call
 */
router.get('/dashboard', async (req, res) => {
  try {
    const userId = req.user.userId;
    
    // Always run fresh analysis for dashboard
    const analysis = await aiAnalytics.analyzeUserPerformance(userId);
    
    if (!analysis.hasData) {
      return res.json({
        hasData: false,
        message: analysis.message
      });
    }

    // Get trend data
    const trend = await aiAnalytics.getPerformanceTrend(userId, 30);
    const subjectBreakdown = await aiAnalytics.getSubjectBreakdown(userId);

    res.json({
      hasData: true,
      
      // Exam Readiness (top widget)
      examReadiness: analysis.examReadiness,
      
      // Overall Stats
      overallMetrics: analysis.overallMetrics,
      
      // Difficulty Breakdown
      difficultyBreakdown: analysis.difficultyBreakdown,
      
      // Weak Points
      weakPoints: analysis.weakPoints,
      
      // Subject Scores
      subjectScores: analysis.subjectScores,
      subjectBreakdown,
      
      // Recommendations
      recommendations: analysis.recommendations,
      
      // Study Plan
      studyPlan: analysis.studyPlan,
      
      // Trend Data
      performanceTrend: trend,
      
      // Metadata
      lastAnalyzedAt: analysis.lastAnalyzedAt
    });
  } catch (error) {
    console.error('Error getting analytics dashboard:', error);
    res.status(500).json({ error: 'Failed to get analytics dashboard' });
  }
});

/**
 * GET /api/analytics/user/trend
 * Returns performance trend over specified days
 */
router.get('/trend', async (req, res) => {
  try {
    const userId = req.user.userId;
    const days = parseInt(req.query.days) || 30;
    
    const trend = await aiAnalytics.getPerformanceTrend(userId, Math.min(days, 90));
    
    res.json({
      days,
      data: trend,
      summary: trend.length > 0 ? {
        totalDays: trend.length,
        avgAccuracy: Math.round(trend.reduce((sum, d) => sum + parseFloat(d.accuracy), 0) / trend.length * 100) / 100,
        totalAttempted: trend.reduce((sum, d) => sum + d.attempted, 0),
        totalCorrect: trend.reduce((sum, d) => sum + d.correct, 0)
      } : null
    });
  } catch (error) {
    console.error('Error getting trend:', error);
    res.status(500).json({ error: 'Failed to get performance trend' });
  }
});

/**
 * GET /api/analytics/user/topics
 * Returns detailed topic-level performance
 */
router.get('/topics', async (req, res) => {
  try {
    const userId = req.user.userId;
    const { subject, sortBy = 'accuracy', order = 'asc' } = req.query;
    
    const pool = require('../db');
    
    let query = `
      SELECT 
        tps.*,
        t.topic_name,
        s.subject_code,
        s.subject_name
      FROM topic_performance_summary tps
      JOIN topics t ON tps.topic_id = t.topic_id
      JOIN subjects s ON t.subject_id = s.subject_id
      WHERE tps.user_id = ?
    `;
    
    const params = [userId];
    
    if (subject) {
      query += ' AND s.subject_code = ?';
      params.push(subject);
    }
    
    // Sort
    const validSortFields = ['accuracy_percent', 'total_attempted', 'last_attempted_at', 'topic_name'];
    const sortField = validSortFields.includes(sortBy) ? sortBy : 'accuracy_percent';
    const sortOrder = order === 'desc' ? 'DESC' : 'ASC';
    query += ` ORDER BY ${sortField} ${sortOrder}`;
    
    const [topics] = await pool.query(query, params);
    
    res.json({
      total: topics.length,
      topics: topics.map(t => ({
        topicId: t.topic_id,
        topicName: t.topic_name,
        subjectCode: t.subject_code,
        subjectName: t.subject_name,
        accuracy: t.accuracy_percent,
        attempted: t.total_attempted,
        correct: t.total_correct,
        avgTime: t.avg_time_seconds,
        difficultyBreakdown: {
          easy: { attempted: t.easy_attempted, correct: t.easy_correct },
          medium: { attempted: t.medium_attempted, correct: t.medium_correct },
          hard: { attempted: t.hard_attempted, correct: t.hard_correct }
        },
        lastAttempted: t.last_attempted_at,
        status: getTopicStatus(t.accuracy_percent)
      }))
    });
  } catch (error) {
    console.error('Error getting topics:', error);
    res.status(500).json({ error: 'Failed to get topic performance' });
  }
});

// Helper functions
function getTopicStatus(accuracy) {
  if (accuracy >= 80) return 'mastered';
  if (accuracy >= 60) return 'good';
  if (accuracy >= 40) return 'needs_attention';
  return 'critical';
}

function getPracticeSetSuggestions(patterns) {
  const suggestions = [];
  
  // If user has weak subjects, suggest relevant practice sets
  if (patterns.subjectScores) {
    const weakSubjects = patterns.subjectScores.filter(s => s.accuracy < 60);
    weakSubjects.forEach(subject => {
      suggestions.push({
        type: 'subject_focus',
        subjectCode: subject.subjectCode,
        reason: `Improve your ${subject.subjectCode} score (currently ${subject.accuracy}%)`
      });
    });
  }

  // Suggest comprehensive review if overall accuracy is moderate
  if (patterns.overallAccuracy && patterns.overallAccuracy >= 50 && patterns.overallAccuracy < 75) {
    suggestions.push({
      type: 'comprehensive_review',
      practiceSetId: 200,
      reason: 'Comprehensive review to solidify your knowledge'
    });
  }

  // Suggest advanced challenge if overall accuracy is high
  if (patterns.overallAccuracy && patterns.overallAccuracy >= 75) {
    suggestions.push({
      type: 'advanced_challenge',
      practiceSetId: 202,
      reason: 'Challenge yourself with advanced questions'
    });
  }

  return suggestions;
}

module.exports = router;
