@echo off
REM ================================================================
REM MVP PHASE 1 - Database Migration Execution Script
REM Run this script to execute all database migrations
REM ================================================================

echo ========================================
echo MVP PHASE 1 - Database Migration
echo ========================================
echo.

REM Check if MySQL is accessible
mysql --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: MySQL is not in PATH
    echo.
    echo Please use one of these methods instead:
    echo 1. MySQL Workbench - Open and execute each .sql file
    echo 2. Docker: docker exec -i mysql_container mysql -u root -p cpale_explained ^< migration.sql
    echo 3. phpMyAdmin - Import each .sql file through web interface
    echo.
    pause
    exit /b 1
)

REM Set database credentials
set DB_USER=root
set DB_NAME=cpale_explained

echo Enter MySQL root password:
set /p DB_PASS=

echo.
echo Step 1/5: Creating backup...
mysql -u %DB_USER% -p%DB_PASS% %DB_NAME% < database\migrations\mvp_phase1_backup.sql
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Backup failed!
    pause
    exit /b 1
)
echo ✓ Backup complete

echo.
echo Step 2/5: Running main migration...
mysql -u %DB_USER% -p%DB_PASS% %DB_NAME% < database\migrations\mvp_phase1_migration.sql
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Migration failed!
    pause
    exit /b 1
)
echo ✓ Migration complete

echo.
echo Step 3/5: Selecting 50 FREE MCQs...
mysql -u %DB_USER% -p%DB_PASS% %DB_NAME% < database\migrations\mvp_phase1_select_free_mcqs.sql
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: FREE MCQ selection failed!
    pause
    exit /b 1
)
echo ✓ FREE MCQs selected

echo.
echo Step 4/5: Creating test users...
mysql -u %DB_USER% -p%DB_PASS% %DB_NAME% < database\migrations\mvp_phase1_test_data.sql
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Test data creation failed!
    pause
    exit /b 1
)
echo ✓ Test users created

echo.
echo Step 5/5: Verifying migration...
mysql -u %DB_USER% -p%DB_PASS% %DB_NAME% -e "SELECT 'subscription_plans_v2' as table_name, COUNT(*) as rows FROM subscription_plans_v2 UNION ALL SELECT 'user_subscriptions_v2', COUNT(*) FROM user_subscriptions_v2 UNION ALL SELECT 'FREE MCQs', COUNT(*) FROM questions WHERE access_type='FREE';"

echo.
echo ========================================
echo ✓ ALL MIGRATIONS COMPLETED SUCCESSFULLY!
echo ========================================
echo.
echo Test Users Created:
echo - testfree@cpale.com / Test123!
echo - testpaid@cpale.com / Test123!
echo - testexpired@cpale.com / Test123!
echo.
pause
