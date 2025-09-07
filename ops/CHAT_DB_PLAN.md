Chat Search DB Plan — Proposal (Ideas Before Code)

Decision Path
- Start now: Option A — SQLite + FTS5 (fast, zero‑ops, good keyword search)
- Upgrade later: Option B — Postgres + Full‑Text Search (robust, concurrent)
- Optional Phase 2: Add pgvector to Postgres for semantic search (hybrid)

Objectives
- Persist all assistant chats with metadata for reliable retrieval.
- Provide fast keyword search with filters now; keep API stable for future upgrades.
- Keep data private (no external sends) unless explicitly approved for embeddings later.

Scope (initial)
- Storage: SQLite file colocated with API (A). Schema mirrors Postgres plan.
- Features: ingest, list threads, keyword search with highlights/snippets, thread view, tag/title ops, deletion/redaction.
- UI: New “Chat Search” page on .rest with search box, filters (role/date/tags/thread), result list, thread viewer.

Data Model (logical, shared across A → B → C)
- threads
  - id: string/UUID (stable across backends)
  - title: text (nullable)
  - tags: array (SQLite JSON; Postgres TEXT[])
  - created_at, updated_at: ISO timestamps (Z)

- messages
  - id: integer (SQLite autoincrement / Postgres BIGSERIAL)
  - thread_id: FK → threads.id
  - role: text (user|assistant|system|tool)
  - content: text (chat body)
  - meta: JSON (tool IDs, costs, tokens, etc.)
  - created_at: ISO timestamp (Z)

Search Indexing
- Option A (SQLite)
  - messages_fts: FTS5 virtual table on content (tokenizer=unicode61)
  - Triggers: keep FTS in sync on INSERT/UPDATE/DELETE
  - Optional auxiliary columns for snippet/highlight

- Option B (Postgres)
  - messages.tsv: tsvector (to_tsvector('english', content))
  - Index: GIN on tsv
  - Ranking: ts_rank(ms.tsv, plainto_tsquery('english', $q))

- Option C (Postgres + pgvector)
  - messages.embedding: VECTOR(768|1536) + ivfflat index
  - Hybrid rank: alpha*semantic + (1-alpha)*lexical

Planned API Surface (no code yet)
- POST /api/chats/ingest
  - Body: { thread_id?, role, content, meta? } → returns { thread_id, message_id }
  - Behavior: create thread if missing; auto title on first assistant message (optional)

- GET /api/chats/search
  - Query: q, top_k=20, from/to, role[], thread_id, tags[], semantic? (future)
  - Returns: [{ thread_id, message_id, role, snippet, score, created_at }]

- GET /api/chats/thread
  - Query: thread_id → returns ordered messages + thread meta

- PATCH /api/chats/thread
  - Body: { title?, add_tags?, remove_tags? }

- DELETE /api/chats/message | /api/chats/thread
  - Hard delete for redaction; optional soft‑delete flag later

Dashboard UI (planned)
- New “Chat Search” page with:
  - Search input with enter-to-search; semantic toggle disabled in Phase 1
  - Filters: role (multi), date range, tags, thread picker
  - Results list with highlights/snippets and scores
  - Thread viewer panel (side-by-side) with quick tag/title edit and delete

Privacy & Safety
- Default: no outbound calls for indexing; embeddings only after explicit approval.
- Support redaction (delete) and retention policy (e.g., prune >180 days) if desired.
- Avoid logging secrets in meta; mark fields for exclusion from search if needed.

Backups & Ops
- SQLite file included in system backups (and future restic plan).
- Migration to Postgres keeps same logical schema; add DAL layer to abstract storage.

Upgrade Plan (A → B)
1) Add DAL interface (ChatStore) so backends swap via config.
2) Stand up Postgres tables + indexes; enable triggers/generated tsv.
3) Export from SQLite as JSONL; import into Postgres.
4) Flip config to Postgres; validate search parity on samples.
5) Optional: dual‑write for a short window, then retire SQLite.

Risks & Mitigations
- Concurrency (SQLite): keep writes small and infrequent; API batches inserts; future move to Postgres.
- Search quality: FTS is lexical; semantic toggle arrives with pgvector later.
- Storage growth: prune or archive old threads if needed.

Approval Checklist (to proceed)
- Confirm Option A now, with upgrade to B later.
- Confirm API endpoints and minimal UI scope above.
- Confirm retention and redaction requirements (defaults: keep all; allow hard delete).

After Approval (implementation outline)
- Add DAL + SQLite schema + FTS triggers; wire endpoints; add UI page; log in STATEOFSHIT.md.
- Provide migration script template for A→B and a verification checklist.

