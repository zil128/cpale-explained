require('dotenv').config();
const express = require('express');
const cors = require('cors');
const path = require('path');
const { db } = require('./models');

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Serve static files
app.use(express.static(path.join(__dirname, 'public')));
app.use('/landing-page', express.static(path.join(__dirname, 'landing-page')));
app.use('/', express.static(path.join(__dirname, 'landing-page')));

// Basic API endpoints for testing
app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || 'development'
  });
});

app.get('/api/questions/tos', (req, res) => {
  try {
    const tos = require('./data/tos.json');
    res.json(tos);
  } catch (error) {
    res.status(500).json({ error: 'Failed to load TOS data' });
  }
});

app.get('/api/questions/stats', (req, res) => {
  try {
    const mockQuestions = require('./sample-questions.json');
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
  } catch (error) {
    res.status(500).json({ error: 'Failed to generate stats' });
  }
});

app.get('/api/questions/random', (req, res) => {
  try {
    const mockQuestions = require('./sample-questions.json');
    const count = parseInt(req.query.count) || 1;
    const questions = mockQuestions.slice(0, Math.min(count, mockQuestions.length));
    res.json(questions);
  } catch (error) {
    res.status(500).json({ error: 'Failed to get questions' });
  }
});

app.get('/api/questions/:subject', (req, res) => {
  try {
    const mockQuestions = require('./sample-questions.json');
    const { subject } = req.params;
    const filtered = mockQuestions.filter(q => q.subject === subject.toUpperCase());
    res.json(filtered);
  } catch (error) {
    res.status(500).json({ error: 'Failed to filter questions' });
  }
});

app.post('/api/questions/generate', async (req, res) => {
  try {
    const MCQGenerator = require('./services/MCQGenerator');
    const generator = new MCQGenerator();
    
    const { subject, topic, difficulty } = req.body;
    
    const question = await generator.generateMCQ(subject, topic, difficulty);
    res.status(201).json({
      message: 'Question generated successfully',
      question
    });
  } catch (error) {
    res.status(500).json({ error: 'Failed to generate question: ' + error.message });
  }
});

// Default route - serve index.html
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: 'Not found', path: req.path });
});

// Error handling
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Something went wrong!' });
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 CPALE MCQ Generator - Production Server`);
  console.log(`📊 Running on: http://localhost:${PORT}`);
  console.log(`🌐 Landing Pages:`);
  console.log(`   - Main: http://localhost:${PORT}/`);
  console.log(`   - Register: http://localhost:${PORT}/landing-page/register.html`);
  console.log(`   - Dashboard: http://localhost:${PORT}/landing-page/dashboard.html`);
  console.log(`   - Quiz: http://localhost:${PORT}/landing-page/quiz.html`);
  console.log(`🔗 API Endpoints:`);
  console.log(`   - GET /api/health`);
  console.log(`   - GET /api/questions/tos`);
  console.log(`   - GET /api/questions/stats`);
  console.log(`   - GET /api/questions/random`);
  console.log(`   - GET /api/questions/:subject`);
  console.log(`   - POST /api/questions/generate`);
  console.log(`🎉 Production Server Ready!`);
});

module.exports = app;