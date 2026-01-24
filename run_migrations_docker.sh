#!/bin/bash
# ================================================================
# MVP PHASE 1 - Database Migration (Docker version)
# Executes migrations on cpale-mysql Docker container
# ================================================================

echo "========================================"
echo "MVP PHASE 1 - Database Migration (Docker)"
echo "========================================"
echo ""

# Container and database settings
CONTAINER="cpale-mysql"
DB_USER="root"
DB_NAME="cpale_explained"

# Check if container is running
if ! docker ps | grep -q "$CONTAINER"; then
    echo "ERROR: Container '$CONTAINER' is not running"
    echo "Start it with: docker start $CONTAINER"
    exit 1
fi

echo "Using Docker container: $CONTAINER"
echo "Database: $DB_NAME"
echo ""

echo "Enter MySQL root password (default is often 'root' or 'password'):"
read -s DB_PASS
echo ""

# Test connection
echo "Testing database connection..."
if ! docker exec -i "$CONTAINER" mysql -u "$DB_USER" -p"$DB_PASS" -e "USE $DB_NAME;" 2>/dev/null; then
    echo "ERROR: Cannot connect to database"
    echo "Please check:"
    echo "1. MySQL password is correct"
    echo "2. Database '$DB_NAME' exists"
    exit 1
fi
echo "✓ Connection successful"
echo ""

echo "Step 1/5: Creating backup..."
if docker exec -i "$CONTAINER" mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < database/migrations/mvp_phase1_backup.sql 2>/dev/null; then
    echo "✓ Backup complete"
else
    echo "ERROR: Backup failed!"
    echo "Check if database tables exist"
    exit 1
fi
echo ""

echo "Step 2/5: Running main migration..."
if docker exec -i "$CONTAINER" mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < database/migrations/mvp_phase1_migration.sql 2>/dev/null; then
    echo "✓ Migration complete"
else
    echo "ERROR: Migration failed!"
    echo "Check migration SQL for errors"
    exit 1
fi
echo ""

echo "Step 3/5: Selecting 50 FREE MCQs..."
if docker exec -i "$CONTAINER" mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < database/migrations/mvp_phase1_select_free_mcqs.sql 2>/dev/null; then
    echo "✓ FREE MCQs selected"
else
    echo "WARNING: FREE MCQ selection had issues (may be normal if re-running)"
fi
echo ""

echo "Step 4/5: Creating test users..."
if docker exec -i "$CONTAINER" mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < database/migrations/mvp_phase1_test_data.sql 2>/dev/null; then
    echo "✓ Test users created"
else
    echo "WARNING: Test data creation had issues (may be normal if re-running)"
fi
echo ""

echo "Step 5/5: Verifying migration..."
docker exec -i "$CONTAINER" mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "
SELECT 'subscription_plans_v2' as table_name, COUNT(*) as rows 
FROM subscription_plans_v2 
UNION ALL 
SELECT 'user_subscriptions_v2', COUNT(*) 
FROM user_subscriptions_v2 
UNION ALL 
SELECT 'user_mcq_usage', COUNT(*) 
FROM user_mcq_usage
UNION ALL 
SELECT 'FREE MCQs', COUNT(*) 
FROM questions WHERE access_type='FREE';
" 2>/dev/null

echo ""
echo "========================================"
echo "✓ MIGRATION COMPLETED!"
echo "========================================"
echo ""
echo "Test Users Created:"
echo "  Email: testfree@cpale.com"
echo "  Password: Test123!"
echo "  Plan: FREE (15/50 MCQs used)"
echo ""
echo "  Email: testpaid@cpale.com"
echo "  Password: Test123!"
echo "  Plan: PAID (Active, 25 days remaining)"
echo ""
echo "  Email: testexpired@cpale.com"
echo "  Password: Test123!"
echo "  Plan: PAID (Expired 5 days ago)"
echo ""
echo "Next steps:"
echo "1. Start backend: cd backend && npm start"
echo "2. Test API: curl http://localhost:5000/api/health"
echo "3. Update frontend HTML files (see NEXT_STEPS.md)"
echo ""
