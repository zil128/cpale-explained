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

// Mock data for testing without database
const mockQuestions = require('../sample-questions.json');

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || 'development'
  });
});

// Mock question endpoints
app.get('/api/questions/random', (req, res) => {
  const count = parseInt(req.query.count) || 1;
  const questions = mockQuestions.slice(0, Math.min(count, mockQuestions.length));
  res.json(questions);
});

app.get('/api/questions/:subject', (req, res) => {
  const { subject } = req.params;
  const filtered = mockQuestions.filter(q => q.subject === subject.toUpperCase());
  res.json(filtered);
});

app.get('/api/questions/search/:term', (req, res) => {
  const { term } = req.params;
  const results = mockQuestions.filter(q => 
    q.question_text.toLowerCase().includes(term.toLowerCase()) ||
    q.topic.toLowerCase().includes(term.toLowerCase())
  );
  res.json(results);
});

app.get('/api/questions/stats', (req, res) => {
  const stats = {};
  mockQuestions.forEach(q => {
    if (!stats[q.subject]) {
      stats[q.subject] = { Easy: 0, Medium: 0, Difficult: 0, Tricky: 0 };
    }
    stats[q.subject][q.difficulty_level]++;
  });
  
  const result = [];
  Object.entries(stats).forEach(([subject, difficulties]) => {
    Object.entries(difficulties).forEach(([difficulty, count]) => {
      result.push({
        subject,
        difficulty_level: difficulty,
        count
      });
    });
  });
  
  res.json(result);
});

app.get('/api/questions/tos', (req, res) => {
  const tos = require('./src/data/tos.json');
  res.json(tos);
});

// Serve landing pages
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'landing-page', 'index.html'));
});

// Error handling
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Something went wrong!' });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: 'Not found', path: req.path });
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 CPALE MCQ Generator running on http://localhost:${PORT}`);
  console.log(`📊 Landing pages available at:`);
  console.log(`   - http://localhost:${PORT}/`);
  console.log(`   - http://localhost:${PORT}/landing-page/register.html`);
  console.log(`   - http://localhost:${PORT}/landing-page/dashboard.html`);
  console.log(`   - http://localhost:${PORT}/landing-page/quiz.html`);
  console.log(`🔗 API Endpoints available at:`);
  console.log(`   - GET /api/health`);
  console.log(`   - GET /api/questions/random`);
  console.log(`   - GET /api/questions/:subject`);
  console.log(`   - GET /api/questions/search/:term`);
  console.log(`   - GET /api/questions/stats`);
  console.log(`   - GET /api/questions/tos`);
});

module.exports = app;