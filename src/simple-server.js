const express = require('express');
const app = express();
const cors = require('cors');
const path = require('path');
require('dotenv').config();

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Serve static files
app.use(express.static(path.join(__dirname, 'public')));
app.use('/landing-page', express.static(path.join(__dirname, 'landing-page')));

// Basic routes for testing
app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
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

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`🚀 CPALE MCQ Generator running on http://localhost:${PORT}`);
  console.log(`📊 Landing pages available at:`);
  console.log(`   - http://localhost:${PORT}/`);
  console.log(`   - http://localhost:${PORT}/landing-page/register.html`);
  console.log(`   - http://localhost:${PORT}/landing-page/dashboard.html`);
  console.log(`   - http://localhost:${PORT}/landing-page/quiz.html`);
});

module.exports = app;