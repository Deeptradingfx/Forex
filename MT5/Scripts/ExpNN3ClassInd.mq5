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
input int      ExtDepth=7;
input int      ExtDeviation=5;
input int      ExtBackstep=3;
input int      ATR=14;
input int      MACDFast=12;
input int      MACDSlow=29;
input int      RSI=14;
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
    int h=iCustom(Symbol(),Period(),"Examples\\ZigZag",ExtDepth,ExtDeviation,ExtBackstep);
    double zh[],zl[],z[];
    ArrayResize(zh,limit);
    ArrayResize(zl,limit);
    ArrayResize(z,limit);
    CopyBuffer(h,1,0,limit,zh);
    CopyBuffer(h,2,0,limit,zl);
    CopyBuffer(h,0,0,limit,z);
    int h1=iATR(Symbol(),Period(),ATR);
    double at[];
    ArrayResize(at,limit);
    CopyBuffer(h1,0,0,limit,at);
    int h2=iMACD(Symbol(),Period(),MACDFast,MACDSlow,3,PRICE_MEDIAN);
    double macd[];
    ArrayResize(macd,limit);
    CopyBuffer(h2,0,0,limit,macd);
    int h3=iRSI(Symbol(),Period(),RSI,PRICE_MEDIAN);
    double rsi[];
    ArrayResize(rsi,limit);
    CopyBuffer(h3,0,0,limit,rsi);
    int tr=(int)(limit*Split);
    int ot=FileOpen("train.txt",FILE_WRITE|FILE_ANSI,0);
    int f=1;
    for(int i=10;i<tr;i++)
    {
      string d="|features ";
      for(int j=0;j<10;j++)
      {
         
         double delta=(at[i-j])/norm;
         double delta1=(macd[i-j]+norm)/norm/10;
         double delta2=(rsi[i-j])/norm;
         d=d+DoubleToString(delta,15)+" "+DoubleToString(delta1,15)+" "+DoubleToString(delta2,15)+" ";
      }
      string d1="|labels 0.0 0.0 1.0 0.0";
      if(z[i]>0)
      {
         if(zh[i]>0) d1="|labels 1.0 0.0 0.0 0.0";
         if(zl[i]>0) d1="|labels 0.0 1.0 0.0 0.0";
      }
      d=d+d1;
      FileWrite(ot,d);
    }
    FileClose(ot);
    ot=FileOpen("test.txt",FILE_WRITE|FILE_ANSI,0);
    for(int i=tr;i<limit;i++)
    {
      string d="|features ";
      for(int j=0;j<10;j++)
      {
          
         double delta=(at[i-j])/norm;
         double delta1=(macd[i-j]+norm)/norm/10;
         double delta2=(rsi[i-j])/norm;
         d=d+DoubleToString(delta,15)+" "+DoubleToString(delta1,15)+" "+DoubleToString(delta2,15)+" ";
      }
      string d1="|labels 0.0 0.0 1.0 0.0";
      if(z[i]>0)
      {
         if(zh[i]>0) d1="|labels 1.0 0.0 0.0 0.0";
         if(zl[i]>0) d1="|labels 0.0 1.0 0.0 0.0";
      }
      d=d+d1;
      FileWrite(ot,d);
    }
    FileClose(ot);
  }
//+------------------------------------------------------------------+
