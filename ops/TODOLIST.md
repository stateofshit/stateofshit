# TODO: VPS Hardening and Stability

See also: ~/CHAT_DB_PLAN.md (Chat Search DB Plan — Proposal)

## 0) Web UI + Filesystem features

- [x] .rest Endpoint Configurator UI
  - Add `GET/PUT /api/presets` storing JSON at `/srv/box/private/presets.json`.
  - Build `/config` page: pick endpoint, edit headers/body, send, view response, save presets.
  - Copy buttons for curl/fetch; basic request history.
- [x] .rest Files tab (box manager)
  - Tree view for `/srv/box`, drag/drop upload to `staging/`, text preview/edit.
  - Tag editor chips; quick actions: “Publish to .live/.space” (copy into `public-live/` or `public-space/`).
  - Show audit tail from `/var/log/stateofshit/audit.jsonl`.
- [x] .live terminal theme + safe viewer
  - Reskin status site to terminal look; link “Archive”.
  - Add read‑only viewer mapped to `/srv/box/public-live` (route like `/files/<path>`), no listings by default.
- [x] .space terminal landing
  - Terminal‑style hero; render a selected file from `/srv/box/public-space` (config at `/srv/box/public-space/_show.json`).
- [ ] Optional security refinements
  - [x] Path allowlist for signed URLs (e.g., only allow `/public-*`); keep TTL short.
  - [ ] Rate limits on `/api/fs/*` tuned for large uploads
    - Zones (add to `/etc/nginx/conf.d/ratelimit-rest.conf`):

```nginx
limit_req_zone $binary_remote_addr zone=perip:10m rate=10r/s;   # already present
limit_req_zone $binary_remote_addr zone=fsreq:10m rate=2r/s;    # file-op requests
limit_conn_zone $binary_remote_addr zone=fsconn:10m;            # concurrent transfers/IP
limit_req_zone $arg_token         zone=fstoken:10m rate=5r/s;   # signed URL fetches
```

    - Vhost rules for `stateofshit.rest` (within `server { ... }`):

```nginx
# Uploads
location = /api/fs/upload {
  limit_req zone=fsreq burst=10 nodelay;
  limit_conn fsconn 2;
  client_body_timeout 300s;
  proxy_set_header Host $host; proxy_pass http://127.0.0.1:8001;
}

# Mutating file ops
location ~ ^/api/fs/(write|move|delete|mkdir|publish|copy)$ {
  limit_req zone=fsreq burst=10;
  proxy_set_header Host $host; proxy_pass http://127.0.0.1:8001;
}

# Reads
location ~ ^/api/fs/(list|read|download|tags|read-b64)$ {
  limit_req zone=perip burst=30;
  proxy_set_header Host $host; proxy_pass http://127.0.0.1:8001;
}

# Signed downloads (no Basic Auth)
location = /api/fs/signed {
  auth_basic off;
  limit_req zone=fstoken burst=20 nodelay;
  proxy_set_header Host $host; proxy_pass http://127.0.0.1:8001;
}
```

    - Verify and tune:

```bash
sudo nginx -t && sudo systemctl reload nginx
tail -f /var/log/nginx/stateofshit.rest_error.log | rg 429
```

    - Rollback: comment the new `limit_*` lines, `nginx -t`, reload.

This checklist collects the tasks we decided to defer: adding a swap file and hardening SSH. Each item includes copy‑pasteable steps, verification, and rollback notes. Target OS: Ubuntu/Debian.

## 1) Add a 2 GiB swap file

- [ ] Check current memory and swap

```bash
free -h
swapon --show
cat /proc/swaps
```

- [ ] Create and enable swap (2 GiB)

```bash
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

- [ ] Persist across reboots (fstab)

```bash
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

- [ ] Optional: tune swappiness (less aggressive swapping)

```bash
echo 'vm.swappiness=20' | sudo tee /etc/sysctl.d/99-swappiness.conf
sudo sysctl -p /etc/sysctl.d/99-swappiness.conf
```

- [ ] Verify swap is active and persistent

```bash
free -h
cat /proc/swaps
grep -E '^/swapfile ' /etc/fstab
```

- [ ] Rollback (remove swap)

