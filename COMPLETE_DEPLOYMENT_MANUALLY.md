# Complete Deployment Manually - Final Steps

## Current Status

✅ MySQL installed and database imported (61 tables, 6 users, 275 questions)
✅ Nginx installed
✅ PM2 installed
✅ Node.js installed
⏳ npm install might still be running in background

---

## SSH Back into Your Droplet

```cmd
ssh -i C:\Users\LD3\.ssh\digitalocean_cpale root@165.245.186.74
```

---

## Step 1: Check if npm install is Still Running

```bash
ps aux | grep npm
```

**If you see npm running:**
- Wait for it to finish (could take 5-10 minutes)
- Press Ctrl+C if it seems stuck, then run: `cd /var/www/cpaleexplained && npm install`

**If npm is not running:**
- Continue to Step 2

---

## Step 2: Complete Application Setup

```bash
# Navigate to application directory
cd /var/www/cpaleexplained

# Install dependencies if not done
npm install

# Update frontend API URLs
cd landing-page
for file in *.html; do
    sed -i "s|http://localhost:5000/api|/api|g" "$file"
done
cd ..

# Start application with PM2
pm2 start backend/server.js --name cpale-api
pm2 save
pm2 startup

# Copy and run the command that pm2 startup outputs

# Check status
pm2 status
pm2 logs cpale-api --lines 20
```

**Expected:** PM2 should show cpale-api as "online"

---

## Step 3: Configure Nginx

```bash
# Create Nginx configuration
cat > /etc/nginx/sites-available/cpaleexplained <<'EOF'
server {
    listen 80;
    listen [::]:80;
    server_name cpaleexplained.com www.cpaleexplained.com 165.245.186.74;

    access_log /var/log/nginx/cpaleexplained_access.log;
    error_log /var/log/nginx/cpaleexplained_error.log;

    root /var/www/cpaleexplained/landing-page;
    index index.html;

    client_max_body_size 10M;

    location /api/ {
        proxy_pass http://localhost:5000/api/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }

    location /uploads/ {
        alias /var/www/cpaleexplained/uploads/;
        autoindex off;
    }

    location / {
        try_files $uri $uri/ =404;
    }

    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
    }
}
EOF

# Enable site
rm -f /etc/nginx/sites-enabled/default
ln -sf /etc/nginx/sites-available/cpaleexplained /etc/nginx/sites-enabled/

# Test configuration
nginx -t

# Restart Nginx
systemctl restart nginx
systemctl status nginx
```

---

## Step 4: Test Your Site

```bash
# Test API
curl http://localhost:5000/api/health

# Should return: {"status":"healthy"}

# Test Nginx
curl -I http://localhost

# Should return: HTTP/1.1 200 OK
```

**From your browser:**
```
http://165.245.186.74
```

**Should show your landing page!**

---

## Step 5: Update DNS in Namecheap

1. Go to: https://ap.www.namecheap.com/domains/list/
2. Manage: cpaleexplained.com → Advanced DNS
3. Update A records:
   - @ → **165.245.186.74** (TTL: 5 min)
   - www → **165.245.186.74** (TTL: 5 min)
4. Save changes

---

## Step 6: Setup SSL (After DNS Propagates)

**Wait 5-30 minutes for DNS to propagate**

Check DNS:
```bash
nslookup cpaleexplained.com
```

**Once DNS resolves to 165.245.186.74:**

```bash
# Install Certbot if not already installed
apt install -y certbot python3-certbot-nginx

# Get SSL certificate
certbot --nginx -d cpaleexplained.com -d www.cpaleexplained.com

# Follow prompts:
# - Enter email address
# - Agree to terms: Y
# - Redirect HTTP to HTTPS: 2 (Yes)

# Test auto-renewal
certbot renew --dry-run
```

---

## Step 7: Final Verification

```bash
# Check all services
pm2 status
systemctl status nginx
systemctl status mysql

# View logs
pm2 logs cpale-api --lines 50
tail -f /var/log/nginx/cpaleexplained_error.log
```

**Test in browser:**
- http://165.245.186.74 ✅
- http://cpaleexplained.com ✅
- https://cpaleexplained.com ✅ (green padlock)

---

## Troubleshooting

### npm install hangs or fails:
```bash
cd /var/www/cpaleexplained
rm -rf node_modules package-lock.json
npm cache clean --force
npm install
```

### PM2 app won't start:
```bash
pm2 logs cpale-api --err
# Check for errors

# Verify .env file exists
cat /var/www/cpaleexplained/.env

# Test database connection
mysql -u cpale_user -pCpale2026SecurePass! cpale_explained -e "SELECT 1;"
```

### Nginx shows 502 Bad Gateway:
```bash
# Check if backend is running
pm2 status
curl http://localhost:5000/api/health

# If not running, restart
pm2 restart cpale-api
```

### Site shows 404:
```bash
# Check Nginx configuration
nginx -t
cat /etc/nginx/sites-enabled/cpaleexplained

# Check root directory
ls -la /var/www/cpaleexplained/landing-page/index.html

# Restart Nginx
systemctl restart nginx
```

---

## Quick Commands Reference

```bash
# SSH into droplet
ssh -i C:\Users\LD3\.ssh\digitalocean_cpale root@165.245.186.74

# Check services
pm2 status
systemctl status nginx
systemctl status mysql

# View logs
pm2 logs cpale-api
tail -f /var/log/nginx/cpaleexplained_error.log

# Restart services
pm2 restart cpale-api
systemctl restart nginx

# Test API
curl http://localhost:5000/api/health

# Get droplet IP
curl ifconfig.me
```

---

## Summary

**Droplet IP:** 165.245.186.74

**Services:**
- ✅ MySQL: Running (cpale_explained database with 61 tables)
- ✅ Node.js: Installed (v18.20.8)
- ✅ Nginx: Installed
- ✅ PM2: Installed
- ⏳ Application: Needs to be started with PM2
- ⏳ Nginx: Needs configuration

**Next Actions:**
1. SSH into droplet
2. Complete Steps 1-3 above
3. Test site at http://165.245.186.74
4. Update DNS
5. Setup SSL
6. Test https://cpaleexplained.com

**Estimated time:** 15-20 minutes

---

Good luck! Let me know if you encounter any issues.
