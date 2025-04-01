//+------------------------------------------------------------------+
//|                                           AbsorptionDetector.mqh |
//|                                       COWENFUNDING SERVICES, LLC |
//|                                             HTTPS://WWW.COWEN.TV |
//+------------------------------------------------------------------+
#property copyright "COWENFUNDING SERVICES, LLC"
#property link      "HTTPS://WWW.COWEN.TV"
#ifndef __ABSORPTION_MQH__
#define __ABSORPTION_MQH__

string DetectSpoofOrAbsorption()
{
   int curr = (dom_head - 1 + MAX_SNAPSHOTS) % MAX_SNAPSHOTS;
   int prev = (dom_head - 2 + MAX_SNAPSHOTS) % MAX_SNAPSHOTS;

   double bidC, askC, bidP, askP;
   long bidVC, askVC, bidVP, askVP;

   ExtractTopOfBook(dom_history[curr].book, bidC, bidVC, askC, askVC);
   ExtractTopOfBook(dom_history[prev].book, bidP, bidVP, askP, askVP);

   long bidDiff = bidVC - bidVP;
   long askDiff = askVC - askVP;

   if(bidDiff < -GetAverageVolume(50) * 0.5 && bidC == bidP) return "SPOOF_BID";
   if(askDiff < -GetAverageVolume(50) * 0.5 && askC == askP) return "SPOOF_ASK";

   long buyerAgg = (askC == askP && askVC < askVP) ? askVP - askVC : 0;
   long sellerAgg = (bidC == bidP && bidVC < bidVP) ? bidVP - bidVC : 0;
   double avgVol = GetAverageVolume(50);

   if(buyerAgg > avgVol * 1.25) return "ABSORB_ASK";
   if(sellerAgg > avgVol * 1.25) return "ABSORB_BID";

   return "NONE";
}

double GetAggressionRatio()
{
   int curr = (dom_head - 1 + MAX_SNAPSHOTS) % MAX_SNAPSHOTS;
   int prev = (dom_head - 2 + MAX_SNAPSHOTS) % MAX_SNAPSHOTS;

   double bidC, askC, bidP, askP;
   long bidVC, askVC, bidVP, askVP;

   ExtractTopOfBook(dom_history[curr].book, bidC, bidVC, askC, askVC);
   ExtractTopOfBook(dom_history[prev].book, bidP, bidVP, askP, askVP);

   long deltaBuy = (askC == askP && askVC < askVP) ? askVP - askVC : 0;
   long deltaSell = (bidC == bidP && bidVC < bidVP) ? bidVP - bidVC : 0;
   long topBook = bidVC + askVC;

   return ((double)(deltaBuy + deltaSell)) / MathMax(topBook, 1);
}

#endif
