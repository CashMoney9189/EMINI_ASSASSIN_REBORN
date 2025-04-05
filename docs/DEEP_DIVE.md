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
