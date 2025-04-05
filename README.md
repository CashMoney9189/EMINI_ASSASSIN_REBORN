# EMINI_ASSASSIN

## 🔫 Real-time DOM Signal Engine for MetaTrader 5

This EA tracks Level 2 order book in real-time, detecting:

- 🧠 Spoofing / Absorption
- 📉 Churn Zones
- 📈 Volume Spike Breakouts
- ⚖️ Delta Imbalances

It logs everything to `AssassinLog.csv` and prints kill data directly on your chart HUD via `Comment()`.

---

### 🔧 Setup

1. Copy files to: MQL5/Experts/EMINI_ASSASSIN/


2. Ensure these files are together:
- `EMINI_ASSASSIN.mq5`
- `DOMTracker.mqh`
- `SignalEngine.mqh`
- `AbsorptionDetector.mqh`
- `OutputFormatter.mqh`

3. Compile `EMINI_ASSASSIN.mq5` in MetaEditor

4. Drop on live chart, enable auto-trading (NO TRADES EXECUTED)

5. Monitor:
- HUD output via `Comment()`
- Signal CSV via `MQL5/Files/AssassinLog.csv`

---

### ⚠️ Warning

- **DOES NOT EXECUTE TRADES** — signal logger only
- Not designed for brokers that throttle `MarketBookGet()` API

---

### 📦 Status

| Feature        | Status  |
|----------------|---------|
| DOM Snapshots  | ✅       |
| Delta/Vol Math | ✅       |
| Spoof Flag     | ✅       |
| Kill Logging   | ✅       |
| ML-Ready       | ✅       |
| GUI Panel      | ❌       |

---

> For full breakdown, see `docs/PROJECT_SUMMARY.md`



PREVIOUS 
# 🔫 EMINI_ASSASSIN | MURDEROUS WARLORD EDITION

**A real-time DOM kill engine. No indicators. No fluff. Just pure aggression detection.**

## 🚀 Features

- 🛰 Real-time DOM snapshot buffer
- 🎯 Delta spike detection (dynamic)
- 🧠 Adaptive aggression evaluation
- 📊 Volume breakout confirmation
- 🔍 Spoof/Absorption detection
- 🧾 CSV signal logging (ML-ready)
- 📺 Comment()-based chart HUD (no GUI bullshit)

## 🗂 File Structure

Place these files inside:
/MQL5/Experts/EMINI_ASSASSIN/ ├── EMINI_ASSASSIN.mq5 ├── DOMTracker.mqh ├── AbsorptionDetector.mqh ├── SignalEngine.mqh ├── OutputFormatter.mqh

markdown
Copy
Edit

## 🛠 Setup Instructions

1. Copy all files to `Documents/MQL5/Experts/EMINI_ASSASSIN/`
2. Open `EMINI_ASSASSIN.mq5` in MetaEditor
3. Hit "Compile" (0 errors, 0 warnings or I break fingers)
4. Attach to *any* chart (timeframe irrelevant)
5. Enable AutoTrading
6. Killfeed appears via `Comment()` overlay
7. Logs write to: `MQL5/Files/AssassinLog.csv`

## 🧪 Sample Output

🔫 EMINI_ASSASSIN — Signal Feed: 12:37:01 | P:4085.25 ➜ 4087.00 | Δ:+240 ➜ +310 | V:1450 | UP | SPOOF_ASK | 🔫 KILL_CONFIRMED 12:37:05 | P:4086.75 ➜ 4086.10 | Δ:-180 ➜ -120 | V:1330 | DOWN | NONE | 👀 MISSED_KILL