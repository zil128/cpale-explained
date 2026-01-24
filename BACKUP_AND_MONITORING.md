# CPALE Explained - Backup and Monitoring Guide

## Overview

This guide covers backup procedures and monitoring strategies for the CPALE Explained platform.

---

## 1. Database Backup

### Manual Backup

#### Full Database Backup
```bash
# Backup entire database
docker exec cpale-mysql mysqldump -ucpale_user -pcpale_password cpale_explained > backup_$(date +%Y%m%d_%H%M%S).sql

# Backup with compression
docker exec cpale-mysql mysqldump -ucpale_user -pcpale_password cpale_explained | gzip > backup_$(date +%Y%m%d_%H%M%S).sql.gz
```

#### Backup Specific Tables
```bash
# Backup user data only
docker exec cpale-mysql mysqldump -ucpale_user -pcpale_password cpale_explained users user_subscriptions_v2 user_mock_attempts > users_backup.sql

# Backup question bank
docker exec cpale-mysql mysqldump -ucpale_user -pcpale_password cpale_explained questions question_choices question_explanations topics subjects > questions_backup.sql
```

### Automated Daily Backup

Create a backup script `scripts/backup.sh`:

```bash
#!/bin/bash

# Configuration
BACKUP_DIR="/path/to/backups"
RETENTION_DAYS=30
DATE=$(date +%Y%m%d_%H%M%S)

# Create backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

# Perform backup
docker exec cpale-mysql mysqldump -ucpale_user -pcpale_password cpale_explained | gzip > $BACKUP_DIR/cpale_backup_$DATE.sql.gz

# Check if backup was successful
if [ $? -eq 0 ]; then
    echo "Backup successful: cpale_backup_$DATE.sql.gz"
else
    echo "Backup FAILED!"
    exit 1
fi

# Remove backups older than retention period
find $BACKUP_DIR -name "cpale_backup_*.sql.gz" -mtime +$RETENTION_DAYS -delete

echo "Cleanup complete. Removed backups older than $RETENTION_DAYS days."
```

Schedule with cron (Linux/Mac):
```bash
# Run daily at 2 AM
0 2 * * * /path/to/scripts/backup.sh >> /var/log/cpale_backup.log 2>&1
```

### Restore from Backup

```bash
# Restore from SQL file
docker exec -i cpale-mysql mysql -ucpale_user -pcpale_password cpale_explained < backup_file.sql

# Restore from compressed backup
gunzip < backup_file.sql.gz | docker exec -i cpale-mysql mysql -ucpale_user -pcpale_password cpale_explained
```

---

## 2. Application Monitoring

### Health Check Endpoint

Add a health check endpoint to `server.js`:

```javascript
// Health check endpoint
app.get('/api/health', async (req, res) => {
  try {
    // Check database connection
    await pool.query('SELECT 1');
    
    res.json({
      status: 'healthy',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      database: 'connected'
    });
  } catch (error) {
    res.status(503).json({
      status: 'unhealthy',
      timestamp: new Date().toISOString(),
      error: error.message
    });
  }
});
```

### Basic Monitoring Script

Create `scripts/monitor.sh`:

```bash
#!/bin/bash

# Configuration
API_URL="http://localhost:5000/api/health"
LOG_FILE="/var/log/cpale_monitor.log"

# Check health endpoint
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" $API_URL)

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

if [ "$RESPONSE" -eq 200 ]; then
    echo "$TIMESTAMP - OK: Server healthy" >> $LOG_FILE
else
    echo "$TIMESTAMP - ERROR: Server returned $RESPONSE" >> $LOG_FILE
    
    # Optional: Send alert (email, Slack, etc.)
    # curl -X POST "https://hooks.slack.com/..." -d '{"text":"CPALE Server Down!"}'
fi
```

Schedule health checks every 5 minutes:
```bash
*/5 * * * * /path/to/scripts/monitor.sh
```

---

## 3. Log Management

### Application Logs

Configure logging in `server.js`:

```javascript
const fs = require('fs');
const path = require('path');

// Create logs directory
const logsDir = path.join(__dirname, 'logs');
if (!fs.existsSync(logsDir)) {
    fs.mkdirSync(logsDir);
}

// Log to file
const logStream = fs.createWriteStream(
    path.join(logsDir, `app_${new Date().toISOString().split('T')[0]}.log`),
    { flags: 'a' }
);

// Override console.log
const originalLog = console.log;
console.log = (...args) => {
    const timestamp = new Date().toISOString();
    const message = `[${timestamp}] ${args.join(' ')}\n`;
    logStream.write(message);
    originalLog.apply(console, args);
};
```

### Log Rotation

Create `scripts/rotate_logs.sh`:

```bash
#!/bin/bash

LOGS_DIR="/path/to/backend/logs"
RETENTION_DAYS=14

# Compress old logs
find $LOGS_DIR -name "*.log" -mtime +1 -exec gzip {} \;

# Remove logs older than retention period
find $LOGS_DIR -name "*.log.gz" -mtime +$RETENTION_DAYS -delete
```

