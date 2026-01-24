#!/bin/bash
# ================================================================
# MVP PHASE 1 - Automated Database Migration
# Using credentials from .env file
# ================================================================

echo "========================================"
echo "MVP PHASE 1 - Database Migration"
echo "========================================"
echo ""

CONTAINER="cpale-mysql"
DB_USER="cpale_user"
DB_PASS="cpale_password"
DB_NAME="cpale_explained"

# Check container
if ! docker ps | grep -q "$CONTAINER"; then
    echo "ERROR: Container '$CONTAINER' not running"
    exit 1
fi

echo "✓ Container running: $CONTAINER"
echo "✓ Database: $DB_NAME"
echo ""

echo "Step 1/5: Creating backup..."
docker exec -i "$CONTAINER" mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < database/migrations/mvp_phase1_backup.sql 2>&1 | grep -v "Warning"
echo "✓ Backup complete"
echo ""

echo "Step 2/5: Running main migration..."
docker exec -i "$CONTAINER" mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < database/migrations/mvp_phase1_migration.sql 2>&1 | grep -v "Warning"
echo "✓ Migration complete"
echo ""

echo "Step 3/5: Selecting 50 FREE MCQs..."
docker exec -i "$CONTAINER" mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < database/migrations/mvp_phase1_select_free_mcqs.sql 2>&1 | grep -v "Warning"
echo "✓ FREE MCQs selected"
echo ""

echo "Step 4/5: Creating test users..."
docker exec -i "$CONTAINER" mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < database/migrations/mvp_phase1_test_data.sql 2>&1 | grep -v "Warning"
echo "✓ Test users created"
echo ""

echo "Step 5/5: Verifying migration..."
docker exec -i "$CONTAINER" mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "
SELECT 'subscription_plans_v2' as table_name, COUNT(*) as rows FROM subscription_plans_v2
UNION ALL SELECT 'user_subscriptions_v2', COUNT(*) FROM user_subscriptions_v2
UNION ALL SELECT 'user_mcq_usage', COUNT(*) FROM user_mcq_usage
UNION ALL SELECT 'FREE MCQs', COUNT(*) FROM questions WHERE access_type='FREE';
" 2>&1 | grep -v "Warning"

echo ""
echo "========================================"
echo "✓ ALL MIGRATIONS COMPLETED!"
echo "========================================"
echo ""
echo "Test Users:"
echo "  testfree@cpale.com / Test123!"
echo "  testpaid@cpale.com / Test123!"
echo "  testexpired@cpale.com / Test123!"
echo ""
