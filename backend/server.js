// server.js - Backend Server for CPALE Explained (Local Docker MySQL)
require('dotenv').config();
const express = require('express');
const mysql = require('mysql2/promise');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const path = require('path');

// MVP Phase 1: Subscription management
const subscriptionRoutes = require('./routes/subscription');
const subscriptionMiddleware = require('./middleware/subscriptionCheck');
const SubscriptionChecker = require('./services/subscriptionChecker');

const app = express();
const PORT = process.env.PORT || 5000;

// ============================================================================
// UTILITY FUNCTIONS
// ============================================================================

/**
 * Shuffle array randomly using Fisher-Yates algorithm
 * Used to randomize choice order on each quiz attempt to prevent memorization
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
 * Assign dynamic labels (A, B, C, D) to shuffled choices
 */
function assignChoiceLabels(choices) {
  const shuffled = shuffleArray(choices);
  return shuffled.map((choice, index) => ({
    ...choice,
    choice_label: String.fromCharCode(65 + index) // A=65, B=66, C=67, D=68
  }));
}

// Middleware
app.use(cors({
  origin: ['http://localhost:3000', 'http://127.0.0.1:3000', 'http://localhost:5500', 'http://127.0.0.1:5500'],
  credentials: true
}));
app.use(express.json());

// Serve static files from landing-page
app.use('/landing-page', express.static(path.join(__dirname, '../landing-page')));

// Database Connection Pool
let pool = null;

async function setupDatabase() {
  try {
    pool = mysql.createPool({
      host: process.env.DB_HOST || 'localhost',
      port: process.env.DB_PORT || 3306,
      user: process.env.DB_USER || 'cpale_user',
      password: process.env.DB_PASSWORD || 'cpale_password',
      database: process.env.DB_NAME || 'cpale_explained',
      waitForConnections: true,
      connectionLimit: 10,
      queueLimit: 0
    });

    // Test connection
    const connection = await pool.getConnection();
    console.log('Database connected successfully!');
    connection.release();
    
    // Initialize subscription middleware with database pool
    subscriptionMiddleware.setPool(pool);
    subscriptionRoutes.setPool(pool);
    console.log('Subscription middleware initialized');
    
    // Initialize subscription checker service
    const subscriptionChecker = new SubscriptionChecker(pool);
    subscriptionChecker.startPeriodicChecks(6); // Check every 6 hours
    console.log('Subscription checker service started');
    
    return true;
  } catch (error) {
    console.error('Database connection failed:', error.message);
    return false;
  }
}

// ============================================================================
// AUTHENTICATION MIDDLEWARE
// ============================================================================
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'Access token required' });
  }

  jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({ error: 'Invalid or expired token' });
    }
    req.user = user;
    next();
  });
};

// ============================================================================
// ROUTES
// ============================================================================

// Health check
app.get('/api/health', (req, res) => {
  res.json({
    status: 'OK',
    message: 'CPALE Explained API is running',
    database: pool ? 'Connected' : 'Disconnected',
    timestamp: new Date().toISOString()
  });
});

// Subscribe email (Landing Page)
app.post('/api/subscribe', async (req, res) => {
  try {
    const { email, firstName, plan = 'FREE', source = 'WEBSITE' } = req.body;

    if (!email || !email.includes('@')) {
      return res.status(400).json({ error: 'Valid email is required' });
    }

    const [existing] = await pool.query(
      'SELECT subscriber_id FROM email_subscribers WHERE email = ?',
      [email]
    );

    if (existing.length > 0) {
      return res.json({
        message: 'You are already subscribed!',
        subscriberId: existing[0].subscriber_id
      });
    }

    const [result] = await pool.query(
      `INSERT INTO email_subscribers (email, first_name, source, is_verified)
       VALUES (?, ?, ?, TRUE)`,
      [email, firstName || null, source]
    );

    res.status(201).json({
      message: 'Successfully subscribed!',
      subscriberId: result.insertId,
      plan: plan
    });
  } catch (error) {
    console.error('Subscribe error:', error);
    res.status(500).json({ error: 'Failed to subscribe' });
  }
});

// ============================================================================
// SUBSCRIPTION ROUTES (MVP Phase 1)
// ============================================================================
const { attachSubscription } = subscriptionMiddleware;
// Public endpoint for viewing subscription plans
const { getAllPlans } = require('./config/plans');
app.get('/api/subscription/plans', (req, res) => {
  try {
    const plans = getAllPlans();
    res.json({
      plans: plans.map(plan => ({
        code: plan.code,
        name: plan.name,
        description: plan.description,
        price: plan.price,
        duration_days: plan.duration_days,
        mcq_limit: plan.mcq_limit,
        features: plan.features
      }))
    });
  } catch (error) {
    console.error('Get plans error:', error);
    res.status(500).json({ error: 'Failed to get subscription plans' });
  }
});
// Protected subscription routes
app.use('/api/subscription', authenticateToken, subscriptionRoutes);

// PAYMENT ROUTES
// ============================================================================
const paymentRoutes = require('./routes/payment');
paymentRoutes.setPool(pool);
// Public route for payment methods (must be before protected routes)
app.get('/api/payment/methods', async (req, res) => {
  try {
    const [methods] = await pool.execute(
      `SELECT payment_method, is_active, account_name, account_number, 
              bank_name, qr_code_url, instructions
       FROM payment_methods_config
       WHERE is_active = TRUE
       ORDER BY FIELD(payment_method, 'GCASH', 'PAYMAYA', 'BANK_TRANSFER')`
    );
    res.json({ methods });
  } catch (error) {
    console.error('Get payment methods error:', error);
    res.status(500).json({ error: 'Failed to get payment methods' });
  }
});
// Protected payment routes
app.use('/api/payment', authenticateToken, paymentRoutes);

