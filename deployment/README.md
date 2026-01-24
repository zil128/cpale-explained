# CPALE Explained - Deployment Guide

This directory contains all scripts and configuration files needed to deploy CPALE Explained to your DigitalOcean droplet.

## 📋 Prerequisites

1. **DigitalOcean Droplet**: cpaleexplained-server @ 143.198.206.143
2. **Domain**: cpaleexplained.com (configured in Namecheap)
3. **SSH Access**: Via DigitalOcean Console or SSH client
4. **Database Backup**: cpale_db_backup.sql (in project root)

## 🚀 Quick Deployment (5 Steps)

### Step 1: Configure DNS (Do this FIRST)

Go to Namecheap DNS settings and add these A records:

| Type | Host | Value | TTL |
|------|------|-------|-----|
| A Record | @ | 143.198.206.143 | 300 |
| A Record | www | 143.198.206.143 | 300 |

**Wait time**: 5-60 minutes for DNS propagation

### Step 2: Access Droplet Console

1. Login to DigitalOcean
2. Go to Droplets → cpaleexplained-server
3. Click "Access" → "Launch Droplet Console"
4. Login as root

### Step 3: Upload Database Backup

**Option A: Using SCP (from your local machine)**
```bash
scp cpale_db_backup.sql root@143.198.206.143:/root/
```

**Option B: Using DigitalOcean Console**
1. Open DigitalOcean Console
2. Create the file manually:
```bash
nano /root/cpale_db_backup.sql
# Paste the contents and save (Ctrl+X, Y, Enter)
```

**Option C: Using wget (if uploaded to cloud storage)**
```bash
wget -O /root/cpale_db_backup.sql "YOUR_CLOUD_STORAGE_URL"
```

### Step 4: Clone Deployment Repository

On the droplet console:
```bash
cd /root
git clone https://github.com/zil128/cpale-explained.git
cd cpale-explained/deployment
chmod +x *.sh
```

### Step 5: Run Deployment Scripts

Execute scripts in order:

```bash
# 1. Install all required software (Node.js, MySQL, Nginx, PM2)
bash install_server.sh

# 2. Setup database and import data
bash setup_database.sh

# 3. Deploy application code
bash deploy_application.sh

# 4. Configure Nginx
bash setup_nginx.sh

# 5. Setup SSL (wait for DNS propagation first!)
bash setup_ssl.sh
```

## 📝 Detailed Script Descriptions

### 1. install_server.sh
**What it does:**
- Updates system packages
- Installs Node.js 18.x
- Installs MySQL 5.7
- Installs Nginx web server
- Installs PM2 process manager
- Installs Certbot for SSL
- Configures firewall (UFW)

**Time**: ~15 minutes

**Important**: MySQL root password will be set to `CpaleRootPass2026!`

### 2. setup_database.sh
**What it does:**
- Creates database: cpale_explained
- Creates user: cpale_user
- Imports database from /root/cpale_db_backup.sql
- Verifies tables, users, and questions count

**Time**: ~2 minutes

**Requirements**: cpale_db_backup.sql must be in /root/

### 3. deploy_application.sh
**What it does:**
- Clones repository from GitHub
- Installs npm dependencies
- Generates secure JWT secret
- Creates production .env file
- Updates frontend API URLs
- Starts application with PM2

**Time**: ~5 minutes

**Important**: PM2 will auto-start on server reboot

### 4. setup_nginx.sh
**What it does:**
- Creates Nginx configuration
- Sets up reverse proxy for API
- Configures static file serving
- Enables site and reloads Nginx

**Time**: ~1 minute

**Test**: Your site will be accessible via HTTP after this step

### 5. setup_ssl.sh
**What it does:**
- Obtains Let's Encrypt SSL certificate
- Configures HTTPS
- Sets up auto-renewal

**Time**: ~2 minutes

**Requirements**: DNS must be propagated first!

## ✅ Post-Deployment Verification

### Check Services Status
```bash
# PM2 application
pm2 status

# Nginx web server
systemctl status nginx

# MySQL database
systemctl status mysql
```

### View Logs
```bash
# Application logs
pm2 logs cpale-api

# Nginx access logs
tail -f /var/log/nginx/cpaleexplained_access.log

# Nginx error logs
tail -f /var/log/nginx/cpaleexplained_error.log
```

### Test API Endpoint
```bash
curl http://localhost:5000/api/health
# Should return: {"status":"healthy"}
```

### Test Website
Open in browser:
- http://cpaleexplained.com (before SSL)
- https://cpaleexplained.com (after SSL)

## 🔧 Maintenance Commands

### Update Application
```bash
cd /var/www/cpaleexplained
git pull origin main
npm install
pm2 restart cpale-api
```

### Restart Services
```bash
pm2 restart cpale-api        # Restart Node.js app
systemctl restart nginx      # Restart web server
systemctl restart mysql      # Restart database
```

### Backup Database
```bash
mysqldump -u cpale_user -pCpale2026SecurePass! cpale_explained > backup_$(date +%Y%m%d).sql
```

### View Resource Usage
```bash
htop                        # Interactive process viewer
pm2 monit                   # PM2 monitoring
df -h                       # Disk usage
free -m                     # Memory usage
```

## 🚨 Troubleshooting

### Issue: DNS not resolving
```bash
nslookup cpaleexplained.com
ping cpaleexplained.com
```
**Solution**: Wait for DNS propagation (up to 60 minutes)

### Issue: PM2 app not starting
```bash
pm2 logs cpale-api --lines 100
```
**Common causes**: Database connection error, missing .env file

### Issue: Nginx 502 Bad Gateway
```bash
# Check if backend is running
pm2 status
curl http://localhost:5000/api/health
```
**Solution**: Restart PM2 app

### Issue: Database connection refused
```bash
systemctl status mysql
mysql -u cpale_user -p
```
**Solution**: Check MySQL is running and credentials are correct

## 📊 Expected Results

After successful deployment:

- **Tables**: 61 database tables
- **Users**: 6 users imported
- **Questions**: 275 questions imported
- **Database Size**: ~3.6 MB
- **API Response Time**: < 100ms
- **SSL Certificate**: Valid Let's Encrypt certificate
- **Uptime**: 99.9%+ with PM2 auto-restart

## 🔐 Important Credentials

Save these credentials securely:

**MySQL Root:**
- User: root
- Password: CpaleRootPass2026!

**MySQL Application:**
- User: cpale_user
- Password: Cpale2026SecurePass!
- Database: cpale_explained

**JWT Secret:**
- Auto-generated during deployment
- Stored in /var/www/cpaleexplained/.env

## 📞 Support

If you encounter issues:

1. Check logs: `pm2 logs cpale-api`
2. Verify services: `systemctl status nginx mysql`
3. Test API: `curl http://localhost:5000/api/health`
4. Review Nginx logs: `tail -f /var/log/nginx/cpaleexplained_error.log`

## 🎉 Success Checklist

- [ ] DNS configured in Namecheap
- [ ] All scripts executed successfully
- [ ] PM2 shows app running
- [ ] Nginx configuration valid
- [ ] Database imported (61 tables, 6 users, 275 questions)
- [ ] Website loads via HTTP
- [ ] SSL certificate installed
- [ ] Website loads via HTTPS
- [ ] Login/Registration works
- [ ] Quiz loads questions
- [ ] Payment flow functional
- [ ] Admin dashboard accessible

**Total deployment time**: ~1-2 hours (including DNS propagation)
