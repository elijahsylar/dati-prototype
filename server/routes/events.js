const express = require('express');
const pool = require('../db');
const auth = require('../middleware/auth');
const router = express.Router();

// GET /api/events — list events (optional ?status= filter)
router.get('/', async (req, res) => {
    try {
        let query = `
            SELECT e.*, t.name AS theme_name,
                   (SELECT COUNT(*) FROM questions q WHERE q.theme_id = e.theme_id AND q.is_active = 1) AS available_questions
            FROM events e
            JOIN themes t ON t.id = e.theme_id
        `;
        const params = [];

        if (req.query.status) {
            query += ' WHERE e.status = ?';
            params.push(req.query.status);
        }

        query += ' ORDER BY e.event_date ASC';

        const [rows] = await pool.query(query, params);
        res.json(rows);
    } catch (err) {
        console.error('Get events error:', err);
        res.status(500).json({ error: 'Server error' });
    }
});

// GET /api/events/:id
router.get('/:id', async (req, res) => {
    try {
        const [rows] = await pool.query(
            `SELECT e.*, t.name AS theme_name
             FROM events e
             JOIN themes t ON t.id = e.theme_id
             WHERE e.id = ?`,
            [req.params.id]
        );
        if (rows.length === 0) return res.status(404).json({ error: 'Event not found' });
        res.json(rows[0]);
    } catch (err) {
        console.error('Get event error:', err);
        res.status(500).json({ error: 'Server error' });
    }
});

// POST /api/events — create event
router.post('/', auth, async (req, res) => {
    try {
        const { theme_id, title, event_date, start_time, max_teams, max_players_per_team, question_count, time_limit_seconds } = req.body;

        if (!theme_id || !title || !event_date) {
            return res.status(400).json({ error: 'theme_id, title, and event_date are required' });
        }

        const [result] = await pool.query(
            `INSERT INTO events (theme_id, title, event_date, start_time, max_teams, max_players_per_team, question_count, time_limit_seconds)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
            [
                theme_id, title, event_date,
                start_time || '19:00:00',
                max_teams || 30,
                max_players_per_team || 5,
                question_count || 10,
                time_limit_seconds || 30
            ]
        );

        const [event] = await pool.query('SELECT * FROM events WHERE id = ?', [result.insertId]);
        res.status(201).json(event[0]);
    } catch (err) {
        console.error('Create event error:', err);
        res.status(500).json({ error: 'Server error' });
    }
});

// PUT /api/events/:id — update event
router.put('/:id', auth, async (req, res) => {
    try {
        const allowed = ['theme_id', 'title', 'event_date', 'start_time', 'max_teams', 'max_players_per_team', 'question_count', 'time_limit_seconds', 'status'];
        const fields = [];
        const values = [];

        for (const key of allowed) {
            if (req.body[key] !== undefined) {
                fields.push(`${key} = ?`);
                values.push(req.body[key]);
            }
        }

        if (fields.length === 0) return res.status(400).json({ error: 'No fields to update' });

        values.push(req.params.id);
        await pool.query(`UPDATE events SET ${fields.join(', ')} WHERE id = ?`, values);

        const [event] = await pool.query('SELECT * FROM events WHERE id = ?', [req.params.id]);
        res.json(event[0]);
    } catch (err) {
        console.error('Update event error:', err);
        res.status(500).json({ error: 'Server error' });
    }
});

// DELETE /api/events/:id — cancel event
router.delete('/:id', auth, async (req, res) => {
    try {
        await pool.query("UPDATE events SET status = 'cancelled' WHERE id = ?", [req.params.id]);
        res.json({ message: 'Event cancelled' });
    } catch (err) {
        console.error('Delete event error:', err);
        res.status(500).json({ error: 'Server error' });
    }
});

module.exports = router;
