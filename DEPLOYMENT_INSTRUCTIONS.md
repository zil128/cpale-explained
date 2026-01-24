# 🚀 CPALE Explained - Production Deployment Instructions

## ✅ DEPLOYMENT READY!

All deployment files have been created and pushed to GitHub. You can now deploy your application to the DigitalOcean droplet.

---

## 📦 What's Been Prepared

### Deployment Scripts (in `deployment/` folder)
1. **install_server.sh** - Installs all required software (Node.js, MySQL, Nginx, PM2)
2. **setup_database.sh** - Creates database and imports your data
3. **deploy_application.sh** - Deploys the application code
4. **setup_nginx.sh** - Configures the web server
5. **setup_ssl.sh** - Installs SSL certificate

### Database Backup
- **cpale_db_backup.sql** - Complete database export (684KB)
  - 61 tables
  - 6 users
  - 275 questions
  - All subscription and payment data

### Configuration Files
- **ecosystem.config.js** - PM2 process manager configuration
- **deployment/.env.production** - Production environment template

### Documentation
- **deployment/README.md** - Detailed deployment guide
- **deployment/QUICK_START.md** - Quick start instructions

---

## 🎯 DEPLOYMENT STEPS (Copy & Paste Ready)

### STEP 1: Configure DNS in Namecheap (DO THIS FIRST!)

1. Go to: https://ap.www.namecheap.com/domains/list/
2. Find **cpaleexplained.com** → Click **Manage**
3. Go to **Advanced DNS** tab
4. Add these A Records:

```
Type: A Record | Host: @ | Value: 143.198.206.143 | TTL: 300
Type: A Record | Host: www | Value: 143.198.206.143 | TTL: 300
```

5. Save and wait 5-60 minutes for DNS propagation

---

### STEP 2: Access Your Droplet Console

**Option A: DigitalOcean Web Console (RECOMMENDED)**
1. Login to DigitalOcean: https://cloud.digitalocean.com/
2. Go to: Droplets → cpaleexplained-server
3. Click: **Access** → **Launch Droplet Console**
4. Login as: **root**

**Option B: SSH Client (if enabled)**
```bash
ssh root@143.198.206.143
# Password: tu6in*Jjq7bznVe
```

---

### STEP 3: Run Automated Deployment

Copy and paste these commands into your droplet console:

```bash
# Navigate to root home directory
cd /root

# Clone the repository
git clone https://github.com/zil128/cpale-explained.git

# Navigate to deployment folder
cd cpale-explained/deployment

# Make scripts executable
chmod +x *.sh

# Run deployment scripts in order
echo "=========================================="
echo "Starting deployment process..."
echo "=========================================="

# 1. Install server software (~15 minutes)
bash install_server.sh

# 2. Setup database (~2 minutes)
bash setup_database.sh

# 3. Deploy application (~5 minutes)
bash deploy_application.sh

# 4. Configure web server (~1 minute)
bash setup_nginx.sh

# At this point, your site should be accessible via HTTP!
# Test: http://143.198.206.143 (or http://cpaleexplained.com if DNS resolved)

# 5. Setup SSL certificate (~2 minutes)
# IMPORTANT: Wait for DNS propagation before running this!
# Check DNS with: nslookup cpaleexplained.com
bash setup_ssl.sh
```

---

### STEP 4: Verify Deployment

After all scripts complete, verify everything is working:

**Check Services Status:**
```bash
# PM2 application status
pm2 status
# Should show: cpale-api | status: online

# Nginx web server
systemctl status nginx
# Should show: active (running)

# MySQL database
systemctl status mysql
# Should show: active (running)
```

**Test API Endpoint:**
```bash
curl http://localhost:5000/api/health
# Should return: {"status":"healthy"}
```

**Test Website:**
1. Open browser and go to: http://143.198.206.143
   - Should show your landing page
2. After DNS propagates: http://cpaleexplained.com
3. After SSL setup: https://cpaleexplained.com
   - Should show green padlock (secure)

**Test Functionality:**
- [ ] Landing page loads
- [ ] Registration works
- [ ] Login works
- [ ] Dashboard shows subscription
- [ ] Quiz loads questions
- [ ] Payment modal opens
- [ ] Admin dashboard loads

---

## 📊 Expected Results

After successful deployment:

✅ **Website URL**: https://cpaleexplained.com  
✅ **Database**: 61 tables, 6 users, 275 questions imported  
✅ **SSL Certificate**: Valid Let's Encrypt certificate  
✅ **Auto-Start**: PM2 configured to restart on server reboot  
✅ **API Response**: < 100ms response time  
✅ **Uptime**: 99.9%+ with automatic restart on crashes  

---

## 🔐 Important Credentials (SAVE THESE!)

**Droplet Access:**
- IP: 143.198.206.143
- User: root
- Password: tu6in*Jjq7bznVe

**MySQL Root:**
- User: root
- Password: CpaleRootPass2026!

**MySQL Application:**
- Host: localhost
- Port: 3306
- Database: cpale_explained
- User: cpale_user
- Password: Cpale2026SecurePass!

**Application Location:**
- Path: /var/www/cpaleexplained
- PM2 App Name: cpale-api

---

## 🔧 Useful Commands After Deployment

### View Application Logs
```bash
# Real-time application logs
pm2 logs cpale-api

# Last 100 lines
pm2 logs cpale-api --lines 100

# Error logs only
pm2 logs cpale-api --err
```

