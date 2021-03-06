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
input double   norm=10.0;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
    int limit=Bars(Symbol(),Period());
    if(limit>NBars) limit=NBars;
    int h=iFractals(Symbol(),Period());
    double zh[],zl[];
    ArrayResize(zh,limit);
    ArrayResize(zl,limit);
    
    CopyBuffer(h,0,0,limit,zh);
    CopyBuffer(h,1,0,limit,zl);
    
    MqlRates his[];
    ArrayResize(his,limit);
    CopyRates(Symbol(),Period(),0,limit,his);
    int tr=(int)(limit*Split);
    int ot=FileOpen("train.txt",FILE_WRITE|FILE_ANSI,0);
    for(int i=20;i<tr;i++)
    {
      string d="|features ";
      for(int j=0;j<20;j++)
      {
         
         double delta=(his[i-j].high/his[i-j].low)/norm;
         double delta1=(his[i-j].high/his[i-j-1].high)/norm;
         double delta2=(his[i-j].low/his[i-j-1].low)/norm;
         d=d+DoubleToString(delta,12)+" "+DoubleToString(delta1,12)+" "+DoubleToString(delta2,12)+" ";
      }
      string d1="|labels 1:1";
      
         if(zh[i]!=EMPTY_VALUE) d1="|labels 2:1";
         if(zl[i]!=EMPTY_VALUE) d1="|labels 3:1";
      
      d=d+d1;
      FileWrite(ot,d);
    }
    FileClose(ot);
    ot=FileOpen("test.txt",FILE_WRITE|FILE_ANSI,0);
    for(int i=tr;i<limit;i++)
    {
      string d="|features ";
      for(int j=0;j<20;j++)
      {
          
         double delta=(his[i-j].high/his[i-j].low)/norm;
         double delta1=(his[i-j].high/his[i-j-1].high)/norm;
         double delta2=(his[i-j].low/his[i-j-1].low)/norm;
         d=d+DoubleToString(delta,12)+" "+DoubleToString(delta1,12)+" "+DoubleToString(delta2,12)+" ";
      }
      
       string d1="|labels 1:1";
      
         if(zh[i]!=EMPTY_VALUE) d1="|labels 2:1";
         if(zl[i]!=EMPTY_VALUE) d1="|labels 3:1";
      d=d+d1;
      FileWrite(ot,d);
    }
    FileClose(ot);
  }
//+------------------------------------------------------------------+
