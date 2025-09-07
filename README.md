# stateofshit — Monorepo

Source of truth for ops docs and site sources. No secrets. Deploy to webroots via scripts.

Structure
- `ops/` — operational docs (AGENTS.md, ENTRANCE.md, STATEOFSHIT.md, TODOLIST.md, GPT_API.md, plans)
- `sites/`
  - `live/` — static status site (deploys to `/var/www/stateofshit`)
  - `rest/` — dashboard/static docs (deploys to `/var/www/stateofshit-rest`)
  - `space/` — static landing (deploys to `/var/www/stateofshit-space`)
- `scripts/` — deploy helpers

Usage
- Local edit, commit, then deploy:
  - `./scripts/deploy-live.sh`
  - `./scripts/deploy-rest.sh`
  - `./scripts/deploy-space.sh`
  - `./scripts/deploy-all.sh`

Notes
- Keep credentials in `/etc/stateofshit/*`, never here.
- Webroots are not git repos; avoid exposing `.git` over HTTP.
- Publish status page after editing `~/STATEOFSHIT.md`:
  - `sudo install -m 0644 ~/STATEOFSHIT.md /var/www/stateofshit/STATEOFSHIT.md`

