# 🎯 D.A.T.I. — Don't Ask The Internet

Trivia app backend prototype for **The Cellar Door**.

## Quick Start

### 1. Prerequisites
- Node.js 18+ → [nodejs.org](https://nodejs.org)
- MySQL 8+ → [mysql.com](https://dev.mysql.com/downloads/)

### 2. Clone & Install
```bash
cd dati-prototype
npm install
```

### 3. Set Up the Database
```bash
# Log into MySQL
mysql -u root -p

# Then run:
source db/schema.sql
source db/seed.sql
```

### 4. Configure Environment
```bash
cp .env.example .env
```
Edit `.env` and set your MySQL password:
```
DB_PASSWORD=your_mysql_password
JWT_SECRET=pick_any_random_string_here
```

### 5. Set Up Admin Password
```bash
# Start the server first
npm start

# In another terminal, set the admin password:
curl -X POST http://localhost:3000/api/auth/setup \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'
```

### 6. Open the Admin Panel
- **On your computer:** http://localhost:3000
- **On iPad (same Wi-Fi):** http://YOUR_LOCAL_IP:3000

To find your local IP:
- **Mac:** `ifconfig | grep "inet " | grep -v 127.0.0.1`
- **Windows:** `ipconfig` → look for IPv4 Address

### 7. Log In
- Username: `admin`
- Password: `admin123` (or whatever you set)

---

## Project Structure
```
dati-prototype/
├── db/
│   ├── schema.sql          # MySQL tables
│   └── seed.sql            # 6 themes, 80+ questions, sample events
├── server/
│   ├── index.js            # Express entry point
│   ├── db.js               # MySQL connection pool
│   ├── middleware/
│   │   └── auth.js         # JWT auth middleware
│   └── routes/
│       ├── auth.js         # Login + password setup
│       ├── themes.js       # CRUD for themes
│       ├── questions.js    # CRUD for questions
│       └── events.js       # CRUD for events
├── public/
│   ├── index.html          # Admin panel UI
│   ├── css/admin.css       # Styles
│   └── js/admin.js         # Client-side logic
├── .env.example
├── package.json
└── README.md
```

## API Endpoints

All write endpoints require `Authorization: Bearer <token>` header.

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/login` | Login, returns JWT |
| POST | `/api/auth/setup` | Set password (first run) |
| GET | `/api/themes` | List all themes |
| GET | `/api/themes/:id` | Theme + its questions |
| POST | `/api/themes` | Create theme 🔒 |
| PUT | `/api/themes/:id` | Update theme 🔒 |
| DELETE | `/api/themes/:id` | Deactivate theme 🔒 |
| GET | `/api/questions` | List questions (?theme_id=&difficulty=) |
| POST | `/api/questions` | Create question 🔒 |
| PUT | `/api/questions/:id` | Update question 🔒 |
| DELETE | `/api/questions/:id` | Deactivate question 🔒 |
| GET | `/api/events` | List events (?status=) |
| POST | `/api/events` | Create event 🔒 |
| PUT | `/api/events/:id` | Update event 🔒 |
| DELETE | `/api/events/:id` | Cancel event 🔒 |
| GET | `/api/health` | DB connection check |

## Seed Data Included

- **6 Themes:** American History, Music Through the Decades, 2000s Nostalgia, Science & Nature, Sports Legends, Food & Drink
- **80+ Questions** across all themes with easy/medium/hard difficulty
- **6 Sample Events** with real dates starting 02/19/2026
- **2 Admin Users** (password setup required on first run)

## Dev Mode
```bash
npm run dev    # auto-restarts on file changes (uses nodemon)
```
