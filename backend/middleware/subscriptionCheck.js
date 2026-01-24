/**
 * Subscription Check Middleware
 * Verifies user subscription status and access levels
 */

const mysql = require('mysql2/promise');
const { isSubscriptionExpired, getMCQLimit } = require('../config/plans');

// Database pool (will be injected via setPool function)
let pool = null;

/**
 * Set database pool
 * @param {object} dbPool - MySQL connection pool
 */
function setPool(dbPool) {
  pool = dbPool;
}

/**
 * Get user subscription status from database
 * @param {number} userId - User ID
 * @returns {object|null} Subscription object or null
 */
async function getUserSubscription(userId) {
  if (!pool) {
    throw new Error('Database pool not initialized');
  }

  const [subscriptions] = await pool.query(
    `SELECT 
      usv.subscription_id,
      usv.user_id,
      usv.plan_id,
      usv.subscription_type,
      usv.start_date,
      usv.end_date,
      usv.is_active,
      usv.payment_reference,
      sp.plan_code,
      sp.plan_name,
      sp.price_php,
      sp.duration_days,
      sp.mcq_limit
    FROM user_subscriptions_v2 usv
    JOIN subscription_plans_v2 sp ON usv.plan_id = sp.plan_id
    WHERE usv.user_id = ?
    ORDER BY usv.created_at DESC
    LIMIT 1`,
    [userId]
  );

  if (subscriptions.length === 0) {
    return null;
  }

  const subscription = subscriptions[0];

  // Check if expired and update if needed
  if (isSubscriptionExpired(subscription) && subscription.subscription_type === 'PAID') {
    await downgradeToFree(userId);
    subscription.subscription_type = 'FREE';
    subscription.is_active = false;
  }

  return subscription;
}

/**
 * Get user MCQ usage stats
 * @param {number} userId - User ID
 * @returns {object} Usage stats
 */
async function getUserMCQUsage(userId) {
  if (!pool) {
    throw new Error('Database pool not initialized');
  }

  const [usage] = await pool.query(
    `SELECT mcqs_attempted, last_reset_date
    FROM user_mcq_usage
    WHERE user_id = ?`,
    [userId]
  );

  if (usage.length === 0) {
    // Initialize usage if not exists
    await pool.query(
      `INSERT INTO user_mcq_usage (user_id, mcqs_attempted, last_reset_date)
      VALUES (?, 0, CURDATE())`,
      [userId]
    );
    return { mcqs_attempted: 0, last_reset_date: new Date() };
  }

  return usage[0];
}

/**
 * Downgrade user to FREE plan
 * @param {number} userId - User ID
 */
async function downgradeToFree(userId) {
  if (!pool) {
    throw new Error('Database pool not initialized');
  }

  const [freePlan] = await pool.query(
    `SELECT plan_id FROM subscription_plans_v2 WHERE plan_code = 'FREE'`
  );

  if (freePlan.length === 0) {
    throw new Error('FREE plan not found in database');
  }

  await pool.query(
    `UPDATE user_subscriptions_v2
    SET plan_id = ?,
        subscription_type = 'FREE',
        is_active = FALSE,
        end_date = NULL,
        updated_at = NOW()
    WHERE user_id = ?`,
    [freePlan[0].plan_id, userId]
  );
}

/**
 * Middleware: Attach subscription to request object
 * Usage: app.get('/api/endpoint', authenticateToken, attachSubscription, handler)
 */
async function attachSubscription(req, res, next) {
  try {
    if (!req.user || !req.user.userId) {
      return res.status(401).json({ error: 'User not authenticated' });
    }

    const subscription = await getUserSubscription(req.user.userId);
    const usage = await getUserMCQUsage(req.user.userId);

    req.user.subscription = subscription || {
      subscription_type: 'FREE',
      plan_code: 'FREE',
      mcq_limit: 50
    };
    req.user.usage = usage;

    next();
  } catch (error) {
    console.error('Subscription check error:', error);
    res.status(500).json({ error: 'Failed to check subscription status' });
  }
}

/**
 * Middleware: Require PAID subscription
 * Usage: app.get('/api/paid-only', authenticateToken, requirePaidPlan, handler)
 */
async function requirePaidPlan(req, res, next) {
  try {
    if (!req.user || !req.user.subscription) {
      await attachSubscription(req, res, () => {});
    }

    if (req.user.subscription.subscription_type !== 'PAID') {
      return res.status(403).json({
        error: 'This feature requires a PAID subscription',
        required_plan: 'PAID',
        upgrade_url: '/pricing.html'
      });
    }

    // Check if expired
    if (isSubscriptionExpired(req.user.subscription)) {
      return res.status(403).json({
        error: 'Your PAID subscription has expired',
        required_plan: 'PAID',
        upgrade_url: '/pricing.html'
      });
    }

    next();
  } catch (error) {
    console.error('Paid plan check error:', error);
    res.status(500).json({ error: 'Failed to verify subscription' });
  }
}

/**
 * Middleware: Check MCQ limit for FREE users
 * Usage: app.get('/api/questions', authenticateToken, checkMCQLimit, handler)
 */
async function checkMCQLimit(req, res, next) {
  try {
    if (!req.user || !req.user.subscription) {
      await attachSubscription(req, res, () => {});
    }

    // PAID users have unlimited access
    if (req.user.subscription.subscription_type === 'PAID') {
      req.user.hasUnlimitedAccess = true;
      return next();
    }

    // FREE users have limit
    const limit = getMCQLimit('FREE');
    const used = req.user.usage.mcqs_attempted || 0;

    if (used >= limit) {
      return res.status(403).json({
        error: `You have reached your FREE MCQ limit (${limit} questions)`,
        mcqs_attempted: used,
        mcq_limit: limit,
        upgrade_message: 'Upgrade to PAID for unlimited access',
        upgrade_url: '/pricing.html'
      });
    }

    req.user.hasUnlimitedAccess = false;
    req.user.remainingMCQs = limit - used;

    next();
  } catch (error) {
    console.error('MCQ limit check error:', error);
    res.status(500).json({ error: 'Failed to check MCQ limit' });
  }
}

/**
 * Increment MCQ usage counter
 * @param {number} userId - User ID
 * @param {number} count - Number of MCQs attempted (default: 1)
 */
async function incrementMCQUsage(userId, count = 1) {
  if (!pool) {
    throw new Error('Database pool not initialized');
  }

  await pool.query(
    `UPDATE user_mcq_usage
    SET mcqs_attempted = mcqs_attempted + ?,
        updated_at = NOW()
    WHERE user_id = ?`,
    [count, userId]
  );
}

module.exports = {
  setPool,
  getUserSubscription,
  getUserMCQUsage,
  attachSubscription,
  requirePaidPlan,
  checkMCQLimit,
  incrementMCQUsage,
  downgradeToFree
};
