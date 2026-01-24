/**
 * Analytics Routes
 * Admin-only endpoints for dashboard statistics and metrics
 */

const express = require('express');
const router = express.Router();

// Database pool (will be injected)
let pool = null;

function setPool(dbPool) {
  pool = dbPool;
}

/**
 * GET /api/analytics/overview
 * Get dashboard overview statistics
 * Requires admin authentication
 */
router.get('/overview', async (req, res) => {
  try {
    // Total users
    const [totalUsers] = await pool.execute('SELECT COUNT(*) as count FROM users');
    
    // Paid subscribers (active)
    const [paidUsers] = await pool.execute(`
      SELECT COUNT(*) as count 
      FROM user_subscriptions_v2 
      WHERE subscription_type = 'PAID' AND is_active = TRUE
    `);
    
    // Monthly revenue (current month)
    const [monthlyRevenue] = await pool.execute(`
      SELECT COALESCE(SUM(amount), 0) as total
      FROM payment_transactions
      WHERE payment_status = 'SUCCESS'
        AND YEAR(paid_at) = YEAR(CURDATE())
        AND MONTH(paid_at) = MONTH(CURDATE())
    `);
    
    // Pending payments
    const [pendingPayments] = await pool.execute(`
      SELECT COUNT(*) as count
      FROM payment_transactions
      WHERE payment_status IN ('PENDING', 'VERIFYING')
    `);

    // Total revenue (all time)
    const [totalRevenue] = await pool.execute(`
      SELECT COALESCE(SUM(amount), 0) as total
      FROM payment_transactions
      WHERE payment_status = 'SUCCESS'
    `);

    res.json({
      total_users: totalUsers[0].count,
      paid_subscribers: paidUsers[0].count,
      free_users: totalUsers[0].count - paidUsers[0].count,
      monthly_revenue: parseFloat(monthlyRevenue[0].total),
      total_revenue: parseFloat(totalRevenue[0].total),
      pending_payments: pendingPayments[0].count
    });

  } catch (error) {
    console.error('Get analytics overview error:', error);
    res.status(500).json({ error: 'Failed to get analytics overview' });
  }
});

/**
 * GET /api/analytics/conversion
 * Get conversion metrics
 * Requires admin authentication
 */
router.get('/conversion', async (req, res) => {
  try {
    // Total conversions (users who upgraded from FREE to PAID)
    const [conversions] = await pool.execute(`
      SELECT COUNT(*) as total_conversions,
             AVG(days_until_conversion) as avg_days_to_convert
      FROM conversion_tracking
      WHERE conversion_date IS NOT NULL
    `);

    // Conversion rate
    const [totalUsers] = await pool.execute('SELECT COUNT(*) as count FROM users');
    const conversionCount = conversions[0].total_conversions || 0;
    const totalCount = totalUsers[0].count || 1;
    const conversionRate = (conversionCount / totalCount) * 100;

    // Recent conversions (last 7 days)
    const [recentConversions] = await pool.execute(`
      SELECT COUNT(*) as count
      FROM conversion_tracking
      WHERE conversion_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
    `);

    // Conversions by week (last 4 weeks)
    const [weeklyConversions] = await pool.execute(`
      SELECT 
        WEEK(conversion_date) as week_number,
        COUNT(*) as conversions
      FROM conversion_tracking
      WHERE conversion_date >= DATE_SUB(CURDATE(), INTERVAL 4 WEEK)
      GROUP BY WEEK(conversion_date)
      ORDER BY WEEK(conversion_date) DESC
    `);

    res.json({
      total_conversions: conversionCount,
      conversion_rate: parseFloat(conversionRate.toFixed(2)),
      avg_days_to_convert: parseFloat(conversions[0].avg_days_to_convert || 0).toFixed(1),
      recent_conversions_7d: recentConversions[0].count,
      weekly_trend: weeklyConversions
    });

  } catch (error) {
    console.error('Get conversion metrics error:', error);
    res.status(500).json({ error: 'Failed to get conversion metrics' });
  }
});

/**
 * GET /api/analytics/revenue
 * Get revenue breakdown
 * Requires admin authentication
 */
