//+------------------------------------------------------------------+
//|                                                   DOMTracker.mqh |
//|                                       COWENFUNDING SERVICES, LLC |
//|                                             HTTPS://WWW.COWEN.TV |
//+------------------------------------------------------------------+
#property copyright "COWENFUNDING SERVICES, LLC"
#property link      "HTTPS://WWW.COWEN.TV"
#ifndef __DOMTRACKER_MQH__
#define __DOMTRACKER_MQH__

struct DOMSnapshot {
   datetime timestamp;
   MqlBookInfo book[];
};

DOMSnapshot dom_history[MAX_SNAPSHOTS];
int dom_head = 0;

void StoreDOMSnapshot(const MqlBookInfo &book[])
{
   DOMSnapshot snap;
   snap.timestamp = TimeCurrent();
   ArrayResize(snap.book, ArraySize(book));
   for(int i = 0; i < ArraySize(book); i++)
      snap.book[i] = book[i];
   dom_history[dom_head] = snap;
   dom_head = (dom_head + 1) % MAX_SNAPSHOTS;
}

void ExtractTopOfBook(const MqlBookInfo &book[], double &bid, long &bidVol, double &ask, long &askVol)
{
   bid = 0; ask = 0; bidVol = 0; askVol = 0;
   for(int i = 0; i < ArraySize(book); i++)
   {
      if(book[i].type == BOOK_TYPE_BUY && bid == 0)
      {
         bid = book[i].price; bidVol = book[i].volume;
      }
      else if(book[i].type == BOOK_TYPE_SELL && ask == 0)
      {
         ask = book[i].price; askVol = book[i].volume;
      }
      if(bid > 0 && ask > 0) break;
   }
}

double GetDeltaBetween(int currIdx, int prevIdx)
{
   double bidC, askC, bidP, askP;
   long bidVC, askVC, bidVP, askVP;

   ExtractTopOfBook(dom_history[currIdx].book, bidC, bidVC, askC, askVC);
   ExtractTopOfBook(dom_history[prevIdx].book, bidP, bidVP, askP, askVP);

   long buy  = (askC == askP && askVC < askVP) ? askVP - askVC : 0;
   long sell = (bidC == bidP && bidVC < bidVP) ? bidVP - bidVC : 0;
   return (double)(buy - sell);
}

double GetDeltaStdDev(int lookback)
{
   double sum = 0, sq_sum = 0;
   for(int i = 1; i <= lookback; i++)
   {
      int curr = (dom_head - i + MAX_SNAPSHOTS) % MAX_SNAPSHOTS;
      int prev = (dom_head - i - 1 + MAX_SNAPSHOTS) % MAX_SNAPSHOTS;
      double d = GetDeltaBetween(curr, prev);
      sum += d;
      sq_sum += d * d;
   }
   double mean = sum / lookback;
   double variance = (sq_sum / lookback) - (mean * mean);
   return MathSqrt(MathMax(variance, 0.0001));
}

double GetAverageVolume(int lookback)
{
   double sum = 0;
   for(int i = 1; i <= lookback; i++)
   {
      int idx = (dom_head - i + MAX_SNAPSHOTS) % MAX_SNAPSHOTS;
      double bid, ask; long bidVol, askVol;
      ExtractTopOfBook(dom_history[idx].book, bid, bidVol, ask, askVol);
      sum += (double)(bidVol + askVol);
   }
   return sum / lookback;
}

#endif

