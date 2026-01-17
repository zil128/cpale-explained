require('dotenv').config();
const express = require('express');
const cors = require('cors');
const path = require('path');
const { db } = require('./models');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Serve static files
app.use(express.static(path.join(__dirname, 'public')));
app.use('/landing-page', express.static(path.join(__dirname, 'landing-page')));
app.use('/landing-page/', express.static(path.join(__dirname, 'landing-page')));

// API Routes
app.use('/api/auth', require('./routes/auth'));
app.use('/api/questions', require('./routes/questions'));
app.use('/api/analytics', require('./routes/analytics'));
app.use('/api/users', require('./routes/users'));

// Serve landing pages
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'landing-page', 'index.html'));
});

// Handle landing-page directory
app.get('/landing-page', (req, res) => {
  res.sendFile(path.join(__dirname, 'landing-page', 'index.html'));
});

app.get('/landing-page/', (req, res) => {
  res.sendFile(path.join(__dirname, 'landing-page', 'index.html'));
});

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Something went wrong!' });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: 'Not found' });
});

// Initialize database and start server
async function startServer() {
  try {
    // Try to initialize database, but continue if it fails
    try {
      await db.initialize();
      console.log('Database initialized successfully');
    } catch (dbError) {
      console.warn('Database initialization failed, starting server anyway:', dbError.message);
    }
    
    app.listen(PORT, () => {
      console.log(`🚀 CPALE MCQ Generator running on http://localhost:${PORT}`);
      console.log(`📊 Landing pages available at:`);
      console.log(`   - http://localhost:${PORT}/`);
      console.log(`   - http://localhost:${PORT}/landing-page/register.html`);
      console.log(`   - http://localhost:${PORT}/landing-page/dashboard.html`);
      console.log(`   - http://localhost:${PORT}/landing-page/quiz.html`);
    });
  } catch (error) {
    console.error('Failed to start server:', error);
    process.exit(1);
  }
}

startServer();

module.exports = app;