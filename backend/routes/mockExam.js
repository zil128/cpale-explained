/**
 * Mock Exam Routes
 * API endpoints for mock preboard exam system
 */

const express = require('express');
const router = express.Router();
const mockExamService = require('../services/mockExamService');

/**
 * GET /api/mock-exam/list
 * Get list of available mock exams with user's attempts
 */
router.get('/list', async (req, res) => {
  try {
    const userId = req.user.userId;
    const exams = await mockExamService.getExamList(userId);
    
    res.json({
      exams,
      total: exams.length
    });
  } catch (error) {
    console.error('Get exam list error:', error);
    res.status(500).json({ error: 'Failed to get exam list' });
  }
});

/**
 * GET /api/mock-exam/in-progress
 * Check if user has an in-progress exam
 */
router.get('/in-progress', async (req, res) => {
  try {
    const userId = req.user.userId;
    const inProgress = await mockExamService.getInProgressExam(userId);
    
    res.json({
      hasInProgress: !!inProgress,
      exam: inProgress
    });
  } catch (error) {
    console.error('Check in-progress error:', error);
    res.status(500).json({ error: 'Failed to check in-progress exam' });
  }
});

/**
 * POST /api/mock-exam/:examId/start
 * Start a new mock exam attempt
 */
router.post('/:examId/start', async (req, res) => {
  try {
    const userId = req.user.userId;
    const examId = parseInt(req.params.examId);

    // Check for existing in-progress exam
    const inProgress = await mockExamService.getInProgressExam(userId);
    if (inProgress) {
      return res.status(400).json({
        error: 'You have an exam in progress',
        attemptId: inProgress.attemptId,
        examName: inProgress.examName,
        timeRemaining: inProgress.timeRemainingSeconds
      });
    }

    const result = await mockExamService.startExam(examId, userId);
    
    res.json({
      success: true,
      ...result
    });
  } catch (error) {
    console.error('Start exam error:', error);
    res.status(500).json({ error: error.message || 'Failed to start exam' });
  }
});

/**
 * GET /api/mock-exam/:attemptId/questions
 * Get questions for an in-progress exam
 */
router.get('/:attemptId/questions', async (req, res) => {
  try {
    const userId = req.user.userId;
    const attemptId = parseInt(req.params.attemptId);

    const result = await mockExamService.getExamQuestions(attemptId, userId);
    
    res.json(result);
  } catch (error) {
    console.error('Get questions error:', error);
    res.status(error.message.includes('not found') ? 404 : 500).json({ 
      error: error.message || 'Failed to get exam questions' 
    });
  }
});

/**
 * PUT /api/mock-exam/:attemptId/save
 * Auto-save answer for a question
 */
router.put('/:attemptId/save', async (req, res) => {
  try {
    const userId = req.user.userId;
    const attemptId = parseInt(req.params.attemptId);
    const { questionId, selectedChoiceId, timeSpent, isMarked } = req.body;

    if (!questionId) {
      return res.status(400).json({ error: 'questionId required' });
    }

    await mockExamService.saveAnswer(attemptId, userId, questionId, selectedChoiceId, timeSpent, isMarked);
    
    res.json({ saved: true });
  } catch (error) {
    console.error('Save answer error:', error);
    res.status(500).json({ error: error.message || 'Failed to save answer' });
  }
});

/**
 * PUT /api/mock-exam/:attemptId/save-bulk
 * Bulk save multiple answers
 */
router.put('/:attemptId/save-bulk', async (req, res) => {
  try {
    const userId = req.user.userId;
    const attemptId = parseInt(req.params.attemptId);
    const { answers } = req.body; // Array of { questionId, selectedChoiceId, timeSpent, isMarked }

    if (!answers || !Array.isArray(answers)) {
      return res.status(400).json({ error: 'answers array required' });
    }

    for (const answer of answers) {
      await mockExamService.saveAnswer(
        attemptId, 
        userId, 
        answer.questionId, 
        answer.selectedChoiceId, 
        answer.timeSpent, 
        answer.isMarked
      );
    }
    
    res.json({ saved: true, count: answers.length });
  } catch (error) {
    console.error('Bulk save error:', error);
    res.status(500).json({ error: error.message || 'Failed to save answers' });
  }
});

/**
 * POST /api/mock-exam/:attemptId/submit
 * Submit exam and get results
 */
router.post('/:attemptId/submit', async (req, res) => {
  try {
    const userId = req.user.userId;
    const attemptId = parseInt(req.params.attemptId);
    const { answers } = req.body; // Optional final answers

    const result = await mockExamService.submitExam(attemptId, userId, answers || []);
    
    res.json({
      success: true,
      ...result
    });
  } catch (error) {
    console.error('Submit exam error:', error);
    res.status(error.message.includes('already') ? 400 : 500).json({ 
      error: error.message || 'Failed to submit exam' 
    });
  }
});

/**
 * GET /api/mock-exam/:attemptId/results
 * Get detailed exam results
 */
router.get('/:attemptId/results', async (req, res) => {
  try {
    const userId = req.user.userId;
    const attemptId = parseInt(req.params.attemptId);

    const result = await mockExamService.getExamResults(attemptId, userId);
    
    res.json(result);
  } catch (error) {
    console.error('Get results error:', error);
    res.status(error.message.includes('not found') ? 404 : 500).json({ 
      error: error.message || 'Failed to get exam results' 
    });
  }
});

/**
 * GET /api/mock-exam/:attemptId/resume
 * Resume an in-progress exam
 */
router.get('/:attemptId/resume', async (req, res) => {
  try {
    const userId = req.user.userId;
    const attemptId = parseInt(req.params.attemptId);

    const result = await mockExamService.resumeExam(attemptId, userId);
    
    res.json(result);
  } catch (error) {
    console.error('Resume exam error:', error);
    res.status(error.message.includes('expired') ? 410 : 500).json({ 
      error: error.message || 'Failed to resume exam' 
    });
  }
});

module.exports = router;