```bash
sudo swapoff /swapfile
sudo sed -i '\#^/swapfile #d' /etc/fstab
sudo rm -f /swapfile
sudo rm -f /etc/sysctl.d/99-swappiness.conf
```

Notes: Swap is a safety net against out‑of‑memory kills during memory spikes. 2–4 GiB is a sensible default for an 8 GiB VPS.

---

## 2) SSH hardening (do later, keep a session open)

Prereqs: You can log in with an SSH key as a non‑root sudo user.

- [ ] Backup current config

```bash
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.$(date +%F-%H%M%S)
```

- [ ] Apply recommended settings (edit with your preferred editor)

```bash
sudoedit /etc/ssh/sshd_config
# Ensure or add these lines (uncomment/adjust as needed):
PasswordAuthentication no
ChallengeResponseAuthentication no
PermitRootLogin prohibit-password
PubkeyAuthentication yes
PermitEmptyPasswords no
X11Forwarding no
MaxAuthTries 3
LoginGraceTime 20s
ClientAliveInterval 300
ClientAliveCountMax 2
# Optional: restrict to specific users
# AllowUsers youruser
```

- [ ] Reload and test (do NOT close your existing SSH session yet)

```bash
sudo systemctl reload ssh || sudo systemctl reload sshd
ssh -o PreferredAuthentications=publickey -o PubkeyAuthentication=yes youruser@your.server
```

- [ ] Optional: rate‑limit SSH with UFW (after ruleset is in place)

```bash
sudo ufw limit 22/tcp
sudo ufw status verbose
```

- [ ] Rollback quickly if locked out

```bash
sudo cp /etc/ssh/sshd_config.$(ls -t /etc/ssh/ | grep '^sshd_config' | head -1) /etc/ssh/sshd_config
sudo systemctl reload ssh || sudo systemctl reload sshd
```

---

## Optional follow‑ups (nice to have)

- [ ] Firewall baseline: allow 22,80,443; default deny incoming
- [ ] Automatic security updates: unattended‑upgrades + needrestart
- [ ] Fail2ban jails for sshd and nginx
- [ ] Backups with restic or borgbackup
- [ ] Monitoring: node‑exporter or netdata; lightweight: glances/btop
- [ ] Time sync: verify chrony or systemd‑timesyncd is active

---

## 3) Backups (restic + systemd timer)

Restic provides encrypted, deduplicated backups to many backends (local, S3, B2, etc.). Choose one backend and keep credentials out of git.

- [ ] Install restic

```bash
sudo apt-get update && sudo apt-get install -y restic
restic version
```

- [ ] Configure repository and credentials (example: local + S3)

```bash
# Create a secrets file readable only by root
sudo install -d -m 0750 /etc/restic
sudo bash -lc 'cat > /etc/restic/env <<\EOF
export RESTIC_REPOSITORY=/var/backups/restic
export RESTIC_PASSWORD=<strong-unique-password>
# Optional S3 example (comment out local repo above if using S3)
# export RESTIC_REPOSITORY=s3:https://s3.us-east-1.amazonaws.com/your-bucket/path
# export AWS_ACCESS_KEY_ID=...
# export AWS_SECRET_ACCESS_KEY=...
EOF'
sudo chmod 640 /etc/restic/env
sudo chown root:root /etc/restic/env

# Initialize repo (local example)
sudo mkdir -p /var/backups/restic
sudo bash -lc 'source /etc/restic/env && restic init'
```

- [ ] Select data to back up (example paths)

```bash
sudo install -m 0640 /dev/stdin /etc/restic/include <<'EOF'
/etc
/var/www
/var/lib/nginx
/var/lib/postgresql
/var/lib/redis
/home
EOF

sudo install -m 0640 /dev/stdin /etc/restic/exclude <<'EOF'
*.tmp
*.swp
*.cache
/home/*/.cache
/var/cache
/var/tmp
/var/lib/docker
EOF
```

- [ ] Create systemd service and timer

