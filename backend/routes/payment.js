/**
 * Payment Routes
 * Handles payment transactions, verification, and history
 */

const express = require('express');
const router = express.Router();
const multer = require('multer');
const path = require('path');
const fs = require('fs').promises;
const emailNotifications = require('../utils/emailNotifications');

// Database pool (will be injected)
let pool = null;

/**
 * Set database pool
 */
function setPool(dbPool) {
  pool = dbPool;
}

// Configure multer for payment proof uploads
const storage = multer.diskStorage({
  destination: async (req, file, cb) => {
    const uploadDir = path.join(__dirname, '../../uploads/payment-proofs');
    try {
      await fs.mkdir(uploadDir, { recursive: true });
      cb(null, uploadDir);
    } catch (error) {
      cb(error);
    }
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, `payment-${req.user.user_id}-${uniqueSuffix}${path.extname(file.originalname)}`);
  }
});

const upload = multer({
  storage: storage,
  limits: { fileSize: 5 * 1024 * 1024 }, // 5MB limit
  fileFilter: (req, file, cb) => {
    const allowedTypes = /jpeg|jpg|png|pdf/;
    const extname = allowedTypes.test(path.extname(file.originalname).toLowerCase());
    const mimetype = allowedTypes.test(file.mimetype);
    
    if (extname && mimetype) {
      return cb(null, true);
    } else {
      cb(new Error('Only images (JPEG, PNG) and PDF files are allowed'));
    }
  }
});

/**
 * GET /api/payment/methods
 * Get available payment methods and their details
 * Public endpoint
 */
router.get('/methods', async (req, res) => {
  try {
    const [methods] = await pool.execute(
      `SELECT payment_method, is_active, account_name, account_number, 
              bank_name, qr_code_url, instructions
       FROM payment_methods_config
       WHERE is_active = TRUE
       ORDER BY FIELD(payment_method, 'GCASH', 'PAYMAYA', 'BANK_TRANSFER')`
    );

    res.json({ methods });
  } catch (error) {
    console.error('Get payment methods error:', error);
    res.status(500).json({ error: 'Failed to get payment methods' });
  }
});

/**
 * POST /api/payment/initiate
 * Initiate a payment transaction
 * Requires authentication
 */
router.post('/initiate', async (req, res) => {
  try {
    const { plan_code, payment_method } = req.body;
    const userId = req.user.user_id;

    if (!plan_code || !payment_method) {
      return res.status(400).json({ error: 'plan_code and payment_method are required' });
    }

    // Get plan details
    const [plans] = await pool.execute(
      'SELECT * FROM subscription_plans_v2 WHERE plan_code = ?',
      [plan_code]
    );

    if (plans.length === 0) {
      return res.status(404).json({ error: 'Plan not found' });
    }

    const plan = plans[0];
    const amount = plan.price;

    // Generate reference number
    const referenceNumber = `CPALE-${Date.now()}-${userId}`;

    // Create payment transaction
    const [result] = await pool.execute(
      `INSERT INTO payment_transactions 
       (user_id, subscription_id, amount, currency, payment_method, payment_status, transaction_ref)
       VALUES (?, NULL, ?, 'PHP', ?, 'PENDING', ?)`,
      [userId, amount, payment_method, referenceNumber]
    );

    const paymentId = result.insertId;

    // Get payment method details
    const [methodDetails] = await pool.execute(
      'SELECT * FROM payment_methods_config WHERE payment_method = ?',
      [payment_method]
    );

    res.json({
      payment_id: paymentId,
      reference_number: referenceNumber,
      amount: amount,
      payment_method: payment_method,
      payment_details: methodDetails[0] || null,
      status: 'PENDING'
    });

  } catch (error) {
    console.error('Initiate payment error:', error);
    res.status(500).json({ error: 'Failed to initiate payment' });
  }
});

/**
 * POST /api/payment/:paymentId/upload-proof
 * Upload payment proof for manual verification
 * Requires authentication
 */
