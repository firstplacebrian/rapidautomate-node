# RapidAutomate Desktop Node

A portable desktop node — workspace automation tool and game center for Windows.

## What It Includes

- Local automation services (engine + API)
- Full dashboard UI accessible from any browser on your network
- **Chess game** — play against the ChessForge bot (Positional Seat Theory AI)
- Account management, browser profiles, content tools
- No cloud required — runs entirely on your machine

## Quick Start

1. Unzip to any folder
2. Double-click `start-node.bat`
3. Browser opens automatically at `http://localhost:3001`
4. Click **Chess** in the sidebar to play

---

## How to Play Chess Against the Bot

### Overview
You play **White**. The bot plays **Black** using **Positional Seat Theory** — a chess AI that evaluates board positions based on 20-dimensional vectors and recommends moves from a learned pattern library.

### Playing the Game

1. **Click any of your pieces** (white) to select it — legal moves highlight with dots
2. **Click a highlighted square** to move there
3. The bot responds automatically after your move (~0.5s)
4. **Pawn promotion**: reaching the 8th rank opens a piece selector (Queen, Rook, Bishop, Knight)
5. **Flip Board**: swap perspective (useful when coaching yourself on Black's position)
6. **New Game**: resets the board at any time

### Understanding the Bot's Analysis Panel

After each bot move, the right panel updates with:

| Field | What it means |
|-------|---------------|
| **GTO Move** | The bot's chosen move from its pattern library |
| **Confidence** | How many similar positions it found in its library |
| **Expected outcome** | Average win % for this type of position (0–100) |
| **Clock phase** | Opening / Middlegame / Endgame — changes strategy |
| **White / Black authority** | Seat control score — who "owns" the board |

### Seat Theory (How the Bot Thinks)

The bot treats the board as a map of **seats** — key squares with strategic authority. High-authority seats (e4, d4, c3, f3, etc.) control more of the board. The bot aims to:

- **Occupy high-authority seats** with its pieces
- **Contest your control** when you hold the advantage
- **Exploit clock phase** — opening = development, middlegame = initiative, endgame = conversion

The **authority bar** shows who controls more of the board right now. If it's heavily black-side, the bot has positional pressure. If it's white-side, you're ahead — don't give it back.

### Tips for Beating the Bot

- The bot is strong in **middlegame positional play** — it will try to dominate the center
- It's weakest in **sharp tactical lines** — sacrifices and unexpected piece activity can throw it off
- When the bot has low confidence (few patterns), it falls back to random moves — push complications
- Watch the **seat advice text** — it tells you exactly what the bot is trying to do next

### Seeding the Bot's Library (Make It Stronger)

The bot learns from PGN games. To import grandmaster games:

```
POST http://localhost:3500/api/chess/import-pgn
{ "pgn": "<paste PGN text here>", "maxGames": 100 }
```

The more games imported, the stronger and more principled the bot's play becomes.

---

## Network Access

To access from another computer on the same WiFi:

1. On this machine, open cmd: `ipconfig | findstr "IPv4"`
2. Note the IP (e.g. `192.168.1.105`)
3. On the other computer: open `http://192.168.1.105:3001`

---

## Stopping the Node

Close the terminal window, or double-click `stop-node.bat`.
