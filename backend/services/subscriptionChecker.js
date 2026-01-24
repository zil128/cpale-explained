/**
 * Subscription Checker Service
 * Checks for expiring/expired subscriptions and sends reminders
 */

const emailNotifications = require('../utils/emailNotifications');

class SubscriptionChecker {
  constructor(pool) {
    this.pool = pool;
    this.isRunning = false;
  }

  /**
   * Check for subscriptions expiring soon and send reminders
   */
  async checkExpiringSubscriptions() {
    try {
      console.log('[SubscriptionChecker] Checking for expiring subscriptions...');

      // Get subscriptions expiring in 7, 3, and 1 days
      const [expiringSubscriptions] = await this.pool.execute(`
        SELECT 
          us.subscription_id,
          us.user_id,
          us.plan_id,
          us.end_date,
          DATEDIFF(us.end_date, NOW()) AS days_remaining,
          u.email,
          u.display_name AS displayName,
          sp.plan_name,
          sp.plan_code
        FROM user_subscriptions_v2 us
        JOIN users u ON us.user_id = u.user_id
        JOIN subscription_plans_v2 sp ON us.plan_id = sp.plan_id
        WHERE us.subscription_type = 'PAID'
          AND us.is_active = TRUE
          AND us.end_date IS NOT NULL
          AND DATEDIFF(us.end_date, NOW()) IN (7, 3, 1)
      `);

      console.log(`[SubscriptionChecker] Found ${expiringSubscriptions.length} subscriptions expiring soon`);

      // Check if reminders already sent today
      for (const sub of expiringSubscriptions) {
        const reminderSent = await this.wasReminderSentToday(sub.user_id, sub.days_remaining);
        
        if (!reminderSent) {
          await emailNotifications.sendRenewalReminder(
            { email: sub.email, displayName: sub.displayName },
            { plan_name: sub.plan_name, end_date: sub.end_date },
            sub.days_remaining
          );

          // Log reminder sent
          await this.logReminderSent(sub.user_id, sub.subscription_id, sub.days_remaining);
          
          console.log(`[SubscriptionChecker] Sent ${sub.days_remaining}-day reminder to ${sub.email}`);
        }
      }

      return { checked: expiringSubscriptions.length };
    } catch (error) {
      console.error('[SubscriptionChecker] Error checking expiring subscriptions:', error);
      throw error;
    }
  }

  /**
   * Check for expired subscriptions and downgrade to FREE
   */
  async checkExpiredSubscriptions() {
    try {
      console.log('[SubscriptionChecker] Checking for expired subscriptions...');

      const connection = await this.pool.getConnection();
      
      try {
        await connection.beginTransaction();

        // Get expired subscriptions that are still active
        const [expiredSubscriptions] = await connection.execute(`
          SELECT 
            us.subscription_id,
            us.user_id,
            us.plan_id,
            us.end_date,
            u.email,
            u.display_name AS displayName,
            sp.plan_name,
            sp.plan_code
          FROM user_subscriptions_v2 us
          JOIN users u ON us.user_id = u.user_id
          JOIN subscription_plans_v2 sp ON us.plan_id = sp.plan_id
          WHERE us.subscription_type = 'PAID'
            AND us.is_active = TRUE
            AND us.end_date IS NOT NULL
            AND us.end_date < NOW()
        `);

        console.log(`[SubscriptionChecker] Found ${expiredSubscriptions.length} expired subscriptions`);

        for (const sub of expiredSubscriptions) {
          // Get FREE plan
          const [freePlans] = await connection.execute(
            'SELECT * FROM subscription_plans_v2 WHERE plan_code = ?',
            ['FREE']
          );

          if (freePlans.length > 0) {
            const freePlan = freePlans[0];

            // Downgrade to FREE
            await connection.execute(`
              UPDATE user_subscriptions_v2 
              SET plan_id = ?,
                  subscription_type = 'FREE',
                  is_active = TRUE,
                  end_date = NULL,
                  updated_at = NOW()
              WHERE subscription_id = ?
            `, [freePlan.plan_id, sub.subscription_id]);

            // Log subscription history
            await connection.execute(`
              INSERT INTO subscription_history 
              (user_id, subscription_id, action_type, previous_plan_code, new_plan_code, notes)
              VALUES (?, ?, 'EXPIRED', ?, 'FREE', 'Subscription expired and downgraded to FREE plan')
            `, [sub.user_id, sub.subscription_id, sub.plan_code]);

            // Send notification
            await emailNotifications.sendSubscriptionExpired(
              { email: sub.email, displayName: sub.displayName },
              { plan_name: sub.plan_name, end_date: sub.end_date }
            );

            console.log(`[SubscriptionChecker] Downgraded user ${sub.email} to FREE plan`);
          }
        }

        await connection.commit();

        return { expired: expiredSubscriptions.length };
      } catch (error) {
        await connection.rollback();
        throw error;
      } finally {
        connection.release();
      }
    } catch (error) {
      console.error('[SubscriptionChecker] Error checking expired subscriptions:', error);
      throw error;
    }
  }

