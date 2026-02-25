const express = require('express');
const cors = require('cors');
const path = require('path');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, '..', 'public')));

// API Routes
app.use('/api/auth',      require('./routes/auth'));
app.use('/api/themes',    require('./routes/themes'));
app.use('/api/questions',  require('./routes/questions'));
app.use('/api/events',    require('./routes/events'));

// Health check
app.get('/api/health', async (req, res) => {
    const pool = require('./db');
    try {
        await pool.query('SELECT 1');
        res.json({ status: 'ok', db: 'connected' });
    } catch (err) {
        res.status(500).json({ status: 'error', db: 'disconnected' });
    }
});

// Serve admin UI for any non-API route
app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, '..', 'public', 'index.html'));
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`\n  🎯 D.A.T.I. Backend running on http://localhost:${PORT}`);
    console.log(`  📱 Admin panel: http://localhost:${PORT}`);
    console.log(`  💡 To access from iPad, use your local IP: http://<your-ip>:${PORT}\n`);
});