// ANALYTICS ROUTES (Admin only)
// ============================================================================
const analyticsRoutes = require('./routes/analytics');
analyticsRoutes.setPool(pool);
app.use('/api/analytics/admin', authenticateToken, analyticsRoutes);

// USER ANALYTICS ROUTES (AI-powered performance analysis)
// ============================================================================
const userAnalyticsRoutes = require('./routes/userAnalytics');
app.use('/api/analytics/user', authenticateToken, userAnalyticsRoutes);

// MOCK EXAM ROUTES (PAID users only)
// ============================================================================
const mockExamRoutes = require('./routes/mockExam');
app.use('/api/mock-exam', authenticateToken, mockExamRoutes);

// Register new user
app.post('/api/auth/register', async (req, res) => {
  try {
    const { email, password, displayName } = req.body;

    if (!email || !password) {
      return res.status(400).json({ error: 'Email and password required' });
    }

    if (password.length < 6) {
      return res.status(400).json({ error: 'Password must be at least 6 characters' });
    }

    const [existing] = await pool.query(
      'SELECT user_id FROM users WHERE email = ?',
      [email]
    );

    if (existing.length > 0) {
      return res.status(400).json({ error: 'Email already registered' });
    }

    // Note: In a production app, you would store the hashed password
    // For MVP, we're storing basic user info
    const [result] = await pool.query(
      `INSERT INTO users (email, display_name, user_type, is_active)
       VALUES (?, ?, 'FREE', TRUE)`,
      [email, displayName || email.split('@')[0]]
    );

    const userId = result.insertId;

    // Create FREE subscription in new v2 table (MVP Phase 1)
    const [freePlan] = await pool.query(
      `SELECT plan_id FROM subscription_plans_v2 WHERE plan_code = 'FREE'`
    );

    if (freePlan.length > 0) {
      await pool.query(
        `INSERT INTO user_subscriptions_v2 
        (user_id, plan_id, subscription_type, start_date, end_date, is_active)
        VALUES (?, ?, 'FREE', CURDATE(), NULL, TRUE)`,
        [userId, freePlan[0].plan_id]
      );
      
      // Initialize MCQ usage tracking
      await pool.query(
        `INSERT INTO user_mcq_usage (user_id, mcqs_attempted, last_reset_date)
        VALUES (?, 0, CURDATE())`,
        [userId]
      );
    }

    // Generate JWT token
    const token = jwt.sign(
      { userId, email, userType: 'FREE' },
      process.env.JWT_SECRET,
      { expiresIn: '7d' }
    );

    res.status(201).json({
      message: 'Registration successful',
      token,
      user: {
        userId,
        email,
        displayName: displayName || email.split('@')[0],
        userType: 'FREE'
      }
    });
  } catch (error) {
    console.error('Registration error:', error);
    res.status(500).json({ error: 'Registration failed' });
  }
});

// Login user
app.post('/api/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ error: 'Email and password required' });
    }

    const [users] = await pool.query(
      'SELECT user_id, email, display_name, user_type, is_active FROM users WHERE email = ?',
      [email]
    );

    if (users.length === 0) {
      return res.status(401).json({ error: 'Invalid email or password' });
    }

    const user = users[0];

    if (!user.is_active) {
      return res.status(403).json({ error: 'Account is disabled' });
    }

    // Update login stats
    await pool.query(
      'UPDATE users SET last_login_at = NOW(), login_count = login_count + 1 WHERE user_id = ?',
      [user.user_id]
    );

    const token = jwt.sign(
      { userId: user.user_id, email: user.email, userType: user.user_type },
      process.env.JWT_SECRET,
      { expiresIn: '7d' }
    );

    res.json({
      message: 'Login successful',
      token,
      user: {
        userId: user.user_id,
        email: user.email,
        displayName: user.display_name,
        userType: user.user_type
      }
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ error: 'Login failed' });
  }
});

// Get FREE questions for quiz
app.get('/api/questions/free', async (req, res) => {
  try {
    const { subject } = req.query;

    let query = `
      SELECT
        q.question_id,
        q.question_code,
        q.question_text,
        q.difficulty_level,
        q.topic_id,
        t.topic_name,
        s.subject_name,
        s.subject_code
      FROM questions q
      JOIN topics t ON q.topic_id = t.topic_id
      JOIN subjects s ON t.subject_id = s.subject_id
      WHERE q.access_type = 'FREE'
        AND q.is_active = TRUE
    `;

    const params = [];
    if (subject) {
      query += ' AND s.subject_code = ?';
      params.push(subject);
    }

    query += ' ORDER BY RAND() LIMIT 50';

    const [questions] = await pool.query(query, params);

    // Get choices for each question (shuffled with dynamic labels)
    for (let question of questions) {
      const [choices] = await pool.query(
        `SELECT choice_id, choice_text, is_correct, why_wrong
         FROM question_choices
         WHERE question_id = ? AND is_active = TRUE`,
        [question.question_id]
      );
      // Shuffle choices and assign dynamic labels (A, B, C, D)
      question.choices = assignChoiceLabels(choices);
    }

    res.json({
      questions,
      total: questions.length
    });
  } catch (error) {
    console.error('Get questions error:', error);
    res.status(500).json({ error: 'Failed to fetch questions' });
  }
});

