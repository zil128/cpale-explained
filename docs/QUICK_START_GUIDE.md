# MVP PHASE 1 - QUICK START GUIDE

**Estimated Time**: 30-45 minutes  
**Complexity**: Moderate (requires SQL + code editing)

---

## 🚀 QUICK EXECUTION STEPS

### 1. Run Database Migration (5 minutes)

```bash
cd C:\Users\LD3\Desktop\cpale-explained

# Run all migration scripts in order
mysql -u root -p cpale_explained < database/migrations/mvp_phase1_backup.sql
mysql -u root -p cpale_explained < database/migrations/mvp_phase1_migration.sql
mysql -u root -p cpale_explained < database/migrations/mvp_phase1_select_free_mcqs.sql
mysql -u root -p cpale_explained < database/migrations/mvp_phase1_test_data.sql
```

✅ **Verify**: Check tables exist
```sql
SHOW TABLES LIKE '%_v2';
-- Should show: subscription_plans_v2, user_subscriptions_v2
```

---

### 2. Update Backend server.js (10 minutes)

**File**: `backend/server.js`

**Changes needed (6 locations)**:

| Line | Change | What to do |
|------|--------|------------|
| ~8 | Add imports | Add 2 new require statements |
| ~76 | Init middleware | Add 2 setPool() calls |
| ~148 | Register routes | Add app.use('/api/subscription') |
| ~282 | Update query | Change `access_level` to `access_type` |
| ~370 | Update practice sets | Replace entire endpoint function |
| ~180 | Update register | Change subscription creation |

📄 **See**: `docs/MANUAL_UPDATES_REQUIRED.md` Section 1 for exact code

---

### 3. Update Frontend Files (20 minutes)

#### A. pricing.html
- Remove billing tabs
- Change grid to 2 columns
- Delete BASIC card
- Update PAID card
- Replace JavaScript

#### B. dashboard.html
- Add subscription widget HTML
- Add JavaScript for status display

#### C. quiz.html
- Update loadPracticeSets()
- Add access check

#### D. index.html
- Replace pricing section

#### E. register.html
- Add FREE plan notice
- Remove plan selection

📄 **See**: `docs/MANUAL_UPDATES_REQUIRED.md` Sections 2-6 for copy-paste code

---

### 4. Test Everything (10 minutes)

**Test Users** (all password: `Test123!`):
- testfree@cpale.com
- testpaid@cpale.com  
- testexpired@cpale.com

**Quick Test Checklist**:
```
□ Login as FREE user → see 50 MCQ limit
□ Login as PAID user → see unlimited access
□ Check dashboard shows subscription
□ Try to access practice sets
□ Visit pricing page (2 cards only)
```

---

## 📁 FILES CREATED (Auto-Generated ✅)

### Database Scripts (5 files):
```
database/migrations/
  ├── mvp_phase1_backup.sql          ✅
  ├── mvp_phase1_migration.sql       ✅
  ├── mvp_phase1_select_free_mcqs.sql ✅
  ├── mvp_phase1_test_data.sql       ✅
  └── mvp_phase1_rollback.sql        ✅
```

### Backend Files (3 files):
```
backend/
  ├── config/plans.js                 ✅
  ├── middleware/subscriptionCheck.js ✅
  └── routes/subscription.js          ✅
```

### Documentation (3 files):
```
docs/
  ├── MVP_PHASE1_IMPLEMENTATION_STATUS.md  ✅
  ├── MANUAL_UPDATES_REQUIRED.md           ✅
  └── QUICK_START_GUIDE.md (this file)     ✅
```

---

## 📝 FILES TO MODIFY MANUALLY (7 files)

### Backend (1 file):
```
backend/
  └── server.js                       ⏳ (6 changes)
```

### Frontend (5 files):
```
landing-page/
  ├── pricing.html                    ⏳
  ├── dashboard.html                  ⏳
  ├── quiz.html                       ⏳
  ├── index.html                      ⏳
  └── register.html                   ⏳
```

---

## 🎯 NEW API ENDPOINTS AVAILABLE

After implementation, these endpoints will work:

```
GET  /api/subscription/status   → User's current subscription
GET  /api/subscription/plans    → Available plans (FREE, PAID)
GET  /api/subscription/usage    → MCQ usage statistics
POST /api/subscription/upgrade  → Prepare for upgrade
POST /api/subscription/activate → Activate after payment
```

---

## 🔄 ROLLBACK (if needed)

If anything goes wrong:
```bash
mysql -u root -p cpale_explained < database/migrations/mvp_phase1_rollback.sql
```

This removes all new tables/columns and restores original state.

---

## 📊 WHAT CHANGED

### Database:
- ✅ 3 new tables created
- ✅ 2 new columns added to existing tables
- ✅ 50 random MCQs marked as FREE
- ✅ Test users created

### Backend:
- ✅ Subscription middleware created
- ✅ Subscription routes created
- ✅ Plans config created
- ⏳ server.js needs 6 small updates

### Frontend:
- ⏳ All 5 HTML files need updates
- ⏳ Simplified pricing (2 cards instead of 3)
- ⏳ Subscription status widget
- ⏳ Access control checks

---

## ✅ SUCCESS CRITERIA

You'll know it's working when:

1. **Database**: 3 new tables exist with data
2. **Backend**: Server starts without errors
3. **Frontend**: Pricing shows 2 cards (FREE & PAID)
4. **Dashboard**: Shows subscription status
5. **FREE user**: Can only access 50 MCQs
6. **PAID user**: Can access unlimited MCQs
7. **Test login**: All 3 test users work

---

## 🆘 HELP

**Stuck?** Check these docs in order:

1. **This file** - Overview and quick steps
2. `MANUAL_UPDATES_REQUIRED.md` - Detailed code changes
3. `MVP_PHASE1_IMPLEMENTATION_STATUS.md` - Full status and reference

**Common Issues**:
- Database error → Check migration ran successfully
- API error → Check server.js imports and routes
- Frontend not loading → Check browser console
- Subscription null → Check middleware attached

---

## 🎓 NEXT STEPS

After MVP is stable (1-2 weeks):

**Phase 2**: Tiered Pricing
- Add 30/60/90/120/150/180 day plans
- Update `subscription_plans_v2` table
- Update pricing.html with duration selector
- Keep access control same (all PAID tiers = same access)

**Phase 3**: AI Analytics
- Track user performance by topic
- Recommend personalized MCQs
- Adaptive learning paths

---

## 📞 READY TO START?

**Step 1**: Run database migrations (5 min)  
**Step 2**: Update server.js (10 min)  
**Step 3**: Update HTML files (20 min)  
**Step 4**: Test with test users (10 min)

**Total**: ~45 minutes to full implementation

Let's go! 🚀
