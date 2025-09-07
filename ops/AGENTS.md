# AGENTS — StateOfShit Ops Guide

Read this first, every session.

Scope
- This covers the whole “stateofshit” server: sites (.live/.rest/.space), API, and content box.

Start‑of‑session Checklist
- Read `~/ENTRANCE.md` (facts + commands) and `~/STATEOFSHIT.md` (latest changes).
- Don’t prompt about items already in `~/TODOLIST.md` unless asked.

Auth & Access
- `.rest` is behind Nginx Basic Auth. Use the current admin creds provided out‑of‑band. Rotate with `sudo htpasswd /etc/nginx/.htpasswd-stateofshit admin`.
- API is also reachable locally without Basic at `http://127.0.0.1:8001` (for maintenance).

Layout
- Sites: `/var/www/stateofshit` (live), `/var/www/stateofshit-rest` (rest), `/var/www/stateofshit-space` (space)
- API: `/opt/stateofshit-api` (FastAPI app), service `stateofshit-api.service`
- Box: `/srv/box` with `public-live/`, `public-space/`, `staging/`, `private/`
- Config: `/etc/stateofshit/api.env`, `/etc/stateofshit/box.env`

API & Docs
- OpenAPI 3.1.1: `~/code/openapi.json` (local copy), `GET /api/openapi.json` (behind auth).
- Filesystem API is sandboxed to `/srv/box`; uploads up to 1 GB.
- Signed URLs: mint via `POST /api/fs/signed-url` (auth); fetch `GET /api/fs/signed?token=…` (no auth).

Rules
- Keep edits surgical; always `nginx -t` before reload.
- Don’t commit secrets to files in home or webroots. Use `/etc/stateofshit/*` for creds.
- Log substantive changes as a new entry in `~/STATEOFSHIT.md`.

Process Policy — Propose Before You Code
- For new features or UX changes, present a concise proposal first (bullets: what/why, UI/UX, endpoints touched, risks) and wait for approval before editing files.
- Only skip the proposal step when the user explicitly requests immediate execution or small copy tweaks.
- After approval, implement exactly the agreed scope and report back with a brief diff summary and verification steps.

Troubleshooting
- Nginx logs per site: `/var/log/nginx/*_access.log`, `*_error.log`
- API logs: `journalctl -u stateofshit-api -n 200`
- Connectivity: `curl -I https://stateofshit.live/` and `curl -I https://stateofshit.rest/`
