const { db } = require('../models');

class PremiumAnalytics {
  constructor() {
    this.db = db;
  }

  async getAdvancedWeaknessAnalysis(userId) {
    const connection = await this.db.getPool();
    
    const [analysis] = await connection.query(`
      SELECT 
        subject,
        topic,
        difficulty_level,
        total_attempts,
        correct_attempts,
        mastery_score,
        AVG(CASE WHEN time_taken IS NOT NULL THEN time_taken END) as avg_time,
        -- Pattern analysis
        CASE 
          WHEN mastery_score < 30 THEN 'Critical Foundation Gap'
          WHEN mastery_score < 50 THEN 'Conceptual Misunderstanding'
          WHEN mastery_score < 70 THEN 'Application Weakness'
          WHEN mastery_score < 85 THEN 'Practice Needed'
          ELSE 'Mastery Achieved'
        END as performance_category,
        -- Learning velocity
        CASE 
          WHEN total_attempts >= 10 AND mastery_score < 50 THEN 'Slow Progress'
          WHEN total_attempts >= 5 AND mastery_score < 70 THEN 'Moderate Progress'
          WHEN mastery_score >= 85 THEN 'Fast Progress'
          ELSE 'Insufficient Data'
        END as learning_velocity
      FROM analytics 
      WHERE user_id = ? AND total_attempts >= 3
      ORDER BY mastery_score ASC, total_attempts DESC
      LIMIT 15
    `, [userId]);

    return analysis;
  }

  async getPersonalizedRecommendations(userId) {
    const connection = await this.db.getPool();
    
    // Get user's current performance patterns
    const [patterns] = await connection.query(`
      SELECT 
        subject,
        AVG(mastery_score) as avg_mastery,
        STDDEV(mastery_score) as mastery_variance,
        COUNT(*) as topics_covered,
        AVG(total_attempts) as avg_attempts_per_topic
      FROM analytics 
      WHERE user_id = ? AND total_attempts >= 3
      GROUP BY subject
    `, [userId]);

    // Generate personalized recommendations
    const recommendations = [];

    for (const pattern of patterns) {
      if (pattern.avg_mastery < 50) {
        recommendations.push({
          type: 'FOUNDATION_REBUILD',
          subject: pattern.subject,
          priority: 'HIGH',
          message: `Return to basics for ${pattern.subject}. Focus on understanding core principles before attempting advanced problems.`,
          actionItems: [
            'Review fundamental concepts',
            'Practice easy-level questions',
            'Watch concept videos',
            'Use memory triggers'
          ],
          estimatedTime: '2-3 weeks'
        });
      } else if (pattern.avg_mastery < 70) {
        recommendations.push({
          type: 'INTENSIVE_PRACTICE',
          subject: pattern.subject,
          priority: 'MEDIUM',
          message: `${pattern.subject} needs more focused practice. Your understanding is partial but not consistent.`,
          actionItems: [
            'Practice medium-level questions',
            'Focus on weak topics',
            'Review mistakes patterns',
            'Use spaced repetition'
          ],
          estimatedTime: '1-2 weeks'
        });
      } else if (pattern.mastery_variance > 25) {
        recommendations.push({
          type: 'CONSISTENCY_IMPROVEMENT',
          subject: pattern.subject,
          priority: 'MEDIUM',
          message: `Your ${pattern.subject} performance is inconsistent. Focus on steady improvement.`,
          actionItems: [
            'Daily practice sessions',
            'Mixed difficulty questions',
            'Time-based practice',
            'Regular review cycles'
          ],
          estimatedTime: '1 week'
        });
      }
    }

    // Time management recommendations
    const [timeAnalysis] = await connection.query(`
      SELECT 
        AVG(time_taken) as avg_time,
        AVG(CASE WHEN is_correct = 1 THEN time_taken END) as avg_correct_time,
        AVG(CASE WHEN is_correct = 0 THEN time_taken END) as avg_wrong_time,
        difficulty_level
      FROM user_progress up
      WHERE up.user_id = ? AND time_taken IS NOT NULL
      GROUP BY difficulty_level
    `, [userId]);

    for (const time of timeAnalysis) {
      if (time.avg_wrong_time > time.avg_correct_time * 1.5) {
        recommendations.push({
          type: 'TIME_MANAGEMENT',
          subject: time.difficulty_level,
          priority: 'MEDIUM',
          message: `You spend too much time on difficult ${time.difficulty_level} questions. Improve time management.`,
          actionItems: [
            'Set time limits per question',
            'Practice quick decision making',
            'Skip and return strategy',
            'Elimination techniques'
          ],
          estimatedTime: '3-5 days'
        });
      }
    }

    return recommendations.sort((a, b) => {
      const priorityOrder = { 'HIGH': 1, 'MEDIUM': 2, 'LOW': 3 };
      return priorityOrder[a.priority] - priorityOrder[b.priority];
    });
  }

