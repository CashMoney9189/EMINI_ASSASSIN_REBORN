//+------------------------------------------------------------------+
//|                                              OutputFormatter.mqh |
//|                                       COWENFUNDING SERVICES, LLC |
//|                                             HTTPS://WWW.COWEN.TV |
//+------------------------------------------------------------------+
#property copyright "COWENFUNDING SERVICES, LLC"
#property link      "HTTPS://WWW.COWEN.TV"
#ifndef __OUTPUTFORMATTER_MQH__
#define __OUTPUTFORMATTER_MQH__

string FormatSignalRow(const SignalEvent &e)
{
   return StringFormat("%s | P:%.2f ➜ %.2f | Δ:%.0f ➜ %.0f | V:%d | %s | %s | %s",
                       TimeToString(e.timestamp, TIME_SECONDS),
                       e.price_trigger, e.price_follow,
                       e.delta_trigger, e.delta_follow,
                       e.volume_trigger,
                       e.trend_bias,
                       e.spoof_state,
                       e.outcome_tag);
}

string GetLatestFormattedSignals(int count)
{
   string out = "🔫 EMINI_ASSASSIN — Signal Feed:\n";
   for(int i = 0; i < count; i++)
   {
      int idx = (g_signal_head - 1 - i + MAX_SIGNAL_EVENTS) % MAX_SIGNAL_EVENTS;
      out += FormatSignalRow(g_signals[idx]) + "\n";
   }
   return out;
}

#endif

