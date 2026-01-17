const express = require('express');
const router = express.Router();
const { db } = require('../models');
const jwt = require('jsonwebtoken');

// Middleware to verify JWT token
const verifyToken = (req, res, next) => {
  const token = req.headers.authorization?.replace('Bearer ', '');
  
  if (!token) {
    return res.status(401).json({ error: 'No token provided' });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET || 'fallback_secret');
    req.userId = decoded.userId;
    next();
  } catch (error) {
    return res.status(401).json({ error: 'Invalid token' });
  }
};

// Record quiz attempt
router.post('/attempt', verifyToken, async (req, res) => {
  try {
    const { questionCode, isCorrect, timeTaken, difficultyLevel } = req.body;
    
    if (!questionCode || isCorrect === undefined || !difficultyLevel) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    const connection = await db.getPool();
    
    // Record the attempt
    await connection.query(
      'INSERT INTO user_progress (user_id, question_code, is_correct, time_taken, difficulty_level, attempted_at) VALUES (?, ?, ?, ?, ?, NOW()) ON DUPLICATE KEY UPDATE is_correct = VALUES(is_correct), time_taken = VALUES(time_taken), attempted_at = VALUES(attempted_at)',
      [req.userId, questionCode, isCorrect, timeTaken || null, difficultyLevel]
    );

    // Update analytics
    await connection.query(`
      INSERT INTO analytics (user_id, subject, topic, difficulty_level, total_attempts, correct_attempts, average_time, mastery_score, last_attempted)
      SELECT ?, mcqs.subject, mcqs.topic, mcqs.difficulty_level, 1, ?, ?, ?, NOW()
      FROM mcqs WHERE mcqs.question_code = ?
      ON DUPLICATE KEY UPDATE 
        total_attempts = total_attempts + 1,
        correct_attempts = correct_attempts + VALUES(correct_attempts),
        average_time = (average_time * (total_attempts - 1) + VALUES(average_time)) / total_attempts,
        mastery_score = (correct_attempts * 100.0) / total_attempts,
        last_attempted = VALUES(last_attempted)
    `, [req.userId, isCorrect ? 1 : 0, timeTaken || 0, isCorrect ? 100 : 0, questionCode]);

    res.json({ message: 'Attempt recorded successfully' });
  } catch (error) {
    console.error('Error recording attempt:', error);
    res.status(500).json({ error: 'Failed to record attempt' });
  }
});

// Get user progress
router.get('/progress', verifyToken, async (req, res) => {
  try {
    const { subject, difficulty } = req.query;
    
    let query = `
      SELECT 
        subject,
        topic,
        difficulty_level,
        SUM(total_attempts) as total_attempts,
        SUM(correct_attempts) as correct_attempts,
        AVG(average_time) as avg_time,
        AVG(mastery_score) as mastery_score
      FROM analytics 
      WHERE user_id = ?
    `;
    const params = [req.userId];

    if (subject) {
      query += ' AND subject = ?';
      params.push(subject);
    }

    if (difficulty) {
      query += ' AND difficulty_level = ?';
      params.push(difficulty);
    }

    query += ' GROUP BY subject, topic, difficulty_level ORDER BY subject, topic, difficulty_level';

    const connection = await db.getPool();
    const [progress] = await connection.query(query, params);

    res.json(progress);
  } catch (error) {
    console.error('Error fetching progress:', error);
    res.status(500).json({ error: 'Failed to fetch progress' });
  }
});

// Get user weaknesses
router.get('/weaknesses', verifyToken, async (req, res) => {
  try {
    const connection = await db.getPool();
    
    const [weaknesses] = await connection.query(`
      SELECT 
        subject,
        topic,
        difficulty_level,
        total_attempts,
        correct_attempts,
        mastery_score,
        CASE 
          WHEN mastery_score < 50 THEN 'Critical'
          WHEN mastery_score < 70 THEN 'Needs Improvement'
          WHEN mastery_score < 85 THEN 'Good'
          ELSE 'Excellent'
        END as performance_level
      FROM analytics 
      WHERE user_id = ? AND total_attempts >= 3
      ORDER BY mastery_score ASC, total_attempts DESC
      LIMIT 10
    `, [req.userId]);

    res.json(weaknesses);
  } catch (error) {
    console.error('Error fetching weaknesses:', error);
    res.status(500).json({ error: 'Failed to fetch weaknesses' });
  }
});

// Get overall statistics
router.get('/stats', verifyToken, async (req, res) => {
  try {
    const connection = await db.getPool();
    
    const [stats] = await connection.query(`
      SELECT 
        COUNT(DISTINCT question_code) as questions_attempted,
        SUM(CASE WHEN is_correct = 1 THEN 1 ELSE 0 END) as correct_answers,
        COUNT(*) as total_attempts,
        AVG(time_taken) as avg_time_per_question,
        (SUM(CASE WHEN is_correct = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) as accuracy_rate
      FROM user_progress 
      WHERE user_id = ?
    `, [req.userId]);

    const [subjectStats] = await connection.query(`
      SELECT 
        subject,
        COUNT(DISTINCT question_code) as questions_attempted,
        SUM(CASE WHEN is_correct = 1 THEN 1 ELSE 0 END) as correct_answers,
        COUNT(*) as total_attempts,
        (SUM(CASE WHEN is_correct = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) as accuracy_rate
      FROM user_progress up
      JOIN mcqs m ON up.question_code = m.question_code
      WHERE up.user_id = ?
      GROUP BY subject
      ORDER BY accuracy_rate DESC
    `, [req.userId]);

    res.json({
      overall: stats[0] || {
        questions_attempted: 0,
        correct_answers: 0,
        total_attempts: 0,
        avg_time_per_question: 0,
        accuracy_rate: 0
      },
      by_subject: subjectStats
    });
  } catch (error) {
    console.error('Error fetching stats:', error);
    res.status(500).json({ error: 'Failed to fetch statistics' });
  }
});

// Get recommended study topics
router.get('/recommendations', verifyToken, async (req, res) => {
  try {
    const connection = await db.getPool();
    
    const [recommendations] = await connection.query(`
      SELECT 
        subject,
        topic,
        difficulty_level,
        mastery_score,
        total_attempts,
        CASE 
          WHEN mastery_score < 50 AND total_attempts >= 3 THEN 'Priority Review'
          WHEN mastery_score < 70 AND total_attempts >= 3 THEN 'Practice More'
          WHEN mastery_score >= 85 OR total_attempts < 3 THEN 'Move to Next Topic'
          ELSE 'Continue Studying'
        END as recommendation
      FROM analytics 
      WHERE user_id = ?
      ORDER BY 
        CASE 
          WHEN mastery_score < 50 THEN 1
          WHEN mastery_score < 70 THEN 2
          ELSE 3
        END,
        total_attempts DESC
      LIMIT 15
    `, [req.userId]);

    res.json(recommendations);
  } catch (error) {
    console.error('Error fetching recommendations:', error);
    res.status(500).json({ error: 'Failed to fetch recommendations' });
  }
});

module.exports = router;