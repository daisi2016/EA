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
//--indicator �ⲿ����
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

//---- �������͡���ʽ����Ⱥ���ɫΪһ��ָ������ʾ�ߡ� 
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID,4);
   SetIndexStyle(1,DRAW_HISTOGRAM,STYLE_SOLID,4);
   SetIndexStyle(2,DRAW_LINE,STYLE_SOLID,2);
   SetIndexStyle(3,DRAW_LINE,STYLE_SOLID,2);
//---���þ�ȷ��ʽ(����������С�����Ժ�)ʹ�Զ���ֱֵ�ۻ������ҶԾ�ȷ�۸� ΪĬ��ֵ�� ָ�����ӵ�ͼ���С�
   IndicatorDigits(MarketInfo(Symbol(),MODE_DIGITS)+1);
//---�Ӹ���ָ���߻������뿪ʼ����������(�����ݿ�ʼ) 
   SetIndexDrawBegin(0,9);
   SetIndexDrawBegin(1,9);
   SetIndexDrawBegin(3,9);
   
//---- �����Զ���ָ��Ԥ����Ļ�������ȫ��ˮƽ
   SetIndexBuffer(0,LimeBuffer);
   SetIndexBuffer(1,WhiteBuffer); 
   SetIndexBuffer(2,MacdBuffer);
   SetIndexBuffer(3,SignalBuffer);
//---- ��������ָ��ˮƽ���������͡���ʽ����Ⱥ���ɫ�������� 
   SetLevelStyle(0, 2, White);
   SetLevelValue(0 , 0);
   //----��DataWindow ��tooltip������ͼ��������
   SetIndexLabel(0,NULL);
   SetIndexLabel(1,NULL);
   SetIndexLabel(2,NULL);
   SetIndexLabel(3,NULL);
   
//---- ������ʾ�����ݴ��ں��Ӵ������Զ���ָ���"���"�� 
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
//---- ������ܳ��ִ���
   if(counted_bars<0) return(-1);
//---- �����������������
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
//---- macd counted in the 1-st additional buffer
   for(int i=0; i<limit; i++)
      MacdBuffer[i]=iMA(NULL,0,FastEMA,0,MODE_EMA,PRICE_WEIGHTED,i)-iMA(NULL,0,SlowEMA,0,MODE_EMA,PRICE_WEIGHTED,i);
//---- ��LimeBuffer��WhiteBuffer����������������
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