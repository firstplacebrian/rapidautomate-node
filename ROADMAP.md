# Desktop Node Deployment Roadmap

> How to deploy a RapidAutomate node on any Windows desktop computer.
> Each node runs independently, syncs to the same cloud dashboard, different IP/location.

---

## What You Get Per Node

- CTR campaigns from that machine's IP/location
- GPS drive simulations from that geo
- Account warmup with unique browser fingerprints
- Browser automation (antidetect profiles)
- Content syndication
- Social automation (11 platforms)
- Everything syncs to rapidrankings.io dashboard under your org

---

## Phase 1: Package the Portable Install

**Status**: NOT STARTED
**What**: Create a self-contained zip that runs on any Windows machine with zero setup.

- [ ] Build `rapidautomate-node.zip` containing:
  - `node.exe` (Windows x64 binary, no installer needed)
  - `engine-bundle.js` (antidetect engine)
  - `content-bundle.mjs` (content distribution)
  - `node_modules/` (native deps: better-sqlite3, bcryptjs, etc.)
  - `prisma/` (schema + migrations)
  - `data/` (empty — fresh SQLite DB created on first run)
  - `start-node.bat` (double-click launcher)
  - `stop-node.bat` (graceful shutdown)
  - `config.env` (editable settings)
- [ ] `start-node.bat` should:
  - Set env vars from `config.env`
  - Run `prisma db push` on first launch (create tables)
  - Start engine on port 3500
  - Start content-distribution on port 3001
  - Show status in console window
  - Auto-login to cloud API
  - Register as new instance (unique ISN)
  - Start heartbeat + sync loop
- [ ] `stop-node.bat` should:
  - Gracefully kill both node processes
  - Log shutdown time
- [ ] `config.env` template:
  ```
  CENTRAL_API_URL=https://rapidranking-api.vercel.app
  CENTRAL_API_PREFIX=/api/v1
  CENTRAL_API_EMAIL=jenn@rapidrankings.io
  CENTRAL_API_PASSWORD=RapidRank2026
  API_KEY=desktop-api-key-1234567890
  ENGINE_PORT=3500
  CONTENT_PORT=3001
  ```
- [ ] Test: unzip on a clean Windows machine, double-click `start-node.bat`, verify it registers + syncs

**Size estimate**: ~150-200 MB (mostly node.exe + native modules)

---

## Phase 2: Multi-Node Campaign Distribution

**Status**: NOT STARTED
**What**: Assign campaigns to specific nodes so work is split by location.

- [ ] Add `nodeId` field to CTR campaigns and GPS drives
- [ ] Each node only picks up campaigns assigned to its ISN (or unassigned = any node)
- [ ] Cloud dashboard shows which node is running which campaign
- [ ] API endpoint: `POST /sync` action `assign-campaigns` — push campaign assignments to nodes

**Example**:
- Node A (Jenn's laptop, Denver) → "High Ground JJ - Maps Pack" (local searches)
- Node B (Merlino's desktop, different city) → "High Ground JJ - Organic Search" (non-local branded terms)

---

## Phase 3: Remote Node Management

**Status**: NOT STARTED
**What**: Control remote nodes from the dashboard without touching that machine.

- [ ] Task receiver already exists (`startTaskReceiver()`) — needs cloud endpoint
- [ ] Add `POST /api/v1/sync` action `pending-tasks` — node polls for commands
- [ ] Dashboard can:
  - Start/stop/pause campaigns on any node
  - Create new campaigns on a specific node
  - Queue GPS drives on a specific node
  - View per-node health, uptime, last heartbeat
- [ ] Add node status page to dashboard (list of registered instances, online/offline, last sync time)

---

## Phase 4: Auto-Update

**Status**: NOT STARTED
**What**: Push bundle updates to remote nodes without manual file copying.

- [ ] Version check on heartbeat — cloud returns `latestVersion` in heartbeat response
- [ ] If version mismatch, node downloads new bundles from cloud/GDrive/S3
- [ ] Hot-reload: restart services with new bundles without losing campaign state
- [ ] Rollback: keep previous bundle as backup

---

## Phase 5: Node Scaling

**Status**: NOT STARTED
**What**: Run nodes on VPS/cloud for 24/7 operation + geo diversity.

- [ ] Same zip works on any Windows VPS (Hetzner, Vultr, etc.)
- [ ] Linux variant: replace `node.exe` with linux binary, `.bat` → `.sh`
- [ ] Docker container option for cloud deployment
- [ ] Geo targeting: spin up VPS in specific cities for hyper-local CTR
- [ ] Cost model: ~$5-10/mo per VPS node

---

## Quick Reference

| Item | Value |
|------|-------|
| Cloud API | https://rapidranking-api.vercel.app |
| Dashboard | https://www.rapidrankings.io |
| Engine port | 3500 |
| Content port | 3001 |
| Sync interval | 5 min |
| Heartbeat | 5 min |
| Auth | jenn@rapidrankings.io / RapidRank2026 |
| Org ID | cmml39w3n00024qz5d7ch2nhf |
| Current ISN (this laptop) | cmmlmn73n00016ee2mv7pfvu9 |
| Bundle source | `browser-sender/scripts/bundle-desktop.mjs` |
| Resources dir | `browser-sender/src-tauri/resources/` |
