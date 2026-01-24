# ✅ POST-DEPLOYMENT STEPS

## 🎉 Congratulations! Deployment Complete!

Your CPALE Explained application has been successfully deployed to your new DigitalOcean droplet.

---

## 📋 IMMEDIATE NEXT STEPS

### Step 1: Note Your Droplet IP Address

The deployment script should have displayed your droplet IP at the end.

**If you didn't note it, run this on the droplet:**
```bash
curl -s ifconfig.me
echo ""
```

**Write down this IP address!** (e.g., 159.89.xxx.xxx)

---

### Step 2: Test Your Site via IP (Should Work Immediately!)

**Open your browser and go to:**
```
http://YOUR_DROPLET_IP
```

**Expected Result:**
✅ Your CPALE Explained landing page should load!
✅ You should see the pricing, features, and registration/login buttons

**If it doesn't load:**
Run these commands on the droplet to check status:
```bash
pm2 status
systemctl status nginx
curl http://localhost:5000/api/health
```

---

### Step 3: Update DNS in Namecheap

Now point your domain to the new droplet:

1. **Go to:** https://ap.www.namecheap.com/domains/list/

2. **Click:** Manage on cpaleexplained.com

3. **Click:** Advanced DNS tab

4. **Update A Records** (change from old IP to new IP):

   | Type | Host | Value | TTL |
   |------|------|-------|-----|
   | A Record | @ | **YOUR_NEW_DROPLET_IP** | 5 min |
   | A Record | www | **YOUR_NEW_DROPLET_IP** | 5 min |

5. **Click:** Save All Changes

6. **Wait:** 5-30 minutes for DNS propagation

---

### Step 4: Verify DNS Propagation

**From your local Windows machine:**
```cmd
nslookup cpaleexplained.com
```

**Expected result:**
```
Address: YOUR_NEW_DROPLET_IP
```

**Also check online:**
- https://dnschecker.org/ (enter: cpaleexplained.com)
- https://www.whatsmydns.net/ (enter: cpaleexplained.com)

---

### Step 5: Test Your Domain (After DNS Propagates)

**Open browser:**
```
http://cpaleexplained.com
https://cpaleexplained.com
```

Both should work and show your site with valid SSL certificate (green padlock)!

---

### Step 6: Test All Functionality

Go through this checklist:

- [ ] **Landing Page** - Loads correctly
- [ ] **Registration** - Create a new test account
  - Email: test@example.com
  - Password: Test123!
- [ ] **Login** - Login with test account
- [ ] **Dashboard** - Shows "Free Plan" with 0/50 MCQs
- [ ] **Quiz** - Click "Start Quiz", questions load
- [ ] **Answer Questions** - Can select answers and submit
- [ ] **Results** - Shows score and explanations
- [ ] **Subscription** - "Upgrade to Paid" button works
- [ ] **Payment Modal** - Opens and shows payment methods
- [ ] **Admin Dashboard** - Access admin.html (if you have admin account)

---

### Step 7: Verify Backend Services (On Droplet)

**SSH into your droplet:**
```cmd
ssh -i C:\Users\LD3\.ssh\digitalocean_cpale root@YOUR_DROPLET_IP
```

**Check PM2 status:**
```bash
pm2 status
```
**Expected:** cpale-api should show status "online"

**Check PM2 logs:**
```bash
pm2 logs cpale-api --lines 50
```
**Expected:** No critical errors, should see "Server running on port 5000"

**Check Nginx status:**
```bash
systemctl status nginx
```
**Expected:** active (running)

**Check MySQL status:**
```bash
systemctl status mysql
```
**Expected:** active (running)

**Test API endpoint:**
```bash
curl http://localhost:5000/api/health
```
**Expected:** {"status":"healthy"}

**Verify database:**
```bash
mysql -u cpale_user -pCpale2026SecurePass! cpale_explained -e "SELECT COUNT(*) as total_tables FROM information_schema.tables WHERE table_schema = 'cpale_explained';"
```
**Expected:** 61 tables

```bash
mysql -u cpale_user -pCpale2026SecurePass! cpale_explained -e "SELECT COUNT(*) as total_users FROM users;"
```
**Expected:** 6+ users

```bash
mysql -u cpale_user -pCpale2026SecurePass! cpale_explained -e "SELECT COUNT(*) as total_questions FROM questions;"
```
**Expected:** 275 questions

---

### Step 8: Clean Up Old Droplet (After Confirming Everything Works)