// Get explanation for a question
app.get('/api/questions/:questionId/explanation', authenticateToken, async (req, res) => {
  try {
    const { questionId } = req.params;

    // Get explanation from question_explanations table
    // Note: why_wrong_choices now stores the legal_reference (PAS/PFRS/Law citations)
    const [explanations] = await pool.query(
      `SELECT
        e.short_explanation,
        e.exam_explanation,
        e.memory_tip,
        e.why_wrong_choices as legal_reference,
        c.choice_text as correct_answer_text
      FROM question_explanations e
      JOIN questions q ON e.question_id = q.question_id
      JOIN question_choices c ON q.question_id = c.question_id AND c.is_correct = TRUE
      WHERE e.question_id = ? AND e.is_active = TRUE`,
      [questionId]
    );

    if (explanations.length === 0) {
      return res.json({
        explanation: {
          short_explanation: 'No detailed explanation available for this question.',
          exam_explanation: '',
          memory_tip: 'Review the concept and practice more questions.'
        }
      });
    }

    res.json({ explanation: explanations[0] });
  } catch (error) {
    console.error('Get explanation error:', error);
    res.status(500).json({ error: 'Failed to fetch explanation' });
  }
});

// ============================================================================
// PRACTICE SET ENDPOINTS
// ============================================================================

// Get all practice sets for a subject
app.get('/api/practice-sets', authenticateToken, attachSubscription, async (req, res) => {
  try {
    const { subject } = req.query;
    const userPlan = req.user.subscription.subscription_type;

    let query = `
      SELECT
        ps.practice_set_id,
        ps.set_code,
        ps.set_name,
        ps.set_type,
        ps.access_type,
        ps.questions_per_set,
        t.topic_name,
        s.subject_code,
        s.subject_name,
        (SELECT COUNT(*) FROM questions q WHERE q.practice_set_id = ps.practice_set_id) as question_count
      FROM practice_sets ps
      JOIN topics t ON ps.topic_id = t.topic_id
      JOIN subjects s ON t.subject_id = s.subject_id
      WHERE ps.is_active = TRUE
    `;

    // FREE users only see FREE practice sets (MVP Phase 1)
    if (userPlan === 'FREE') {
      query += " AND ps.access_type = 'FREE'";
    }
    // PAID users see all practice sets

    const params = [];
    if (subject) {
      query += ' AND s.subject_code = ?';
      params.push(subject);
    }

    query += ' ORDER BY s.subject_code, ps.display_order';

    const [practiceSets] = await pool.query(query, params);

    res.json({
      practice_sets: practiceSets,
      total: practiceSets.length,
      userPlan: userPlan
    });
  } catch (error) {
    console.error('Get practice sets error:', error);
    res.status(500).json({ error: 'Failed to fetch practice sets' });
  }
});

// Get questions for a specific practice set
app.get('/api/practice-sets/:setId/questions', authenticateToken, async (req, res) => {
  try {
    const { setId } = req.params;
    const userId = req.user.userId;

    // Check if practice set exists and user has access
    const [practiceSet] = await pool.query(
      `SELECT ps.*, s.subject_code
       FROM practice_sets ps
       JOIN topics t ON ps.topic_id = t.topic_id
       JOIN subjects s ON t.subject_id = s.subject_id
       WHERE ps.practice_set_id = ?`,
      [setId]
    );

    if (practiceSet.length === 0) {
      return res.status(404).json({ error: 'Practice set not found' });
    }

    const set = practiceSet[0];

    // Check access type (PAID vs FREE)
    if (set.access_type === 'PAID') {
      // Check user subscription in user_subscriptions_v2
      const [subscription] = await pool.query(
        `SELECT subscription_type, is_active, end_date FROM user_subscriptions_v2
         WHERE user_id = ? AND is_active = TRUE AND (end_date IS NULL OR end_date > CURDATE())`,
        [userId]
      );

      if (subscription.length === 0 || subscription[0].subscription_type !== 'PAID') {
        return res.status(403).json({
          error: 'Subscription required',
          required_plan: 'PAID',
          message: 'This practice set requires a PAID subscription. Upgrade to access all 225+ premium questions.'
        });
      }
    }

    // Get questions for this practice set
    const [questions] = await pool.query(
      `SELECT
        q.question_id,
        q.question_code,
        q.question_text,
        q.difficulty_level,
        t.topic_name
       FROM questions q
       JOIN topics t ON q.topic_id = t.topic_id
       WHERE q.practice_set_id = ? AND q.is_active = TRUE
       ORDER BY q.question_code`,
      [setId]
    );

    // Get choices for each question (shuffled with dynamic labels, without showing correct answer)
    for (let question of questions) {
      const [choices] = await pool.query(
        `SELECT choice_id, choice_text
         FROM question_choices
         WHERE question_id = ? AND is_active = TRUE`,
        [question.question_id]
      );
      // Shuffle choices and assign dynamic labels (A, B, C, D)
      question.choices = assignChoiceLabels(choices);
    }

    res.json({
      practice_set: {
        set_id: set.practice_set_id,
        set_code: set.set_code,
        set_name: set.set_name,
        subject_code: set.subject_code,
        questions_per_set: set.questions_per_set
      },
      questions,
      total: questions.length
    });
  } catch (error) {
    console.error('Get practice set questions error:', error);
    res.status(500).json({ error: 'Failed to fetch practice set questions' });
  }
});

