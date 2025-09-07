# Domains — StateOfShit

Authoritative list of domains and their purpose, DNS targets, and deployment status.

- stateofshit.live
  - Purpose: Public status site rendering `STATEOFSHIT.md`.
  - DNS: A `147.93.183.152` (www → same).
  - Nginx: `/etc/nginx/sites-available/stateofshit.live` → `/var/www/stateofshit`.
  - TLS: Let’s Encrypt active; HTTP→HTTPS redirect enabled.

- stateofshit.rest
  - Purpose: Main API dashboard + JSON API.
  - DNS: A `147.93.183.152` (www → same).
  - Nginx: `/etc/nginx/sites-available/stateofshit.rest` → `/var/www/stateofshit-rest`.
  - TLS: Let’s Encrypt active; HTTP→HTTPS redirect enabled.
  - Endpoints: proxied to FastAPI under `/api/*`.

- stateofshit.space
  - Purpose: Public "Coming Soon" landing.
  - DNS: A `147.93.183.152` (www → same).
  - Nginx: `/etc/nginx/sites-available/stateofshit.space` → `/var/www/stateofshit-space`.
  - TLS: Let’s Encrypt active; HTTP→HTTPS redirect enabled.
  - Auth: None (public).

Notes
- Update DNS first (A and www A → `147.93.183.152`), then run Certbot with Nginx plugin.
- Keep all sites under `/etc/nginx/sites-available/*` with symlinks in `sites-enabled/`.