router.post('/:paymentId/upload-proof', upload.single('proof'), async (req, res) => {
  try {
    const { paymentId } = req.params;
    const { payer_name, payer_contact, payment_notes } = req.body;
    const userId = req.user.user_id;

    if (!req.file) {
      return res.status(400).json({ error: 'Payment proof file is required' });
    }

    // Verify payment belongs to user
    const [payments] = await pool.execute(
      'SELECT * FROM payment_transactions WHERE payment_id = ? AND user_id = ?',
      [paymentId, userId]
    );

    if (payments.length === 0) {
      return res.status(404).json({ error: 'Payment not found' });
    }

    const payment = payments[0];

    if (payment.payment_status !== 'PENDING') {
      return res.status(400).json({ error: 'Payment already processed' });
    }

    // Store file URL (relative path)
    const proofUrl = `/uploads/payment-proofs/${req.file.filename}`;

    // Update payment with proof
    await pool.execute(
      `UPDATE payment_transactions 
       SET payment_proof_url = ?, payer_name = ?, payer_contact = ?, 
           payment_notes = ?, payment_status = 'VERIFYING', updated_at = NOW()
       WHERE payment_id = ?`,
      [proofUrl, payer_name, payer_contact, payment_notes, paymentId]
    );

    // Get user details for notification
    const [users] = await pool.execute(
      'SELECT email, displayName FROM users WHERE user_id = ?',
      [userId]
    );

    if (users.length > 0) {
      // Send confirmation email to user
      await emailNotifications.sendPaymentProofReceived(users[0], payment);
      
      // Notify admin
      await emailNotifications.notifyAdminNewPayment(payment, users[0]);
    }

    res.json({
      message: 'Payment proof uploaded successfully',
      payment_id: paymentId,
      status: 'VERIFYING',
      estimated_verification_time: '24 hours'
    });

  } catch (error) {
    console.error('Upload proof error:', error);
    res.status(500).json({ error: 'Failed to upload payment proof' });
  }
});

/**
 * GET /api/payment/history
 * Get user's payment history
 * Requires authentication
 */
router.get('/history', async (req, res) => {
  try {
    const userId = req.user.user_id;

    const [payments] = await pool.execute(
      `SELECT payment_id, amount, currency, payment_method, payment_status,
              transaction_ref, payer_name, paid_at, created_at, verified_at
       FROM payment_transactions
       WHERE user_id = ?
       ORDER BY created_at DESC
       LIMIT 50`,
      [userId]
    );

    res.json({ payments });

  } catch (error) {
    console.error('Get payment history error:', error);
    res.status(500).json({ error: 'Failed to get payment history' });
  }
});

/**
 * GET /api/payment/:paymentId/status
 * Check payment status
 * Requires authentication
 */
router.get('/:paymentId/status', async (req, res) => {
  try {
    const { paymentId } = req.params;
    const userId = req.user.user_id;

    const [payments] = await pool.execute(
      `SELECT payment_id, amount, payment_method, payment_status,
              transaction_ref, created_at, verified_at, verification_notes
       FROM payment_transactions
       WHERE payment_id = ? AND user_id = ?`,
      [paymentId, userId]
    );

    if (payments.length === 0) {
      return res.status(404).json({ error: 'Payment not found' });
    }

    res.json({ payment: payments[0] });

  } catch (error) {
    console.error('Get payment status error:', error);
    res.status(500).json({ error: 'Failed to get payment status' });
  }
});

/**
 * ADMIN ENDPOINTS
 * These require admin authentication
 */

/**
 * GET /api/payment/admin/pending
 * Get all pending payments for verification
 * Requires admin authentication
 */
router.get('/admin/pending', async (req, res) => {
  try {
    // TODO: Add admin authentication check
    
    const [payments] = await pool.execute(
      `SELECT p.payment_id, p.user_id, u.email, u.displayName,
              p.amount, p.payment_method, p.payment_status,
              p.transaction_ref, p.payer_name, p.payer_contact,
              p.payment_proof_url, p.payment_notes, p.created_at
       FROM payment_transactions p
       JOIN users u ON p.user_id = u.user_id
       WHERE p.payment_status IN ('PENDING', 'VERIFYING')
       ORDER BY p.created_at ASC`
    );

    res.json({ payments });

  } catch (error) {
    console.error('Get pending payments error:', error);
    res.status(500).json({ error: 'Failed to get pending payments' });
  }
});

/**
 * POST /api/payment/admin/:paymentId/verify
 * Verify and approve a payment
 * Requires admin authentication
 */
