# 🚀 Create New Droplet - Step-by-Step Guide

## Droplet Configuration Settings

### Current Droplet Info:
- **IP**: 143.198.206.143
- **Region**: Singapore (SGP1)
- **Name**: cpaleexplained-server

---

## 📋 NEW DROPLET SETTINGS

When creating your new droplet, use these exact settings:

### 1. Choose Region
**Select**: **Singapore - SGP1** (same as current droplet)
- This ensures low latency for your target users
- Same data center as current setup

### 2. Choose Image
**Select**: **Ubuntu 22.04 (LTS) x64**
- Latest stable Ubuntu version
- Long-term support
- Compatible with all deployment scripts

### 3. Choose Size
**Recommended**: **Basic - $6/month**
- CPU: 1 vCPU
- Memory: 1 GB RAM
- SSD: 25 GB
- Transfer: 1000 GB

**OR if current droplet is larger, match its size**

### 4. Authentication Method
**IMPORTANT**: Select **SSH keys**
✅ Check: **CPALE Deployment Key**

**DO NOT select password authentication!**

### 5. Hostname
**Enter**: `cpaleexplained-server`

### 6. Advanced Options (Optional)
- [ ] Enable IPv6
- [ ] User data (leave blank)
- [ ] Monitoring (free - recommended)
- [ ] Backups (optional - costs extra)

### 7. Finalize
Click: **Create Droplet**

Wait 60-120 seconds for droplet to be created.

---

## 🔑 BEFORE CREATING DROPLET - ADD SSH KEY

### Step 1: Add SSH Key to Your DigitalOcean Account

1. Go to: https://cloud.digitalocean.com/account/security

2. Scroll to **SSH keys** section

3. Click: **Add SSH Key**

4. Paste your public key:
   ```
   ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGyYHz0IqpfJANhZfPY9j912bh7ow/V2OS/ZsJnMjUYk cpale-deployment-key
   ```

5. Name: `CPALE Deployment Key`

6. Click: **Add SSH Key**

7. Verify it appears in your SSH keys list

---

## ✅ AFTER DROPLET CREATION

### Step 1: Note the New IP Address
Your new droplet will have a different IP (e.g., `159.89.xxx.xxx`)

**Write it down!**

### Step 2: Test SSH Connection

**Windows Command Prompt:**
```cmd
ssh -i C:\Users\LD3\.ssh\digitalocean_cpale root@NEW_DROPLET_IP
```

Replace `NEW_DROPLET_IP` with your actual new IP.

**Expected result**: You should login immediately without password!

### Step 3: Deploy Application

Once logged in:
```bash
cd /root
git clone https://github.com/zil128/cpale-explained.git
cd cpale-explained/deployment
chmod +x *.sh

echo "=========================================="
echo "Starting Deployment - This will take ~25 minutes"
echo "=========================================="

bash install_server.sh       # ~15 minutes
bash setup_database.sh        # ~2 minutes
bash deploy_application.sh    # ~5 minutes
bash setup_nginx.sh           # ~1 minute
bash setup_ssl.sh             # ~2 minutes (after DNS)

echo "=========================================="
echo "✅ Deployment Complete!"
echo "=========================================="

pm2 status
systemctl status nginx
```

### Step 4: Verify Website Works

**Test via IP** (works immediately):
```
http://NEW_DROPLET_IP
```

Your landing page should load!

### Step 5: Update DNS in Namecheap

1. Go to: https://ap.www.namecheap.com/domains/list/
2. Click: **Manage** on cpaleexplained.com
3. Click: **Advanced DNS** tab
4. **Edit** existing A records (or delete and recreate):

**Change from OLD IP (143.198.206.143) to NEW IP:**

| Type | Host | Value | TTL |
|------|------|-------|-----|
| A Record | @ | **NEW_DROPLET_IP** | 5 min |
| A Record | www | **NEW_DROPLET_IP** | 5 min |

5. Click: **Save All Changes**

6. Wait 5-30 minutes for DNS propagation

### Step 6: Test Domain

After DNS propagates:
```
http://cpaleexplained.com
https://cpaleexplained.com
```

Both should work!

### Step 7: Test All Functionality

- [ ] Landing page loads
- [ ] User registration works
- [ ] User login works
- [ ] Dashboard displays
- [ ] Quiz loads questions
- [ ] Payment modal works
- [ ] Admin dashboard accessible

### Step 8: Clean Up Old Droplet

**ONLY after confirming new droplet works perfectly:**

1. Go to: https://cloud.digitalocean.com/droplets
2. Click: old cpaleexplained-server (143.198.206.143)
3. Click: **Destroy**
4. Type droplet name to confirm
5. Click: **Destroy**

**Cost savings**: Old droplet will be prorated, you only pay for time used

---

## 📊 COMPARISON: Old vs New

| Feature | Old Droplet | New Droplet |
|---------|-------------|-------------|
| IP | 143.198.206.143 | NEW_IP |
| Region | Singapore SGP1 | Singapore SGP1 |
| Access | ❌ Password disabled | ✅ SSH key enabled |
| Status | Inaccessible | ✅ Fully accessible |
| Deployment | ❌ Cannot deploy | ✅ Ready to deploy |

---

## ⏱️ TIMELINE

```
0 min:     Add SSH key to DigitalOcean
+2 min:    Create new droplet
+4 min:    Droplet ready, note IP
+5 min:    Test SSH connection ✅
+6 min:    Start deployment scripts
+31 min:   Deployment complete
+32 min:   Test site via IP ✅
+35 min:   Update DNS
+40-65 min: DNS propagates
+70 min:   Test site via domain ✅
+75 min:   Destroy old droplet

TOTAL: ~75 minutes from start to finish
```

---

## 🚨 TROUBLESHOOTING

### SSH connection fails to new droplet
**Check:**
- Did you select the SSH key during droplet creation?
- Are you using the correct private key path?
- Is the IP address correct?

**Solution:**
```cmd
ssh -v -i C:\Users\LD3\.ssh\digitalocean_cpale root@NEW_IP
```
The `-v` flag shows verbose output to debug

### Website doesn't load via IP
**Check:**
- Is Nginx running? `systemctl status nginx`
- Are there errors? `tail -f /var/log/nginx/error.log`
- Is PM2 running? `pm2 status`

### DNS not resolving to new IP
**Check:**
- Did you update BOTH @ and www records?
- Did you click "Save All Changes"?
- Wait longer (up to 60 minutes)

**Test:**
```cmd
nslookup cpaleexplained.com
```

---

## 💰 COST BREAKDOWN

**New droplet**: $6/month = $0.009/hour
**Time during testing**: ~2 hours = $0.018
**Old droplet prorated**: Refund for unused time

**Extra cost during transition**: Less than $0.05

---

## ✅ READY TO CREATE?

**Before you start, verify:**
- [ ] SSH key added to DigitalOcean account
- [ ] You know the region: **Singapore - SGP1**
- [ ] You have the deployment commands ready
- [ ] You're ready to wait ~75 minutes for full deployment

**Let's do this! 🚀**

Go to: https://cloud.digitalocean.com/droplets/new
