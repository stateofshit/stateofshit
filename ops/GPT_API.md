GPT API — StateOfShit

Purpose
- This guide teaches a custom GPT how to use the StateOfShit API correctly, with auth, parameters, and end‑to‑end examples for every endpoint. The “box” filesystem API is the primary surface for uploads/downloads and content management.

Bases & Auth
- Hosted base (behind Basic Auth): https://stateofshit.rest/api
- Local base (no Basic, maintenance only): http://127.0.0.1:8001/api
- Basic Auth for hosted: send Authorization: Basic <base64(admin:password)>
  - With curl: use -u admin:password
  - Do not hardcode credentials in prompts; inject at runtime.
- Bearer API key: supported but typically empty in prod (edge is Basic). If used, send Authorization: Bearer <API_KEY>.

Conventions
- All filesystem paths are sandboxed to /srv/box. A leading / in query/body is treated as relative to this root. Traversal outside the box is rejected.
- Content types:
  - JSON requests: Content-Type: application/json
  - Form-encoded text writes: application/x-www-form-urlencoded
  - Uploads: multipart/form-data (field name file)
- Limits:
  - Upload cap: 1 GB (MAX_UPLOAD_MB=1024). Exceeds → 413.
  - Signed URLs can only serve public paths (default allowlist ^/(public-live|public-space)/).

Health & Meta
- GET /health → 200 { status, time }
- GET /version → 200 { name, version }
- GET /openapi.json → OpenAPI 3.1.1 (behind Basic)

Filesystem API (box)
1) List directory
  - GET /fs/list?path=/
  - Example (hosted):
    curl -u admin:*** "https://stateofshit.rest/api/fs/list?path=/"

2) Read text file
  - GET /fs/read?path=/staging/sample.txt
    curl -u admin:*** "https://stateofshit.rest/api/fs/read?path=/staging/sample.txt"

3) Read file as base64 (with size + mime)
  - GET /fs/read-b64?path=/staging/image.png
    curl -u admin:*** "https://stateofshit.rest/api/fs/read-b64?path=/staging/image.png"

4) Download file (auth)
  - GET /fs/download?path=/staging/big.bin
    curl -u admin:*** -OJL "https://stateofshit.rest/api/fs/download?path=/staging/big.bin"

5) Write small text (overwrite)
  - PATCH /fs/write?path=/staging/note.txt body: content=...
    curl -u admin:*** -X PATCH \
      -H "Content-Type: application/x-www-form-urlencoded" \
      --data-urlencode "content=hello world" \
      "https://stateofshit.rest/api/fs/write?path=/staging/note.txt"

6) Upload file (multipart)
  - POST /fs/upload with fields path, file[, overwrite]
    curl -u admin:*** -X POST \
      -F path=/staging \
      -F file=@./local-file.bin \
      "https://stateofshit.rest/api/fs/upload"

7) Mkdir
  - POST /fs/mkdir { path }
    curl -u admin:*** -X POST -H "Content-Type: application/json" \
      -d '{"path":"/staging/sub"}' \
      "https://stateofshit.rest/api/fs/mkdir"

8) Move/Rename
  - POST /fs/move { src, dst }
    curl -u admin:*** -X POST -H "Content-Type: application/json" \
      -d '{"src":"/staging/old.txt","dst":"/staging/new.txt"}' \
      "https://stateofshit.rest/api/fs/move"

9) Delete
  - DELETE /fs/delete?path=/staging/new.txt
    curl -u admin:*** -X DELETE "https://stateofshit.rest/api/fs/delete?path=/staging/new.txt"

10) Tags (get)
  - GET /fs/tags?path=/staging/file.txt
    curl -u admin:*** "https://stateofshit.rest/api/fs/tags?path=/staging/file.txt"

11) Tags (patch add/remove)
  - PATCH /fs/tags { path, add[], remove[] }
    curl -u admin:*** -X PATCH -H "Content-Type: application/json" \
      -d '{"path":"/staging/file.txt","add":["doc","draft"],"remove":["old"]}' \
      "https://stateofshit.rest/api/fs/tags"

12) Copy (file or folder)
  - POST /fs/copy { src, dst }
    curl -u admin:*** -X POST -H "Content-Type: application/json" \
      -d '{"src":"/staging/a.txt","dst":"/staging/copies/a.txt"}' \
      "https://stateofshit.rest/api/fs/copy"

13) Publish to public site roots
  - POST /fs/publish { src, target }
    - target: "live" (→ /public-live) or "space" (→ /public-space)
    curl -u admin:*** -X POST -H "Content-Type: application/json" \
      -d '{"src":"/staging/a.txt","target":"live"}' \
      "https://stateofshit.rest/api/fs/publish"
    - Then fetch at:
      - https://stateofshit.live/files/a.txt
      - https://stateofshit.space/files/a.txt