// Submit practice set answers
app.post('/api/practice-sets/:setId/submit', authenticateToken, async (req, res) => {
  try {
    const { setId } = req.params;
    const { answers } = req.body; // Array of { questionId, selectedChoiceId, timeSpent }
    const userId = req.user.userId;

    if (!answers || !Array.isArray(answers)) {
      return res.status(400).json({ error: 'Answers array required' });
    }

    // Import AI analytics service for recording answers
    const aiAnalytics = require('./services/aiAnalytics');

    let correct = 0;
    let total = answers.length;
    const results = [];

    for (const answer of answers) {
      const { questionId, selectedChoiceId, timeSpent } = answer;

      // Check if selected choice is correct
      const [choice] = await pool.query(
        `SELECT is_correct FROM question_choices WHERE choice_id = ? AND question_id = ?`,
        [selectedChoiceId, questionId]
      );

      const isCorrect = choice.length > 0 && choice[0].is_correct === 1;
      if (isCorrect) correct++;

      // Get correct answer for feedback (label not stored, only choice_id and text)
      const [correctChoice] = await pool.query(
        `SELECT choice_id, choice_text
         FROM question_choices
         WHERE question_id = ? AND is_correct = TRUE`,
        [questionId]
      );

      results.push({
        questionId,
        selectedChoiceId,
        isCorrect,
        correctAnswer: correctChoice[0]
      });

      // Save progress to user_topic_weakness (legacy)
      const [question] = await pool.query(
        'SELECT topic_id FROM questions WHERE question_id = ?',
        [questionId]
      );

      if (question.length > 0) {
        const topicId = question[0].topic_id;
        const [topic] = await pool.query('SELECT subject_id FROM topics WHERE topic_id = ?', [topicId]);
        const subjectId = topic[0]?.subject_id || 1;

        const [existing] = await pool.query(
          'SELECT weakness_id FROM user_topic_weakness WHERE user_id = ? AND topic_id = ?',
          [userId, topicId]
        );

        if (existing.length > 0) {
          await pool.query(
            `UPDATE user_topic_weakness
             SET total_questions = total_questions + 1,
                 wrong_answers = wrong_answers + ?,
                 last_updated = NOW()
             WHERE weakness_id = ?`,
            [isCorrect ? 0 : 1, existing[0].weakness_id]
          );
        } else {
          await pool.query(
            `INSERT INTO user_topic_weakness (user_id, subject_id, topic_id, total_questions, wrong_answers)
             VALUES (?, ?, ?, 1, ?)`,
            [userId, subjectId, topicId, isCorrect ? 0 : 1]
          );
        }
      }

      // Record answer for AI Analytics
      try {
        await aiAnalytics.recordAnswer(
          userId,
          questionId,
          selectedChoiceId,
          isCorrect,
          timeSpent || 60, // Default to 60 seconds if not provided
          'PRACTICE'
        );
      } catch (analyticsError) {
        console.error('Analytics recording error (non-fatal):', analyticsError.message);
      }
    }

    const score = Math.round((correct / total) * 100);

    res.json({
      score,
      correct,
      total,
      passed: score >= 75,
      results
    });
  } catch (error) {
    console.error('Submit practice set error:', error);
    res.status(500).json({ error: 'Failed to submit practice set' });
  }
});

// ============================================================================
// MOCK PREBOARD ENDPOINTS (for ADVANCE users)
// ============================================================================

// Get mock preboard exams
app.get('/api/mock-preboard', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.userId;

    // Check if user has ADVANCE subscription
    const [subscription] = await pool.query(
      `SELECT plan_name FROM user_subscriptions
       WHERE user_id = ? AND status = 'ACTIVE' AND end_date > NOW()`,
      [userId]
    );

    if (subscription.length === 0 || subscription[0].plan_name !== 'ADVANCE') {
      return res.status(403).json({
        error: 'ADVANCE subscription required',
        message: 'Mock Preboard exams are available for ADVANCE subscribers only'
      });
    }

    // Get available mock exams
    const [exams] = await pool.query(
      `SELECT
        e.exam_id,
        e.exam_code,
        e.exam_name,
        e.time_limit_minutes,
        e.questions_count,
        s.subject_code,
        s.subject_name,
        (SELECT COUNT(*) FROM user_mock_attempts uma WHERE uma.exam_id = e.exam_id AND uma.user_id = ?) as attempts
       FROM mock_preboard_exams e
       JOIN subjects s ON e.subject_id = s.subject_id
       WHERE e.is_active = TRUE
       ORDER BY s.subject_code`,
      [userId]
    );

    res.json({
      exams,
      total: exams.length
    });
  } catch (error) {
    console.error('Get mock preboard error:', error);
    res.status(500).json({ error: 'Failed to fetch mock preboard exams' });
  }
});