router.get('/revenue', async (req, res) => {
  try {
    const { period = 'month' } = req.query; // month, week, year

    let dateFormat, dateCondition;
    switch (period) {
      case 'week':
        dateFormat = 'DATE(paid_at)';
        dateCondition = 'paid_at >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)';
        break;
      case 'year':
        dateFormat = 'DATE_FORMAT(paid_at, "%Y-%m")';
        dateCondition = 'paid_at >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)';
        break;
      default: // month
        dateFormat = 'DATE(paid_at)';
        dateCondition = 'YEAR(paid_at) = YEAR(CURDATE()) AND MONTH(paid_at) = MONTH(CURDATE())';
    }

    // Revenue over time
    const [revenueData] = await pool.execute(`
      SELECT 
        ${dateFormat} as date,
        COUNT(*) as payment_count,
        SUM(amount) as revenue
      FROM payment_transactions
      WHERE payment_status = 'SUCCESS' AND ${dateCondition}
      GROUP BY ${dateFormat}
      ORDER BY date ASC
    `);

    // Revenue by payment method
    const [byMethod] = await pool.execute(`
      SELECT 
        payment_method,
        COUNT(*) as payment_count,
        SUM(amount) as revenue
      FROM payment_transactions
      WHERE payment_status = 'SUCCESS'
      GROUP BY payment_method
    `);

    res.json({
      period: period,
      revenue_over_time: revenueData,
      revenue_by_method: byMethod
    });

  } catch (error) {
    console.error('Get revenue metrics error:', error);
    res.status(500).json({ error: 'Failed to get revenue metrics' });
  }
});

/**
 * GET /api/analytics/subscriptions
 * Get subscription statistics
 * Requires admin authentication
 */
router.get('/subscriptions', async (req, res) => {
  try {
    // Active subscriptions by type
    const [byType] = await pool.execute(`
      SELECT 
        subscription_type,
        COUNT(*) as count
      FROM user_subscriptions_v2
      WHERE is_active = TRUE
      GROUP BY subscription_type
    `);

    // Expiring soon (next 7 days)
    const [expiringSoon] = await pool.execute(`
      SELECT 
        u.user_id,
        u.email,
        u.displayName,
        us.end_date,
        DATEDIFF(us.end_date, NOW()) as days_remaining
      FROM user_subscriptions_v2 us
      JOIN users u ON us.user_id = u.user_id
      WHERE us.subscription_type = 'PAID'
        AND us.is_active = TRUE
        AND us.end_date IS NOT NULL
        AND DATEDIFF(us.end_date, NOW()) BETWEEN 0 AND 7
      ORDER BY us.end_date ASC
    `);

    // Recent subscription changes
    const [recentChanges] = await pool.execute(`
      SELECT 
        sh.action_type,
        sh.previous_plan_code,
        sh.new_plan_code,
        sh.created_at,
        u.email,
        u.displayName
      FROM subscription_history sh
      JOIN users u ON sh.user_id = u.user_id
      ORDER BY sh.created_at DESC
      LIMIT 10
    `);

    // Churn rate (subscriptions that expired in last 30 days)
    const [churnData] = await pool.execute(`
      SELECT COUNT(*) as churned_count
      FROM subscription_history
      WHERE action_type = 'EXPIRED'
        AND created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
    `);

    res.json({
      subscriptions_by_type: byType,
      expiring_soon: expiringSoon,
      recent_changes: recentChanges,
      churned_last_30_days: churnData[0].churned_count
    });

  } catch (error) {
    console.error('Get subscription stats error:', error);
    res.status(500).json({ error: 'Failed to get subscription statistics' });
  }
});

/**
 * GET /api/analytics/users
 * Get user engagement statistics
 * Requires admin authentication
 */
