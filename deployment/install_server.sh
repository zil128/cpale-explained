#!/bin/bash
# CPALE Explained - Server Installation Script
# Run this script on your DigitalOcean droplet to install all required software

set -e  # Exit on error

echo "=========================================="
echo "CPALE Explained - Server Setup"
echo "=========================================="
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root (or use: sudo bash install_server.sh)"
    exit 1
fi

echo "Step 1: Update system packages..."
apt update
apt upgrade -y

echo ""
echo "Step 2: Install basic utilities..."
apt install -y curl wget git vim htop ufw

echo ""
echo "Step 3: Install Node.js 18.x..."
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt install -y nodejs
    echo "✅ Node.js installed: $(node --version)"
else
    echo "✅ Node.js already installed: $(node --version)"
fi

echo ""
echo "Step 4: Install MySQL 5.7..."
if ! command -v mysql &> /dev/null; then
    # Download MySQL APT config
    wget https://dev.mysql.com/get/mysql-apt-config_0.8.22-1_all.deb
    
    # Non-interactive install - select MySQL 5.7
    echo "mysql-apt-config mysql-apt-config/select-server select mysql-5.7" | debconf-set-selections
    DEBIAN_FRONTEND=noninteractive dpkg -i mysql-apt-config_0.8.22-1_all.deb
    
    apt update
    
    # Set root password non-interactively
    echo "mysql-server mysql-server/root_password password CpaleRootPass2026!" | debconf-set-selections
    echo "mysql-server mysql-server/root_password_again password CpaleRootPass2026!" | debconf-set-selections
    
    DEBIAN_FRONTEND=noninteractive apt install -y mysql-server
    
    # Start MySQL
    systemctl start mysql
    systemctl enable mysql
    
    echo "✅ MySQL installed: $(mysql --version)"
    echo "⚠️  MySQL root password: CpaleRootPass2026!"
else
    echo "✅ MySQL already installed: $(mysql --version)"
fi

echo ""
echo "Step 5: Install Nginx..."
if ! command -v nginx &> /dev/null; then
    apt install -y nginx
    systemctl start nginx
    systemctl enable nginx
    echo "✅ Nginx installed: $(nginx -v 2>&1)"
else
    echo "✅ Nginx already installed: $(nginx -v 2>&1)"
fi

echo ""
echo "Step 6: Install PM2 process manager..."
if ! command -v pm2 &> /dev/null; then
    npm install -g pm2
    echo "✅ PM2 installed: $(pm2 --version)"
else
    echo "✅ PM2 already installed: $(pm2 --version)"
fi

echo ""
echo "Step 7: Install Certbot for SSL..."
if ! command -v certbot &> /dev/null; then
    apt install -y certbot python3-certbot-nginx
    echo "✅ Certbot installed"
else
    echo "✅ Certbot already installed"
fi

echo ""
echo "Step 8: Configure firewall..."
ufw --force reset
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp comment 'SSH'
ufw allow 80/tcp comment 'HTTP'
ufw allow 443/tcp comment 'HTTPS'
ufw --force enable
echo "✅ Firewall configured"

echo ""
echo "=========================================="
echo "✅ Server setup complete!"
echo "=========================================="
echo ""
echo "Installed software:"
echo "  - Node.js: $(node --version)"
echo "  - npm: $(npm --version)"
echo "  - MySQL: $(mysql --version | head -n1)"
echo "  - Nginx: $(nginx -v 2>&1)"
echo "  - PM2: $(pm2 --version)"
echo "  - Git: $(git --version)"
echo ""
echo "MySQL root password: CpaleRootPass2026!"
echo ""
echo "Next step: Run setup_database.sh"
echo ""
