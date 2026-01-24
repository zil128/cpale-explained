# MANUAL UPDATES REQUIRED TO COMPLETE MVP PHASE 1

This document provides step-by-step instructions for the remaining manual updates needed.

---

## TABLE OF CONTENTS
1. [Backend server.js Updates](#1-backend-serverjs-updates)
2. [Frontend pricing.html Updates](#2-frontend-pricinghtml-updates)
3. [Frontend dashboard.html Updates](#3-frontend-dashboardhtml-updates)
4. [Frontend quiz.html Updates](#4-frontend-quizhtml-updates)
5. [Frontend index.html Updates](#5-frontend-indexhtml-updates)
6. [Frontend register.html Updates](#6-frontend-registerhtml-updates)

---

## 1. Backend server.js Updates

### Location: `backend/server.js`

### STEP 1.1: Add Imports (Line ~8)

**After line 8** (`const path = require('path');`), ADD:

```javascript
const subscriptionRoutes = require('./routes/subscription');
const subscriptionMiddleware = require('./middleware/subscriptionCheck');
```

### STEP 1.2: Initialize Middleware (Line ~76)

**After line 76** (inside `setupDatabase()` after `connection.release();`), ADD:

```javascript
// Initialize subscription middleware with database pool
subscriptionMiddleware.setPool(pool);
subscriptionRoutes.setPool(pool);
```

### STEP 1.3: Register Subscription Routes (Line ~148)

**After line 148** (after the `/api/subscribe` route), ADD:

```javascript
// ============================================================================
// SUBSCRIPTION ROUTES
// ============================================================================
const { attachSubscription } = subscriptionMiddleware;
app.use('/api/subscription', authenticateToken, subscriptionRoutes);
```

### STEP 1.4: Update FREE Questions Endpoint (Line ~282)

**FIND** (around line 282):
```javascript
WHERE q.access_level = 'FREE'
```

**REPLACE WITH**:
```javascript
WHERE q.access_type = 'FREE'
```

### STEP 1.5: Update Practice Sets Endpoint (Line ~370)

**FIND** (around line 370):
```javascript
app.get('/api/practice-sets', authenticateToken, async (req, res) => {
  try {
    const [sets] = await pool.query(
      `SELECT 
        ps.practice_set_id,
        ps.set_code,
        ps.set_name,
        ps.set_type,
        ps.access_level,
        // ... rest of query
```

**REPLACE WITH**:
```javascript
app.get('/api/practice-sets', authenticateToken, attachSubscription, async (req, res) => {
  try {
    const userPlan = req.user.subscription.subscription_type;
    
    let query = `
      SELECT 
        ps.practice_set_id,
        ps.set_code,
        ps.set_name,
        ps.set_type,
        ps.access_type,
        ps.questions_per_set,
        ps.display_order,
        t.topic_id,
        t.topic_name,
        s.subject_id,
        s.subject_code,
        s.subject_name
      FROM practice_sets ps
      JOIN topics t ON ps.topic_id = t.topic_id
      JOIN subjects s ON t.subject_id = s.subject_id
      WHERE ps.is_active = TRUE
    `;
    
    // FREE users only see FREE practice sets
    if (userPlan === 'FREE') {
      query += " AND ps.access_type = 'FREE'";
    }
    
    query += " ORDER BY s.subject_code, ps.display_order";
    
    const [sets] = await pool.query(query);
    
    res.json({
      practiceSets: sets,
      userPlan: userPlan,
      totalSets: sets.length
    });
  } catch (error) {
    console.error('Get practice sets error:', error);
    res.status(500).json({ error: 'Failed to fetch practice sets' });
  }
});
```

### STEP 1.6: Update Register Endpoint (Line ~150-187)

**FIND** the register endpoint and **UPDATE** the subscription creation:

```javascript
// Create subscription record - CHANGE THIS:
await pool.query(
  `INSERT INTO user_subscriptions (user_id, plan_type, subscription_status, start_date, is_active)
   VALUES (?, 'FREE', 'ACTIVE', CURDATE(), TRUE)`,
  [userId]
);

// TO THIS:
// Create FREE subscription in new v2 table
const [freePlan] = await pool.query(
  `SELECT plan_id FROM subscription_plans_v2 WHERE plan_code = 'FREE'`
);

if (freePlan.length > 0) {
  await pool.query(
    `INSERT INTO user_subscriptions_v2 
    (user_id, plan_id, subscription_type, start_date, end_date, is_active)
    VALUES (?, ?, 'FREE', CURDATE(), NULL, TRUE)`,
    [userId, freePlan[0].plan_id]
  );
  
  // Initialize MCQ usage tracking
  await pool.query(
    `INSERT INTO user_mcq_usage (user_id, mcqs_attempted, last_reset_date)
    VALUES (?, 0, CURDATE())`,
    [userId]
  );
}
```

---

## 2. Frontend pricing.html Updates

### Location: `landing-page/pricing.html`

### STEP 2.1: Remove Billing Period Tabs (Lines 220-231)

**DELETE** the entire billing period tabs section:
```html
<!-- DELETE THIS SECTION -->
<div class="flex justify-center mb-10">
    <div class="glass rounded-full p-1.5 flex space-x-1">
        <button id="monthlyTab" class="tab-btn active px-6 py-2.5 rounded-full font-semibold text-sm">
            Monthly
        </button>
        <button id="semiAnnualTab" class="tab-btn px-6 py-2.5 rounded-full font-semibold text-sm text-gray-600">
            6 Months
            <span class="ml-1 text-xs bg-emerald-100 text-emerald-600 px-2 py-0.5 rounded-full">Save up to 11%</span>
        </button>
    </div>
</div>
<!-- END DELETE -->
```

### STEP 2.2: Update Pricing Cards Grid (Line 234)

**CHANGE FROM**:
```html
<div class="grid md:grid-cols-3 gap-6 md:gap-8" id="pricingCards">
```

**CHANGE TO**:
```html
<div class="grid md:grid-cols-2 gap-8 max-w-4xl mx-auto" id="pricingCards">
```

### STEP 2.3: Keep FREE Card As-Is (Lines 236-287)
Keep the FREE card exactly as it is.

### STEP 2.4: Update PAID Card (Lines 289-341)

**DELETE** the BASIC card completely

**FIND** the ADVANCE card (lines 343-395) and **REPLACE** with:

```html
<!-- PAID Plan -->
<div class="pricing-card featured glass rounded-3xl p-8 relative animate-pulse-glow">
    <div class="mb-6">
        <span class="text-sm font-semibold text-accent uppercase tracking-wider">Best Value</span>
        <h3 class="text-2xl font-bold text-gray-800 mt-1">Paid Plan</h3>
    </div>
    <div class="mb-6">
        <span class="text-5xl font-bold bg-gradient-to-r from-primary to-accent bg-clip-text text-transparent">P149</span>
        <span class="text-gray-500">/month (30 days)</span>
    </div>
    <p class="text-gray-600 mb-6">Full access for serious reviewers ready to pass CPALE.</p>
    <ul class="space-y-3 mb-8">
        <li class="flex items-center text-gray-600">
            <svg class="w-5 h-5 text-emerald-500 mr-3" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
            </svg>
            <span><strong>UNLIMITED MCQs</strong> - full database access</span>
        </li>
        <li class="flex items-center text-gray-600">
            <svg class="w-5 h-5 text-emerald-500 mr-3" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
            </svg>
            <span>All 6 CPALE subjects</span>
        </li>
        <li class="flex items-center text-gray-600">
            <svg class="w-5 h-5 text-emerald-500 mr-3" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
            </svg>
            <span><strong>Practice Sets</strong> (75 MCQs each)</span>
        </li>
        <li class="flex items-center text-gray-600">
            <svg class="w-5 h-5 text-emerald-500 mr-3" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
            </svg>
            <span>Basic analytics dashboard</span>
        </li>
        <li class="flex items-center text-gray-600">
            <svg class="w-5 h-5 text-emerald-500 mr-3" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
            </svg>
            <span>Email support</span>
        </li>
        <li class="flex items-center text-gray-600">
            <svg class="w-5 h-5 text-emerald-500 mr-3" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
            </svg>
            <span><strong>30 days access</strong> - manual renewal</span>
        </li>
    </ul>
    <button onclick="selectPlan('PAID_MONTHLY')" class="block w-full py-3 px-6 text-center bg-gradient-to-r from-primary via-accent to-pink-500 text-white font-semibold rounded-xl hover:shadow-lg hover:shadow-accent/30 transition">
        Get Paid Plan
    </button>
</div>
```

### STEP 2.5: Update JavaScript (Lines 507-717)

**REPLACE** the entire `<script>` section with:

```javascript
<script>
    const API_URL = 'http://localhost:5000/api';

    // State
    let selectedPlanCode = null;
    let selectedPaymentMethod = null;
    let appliedPromo = null;
    let currentPrice = 0;

    // Plans data
    const plansData = {
        FREE: { code: 'FREE', price: 0, name: 'Free Plan' },
        PAID_MONTHLY: { code: 'PAID_MONTHLY', price: 149, name: 'Paid Monthly' }
    };

    function selectPlan(planCode) {
        // Check if user is logged in
        const token = localStorage.getItem('token');
        if (!token) {
            alert('Please login or register first to subscribe.');
            window.location.href = 'register.html';
            return;
        }

        if (planCode === 'FREE') {
            alert('You are already on the FREE plan!');
            return;
        }

        const plan = plansData[planCode];
        selectedPlanCode = plan.code;
        currentPrice = plan.price;

        // Update modal info
        document.getElementById('selectedPlanInfo').textContent = `You selected: ${plan.name} - P${plan.price}`;
        document.getElementById('subtotalPrice').textContent = `P${plan.price.toLocaleString()}.00`;
        document.getElementById('totalPrice').textContent = `P${plan.price.toLocaleString()}.00`;

        // Reset state
        appliedPromo = null;
        selectedPaymentMethod = null;
        document.getElementById('discountRow').classList.add('hidden');
        document.getElementById('promoMessage').classList.add('hidden');
        document.getElementById('promoCodeInput').value = '';
        document.querySelectorAll('.payment-btn').forEach(btn => btn.classList.remove('selected'));
        document.getElementById('paymentInstructions').classList.add('hidden');
        document.getElementById('proceedBtn').disabled = true;

        // Show modal
        document.getElementById('paymentModal').classList.remove('hidden');
        document.getElementById('paymentModal').classList.add('flex');
    }

    function closePaymentModal() {
        document.getElementById('paymentModal').classList.add('hidden');
        document.getElementById('paymentModal').classList.remove('flex');
    }

    async function applyPromoCode() {
        const code = document.getElementById('promoCodeInput').value.trim();
        if (!code) return;

        try {
            const response = await fetch(`${API_URL}/payment/validate-promo`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ code, planCode: selectedPlanCode })
            });

            const data = await response.json();
            const messageEl = document.getElementById('promoMessage');

            if (data.valid) {
                appliedPromo = data.promo;
                let discount = 0;

                if (data.promo.discountType === 'PERCENTAGE') {
                    discount = currentPrice * (data.promo.discountValue / 100);
                } else {
                    discount = data.promo.discountValue;
                }

                const finalPrice = Math.max(0, currentPrice - discount);

                document.getElementById('discountRow').classList.remove('hidden');
                document.getElementById('discountAmount').textContent = `-P${discount.toFixed(2)}`;
                document.getElementById('totalPrice').textContent = `P${finalPrice.toFixed(2)}`;

                messageEl.textContent = `Promo applied: ${data.promo.description}`;
                messageEl.classList.remove('hidden', 'text-red-500');
                messageEl.classList.add('text-emerald-500');
            } else {
                messageEl.textContent = data.error || 'Invalid promo code';
                messageEl.classList.remove('hidden', 'text-emerald-500');
                messageEl.classList.add('text-red-500');
            }
        } catch (error) {
            console.error('Promo validation error:', error);
        }
    }

    function selectPaymentMethod(method) {
        selectedPaymentMethod = method;

        // Update UI
        document.querySelectorAll('.payment-btn').forEach(btn => btn.classList.remove('selected'));
        event.currentTarget.classList.add('selected');

        // Show instructions
        const instructions = {
            'GCASH': 'Send payment to GCash number: 0917-XXX-XXXX (CPALE Explained). Include your email as reference.',
            'PAYMAYA': 'Send payment to Maya number: 0917-XXX-XXXX (CPALE Explained). Include your email as reference.',
            'BANK_TRANSFER': 'Transfer to BDO Account: 1234-5678-9012 (CPALE Explained Inc.). Send proof to payment@cpaleexplained.com'
        };

        document.getElementById('instructionsText').textContent = instructions[method];
        document.getElementById('paymentInstructions').classList.remove('hidden');
        document.getElementById('proceedBtn').disabled = false;
    }

    async function proceedToPayment() {
        if (!selectedPaymentMethod || !selectedPlanCode) return;

        const token = localStorage.getItem('token');
        if (!token) {
            alert('Please login first');
            return;
        }

        try {
            const response = await fetch(`${API_URL}/payment/create`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${token}`
                },
                body: JSON.stringify({
                    planCode: selectedPlanCode,
                    paymentProvider: selectedPaymentMethod,
                    promoCode: appliedPromo?.code || null
                })
            });

            const data = await response.json();

            if (response.ok) {
                // Show confirmation modal
                closePaymentModal();
                document.getElementById('referenceNumber').textContent = data.transaction.reference;
                document.getElementById('confirmInstructions').textContent = data.transaction.instructions || 
                    'Please complete your payment using the selected method. Once confirmed, your subscription will be activated within 24 hours.';
                document.getElementById('confirmationModal').classList.remove('hidden');
                document.getElementById('confirmationModal').classList.add('flex');
            } else {
                alert(data.error || 'Failed to create payment');
            }
        } catch (error) {
            console.error('Payment creation error:', error);
            alert('Failed to create payment. Please try again.');
        }
    }

    function closeConfirmationModal() {
        document.getElementById('confirmationModal').classList.add('hidden');
        document.getElementById('confirmationModal').classList.remove('flex');
        window.location.href = 'dashboard.html';
    }

    // Close modal on outside click
    document.getElementById('paymentModal').addEventListener('click', (e) => {
        if (e.target === document.getElementById('paymentModal')) {
            closePaymentModal();
        }
    });
</script>
```

---

## 3. Frontend dashboard.html Updates

### Location: `landing-page/dashboard.html`

### STEP 3.1: Add Subscription Widget (After opening body tag)

**FIND** the main content area (usually after navigation) and **ADD**:

```html
<!-- Subscription Status Widget -->
<div id="subscriptionWidget" class="glass rounded-3xl p-6 mb-6 max-w-4xl mx-auto">
    <div class="flex justify-between items-center mb-4">
        <div>
            <h3 class="text-lg font-bold">Your Plan: <span id="planName" class="text-primary">Loading...</span></h3>
            <p class="text-sm text-gray-600" id="planDetails">Checking subscription status...</p>
        </div>
        <div id="upgradeButton" class="hidden">
            <a href="pricing.html" class="px-6 py-3 bg-gradient-to-r from-primary to-accent text-white rounded-xl font-semibold hover:shadow-lg transition">
                Upgrade to Paid
            </a>
        </div>
    </div>
    
    <!-- Progress bar for FREE users showing MCQ usage -->
    <div id="mcqUsageBar" class="hidden mt-4">
        <div class="flex justify-between text-sm mb-2">
            <span class="font-medium text-gray-700">MCQs Used</span>
            <span id="mcqCount" class="font-bold text-primary">0/50</span>
        </div>
        <div class="w-full bg-gray-200 rounded-full h-3">
            <div id="mcqProgress" class="bg-gradient-to-r from-primary to-accent h-3 rounded-full transition-all duration-500" style="width: 0%"></div>
        </div>
        <p class="text-xs text-gray-500 mt-2">Upgrade to PAID for unlimited MCQ access!</p>
    </div>
    
    <!-- Expiration warning for PAID users -->
    <div id="expirationWarning" class="hidden mt-4 bg-amber-50 border border-amber-200 rounded-xl p-4">
        <div class="flex items-center">
            <svg class="w-5 h-5 text-amber-500 mr-2" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd"/>
            </svg>
            <span id="expirationMessage" class="text-sm font-medium text-amber-800"></span>
        </div>
    </div>
</div>
```

### STEP 3.2: Add JavaScript (Before closing `</body>` tag)

**ADD** at the bottom of the file:

```html
<script>
    const API_URL = 'http://localhost:5000/api';

    // Load subscription status on page load
    async function loadSubscriptionStatus() {
        const token = localStorage.getItem('token');
        if (!token) {
            window.location.href = 'login.html';
            return;
        }

        try {
            const res = await fetch(`${API_URL}/subscription/status`, {
                headers: { 'Authorization': `Bearer ${token}` }
            });

            if (!res.ok) {
                throw new Error('Failed to fetch subscription');
            }

            const data = await res.json();
            
            // Update plan name
            document.getElementById('planName').textContent = data.plan_name;
            
            if (data.subscription_type === 'FREE') {
                // Show FREE user UI
                document.getElementById('upgradeButton').classList.remove('hidden');
                document.getElementById('mcqUsageBar').classList.remove('hidden');
                
                const used = data.mcqs_used || 0;
                const limit = data.mcq_limit || 50;
                const percentage = Math.min(100, (used / limit) * 100);
                
                document.getElementById('planDetails').textContent = `${limit} FREE MCQs available`;
                document.getElementById('mcqCount').textContent = `${used}/${limit}`;
                document.getElementById('mcqProgress').style.width = `${percentage}%`;
                
                // Change color based on usage
                const progressBar = document.getElementById('mcqProgress');
                if (percentage >= 80) {
                    progressBar.classList.remove('from-primary', 'to-accent');
                    progressBar.classList.add('from-amber-400', 'to-red-500');
                }
            } else if (data.subscription_type === 'PAID') {
                // Show PAID user UI
                const daysLeft = data.days_remaining;
                
                if (daysLeft !== null) {
                    document.getElementById('planDetails').textContent = 
                        `Valid until ${new Date(data.end_date).toLocaleDateString()} (${daysLeft} days remaining)`;
                    
                    // Show expiration warning if less than 7 days
                    if (daysLeft <= 7 && daysLeft > 0) {
                        document.getElementById('expirationWarning').classList.remove('hidden');
                        document.getElementById('expirationMessage').textContent = 
                            `Your subscription expires in ${daysLeft} day${daysLeft > 1 ? 's' : ''}. Renew now to continue unlimited access!`;
                    }
                } else {
                    document.getElementById('planDetails').textContent = 'Unlimited access to all MCQs and Practice Sets';
                }
            }
        } catch (error) {
            console.error('Failed to load subscription:', error);
            document.getElementById('planName').textContent = 'Error';
            document.getElementById('planDetails').textContent = 'Failed to load subscription status';
        }
    }

    // Load on page ready
    document.addEventListener('DOMContentLoaded', loadSubscriptionStatus);
</script>
```

---

## 4. Frontend quiz.html Updates

### Location: `landing-page/quiz.html`

### STEP 4.1: Update loadPracticeSets Function

**FIND** the `loadPracticeSets()` function and **UPDATE** to:

```javascript
async function loadPracticeSets() {
    const token = localStorage.getItem('token');
    if (!token) {
        window.location.href = 'login.html';
        return;
    }

    try {
        const res = await fetch(`${API_URL}/practice-sets`, {
            headers: { 'Authorization': `Bearer ${token}` }
        });

        if (!res.ok) {
            throw new Error('Failed to fetch practice sets');
        }

        const data = await res.json();
        
        // Backend already filters based on subscription
        // FREE users only see FREE practice sets
        // PAID users see all practice sets
        
        const practiceSetsList = document.getElementById('practiceSetsList');
        if (data.practiceSets.length === 0) {
            practiceSetsList.innerHTML = `
                <div class="text-center py-12">
                    <p class="text-gray-600 mb-4">No practice sets available for your plan</p>
                    <a href="pricing.html" class="px-6 py-3 bg-gradient-to-r from-primary to-accent text-white rounded-xl">
                        Upgrade to Access Practice Sets
                    </a>
                </div>
            `;
            return;
        }
        
        displayPracticeSets(data.practiceSets);
        
        // Show plan indicator
        if (data.userPlan === 'FREE') {
            showFreePlanNotice();
        }
    } catch (error) {
        console.error('Failed to load practice sets:', error);
        alert('Failed to load practice sets. Please try again.');
    }
}

function showFreePlanNotice() {
    const notice = document.createElement('div');
    notice.className = 'bg-amber-50 border border-amber-200 rounded-xl p-4 mb-6';
    notice.innerHTML = `
        <div class="flex items-center justify-between">
            <div class="flex items-center">
                <svg class="w-5 h-5 text-amber-500 mr-2" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd"/>
                </svg>
                <span class="text-sm font-medium text-amber-800">You're on the FREE plan. Upgrade to access all Practice Sets!</span>
            </div>
            <a href="pricing.html" class="text-sm font-semibold text-primary hover:text-accent">
                Upgrade Now →
            </a>
        </div>
    `;
    
    const container = document.getElementById('practiceSetsList').parentElement;
    container.insertBefore(notice, document.getElementById('practiceSetsList'));
}
```

### STEP 4.2: Add Access Check Before Starting Quiz

**FIND** the function that starts a practice set and **ADD** access check:

```javascript
async function startPracticeSet(setId) {
    const token = localStorage.getItem('token');
    
    try {
        const res = await fetch(`${API_URL}/practice-sets/${setId}/start`, {
            method: 'POST',
            headers: { 
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json'
            }
        });
        
        if (res.status === 403) {
            // User doesn't have access
            const data = await res.json();
            alert(data.error || 'This practice set requires a PAID subscription.');
            
            // Redirect to pricing
            if (confirm('Would you like to upgrade now?')) {
                window.location.href = 'pricing.html';
            }
            return;
        }
        
        if (!res.ok) {
            throw new Error('Failed to start practice set');
        }
        
        // Continue with quiz...
        const data = await res.json();
        // ... rest of quiz logic
    } catch (error) {
        console.error('Failed to start practice set:', error);
        alert('Failed to start practice set. Please try again.');
    }
}
```

---

## 5. Frontend index.html Updates

### Location: `landing-page/index.html`

### STEP 5.1: Find Pricing Section (Usually around line 300-400)

**REPLACE** the pricing section with:

```html
<!-- Pricing Section -->
<section class="py-20 bg-gradient-to-br from-lavender to-mint">
    <div class="max-w-6xl mx-auto px-4">
        <div class="text-center mb-12">
            <h2 class="text-4xl font-bold text-gray-800 mb-4">
                Simple, Transparent Pricing
            </h2>
            <p class="text-lg text-gray-600">
                Choose the plan that fits your CPALE journey
            </p>
        </div>

        <div class="grid md:grid-cols-2 gap-8 max-w-4xl mx-auto">
            <!-- FREE Plan -->
            <div class="bg-white rounded-3xl p-8 shadow-lg">
                <h3 class="text-2xl font-bold text-gray-800 mb-2">Free Plan</h3>
                <div class="mb-6">
                    <span class="text-5xl font-bold text-gray-800">P0</span>
                    <span class="text-gray-500">/forever</span>
                </div>
                <ul class="space-y-3 mb-8">
                    <li class="flex items-center">
                        <svg class="w-5 h-5 text-emerald-500 mr-3" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                        </svg>
                        <span>50 FREE MCQs</span>
                    </li>
                    <li class="flex items-center">
                        <svg class="w-5 h-5 text-emerald-500 mr-3" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                        </svg>
                        <span>All 6 CPALE subjects</span>
                    </li>
                    <li class="flex items-center">
                        <svg class="w-5 h-5 text-emerald-500 mr-3" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                        </svg>
                        <span>Unlimited repetition</span>
                    </li>
                    <li class="flex items-center">
                        <svg class="w-5 h-5 text-emerald-500 mr-3" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                        </svg>
                        <span>Basic progress tracking</span>
                    </li>
                </ul>
                <a href="register.html" class="block w-full py-3 text-center border-2 border-gray-300 text-gray-700 font-semibold rounded-xl hover:border-primary hover:text-primary transition">
                    Start Free
                </a>
            </div>

            <!-- PAID Plan -->
            <div class="bg-gradient-to-br from-primary to-accent rounded-3xl p-8 shadow-2xl relative">
                <div class="absolute -top-4 left-1/2 transform -translate-x-1/2 bg-emerald-500 text-white px-4 py-1 rounded-full text-sm font-bold">
                    BEST VALUE
                </div>
                <h3 class="text-2xl font-bold text-white mb-2">Paid Plan</h3>
                <div class="mb-6">
                    <span class="text-5xl font-bold text-white">P149</span>
                    <span class="text-purple-100">/month (30 days)</span>
                </div>
                <ul class="space-y-3 mb-8">
                    <li class="flex items-center text-white">
                        <svg class="w-5 h-5 text-emerald-300 mr-3" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                        </svg>
                        <span><strong>UNLIMITED MCQs</strong></span>
                    </li>
                    <li class="flex items-center text-white">
                        <svg class="w-5 h-5 text-emerald-300 mr-3" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                        </svg>
                        <span>All 6 CPALE subjects</span>
                    </li>
                    <li class="flex items-center text-white">
                        <svg class="w-5 h-5 text-emerald-300 mr-3" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                        </svg>
                        <span>Practice Sets (75 MCQs)</span>
                    </li>
                    <li class="flex items-center text-white">
                        <svg class="w-5 h-5 text-emerald-300 mr-3" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                        </svg>
                        <span>Basic analytics</span>
                    </li>
                    <li class="flex items-center text-white">
                        <svg class="w-5 h-5 text-emerald-300 mr-3" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                        </svg>
                        <span>Email support</span>
                    </li>
                </ul>
                <a href="pricing.html" class="block w-full py-3 text-center bg-white text-primary font-semibold rounded-xl hover:shadow-lg transition">
                    Get Paid Plan
                </a>
            </div>
        </div>

        <div class="text-center mt-8">
            <a href="pricing.html" class="text-primary font-semibold hover:text-accent">
                View detailed pricing →
            </a>
        </div>
    </div>
</section>
```

---

## 6. Frontend register.html Updates

### Location: `landing-page/register.html`

### STEP 6.1: Remove Plan Selection (if it exists)

**FIND** any plan selection dropdown or radio buttons and **DELETE** them.

### STEP 6.2: Add FREE Plan Notice

**ADD** after email/password fields:

```html
<div class="bg-emerald-50 border border-emerald-200 rounded-xl p-4 mb-4">
    <div class="flex items-center">
        <svg class="w-5 h-5 text-emerald-500 mr-2" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
        </svg>
        <span class="text-sm font-medium text-emerald-800">
            Start with FREE plan • 50 MCQs • Upgrade anytime
        </span>
    </div>
</div>
```

### STEP 6.3: Update Registration JavaScript

**FIND** the registration handler and ensure it defaults to FREE:

```javascript
async function handleRegister(e) {
    e.preventDefault();
    
    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;
    const displayName = document.getElementById('displayName').value;
    
    try {
        const res = await fetch(`${API_URL}/auth/register`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                email,
                password,
                displayName
                // No plan_code needed - backend defaults to FREE
            })
        });
        
        const data = await res.json();
        
        if (res.ok) {
            localStorage.setItem('token', data.token);
            alert('Registration successful! Starting with FREE plan.');
            window.location.href = 'dashboard.html';
        } else {
            alert(data.error || 'Registration failed');
        }
    } catch (error) {
        console.error('Registration error:', error);
        alert('Registration failed. Please try again.');
    }
}
```

---

## ✅ COMPLETION CHECKLIST

After making all manual updates:

- [ ] Database migration scripts run successfully
- [ ] Backend server.js updated with all changes
- [ ] pricing.html simplified to 2 cards
- [ ] dashboard.html shows subscription widget
- [ ] quiz.html has access control
- [ ] index.html pricing section updated
- [ ] register.html defaults to FREE
- [ ] Test with provided test users
- [ ] Verify FREE user MCQ limits work
- [ ] Verify PAID user unlimited access works
- [ ] Test payment and upgrade flow
- [ ] Check subscription expiration logic

---

## 🆘 TROUBLESHOOTING

**Database connection errors**:
- Check `.env` file has correct credentials
- Verify MySQL is running
- Check `subscription_plans_v2` table exists

**Subscription not loading**:
- Check browser console for errors
- Verify API endpoint `/api/subscription/status` works
- Check JWT token in localStorage

**Practice sets not filtering**:
- Verify `access_type` column exists in `practice_sets` table
- Check backend console for SQL errors
- Ensure middleware is attached to routes

**Payment not activating**:
- Check payment webhook/callback
- Verify `/api/subscription/activate` endpoint
- Check payment_transactions_new table

---

**Next**: After completing manual updates, run the testing checklist in `MVP_PHASE1_IMPLEMENTATION_STATUS.md`