router.get('/users', async (req, res) => {
  try {
    // New users by period
    const [newUsers] = await pool.execute(`
      SELECT 
        DATE(created_at) as date,
        COUNT(*) as new_users
      FROM users
      WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
      GROUP BY DATE(created_at)
      ORDER BY date DESC
    `);

    // User activity (from conversion_tracking)
    const [activityStats] = await pool.execute(`
      SELECT 
        AVG(total_mcqs_attempted) as avg_mcqs_attempted,
        AVG(total_sessions) as avg_sessions
      FROM conversion_tracking
    `);

    // Most active users
    const [activeUsers] = await pool.execute(`
      SELECT 
        u.user_id,
        u.email,
        u.displayName,
        ct.total_mcqs_attempted,
        ct.total_sessions,
        us.subscription_type
      FROM users u
      JOIN conversion_tracking ct ON u.user_id = ct.user_id
      LEFT JOIN user_subscriptions_v2 us ON u.user_id = us.user_id
      ORDER BY ct.total_mcqs_attempted DESC
      LIMIT 10
    `);

    res.json({
      new_users_last_30_days: newUsers,
      avg_mcqs_attempted: parseFloat(activityStats[0].avg_mcqs_attempted || 0).toFixed(1),
      avg_sessions: parseFloat(activityStats[0].avg_sessions || 0).toFixed(1),
      most_active_users: activeUsers
    });

  } catch (error) {
    console.error('Get user stats error:', error);
    res.status(500).json({ error: 'Failed to get user statistics' });
  }
});

/**
 * GET /api/analytics/dashboard
 * Get all dashboard data in one request
 * Requires admin authentication
 */
router.get('/dashboard', async (req, res) => {
  try {
    // Run all queries in parallel for better performance
    const [overview, conversion, subscriptions] = await Promise.all([
      // Overview stats
      (async () => {
        const [totalUsers] = await pool.execute('SELECT COUNT(*) as count FROM users');
        const [paidUsers] = await pool.execute(`
          SELECT COUNT(*) as count 
          FROM user_subscriptions_v2 
          WHERE subscription_type = 'PAID' AND is_active = TRUE
        `);
        const [monthlyRevenue] = await pool.execute(`
          SELECT COALESCE(SUM(amount), 0) as total
          FROM payment_transactions
          WHERE payment_status = 'SUCCESS'
            AND YEAR(paid_at) = YEAR(CURDATE())
            AND MONTH(paid_at) = MONTH(CURDATE())
        `);
        const [pendingPayments] = await pool.execute(`
          SELECT COUNT(*) as count
          FROM payment_transactions
          WHERE payment_status IN ('PENDING', 'VERIFYING')
        `);

        return {
          total_users: totalUsers[0].count,
          paid_subscribers: paidUsers[0].count,
          monthly_revenue: parseFloat(monthlyRevenue[0].total),
          pending_payments: pendingPayments[0].count
        };
      })(),

      // Conversion metrics
      (async () => {
        const [conversions] = await pool.execute(`
          SELECT COUNT(*) as total_conversions,
                 AVG(days_until_conversion) as avg_days_to_convert
          FROM conversion_tracking
          WHERE conversion_date IS NOT NULL
        `);
        const [totalUsers] = await pool.execute('SELECT COUNT(*) as count FROM users');
        const conversionRate = ((conversions[0].total_conversions || 0) / (totalUsers[0].count || 1)) * 100;

        return {
          total_conversions: conversions[0].total_conversions || 0,
          conversion_rate: parseFloat(conversionRate.toFixed(2)),
          avg_days_to_convert: parseFloat(conversions[0].avg_days_to_convert || 0).toFixed(1)
        };
      })(),

      // Recent subscriptions
      (async () => {
        const [recent] = await pool.execute(`
          SELECT 
            sh.action_type,
            sh.new_plan_code,
            sh.created_at,
            u.email,
            u.displayName
          FROM subscription_history sh
          JOIN users u ON sh.user_id = u.user_id
          WHERE sh.action_type IN ('CREATED', 'UPGRADED', 'RENEWED')
          ORDER BY sh.created_at DESC
          LIMIT 5
        `);
        return recent;
      })()
    ]);

    res.json({
      overview,
      conversion,
      recent_subscriptions: subscriptions
    });

  } catch (error) {
    console.error('Get dashboard data error:', error);
    res.status(500).json({ error: 'Failed to get dashboard data' });
  }
});

module.exports = router;
module.exports.setPool = setPool;
