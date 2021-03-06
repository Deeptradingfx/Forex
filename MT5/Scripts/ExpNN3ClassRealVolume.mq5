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
    MqlRates his[];
    ArrayResize(his,limit);
    CopyRates(Symbol(),Period(),0,limit,his);
    int tr=(int)(limit*Split);
    int ot=FileOpen("train.txt",FILE_WRITE|FILE_ANSI,0);
    int f=1;
    for(int i=10;i<tr;i++)
    {
      string d="|features ";
      for(int j=0;j<10;j++)
      {
         
         double delta=(his[i-j].high/his[i-j].low)/norm;
         double delta1=(his[i-j].high/his[i-j-1].high/norm);
         double delta2=(his[i-j].low/his[i-j-1].low)/norm;
         double delta3=((double)(his[i-j].real_volume)/(double)(his[i-j-1].real_volume))/norm;
         d=d+DoubleToString(delta,17)+" "+DoubleToString(delta1,17)+" "+DoubleToString(delta2,17)+" "+DoubleToString(delta3,17)+" ";
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
          
         double delta=(his[i-j].high/his[i-j].low)/norm;
         double delta1=(his[i-j].high/his[i-j-1].high/norm);
         double delta2=(his[i-j].low/his[i-j-1].low)/norm;
         double delta3=((double)(his[i-j].real_volume)/(double)(his[i-j-1].real_volume))/norm;
         d=d+DoubleToString(delta,17)+" "+DoubleToString(delta1,17)+" "+DoubleToString(delta2,17)+" "+DoubleToString(delta3,17)+" ";
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