// Start a mock preboard exam
app.post('/api/mock-preboard/:examId/start', authenticateToken, async (req, res) => {
  try {
    const { examId } = req.params;
    const userId = req.user.userId;

    // Get exam details
    const [exam] = await pool.query(
      `SELECT e.*, s.subject_code
       FROM mock_preboard_exams e
       JOIN subjects s ON e.subject_id = s.subject_id
       WHERE e.exam_id = ?`,
      [examId]
    );

    if (exam.length === 0) {
      return res.status(404).json({ error: 'Exam not found' });
    }

    const examInfo = exam[0];

    // Get random questions for this subject (100 questions for mock preboard)
    const [questions] = await pool.query(
      `SELECT
        q.question_id,
        q.question_code,
        q.question_text,
        q.difficulty_level
       FROM questions q
       JOIN practice_sets ps ON q.practice_set_id = ps.practice_set_id
       JOIN topics t ON ps.topic_id = t.topic_id
       JOIN subjects s ON t.subject_id = s.subject_id
       WHERE s.subject_code = ? AND q.is_active = TRUE
       ORDER BY RAND()
       LIMIT ?`,
      [examInfo.subject_code, examInfo.questions_count]
    );

    // Get choices for each question (shuffled with dynamic labels)
    for (let question of questions) {
      const [choices] = await pool.query(
        `SELECT choice_id, choice_text
         FROM question_choices
         WHERE question_id = ? AND is_active = TRUE`,
        [question.question_id]
      );
      // Shuffle choices and assign dynamic labels (A, B, C, D)
      question.choices = assignChoiceLabels(choices);
    }

    // Create attempt record
    const [attempt] = await pool.query(
      `INSERT INTO user_mock_attempts (user_id, exam_id, started_at, status)
       VALUES (?, ?, NOW(), 'IN_PROGRESS')`,
      [userId, examId]
    );

    res.json({
      attempt_id: attempt.insertId,
      exam: {
        exam_id: examInfo.exam_id,
        exam_name: examInfo.exam_name,
        time_limit_minutes: examInfo.time_limit_minutes,
        subject_code: examInfo.subject_code
      },
      questions,
      total: questions.length,
      start_time: new Date().toISOString()
    });
  } catch (error) {
    console.error('Start mock preboard error:', error);
    res.status(500).json({ error: 'Failed to start mock preboard exam' });
  }
});

// Save progress (protected route)
app.post('/api/progress/save', authenticateToken, async (req, res) => {
  try {
    const { questionId, isCorrect, topicId } = req.body;
    const userId = req.user.userId;

    // For MVP, we'll track in user_topic_weakness table
    const [existing] = await pool.query(
      'SELECT weakness_id, total_questions, wrong_answers FROM user_topic_weakness WHERE user_id = ? AND topic_id = ?',
      [userId, topicId]
    );

    if (existing.length > 0) {
      await pool.query(
        `UPDATE user_topic_weakness
         SET total_questions = total_questions + 1,
             wrong_answers = wrong_answers + ?,
             last_updated = NOW()
         WHERE weakness_id = ?`,
        [isCorrect ? 0 : 1, existing[0].weakness_id]
      );
    } else {
      // Get subject_id from topic
      const [topic] = await pool.query('SELECT subject_id FROM topics WHERE topic_id = ?', [topicId]);
      const subjectId = topic[0]?.subject_id || 1;

      await pool.query(
        `INSERT INTO user_topic_weakness (user_id, subject_id, topic_id, total_questions, wrong_answers)
         VALUES (?, ?, ?, 1, ?)`,
        [userId, subjectId, topicId, isCorrect ? 0 : 1]
      );
    }

    res.json({ message: 'Progress saved' });
  } catch (error) {
    console.error('Save progress error:', error);
    res.status(500).json({ error: 'Failed to save progress' });
  }
});

// Get user stats (protected route)
app.get('/api/progress/stats', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.userId;

    // Get overall stats
    const [overallStats] = await pool.query(
      `SELECT
        COALESCE(SUM(total_questions), 0) as total_answered,
        COALESCE(SUM(total_questions - wrong_answers), 0) as total_correct,
        CASE
          WHEN SUM(total_questions) > 0
          THEN ROUND((SUM(total_questions - wrong_answers) / SUM(total_questions)) * 100, 1)
          ELSE 0
        END as accuracy_rate
      FROM user_topic_weakness
      WHERE user_id = ?`,
      [userId]
    );

    // Get stats by subject
    const [subjectStats] = await pool.query(
      `SELECT
        s.subject_code,
        s.subject_name,
        COALESCE(SUM(w.total_questions), 0) as attempted,
        CASE
          WHEN SUM(w.total_questions) > 0
          THEN ROUND((SUM(w.total_questions - w.wrong_answers) / SUM(w.total_questions)) * 100, 1)
          ELSE 0
        END as accuracy
      FROM subjects s
      LEFT JOIN topics t ON s.subject_id = t.subject_id
      LEFT JOIN user_topic_weakness w ON t.topic_id = w.topic_id AND w.user_id = ?
      GROUP BY s.subject_id, s.subject_code, s.subject_name
      ORDER BY s.display_order`,
      [userId]
    );

    // Calculate free questions remaining (50 free questions limit)
    const freeQuestionsRemaining = Math.max(0, 50 - (overallStats[0].total_answered || 0));

    res.json({
      overview: {
        total_answered: overallStats[0].total_answered || 0,
        total_correct: overallStats[0].total_correct || 0,
        accuracy_rate: overallStats[0].accuracy_rate || 0
      },
      bySubject: subjectStats,
      freeQuestionsRemaining
    });
  } catch (error) {
    console.error('Get stats error:', error);
    res.status(500).json({ error: 'Failed to fetch stats' });
  }
});

