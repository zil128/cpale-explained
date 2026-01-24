# CPALE Explained - Local Deployment Guide

## Prerequisites

Before deploying CPALE Explained locally, ensure you have:

- **Node.js** v16 or higher
- **Docker Desktop** installed and running
- **Git** (optional, for cloning)

---

## Quick Start

### 1. Start MySQL Database

```bash
# Pull and run MySQL container
docker run -d \
  --name cpale-mysql \
  -e MYSQL_ROOT_PASSWORD=rootpassword \
  -e MYSQL_DATABASE=cpale_explained \
  -e MYSQL_USER=cpale_user \
  -e MYSQL_PASSWORD=cpale_password \
  -p 3306:3306 \
  mysql:8.0

# Wait for MySQL to be ready (about 30 seconds)
docker logs -f cpale-mysql
# Look for: "ready for connections"
```

### 2. Run Database Migrations

```bash
# Navigate to project root
cd cpale-explained

# Run all migrations in order
docker exec -i cpale-mysql mysql -ucpale_user -pcpale_password cpale_explained < database/migrations/001_initial_schema.sql
docker exec -i cpale-mysql mysql -ucpale_user -pcpale_password cpale_explained < database/migrations/002_seed_data.sql
docker exec -i cpale-mysql mysql -ucpale_user -pcpale_password cpale_explained < database/migrations/create_paid_practice_sets.sql
docker exec -i cpale-mysql mysql -ucpale_user -pcpale_password cpale_explained < database/migrations/create_analytics_tables.sql
docker exec -i cpale-mysql mysql -ucpale_user -pcpale_password cpale_explained < database/migrations/create_mock_exams.sql
```

### 3. Install Dependencies

```bash
cd backend
npm install
```

### 4. Configure Environment

Create a `.env` file in the `backend` folder:

```env
# Database
DB_HOST=localhost
DB_PORT=3306
DB_USER=cpale_user
DB_PASSWORD=cpale_password
DB_NAME=cpale_explained

# JWT
JWT_SECRET=your-super-secret-key-change-in-production

# Server
PORT=5000
NODE_ENV=development
```

### 5. Start the Server

```bash
cd backend
node server.js
```

You should see:
```
========================================
   CPALE Explained - MVP Server
========================================
API Server:     http://localhost:5000
Landing Page:   http://localhost:5000/landing-page/
Database:       cpale_explained
Environment:    development
========================================
```

### 6. Access the Application

Open your browser and navigate to:
- **Landing Page**: http://localhost:5000/landing-page/
- **Login**: http://localhost:5000/landing-page/login.html
- **Dashboard**: http://localhost:5000/landing-page/dashboard.html

---

## Test Accounts

### PAID User (Full Access)
- **Email**: `testuser@cpaleexplained.com`
- **Password**: `password123`

### FREE User (Limited Access)
- **Email**: `test@cpaleexplained.com`
- **Password**: `password123`

---

## Project Structure

```
cpale-explained/
├── backend/
│   ├── server.js           # Main Express server
│   ├── db.js               # Database connection pool
│   ├── routes/
│   │   ├── userAnalytics.js  # Analytics API routes
│   │   └── mockExam.js       # Mock exam API routes
│   ├── services/
│   │   ├── aiAnalytics.js    # AI analytics logic
│   │   ├── mockExamService.js # Mock exam logic
│   │   └── subscriptionChecker.js # Background subscription checks
│   └── utils/
│       └── emailNotifications.js # Email sending utility
├── database/
│   └── migrations/          # SQL migration files
├── landing-page/
│   ├── index.html          # Home/landing page
│   ├── login.html          # Login page
│   ├── register.html       # Registration page
│   ├── dashboard.html      # User dashboard
│   ├── quiz.html           # Practice quiz interface
│   ├── analytics.html      # AI analytics dashboard
│   ├── mock-exam-list.html # Mock exam selection
│   ├── mock-exam.html      # Mock exam interface
│   ├── mock-exam-results.html # Exam results page
│   └── pricing.html        # Subscription pricing
└── docs/                   # Documentation
```