  /**
   * Check if reminder was already sent today
   */
  async wasReminderSentToday(userId, daysRemaining) {
    const [reminders] = await this.pool.execute(`
      SELECT * FROM renewal_reminders
      WHERE user_id = ?
        AND days_before_expiry = ?
        AND DATE(sent_at) = CURDATE()
    `, [userId, daysRemaining]);

    return reminders.length > 0;
  }

  /**
   * Log that a reminder was sent
   */
  async logReminderSent(userId, subscriptionId, daysRemaining) {
    try {
      await this.pool.execute(`
        INSERT INTO renewal_reminders 
        (user_id, subscription_id, days_before_expiry, sent_at)
        VALUES (?, ?, ?, NOW())
      `, [userId, subscriptionId, daysRemaining]);
    } catch (error) {
      // Table might not exist - create it
      await this.createReminderTable();
      // Retry
      await this.pool.execute(`
        INSERT INTO renewal_reminders 
        (user_id, subscription_id, days_before_expiry, sent_at)
        VALUES (?, ?, ?, NOW())
      `, [userId, subscriptionId, daysRemaining]);
    }
  }

  /**
   * Create renewal_reminders table if it doesn't exist
   */
  async createReminderTable() {
    await this.pool.execute(`
      CREATE TABLE IF NOT EXISTS renewal_reminders (
        reminder_id INT AUTO_INCREMENT PRIMARY KEY,
        user_id BIGINT(20) NOT NULL,
        subscription_id INT NOT NULL,
        days_before_expiry INT NOT NULL,
        sent_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        INDEX idx_user_id (user_id),
        INDEX idx_sent_at (sent_at),
        FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    `);
  }

  /**
   * Run all checks
   */
  async runAllChecks() {
    if (this.isRunning) {
      console.log('[SubscriptionChecker] Already running, skipping...');
      return;
    }

    this.isRunning = true;
    console.log('[SubscriptionChecker] Starting subscription checks...');

    try {
      const expiringResult = await this.checkExpiringSubscriptions();
      const expiredResult = await this.checkExpiredSubscriptions();

      console.log('[SubscriptionChecker] Checks completed:', {
        expiring: expiringResult.checked,
        expired: expiredResult.expired
      });

      return {
        success: true,
        expiring: expiringResult.checked,
        expired: expiredResult.expired
      };
    } catch (error) {
      console.error('[SubscriptionChecker] Error running checks:', error);
      return {
        success: false,
        error: error.message
      };
    } finally {
      this.isRunning = false;
    }
  }

  /**
   * Start periodic checking (every 6 hours)
   */
  startPeriodicChecks(intervalHours = 6) {
    console.log(`[SubscriptionChecker] Starting periodic checks every ${intervalHours} hours`);
    
    // Run immediately
    this.runAllChecks();
    
    // Then run periodically
    this.intervalId = setInterval(() => {
      this.runAllChecks();
    }, intervalHours * 60 * 60 * 1000);
  }

  /**
   * Stop periodic checking
   */
  stopPeriodicChecks() {
    if (this.intervalId) {
      clearInterval(this.intervalId);
      console.log('[SubscriptionChecker] Stopped periodic checks');
    }
  }
}

module.exports = SubscriptionChecker;
