# Troubleshooting Droplet Access

## Issue: DigitalOcean Droplet Console Fails to Launch

If the web-based console isn't working, here are alternative methods to access your droplet.

---

## Method 1: Enable Password Authentication via Recovery Console

### Step 1: Access Recovery Console
1. Login to DigitalOcean: https://cloud.digitalocean.com/
2. Go to: Droplets → cpaleexplained-server
3. Click: **Access** → **Recovery Console**
4. If Recovery Console also fails, try Method 2

### Step 2: Boot into Recovery Mode
1. In the droplet page, click **Power** → **Power Off**
2. Wait for droplet to power off completely
3. Click **Recovery** → **Boot from Recovery ISO**
4. Wait for recovery mode to boot
5. Try **Launch Droplet Console** again

---

## Method 2: Reset Root Password (Recommended)

### Via DigitalOcean Dashboard:
1. Go to: Droplets → cpaleexplained-server
2. Click **Access** tab
3. Click **Reset Root Password**
4. Check your email for the new temporary password
5. Use the temporary password to SSH in
6. You'll be forced to change password on first login

---

## Method 3: SSH from Windows (Enable Password Authentication)

Since you have root credentials, let's try SSH from your Windows machine:

### Option A: Using Windows Command Prompt
```cmd
ssh root@143.198.206.143
```

When prompted:
- Type: `yes` (to accept fingerprint)
- Enter password: `tu6in*Jjq7bznVe`

### Option B: Using PowerShell
```powershell
ssh root@143.198.206.143
```

### Option C: Using PuTTY (if SSH command doesn't work)
1. Download PuTTY: https://www.putty.org/
2. Open PuTTY
3. Host Name: `143.198.206.143`
4. Port: `22`
5. Connection Type: SSH
6. Click **Open**
7. Login as: `root`
8. Password: `tu6in*Jjq7bznVe`

---

## Method 4: Add SSH Key (For Permanent Access)

### Step 1: Generate SSH Key on Windows
```powershell
# Open PowerShell and run:
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

# Press Enter to accept default location
# Press Enter twice to skip passphrase (or set one)

# Display your public key:
type $env:USERPROFILE\.ssh\id_rsa.pub
```

### Step 2: Add Key to DigitalOcean
1. Copy the public key output
2. Go to: DigitalOcean → Settings → Security → SSH Keys
3. Click **Add SSH Key**
4. Paste your public key
5. Name it: "Windows Local Machine"
6. Click **Add SSH Key**

### Step 3: Add Key to Droplet
1. Go to: Droplets → cpaleexplained-server
2. Click **Access** tab
3. Under SSH Keys, click **Add SSH Key**
4. Select your newly added key
5. Click **Add**

### Step 4: Test SSH Connection
```powershell
ssh root@143.198.206.143
# Should login without password!
```

---

## Method 5: Use DigitalOcean's doctl CLI

### Install doctl (DigitalOcean CLI)
```powershell
# Using Chocolatey (if installed):
choco install doctl

# Or download from:
# https://github.com/digitalocean/doctl/releases
```

### Authenticate and Connect
```powershell
# Authenticate with your DigitalOcean account
doctl auth init

# Get your droplet ID
doctl compute droplet list

# SSH into droplet
doctl compute ssh cpaleexplained-server
```

---

## Quick Fix: Test SSH Right Now

Let's test if SSH works from your Windows machine:

### Test 1: Check if OpenSSH is available
```cmd
ssh -V
```

If you see a version number, OpenSSH is installed. If not, install it:

### Install OpenSSH on Windows 10/11
```powershell
# Run as Administrator
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
```

### Test 2: Try connecting
```cmd
ssh -o PasswordAuthentication=yes root@143.198.206.143
```

When prompted, enter password: `tu6in*Jjq7bznVe`

---

## What to Do After Successful SSH Login

Once you successfully SSH into the droplet, run the deployment commands:

```bash
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

## Common SSH Errors and Solutions

### Error: "Connection refused"
**Cause:** SSH service not running or firewall blocking
**Solution:**
1. Try Recovery Console to access server
2. Restart SSH service
3. Check if port 22 is open

### Error: "Permission denied (publickey,password)"
**Cause:** Password authentication disabled
**Solution:**
1. Use SSH key instead (Method 4)
2. OR Reset root password (Method 2)
3. OR Enable password auth via Recovery Console

### Error: "Connection timed out"
**Cause:** Network issue or firewall
**Solution:**
1. Check your internet connection
2. Try from different network
3. Check DigitalOcean firewall settings

### Error: "Host key verification failed"
**Cause:** SSH fingerprint mismatch
**Solution:**
```cmd
ssh-keygen -R 143.198.206.143
```
Then try connecting again

---

## Emergency: Contact DigitalOcean Support

If none of these methods work:

1. Go to: https://cloud.digitalocean.com/support/tickets
2. Click **Create Ticket**
3. Subject: "Cannot access droplet console or SSH"
4. Droplet: cpaleexplained-server (143.198.206.143)
5. Issue: Describe the console error and SSH issues

DigitalOcean support typically responds within 1-2 hours.

---

## Alternative Deployment Methods

### Option A: Use GitHub Actions (CI/CD)
Deploy automatically when you push to GitHub (requires SSH access to be working first)

### Option B: Use DigitalOcean App Platform
Deploy directly from GitHub without SSH access needed
1. Go to: Apps → Create App
2. Connect GitHub repo
3. Auto-deploy on git push

### Option C: Rebuild Droplet
As a last resort, you can:
1. Create a snapshot of current droplet
2. Create new droplet from Ubuntu image
3. Add SSH key during creation
4. Deploy to new droplet

---

## Let's Try This Now

**I'll help you test SSH from your Windows machine right now.**

Tell me the result of this command:

```cmd
ssh -V
```

If SSH is available, we'll try connecting directly from your local machine instead of using the web console.
