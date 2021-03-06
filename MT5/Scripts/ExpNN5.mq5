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
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

void OnStart()
  {
//---
    int limit=Bars(Symbol(),Period());
    if(limit>NBars) limit=NBars;
    int h=iCustom(Symbol(),Period(),"Examples\\ZigZag",ExtDepth,ExtDeviation,ExtBackstep);
    double zh[],zl[];
    ArrayResize(zh,limit);
    ArrayResize(zl,limit);
    CopyBuffer(h,1,0,limit,zh);
    CopyBuffer(h,2,0,limit,zl);
    MqlRates his[];
    ArrayResize(his,limit);
    CopyRates(Symbol(),Period(),0,limit,his);
    double rez[],rez1[];
    ArrayResize(rez,limit*2);
    ArrayResize(rez1,limit*2);
    int index=0;
    for(int i=0;i<limit;i++)
    {
      rez1[index]=his[i].high;
      rez1[index+1]=his[i].low;
      index=index+2;
    }
    double dd1=0.0;
    double dd2=1.0;
    double x_min=rez1[ArrayMinimum(rez1)];
    double x_max=rez1[ArrayMaximum(rez1)];
    for(int i=0;i<ArraySize(rez1);i++)
    {
      rez[i]=(((rez1[i]-x_min)*(dd2-dd1))/(x_max-x_min))+dd1;
    }
    int tr=(int)(limit*Split);
    int ot=FileOpen("train.txt",FILE_WRITE|FILE_ANSI,0);
    for(int i=30;i<tr*2;i=i+2)
    {
      string d="|features ";
      for(int j=0;j<15;j++)
      {
         double delta=(rez[i-j]-rez[i-j+1]);
         double delta1=(rez[i-j]-rez[i-j-2]);
         double delta2=(rez[i-j+1]-rez[i-j-2]);
         d=d+DoubleToString(delta,8)+" "+DoubleToString(delta1,8)+" "+DoubleToString(delta2,8)+" ";
      }
      string d1="|labels 0.0 0.0 1.0";
      if(zh[i/2]>0) d1="|labels 1.0 0.0 0.0";
      if(zl[i/2]>0) d1="|labels 0.0 1.0 0.0";
      d=d+d1;
      FileWrite(ot,d);
    }
    FileClose(ot);
    ot=FileOpen("test.txt",FILE_WRITE|FILE_ANSI,0);
    for(int i=tr*2;i<limit*2;i=i+2)
    {
      string d="|features ";
      for(int j=0;j<15;j++)
      {
         double delta=(rez[i-j]-rez[i-j+1]);
         double delta1=(rez[i-j]-rez[i-j-2]);
         double delta2=(rez[i-j+1]-rez[i-j-2]);
         d=d+DoubleToString(delta,8)+" "+DoubleToString(delta1,8)+" "+DoubleToString(delta2,8)+" ";
      }
      string d1="|labels 0.0 0.0 1.0";
      if(zh[i/2]>0) d1="|labels 1.0 0.0 0.0";
      if(zl[i/2]>0) d1="|labels 0.0 1.0 0.0";
      d=d+d1;
      FileWrite(ot,d);
    }
    FileClose(ot);
  }
//+------------------------------------------------------------------+
