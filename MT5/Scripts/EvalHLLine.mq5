//+------------------------------------------------------------------+
//|                                                   EvalHLLine.mq5 |
//|                                           Copyright 2017, Рэндом |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Рэндом"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property script_show_inputs
//--- input parameters
input double   norm=1.0;
input double   H=0.00001;
input double   L=0.00001;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   MqlRates his[1];
   CopyRates(Symbol(),Period(),1,1,his);
   ObjectCreate(0,"EvalH"+Symbol()+IntegerToString(Period()),OBJ_HLINE,0,0,his[0].high+H*norm);
   ObjectCreate(0,"EvalL"+Symbol()+IntegerToString(Period()),OBJ_HLINE,0,0,his[0].low+L*norm);
  }
//+------------------------------------------------------------------+
