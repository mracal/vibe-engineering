# bart-coaching

Bart-style coaching hooks for Claude Code. Provides growth-oriented feedback across three dimensions as you work, with compound reflections that accumulate across sessions.

## What It Does

**During sessions** — Three types of coaching insights appear naturally:
- `* Insight` — Technical depth: why things work, not just how
- `> Systems` — Operational maturity: what breaks under load, what's invisible in prod
- `# Mirror` — Self-awareness: patterns in your behavior (hero-mode, skipped steps, assumptions)

**At session end** — Blocks exit until you write a compound reflection comparing this session's patterns to your growth trajectory. Reflections persist across sessions using usage-based retention.

## Installation

```bash
claude plugin add --local /path/to/bart-coaching
```

## How It Works

Two hooks, minimal context cost (~1,400 tokens total):

| Hook | When | Cost | Purpose |
|------|------|------|---------|
| SessionStart | Once | ~1,200 tokens | Loads coaching context + past reflections |
| Stop | Once at exit | ~200 tokens | Enforces compound reflection before closing |

### Context Safety

- SessionStart output is hard-capped at 1,500 chars for past reflections
- If context is tight, coaching drops silently — work always comes first
- No per-edit hooks. All coaching behavior comes from SessionStart instructions

### Compound Reflections

Reflections use **usage-based retention**:
- Active patterns stay in the reflections file
- Resolved patterns get archived (never deleted)
- Archive is always accessible for revisiting old growth patterns

## Inspired By

Bart's 10-step coaching pipeline from [nosaintsville-agent](https://github.com/ash1794/nosaintsville-agent): validate effort, probe assumptions, detect hero-mode, surface dissent, enforce reflection.
