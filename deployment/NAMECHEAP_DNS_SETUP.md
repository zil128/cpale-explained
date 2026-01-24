# Namecheap DNS Configuration Guide

## Step-by-Step DNS Setup for cpaleexplained.com

### 1. Login to Namecheap
Go to: https://ap.www.namecheap.com/domains/list/

### 2. Access DNS Settings
1. Find **cpaleexplained.com** in your domain list
2. Click **Manage** button
3. Click on **Advanced DNS** tab

### 3. Delete Existing Records (if any)
Before adding new records, delete any existing A records:
- Look for existing A Records with Host: `@` or `www`
- Click the trash icon to delete them

### 4. Add A Records

Click **Add New Record** and create these two records:

#### Record 1: Root Domain
```
Type:  A Record
Host:  @
Value: 143.198.206.143
TTL:   5 min
```

#### Record 2: WWW Subdomain
```
Type:  A Record
Host:  www
Value: 143.198.206.143
TTL:   5 min
```

### 5. Save Changes
Click **Save All Changes** button at the bottom

### 6. Verify Configuration

Your DNS records should look like this:

| Type | Host | Value | TTL |
|------|------|-------|-----|
| A Record | @ | 143.198.206.143 | 5 min |
| A Record | www | 143.198.206.143 | 5 min |

### 7. Wait for DNS Propagation

**Expected wait time:** 5-30 minutes (with 5 min TTL)

You can check DNS propagation status at:
- https://dnschecker.org/ (enter: cpaleexplained.com)
- https://www.whatsmydns.net/ (enter: cpaleexplained.com)

### 8. Test DNS Resolution

**On the droplet console, test with:**
```bash
nslookup cpaleexplained.com
# Should return: 143.198.206.143

ping cpaleexplained.com
# Should ping: 143.198.206.143
```

**On your local machine:**
```bash
nslookup cpaleexplained.com
# Should return: 143.198.206.143
```

---

## Why 5 min TTL?

TTL (Time To Live) controls how long DNS servers cache your records:
- **5 min** = DNS updates propagate quickly (good for deployment)
- **60 min** = Slower propagation, but less DNS queries (good for stable sites)

For initial deployment, **5 min is recommended**.

After your site is live and stable, you can change it to 60 min to reduce DNS query load.

---

## Common Issues

### Issue: DNS not propagating after 30 minutes
**Solution:**
1. Clear your local DNS cache:
   - Windows: `ipconfig /flushdns`
   - Mac: `sudo dscacheutil -flushcache`
2. Try accessing via incognito/private browser
3. Check with online DNS checker tools

### Issue: Wrong IP address showing
**Solution:**
1. Verify A records in Namecheap show 143.198.206.143
2. Make sure you clicked "Save All Changes"
3. Wait another 5-10 minutes for propagation

### Issue: Can access via www but not root domain (or vice versa)
**Solution:**
- Make sure BOTH A records exist (@ and www)
- Both should point to 143.198.206.143
- Wait for full propagation

---

## After DNS is Working

Once DNS resolves correctly:

1. Test HTTP access:
   ```
   http://cpaleexplained.com
   http://www.cpaleexplained.com
   ```

2. Run SSL setup script on droplet:
   ```bash
   cd /root/cpale-explained/deployment
   bash setup_ssl.sh
   ```

3. Test HTTPS access:
   ```
   https://cpaleexplained.com
   https://www.cpaleexplained.com
   ```

---

## Visual Guide

```
┌─────────────────────────────────────────────────┐
│ Namecheap Dashboard                             │
├─────────────────────────────────────────────────┤
│                                                 │
│ Domain List → cpaleexplained.com → [Manage]    │
│                                                 │
│   ┌─────────────────────────────────────────┐  │
│   │ Advanced DNS Tab                        │  │
│   ├─────────────────────────────────────────┤  │
│   │                                         │  │
│   │ Host Records                            │  │
│   │                                         │  │
│   │ ┌──────────┬──────┬─────────────────┐  │  │
│   │ │ Type     │ Host │ Value           │  │  │
│   │ ├──────────┼──────┼─────────────────┤  │  │
│   │ │ A Record │ @    │ 143.198.206.143 │  │  │
│   │ │ A Record │ www  │ 143.198.206.143 │  │  │
│   │ └──────────┴──────┴─────────────────┘  │  │
│   │                                         │  │
│   │ [Save All Changes]                      │  │
│   └─────────────────────────────────────────┘  │
│                                                 │
└─────────────────────────────────────────────────┘
```

---

**Status:** Ready to configure ✅

**Next step:** Follow the visual guide above to configure your DNS records in Namecheap.
