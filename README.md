# 🎯 D.A.T.I. — Don't Ask The Internet

**A real-time multiplayer trivia platform built for live bar events.**

D.A.T.I. is a full-stack trivia application designed for The Cellar Door, a local bar looking to drive weeknight traffic through hosted trivia events. The platform supports 30+ simultaneous tablet connections, admin-managed themed rounds, timed gameplay with speed-based scoring, and a signature "Ask the Internet" lifeline mechanic that turns a single Google search into a strategic, public, high-drama moment.

The name is the mechanic — tablets lock into kiosk mode during gameplay. Try to leave? *Don't Ask The Internet.*

> 🔗 **Live Demo:** [dati.elijah-sylar.com](https://dati.elijah-sylar.com) *(password-protected — contact for access)*

---

## Features

### Admin Panel
- **Theme Management** — Create, edit, and deactivate trivia themes with full CRUD operations
- **Question Bank** — 80+ seed questions across 6 themes with difficulty tiers (easy / medium / hard) and four-option multiple choice
- **Event Scheduling** — Configure trivia nights with date, time, team limits, question count, and per-question time limits
- **Event Lifecycle** — Draft → Published → Active → Completed status workflow
- **JWT Authentication** — Secure admin login with bcrypt password hashing
- **Inline Game Testing** — One-click demo launches from the admin panel to preview any theme's gameplay

### Gameplay Engine
- **Speed-Based Scoring** — Faster correct answers earn more points (+10 / +7 / +5 based on response time)
- **30-Second Countdown Timer** — Visual urgency with color transitions (gold → orange → red pulse)
- **Difficulty Badges** — Questions display difficulty level with corresponding point multipliers
- **Theme Selection** — Lobby with dropdown or URL parameter (`?theme_id=`) for direct theme loading
- **Live Score Tracking** — Animated score flashes on correct/incorrect answers
- **Final Leaderboard** — End-of-game scoreboard ranking all teams

### Planned Features
- **Real-Time Multiplayer** — Socket.io game rooms with synced questions and live team scoring
- **"Ask the Internet" Lifeline** — Each team gets one 30-second internet search per game, announced on the bar's TV with a dramatic countdown
- **TV Display Mode** — Large-screen view showing questions and live leaderboard for the entire venue
- **QR Code Join Flow** — Teams scan to join a game session from bar-provided tablets
- **Kiosk Mode** — iOS Guided Access / Android kiosk lock to prevent app-switching during gameplay
- **Analytics Dashboard** — Track returning teams, popular themes, and peak nights
- **Offline Resilience** — Graceful handling of Wi-Fi interruptions mid-game

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| **Runtime** | Node.js 18+ |
| **Framework** | Express.js |
| **Database** | MySQL 8 (InnoDB, utf8mb4) |
| **Authentication** | JWT + bcrypt |
| **Real-Time** | Socket.io *(planned)* |
| **Frontend** | Vanilla HTML / CSS / JavaScript |
| **Process Manager** | PM2 |
| **Reverse Proxy** | Nginx with SSL (Let's Encrypt) |
| **Hosting** | DigitalOcean |
| **Version Control** | Git / GitHub |

---

## Architecture

```
Client (Browser/Tablet)
        │
        ▼
   Nginx (SSL + Basic Auth)
        │
        ▼
   Express.js (Port 3001)
   ├── /api/auth      → JWT login + setup
   ├── /api/themes    → Theme CRUD
   ├── /api/questions  → Question CRUD (filterable by theme + difficulty)
   ├── /api/events    → Event CRUD (filterable by status)
   ├── /api/health    → DB connection check
   └── /public        → Static admin panel + gameplay UI
        │
        ▼
   MySQL 8 (dati_trivia)
   ├── themes          → Trivia categories
   ├── questions       → Question bank with options + difficulty
   ├── events          → Scheduled trivia nights
   └── admin_users     → Host/admin accounts
```

---

## Database Schema

```sql
themes
├── id              INT PRIMARY KEY AUTO_INCREMENT
├── name            VARCHAR(100) UNIQUE
├── description     VARCHAR(500)
├── is_active       TINYINT(1) DEFAULT 1
├── created_at      TIMESTAMP
└── updated_at      TIMESTAMP

questions
├── id              INT PRIMARY KEY AUTO_INCREMENT
├── theme_id        INT → FK themes(id)
├── question_text   VARCHAR(1000)
├── option_a–d      VARCHAR(500)
├── correct_answer  ENUM('A','B','C','D')
├── difficulty      ENUM('easy','medium','hard')
├── is_active       TINYINT(1) DEFAULT 1
├── created_at      TIMESTAMP
└── updated_at      TIMESTAMP

events
├── id              INT PRIMARY KEY AUTO_INCREMENT
├── theme_id        INT → FK themes(id)
├── title           VARCHAR(200)
├── event_date      DATE
├── start_time      TIME
├── max_teams       INT DEFAULT 30
├── max_players_per_team  INT DEFAULT 5
├── question_count  INT DEFAULT 15
├── time_limit_seconds    INT DEFAULT 30
├── status          ENUM('draft','published','active','completed','cancelled')
├── created_at      TIMESTAMP
└── updated_at      TIMESTAMP

admin_users
├── id              INT PRIMARY KEY AUTO_INCREMENT
├── username        VARCHAR(50) UNIQUE
├── password_hash   VARCHAR(255)
├── role            ENUM('admin','host')
└── created_at      TIMESTAMP
```

All tables use soft deletes (`is_active` flag) to preserve data integrity and support audit history.

---

## API Reference

All write operations require `Authorization: Bearer <token>` header.

### Authentication
| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/api/auth/login` | Authenticate → returns JWT |
| `POST` | `/api/auth/setup` | Initialize admin password (first run) |

### Themes
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/themes` | List all active themes |
| `GET` | `/api/themes/:id` | Get theme with associated questions |
| `POST` | `/api/themes` | Create new theme 🔒 |
| `PUT` | `/api/themes/:id` | Update theme 🔒 |
| `DELETE` | `/api/themes/:id` | Soft-delete theme 🔒 |

### Questions
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/questions` | List questions (filter: `?theme_id=` `?difficulty=`) |
| `POST` | `/api/questions` | Create question 🔒 |
| `PUT` | `/api/questions/:id` | Update question 🔒 |
| `DELETE` | `/api/questions/:id` | Soft-delete question 🔒 |

### Events
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/events` | List events (filter: `?status=`) |
| `POST` | `/api/events` | Create event 🔒 |
| `PUT` | `/api/events/:id` | Update event 🔒 |
| `DELETE` | `/api/events/:id` | Cancel event 🔒 |

### Health
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/health` | Database connection status |

---

## Project Structure

```
dati-prototype/
├── db/
│   ├── schema.sql              # Table definitions + indexes + foreign keys
│   └── seed.sql                # 6 themes, 80+ questions, 6 sample events
├── server/
│   ├── index.js                # Express entry point
│   ├── db.js                   # MySQL connection pool (mysql2/promise)
│   ├── middleware/
│   │   └── auth.js             # JWT verification middleware
│   └── routes/
│       ├── auth.js             # Login + initial password setup
│       ├── themes.js           # Theme CRUD endpoints
│       ├── questions.js        # Question CRUD endpoints
│       └── events.js           # Event CRUD endpoints
├── public/
│   ├── index.html              # Admin panel (SPA)
│   ├── play.html               # Gameplay interface (iPad-optimized)
│   ├── css/
│   │   └── admin.css           # Admin styles (navy + gold theme)
│   └── js/
│       └── admin.js            # Admin client-side logic
├── .env.example                # Environment template
├── .gitignore
├── package.json
└── README.md
```

---

## Getting Started

### Prerequisites
- [Node.js 18+](https://nodejs.org)
- [MySQL 8+](https://dev.mysql.com/downloads/)

### Installation

```bash
git clone https://github.com/elijahsylar/dati-prototype.git
cd dati-prototype
npm install
```

### Database Setup

```bash
mysql -u root -p
```

```sql
CREATE DATABASE dati_trivia;
CREATE USER 'dati'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON dati_trivia.* TO 'dati'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

```bash
mysql -u dati -p dati_trivia < db/schema.sql
mysql -u dati -p dati_trivia < db/seed.sql
```

### Environment Configuration

```bash
cp .env.example .env
```

Edit `.env`:
```
DB_HOST=localhost
DB_USER=dati
DB_PASSWORD=your_password
DB_NAME=dati_trivia
DB_PORT=3306
JWT_SECRET=your_secret_key
PORT=3000
```

### Run

```bash
npm start          # production
npm run dev        # development (auto-restart with nodemon)
```

### Initialize Admin Account

```bash
curl -X POST http://localhost:3000/api/auth/setup \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'
```

### Access

| Interface | URL |
|-----------|-----|
| Admin Panel | `http://localhost:3000` |
| Gameplay Demo | `http://localhost:3000/play.html` |
| iPad (same network) | `http://YOUR_LOCAL_IP:3000` |

---

## Deployment

The production instance runs on a DigitalOcean droplet with Nginx reverse proxy, PM2 process management, and Let's Encrypt SSL.

```bash
# Process management
pm2 start server/index.js --name dati
pm2 save
pm2 startup

# Nginx handles SSL termination + basic auth on non-API routes
# Certbot manages certificate auto-renewal
```

---

## Seed Data

The database ships with demo content ready for immediate testing:

| Content | Count |
|---------|-------|
| Themes | 6 (American History, Music, 2000s Nostalgia, Science, Sports, Food & Drink) |
| Questions | 80+ across all themes (easy / medium / hard) |
| Events | 6 sample trivia nights |
| Admin Users | 2 (password setup required on first run) |

---

## Author

**Elijah Camp** — Database Administrator & Full Stack Developer
- Backend architecture, database design, API development, admin panel
- University of Colorado Denver — Computer Science, Spring 2026

---

*Don't Ask The Internet. Use your brain.* 🧠