**ONLY after you've confirmed:**
- ✅ New site works via IP
- ✅ DNS updated and propagated
- ✅ New site works via domain
- ✅ All functionality tested
- ✅ No errors in logs

**Then destroy the old droplet:**

1. Go to: https://cloud.digitalocean.com/droplets
2. Find: Old cpaleexplained-server (143.198.206.143)
3. Click: **More** → **Destroy**
4. Type the droplet name to confirm
5. Click: **Destroy**

**You'll be refunded for unused time!**

---

## 🔐 IMPORTANT CREDENTIALS TO SAVE

### Droplet SSH Access:
```
Host: YOUR_NEW_DROPLET_IP
User: root
SSH Key: C:\Users\LD3\.ssh\digitalocean_cpale
Command: ssh -i C:\Users\LD3\.ssh\digitalocean_cpale root@YOUR_IP
```

### MySQL Database:
```
Host: localhost
Port: 3306
Database: cpale_explained
User: cpale_user
Password: Cpale2026SecurePass!
Root Password: CpaleRootPass2026!
```

### Application:
```
Location: /var/www/cpaleexplained
PM2 App Name: cpale-api
.env File: /var/www/cpaleexplained/.env
```

---

## 🔧 USEFUL COMMANDS

### View Application Logs:
```bash
pm2 logs cpale-api
pm2 logs cpale-api --lines 100
```

### Restart Services:
```bash
pm2 restart cpale-api
systemctl restart nginx
systemctl restart mysql
```

### Monitor Resources:
```bash
pm2 monit
htop
df -h
free -m
```

### Update Application (After Code Changes):
```bash
cd /var/www/cpaleexplained
git pull origin master
npm install
pm2 restart cpale-api
```

### View Nginx Logs:
```bash
tail -f /var/log/nginx/cpaleexplained_access.log
tail -f /var/log/nginx/cpaleexplained_error.log
```

### Database Backup:
```bash
mysqldump -u cpale_user -pCpale2026SecurePass! cpale_explained > backup_$(date +%Y%m%d).sql
```

---

## 🚨 TROUBLESHOOTING

### Site not loading via IP:
```bash
# Check if Nginx is running
systemctl status nginx

# Check if backend is running
pm2 status

# Check API health
curl http://localhost:5000/api/health

# View error logs
tail -f /var/log/nginx/cpaleexplained_error.log
pm2 logs cpale-api --err
```

### Site not loading via domain:
```bash
# Check DNS from droplet
nslookup cpaleexplained.com

# If DNS not resolved, wait longer or check Namecheap settings
```

### Database connection errors:
```bash
# Check MySQL is running
systemctl status mysql

# Test connection
mysql -u cpale_user -pCpale2026SecurePass! cpale_explained -e "SELECT 1;"

# Check .env file
cat /var/www/cpaleexplained/.env
```

### SSL certificate issues:
```bash
# Check certificate
certbot certificates

# Renew certificate
certbot renew

# Test renewal
certbot renew --dry-run
```

---

## 📊 MONITORING & MAINTENANCE

### Daily Tasks:
- Monitor PM2 logs for errors
- Check disk space: `df -h`
- Review Nginx access logs

### Weekly Tasks:
- Review user registrations and activity
- Check database size
- Review pending payments (admin dashboard)

### Monthly Tasks:
- Review and optimize database
- Check for system updates
- Review analytics and metrics
- Backup database to external storage

---

## 🎉 YOU'RE LIVE!

Your CPALE Explained application is now fully deployed and accessible at:

**🌐 https://cpaleexplained.com**

Features enabled:
- ✅ User registration and authentication
- ✅ Free tier (50 MCQs)
- ✅ Paid subscription (₱149/month)
- ✅ Payment processing (GCash/Maya/Bank)
- ✅ Quiz system with detailed explanations
- ✅ Admin dashboard for payment verification
- ✅ Analytics and progress tracking
- ✅ Automatic SSL certificate renewal
- ✅ PM2 auto-restart on crashes
- ✅ Background subscription checker

**Congratulations on your successful deployment! 🚀**

---

## 📞 NEED HELP?

If you encounter any issues:

1. Check the troubleshooting section above
2. Review deployment logs
3. Check service status (PM2, Nginx, MySQL)
4. Review application logs

All documentation is available in your project:
- deployment/README.md
- deployment/TROUBLESHOOTING_ACCESS.md
- DEPLOYMENT_GUIDE.md

---

**Deployment Date:** January 25, 2026
**Status:** ✅ Production Ready
**Version:** 1.0.0