---

## 4. Performance Monitoring

### Database Performance

```sql
-- Check slow queries (run in MySQL)
SHOW PROCESSLIST;

-- Check table sizes
SELECT 
    table_name,
    ROUND(data_length / 1024 / 1024, 2) AS data_mb,
    ROUND(index_length / 1024 / 1024, 2) AS index_mb,
    table_rows
FROM information_schema.tables
WHERE table_schema = 'cpale_explained'
ORDER BY data_length DESC;

-- Check connection count
SHOW STATUS LIKE 'Threads_connected';
```

### Node.js Memory Usage

Add memory monitoring:

```javascript
// Log memory usage every hour
setInterval(() => {
    const used = process.memoryUsage();
    console.log(`Memory Usage: ${Math.round(used.heapUsed / 1024 / 1024)}MB / ${Math.round(used.heapTotal / 1024 / 1024)}MB`);
}, 3600000);
```

---

## 5. Error Tracking

### Basic Error Logging

```javascript
// Global error handler
app.use((err, req, res, next) => {
    const errorLog = {
        timestamp: new Date().toISOString(),
        method: req.method,
        url: req.url,
        error: err.message,
        stack: err.stack,
        userId: req.user?.userId || 'anonymous'
    };
    
    console.error('ERROR:', JSON.stringify(errorLog));
    
    res.status(500).json({ error: 'Internal server error' });
});

// Unhandled promise rejections
process.on('unhandledRejection', (reason, promise) => {
    console.error('Unhandled Rejection:', reason);
});

// Uncaught exceptions
process.on('uncaughtException', (error) => {
    console.error('Uncaught Exception:', error);
    process.exit(1);
});
```

---

## 6. Alerting

### Simple Email Alert Script

Create `scripts/alert.js`:

```javascript
const nodemailer = require('nodemailer');

async function sendAlert(subject, message) {
    const transporter = nodemailer.createTransport({
        host: 'smtp.gmail.com',
        port: 587,
        auth: {
            user: process.env.ALERT_EMAIL,
            pass: process.env.ALERT_PASSWORD
        }
    });

    await transporter.sendMail({
        from: process.env.ALERT_EMAIL,
        to: 'admin@cpaleexplained.com',
        subject: `[CPALE Alert] ${subject}`,
        text: message
    });
}

module.exports = { sendAlert };
```

---

## 7. Docker Container Monitoring

### Check Container Status

```bash
# View container stats
docker stats cpale-mysql

# View container logs
docker logs cpale-mysql --tail 100

# Check container health
docker inspect cpale-mysql --format='{{.State.Health.Status}}'
```

### Container Auto-Restart

```bash
# Update container to always restart
docker update --restart=always cpale-mysql
```

---

## 8. Backup Verification

### Monthly Backup Test Procedure

1. **Create test environment**
   ```bash
   docker run -d --name cpale-mysql-test -p 3307:3306 \
     -e MYSQL_ROOT_PASSWORD=testroot \
     -e MYSQL_DATABASE=cpale_test \
     -e MYSQL_USER=cpale_user \
     -e MYSQL_PASSWORD=cpale_password \
     mysql:8.0
   ```

2. **Restore backup to test environment**
   ```bash
   gunzip < latest_backup.sql.gz | docker exec -i cpale-mysql-test mysql -ucpale_user -pcpale_password cpale_test
   ```

3. **Verify data integrity**
   ```bash
   docker exec cpale-mysql-test mysql -ucpale_user -pcpale_password cpale_test -e "SELECT COUNT(*) FROM users; SELECT COUNT(*) FROM questions;"
   ```

4. **Cleanup test environment**
   ```bash
   docker rm -v cpale-mysql-test
   ```

---

## 9. Monitoring Dashboard (Optional)

For production, consider using:

- **Grafana + Prometheus**: Full metrics visualization
- **Datadog**: Cloud monitoring service
- **New Relic**: Application performance monitoring
- **Sentry**: Error tracking and monitoring

---

## 10. Checklist

### Daily
- [ ] Check health endpoint is responding
- [ ] Review error logs for critical issues
- [ ] Verify backup completed successfully

### Weekly
- [ ] Review performance metrics
- [ ] Check disk space usage
- [ ] Review slow query logs

### Monthly
- [ ] Test backup restoration
- [ ] Review and archive old logs
- [ ] Update dependencies for security patches
- [ ] Review user growth and capacity planning

---

## Quick Reference

| Task | Command |
|------|---------|
| Full backup | `docker exec cpale-mysql mysqldump -ucpale_user -pcpale_password cpale_explained > backup.sql` |
| Restore backup | `docker exec -i cpale-mysql mysql -ucpale_user -pcpale_password cpale_explained < backup.sql` |
| Check container | `docker ps \| grep cpale-mysql` |
| View logs | `docker logs cpale-mysql --tail 100` |
| Container stats | `docker stats cpale-mysql` |
| Health check | `curl http://localhost:5000/api/health` |

---

*Last Updated: January 24, 2026*
