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
input int      NBars=50000;
input double   Split=0.98;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
    int limit=Bars(Symbol(),Period());
    if(limit>NBars) limit=NBars;
    
    MqlRates his[];
    ArrayResize(his,limit);
    CopyRates(Symbol(),Period(),0,limit,his);
    int tr=(int)(limit*Split);
    int ot=FileOpen("train.txt",FILE_WRITE|FILE_ANSI,0);
    for(int i=15;i<tr;i++)
    {
      string d="|features ";
      for(int j=1;j<16;j++)
      {
         double delta=his[i-j].high;
         
         d=d+DoubleToString(delta,Digits())+" ";
      }
      string d1="|labels "+DoubleToString(his[i].high,Digits());
      d=d+d1;
      FileWrite(ot,d);
    }
    FileClose(ot);
    ot=FileOpen("test.txt",FILE_WRITE|FILE_ANSI,0);
    for(int i=tr;i<limit;i++)
    {
      string d="|features ";
      for(int j=1;j<16;j++)
      {
         double delta=his[i-j].high;
         
         d=d+DoubleToString(delta,Digits())+" ";
      }
      string d1="|labels "+DoubleToString(his[i].high,Digits());
      d=d+d1;
      FileWrite(ot,d);
    }
    FileClose(ot);
  }
//+------------------------------------------------------------------+
