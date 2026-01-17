const express = require('express');
const router = express.Router();
const { mcqModel } = require('../models');
const MCQGenerator = require('../services/MCQGenerator');

const generator = new MCQGenerator();

// Get random questions
router.get('/random', async (req, res) => {
  try {
    const { subject, difficulty, count = 1 } = req.query;
    
    const filters = {};
    if (subject) filters.subject = subject;
    if (difficulty) filters.difficulty_level = difficulty;
    filters.limit = parseInt(count);
    
    const questions = await mcqModel.getRandom(filters);
    
    // Parse JSON fields for each question
    const parsedQuestions = questions.map(q => ({
      ...q,
      choices: JSON.parse(q.choices),
      why_wrong_choices: JSON.parse(q.why_wrong_choices),
      standards_reference: JSON.parse(q.standards_reference || '[]'),
      tags: JSON.parse(q.tags || '[]'),
      latin_breakdown: JSON.parse(q.latin_breakdown || '{}'),
      elements_checklist: JSON.parse(q.elements_checklist || '[]'),
      references: JSON.parse(q.references || '[]')
    }));
    
    res.json(parsedQuestions);
  } catch (error) {
    console.error('Error fetching random questions:', error);
    res.status(500).json({ error: 'Failed to fetch questions' });
  }
});

// Get questions by subject
router.get('/:subject', async (req, res) => {
  try {
    const { subject } = req.params;
    const { topic, difficulty, count = 10 } = req.query;
    
    const filters = { subject };
    if (topic) filters.topic = topic;
    if (difficulty) filters.difficulty_level = difficulty;
    filters.limit = parseInt(count);
    
    const questions = await mcqModel.getRandom(filters);
    
    // Parse JSON fields
    const parsedQuestions = questions.map(q => ({
      ...q,
      choices: JSON.parse(q.choices),
      why_wrong_choices: JSON.parse(q.why_wrong_choices),
      standards_reference: JSON.parse(q.standards_reference || '[]'),
      tags: JSON.parse(q.tags || '[]'),
      latin_breakdown: JSON.parse(q.latin_breakdown || '{}'),
      elements_checklist: JSON.parse(q.elements_checklist || '[]'),
      references: JSON.parse(q.references || '[]')
    }));
    
    res.json(parsedQuestions);
  } catch (error) {
    console.error('Error fetching subject questions:', error);
    res.status(500).json({ error: 'Failed to fetch questions' });
  }
});

// Search questions
router.get('/search/:term', async (req, res) => {
  try {
    const { term } = req.params;
    const { subject, difficulty, count = 10 } = req.query;
    
    const filters = {};
    if (subject) filters.subject = subject;
    if (difficulty) filters.difficulty_level = difficulty;
    filters.limit = parseInt(count);
    
    const questions = await mcqModel.search(term, filters);
    
    // Parse JSON fields
    const parsedQuestions = questions.map(q => ({
      ...q,
      choices: JSON.parse(q.choices),
      why_wrong_choices: JSON.parse(q.why_wrong_choices),
      standards_reference: JSON.parse(q.standards_reference || '[]'),
      tags: JSON.parse(q.tags || '[]'),
      latin_breakdown: JSON.parse(q.latin_breakdown || '{}'),
      elements_checklist: JSON.parse(q.elements_checklist || '[]'),
      references: JSON.parse(q.references || '[]')
    }));
    
    res.json(parsedQuestions);
  } catch (error) {
    console.error('Error searching questions:', error);
    res.status(500).json({ error: 'Failed to search questions' });
  }
});

// Get question by ID
router.get('/id/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const question = await mcqModel.findById(id);
    
    if (!question) {
      return res.status(404).json({ error: 'Question not found' });
    }
    
    // Parse JSON fields
    const parsedQuestion = {
      ...question,
      choices: JSON.parse(question.choices),
      why_wrong_choices: JSON.parse(question.why_wrong_choices),
      standards_reference: JSON.parse(question.standards_reference || '[]'),
      tags: JSON.parse(question.tags || '[]'),
      latin_breakdown: JSON.parse(question.latin_breakdown || '{}'),
      elements_checklist: JSON.parse(question.elements_checklist || '[]'),
      references: JSON.parse(question.references || '[]')
    };
    
    res.json(parsedQuestion);
  } catch (error) {
    console.error('Error fetching question:', error);
    res.status(500).json({ error: 'Failed to fetch question' });
  }
});

// Generate new question (for testing/admin)
router.post('/generate', async (req, res) => {
  try {
    const { subject, topic, difficulty } = req.body;
    
    if (!subject || !topic || !difficulty) {
      return res.status(400).json({ error: 'Subject, topic, and difficulty are required' });
    }
    
    // Get topic info from TOS
    const tos = require('../data/tos.json');
    const subjectInfo = tos.subjects.find(s => s.code === subject);
    
    if (!subjectInfo) {
      return res.status(400).json({ error: 'Invalid subject' });
    }
    
    let topicInfo = null;
    
    // Search in topics
    if (subjectInfo.topics) {
      topicInfo = subjectInfo.topics.find(t => t.code === topic);
    }
    
    // Search in sections
    if (!topicInfo && subjectInfo.sections) {
      for (const section of subjectInfo.sections) {
        if (section.topics) {
          topicInfo = section.topics.find(t => t.code === topic);
          if (topicInfo) break;
        }
      }
    }
    
    if (!topicInfo) {
      return res.status(400).json({ error: 'Invalid topic' });
    }
    
    // Generate question
    const question = await generator.generateMCQ(subject, topicInfo, difficulty);
    
    // Save to database
    const questionId = await mcqModel.create(question);
    
    res.status(201).json({
      message: 'Question generated successfully',
      questionId,
      question
    });
  } catch (error) {
    console.error('Error generating question:', error);
    res.status(500).json({ error: 'Failed to generate question' });
  }
});

// Get statistics
router.get('/stats', async (req, res) => {
  try {
    const stats = await mcqModel.getStats();
    res.json(stats);
  } catch (error) {
    console.error('Error fetching stats:', error);
    res.status(500).json({ error: 'Failed to fetch statistics' });
  }
});

// Get TOS information
router.get('/tos', async (req, res) => {
  try {
    const tos = require('../data/tos.json');
    res.json(tos);
  } catch (error) {
    console.error('Error fetching TOS:', error);
    res.status(500).json({ error: 'Failed to fetch TOS' });
  }
});

module.exports = router;