### Restart Services
```bash
# Restart Node.js application
pm2 restart cpale-api

# Restart Nginx
systemctl restart nginx

# Restart MySQL
systemctl restart mysql
```

### Monitor Resources
```bash
# PM2 monitoring
pm2 monit

# System resources
htop

# Disk usage
df -h

# Memory usage
free -m
```

### Update Application (After Making Code Changes)
```bash
cd /var/www/cpaleexplained
git pull origin master
npm install
pm2 restart cpale-api
```

### Backup Database
```bash
mysqldump -u cpale_user -pCpale2026SecurePass! cpale_explained > backup_$(date +%Y%m%d).sql
```

---

## 🚨 Troubleshooting Guide

### Issue: Scripts fail to execute
```bash
# Make sure scripts are executable
cd /root/cpale-explained/deployment
chmod +x *.sh

# Run scripts with bash
bash install_server.sh
```

### Issue: DNS not resolving
```bash
# Check DNS propagation
nslookup cpaleexplained.com

# If not resolved, access via IP
# http://143.198.206.143
```

### Issue: PM2 app not starting
```bash
# Check logs
pm2 logs cpale-api --lines 50

# Check .env file exists
cat /var/www/cpaleexplained/.env

# Restart app
pm2 restart cpale-api
```

### Issue: Database connection failed
```bash
# Check MySQL is running
systemctl status mysql

# Test database connection
mysql -u cpale_user -pCpale2026SecurePass! cpale_explained -e "SELECT 1;"

# Check credentials in .env
cat /var/www/cpaleexplained/.env | grep DB_
```

### Issue: Nginx 502 Bad Gateway
```bash
# Check if backend is running
pm2 status
curl http://localhost:5000/api/health

# If not running, restart
pm2 restart cpale-api

# Check Nginx logs
tail -f /var/log/nginx/cpaleexplained_error.log
```

### Issue: SSL certificate fails
```bash
# Make sure DNS is propagated first
nslookup cpaleexplained.com

# Check Nginx configuration
nginx -t

# Manually run certbot
certbot --nginx -d cpaleexplained.com -d www.cpaleexplained.com
```

---

## 📞 Need Help?

### Check Logs
```bash
# Application logs
pm2 logs cpale-api

# Nginx access logs
tail -f /var/log/nginx/cpaleexplained_access.log

# Nginx error logs
tail -f /var/log/nginx/cpaleexplained_error.log

# MySQL logs
tail -f /var/log/mysql/error.log
```

### Service Status
```bash
# Check all services
systemctl status nginx
systemctl status mysql
pm2 status
```

### Resource Usage
```bash
# CPU and memory
htop

# Disk space
df -h

# Network connections
netstat -tulpn | grep -E '(80|443|3306|5000)'
```

---

## ✅ POST-DEPLOYMENT CHECKLIST

- [ ] DNS configured in Namecheap
- [ ] All deployment scripts executed successfully
- [ ] PM2 shows cpale-api running
- [ ] Nginx serving website on port 80/443
- [ ] MySQL database imported (61 tables verified)
- [ ] Website loads via HTTP
- [ ] SSL certificate installed
- [ ] Website loads via HTTPS with green padlock
- [ ] User registration works
- [ ] User login works
- [ ] Quiz functionality works
- [ ] Payment flow functional
- [ ] Admin dashboard accessible
- [ ] PM2 configured for auto-restart
- [ ] Firewall configured (ports 22, 80, 443 open)

---

## 🎉 SUCCESS!

Your CPALE Explained application is now live at:
## **https://cpaleexplained.com**

Users can:
- ✅ Register for free accounts (50 MCQs limit)
- ✅ Take practice quizzes
- ✅ View detailed explanations
- ✅ Upgrade to paid subscription (₱149/month)
- ✅ Make payments via GCash/Maya/Bank Transfer
- ✅ Track their progress and analytics

Admin can:
- ✅ Verify pending payments
- ✅ View analytics dashboard
- ✅ Monitor user subscriptions
- ✅ Track revenue and conversions

---

## 📈 Next Steps (Optional)

1. **Setup Email Notifications**
   - Configure SendGrid or AWS SES
   - Update .env with email credentials
   - Uncomment email code in backend/utils/emailNotifications.js

2. **Setup Monitoring**
   - UptimeRobot: https://uptimerobot.com/
   - StatusCake: https://www.statuscake.com/
   - PM2 Plus: https://pm2.io/

3. **Setup Automated Backups**
   - Configure daily database backups
   - Upload to cloud storage (S3, DigitalOcean Spaces)

4. **Performance Optimization**
   - Enable Nginx caching
   - Setup CDN for static assets
   - Optimize database queries

5. **Security Hardening**
   - Setup fail2ban for SSH protection
   - Enable rate limiting
   - Configure security headers

---

**Total Deployment Time**: ~25 minutes (active work) + DNS propagation wait

**Estimated Costs**:
- DigitalOcean Droplet: $6-12/month
- Domain (Namecheap): ~$10-15/year
- SSL Certificate: FREE (Let's Encrypt)

**Support**: Check deployment/README.md for detailed troubleshooting

---

**Deployment Date**: January 24, 2026  
**Version**: 1.0.0 Production Ready  
**Status**: ✅ All files committed to GitHub

Good luck with your launch! 🚀
