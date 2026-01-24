# 🚀 CPALE Explained - Quick Start Deployment

## ONE-TIME SETUP (Do These First)

### 1️⃣ Configure Namecheap DNS (5 minutes)
**Do this NOW to allow DNS propagation while you work!**

1. Go to: https://ap.www.namecheap.com/domains/list/
2. Find **cpaleexplained.com** → Click **Manage**
3. Go to **Advanced DNS** tab
4. Add these A Records:

```
Type: A Record | Host: @ | Value: 143.198.206.143 | TTL: 300
Type: A Record | Host: www | Value: 143.198.206.143 | TTL: 300
```

5. Save changes
6. **Wait 5-60 minutes for propagation** (continue with other steps meanwhile)

### 2️⃣ Upload Database Backup to Droplet

**Option A: From your Windows machine (if you can get SSH working)**
```bash
scp cpale_db_backup.sql root@143.198.206.143:/root/
```

**Option B: Using DigitalOcean Console (RECOMMENDED)**
1. Open: DigitalOcean → Droplets → cpaleexplained-server
2. Click **Access** → **Launch Droplet Console**
3. Login as root
4. Create database file:
```bash
# You'll need to paste the database content
# We'll provide instructions below for this
```

---

## 🎯 AUTOMATED DEPLOYMENT (Run on Droplet)

### Connect to Droplet Console
1. Login to DigitalOcean
2. Navigate to: Droplets → cpaleexplained-server
3. Click: **Access** → **Launch Droplet Console**
4. Login as **root**

### Run These Commands in Order

```bash
# Navigate to root home
cd /root

# Clone the repository
git clone https://github.com/zil128/cpale-explained.git
cd cpale-explained/deployment

# Make scripts executable
chmod +x *.sh

# Run deployment scripts
bash install_server.sh      # ~15 minutes - Installs all software
bash setup_database.sh      # ~2 minutes - Creates database
bash deploy_application.sh  # ~5 minutes - Deploys code
bash setup_nginx.sh         # ~1 minute - Configures web server

# Wait for DNS propagation, then:
bash setup_ssl.sh          # ~2 minutes - Installs SSL certificate
```

---

## 📋 DETAILED STEPS

### STEP 1: Install Server Software
```bash
bash install_server.sh
```
**What it does:**
- Updates system packages
- Installs Node.js 18.x
- Installs MySQL 5.7 (root password: `CpaleRootPass2026!`)
- Installs Nginx web server
- Installs PM2 process manager
- Installs Certbot for SSL
- Configures firewall

**Expected output:**
```
✅ Server setup complete!
Node.js: v18.x.x
MySQL: 5.7.x
Nginx: installed
```

---

### STEP 2: Setup Database
```bash
bash setup_database.sh
```
**What it does:**
- Creates database: `cpale_explained`
- Creates user: `cpale_user` (password: `Cpale2026SecurePass!`)
- Imports database from `/root/cpale_db_backup.sql`
- Verifies data import

**Expected output:**
```
✅ Database setup complete!
Total Tables: 61
Total Users: 6
Total Questions: 275
```

**⚠️ IMPORTANT:** Make sure `/root/cpale_db_backup.sql` exists before running this!

---

### STEP 3: Deploy Application
```bash
bash deploy_application.sh
```
**What it does:**
- Clones repository to `/var/www/cpaleexplained`
- Installs npm dependencies
- Generates secure JWT secret
- Creates production `.env` file
- Updates frontend API URLs
- Starts app with PM2

**Expected output:**
```
✅ Application deployment complete!
PM2 Status: online
```

---

### STEP 4: Configure Nginx
```bash
bash setup_nginx.sh
```
**What it does:**
- Creates Nginx configuration
- Sets up reverse proxy (API requests)
- Configures static file serving
- Enables site and reloads Nginx

**Expected output:**
```
✅ Nginx setup complete!
Your site should now be accessible at:
  http://cpaleexplained.com
```

**Test now:** Open http://143.198.206.143 in browser (should show your site)

---

### STEP 5: Setup SSL Certificate
**⚠️ WAIT for DNS propagation first!**

**Check DNS:**
```bash
nslookup cpaleexplained.com
```
Should return: `143.198.206.143`

