# CPALE Explained - Pre-Launch Testing Checklist

## Overview
This checklist ensures all features are tested before launching the CPALE Explained platform.

---

## 1. Infrastructure Checks

### Database
- [ ] MySQL container is running: `docker ps | grep cpale-mysql`
- [ ] Database connection works: Login to app and verify no connection errors
- [ ] All tables exist: Check migration logs for errors

### Server
- [ ] Backend server starts without errors: `cd backend && node server.js`
- [ ] Server responds on port 5000: `curl http://localhost:5000/api/health`
- [ ] Static files are served: Access http://localhost:5000/landing-page/

---

## 2. Authentication Tests

### Registration
- [ ] New user can register with valid email/password
- [ ] Duplicate email is rejected
- [ ] Weak password is rejected (if validation exists)
- [ ] New users default to FREE tier

### Login
- [ ] Valid credentials return JWT token
- [ ] Invalid email returns error
- [ ] Invalid password returns error
- [ ] Token contains correct user info (userId, email, userType)

### Token Validation
- [ ] Protected routes reject requests without token
- [ ] Protected routes reject expired tokens
- [ ] Protected routes reject invalid tokens

---

## 3. Practice Sets & Quiz

### Practice Sets List
- [ ] FREE users see 6 practice sets
- [ ] PAID users see 9 practice sets (6 FREE + 3 PAID)
- [ ] Each set shows question count and subject

### Quiz Functionality
- [ ] Questions load with 4 choices each
- [ ] Choices are shuffled (not always in same order)
- [ ] Answer selection works
- [ ] Correct/incorrect feedback displays
- [ ] Explanation shows after answering
- [ ] Progress saves to database

### Access Control
- [ ] FREE users cannot access PAID practice sets
- [ ] PAID users can access all practice sets

---

## 4. Mock Exam System

### Exam List
- [ ] All 9 exams display (6 subject + 3 comprehensive)
- [ ] Each exam shows: name, questions count, time limit, passing score
- [ ] User's attempt history shows (if any)

### Starting Exam
- [ ] Clicking "Start Exam" creates new attempt
- [ ] 100 questions are generated (for comprehensive)
- [ ] Timer starts correctly (180 minutes)
- [ ] Cannot start new exam if one is in progress

### During Exam
- [ ] All questions load with choices
- [ ] Question navigator shows all questions
- [ ] Can navigate between questions
- [ ] Can mark questions for review
- [ ] Answers auto-save
- [ ] Timer counts down correctly
- [ ] Warning shows when time is low (< 5 minutes)

### Submitting Exam
- [ ] Submit button works
- [ ] Confirmation dialog appears
- [ ] Results calculate correctly
- [ ] Score displays with pass/fail status
- [ ] Subject breakdown shows
- [ ] Difficulty breakdown shows
- [ ] Recommendations generate

### Results Page
- [ ] Overall score displays
- [ ] Charts render correctly
- [ ] Can review each question
- [ ] Shows correct answer for each
- [ ] Shows explanation for each

---

## 5. AI Analytics System

### Analytics Dashboard
- [ ] Dashboard loads for users with history
- [ ] Shows "No data" message for new users
- [ ] Exam readiness score displays
- [ ] Overall metrics show correctly

### Weak Points
- [ ] Critical weak topics identified
- [ ] Topics sorted by weakness score
- [ ] Shows accuracy and attempts for each

### Recommendations
- [ ] Personalized recommendations generate
- [ ] Study plan suggestions show
- [ ] Practice set suggestions work

### Exam Readiness
- [ ] Readiness score calculates (0-100)
- [ ] Predicted score shows
- [ ] Status message appropriate (Ready/Need Practice/etc)

---

## 6. Subscription & Payments

### Subscription Status
- [ ] FREE users show FREE badge
- [ ] PAID users show PAID badge with expiry
- [ ] Subscription status accurate in API responses

### Pricing Page
- [ ] All plans display with prices
- [ ] Feature comparison shows
- [ ] Upgrade buttons work (redirect to payment)

### Subscription Checker (Background)
- [ ] No errors in console at startup
- [ ] Expiring subscriptions would trigger reminders
- [ ] Expired subscriptions would downgrade to FREE

---

## 7. UI/UX Checks

### All Pages Load
- [ ] index.html (landing page)
- [ ] login.html
- [ ] register.html
- [ ] dashboard.html
- [ ] quiz.html
- [ ] analytics.html
- [ ] mock-exam-list.html
- [ ] mock-exam.html
- [ ] mock-exam-results.html
- [ ] pricing.html

### Navigation
- [ ] All nav links work
- [ ] Logo links to dashboard
- [ ] Logout works and clears token
- [ ] Protected pages redirect to login if not authenticated

### Responsive Design
- [ ] Pages work on mobile (< 768px)
- [ ] Pages work on tablet (768px - 1024px)
- [ ] Pages work on desktop (> 1024px)

### Accessibility
- [ ] All images have alt text
- [ ] Forms have labels
- [ ] Color contrast is sufficient
- [ ] Keyboard navigation works

---

## 8. Error Handling

### API Errors
- [ ] 401 for unauthorized access
- [ ] 404 for not found resources
- [ ] 500 errors show user-friendly message
- [ ] Network errors handled gracefully

### Form Validation
- [ ] Empty required fields show error
- [ ] Invalid email format rejected
- [ ] Password requirements enforced

---

## 9. Performance Checks

### Response Times
- [ ] API endpoints respond < 500ms
- [ ] Pages load < 3 seconds
- [ ] No memory leaks in long sessions

### Load Testing (Optional)
- [ ] 10 concurrent users work
- [ ] 50 concurrent users work
- [ ] Database handles load

---

## 10. Security Checks

### Authentication
- [ ] Passwords are hashed (not stored plaintext)
- [ ] JWT secret is not exposed
- [ ] Tokens expire appropriately

### Authorization
- [ ] Users cannot access other users' data
- [ ] FREE users cannot access PAID content
- [ ] Admin routes protected (if any)

### Input Validation
- [ ] SQL injection prevented
- [ ] XSS prevented
- [ ] No sensitive data in error messages

---

## Test Credentials

### PAID User
- Email: `testuser@cpaleexplained.com`
- Password: `password123`
- Access: All features

### FREE User
- Email: `test@cpaleexplained.com`
- Password: `password123`
- Access: FREE practice sets only

---

## Quick Smoke Test Commands

```bash
# 1. Check server is running
curl http://localhost:5000/landing-page/

# 2. Test login
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"testuser@cpaleexplained.com","password":"password123"}'

# 3. Test practice sets (use token from login)
curl http://localhost:5000/api/practice-sets \
  -H "Authorization: Bearer YOUR_TOKEN"

# 4. Test analytics
curl http://localhost:5000/api/analytics/user/dashboard \
  -H "Authorization: Bearer YOUR_TOKEN"

# 5. Test mock exam list
curl http://localhost:5000/api/mock-exam/list \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

## Sign-Off

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Developer | | | |
| QA Tester | | | |
| Product Owner | | | |

---

*Last Updated: January 24, 2026*
