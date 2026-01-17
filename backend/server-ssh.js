// server-ssh.js - Backend Server with SSH Tunnel for CPALE Explained
require('dotenv').config();
const express = require('express');
const mysql = require('mysql2/promise');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { createTunnel } = require('tunnel-ssh');

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors({
  origin: process.env.FRONTEND_URL || 'http://localhost:3000',
  credentials: true
}));
app.use(express.json());

// SSH Tunnel Configuration
const sshConfig = {
  host: process.env.SSH_HOST,
  port: process.env.SSH_PORT || 22,
  username: process.env.SSH_USER,
  password: process.env.SSH_PASSWORD
};

const forwardConfig = {
  srcAddr: '127.0.0.1',
  srcPort: 3307, // Local port to forward from (use 3307 to avoid conflict)
  dstAddr: '127.0.0.1', // MySQL on remote server
  dstPort: 3306 // MySQL port on remote server
};

let tunnel = null;
let pool = null;

// Create SSH Tunnel and MySQL Connection
async function setupConnection() {
  try {
    console.log('🔐 Creating SSH tunnel...');
    
    // Create SSH tunnel
    [tunnel] = await createTunnel(
      { autoClose: true },
      { port: forwardConfig.srcPort },
      sshConfig,
      { dstAddr: forwardConfig.dstAddr, dstPort: forwardConfig.dstPort }
    );

    console.log('✅ SSH tunnel established!');

    // Create MySQL connection pool through tunnel
    pool = mysql.createPool({
      host: '127.0.0.1',
      port: forwardConfig.srcPort, // Connect to local forwarded port
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
      waitForConnections: true,
      connectionLimit: 10,
      queueLimit: 0
    });

    // Test connection
    const connection = await pool.getConnection();
    console.log('✅ Database connected successfully through SSH tunnel!');
    connection.release();

    return true;
  } catch (error) {
    console.error('❌ Connection setup failed:', error.message);
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
    sshTunnel: tunnel ? 'Connected' : 'Disconnected',
    timestamp: new Date().toISOString()
  });
});

// Subscribe email
app.post('/api/subscribe', async (req, res) => {
  try {
    const { email, firstName, source = 'WEBSITE' } = req.body;

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
       VALUES (?, ?, ?, FALSE)`,
      [email, firstName || null, source]
    );

    res.status(201).json({
      message: 'Successfully subscribed!',
      subscriberId: result.insertId
    });
  } catch (error) {
    console.error('Subscribe error:', error);
    res.status(500).json({ error: 'Failed to subscribe' });
  }
});

// Register new user
app.post('/api/auth/register', async (req, res) => {
  try {
    const { email, password, displayName } = req.body;

    if (!email || !password) {
      return res.status(400).json({ error: 'Email and password required' });
    }

    const [existing] = await pool.query(
      'SELECT user_id FROM users WHERE email = ?',
      [email]
    );

    if (existing.length > 0) {
      return res.status(400).json({ error: 'Email already registered' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const [result] = await pool.query(
      `INSERT INTO users (email, display_name, user_type, is_active) 
       VALUES (?, ?, 'FREE', TRUE)`,
      [email, displayName || email.split('@')[0]]
    );

    const userId = result.insertId;

    await pool.query(
      `INSERT INTO user_subscriptions (user_id, plan_type, subscription_status, start_date, is_active)
       VALUES (?, 'FREE', 'ACTIVE', NOW(), TRUE)`,
      [userId]
    );

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

// Get FREE questions
app.get('/api/questions/free', async (req, res) => {
  try {
    const [questions] = await pool.query(
      `SELECT 
        q.question_id,
        q.question_code,
        q.question_text,
        q.difficulty_level,
        t.topic_name,
        s.subject_name
      FROM questions q
      JOIN topics t ON q.topic_id = t.topic_id
      JOIN subjects s ON t.subject_id = s.subject_id
      WHERE q.access_level = 'FREE' 
        AND q.is_active = TRUE
      ORDER BY q.question_id
      LIMIT 50`
    );

    for (let question of questions) {
      const [choices] = await pool.query(
        `SELECT choice_id, choice_label, choice_text
         FROM question_choices
         WHERE question_id = ? AND is_active = TRUE
         ORDER BY display_order`,
        [question.question_id]
      );
      question.choices = choices;
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

// Get explanation
app.get('/api/questions/:questionId/explanation', async (req, res) => {
  try {
    const { questionId } = req.params;

    const [explanations] = await pool.query(
      `SELECT 
        e.short_explanation,
        e.exam_explanation,
        e.why_wrong_choices,
        e.memory_tip,
        c.choice_label as correct_answer
      FROM question_explanations e
      JOIN questions q ON e.question_id = q.question_id
      JOIN question_choices c ON q.question_id = c.question_id AND c.is_correct = TRUE
      WHERE e.question_id = ? AND e.is_active = TRUE`,
      [questionId]
    );

    if (explanations.length === 0) {
      return res.status(404).json({ error: 'Explanation not found' });
    }

    res.json(explanations[0]);
  } catch (error) {
    console.error('Get explanation error:', error);
    res.status(500).json({ error: 'Failed to fetch explanation' });
  }
});

// ============================================================================
// START SERVER
// ============================================================================
setupConnection().then((success) => {
  if (success) {
    app.listen(PORT, () => {
      console.log(`🚀 CPALE Explained API running on http://localhost:${PORT}`);
      console.log(`📚 Database: ${process.env.DB_NAME}`);
      console.log(`🔐 SSH Tunnel: ${process.env.SSH_HOST}`);
      console.log(`🌍 Environment: ${process.env.NODE_ENV}`);
    });
  } else {
    console.error('❌ Failed to start server');
    process.exit(1);
  }
});

// Graceful shutdown
process.on('SIGINT', async () => {
  console.log('\n🛑 Shutting down gracefully...');
  if (pool) await pool.end();
  if (tunnel) tunnel.close();
  process.exit(0);
});