router.post('/admin/:paymentId/verify', async (req, res) => {
  try {
    const { paymentId } = req.params;
    const { verification_notes, action } = req.body; // action: 'approve' or 'reject'
    const adminUserId = req.user.user_id; // TODO: Verify is admin

    if (!['approve', 'reject'].includes(action)) {
      return res.status(400).json({ error: 'Invalid action. Must be "approve" or "reject"' });
    }

    const connection = await pool.getConnection();
    
    try {
      await connection.beginTransaction();

      // Get payment details
      const [payments] = await connection.execute(
        'SELECT * FROM payment_transactions WHERE payment_id = ?',
        [paymentId]
      );

      if (payments.length === 0) {
        await connection.rollback();
        return res.status(404).json({ error: 'Payment not found' });
      }

      const payment = payments[0];

      if (action === 'approve') {
        // Update payment status
        await connection.execute(
          `UPDATE payment_transactions 
           SET payment_status = 'SUCCESS', verified_by = ?, verified_at = NOW(),
               verification_notes = ?, paid_at = NOW(), updated_at = NOW()
           WHERE payment_id = ?`,
          [adminUserId, verification_notes, paymentId]
        );

        // Get plan from amount (assuming P149 = PAID_MONTHLY)
        // In production, you'd store plan_code in payment_transactions
        const planCode = payment.amount === 149 ? 'PAID_MONTHLY' : 'FREE';

        // Get plan details
        const [plans] = await connection.execute(
          'SELECT * FROM subscription_plans_v2 WHERE plan_code = ?',
          [planCode]
        );

        if (plans.length > 0) {
          const plan = plans[0];
          
          // Calculate end date
          const endDate = new Date();
          endDate.setDate(endDate.getDate() + (plan.duration_days || 30));

          // Update user subscription
          await connection.execute(
            `UPDATE user_subscriptions_v2 
             SET plan_id = ?, subscription_type = 'PAID', is_active = TRUE,
                 start_date = NOW(), end_date = ?, updated_at = NOW()
             WHERE user_id = ?`,
            [plan.plan_id, endDate, payment.user_id]
          );

          // Update payment with subscription_id
          const [subs] = await connection.execute(
            'SELECT subscription_id FROM user_subscriptions_v2 WHERE user_id = ?',
            [payment.user_id]
          );
          
          if (subs.length > 0) {
            await connection.execute(
              'UPDATE payment_transactions SET subscription_id = ? WHERE payment_id = ?',
              [subs[0].subscription_id, paymentId]
            );

            // Log subscription history
            await connection.execute(
              `INSERT INTO subscription_history 
               (user_id, subscription_id, action_type, previous_plan_code, new_plan_code, payment_id, notes, changed_by)
               VALUES (?, ?, 'UPGRADED', 'FREE', ?, ?, 'Payment verified and approved', ?)`,
              [payment.user_id, subs[0].subscription_id, planCode, paymentId, adminUserId]
            );
          }
        }

      } else {
        // Reject payment
        await connection.execute(
          `UPDATE payment_transactions 
           SET payment_status = 'FAILED', verified_by = ?, verified_at = NOW(),
               verification_notes = ?, updated_at = NOW()
           WHERE payment_id = ?`,
          [adminUserId, verification_notes, paymentId]
        );
      }

      await connection.commit();

      // Send email notification if approved
      if (action === 'approve') {
        const [users] = await connection.execute(
          'SELECT email, displayName FROM users WHERE user_id = ?',
          [payment.user_id]
        );

        const [subs] = await connection.execute(
          `SELECT us.*, sp.plan_name 
           FROM user_subscriptions_v2 us
           JOIN subscription_plans_v2 sp ON us.plan_id = sp.plan_id
           WHERE us.user_id = ?`,
          [payment.user_id]
        );

        if (users.length > 0 && subs.length > 0) {
          await emailNotifications.sendPaymentVerified(users[0], payment, subs[0]);
        }
      }

      res.json({
        message: action === 'approve' ? 'Payment approved and subscription activated' : 'Payment rejected',
        payment_id: paymentId,
        status: action === 'approve' ? 'SUCCESS' : 'FAILED'
      });

    } catch (error) {
      await connection.rollback();
      throw error;
    } finally {
      connection.release();
    }

  } catch (error) {
    console.error('Verify payment error:', error);
    res.status(500).json({ error: 'Failed to verify payment' });
  }
});

module.exports = router;
module.exports.setPool = setPool;