```bash
sudo tee /etc/systemd/system/restic-backup.service >/dev/null <<'EOF'
[Unit]
Description=Restic backup
Wants=network-online.target
After=network-online.target

[Service]
Type=oneshot
EnvironmentFile=/etc/restic/env
Nice=10
IOSchedulingClass=best-effort
IOSchedulingPriority=7
ExecStart=/bin/sh -c '\
  /usr/bin/restic backup \
    --verbose \
    --files-from=/etc/restic/include \
    --exclude-file=/etc/restic/exclude'
ExecStartPost=/bin/sh -c '\
  /usr/bin/restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --prune'
EOF

sudo tee /etc/systemd/system/restic-backup.timer >/dev/null <<'EOF'
[Unit]
Description=Daily Restic backup

[Timer]
OnCalendar=03:30
RandomizedDelaySec=30m
Persistent=true

[Install]
WantedBy=timers.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now restic-backup.timer
systemctl list-timers | grep restic || true
```

- [ ] Test and verify

```bash
sudo systemctl start restic-backup.service
sudo journalctl -u restic-backup.service -n 200 --no-pager
sudo bash -lc 'source /etc/restic/env && restic snapshots'
```

- [ ] Restore test (example: list and restore a file)

```bash
sudo bash -lc 'source /etc/restic/env && restic ls latest /etc/hosts'
sudo bash -lc 'source /etc/restic/env && restic restore latest --include /etc/hosts --target /root/restores'
```

- [ ] Rollback (disable backup)

```bash
sudo systemctl disable --now restic-backup.timer
```

Notes: Keep `/etc/restic/env` secure. For cloud backends, prefer IAM users/roles with least privilege and bucket lifecycle policies.

---

## 4) Nginx hardening and tuning

- [ ] Security headers snippet

```bash
sudo tee /etc/nginx/snippets/security-headers.conf >/dev/null <<'EOF'
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Referrer-Policy "strict-origin-when-cross-origin" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header Permissions-Policy "geolocation=(), microphone=(), camera=()" always;
# If you serve strictly HTTPS and handle nonces/hashes, consider CSP:
# add_header Content-Security-Policy "default-src 'self';" always;
server_tokens off;
EOF
```

- [ ] TLS baseline (if using TLS)

```bash
sudo tee /etc/nginx/snippets/tls-params.conf >/dev/null <<'EOF'
ssl_protocols TLSv1.2 TLSv1.3;
ssl_prefer_server_ciphers off;
ssl_session_cache shared:SSL:10m;
ssl_session_timeout 1d;
ssl_session_tickets off;
# Enable OCSP stapling when you have a resolver and chain
resolver 1.1.1.1 9.9.9.9 valid=300s;
resolver_timeout 5s;
EOF
```

- [ ] Gzip compression

```bash
sudo tee /etc/nginx/snippets/gzip.conf >/dev/null <<'EOF'
gzip on;
gzip_comp_level 5;
gzip_min_length 256;
gzip_proxied any;
gzip_types text/plain text/css application/javascript application/json application/xml+rss application/xml image/svg+xml font/ttf font/otf;
EOF
```

- [ ] Optional: basic request rate limiting

```bash
sudo tee /etc/nginx/conf.d/ratelimit.conf >/dev/null <<'EOF'
limit_req_zone $binary_remote_addr zone=perip:10m rate=10r/s;
limit_conn_zone $binary_remote_addr zone=peripconn:10m;
EOF
```

- [ ] Apply snippets in a server block (example)

```nginx
server {
    listen 80;
    server_name example.com;

    include snippets/security-headers.conf;
    include snippets/gzip.conf;
    # For TLS vhosts also: include snippets/tls-params.conf;

    # Optional per‑location limits
    # limit_req zone=perip burst=20 nodelay;
    # limit_conn peripconn 20;

    root /var/www/html;
    index index.html;
}
```

- [ ] Reload and verify

```bash
sudo nginx -t && sudo systemctl reload nginx
```

- [ ] Certbot renewal check

```bash
systemctl list-timers | grep certbot
sudo certbot renew --dry-run
```

Notes: Tailor headers and rate limits to your app. If proxying to upstream apps, also tune `proxy_read_timeout`, `proxy_connect_timeout`, and set `proxy_set_header` values correctly.

---

## 5) Database: PostgreSQL + pgvector (when needed)

Use the built-in Postgres with the pgvector extension for embeddings. Keep Postgres bound to localhost unless you explicitly need remote access.

- [ ] Check Postgres status and version

```bash
systemctl status postgresql --no-pager || true
psql -V
ss -ltnp | rg 5432 || true  # should show 127.0.0.1:5432
```

