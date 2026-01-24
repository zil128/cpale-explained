/**
 * Subscription Routes
 * Endpoints for managing user subscriptions
 */

const express = require('express');
const router = express.Router();
const { getAllPlans, getPlanByCode, calculateEndDate } = require('../config/plans');
const { 
  getUserSubscription, 
  getUserMCQUsage, 
  attachSubscription 
} = require('../middleware/subscriptionCheck');

// Database pool (will be injected via router configuration)
let pool = null;

/**
 * Set database pool
 * @param {object} dbPool - MySQL connection pool
 */
function setPool(dbPool) {
  pool = dbPool;
}

/**
 * GET /api/subscription/status
 * Get current user's subscription status
 * Requires authentication
 */
router.get('/status', attachSubscription, async (req, res) => {
  try {
    const subscription = req.user.subscription;
    const usage = req.user.usage;

    // Calculate remaining days for PAID users
    let daysRemaining = null;
    if (subscription.subscription_type === 'PAID' && subscription.end_date) {
      const endDate = new Date(subscription.end_date);
      const today = new Date();
      const diffTime = endDate - today;
      daysRemaining = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    }

    res.json({
      subscription_type: subscription.subscription_type,
      plan_code: subscription.plan_code,
      plan_name: subscription.plan_name,
      is_active: subscription.is_active,
      start_date: subscription.start_date,
      end_date: subscription.end_date,
      days_remaining: daysRemaining,
      mcq_limit: subscription.mcq_limit,
      mcqs_used: usage.mcqs_attempted || 0,
      mcqs_remaining: subscription.mcq_limit ? subscription.mcq_limit - (usage.mcqs_attempted || 0) : null,
      payment_reference: subscription.payment_reference,
      features: {
        practice_sets: subscription.subscription_type === 'PAID',
        unlimited_mcqs: subscription.subscription_type === 'PAID',
        analytics: 'basic',
        support: subscription.subscription_type === 'PAID' ? 'email' : 'community'
      }
    });
  } catch (error) {
    console.error('Get subscription status error:', error);
    res.status(500).json({ error: 'Failed to get subscription status' });
  }
});

/**
 * GET /api/subscription/plans
 * Get all available subscription plans
 */
router.get('/plans', (req, res) => {
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

/**
 * POST /api/subscription/upgrade
 * Upgrade user subscription (payment processed separately)
 * Requires authentication
 */
router.post('/upgrade', attachSubscription, async (req, res) => {
  try {
    const { plan_code } = req.body;

    if (!plan_code) {
      return res.status(400).json({ error: 'plan_code is required' });
    }

    const plan = getPlanByCode(plan_code);
    if (!plan) {
      return res.status(400).json({ error: 'Invalid plan code' });
    }

    if (plan_code === 'FREE') {
      return res.status(400).json({ error: 'Cannot upgrade to FREE plan' });
    }

    // Check if user already has active PAID subscription
    if (req.user.subscription.subscription_type === 'PAID' && req.user.subscription.is_active) {
      return res.status(400).json({ 
        error: 'You already have an active PAID subscription',
        current_plan: req.user.subscription.plan_code,
        end_date: req.user.subscription.end_date
      });
    }

    // Return upgrade information (actual upgrade happens after payment)
    const startDate = new Date();
    const endDate = calculateEndDate(startDate, plan_code);

    res.json({
      message: 'Ready to upgrade',
      plan: {
        code: plan.code,
        name: plan.name,
        price: plan.price,
        duration_days: plan.duration_days
      },
      subscription_details: {
        start_date: startDate.toISOString().split('T')[0],
        end_date: endDate ? endDate.toISOString().split('T')[0] : null,
        amount: plan.price
      },
      next_step: 'Complete payment to activate subscription'
    });
  } catch (error) {
    console.error('Upgrade subscription error:', error);
    res.status(500).json({ error: 'Failed to process upgrade' });
  }
});

/**
 * POST /api/subscription/activate
 * Activate PAID subscription after successful payment
 * Internal use - called by payment webhook
 */
router.post('/activate', async (req, res) => {
  try {
    if (!pool) {
      return res.status(500).json({ error: 'Database not initialized' });
    }

    const { user_id, plan_code, payment_reference, payment_provider, amount_paid } = req.body;

    if (!user_id || !plan_code || !payment_reference) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    const plan = getPlanByCode(plan_code);
    if (!plan) {
      return res.status(400).json({ error: 'Invalid plan code' });
    }

    // Get plan_id from database
    const [plans] = await pool.query(
      'SELECT plan_id FROM subscription_plans_v2 WHERE plan_code = ?',
      [plan_code]
    );

    if (plans.length === 0) {
      return res.status(404).json({ error: 'Plan not found in database' });
    }

    const plan_id = plans[0].plan_id;
    const startDate = new Date();
    const endDate = calculateEndDate(startDate, plan_code);

    // Update user subscription
    await pool.query(
      `UPDATE user_subscriptions_v2
      SET plan_id = ?,
          subscription_type = 'PAID',
          start_date = ?,
          end_date = ?,
          is_active = TRUE,
          payment_reference = ?,
          payment_provider = ?,
          amount_paid = ?,
          updated_at = NOW()
      WHERE user_id = ?`,
      [
        plan_id,
        startDate.toISOString().split('T')[0],
        endDate ? endDate.toISOString().split('T')[0] : null,
        payment_reference,
        payment_provider,
        amount_paid,
        user_id
      ]
    );

    // Reset MCQ usage counter for newly paid users
    await pool.query(
      `UPDATE user_mcq_usage
      SET mcqs_attempted = 0,
          last_reset_date = CURDATE(),
          updated_at = NOW()
      WHERE user_id = ?`,
      [user_id]
    );

    res.json({
      message: 'Subscription activated successfully',
      subscription: {
        type: 'PAID',
        plan_code,
        start_date: startDate.toISOString().split('T')[0],
        end_date: endDate ? endDate.toISOString().split('T')[0] : null,
        payment_reference
      }
    });
  } catch (error) {
    console.error('Activate subscription error:', error);
    res.status(500).json({ error: 'Failed to activate subscription' });
  }
});

/**
 * GET /api/subscription/usage
 * Get detailed MCQ usage statistics
 * Requires authentication
 */
router.get('/usage', attachSubscription, async (req, res) => {
  try {
    const subscription = req.user.subscription;
    const usage = req.user.usage;

    const mcqLimit = subscription.mcq_limit;
    const mcqsUsed = usage.mcqs_attempted || 0;
    const mcqsRemaining = mcqLimit ? Math.max(0, mcqLimit - mcqsUsed) : null;
    const usagePercentage = mcqLimit ? Math.min(100, (mcqsUsed / mcqLimit) * 100) : 0;

    res.json({
      subscription_type: subscription.subscription_type,
      mcq_limit: mcqLimit,
      mcqs_used: mcqsUsed,
      mcqs_remaining: mcqsRemaining,
      usage_percentage: Math.round(usagePercentage),
      unlimited_access: subscription.subscription_type === 'PAID',
      last_reset_date: usage.last_reset_date,
      can_attempt_more: subscription.subscription_type === 'PAID' || mcqsUsed < mcqLimit
    });
  } catch (error) {
    console.error('Get usage error:', error);
    res.status(500).json({ error: 'Failed to get usage statistics' });
  }
});

module.exports = router;
module.exports.setPool = setPool;
