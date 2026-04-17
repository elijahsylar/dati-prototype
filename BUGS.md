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
