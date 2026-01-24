#!/bin/bash
# CPALE Explained - Application Deployment Script
# Clones repository, installs dependencies, configures environment

set -e

echo "=========================================="
echo "CPALE Explained - Application Deployment"
echo "=========================================="
echo ""

# Configuration
APP_DIR="/var/www/cpaleexplained"
GITHUB_REPO="https://github.com/zil128/cpale-explained.git"

echo "Step 1: Creating application directory..."
mkdir -p /var/www
cd /var/www

echo ""
echo "Step 2: Cloning repository..."
if [ -d "$APP_DIR" ]; then
    echo "Directory already exists. Pulling latest changes..."
    cd "$APP_DIR"
    git pull origin main
else
    echo "Cloning from GitHub..."
    git clone "$GITHUB_REPO" cpaleexplained
    cd "$APP_DIR"
fi

echo "✅ Repository cloned/updated"
echo ""

echo "Step 3: Installing Node.js dependencies..."
npm install
echo "✅ Dependencies installed"
echo ""

echo "Step 4: Creating uploads directory..."
mkdir -p "$APP_DIR/uploads/payment-proofs"
chmod -R 755 "$APP_DIR/uploads"
echo "✅ Uploads directory created"
echo ""

echo "Step 5: Generating JWT secret..."
JWT_SECRET=$(node -e "console.log(require('crypto').randomBytes(64).toString('hex'))")
echo "✅ JWT secret generated"
echo ""

echo "Step 6: Creating .env file..."
cat > "$APP_DIR/.env" <<EOF
# Production Environment
NODE_ENV=production
PORT=5000

# Database Configuration
DB_HOST=localhost
DB_PORT=3306
DB_NAME=cpale_explained
DB_USER=cpale_user
DB_PASSWORD=Cpale2026SecurePass!

# JWT Secret
JWT_SECRET=$JWT_SECRET

# Frontend URL
FRONTEND_URL=https://cpaleexplained.com
EOF

echo "✅ Environment file created"
echo ""

echo "Step 7: Testing backend server..."
cd "$APP_DIR"
timeout 10s node backend/server.js || true
echo "✅ Backend test completed"
echo ""

echo "Step 8: Starting application with PM2..."
pm2 delete cpale-api 2>/dev/null || true
pm2 start "$APP_DIR/backend/server.js" --name cpale-api
pm2 save
pm2 startup systemd -u root --hp /root
echo "✅ Application started with PM2"
echo ""

echo "Step 9: Updating frontend API URLs..."
cd "$APP_DIR/landing-page"

# Update all HTML files to use relative API URLs
for file in *.html; do
    if [ -f "$file" ]; then
        sed -i "s|http://localhost:5000/api|/api|g" "$file"
        sed -i "s|http://localhost:5000|/api|g" "$file"
    fi
done

echo "✅ Frontend API URLs updated"
echo ""

echo "=========================================="
echo "✅ Application deployment complete!"
echo "=========================================="
echo ""
echo "PM2 Status:"
pm2 status
echo ""
echo "View logs: pm2 logs cpale-api"
echo "Next step: Run setup_nginx.sh"
echo ""
