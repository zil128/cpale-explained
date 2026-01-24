/**
 * Create Paid User Script
 * 
 * This script creates a paid user for E2E testing via API endpoints.
 * It registers a new user, activates PAID subscription, and verifies the setup.
 * 
 * Usage: node scripts/create-paid-user.js
 * 
 * Prerequisites:
 *   - Backend server must be running on localhost:5000
 *   - Database must be connected and migrations applied
 */

const BASE_URL = process.env.API_URL || 'http://localhost:5000';

// Test user configuration
const TEST_USER = {
  email: 'testpaid@example.com',
  password: 'Test123!',
  displayName: 'Test Paid User'
};

// PAID plan configuration
const PAID_PLAN = {
  plan_code: 'PAID_MONTHLY',
  payment_reference: `TEST-MANUAL-${Date.now()}`,
  payment_provider: 'MANUAL',
  amount_paid: 149.00
};

/**
 * Make HTTP request using native fetch
 */
async function apiRequest(endpoint, options = {}) {
  const url = `${BASE_URL}${endpoint}`;
  const response = await fetch(url, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      ...options.headers
    }
  });
  
  const data = await response.json();
  
  if (!response.ok) {
    throw new Error(data.error || `HTTP ${response.status}: ${response.statusText}`);
  }
  
  return data;
}

/**
 * Step 1: Register a new user
 */
async function registerUser() {
  console.log('\n[1/5] Registering user...');
  
  try {
    const result = await apiRequest('/api/auth/register', {
      method: 'POST',
      body: JSON.stringify({
        email: TEST_USER.email,
        password: TEST_USER.password,
        displayName: TEST_USER.displayName
      })
    });
    
    console.log(`  ✓ User registered: ${result.user.email}`);
    console.log(`  ✓ User ID: ${result.user.userId}`);
    
    return {
      userId: result.user.userId,
      token: result.token,
      user: result.user
    };
  } catch (error) {
    // If user already exists, try to login instead
    if (error.message.includes('already registered')) {
      console.log('  ! User already exists, attempting login...');
      return await loginUser();
    }
    throw error;
  }
}

/**
 * Login existing user (fallback if user exists)
 */
async function loginUser() {
  const result = await apiRequest('/api/auth/login', {
    method: 'POST',
    body: JSON.stringify({
      email: TEST_USER.email,
      password: TEST_USER.password
    })
  });
  
  console.log(`  ✓ Logged in as: ${result.user.email}`);
  console.log(`  ✓ User ID: ${result.user.userId}`);
  
  return {
    userId: result.user.userId,
    token: result.token,
    user: result.user
  };
}

/**
 * Step 2: Check and activate PAID subscription
 */
async function activateSubscription(userId, token) {
  console.log('\n[2/5] Checking/Activating PAID subscription...');
  
  // First check if already PAID
  try {
    const status = await apiRequest('/api/subscription/status', {
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${token}`
      }
    });
    
    if (status.subscription_type === 'PAID' && status.is_active) {
      console.log(`  ✓ Already PAID subscription active`);
      console.log(`  ✓ Plan: ${status.plan_code}`);
      console.log(`  ✓ Valid until: ${status.end_date}`);
      console.log(`  ✓ Days remaining: ${status.days_remaining}`);
      return { subscription: status, alreadyPaid: true };
    }
  } catch (e) {
    // Continue to activate if status check fails
  }
  
  // Activate PAID subscription
  const result = await apiRequest('/api/subscription/activate', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${token}`
    },
    body: JSON.stringify({
      user_id: userId,
      ...PAID_PLAN
    })
  });
  
  console.log(`  ✓ Subscription activated: ${result.subscription.plan_code}`);
  console.log(`  ✓ Valid until: ${result.subscription.end_date}`);
  console.log(`  ✓ Payment reference: ${result.subscription.payment_reference}`);
  
  return result;
}

/**
 * Step 3: Verify subscription status
 */
