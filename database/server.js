// Database Configuration for CPALE Explained
const mysql = require('mysql2/promise');

// Database connection pool
const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'cpale_explained',
  port: process.env.DB_PORT || 3306,
  connectionLimit: 10,
  waitForConnections: true,
  acquireTimeout: 60000,
  queueLimit: 0,
  enableKeepAlive: true,
  keepAliveInitialDelay: 0,
  charset: 'utf8mb4',
  ssl: process.env.DB_SSL !== 'false',
  multipleStatements: true,
  reconnect: true,
  dateStrings: {
    DATE: 'YYYY-MM-DD HH:mm:ss',
    DATETIME: 'YYYY-MM-DD HH:mm:ss',
    TIMESTAMP: 'YYYY-MM-DD HH:mm:ss'
  }
});

// API URL constant
const API_URL = 'https://cpale-explained.com';

// Check authentication
const token = localStorage.getItem('token');
if (!token) {
  window.location.href = '/landing-page/login.html';
}

// Health check
app.get('/api/health', (req, res) => {
  console.log('❤️ Health check requested');
  res.json({ 
    status: 'OK', 
    message: 'CPALE Explained API is running',
    timestamp: new Date().toISOString(),
    routes: {
      landing: `${API_URL}/landing-page/`,
      login: `${API_URL}/landing-page/login.html`,
      register: `${API_URL}/landing-page/register.html`,
      dashboard: `${API_URL}/landing-page/dashboard.html`,
      quiz: `${API_URL}/landing-page/quiz.html`
    }
  });
});

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
  };
};

// ============================================================================
// SUBSCRIPTION ROUTES
// ============================================================================