// Check free limit
app.get('/api/progress/check-limit', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.userId;

    const [stats] = await pool.query(
      'SELECT COALESCE(SUM(total_questions), 0) as total FROM user_topic_weakness WHERE user_id = ?',
      [userId]
    );

    const total = stats[0].total || 0;
    const hasReachedLimit = total >= 50;
    const remaining = Math.max(0, 50 - total);

    res.json({
      hasReachedLimit,
      remaining,
      total
    });
  } catch (error) {
    console.error('Check limit error:', error);
    res.status(500).json({ error: 'Failed to check limit' });
  }
});

// Get subjects list
app.get('/api/subjects', async (req, res) => {
  try {
    const [subjects] = await pool.query(
      `SELECT subject_id, subject_code, subject_name, display_order
       FROM subjects
       WHERE is_active = TRUE
       ORDER BY display_order`
    );

    res.json({ subjects });
  } catch (error) {
    console.error('Get subjects error:', error);
    res.status(500).json({ error: 'Failed to fetch subjects' });
  }
});

// ============================================================================
// PAYMENT & SUBSCRIPTION ROUTES
// ============================================================================

// Get all subscription plans
app.get('/api/plans', async (req, res) => {
  try {
    const [plans] = await pool.query(
      `SELECT plan_id, plan_code, plan_name, plan_description, billing_period,
              price_php, original_price_php, mcq_limit, features, display_order
       FROM subscription_plans
       WHERE is_active = TRUE
       ORDER BY display_order`
    );

    // Parse features JSON for each plan
    const parsedPlans = plans.map(plan => ({
      ...plan,
      features: typeof plan.features === 'string' ? JSON.parse(plan.features) : plan.features
    }));

    res.json({ plans: parsedPlans });
  } catch (error) {
    console.error('Get plans error:', error);
    res.status(500).json({ error: 'Failed to fetch subscription plans' });
  }
});

// Get payment providers
app.get('/api/payment/providers', async (req, res) => {
  try {
    const [providers] = await pool.query(
      `SELECT provider_id, provider_code, provider_name, instructions, icon_url
       FROM payment_provider_configs
       WHERE is_active = TRUE
       ORDER BY display_order`
    );

    res.json({ providers });
  } catch (error) {
    console.error('Get providers error:', error);
    res.status(500).json({ error: 'Failed to fetch payment providers' });
  }
});

// Validate promo code
app.post('/api/payment/validate-promo', async (req, res) => {
  try {
    const { code, planCode } = req.body;

    if (!code) {
      return res.status(400).json({ error: 'Promo code required' });
    }

    const [promos] = await pool.query(
      `SELECT promo_id, code, description, discount_type, discount_value,
              min_purchase, max_uses, times_used, applicable_plans
       FROM promo_codes
       WHERE code = ? AND is_active = TRUE
         AND (valid_from IS NULL OR valid_from <= CURDATE())
         AND (valid_until IS NULL OR valid_until >= CURDATE())`,
      [code.toUpperCase()]
    );

    if (promos.length === 0) {
      return res.status(404).json({ error: 'Invalid or expired promo code' });
    }

    const promo = promos[0];

    // Check max uses
    if (promo.max_uses && promo.times_used >= promo.max_uses) {
      return res.status(400).json({ error: 'Promo code has reached maximum usage' });
    }

    // Check applicable plans
    if (planCode && promo.applicable_plans) {
      const applicablePlans = typeof promo.applicable_plans === 'string'
        ? JSON.parse(promo.applicable_plans)
        : promo.applicable_plans;

      if (!applicablePlans.includes(planCode)) {
        return res.status(400).json({ error: 'Promo code not applicable to this plan' });
      }
    }

    res.json({
      valid: true,
      promo: {
        code: promo.code,
        description: promo.description,
        discountType: promo.discount_type,
        discountValue: parseFloat(promo.discount_value),
        minPurchase: parseFloat(promo.min_purchase || 0)
      }
    });
  } catch (error) {
    console.error('Validate promo error:', error);
    res.status(500).json({ error: 'Failed to validate promo code' });
  }
});

// Generate internal reference number
function generateReference() {
  const date = new Date();
  const dateStr = date.toISOString().slice(0, 10).replace(/-/g, '');
  const random = Math.random().toString(36).substring(2, 7).toUpperCase();
  return `CPALE-${dateStr}-${random}`;
}