  async getMasteryBreakdown(userId, subject) {
    const connection = await this.db.getPool();
    
    const [breakdown] = await connection.query(`
      SELECT 
        topic,
        difficulty_level,
        mastery_score,
        total_attempts,
        -- Cognitive load assessment
        CASE 
          WHEN difficulty_level = 'Easy' AND mastery_score >= 90 THEN 'Automatic'
          WHEN difficulty_level = 'Easy' AND mastery_score >= 70 THEN 'Developing'
          WHEN difficulty_level = 'Medium' AND mastery_score >= 80 THEN 'Mastered'
          WHEN difficulty_level = 'Medium' AND mastery_score >= 60 THEN 'Competent'
          WHEN difficulty_level = 'Difficult' AND mastery_score >= 70 THEN 'Advanced'
          WHEN difficulty_level = 'Difficult' AND mastery_score >= 50 THEN 'Proficient'
          ELSE 'Learning'
        END as cognitive_status,
        -- Retention score based on recent performance
        (COUNT(CASE WHEN is_correct = 1 AND attempted_at >= DATE_SUB(NOW(), INTERVAL 7 DAY) THEN 1 END) * 100.0 / 
         COUNT(CASE WHEN attempted_at >= DATE_SUB(NOW(), INTERVAL 7 DAY) THEN 1 END)) as recent_retention
      FROM analytics a
      WHERE a.user_id = ? AND a.subject = ?
      GROUP BY a.topic, a.difficulty_level
      ORDER BY a.topic, FIELD(a.difficulty_level, 'Easy', 'Medium', 'Difficult', 'Tricky')
    `, [userId, subject]);

    // Calculate overall mastery indicators
    const totalTopics = breakdown.length;
    const masteredTopics = breakdown.filter(b => b.mastery_score >= 85).length;
    const competentTopics = breakdown.filter(b => b.mastery_score >= 70).length;
    
    return {
      breakdown,
      summary: {
        totalTopics,
        masteredTopics,
        competentTopics,
        masteryPercentage: Math.round((competentTopics / totalTopics) * 100),
        readinessLevel: this.calculateReadinessLevel(competentTopics, totalTopics)
      }
    };
  }

  async getPredictiveAnalytics(userId) {
    const connection = await this.db.getPool();
    
    // Get learning patterns
    const [patterns] = await connection.query(`
      SELECT 
        subject,
        topic,
        -- Learning curve analysis
        CASE 
          WHEN total_attempts <= 3 THEN mastery_score * 0.8
          WHEN total_attempts <= 6 THEN mastery_score * 0.9
          ELSE mastery_score
        END as adjusted_mastery,
        -- Predictive mastery trajectory
        mastery_score + (mastery_score * 0.1 * LOG(total_attempts)) as predicted_mastery,
        -- Difficulty progression capability
        MAX(CASE WHEN difficulty_level = 'Difficult' AND mastery_score >= 70 THEN 1 ELSE 0 END) as can_handle_difficult
      FROM analytics 
      WHERE user_id = ? AND total_attempts >= 2
    `, [userId]);

    // Exam readiness prediction
    const [examReadiness] = await connection.query(`
      SELECT 
        COUNT(*) as total_questions_attempted,
        AVG(mastery_score) as overall_mastery,
        -- Time performance under pressure
        AVG(CASE WHEN time_taken <= 60 THEN mastery_score END) as pressure_mastery,
        -- Consistency factor
        STDDEV(mastery_score) as consistency_score
      FROM analytics 
      WHERE user_id = ? AND total_attempts >= 3
    `, [userId]);

    const readiness = examReadiness[0] || {};
    const predictedScore = this.predictExamScore(readiness, patterns);

    return {
      currentMastery: readiness.overall_mastery || 0,
      predictedExamScore: predictedScore,
      readinessLevel: this.getReadinessLevel(predictedScore),
      improvementPotential: this.calculateImprovementPotential(patterns),
      recommendedStudyPlan: this.generateStudyPlan(patterns, predictedScore),
      timeToExam: this.estimateTimeToReadiness(predictedScore)
    };
  }

  async getComparativeAnalytics(userId) {
    const connection = await this.db.getPool();
    
    // Get user performance
    const [userStats] = await connection.query(`
      SELECT 
        subject,
        AVG(mastery_score) as user_mastery,
        AVG(total_attempts) as user_attempts
      FROM analytics 
      WHERE user_id = ? AND total_attempts >= 3
      GROUP BY subject
    `, [userId]);

    // Get cohort averages (simulated)
    const cohortData = {
      'FAR': { avgMastery: 65, avgAttempts: 8 },
      'AFAR': { avgMastery: 60, avgAttempts: 10 },
      'MS': { avgMastery: 70, avgAttempts: 6 },
      'RFBT': { avgMastery: 55, avgAttempts: 12 },
      'TAX': { avgMastery: 58, avgAttempts: 11 },
      'AUD': { avgMastery: 62, avgAttempts: 9 }
    };

    const comparison = userStats.map(userStat => ({
      subject: userStat.subject,
      userMastery: userStat.user_mastery,
      userAttempts: userStat.user_attempts,
      cohortMastery: cohortData[userStat.subject]?.avgMastery || 0,
      cohortAttempts: cohortData[userStat.subject]?.avgAttempts || 0,
      percentile: this.calculatePercentile(userStat.user_mastery, cohortData[userStat.subject]?.avgMastery),
      performanceLevel: this.getPerformanceLevel(userStat.user_mastery, cohortData[userStat.subject]?.avgMastery)
    }));

    return {
      comparison,
      overallPercentile: this.calculateOverallPercentile(comparison),
      competitiveAdvantage: this.assessCompetitivePosition(comparison)
    };
  }

