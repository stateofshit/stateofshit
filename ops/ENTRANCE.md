# ENTRANCE — Read Me First

Fast facts and working rules for this VPS so any agent can get up to speed without asking. Keep this concise; detailed status lives elsewhere.

— Identity —
- Host: Ubuntu 24.04 (Noble), user `shit` (sudo). Public IP will change; current was captured in STATEOFSHIT.md entries.
- Domains: `stateofshit.live`, `www.stateofshit.live` (HTTPS via Let’s Encrypt).

— Canonical Docs —
- Live status: `~/STATEOFSHIT.md` (authoritative “what’s running/changed”).
- Deferred work: `~/TODOLIST.md` (don’t prompt about items once listed).

- Web Serving —
  - Nginx vhost: `/etc/nginx/sites-available/stateofshit.live` (enabled in `sites-enabled`).
  - Web root: `/var/www/stateofshit` (static site that renders the Markdown).
  - Publish the status page after editing the source:
    - `sudo install -m 0644 ~/STATEOFSHIT.md /var/www/stateofshit/STATEOFSHIT.md`
  - Test + reload Nginx: `sudo nginx -t && sudo systemctl reload nginx`
  - Logs: `/var/log/nginx/stateofshit.live_access.log` and `_error.log`.
  - OpenAPI: local copy at `~/code/openapi.json`; live JSON at `.rest` `/api/openapi.json` (behind auth).

- Security + Ops —
- Firewall: UFW active. Defaults deny incoming; allow `22/tcp`, `80/tcp`, `443/tcp`; SSH is rate‑limited.
- Fail2ban: enabled/active (default jails). SSH hardening is pending (see TODO).
- Updates: unattended‑upgrades enabled; timers for apt and certbot present.
- Time sync: `systemd-timesyncd` enabled and synchronized.
- Logs size: journald capped ~200 MB total.

- Services / Tooling —
- Nginx on 80/443. Postgres and Redis bound to localhost. Docker enabled. Direnv installed and hooked in `~/.bashrc`.
- Utilities available: `rg`, `fd`, `bat`, `ncdu`, `eza`, `tree`, `tldr`, `btop`, `dig`, `traceroute`, `ifconfig`.

- Pending (see TODOLIST.md for exact steps) —
- Swap file (2–4 GiB), SSH hardening, backups (restic + timer), extra Nginx hardening (headers, gzip, TLS tuning).

- Agent Session Protocol —
1) Read `~/STATEOFSHIT.md` and `~/TODOLIST.md` first.
2) Feature ideas before code: for any non-trivial feature/UX change, propose the plan (what/why, UI/UX, endpoints, risks) and wait for approval before implementation.
3) Do NOT re‑ask about TODO items; only execute when told.
4) Prefer surgical edits; always `nginx -t` before reloads. Keep changes minimal and documented in STATEOFSHIT.md entries.
5) For web content, update `/var/www/stateofshit` and the vhost above; don’t create parallel sites.
6) Keep secrets out of repos and webroot. Use `/etc/*` with root‑only perms for credentials.

- Quick Commands —
- Publish status page: `sudo install -m 0644 ~/STATEOFSHIT.md /var/www/stateofshit/STATEOFSHIT.md`
- Check site: `curl -I https://stateofshit.live/`
- Nginx status: `sudo systemctl status nginx`
- UFW status: `sudo ufw status verbose`
- Timers: `systemctl list-timers | grep -E 'apt|unattended|certbot'`
- .rest (API + Dashboard) —
  - Basic Auth protects entire site. Use admin credentials; rotate via `htpasswd`.
  - API base: `https://stateofshit.rest/api`; local base: `http://127.0.0.1:8001/api` (no Basic).
  - Upload cap: 1 GB (`client_max_body_size 1g`, `MAX_UPLOAD_MB=1024`).
  - Filesystem box root: `/srv/box` (public-live, public-space, staging, private).
  - Signed URLs: generate at `POST /api/fs/signed-url` (auth), fetch at `GET /api/fs/signed?token=…` (no auth). Secret `SIGNING_SECRET` in `/etc/stateofshit/api.env`.
  - JSON base64 read: `GET /api/fs/read-b64?path=…` returns `{ size, mime, content_b64 }`.
  - Dashboard has a “Signed URL” button to mint share links.
