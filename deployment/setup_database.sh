#!/bin/bash
# CPALE Explained - Database Setup Script
# Creates database, user, and imports data

set -e

echo "=========================================="
echo "CPALE Explained - Database Setup"
echo "=========================================="
echo ""

# MySQL root password (set during install)
MYSQL_ROOT_PASSWORD="CpaleRootPass2026!"

# Production credentials
DB_NAME="cpale_explained"
DB_USER="cpale_user"
DB_PASSWORD="Cpale2026SecurePass!"

echo "Step 1: Creating database and user..."
mysql -u root -p"$MYSQL_ROOT_PASSWORD" <<EOF
-- Create database
CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create user
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';

-- Grant privileges
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';

-- Flush privileges
FLUSH PRIVILEGES;

-- Show databases
SHOW DATABASES;
EOF

echo "✅ Database and user created"
echo ""

echo "Step 2: Importing database dump..."
if [ -f "/root/cpale_db_backup.sql" ]; then
    mysql -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < /root/cpale_db_backup.sql
    echo "✅ Database imported successfully"
    echo ""
    
    echo "Step 3: Verifying import..."
    mysql -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" <<EOF
SELECT 
    (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = '$DB_NAME') as 'Total Tables',
    (SELECT COUNT(*) FROM users) as 'Total Users',
    (SELECT COUNT(*) FROM questions) as 'Total Questions';
EOF
    echo ""
else
    echo "⚠️  Database dump not found at /root/cpale_db_backup.sql"
    echo "Please upload the database backup file and run this script again"
    exit 1
fi

echo "=========================================="
echo "✅ Database setup complete!"
echo "=========================================="
echo ""
echo "Database credentials:"
echo "  Host: localhost"
echo "  Port: 3306"
echo "  Database: $DB_NAME"
echo "  User: $DB_USER"
echo "  Password: $DB_PASSWORD"
echo ""
echo "Next step: Run deploy_application.sh"
echo ""
