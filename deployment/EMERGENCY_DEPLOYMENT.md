# Emergency Deployment Options

## Current Situation
- DigitalOcean Droplet Console: Not working
- SSH with password: Failing authentication
- Droplet: cpaleexplained-server @ 143.198.206.143

---

## SOLUTION 1: Reset Root Password (EASIEST)

### Via DigitalOcean Web Interface:

1. **Login to DigitalOcean**: https://cloud.digitalocean.com/
2. **Navigate to Droplet**:
   - Click **Droplets** in left sidebar
   - Click on **cpaleexplained-server**
3. **Access Tab**:
   - Click **Access** tab at the top
4. **Reset Password**:
   - Click **Reset Root Password** button
   - Confirm the action
5. **Check Email**:
   - DigitalOcean will send new root password to your registered email
   - Usually arrives within 1-2 minutes
6. **SSH with New Password**:
   ```cmd
   ssh root@143.198.206.143
   # Enter the new password from email
   ```
7. **Change Password** (you'll be prompted on first login):
   ```bash
   # Enter new password twice
   # Then you're logged in!
   ```

---

## SOLUTION 2: Create New Droplet with SSH Key

If the current droplet is inaccessible, create a fresh one:

### Step 1: Generate SSH Key
```cmd
# In Windows Command Prompt or PowerShell:
ssh-keygen -t rsa -b 4096 -f %USERPROFILE%\.ssh\id_rsa_digitalocean

# Press Enter for no passphrase (or set one)
# This creates:
#   - Private key: C:\Users\YourUser\.ssh\id_rsa_digitalocean
#   - Public key:  C:\Users\YourUser\.ssh\id_rsa_digitalocean.pub
```

### Step 2: Display Public Key
```cmd
type %USERPROFILE%\.ssh\id_rsa_digitalocean.pub
```

### Step 3: Add SSH Key to DigitalOcean
1. Go to: https://cloud.digitalocean.com/account/security
2. Click **Add SSH Key**
3. Paste your public key
4. Name: "Windows Machine"
5. Click **Add SSH Key**

### Step 4: Create New Droplet
1. Click **Create** → **Droplets**
2. **Choose Region**: Same as current (check current droplet location)
3. **Choose Image**: Ubuntu 22.04 (LTS) x64
4. **Choose Size**: Same as current droplet ($6-12/month)
5. **Authentication**: Select your SSH key ✅
6. **Hostname**: cpaleexplained-server-new
7. Click **Create Droplet**
8. Wait 1-2 minutes for droplet creation

### Step 5: Update DNS
1. Note new droplet IP address (e.g., 164.90.xxx.xxx)
2. Update Namecheap DNS:
   - Change @ → NEW_IP_ADDRESS
   - Change www → NEW_IP_ADDRESS
3. Wait 5-10 minutes for propagation

### Step 6: Deploy to New Droplet
```cmd
ssh -i %USERPROFILE%\.ssh\id_rsa_digitalocean root@NEW_IP_ADDRESS

# On the new droplet:
cd /root
git clone https://github.com/zil128/cpale-explained.git
cd cpale-explained/deployment
chmod +x *.sh
bash install_server.sh
bash setup_database.sh
bash deploy_application.sh
bash setup_nginx.sh
bash setup_ssl.sh
```

---

## SOLUTION 3: Use PuTTY (Windows SSH Client)

### Download and Install PuTTY
1. Download: https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html
2. Download: **putty.exe** (64-bit installer)
3. Install PuTTY

### Connect to Droplet
1. Open **PuTTY**
2. **Session** settings:
   - Host Name: `143.198.206.143`
   - Port: `22`
   - Connection type: `SSH`
3. **Connection → Data** settings:
   - Auto-login username: `root`
4. Click **Open**
5. Accept security alert (first time)
6. Enter password: `tu6in*Jjq7bznVe`
   - OR new password if you reset it

---

## SOLUTION 4: Contact DigitalOcean Support

If all else fails:

### Create Support Ticket
1. Go to: https://cloud.digitalocean.com/support
2. Click **Create a Ticket**
3. Fill in:
   ```
   Subject: Cannot access droplet - console and SSH failing
   
   Description:
   - Droplet: cpaleexplained-server (143.198.206.143)
   - Issue: Web console not launching
   - Issue: SSH password authentication failing
   - Need: Reset root password or enable console access
   
   Urgency: High - Need to deploy production application
   ```
4. Submit ticket
5. **Response time**: Usually 1-2 hours for paid accounts

---

## SOLUTION 5: Manual File Upload (Without SSH)

If you can't get SSH working, upload files manually:

### Use DigitalOcean Volumes (File Storage)
1. Create a Volume attached to droplet
2. Upload database backup via SFTP
3. Use Recovery Console to mount volume
4. Copy files to droplet

**Note:** This is complex and time-consuming. Try Solutions 1-3 first.

---

## RECOMMENDED IMMEDIATE ACTION

**Try this RIGHT NOW:**

### Option A: Reset Root Password
1. Go to: https://cloud.digitalocean.com/droplets
2. Click: cpaleexplained-server
3. Click: Access tab
4. Click: **Reset Root Password**
5. Check your email
6. Try SSH again with new password

### Option B: Try PuTTY
1. Download PuTTY: https://the.earth.li/~sgtatham/putty/latest/w64/putty.exe
2. Run putty.exe (no install needed)
3. Enter: 143.198.206.143
4. Port: 22
5. Click Open
6. Login: root
7. Password: tu6in*Jjq7bznVe

---

## After Successful Login

Once you successfully access the droplet via ANY method, run:

```bash
cd /root
git clone https://github.com/zil128/cpale-explained.git
cd cpale-explained/deployment
chmod +x *.sh

# Run scripts one by one
bash install_server.sh
bash setup_database.sh
bash deploy_application.sh
bash setup_nginx.sh

# Wait for DNS propagation, then:
bash setup_ssl.sh
```

---

## Need Help Right Now?

Tell me which solution you want to try:

1. **Reset root password** (Easiest - 5 minutes)
2. **Try PuTTY** (Quick - 2 minutes)
3. **Create new droplet** (Fresh start - 30 minutes)
4. **Contact support** (Wait for response - 1-2 hours)

I'll guide you through whichever method you choose!
