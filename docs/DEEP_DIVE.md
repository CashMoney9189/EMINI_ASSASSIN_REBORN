# 🔍 DEEP DIVE — EMINI_ASSASSIN Internals

This doc walks through internals of each system.

---

## 🧠 DOM Snapshot Engine

**StoreDOMSnapshot()**
- Captures current L2 state into circular buffer
- Respects `MAX_SNAPSHOTS`

**ExtractTopOfBook()**
- Extracts best bid/ask and volumes from snapshot

---

## 📈 TickRecon()

Dynamic tick loop for calculating lookback size. Conditions:

- Break if:
  - Delta > 200
  - cumVol > 1000
  - Price range < 2×SymbolPoint **and** cumVol > 500

---

## 📏 GetAverageDeltaRange()

- Like ATR, but for delta over lookback
- Used to create adaptive thresholds

---

## 🪤 IsChurnZone()

- Detects compression zones
- `avgVol > 50` && `avgDelta < 10`
- Protects against trap zones

---

## 🔫 Signal Tracking

**AddSignalEvent()**
- Stores trigger delta, price, volume
- Sets “⏳ PENDING” tag
- Sends to `LogSignalToCSV()`

**UpdateSignalOutcomes()**
- Evaluates after N ticks
- Calculates price follow-through
- Tags outcomes:
  - 🔫 KILL_CONFIRMED
  - 👀 MISSED_KILL
  - 🪤 TRAPPED
  - ❌ KILL_ABORTED

---

## 🔥 OutputFormatter

- `FormatSignalRow()` → chart-safe string
- `GetLatestFormattedSignals()` → HUD display


PREVIOUS

# 🧠 EMINI_ASSASSIN Deep Dive

## 🎯 Purpose
Expose, track, and log high-confidence signals using DOM-based aggression and spoof detection.

---

## 🔄 TickRecon()

Dynamic lookback based on volatility and range compression.
- Ends early if:
  - Delta spike > 200
  - Total volume > 1000
  - Price stuck in narrow range + vol spike
- Output = tick lookback depth

## 📏 GetAverageDeltaRange()

- Calculates delta ATR (avg delta movement over `n` snapshots)
- Used to qualify spikes vs. noise

## ⚖️ ChurnZone Detection

- Filters dead zones (tight range, low delta, high volume)
- Prevents signals in manipulated no-man's-land

## 💣 Aggression Spike Logic

- Detected if: `|NetDelta| > 1.5 * DeltaADR`
- Volume must also exceed average by 2x

---

## 🧬 Signal Lifecycle

1. **Trigger**: Conditions met, signal created
2. **Logged**: Written to `AssassinLog.csv`
3. **Evaluated**: 10 ticks later for price & delta confirmation
4. **Tagged**: Outcome recorded
   - 🔫 `KILL_CONFIRMED`
   - 👀 `MISSED_KILL`
   - 🪤 `TRAPPED`
   - ❌ `KILL_ABORTED`

## 🔎 Detection Logic

| Concept             | Mechanism                                    |
|---------------------|----------------------------------------------|
| Spoof Detection     | Vanishing volume on top book                 |
| Absorption          | Stalled price despite aggressive volume      |
| Trend Bias          | Delta trend over last 50 ticks               |
| Compression Filter  | Price tight, volume high → suppress signal   |

---

## 🧠 SignalEvent Structure

```mql5
struct SignalEvent {
  datetime timestamp;
  double price_trigger;
  double delta_trigger;
  long volume_trigger;
  string spoof_state;
  string trend_bias;
  bool execution_flag;
  double price_follow;
  double delta_follow;
  string outcome_tag;
};
