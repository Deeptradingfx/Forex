//+------------------------------------------------------------------+
//|                                                        ExpNN.mq5 |
//|                                          Copyright 2017, Рэндом. |
//|                                 http://www.investforum.ru/forum/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Рэндом."
#property link      "http://www.investforum.ru/forum/"
#property version   "1.00"
#property script_show_inputs
//--- input parameters
input double   norm=1.0;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
    int limit=32+16;
    MqlRates his[];
    ArrayResize(his,limit);
    CopyRates(Symbol(),Period(),0,limit,his);
    int ot=FileOpen("eval.txt",FILE_WRITE|FILE_ANSI,0);
    for(int i=16;i<limit;i++)
    {
      string d="|features ";
      for(int j=0;j<15;j++)
      {
         
         double delta=(his[i-j].high-his[i-j].low)/norm;
         double delta1=(his[i-j].high-his[i-j-1].high)/norm;
         double delta2=(his[i-j].low-his[i-j-1].low)/norm;
         d=d+DoubleToString(delta,8)+" "+DoubleToString(delta1,8)+" "+DoubleToString(delta2,8)+" ";
      }
      FileWrite(ot,d);
    }
    FileClose(ot);
  }
//+------------------------------------------------------------------+
