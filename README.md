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