// Create payment transaction (initiate payment)
app.post('/api/payment/create', authenticateToken, async (req, res) => {
  try {
    const { planCode, paymentProvider, promoCode } = req.body;
    const userId = req.user.userId;

    if (!planCode || !paymentProvider) {
      return res.status(400).json({ error: 'Plan and payment provider required' });
    }

    // Get plan details
    const [plans] = await pool.query(
      'SELECT plan_id, plan_code, plan_name, price_php, billing_period, mcq_limit FROM subscription_plans WHERE plan_code = ? AND is_active = TRUE',
      [planCode]
    );

    if (plans.length === 0) {
      return res.status(404).json({ error: 'Plan not found' });
    }

    const plan = plans[0];
    let amount = parseFloat(plan.price_php);
    let discountAmount = 0;

    // Apply promo code if provided
    if (promoCode) {
      const [promos] = await pool.query(
        `SELECT promo_id, discount_type, discount_value FROM promo_codes
         WHERE code = ? AND is_active = TRUE
           AND (valid_from IS NULL OR valid_from <= CURDATE())
           AND (valid_until IS NULL OR valid_until >= CURDATE())`,
        [promoCode.toUpperCase()]
      );

      if (promos.length > 0) {
        const promo = promos[0];
        if (promo.discount_type === 'PERCENTAGE') {
          discountAmount = amount * (parseFloat(promo.discount_value) / 100);
        } else {
          discountAmount = parseFloat(promo.discount_value);
        }

        // Update promo usage
        await pool.query('UPDATE promo_codes SET times_used = times_used + 1 WHERE promo_id = ?', [promo.promo_id]);
      }
    }

    const finalAmount = Math.max(0, amount - discountAmount);
    const internalReference = generateReference();

    // Calculate subscription dates
    const startDate = new Date();
    let endDate = new Date();

    switch (plan.billing_period) {
      case 'MONTHLY':
        endDate.setMonth(endDate.getMonth() + 1);
        break;
      case 'SEMI_ANNUAL':
        endDate.setMonth(endDate.getMonth() + 6);
        break;
      case 'ANNUAL':
        endDate.setFullYear(endDate.getFullYear() + 1);
        break;
      case 'LIFETIME':
        endDate.setFullYear(endDate.getFullYear() + 100);
        break;
    }

    // Create transaction record
    const [result] = await pool.query(
      `INSERT INTO payment_transactions_new
       (user_id, plan_id, amount_php, discount_amount, final_amount, payment_provider,
        internal_reference, status, subscription_start, subscription_end)
       VALUES (?, ?, ?, ?, ?, ?, ?, 'PENDING', ?, ?)`,
      [userId, plan.plan_id, amount, discountAmount, finalAmount, paymentProvider.toUpperCase(),
       internalReference, startDate, endDate]
    );

    // Get payment instructions
    const [providers] = await pool.query(
      'SELECT instructions FROM payment_provider_configs WHERE provider_code = ?',
      [paymentProvider.toUpperCase()]
    );

    res.status(201).json({
      message: 'Payment initiated',
      transaction: {
        transactionId: result.insertId,
        reference: internalReference,
        planName: plan.plan_name,
        amount: amount,
        discount: discountAmount,
        finalAmount: finalAmount,
        provider: paymentProvider,
        status: 'PENDING',
        instructions: providers[0]?.instructions || 'Please complete payment using your selected method.',
        subscriptionStart: startDate.toISOString().slice(0, 10),
        subscriptionEnd: endDate.toISOString().slice(0, 10)
      }
    });
  } catch (error) {
    console.error('Create payment error:', error);
    res.status(500).json({ error: 'Failed to create payment' });
  }
});

// Confirm payment (admin/manual verification for MVP)
app.post('/api/payment/confirm', authenticateToken, async (req, res) => {
  try {
    const { reference, externalReference } = req.body;
    const userId = req.user.userId;

    if (!reference) {
      return res.status(400).json({ error: 'Transaction reference required' });
    }

    // Get transaction
    const [transactions] = await pool.query(
      `SELECT t.*, p.plan_code, p.billing_period, p.mcq_limit
       FROM payment_transactions_new t
       JOIN subscription_plans p ON t.plan_id = p.plan_id
       WHERE t.internal_reference = ? AND t.user_id = ?`,
      [reference, userId]
    );

    if (transactions.length === 0) {
      return res.status(404).json({ error: 'Transaction not found' });
    }

    const transaction = transactions[0];

    if (transaction.status === 'COMPLETED') {
      return res.status(400).json({ error: 'Transaction already completed' });
    }

    // Update transaction status
    await pool.query(
      `UPDATE payment_transactions_new
       SET status = 'PROCESSING', external_reference = ?, updated_at = NOW()
       WHERE transaction_id = ?`,
      [externalReference || null, transaction.transaction_id]
    );

    res.json({
      message: 'Payment confirmation submitted for verification',
      status: 'PROCESSING',
      reference: reference
    });
  } catch (error) {
    console.error('Confirm payment error:', error);
    res.status(500).json({ error: 'Failed to confirm payment' });
  }
});