---

## API Endpoints

### Authentication
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/register` | Register new user |
| POST | `/api/auth/login` | Login and get token |

### Practice Sets
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/practice-sets` | List all accessible practice sets |
| GET | `/api/practice-sets/:id/questions` | Get questions for a set |

### Progress
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/progress/save` | Save quiz progress |
| GET | `/api/progress/stats` | Get user statistics |

### Analytics
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/analytics/user/dashboard` | Full analytics dashboard |
| GET | `/api/analytics/user/weak-points` | Identified weak topics |
| GET | `/api/analytics/user/recommendations` | Study recommendations |
| GET | `/api/analytics/user/exam-readiness` | Exam readiness score |

### Mock Exams
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/mock-exam/list` | List available exams |
| GET | `/api/mock-exam/in-progress` | Check for in-progress exam |
| POST | `/api/mock-exam/:examId/start` | Start new exam |
| GET | `/api/mock-exam/:attemptId/questions` | Get exam questions |
| PUT | `/api/mock-exam/:attemptId/save` | Save single answer |
| PUT | `/api/mock-exam/:attemptId/save-bulk` | Save multiple answers |
| POST | `/api/mock-exam/:attemptId/submit` | Submit exam |
| GET | `/api/mock-exam/:attemptId/results` | Get detailed results |

---

## Common Issues & Solutions

### Issue: Cannot connect to MySQL
```
Error: connect ECONNREFUSED 127.0.0.1:3306
```
**Solution**: Ensure Docker container is running:
```bash
docker start cpale-mysql
```

### Issue: Table doesn't exist
```
Error: Table 'cpale_explained.some_table' doesn't exist
```
**Solution**: Run migrations:
```bash
docker exec -i cpale-mysql mysql -ucpale_user -pcpale_password cpale_explained < database/migrations/[missing_migration].sql
```

### Issue: Port 5000 already in use
```
Error: listen EADDRINUSE: address already in use :::5000
```
**Solution**: Kill existing process:
```bash
# Windows
netstat -ano | findstr :5000
taskkill /PID <PID> /F

# Linux/Mac
lsof -i :5000
kill -9 <PID>
```

### Issue: Invalid token errors
**Solution**: Token may be expired. Login again to get a new token.

---

## Stopping the Application

### Stop Server
Press `Ctrl+C` in the terminal running the server.

### Stop MySQL Container
```bash
docker stop cpale-mysql
```

### Remove MySQL Container (keeps data)
```bash
docker rm cpale-mysql
```

### Remove MySQL Data (complete reset)
```bash
docker rm -v cpale-mysql
```

---

## Resetting the Database

To completely reset the database:

```bash
# Stop and remove container with volumes
docker rm -v cpale-mysql

# Restart container
docker run -d \
  --name cpale-mysql \
  -e MYSQL_ROOT_PASSWORD=rootpassword \
  -e MYSQL_DATABASE=cpale_explained \
  -e MYSQL_USER=cpale_user \
  -e MYSQL_PASSWORD=cpale_password \
  -p 3306:3306 \
  mysql:8.0

# Wait 30 seconds, then run migrations
# (see Step 2 above)
```

---

## Development Tips

### Watch Mode (Auto-restart)
Install nodemon for automatic server restarts:
```bash
npm install -g nodemon
nodemon server.js
```

### Database GUI
Connect with any MySQL client:
- Host: `localhost`
- Port: `3306`
- User: `cpale_user`
- Password: `cpale_password`
- Database: `cpale_explained`

### Testing API Endpoints
Use curl, Postman, or VS Code REST Client extension.

---

## Next Steps

1. Run the [Pre-Launch Testing Checklist](./PRE_LAUNCH_TESTING_CHECKLIST.md)
2. Set up [Backup and Monitoring](./BACKUP_AND_MONITORING.md)
3. Configure production environment variables
4. Set up SSL/HTTPS for production

---

*Last Updated: January 24, 2026*
