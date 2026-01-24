/**
 * Email Notification Utilities
 * For subscription renewals and payment confirmations
 * 
 * Note: This is a simplified version using console.log
 * In production, integrate with actual email service (SendGrid, AWS SES, etc.)
 */

/**
 * Send renewal reminder email
 */
async function sendRenewalReminder(user, subscription, daysRemaining) {
  console.log('===== RENEWAL REMINDER EMAIL =====');
  console.log(`To: ${user.email}`);
  console.log(`Subject: Your CPALE Explained subscription expires in ${daysRemaining} days`);
  console.log(`
Dear ${user.displayName || 'Student'},

Your CPALE Explained subscription will expire in ${daysRemaining} days.

Subscription Details:
- Plan: ${subscription.plan_name}
- Expiry Date: ${new Date(subscription.end_date).toLocaleDateString()}
- Days Remaining: ${daysRemaining}

To continue your exam preparation without interruption, please renew your subscription:
${process.env.APP_URL || 'http://localhost:3000'}/landing-page/pricing.html

Don't lose access to:
- Unlimited MCQs
- Practice Sets
- Basic Analytics
- Email Support

Need help? Reply to this email or visit our support page.

Best regards,
CPALE Explained Team
  `);
  console.log('===================================');
  
  // TODO: Integrate with actual email service
  // Example with SendGrid:
  // const sgMail = require('@sendgrid/mail');
  // sgMail.setApiKey(process.env.SENDGRID_API_KEY);
  // await sgMail.send({
  //   to: user.email,
  //   from: 'noreply@cpaleexplained.com',
  //   subject: `Your CPALE Explained subscription expires in ${daysRemaining} days`,
  //   html: emailTemplate
  // });
  
  return { success: true, email: user.email };
}

/**
 * Send subscription expired notification
 */
async function sendSubscriptionExpired(user, subscription) {
  console.log('===== SUBSCRIPTION EXPIRED EMAIL =====');
  console.log(`To: ${user.email}`);
  console.log(`Subject: Your CPALE Explained subscription has expired`);
  console.log(`
Dear ${user.displayName || 'Student'},

Your CPALE Explained subscription has expired.

Your account has been downgraded to the FREE plan with access to:
- 50 MCQs across all subjects
- Basic progress tracking

To restore full access and continue your exam preparation:
${process.env.APP_URL || 'http://localhost:3000'}/landing-page/pricing.html

We hope to see you back soon!

Best regards,
CPALE Explained Team
  `);
  console.log('======================================');
  
  return { success: true, email: user.email };
}

/**
 * Send payment verification email
 */
async function sendPaymentVerified(user, payment, subscription) {
  console.log('===== PAYMENT VERIFIED EMAIL =====');
  console.log(`To: ${user.email}`);
  console.log(`Subject: Payment Verified - Subscription Activated!`);
  console.log(`
Dear ${user.displayName || 'Student'},

Great news! Your payment has been verified and your subscription is now active.

Payment Details:
- Amount: ₱${payment.amount}
- Reference: ${payment.transaction_ref}
- Payment Method: ${payment.payment_method}

Subscription Details:
- Plan: ${subscription.plan_name}
- Valid Until: ${new Date(subscription.end_date).toLocaleDateString()}

You now have full access to:
- Unlimited MCQs
- Practice Sets (75 MCQs each)
- Basic Analytics Dashboard
- Email Support

Start practicing: ${process.env.APP_URL || 'http://localhost:3000'}/landing-page/dashboard.html

Happy studying!

Best regards,
CPALE Explained Team
  `);
  console.log('===================================');
  
  return { success: true, email: user.email };
}

/**
 * Send payment uploaded notification (to user)
 */
async function sendPaymentProofReceived(user, payment) {
  console.log('===== PAYMENT PROOF RECEIVED EMAIL =====');
  console.log(`To: ${user.email}`);
  console.log(`Subject: Payment Proof Received - Under Verification`);
  console.log(`
Dear ${user.displayName || 'Student'},

Thank you for uploading your payment proof!

Payment Details:
- Reference Number: ${payment.transaction_ref}
- Amount: ₱${payment.amount}
- Payment Method: ${payment.payment_method}

Your payment is now under verification. We typically verify payments within 24 hours.

You'll receive another email once your payment is verified and your subscription is activated.

If you have any questions, please reply to this email with your reference number.

Best regards,
CPALE Explained Team
  `);
  console.log('========================================');
  
  return { success: true, email: user.email };
}

/**
 * Send admin notification for new payment
 */
async function notifyAdminNewPayment(payment, user) {
  console.log('===== ADMIN: NEW PAYMENT NOTIFICATION =====');
  console.log(`To: admin@cpaleexplained.com`);
  console.log(`Subject: New Payment Pending Verification`);
  console.log(`
New payment proof uploaded and pending verification:

User Details:
- Name: ${user.displayName || 'N/A'}
- Email: ${user.email}
- User ID: ${user.user_id}

Payment Details:
- Payment ID: ${payment.payment_id}
- Amount: ₱${payment.amount}
- Payment Method: ${payment.payment_method}
- Reference: ${payment.transaction_ref}
- Payer Name: ${payment.payer_name || 'N/A'}
- Contact: ${payment.payer_contact || 'N/A'}

Payment Proof: ${payment.payment_proof_url}

Verify Payment: ${process.env.APP_URL || 'http://localhost:3000'}/landing-page/admin.html

Please verify this payment as soon as possible.
  `);
  console.log('==========================================');
  
  return { success: true };
}

module.exports = {
  sendRenewalReminder,
  sendSubscriptionExpired,
  sendPaymentVerified,
  sendPaymentProofReceived,
  notifyAdminNewPayment
};
