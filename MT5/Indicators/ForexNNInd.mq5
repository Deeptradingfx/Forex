//+------------------------------------------------------------------+
//|                                                      ForexNN.mq5 |
//|                                           Copyright 2017, Рэндом |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, Рэндом"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_plots   1
//--- plot Sig
#property indicator_label1  "Sig"
#property indicator_type1   DRAW_ARROW
#property indicator_color1  clrYellow
#property indicator_style1  STYLE_SOLID
#property indicator_width1  3
//--- input parameters
input string   ModelName="D:\\Models\\model.cmf";//Полный путь к моделе
input int      NBars=50;
input int      ATR=14;
input int      MACDFast=12;
input int      MACDSlow=29;
input int      RSI=14;
input double   norm=10.0;
input double   Signal=0.5;
input double   NoSignal=0.5;
//--- indicator buffers
#import "ForexEval.dll"
void LoadModel(string s);
void EvalModel(double &inp[], double &out[]);
#import

double         SigBuffer[];
int h1,h2,h3;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexBuffer(0,SigBuffer,INDICATOR_DATA);
//--- setting a code from the Wingdings charset as the property of PLOT_ARROW
   PlotIndexSetInteger(0,PLOT_ARROW,159);
   PlotIndexSetDouble(0,PLOT_EMPTY_VALUE,0.0);
   string s=ModelName;
   LoadModel(s);
   h1=iATR(Symbol(),Period(),ATR);
   h2=iMACD(Symbol(),Period(),MACDFast,MACDSlow,3,PRICE_MEDIAN);
   h3=iRSI(Symbol(),Period(),RSI,PRICE_MEDIAN);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   int limit=NBars;
   if(limit>Bars(Symbol(),Period())-11) limit=Bars(Symbol(),Period())-11;
   ArraySetAsSeries(SigBuffer,true);
   ArraySetAsSeries(high,true);
   ArraySetAsSeries(low,true);
   
   double at[];
   ArrayResize(at,limit);
   CopyBuffer(h1,0,0,limit,at);
   ArraySetAsSeries(at,true);
   double macd[];
   ArrayResize(macd,limit);
   CopyBuffer(h2,0,0,limit,macd);
   ArraySetAsSeries(macd,true);
   double rsi[];
   ArrayResize(rsi,limit);
   CopyBuffer(h3,0,0,limit,rsi);
   ArraySetAsSeries(rsi,true);
   double err=0.0;
   for(int i=1;i<limit;i++)
   {
      double in[30],ot[4];
      int index=0;
      for(int j=0;j<10;j++)
      {
         double delta=(at[i+j])/norm;;
         double delta1=(macd[i+j]+norm)/norm/10;
         double delta2=(rsi[i+j])/norm;
         in[index]=delta;
         in[index+1]=delta1;
         in[index+2]=delta2;
         index=index+3;
      }
      EvalModel(in,ot);
      SigBuffer[i]=0.0;
      if(ot[0]>Signal && ot[1]<NoSignal && ot[2]<NoSignal) SigBuffer[i]=high[i];
      if(ot[0]<NoSignal && ot[1]>Signal && ot[2]<NoSignal) SigBuffer[i]=low[i];
      err=ot[3];
   }
   Comment("Err= ",err);
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
