# RapidAutomate Desktop Node

A portable deployment package that turns any Windows desktop into a RapidAutomate automation node.

## What It Does

- Runs CTR campaigns (Google Search, Maps, YouTube)
- Simulates GPS drives to boost Maps rankings
- Warms up Gmail/Google accounts
- Launches antidetect browser profiles
- Syndicates content across platforms
- Automates social media (11 platforms)
- Syncs all data to the cloud dashboard every 5 minutes

## Quick Start

1. Unzip to any folder
2. Edit `config.env` with your credentials
3. Double-click `start-node.bat`
4. View results at https://www.rapidrankings.io

## Setup

### Requirements
- Windows 10/11
- No installation needed — everything is included

### Configuration

Edit `config.env` before first run:

```
CENTRAL_API_EMAIL=your@email.com
CENTRAL_API_PASSWORD=yourpassword
HEADLESS=true          (false to see Chrome windows)
ENGINE_PORT=3500       (change if port conflict)
CONTENT_PORT=3001      (change if port conflict)
```

### First Run

The node will:
1. Create local SQLite databases
2. Auto-login to the cloud API
3. Register as a new instance (gets unique ID)
4. Start heartbeat (every 5 min)
5. Start cloud sync (every 5 min)

## File Structure

```
rapidautomate-node/
├── start-node.bat          ← Double-click to start
├── stop-node.bat           ← Double-click to stop
├── config.env              ← Edit your settings here
├── README.md               ← You are here
└── resources/
    ├── node.exe            ← Node.js runtime (included)
    ├── engine-bundle.js    ← Antidetect engine
    ├── content-bundle.mjs  ← Content distribution service
    ├── node_modules/       ← Native dependencies
    ├── prisma/             ← Database schema
    └── data/               ← Local databases + logs (created on first run)
```

## Multi-Node

You can run multiple nodes on different machines. Each node:
- Gets its own instance ID (ISN)
- Runs campaigns from its own IP/location
- Syncs independently to the same dashboard
- Shows up as a separate instance in the admin panel

## Ports

| Service | Port | Description |
|---------|------|-------------|
| Engine | 3500 | Antidetect browser engine |
| Content | 3001 | Content distribution, CTR, warmup |

## Logs

Logs are in `resources/data/`:
- `engine.log` — Browser engine activity
- `content.log` — Content service, sync, campaigns

## Stopping

Either:
- Double-click `stop-node.bat`
- Close the start-node window
- Run `taskkill /F /IM node.exe` in any terminal

## Dashboard

All data syncs to https://www.rapidrankings.io

Login with the same credentials from your `config.env`.
