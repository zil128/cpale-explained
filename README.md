# CPALE Explained

**AI-Powered CPA Board Exam Reviewer** for Filipino students preparing for the Certified Public Accountant Licensure Examination (CPALE).

## Overview

CPALE Explained will serve as practice buddy that helps CPA exam candidates practice and study smarter with AI-powered analytics that track every answer, analyze weak spots, and provide guidance on what to study next.

## Subjects Covered

| Code | Subject |
|------|---------|
| FAR | Financial Accounting and Reporting |
| AFAR | Advanced Financial Accounting and Reporting |
| AUD | Auditing |
| TAX | Taxation |
| MS | Management Services |
| RFBT | Regulatory Framework for Business Transactions |

## MCQ Content

- **~13,950 total MCQs** across all 6 subjects
- Each MCQ includes:
  - Exam-style question with 4 choices
  - Correct answer with illustration (real-life scenario)
  - Explanation breakdown for correct AND wrong choices
  - Plain-English explanation
  - Formal definition (reviewer-level)
  - Elements/conditions checklist
  - Distinction from similar concepts
  - References (IFRS, PFRS, Civil Code, special laws with specific sections)
  - One-line "power" CPALE memory trigger

## Pricing Plans

| Plan | Price | Access |
|------|-------|--------|
| FREE | P0 | 50 MCQs for all subjects, unlimited repetition |
| BASIC | P149/mo or P800/6mo | 500 MCQs with basic analytics |
| ADVANCE | P299/mo or P1,599/6mo | 10,000+ MCQs with AI advanced analytics |

## Features

- **Practice Sets** - 75 MCQs per set
- **Mock Preboard Exams** - 100 MCQs per subject, timed like real CPALE (3 hours)
- **AI-Powered Analytics** - Weakness detection, mistake pattern recognition
- **Exam-Readiness Intelligence** - Differentiates guessed answers from true mastery
- **User Dashboard** - Track progress across all subjects

## Tech Stack

- **Backend:** Node.js + Express.js
- **Database:** MySQL
- **Frontend:** HTML + Tailwind CSS
- **Authentication:** JWT + bcrypt
- **Fonts:** Space Grotesk (headings), Plus Jakarta Sans (body)

## Getting Started

### Prerequisites

- Node.js (v18+)
- MySQL database

### Installation

1. Clone the repository
   ```bash
   git clone <repository-url>
   cd cpale-explained
   ```

2. Install dependencies
   ```bash
   npm install
   ```

3. Configure environment variables
   ```bash
   cp .env.example .env
   # Edit .env with your database credentials
   ```

4. Start the server
   ```bash
   npm start
   ```

   For development with auto-reload:
   ```bash
   npm run dev
   ```

5. Access the application
   - Landing page: http://localhost:5000/
   - Registration: http://localhost:5000/landing-page/register.html
   - Dashboard: http://localhost:5000/landing-page/dashboard.html
   - Quiz: http://localhost:5000/landing-page/quiz.html

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/health` | Health check |
| GET | `/api/questions/tos` | Get Table of Specifications |
| GET | `/api/questions/stats` | Get question statistics |
| GET | `/api/questions/random` | Get random questions |
| GET | `/api/questions/:subject` | Get questions by subject |
| POST | `/api/questions/generate` | Generate new MCQs |

## Payment Options

- GCash
- Paymaya
- Bank Transfer

## Project Structure

```
cpale-explained/
├── backend/
│   └── server.js          # Main server file
├── landing-page/
│   ├── index.html         # Landing page
│   ├── register.html      # Registration page
│   ├── login.html         # Login page
│   ├── dashboard.html     # User dashboard
│   ├── quiz.html          # Quiz interface
│   └── pricing.html       # Pricing page
├── src/
│   ├── routes/            # API route handlers
│   ├── models/            # Database models
│   ├── services/          # Business logic
│   └── schemas/           # Data schemas
├── topics_under_subjects/ # Subject topic documentation
└── package.json
```

## Quick Start Commands

### Starting the Application

**Step 1: Start Docker Desktop**
- Open Docker Desktop application and wait for it to initialize

**Step 2: Start MySQL Database**
```bash
docker-compose up -d
```

**Step 3: Verify MySQL is Running**
```bash
docker ps -a --filter "name=cpale-mysql"
```

**Step 4: Start the Node.js Server**
```bash
npm start
```

For development with auto-reload:
```bash
npm run dev
```

### Stopping the Application

**Stop the Node.js Server**
- Press `Ctrl + C` in the terminal running the server

**Stop MySQL Container**
```bash
docker-compose down
```

**Stop and Remove All Data (Fresh Start)**
```bash
docker-compose down -v
```

### Useful Commands

| Command | Description |
|---------|-------------|
| `npm start` | Start the production server |
| `npm run dev` | Start with auto-reload (development) |
| `docker-compose up -d` | Start MySQL in background |
| `docker-compose down` | Stop MySQL container |
| `docker-compose logs -f mysql` | View MySQL logs |
| `docker exec -it cpale-mysql mysql -u cpale_user -p` | Access MySQL CLI |

## Git Commands

### Repository URL
```
https://github.com/zil128/cpale-explained
```

### First-Time Setup (Clone Repository)
```bash
# Clone the repository to your local machine
git clone https://github.com/zil128/cpale-explained.git

# Navigate into the project folder
cd cpale-explained
```

### Daily Workflow: Commit and Push Changes

**Step 1: Check what files have changed**
```bash
git status
```

**Step 2: Stage all changes for commit**
```bash
git add -A
```
> Note: Use `git add -A` to include all changes (new, modified, and deleted files)

**Step 3: Commit with a descriptive message**
```bash
git commit -m "Your descriptive commit message here"
```

**Step 4: Push to GitHub**
```bash
git push origin master
```

### Complete Example: Commit and Push
```bash
# 1. Check status
git status

# 2. Stage all changes
git add -A

# 3. Commit with message
git commit -m "Add new feature: mock exam system"

# 4. Push to GitHub
git push origin master
```

### Other Useful Git Commands

| Command | Description |
|---------|-------------|
| `git status` | See what files have changed |
| `git add -A` | Stage all changes (new, modified, deleted) |
| `git add <file>` | Stage a specific file |
| `git commit -m "message"` | Save staged changes with a message |
| `git push origin master` | Upload commits to GitHub |
| `git pull origin master` | Download latest changes from GitHub |
| `git log --oneline -5` | View last 5 commits |
| `git diff` | See unstaged changes |
| `git diff --staged` | See staged changes |

### Troubleshooting

**If push fails with "rejected" error:**
```bash
# Pull latest changes first, then push
git pull origin master
git push origin master
```

**If you have merge conflicts:**
```bash
# 1. Open the conflicted files and resolve conflicts manually
# 2. Stage the resolved files
git add -A

# 3. Complete the merge
git commit -m "Resolve merge conflicts"

# 4. Push
git push origin master
```

**To discard all local changes (WARNING: loses all uncommitted work):**
```bash
git checkout -- .
git clean -fd
```

### Access URLs

| URL | Description |
|-----|-------------|
| http://localhost:5000 | Main application (redirects to landing page) |
| http://localhost:5000/landing-page/ | Landing page |
| http://localhost:5000/api/health | API health check |

## License

ISC

---

Built with care for CPA students in the Philippines.
