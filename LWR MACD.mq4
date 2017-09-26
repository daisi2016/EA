//+------------------------------------------------------------------+
//|                                                     LWR MACD.mq4 |
//|                                             chen_boqiang@163.com |
//|                                                    www.FX520.com |
//+------------------------------------------------------------------+
#property copyright "chen_boqiang@163.com"
#property link      "www.FX520.com"
//---- indicator settings
#property  indicator_separate_window
#property  indicator_buffers 4
#property  indicator_color1  Lime
#property  indicator_color2  White
#property  indicator_color3  Yellow
#property  indicator_color4  Red
//--indicator 外部变量
extern int FastEMA   =18;
extern int SlowEMA   =27;
extern int SignalSMA =9;
//---- indicator buffers
double     LimeBuffer[];
double     WhiteBuffer[];
double     MacdBuffer[];
double     SignalBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {

//---- 设置新型、样式、宽度和颜色为一条指定的显示线。 
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID,4);
   SetIndexStyle(1,DRAW_HISTOGRAM,STYLE_SOLID,4);
   SetIndexStyle(2,DRAW_LINE,STYLE_SOLID,2);
   SetIndexStyle(3,DRAW_LINE,STYLE_SOLID,2);
//---设置精确格式(计数数字在小数点以后)使自定义值直观化。货币对精确价格 为默认值。 指标会添加到图表中。
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS)+1);
//---从给出指标线画出必须开始设置柱数字(从数据开始) 
   SetIndexDrawBegin(0,9);
   SetIndexDrawBegin(1,9);
   SetIndexDrawBegin(3,9);
   
//---- 对于自定义指标预定义的缓冲器绑定全球水平
   SetIndexBuffer(0,LimeBuffer);
   SetIndexBuffer(1,WhiteBuffer); 
   SetIndexBuffer(2,MacdBuffer);
   SetIndexBuffer(3,SignalBuffer);
//---- 函数设置指标水平线输入新型、样式、宽度和颜色输入数据 
   SetLevelStyle(0, 2, White);
   SetLevelValue(0 , 0);
   //----在DataWindow 和tooltip中设置图画线描述
   SetIndexLabel(0,NULL);
   SetIndexLabel(1,NULL);
   SetIndexLabel(2,NULL);
   SetIndexLabel(3,NULL);
   
//---- 设置显示在数据窗口和子窗口中自定义指标的"简称"。 
   IndicatorShortName("LWR MACD("+FastEMA+","+SlowEMA+","+SignalSMA+")");
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
//| 9Squared Oscillator                                              |
//+------------------------------------------------------------------+
int start()
  {
   int    limit;
   int    counted_bars=IndicatorCounted();
   double prev,current;
//---- 检验可能出现错误
   if(counted_bars<0) return(-1);
//---- 最后数的柱将被重数
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
//---- macd counted in the 1-st additional buffer
   for(int i=0; i<limit; i++)
      MacdBuffer[i]=iMA(NULL,0,FastEMA,0,MODE_EMA,PRICE_WEIGHTED,i)-iMA(NULL,0,SlowEMA,0,MODE_EMA,PRICE_WEIGHTED,i);
//---- 用LimeBuffer和WhiteBuffer交换缓冲区的数据
   for(i=0; i<limit; i++)
      SignalBuffer[i]=iMAOnArray(MacdBuffer,Bars,SignalSMA,0,MODE_SMA,i);
   bool up=true;
   for(i=limit-1; i>=0; i--)
     {
      current=MacdBuffer[i];
      prev=MacdBuffer[i+1];
      if(current>prev) up=true;
      if(current<prev) up=false;
      if(!up)
        {
         WhiteBuffer[i]=current;
         LimeBuffer[i]=0.0;
        }
      else
        {
         LimeBuffer[i]=current;
         WhiteBuffer[i]=0.0;
        }
      
     }
//---- done
   return(0);
  }
//+------------------------------------------------------------------+