- [ ] Install pgvector

```bash
# Detect Postgres major and install matching pgvector package
PG_MAJOR=$(psql -V | awk '{print $3}' | cut -d. -f1)
sudo apt-get update
sudo apt-get install -y postgresql-$PG_MAJOR-pgvector
```

- [ ] Create an application database and user (example)

```bash
sudo -u postgres psql <<'SQL'
CREATE ROLE app WITH LOGIN PASSWORD 'change-me' NOSUPERUSER NOCREATEDB NOCREATEROLE;
CREATE DATABASE appdb OWNER app;
GRANT ALL PRIVILEGES ON DATABASE appdb TO app;
SQL
```

- [ ] Enable pgvector extension in the app database

```bash
sudo -u postgres psql -d appdb -c "CREATE EXTENSION IF NOT EXISTS vector;"
```

- [ ] Quick schema and KNN example

```bash
sudo -u postgres psql -d appdb <<'SQL'
CREATE TABLE IF NOT EXISTS docs (
  id BIGSERIAL PRIMARY KEY,
  content TEXT NOT NULL,
  embedding VECTOR(1536)
);
-- Example KNN (parameter $1 should be a 1536-dim vector)
-- SELECT id FROM docs ORDER BY embedding <-> $1 LIMIT 10;
SQL
```

- [ ] Keep Postgres local-only unless needed

```bash
sudo -u postgres psql -c "SHOW listen_addresses;"  # expect 'localhost'
sudo -u postgres psql -c "SHOW port;"               # expect 5432
```

- [ ] Backups

```bash
# Physical data dir is already included in restic include list: /var/lib/postgresql
# Optionally add logical dumps for portability:
sudo install -m 0755 -d /var/backups/pg
sudo tee /usr/local/bin/pgdump-appdb >/dev/null <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
ts=$(date +%F-%H%M%S)
pg_dump --format=custom --file=/var/backups/pg/appdb-$ts.dump appdb
find /var/backups/pg -type f -name 'appdb-*.dump' -mtime +14 -delete
EOF
sudo chmod 755 /usr/local/bin/pgdump-appdb

sudo tee /etc/systemd/system/pgdump-appdb.service >/dev/null <<'EOF'
[Unit]
Description=Logical backup of appdb

[Service]
Type=oneshot
ExecStart=/usr/local/bin/pgdump-appdb
EOF

sudo tee /etc/systemd/system/pgdump-appdb.timer >/dev/null <<'EOF'
[Unit]
Description=Nightly logical backup of appdb

[Timer]
OnCalendar=02:15
Persistent=true

[Install]
WantedBy=timers.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now pgdump-appdb.timer
systemctl list-timers | rg pgdump || true
```

Notes: For large-scale vector workloads consider Qdrant/Weaviate later, but start simple with Postgres + pgvector.
## New ideas (dashboard polish and UX)

- [ ] Files: per-row actions (rename/delete/publish) with a 3‑dot menu
- [ ] Files: multi‑select (shift/ctrl) + bulk actions (delete/publish/move)
- [ ] Files: keyboard navigation (arrows, Enter to open, F2 rename)
- [ ] Files: image/video/audio previews and PDF quick viewer
- [ ] Files: progress bars for uploads; cancel in-flight upload
- [ ] Files: copy/move UI (choose destination path) and duplicate action
- [ ] Files: zip/unzip actions; “Download folder as ZIP”
- [ ] Files: quick search/filter in current directory
- [ ] Files: inline rename on single-click pause
- [ ] Files: generate signed URL from selection (in-place)
- [ ] Files: publish target subpath selection (e.g., to /public-live/subdir)
- [ ] Header: highlight current page (active state)
- [ ] Header: factor common nav into a shared include (client-side injection)
- [ ] Dashboard: add Swagger/ReDoc viewer page for OpenAPI rendering
- [ ] Dashboard: compact mode toggle for Cheat Sheet
- [ ] Dashboard: “Copy as fetch/requests” toggle for key commands
- [ ] Dashboard: small path existence indicator on Cheat Sheet path inputs
- [ ] Docs: add screenshots/animated GIFs for common flows

Process reminder
- [x] Always propose feature ideas and get approval before coding UI/UX changes.