**If DNS is ready, run:**
```bash
bash setup_ssl.sh
```

**You'll be prompted for:**
1. Email address (for certificate renewal notifications)
2. Agree to Terms of Service: **Y**
3. Share email with EFF: **N** (optional)

**Expected output:**
```
✅ SSL setup complete!
Your site is now accessible via HTTPS:
  https://cpaleexplained.com
```

---

## ✅ VERIFICATION CHECKLIST

### Check Services
```bash
# PM2 application status
pm2 status
# Should show: cpale-api | online

# Nginx status
systemctl status nginx
# Should show: active (running)

# MySQL status
systemctl status mysql
# Should show: active (running)
```

### Test API
```bash
curl http://localhost:5000/api/health
# Should return: {"status":"healthy"}
```

### Test Website
Open in browser:
- ✅ http://143.198.206.143 (should work immediately)
- ✅ http://cpaleexplained.com (after DNS propagation)
- ✅ https://cpaleexplained.com (after SSL setup)

### Test Functionality
1. **Landing Page** - Loads correctly
2. **Registration** - Create new account
3. **Login** - Login with credentials
4. **Dashboard** - Shows subscription info
5. **Quiz** - Questions load and work
6. **Payment** - Modal opens and works
7. **Admin** - Dashboard loads stats

---

## 🔧 USEFUL COMMANDS

### View Logs
```bash
# Application logs
pm2 logs cpale-api

# Nginx access logs
tail -f /var/log/nginx/cpaleexplained_access.log

# Nginx error logs
tail -f /var/log/nginx/cpaleexplained_error.log
```

### Restart Services
```bash
pm2 restart cpale-api       # Restart Node.js app
systemctl restart nginx     # Restart web server
systemctl restart mysql     # Restart database
```

### Monitor Resources
```bash
htop                        # System resources
pm2 monit                   # PM2 monitoring
df -h                       # Disk usage
free -m                     # Memory usage
```

---

## 🚨 TROUBLESHOOTING

### Issue: Database backup not found
```bash
# Check if file exists
ls -lh /root/cpale_db_backup.sql

# If missing, you need to upload it
# Use DigitalOcean Console file upload or create manually
```

### Issue: PM2 app won't start
```bash
# Check logs
pm2 logs cpale-api --lines 50

# Common cause: Database connection
# Check .env file
cat /var/www/cpaleexplained/.env

# Test database connection
mysql -u cpale_user -pCpale2026SecurePass! cpale_explained -e "SELECT 1;"
```

### Issue: Nginx 502 Bad Gateway
```bash
# Check if backend is running
pm2 status
curl http://localhost:5000/api/health

# If not running, restart
pm2 restart cpale-api
```

### Issue: DNS not resolving
```bash
# Check DNS propagation
nslookup cpaleexplained.com
ping cpaleexplained.com

# If not resolved, wait longer (up to 60 minutes)
# You can still access via IP: http://143.198.206.143
```

---

## 📊 EXPECTED RESULTS

After successful deployment:

✅ **Database**: 61 tables, 6 users, 275 questions  
✅ **Website**: Accessible via HTTPS  
✅ **API**: Responding in < 100ms  
✅ **SSL**: Valid Let's Encrypt certificate  
✅ **Uptime**: 99.9%+ with PM2 auto-restart  

---

## 🎉 YOU'RE DONE!

Your CPALE Explained application is now live at:
**https://cpaleexplained.com**

Users can now:
- Register for free accounts
- Take practice quizzes
- Upgrade to paid subscriptions
- Make payments via GCash/Maya/Bank

---

## 🔐 SAVE THESE CREDENTIALS

**MySQL Root:**
- User: `root`
- Password: `CpaleRootPass2026!`

**MySQL Application:**
- Host: `localhost`
- Port: `3306`
- Database: `cpale_explained`
- User: `cpale_user`
- Password: `Cpale2026SecurePass!`

**JWT Secret:**
- Auto-generated (stored in `/var/www/cpaleexplained/.env`)

---

**Total Time**: ~25 minutes active work + DNS propagation wait

Need help? Check the full README.md in the deployment folder!
