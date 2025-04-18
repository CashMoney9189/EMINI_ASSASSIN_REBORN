//+------------------------------------------------------------------+
//|                                               EMINI_ASSASSIN.mq5 |
//|                                       COWENFUNDING SERVICES, LLC |
//|                                             HTTPS://WWW.COWEN.TV |
//+------------------------------------------------------------------+
#property copyright "COWENFUNDING SERVICES, LLC"
#property link      "HTTPS://WWW.COWEN.TV"
#property version   "1.00"
#property strict
#property version "1.00"
#property description "EMINI_ASSASSIN | DOM-based Kill Engine — Real-time Signals & Logging"

#define MAX_SNAPSHOTS 500
#define MAX_SIGNAL_EVENTS 100


int OnInit()
{
   MarketBookAdd(_Symbol);
   EventSetTimer(1);
   return INIT_SUCCEEDED;
}

void OnDeinit(const int reason)
{
   EventKillTimer();
   MarketBookRelease(_Symbol);
}

void OnTimer()
{
   MqlBookInfo book[];
   if(!MarketBookGet(_Symbol, book)) return;

   StoreDOMSnapshot(book);
   if(dom_head < 50) return; // Warm-up buffer

   double bid, ask;
   long bidVol, askVol;
   ExtractTopOfBook(book, bid, bidVol, ask, askVol);

   int idx     = (dom_head - 1 + MAX_SNAPSHOTS) % MAX_SNAPSHOTS;
   int prevIdx = (dom_head - 2 + MAX_SNAPSHOTS) % MAX_SNAPSHOTS;

   double delta  = GetDeltaBetween(idx, prevIdx);
   long volume   = bidVol + askVol;
   string spoof  = DetectSpoofOrAbsorption();
   string bias   = (delta > 0) ? "UP" : (delta < 0) ? "DOWN" : "NEUTRAL";

   double deltaStd = GetDeltaStdDev(50);
   double avgVol   = GetAverageVolume(50);
   double aggro    = GetAggressionRatio();

   if(MathAbs(delta) > deltaStd * 2.0 && volume > avgVol * 2.0 && aggro > 0.7)
   {
      AddSignalEvent(bid, delta, volume, spoof, bias, true);
   }

   UpdateSignalOutcomes(10);

   string hudText = GetLatestFormattedSignals(5);
   Comment(hudText);
}