14) Signed download links
  - POST /fs/signed-url { path, ttl_seconds? } → { url, expires }
    curl -u admin:*** -X POST -H "Content-Type: application/json" \
      -d '{"path":"/public-live/a.txt","ttl_seconds":300}' \
      "https://stateofshit.rest/api/fs/signed-url"
  - GET /fs/signed?token=… (no auth) → file download
    curl -OJL "https://stateofshit.rest/api/fs/signed?token=…"
  - Notes:
    - Path must match allowlist (default: /public-live or /public-space). Else 403.
    - token expires at the UNIX timestamp in expires.

Audit & Presets
- GET /audit/tail?limit=200 → recent audit events (JSON lines)
  - curl -u admin:*** "https://stateofshit.rest/api/audit/tail?limit=50"
- GET/PUT /presets → request “presets” for the Config UI
  - GET returns { items: [] }
  - PUT body: { items: [ { name, method, url, headers, body }, ... ] }
  - Example PUT:
    curl -u admin:*** -X PUT -H "Content-Type: application/json" \
      -d '{"items":[{"name":"List Root","method":"GET","url":"/api/fs/list?path=/","headers":{},"body":null}]}' \
      "https://stateofshit.rest/api/presets"

Records API (key/value + tags)
1) List
  - GET /records?limit=50&offset=0&tag=foo&tag=bar
    curl -u admin:*** "https://stateofshit.rest/api/records?limit=20&tag=news"

2) Create
  - POST /records { key, value, tags?[] }
    curl -u admin:*** -X POST -H "Content-Type: application/json" \
      -d '{"key":"post:123","value":{"title":"Hello"},"tags":["news"]}' \
      "https://stateofshit.rest/api/records"

3) Get one
  - GET /records/{key}
    curl -u admin:*** "https://stateofshit.rest/api/records/post:123"

4) Replace value
  - PUT /records/{key} { value }
    curl -u admin:*** -X PUT -H "Content-Type: application/json" \
      -d '{"value":{"title":"Updated"}}' \
      "https://stateofshit.rest/api/records/post:123"

5) Delete
  - DELETE /records/{key}
    curl -u admin:*** -X DELETE "https://stateofshit.rest/api/records/post:123"

6) Tags for record
  - PATCH /records/{key}/tags { add[], remove[] }
    curl -u admin:*** -X PATCH -H "Content-Type: application/json" \
      -d '{"add":["featured"],"remove":["news"]}' \
      "https://stateofshit.rest/api/records/post:123/tags"

7) Aggregate tags
  - GET /tags?scope=all|records|files (default all)
    curl -u admin:*** "https://stateofshit.rest/api/tags?scope=files"

Typical Flows
1) Upload → Publish to live
  - Upload to /staging:
    curl -u admin:*** -F path=/staging -F file=@./file.txt https://stateofshit.rest/api/fs/upload
  - Publish to live:
    curl -u admin:*** -X POST -H 'Content-Type: application/json' \
      -d '{"src":"/staging/file.txt","target":"live"}' \
      https://stateofshit.rest/api/fs/publish
  - Access at: https://stateofshit.live/files/file.txt

2) Create signed link for sharing
  - Mint token:
    curl -u admin:*** -X POST -H 'Content-Type: application/json' \
      -d '{"path":"/public-live/file.txt","ttl_seconds":300}' \
      https://stateofshit.rest/api/fs/signed-url
  - Download (no auth):
    curl -OJL "https://stateofshit.rest/api/fs/signed?token=..."

3) Read a small text asset inline
  - curl -u admin:*** "https://stateofshit.rest/api/fs/read?path=/public-space/info.txt"
  - Or with base64 to embed as data URI:
    curl -u admin:*** "https://stateofshit.rest/api/fs/read-b64?path=/public-live/logo.png"

Error Handling
- 400 invalid input; 401/403 auth; 404 not found; 409 conflict (upload exists); 410 token expired; 413 too large.
- For large files, prefer signed URLs for client access to avoid holding Basic credentials client-side.