// Admin: Approve payment and activate subscription
app.post('/api/admin/payment/approve', authenticateToken, async (req, res) => {
  try {
    const { reference } = req.body;

    // For MVP, we'll skip admin role check - in production, verify user is admin
    // if (req.user.userType !== 'ADMIN') {
    //   return res.status(403).json({ error: 'Admin access required' });
    // }

    const [transactions] = await pool.query(
      `SELECT t.*, p.plan_code, p.billing_period, p.mcq_limit
       FROM payment_transactions_new t
       JOIN subscription_plans p ON t.plan_id = p.plan_id
       WHERE t.internal_reference = ?`,
      [reference]
    );

    if (transactions.length === 0) {
      return res.status(404).json({ error: 'Transaction not found' });
    }

    const transaction = transactions[0];

    // Update transaction to completed
    await pool.query(
      `UPDATE payment_transactions_new
       SET status = 'COMPLETED', completed_at = NOW(), updated_at = NOW()
       WHERE transaction_id = ?`,
      [transaction.transaction_id]
    );

    // Determine user type based on plan
    const userType = transaction.plan_code.startsWith('ADVANCE') ? 'ADVANCE' : 'BASIC';

    // Update user type
    await pool.query(
      'UPDATE users SET user_type = ? WHERE user_id = ?',
      [userType, transaction.user_id]
    );

    // Update or create subscription
    const [existingSub] = await pool.query(
      'SELECT subscription_id FROM user_subscriptions WHERE user_id = ? AND is_active = TRUE',
      [transaction.user_id]
    );

    if (existingSub.length > 0) {
      await pool.query(
        `UPDATE user_subscriptions
         SET plan_type = ?, plan_id = ?, billing_period = ?, subscription_status = 'ACTIVE',
             start_date = ?, end_date = ?, amount_paid = ?, payment_reference = ?,
             payment_provider = ?, updated_at = NOW()
         WHERE subscription_id = ?`,
        [userType, transaction.plan_id, transaction.billing_period,
         transaction.subscription_start, transaction.subscription_end,
         transaction.final_amount, transaction.internal_reference,
         transaction.payment_provider, existingSub[0].subscription_id]
      );
    } else {
      await pool.query(
        `INSERT INTO user_subscriptions
         (user_id, plan_type, plan_id, billing_period, subscription_status, start_date, end_date,
          amount_paid, payment_reference, payment_provider, is_active)
         VALUES (?, ?, ?, ?, 'ACTIVE', ?, ?, ?, ?, ?, TRUE)`,
        [transaction.user_id, userType, transaction.plan_id, transaction.billing_period,
         transaction.subscription_start, transaction.subscription_end,
         transaction.final_amount, transaction.internal_reference, transaction.payment_provider]
      );
    }

    res.json({
      message: 'Payment approved and subscription activated',
      userId: transaction.user_id,
      planCode: transaction.plan_code,
      subscriptionEnd: transaction.subscription_end
    });
  } catch (error) {
    console.error('Approve payment error:', error);
    res.status(500).json({ error: 'Failed to approve payment' });
  }
});

// Get user's subscription status
app.get('/api/subscription/status', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.userId;

    const [subscriptions] = await pool.query(
      `SELECT us.*, sp.plan_code, sp.plan_name, sp.mcq_limit, sp.features
       FROM user_subscriptions us
       LEFT JOIN subscription_plans sp ON us.plan_id = sp.plan_id
       WHERE us.user_id = ? AND us.is_active = TRUE
       ORDER BY us.created_at DESC
       LIMIT 1`,
      [userId]
    );

    if (subscriptions.length === 0) {
      // Return free plan status
      return res.json({
        subscription: {
          planType: 'FREE',
          planName: 'Free Plan',
          mcqLimit: 50,
          status: 'ACTIVE',
          features: { mcqs: 50, subjects: 6, practice_sets: false, mock_preboard: false }
        }
      });
    }

    const sub = subscriptions[0];
    res.json({
      subscription: {
        planType: sub.plan_type,
        planCode: sub.plan_code,
        planName: sub.plan_name,
        mcqLimit: sub.mcq_limit,
        status: sub.subscription_status,
        startDate: sub.start_date,
        endDate: sub.end_date,
        features: typeof sub.features === 'string' ? JSON.parse(sub.features) : sub.features,
        daysRemaining: sub.end_date ? Math.ceil((new Date(sub.end_date) - new Date()) / (1000 * 60 * 60 * 24)) : null
      }
    });
  } catch (error) {
    console.error('Get subscription status error:', error);
    res.status(500).json({ error: 'Failed to fetch subscription status' });
  }
});

// Get user's payment history
app.get('/api/payment/history', authenticateToken, async (req, res) => {
  try {
    const userId = req.user.userId;

    const [transactions] = await pool.query(
      `SELECT t.transaction_id, t.internal_reference, t.amount_php, t.discount_amount,
              t.final_amount, t.payment_provider, t.status, t.created_at, t.completed_at,
              p.plan_name, p.billing_period
       FROM payment_transactions_new t
       JOIN subscription_plans p ON t.plan_id = p.plan_id
       WHERE t.user_id = ?
       ORDER BY t.created_at DESC
       LIMIT 20`,
      [userId]
    );

    res.json({ transactions });
  } catch (error) {
    console.error('Get payment history error:', error);
    res.status(500).json({ error: 'Failed to fetch payment history' });
  }
});

// Redirect root to landing page
app.get('/', (req, res) => {
  res.redirect('/landing-page/');
});

// ============================================================================
// START SERVER
// ============================================================================
setupDatabase().then((success) => {
  if (success) {
    app.listen(PORT, () => {
      console.log('');
      console.log('========================================');
      console.log('   CPALE Explained - MVP Server');
      console.log('========================================');
      console.log(`API Server:     http://localhost:${PORT}`);
      console.log(`Landing Page:   http://localhost:${PORT}/landing-page/`);
      console.log(`Database:       ${process.env.DB_NAME}`);
      console.log(`Environment:    ${process.env.NODE_ENV}`);
      console.log('========================================');
      console.log('');
    });
  } else {
    console.error('Failed to start server - database connection failed');
    console.log('Make sure Docker MySQL container is running:');
    console.log('  docker-compose up -d');
    process.exit(1);
  }
});

// Graceful shutdown
process.on('SIGINT', async () => {
  console.log('\nShutting down gracefully...');
  if (pool) await pool.end();
  process.exit(0);
});