  // Helper methods
  calculateReadinessLevel(competentTopics, totalTopics) {
    const percentage = (competentTopics / totalTopics) * 100;
    
    if (percentage >= 90) return 'EXCELLENT';
    if (percentage >= 80) return 'GOOD';
    if (percentage >= 70) return 'SATISFACTORY';
    if (percentage >= 60) return 'NEEDS_IMPROVEMENT';
    return 'INSUFFICIENT';
  }

  predictExamScore(readiness, patterns) {
    const baseScore = readiness.overall_mastery || 0;
    const consistencyBonus = Math.max(0, 10 - (readiness.consistency_score || 0));
    const pressureAdjustment = (readiness.pressure_mastery || 0) - baseScore;
    const patternMultiplier = this.calculatePatternMultiplier(patterns);
    
    return Math.round(baseScore + consistencyBonus + pressureAdjustment) * patternMultiplier;
  }

  getReadinessLevel(score) {
    if (score >= 85) return 'READY_FOR_EXAM';
    if (score >= 75) return 'STRONG_CANDIDATE';
    if (score >= 65) return 'POTENTIAL_PASS';
    if (score >= 50) return 'NEEDS_IMPROVEMENT';
    return 'REQUIRES_INTENSIVE_STUDY';
  }

  calculateImprovementPotential(patterns) {
    const avgPattern = patterns.reduce((sum, p) => sum + (p.adjusted_mastery || 0), 0) / patterns.length;
    const highPerformers = patterns.filter(p => p.can_handle_difficult).length;
    const improvementRatio = highPerformers / patterns.length;
    
    if (improvementRatio >= 0.7) return 'HIGH';
    if (improvementRatio >= 0.4) return 'MEDIUM';
    return 'LOW';
  }

  generateStudyPlan(patterns, predictedScore) {
    const weakSubjects = patterns.filter(p => p.adjusted_mastery < 60);
    const moderateSubjects = patterns.filter(p => p.adjusted_mastery >= 60 && p.adjusted_mastery < 80);
    
    return {
      phase1: {
        duration: '2 weeks',
        focus: weakSubjects.map(s => s.subject),
        dailyTime: '3-4 hours',
        strategy: 'Foundation rebuilding'
      },
      phase2: {
        duration: '2 weeks',
        focus: moderateSubjects.map(s => s.subject),
        dailyTime: '2-3 hours',
        strategy: 'Practice and application'
      },
      phase3: {
        duration: '1 week',
        focus: 'Mixed practice and mock exams',
        dailyTime: '4-5 hours',
        strategy: 'Exam preparation'
      }
    };
  }

  estimateTimeToReadiness(predictedScore) {
    if (predictedScore >= 85) return '2-3 weeks';
    if (predictedScore >= 75) return '4-6 weeks';
    if (predictedScore >= 65) return '6-8 weeks';
    return '8-12 weeks';
  }

  calculatePercentile(userValue, cohortAvg) {
    if (!cohortAvg) return 50; // Default to 50th percentile
    
    const difference = userValue - cohortAvg;
    const standardDeviation = 15; // Assumed standard deviation
    
    let percentile = 50 + (difference / standardDeviation) * 34;
    return Math.round(Math.max(0, Math.min(100, percentile)));
  }

  getPerformanceLevel(userMastery, cohortMastery) {
    const difference = userMastery - cohortMastery;
    
    if (difference >= 10) return 'TOP_PERFORMER';
    if (difference >= 5) return 'ABOVE_AVERAGE';
    if (difference >= -5) return 'BELOW_AVERAGE';
    return 'NEEDS_SIGNIFICANT_IMPROVEMENT';
  }

  assessCompetitivePosition(comparison) {
    const aboveAverage = comparison.filter(c => c.userMastery > c.cohortMastery).length;
    const totalSubjects = comparison.length;
    const competitiveRatio = aboveAverage / totalSubjects;
    
    if (competitiveRatio >= 0.8) return 'STRONG_COMPETITIVE_ADVANTAGE';
    if (competitiveRatio >= 0.6) return 'MODERATE_ADVANTAGE';
    if (competitiveRatio >= 0.4) return 'COMPETITIVE_POSITION';
    return 'NEEDS_IMPROVEMENT';
  }
}

module.exports = PremiumAnalytics;