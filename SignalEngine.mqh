//+------------------------------------------------------------------+
//|                                                 SignalEngine.mqh |
//|                                       COWENFUNDING SERVICES, LLC |
//|                                             HTTPS://WWW.COWEN.TV |
//+------------------------------------------------------------------+
#property copyright "COWENFUNDING SERVICES, LLC"
#property link      "HTTPS://WWW.COWEN.TV"
#ifndef __SIGNALENGINE_MQH__
#define __SIGNALENGINE_MQH__

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

SignalEvent g_signals[MAX_SIGNAL_EVENTS];
int g_signal_head = 0;

void AddSignalEvent(double triggerPrice, double delta, long vol, string spoofState, string trendBias, bool tradeExecuted)
{
   SignalEvent e;
   e.timestamp = TimeCurrent();
   e.price_trigger = triggerPrice;
   e.delta_trigger = delta;
   e.volume_trigger = vol;
   e.spoof_state = spoofState;
   e.trend_bias = trendBias;
   e.execution_flag = tradeExecuted;
   e.price_follow = 0;
   e.delta_follow = 0;
   e.outcome_tag = "⏳ PENDING";

   g_signals[g_signal_head] = e;
   g_signal_head = (g_signal_head + 1) % MAX_SIGNAL_EVENTS;

   LogSignalToCSV(e);
}

void UpdateSignalOutcomes(int evalTicks)
{
   for(int i = 0; i < MAX_SIGNAL_EVENTS; i++)
   {
      SignalEvent e = g_signals[i];
      if(e.outcome_tag != "⏳ PENDING") continue;

      int currentIdx = dom_head;
      int evalIdx = (currentIdx - evalTicks + MAX_SNAPSHOTS) % MAX_SNAPSHOTS;

      double evalPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      double evalDelta = GetDeltaBetween(currentIdx, evalIdx);

      e.price_follow = evalPrice;
      e.delta_follow = evalDelta;

      double priceMove = evalPrice - e.price_trigger;
      double deltaMove = evalDelta - e.delta_trigger;

      if(MathAbs(priceMove) < SymbolInfoDouble(_Symbol, SYMBOL_POINT) * 5)
         e.outcome_tag = "💤 DUD_SIGNAL";
      else if(priceMove > 0 && e.trend_bias == "UP")
         e.outcome_tag = e.execution_flag ? "🔫 KILL_CONFIRMED" : "👀 MISSED_KILL";
      else if(priceMove < 0 && e.trend_bias == "DOWN")
         e.outcome_tag = e.execution_flag ? "🔫 KILL_CONFIRMED" : "👀 MISSED_KILL";
      else if(priceMove * deltaMove < 0)
         e.outcome_tag = "🪤 TRAPPED";
      else
         e.outcome_tag = "❌ KILL_ABORTED";

      g_signals[i] = e;
   }
}

void LogSignalToCSV(const SignalEvent &e)
{
   int handle = FileOpen("AssassinLog.csv", FILE_WRITE | FILE_CSV | FILE_ANSI | FILE_SHARE_WRITE);
   if(handle == INVALID_HANDLE)
   {
      Print("💀 Failed to open log file. Error: ", GetLastError());
      return;
   }

   FileSeek(handle, 0, SEEK_END);
   FileWrite(handle,
             TimeToString(e.timestamp, TIME_SECONDS),
             DoubleToString(e.price_trigger, 2),
             DoubleToString(e.price_follow, 2),
             DoubleToString(e.delta_trigger, 0),
             DoubleToString(e.delta_follow, 0),
             (string)e.volume_trigger,
             e.trend_bias,
             e.spoof_state,
             e.outcome_tag);

   FileClose(handle);
}

#endif
