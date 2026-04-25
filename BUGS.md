# BUGS / Known Issues

Running log of issues noticed in passing that are **not** in scope for the current work. Fix in dedicated cleanup sessions, not drive-by.

---

## Infrastructure

### nginx `sites-enabled/dati` is a regular file, not a symlink
- **Noticed:** 2026-04-17, during Phase 1 step-1 verification
- **Where:** droplet `159.65.75.40`, `/etc/nginx/sites-enabled/dati`
- **What:** In Debian/Ubuntu nginx convention, files in `sites-enabled/` are expected to be symlinks back to `sites-available/`. On this droplet, `sites-enabled/dati` is a separate regular ASCII file that has drifted from `sites-available/dati`.
- **Drift content:** The two files differ only in `proxy_pass http://localhost:3001;` (sites-available) vs `proxy_pass http://127.0.0.1:3001;` (sites-enabled). Functionally identical on this host.
- **Risk:** Edits to `sites-available/dati` won't take effect — nginx loads the `sites-enabled` copy. Future-us could change sites-available, reload nginx, and be confused when nothing changes. Also breaks the convention used by Aurora / PHT / timeclock / art-website / elijahsylar-redirect on this same droplet, which *are* symlinks.
- **Fix (later):** `sudo rm /etc/nginx/sites-enabled/dati && sudo ln -s /etc/nginx/sites-available/dati /etc/nginx/sites-enabled/dati && sudo nginx -t && sudo systemctl reload nginx`. Decide first whether the canonical config should use `localhost` or `127.0.0.1` (prefer the latter — matches the sites-enabled version currently live in prod).

---

## Dependencies

### npm audit — 7 vulnerabilities pre-existing in transitive deps
- **Noticed:** 2026-04-17, during Phase 1 step 5 (`npm install socket.io`)
- **What:** `npm install` reported `7 vulnerabilities (1 moderate, 6 high)`. These are not caused by socket.io — the count was the same before and after the install, so they're all in existing transitive deps (likely bcrypt / mysql2 / express chain).
- **Fix (later):** Run `npm audit` to enumerate each CVE, decide per-item whether `npm audit fix` is safe or whether a major version bump is needed. Do not run `npm audit fix --force` blindly — it can pin breaking major versions.

---

## Logging

### serve-static URIError noise from path-traversal probes
- **Noticed:** 2026-04-17, during Phase 1 step 9 (reviewing `pm2 logs dati` after deploy)
- **Where:** `/home/elijah/.pm2/logs/dati-error.log` on the droplet
- **What:** Attackers probe the public URL with URL-encoded path-traversal patterns like `/%c0` and `/%c0/`. Express's `serve-static` correctly rejects them with `URIError: Failed to decode param '/%c0'`, but each rejection produces a ~10-line stack trace in the error log. Over 51+ days of uptime the log has accumulated many of these, making real errors harder to spot during post-incident review.
- **Sample:** `URIError: Failed to decode param '/%c0' at decodeURIComponent ... at serveStatic (…/node_modules/serve-static/index.js:125:12)`
- **Risk:** Cosmetic only — the probes aren't succeeding, the server is behaving correctly. The concern is signal-to-noise in the error log.
- **Fix (later):** Add a small Express error-handling middleware that catches `URIError` specifically and responds 400 without logging the stack:
  ```js
  app.use((err, req, res, next) => {
      if (err instanceof URIError) return res.status(400).send('Bad Request');
      next(err);
  });
  ```
  Pairs naturally with the log-rotation work already planned for Phase 7 production hardening.

---

## Architecture

### Broadcast-only state: audit for other latent "host connects late" bugs
- **Noticed:** 2026-04-17, Phase 2 — host console showed `Teams (0)` while server-side the event had 1 team and a player was mid-game. Root cause: `/host.html` populated its roster solely from live `lobby:team_joined` broadcasts. A player who joined before the host connected was invisible to the host because broadcasts are fire-and-forget — no snapshot mechanism.
- **Fix shipped in Phase 2.1:** new `GET /api/events/:id/teams` and `GET /api/events/:id/scores` REST endpoints; `/host.html` fetches both alongside its `host:watch_event` emit.
- **Class of bug to audit:** anywhere state is derived solely from socket broadcasts without an accompanying snapshot lookup. Known candidates:
  - **Timer recovery on host page reload.** `question_started_at` lives in `event_state`, but `/host.html` has no flow to rehydrate "current question + time remaining" on a fresh page load into a live event. A host refresh mid-question currently shows a dead timer. Phase 7 hardening — needs the same snapshot treatment as teams/scores, probably via an extended `GET /api/events/:id/live-state` that returns current question index, question body, and server-wall-clock timestamp for started_at so the client can compute `remaining = time_limit - (now - started_at)`.
  - **Lifeline state on player rejoin.** `teams.lifeline_used` isn't surfaced in the `team:rejoin` ack. A player who used their lifeline, then reloaded, would see the UI as if they still had it. Phase 5 work when the full lifeline UI lands.
- **General principle to enforce:** every broadcast event should have a paired "snapshot on load" REST endpoint (or inclusion in an existing one), so any late-joiner can converge to current truth without waiting for the next broadcast.