async function verifySubscription(token) {
  console.log('\n[3/5] Verifying subscription status...');
  
  const result = await apiRequest('/api/subscription/status', {
    method: 'GET',
    headers: {
      'Authorization': `Bearer ${token}`
    }
  });
  
  console.log(`  ✓ Subscription Type: ${result.subscription_type}`);
  console.log(`  ✓ Plan: ${result.plan_name}`);
  console.log(`  ✓ Days Remaining: ${result.days_remaining}`);
  console.log(`  ✓ MCQ Limit: ${result.mcq_limit || 'Unlimited'}`);
  console.log(`  ✓ Features:`);
  console.log(`    - Practice Sets: ${result.features.practice_sets}`);
  console.log(`    - Unlimited MCQs: ${result.features.unlimited_mcqs}`);
  console.log(`    - Analytics: ${result.features.analytics}`);
  
  return result;
}

/**
 * Step 4: Test AI Analytics endpoints
 */
async function testAnalytics(token) {
  console.log('\n[4/5] Testing AI Analytics access...');
  
  const endpoints = [
    { name: 'Dashboard', path: '/api/analytics/user/dashboard' },
    { name: 'Weak Points', path: '/api/analytics/user/weak-points' },
    { name: 'Recommendations', path: '/api/analytics/user/recommendations' },
    { name: 'Exam Readiness', path: '/api/analytics/user/exam-readiness' }
  ];
  
  const results = [];
  
  for (const endpoint of endpoints) {
    try {
      await apiRequest(endpoint.path, {
        method: 'GET',
        headers: {
          'Authorization': `Bearer ${token}`
        }
      });
      console.log(`  ✓ ${endpoint.name}: Accessible`);
      results.push({ name: endpoint.name, status: 'OK' });
    } catch (error) {
      console.log(`  ✗ ${endpoint.name}: ${error.message}`);
      results.push({ name: endpoint.name, status: 'ERROR', error: error.message });
    }
  }
  
  return results;
}

/**
 * Step 5: Display summary
 */
function displaySummary(userData, token) {
  console.log('\n' + '='.repeat(60));
  console.log('[5/5] SETUP COMPLETE - PAID USER READY FOR E2E TESTING');
  console.log('='.repeat(60));
  
  console.log('\nLOGIN CREDENTIALS:');
  console.log('─'.repeat(40));
  console.log(`  Email:    ${TEST_USER.email}`);
  console.log(`  Password: ${TEST_USER.password}`);
  console.log(`  User ID:  ${userData.userId}`);
  
  console.log('\nJWT TOKEN (for API calls):');
  console.log('─'.repeat(40));
  console.log(`  ${token}`);
  
  console.log('\nNEXT STEPS FOR E2E TESTING:');
  console.log('─'.repeat(40));
  console.log('  1. Open the app at http://localhost:3000');
  console.log('  2. Login with the credentials above');
  console.log('  3. Answer some MCQ questions to generate analytics data');
  console.log('  4. Navigate to AI Analytics section');
  console.log('  5. Verify analytics dashboard displays correctly');
  
  console.log('\nAI ANALYTICS ENDPOINTS AVAILABLE:');
  console.log('─'.repeat(40));
  console.log('  GET /api/analytics/user/dashboard      - Full analytics dashboard');
  console.log('  GET /api/analytics/user/weak-points    - Weak topics analysis');
  console.log('  GET /api/analytics/user/recommendations - AI study recommendations');
  console.log('  GET /api/analytics/user/exam-readiness - Exam readiness score');
  console.log('  GET /api/analytics/user/trend          - Performance trend');
  console.log('  GET /api/analytics/user/topics         - Topic-level performance');
  
  console.log('\n' + '='.repeat(60));
}

/**
 * Main execution
 */
async function main() {
  console.log('='.repeat(60));
  console.log('  CREATE PAID USER FOR E2E TESTING');
  console.log('='.repeat(60));
  console.log(`  Target API: ${BASE_URL}`);
  console.log(`  Test Email: ${TEST_USER.email}`);
  
  try {
    // Step 1: Register or login user
    const userData = await registerUser();
    
    // Step 2: Activate PAID subscription
    await activateSubscription(userData.userId, userData.token);
    
    // Step 3: Verify subscription
    await verifySubscription(userData.token);
    
    // Step 4: Test AI Analytics
    await testAnalytics(userData.token);
    
    // Step 5: Display summary
    displaySummary(userData, userData.token);
    
    process.exit(0);
  } catch (error) {
    console.error('\n✗ ERROR:', error.message);
    
    if (error.message.includes('ECONNREFUSED')) {
      console.error('\n  Make sure the backend server is running:');
      console.error('  cd backend && npm start');
    }
    
    process.exit(1);
  }
}

// Run the script
main();
