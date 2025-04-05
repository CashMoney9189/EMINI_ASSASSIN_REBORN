---
title: "PROJECT_SUMMARY"
description: "Deep breakdown of the EMINI_ASSASSIN project and all major architectural components."
---

## 🗂️ FILE 2: `PROJECT_SUMMARY.md`

---

### 📌 Project Summary

#### 🧠 Initial Concept
The EA was born from pain — to track **Depth of Market** in real time, find manipulation (spoofing, absorption), and log kill-worthy signals. This isn’t your dad’s RSI crossover system.

---

#### ⚙️ Architecture Breakdown
[ BOOKBURNER / EMINI_ASSASSIN ] ├── DOM Engine (Real-Time Buffer) │ └── TickRecon() ← Dynamic Lookback │ ├── Delta Spike Detection │ ├── Delta Bollinger Band │ ├── Volume Cluster Awareness │ ├── CandleRecon() ← Anchor S/R via candle pivots (TODO) ├── Trend Bias Logic ← Aggression vs Absorption ├── SignalEngine.mqh ← Signal gen, outcome tracking ├── OutputFormatter.mqh ← Chart HUD + CSV logging


---

### 🔄 Evolution Highlights

| Feature                  | Status | Comment |
|--------------------------|--------|---------|
| `TickRecon()`            | ✅     | Dynamic tick lookback, churn detection |
| `DeltaADR()`             | ✅     | ATR for delta |
| `SpoofFlag()`            | ✅     | Basic spoof detection, can expand |
| `Confidence Scoring`     | ❌     | Not implemented (ML future target) |
| `CandleRecon()`          | ❌     | Not built, huge opportunity |
| `GUI`                    | ❌     | Abandoned due to MT5 fuckery |
| `ML Integration`         | 🚧     | CSV logger prepped, but model not trained |

---

### 🧪 Backtest-Ready

- 📈 Signals tracked as `SignalEvent`
- 🧾 Logged to `AssassinLog.csv`
- 🧠 Can be used for future ML training

---

### 💀 Final Assessment
This is not a toy. It’s a **modular DOM weapon**. Reusable, testable, and insane with potential.