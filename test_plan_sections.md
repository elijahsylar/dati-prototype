# D.A.T.I. Test Plan — Sections 1–3

---

## Section 1: Introduction

This test plan covers D.A.T.I. (Don't Ask The Internet), a multiplayer trivia app used during live bar events. The stack is Node.js/Express, MySQL 8 (`dati_trivia`), vanilla HTML/CSS/JS, and JWT auth.

The system has two audiences with different risk profiles:

- **Hosts / admins** use a desktop admin panel to manage themes, questions, and events. Mistakes here are recoverable.
- **Players** use iPads running in kiosk mode at the bar. Mistakes here are visible to paying customers mid-event and are not recoverable in the moment.

The purpose of this plan is to verify that D.A.T.I. behaves correctly in both contexts before it is used at a live event. Specifically, the plan validates:

1. The API contract between frontend and backend is honored for every endpoint and every documented error path.
2. Authentication is enforced where the design says it should be, and not where it shouldn't.
3. The app renders and remains operable on the actual iPad hardware used at the bar, and on the desktop browsers hosts use for admin work.
4. The data model enforces its own constraints (foreign keys, uniqueness, enum values, soft-delete semantics).

Scope is limited to the prototype codebase in this repository: `db/`, `server/`, and `public/`. Load testing, penetration testing, and accessibility audits are out of scope for this plan.

---

## Section 2: Compatibility Testing

### 2.1 Risks

- iPads at the bar run Safari in kiosk mode. If layout breaks on iPad viewport sizes or Safari-specific CSS, players see a broken screen mid-event and we cannot fix it during the game.
- Hosts use a mix of Chrome, Firefox, and Safari on macOS and Windows. JWT storage, `fetch()` behavior, and CORS vary subtly across browsers.
- Touch-only input on iPad means hover states, small tap targets, and double-tap-to-zoom can block gameplay.
- Network on the bar Wi-Fi is shared and unreliable. Clients that don't handle request failures gracefully will hang.
- Screen orientation lock, auto-sleep, and iOS background-tab throttling can freeze game state on iPads that aren't actively interacted with.

### 2.2 Items to test

- `public/index.html` (admin panel) on desktop Chrome, Firefox, Safari.
- `public/play.html` (player view) on iPad Safari in kiosk mode, and on a second iPad model if available.
- JWT login flow and token persistence across page reloads.
- All admin CRUD screens: themes, questions, events.
- Touch targets on all player-facing buttons.
- Behavior under degraded network (throttled Wi-Fi, brief disconnect).

### 2.3 Approach

- Manual exploratory testing on each target browser/device.
- Side-by-side comparison of admin panel rendering on Chrome vs. Safari vs. Firefox at 1280×800 and 1920×1080.
- iPad testing on the actual kiosk device, in kiosk mode, at the bar's network.
- Chrome DevTools device emulation for first-pass iPad checks; real-device confirmation before sign-off.
- Network throttling via DevTools "Slow 3G" profile to confirm loading states and error handling.

### 2.4 Regulatory criteria

None applicable. D.A.T.I. does not process payments, PII beyond admin usernames, or regulated data.

### 2.5 Pass/fail criteria

**Pass:**
- Admin panel renders correctly and all CRUD operations complete on Chrome, Firefox, and Safari (current stable).
- Player view renders correctly on iPad Safari in kiosk mode, with all tap targets ≥ 44×44 pt.
- JWT token survives a page reload on all target browsers.
- No console errors on page load for any target.

**Fail:**
- Layout overflow, clipped content, or unreachable controls on any target.
- A CRUD action that works on Chrome but fails silently on Safari or iPad.
- Token lost on reload.
- Any JS error on page load.

### 2.6 Entry/exit criteria

**Entry:**
- Server starts cleanly and `GET /api/health` returns `{"status":"ok","db":"connected"}` (confirmed on 2026-04-05).
- Conformance tests (Section 3) pass.
- Test iPad is provisioned with kiosk mode and connected to the bar network.

**Exit:**
- Every item in 2.2 tested on every target in 2.2.
- All failures either fixed or explicitly accepted as known issues with documented workarounds.

### 2.7 Deliverables

- Compatibility test matrix: one row per (browser/device, feature), columns for pass/fail and notes.
- Screenshots of any rendering defects.
- List of known issues with severity and workaround.

### 2.8 Suspension/resumption criteria

**Suspend** if:
- The backend is unreachable from the test client (blocks all frontend testing).
- A breaking change lands in `public/` mid-cycle.

**Resume** when:
- Backend health check returns green again.
- Frontend build is stable for at least one full pass on Chrome desktop.

### 2.9 Environmental/staffing needs

- One desktop test machine with Chrome, Firefox, and Safari installed (macOS required for Safari).
- One iPad, ideally the exact model used at the bar, provisioned in kiosk mode.
- Access to the bar's Wi-Fi network, or a representative throttled network.
- One tester. Compatibility testing is largely manual and serial; a second tester does not speed it up meaningfully.

---

## Section 3: Conformance Testing

### 3.1 Risks

- API endpoints can drift from their documented contracts (status codes, field names, error shapes) as the backend evolves, silently breaking the frontend.
- Auth middleware can be applied to the wrong routes — either leaving mutations unprotected or blocking public reads.
- DB schema constraints (FKs, unique keys, enums) may be bypassed by API code that doesn't validate before insert.
- Soft-delete semantics (`is_active = 0` for themes/questions, `status = 'cancelled'` for events) can leak deleted records into list endpoints if `WHERE` clauses drift.
- SQL injection becomes possible if any query switches from parameterized binding to string concatenation.

### 3.2 Items to test

All endpoints were exercised against the running server on 2026-04-05. Items under test:

- `GET /api/health`
- `POST /api/auth/setup`, `POST /api/auth/login`
- Full CRUD on `/api/themes`, `/api/questions`, `/api/events`
- JWT middleware on all mutating routes
- DB-level constraints: `themes.name` uniqueness, FK `questions.theme_id → themes.id`, FK `events.theme_id → themes.id`, enum `correct_answer` (A/B/C/D), enum `events.status`
- Soft-delete behavior: `DELETE /api/themes/:id`, `DELETE /api/questions/:id`, `DELETE /api/events/:id`

### 3.3 Approach

- Automated API test script (`/tmp/dati_tests.js`) hitting every endpoint with valid, invalid, missing-field, bad-auth, and SQL-injection inputs.
- Each test asserts status code and inspects the response body.
- Results logged to `test_results.md` as PASS/FAIL with request, expected status, received status, and response.
- Schema conformance verified by confirming that FK violations and duplicate inserts surface as expected error codes.

### 3.4 Regulatory criteria

None applicable.

### 3.5 Pass/fail criteria

**Pass:** Every endpoint returns the documented status code for valid input, missing fields, missing/bad JWT, unknown IDs, FK violations, duplicates, and injection attempts.

**Fail:** Any endpoint returns a status code other than documented, or a SQL injection attempt alters/returns unauthorized data, or a mutation endpoint succeeds without a valid JWT.

**Current result (2026-04-05):** 60 / 60 PASS. Specifically:
- `GET /api/health` → 200 with `db: connected`.
- `POST /api/auth/setup`: valid → 200; missing password → 400; empty body → 400; unknown user → 404; SQL-injected username (`admin' OR '1'='1`) → 404.
- `POST /api/auth/login`: valid → 200 with JWT; bad password → 401; unknown user → 401; missing fields → 400; SQL-injected username (`admin' OR 1=1 --`) → 401.
- `/api/themes`: public GET → 200; POST without JWT → 401; POST with forged JWT → 401; POST empty bearer → 401; POST missing `name` → 400; POST valid → 201; POST duplicate name → 409; POST with injection string in name → 201 (escaped, no schema damage); GET unknown id → 404; PUT with no fields → 400; PUT/DELETE without JWT → 401.
- `/api/questions`: public GET and filters (`?theme_id=`, `?difficulty=`) → 200; POST without JWT → 401; POST missing fields → 400; invalid `correct_answer=Z` → 400; lowercase `b` accepted and normalized → 201; FK violation (`theme_id=999999`) → 500; injection in `question_text` → 201 (escaped); GET unknown id → 404; PUT no fields → 400; DELETE soft-deletes → 200.
- `/api/events`: public GET and `?status=` filter → 200; POST without JWT → 401; POST missing `theme_id`/`event_date` → 400; POST valid → 201; FK violation → 500; PUT with forged/malformed JWT → 401; PUT valid (including `status` transition to `published`) → 200; DELETE cancels → 200; injection in `?status=` query param → 200 with empty results (safely parameterized).

One conformance gap noted but not failing: FK violations return 500 rather than 400. This is a design-spec tightening to consider, not a contract break.

### 3.6 Entry/exit criteria

**Entry:**
- Server running on a reachable port with `.env` populated (DB creds, `JWT_SECRET`, `PORT`).
- DB seeded with schema from `db/schema.sql` and at least one admin user in `admin_users`.
- `GET /api/health` returns 200.

**Exit:**
- 100% of documented endpoints tested.
- 100% pass rate, or all failures triaged with owners and severity.
- Test script and `test_results.md` committed or archived.

### 3.7 Deliverables

- `test_results.md`: full request/response log for every test (3099 lines, 60 cases, generated 2026-04-05).
- `/tmp/dati_tests.js`: repeatable test script.
- This test plan section.
- Triage list for any failing cases (currently empty).

### 3.8 Suspension/resumption criteria

**Suspend** if:
- `GET /api/health` fails (DB unreachable) — no further endpoint testing is meaningful.
- A schema migration is mid-flight and tables are in an inconsistent state.
- More than 20% of tests fail on a clean run, indicating a systemic break that needs developer attention before further test effort.

**Resume** when:
- Health check returns green.
- Schema is stable and seeded.
- Systemic failure is root-caused and fixed.

### 3.9 Environmental/staffing needs

- Local MySQL 8 instance with `dati_trivia` database, user `dati`/`dati123` (or equivalent).
- Node.js 18+ with project dependencies installed (`npm install`).
- `.env` with `DB_*`, `JWT_SECRET`, `PORT` populated. Port 3000 was in use during the 2026-04-05 run; server was moved to 3100.
- One tester with shell access and Node.js familiarity. The full conformance suite runs in under 5 seconds, so one person can run and triage it.
