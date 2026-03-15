# ⛵ Biblitos

> *"Train up a child in the way he should go; even when he is old he will not depart from it."*
> — Proverbs 22:6

**Biblitos** is a free-play biblical world for children ages 3–8. Children explore interactive stories from Scripture — touching characters that come alive, hearing God's Word spoken warmly in their own language, discovering hidden wonders in every corner of the world.

No ads. No pressure. No losing. Just the Word of God present in play.

---

## 🌍 Vision

A digital world where God's Word is the **environment** — not the lesson.

Inspired by Toca Boca's model of free, joyful exploration — but built with a single mission: to plant Scripture deep in the hearts of children before they can even read, through joy, audio, and wonder.

---

## 🗺️ Worlds

| World | Status | Core Scripture |
|---|---|---|
| ⛵ **World 1 — Noah's Ark** | 🔨 In Development | Genesis 6–9 |
| 🌟 **World 2 — Bethlehem** | 📋 Planned | Luke 2 |
| 🌱 **World 3 — The Creation** | 📋 Planned | Genesis 1 |

---

## 🎮 How It Works

Children open the app and see a living biblical world. No instructions appear. They simply reach out and touch.

- Touch the **elephant** → wiggles ears, warm voice says: *"God saw that it was good — Genesis 1:25"*
- Touch the **dove** → wings open, flies a small loop: *"The dove returned with an olive leaf — Genesis 8:11"*
- Touch the **rainbow** → gentle music plays: *"My covenant I set in the clouds — Genesis 9:13"*

Every interaction plants a seed. The child doesn't know they're absorbing Scripture. They're just playing.

---

## 🌐 Languages

Launches in **4 languages simultaneously**:

| Language | Community |
|---|---|
| 🇪🇸 Spanish | Latin America + U.S. Hispanic |
| 🇺🇸 English | North America + Global |
| 🇧🇷 Portuguese | Brazil — world's largest evangelical population |
| 🇫🇷 French | Francophone Africa — fastest growing Church on earth |

---

## 🛠️ Tech Stack

| Layer | Tool |
|---|---|
| Game Engine | Godot 4 |
| Language | GDScript |
| Art | Gemini AI (watercolor style, transparent PNG) |
| TTS Audio | Gemini 2.5 Pro TTS |
| Sound FX | Freesound.org (CC license) |
| Analytics | Firebase Analytics |
| IAP (packs) | Godot GodotInAppPurchases |
| CI/CD | GitHub Actions + Copilot Coding Agent |

---

## 🤖 Coding Agent Setup

This repo is configured for **GitHub Copilot Coding Agent** with Godot + Node.js:

```yaml
# .github/workflows/copilot-setup-steps.yml
# Provisions Godot 4 + Node.js 20 for the agent automatically
```

The agent uses **Claude Sonnet 4.6** for GDScript generation and scene building.

---

## 📁 Repo Structure

```
biblitos/
├── .github/
│   └── workflows/
│       └── copilot-setup-steps.yml
├── assets/
│   ├── characters/
│   │   ├── noah.png
│   │   ├── lion.png
│   │   ├── elephant.png
│   │   ├── giraffe.png
│   │   ├── dove.png
│   │   └── sheep.png
│   ├── backgrounds/
│   │   ├── storm.png
│   │   └── rainbow.png
│   ├── props/
│   │   └── ark.png
│   └── audio/
│       └── (TTS .mp3 files — generated, not committed)
├── scenes/
│   ├── main.tscn
│   ├── world_noah_exterior.tscn
│   ├── world_noah_interior.tscn
│   └── ui/
├── scripts/
│   ├── animals/
│   ├── scenes/
│   └── audio/
├── pipeline/
│   └── generate_audio.py     ← Gemini TTS script
├── project.godot
├── package.json
├── README.md
├── BIBLITOS_MasterPlan.md
└── BIBLITOS_HandoffDoc.md
```


## 📄 Documentation

- [`BIBLITOS_MasterPlan.md`](./BIBLITOS_MasterPlan.md) — Full technical game plan, roadmap, and build schedule
- [`BIBLITOS_HandoffDoc.md`](./BIBLITOS_HandoffDoc.md) — Vision, purpose, and partnership document

---

## 🙏 Philosophy

> *"God's Word should be the air a child breathes — not a subject they study."*

Five non-negotiables that guide every design decision:

1. **Freedom over direction** — the child always leads
2. **Word as environment** — Scripture is present naturally, never forced
3. **Audio-first** — zero text on screen, accessible to every child regardless of literacy
4. **Delight without manipulation** — no streaks, timers, lives, or loot boxes. Ever.
5. **Consistent beauty** — children and God's Word deserve the best craftsmanship

---

## 📜 License

Ministry-first project. All rights reserved. Contact for partnership and licensing inquiries.

---

*Built with prayer, purpose, and a calling to plant God's Word in the next generation.*