Performance & Limits
- Keep request frequency modest for large transfers; future rate limits may apply on /api/fs/*.
- Use streaming clients for big downloads/uploads when possible.

Notes for Custom GPT
- Always specify correct Content-Type and HTTP method.
- Prefer absolute paths starting with / and keep them within /srv/box sandbox.
- Do not reveal credentials; assume they are provided via tool input or environment.


Best Practices for GPTs

1) Choose the right base and auth
- Prefer the hosted base https://stateofshit.rest/api with Basic Auth for end users. Use -u admin:password in curl or set Authorization: Basic ... header. Never hardcode secrets in responses; treat them as tool inputs.
- Use the local base http://127.0.0.1:8001/api only for maintenance flows executed on the server.

2) Plan small, verifiable steps
- Before mutating, read first. Example: list the directory before writing or deleting.
- After each mutation (write/mkdir/move/delete/upload/publish), re‑fetch the affected path or tags to confirm.
- Avoid batch changes unless the user explicitly asks; prefer one clear step at a time.

3) Be precise with paths
- All paths are relative to /srv/box. Use a leading / (e.g., /staging/file.txt).
- Never attempt to access outside the box; the API rejects traversal.
- Publishing copies to /public-live or /public-space; it does not move the source.

4) Uploads and large files
- Max upload size is 1 GB. Suggest checking local file size first; if >1 GB, ask the user to split or compress.
- Use multipart/form-data with field name file and set path to a directory (e.g., /staging). Do not Base64‑encode uploads.
- For big client downloads, mint signed URLs instead of proxying content through the dashboard.

5) Signed URLs (safe sharing)
- Prefer /api/fs/signed-url for shareable links. Returned token works without auth at /api/fs/signed.
- Only public paths are allowed by default (/public-live and /public-space). If 403, ask user to publish the file first.
- Keep TTL short (e.g., 300 seconds) unless the user requests otherwise.

6) Errors and retries
- Common errors: 400 invalid input, 401/403 auth, 404 not found, 409 conflict (target exists), 410 expired token, 413 too large, 429 rate limit.
- Safe to retry automatically: GET and HEAD with exponential backoff (e.g., 0.5s, 1s, 2s up to 3 tries) on 429/502/503/504.
- Do NOT auto‑retry mutating endpoints (POST/PATCH/DELETE) without user confirmation, to avoid double writes. If a retry is needed, verify state first (e.g., list path, check existence) then resume.
- On 409 Exists during upload: either set overwrite=true (not currently supported on upload field; instead target a unique destination) or propose a new filename.

7) Response handling
- Read JSON when content-type is application/json; otherwise treat as text or binary as appropriate.
- For /fs/read-b64, the response provides { size, mime, content_b64 } suitable for embedding via data: URIs.

8) Security hygiene
- Do not echo credentials or tokens in model outputs. Instead, describe where to place them (curl -u, Authorization header) and let tools fill them.
- Prefer signed URLs for client consumption to avoid exposing Basic credentials in client code.

9) Example snippets (beyond curl)

JavaScript (fetch)
```js
// Assumes you have Basic header prepared at runtime (do not hardcode)
const auth = 'Basic ' + btoa(`${user}:${pass}`);

// List root
const res = await fetch('https://stateofshit.rest/api/fs/list?path=/', {
  headers: { Authorization: auth }
});
const j = await res.json();

// Upload (browser)
const fd = new FormData();
fd.append('path', '/staging');
fd.append('file', fileInput.files[0]);
await fetch('https://stateofshit.rest/api/fs/upload', {
  method: 'POST', headers: { Authorization: auth }, body: fd
});

// Publish
await fetch('https://stateofshit.rest/api/fs/publish', {
  method: 'POST', headers: { 'Content-Type': 'application/json', Authorization: auth },
  body: JSON.stringify({ src: '/staging/file.txt', target: 'live' })
});

// Mint signed URL
const r2 = await fetch('https://stateofshit.rest/api/fs/signed-url', {
  method: 'POST', headers: { 'Content-Type': 'application/json', Authorization: auth },
  body: JSON.stringify({ path: '/public-live/file.txt', ttl_seconds: 300 })
});
const { url } = await r2.json(); // use https://stateofshit.rest + url
```

Python (requests)
```python
import requests
from requests.auth import HTTPBasicAuth

base = 'https://stateofshit.rest/api'
auth = HTTPBasicAuth('admin', 'password')

# List
r = requests.get(f'{base}/fs/list', params={'path': '/'}, auth=auth)
r.raise_for_status(); print(r.json())

# Write text
requests.patch(f'{base}/fs/write', params={'path':'/staging/note.txt'},
               data={'content':'hello'}, auth=auth).raise_for_status()

# Upload
with open('local.bin', 'rb') as f:
    files = {'file': ('local.bin', f)}
    data = {'path': '/staging'}
    requests.post(f'{base}/fs/upload', files=files, data=data, auth=auth).raise_for_status()
```

10) Decision guide
- Need to show a file to the public? Use publish (→ /files/... on .live/.space) or mint a signed URL.
- Need to modify text? Prefer /fs/read then /fs/write; confirm with /fs/read.
- Need to duplicate content? Use /fs/copy, not move, when preserving source matters.
- Unsure what exists? Start with /fs/list and /fs/tags before acting.

11) Rate limiting (forward-looking)
- If you receive 429, back off and re‑try reads only. For writes/uploads, ask the user to retry and consider staggering operations.

