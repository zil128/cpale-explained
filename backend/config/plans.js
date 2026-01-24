/**
 * Subscription Plans Configuration
 * MVP Phase 1: FREE vs PAID
 */

const PLANS = {
  FREE: {
    code: 'FREE',
    name: 'Free Plan',
    description: '50 FREE MCQs across all 6 subjects with unlimited repetition',
    price: 0,
    duration_days: null, // Unlimited
    mcq_limit: 50,
    features: {
      mcqs: 50,
      subjects: 6,
      practice_sets: false,
      mock_preboard: false,
      analytics: 'basic',
      support: 'community'
    },
    display_order: 1
  },

  PAID_MONTHLY: {
    code: 'PAID_MONTHLY',
    name: 'Paid Monthly',
    description: 'Access to ALL MCQs, Practice Sets, and Basic Analytics for 30 days',
    price: 149,
    duration_days: 30,
    mcq_limit: null, // Unlimited
    features: {
      mcqs: 'unlimited',
      subjects: 6,
      practice_sets: true,
      practice_set_size: 75,
      mock_preboard: false,
      analytics: 'basic',
      support: 'email'
    },
    display_order: 2
  }
};

/**
 * Get plan configuration by code
 * @param {string} planCode - Plan code ('FREE' or 'PAID_MONTHLY')
 * @returns {object|null} Plan configuration or null if not found
 */
function getPlanByCode(planCode) {
  return PLANS[planCode] || null;
}

/**
 * Get all available plans
 * @returns {array} Array of plan objects
 */
function getAllPlans() {
  return Object.values(PLANS).sort((a, b) => a.display_order - b.display_order);
}

/**
 * Check if user has access to a feature
 * @param {object} subscription - User subscription object
 * @param {string} feature - Feature name
 * @returns {boolean} True if user has access
 */
function hasFeatureAccess(subscription, feature) {
  if (!subscription) return false;
  
  const planCode = subscription.subscription_type === 'FREE' ? 'FREE' : 'PAID_MONTHLY';
  const plan = PLANS[planCode];
  
  if (!plan) return false;
  
  return plan.features[feature] === true || plan.features[feature] === 'unlimited';
}

/**
 * Get MCQ limit for a subscription type
 * @param {string} subscriptionType - 'FREE' or 'PAID'
 * @returns {number|null} MCQ limit or null for unlimited
 */
function getMCQLimit(subscriptionType) {
  const planCode = subscriptionType === 'FREE' ? 'FREE' : 'PAID_MONTHLY';
  const plan = PLANS[planCode];
  return plan ? plan.mcq_limit : 50; // Default to FREE limit
}

/**
 * Calculate subscription end date
 * @param {Date} startDate - Subscription start date
 * @param {string} planCode - Plan code
 * @returns {Date|null} End date or null for unlimited
 */
function calculateEndDate(startDate, planCode) {
  const plan = PLANS[planCode];
  if (!plan || !plan.duration_days) return null;
  
  const endDate = new Date(startDate);
  endDate.setDate(endDate.getDate() + plan.duration_days);
  return endDate;
}

/**
 * Check if subscription is expired
 * @param {object} subscription - User subscription object
 * @returns {boolean} True if expired
 */
function isSubscriptionExpired(subscription) {
  if (!subscription) return true;
  if (subscription.subscription_type === 'FREE') return false;
  if (!subscription.end_date) return false;
  
  const endDate = new Date(subscription.end_date);
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  
  return endDate < today;
}

module.exports = {
  PLANS,
  getPlanByCode,
  getAllPlans,
  hasFeatureAccess,
  getMCQLimit,
  calculateEndDate,
  isSubscriptionExpired
};
