#!/bin/bash
# ================================================================
# MVP PHASE 1 - Database Migration Execution Script (Bash version)
# Run this script to execute all database migrations
# ================================================================

echo "========================================"
echo "MVP PHASE 1 - Database Migration"
echo "========================================"
echo ""

# Check if MySQL is accessible
if ! command -v mysql &> /dev/null; then
    echo "ERROR: MySQL command not found in PATH"
    echo ""
    echo "Please use one of these methods instead:"
    echo "1. Run from Windows CMD: run_migrations.bat"
    echo "2. MySQL Workbench - Open and execute each .sql file"
    echo "3. Docker: docker exec -i mysql_container mysql -u root -p cpale_explained < migration.sql"
    echo ""
    exit 1
fi

# Database credentials
DB_USER="root"
DB_NAME="cpale_explained"

echo "Enter MySQL root password:"
read -s DB_PASS
echo ""

echo "Step 1/5: Creating backup..."
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < database/migrations/mvp_phase1_backup.sql
if [ $? -ne 0 ]; then
    echo "ERROR: Backup failed!"
    exit 1
fi
echo "✓ Backup complete"
echo ""

echo "Step 2/5: Running main migration..."
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < database/migrations/mvp_phase1_migration.sql
if [ $? -ne 0 ]; then
    echo "ERROR: Migration failed!"
    exit 1
fi
echo "✓ Migration complete"
echo ""

echo "Step 3/5: Selecting 50 FREE MCQs..."
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < database/migrations/mvp_phase1_select_free_mcqs.sql
if [ $? -ne 0 ]; then
    echo "ERROR: FREE MCQ selection failed!"
    exit 1
fi
echo "✓ FREE MCQs selected"
echo ""

echo "Step 4/5: Creating test users..."
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < database/migrations/mvp_phase1_test_data.sql
if [ $? -ne 0 ]; then
    echo "ERROR: Test data creation failed!"
    exit 1
fi
echo "✓ Test users created"
echo ""

echo "Step 5/5: Verifying migration..."
mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "SELECT 'subscription_plans_v2' as table_name, COUNT(*) as rows FROM subscription_plans_v2 UNION ALL SELECT 'user_subscriptions_v2', COUNT(*) FROM user_subscriptions_v2 UNION ALL SELECT 'FREE MCQs', COUNT(*) FROM questions WHERE access_type='FREE';"

echo ""
echo "========================================"
echo "✓ ALL MIGRATIONS COMPLETED SUCCESSFULLY!"
echo "========================================"
echo ""
echo "Test Users Created:"
echo "- testfree@cpale.com / Test123!"
echo "- testpaid@cpale.com / Test123!"
echo "- testexpired@cpale.com / Test123!"
echo ""
