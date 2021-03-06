//+------------------------------------------------------------------+
//|                                                    MA Trader.mq4 |
//|                                                            daisi |
//|                                     https://github.com/daisi2016 |
//1.以一条均线为趋势线
//2.斜率大于0为多，斜率小于0为空
//3.k线穿越趋势线时开仓或平仓，趋势转折点上开仓或平仓
//4.趋势中K线偏离均线达到一个值则平仓，K线靠近趋势线时开仓，
//5.以趋势线斜率正负判断多或者空，为零时不做依据，以日线级别为时间单位。类似3
//6.暂时以40均线为参数。
//7.开仓就按固定手数
//8.止损安固定点数或者比例，，盈利超过100点或者一个固定点数，将止损提高到开仓价位或以上，避免盈利了之后亏损出场
//+------------------------------------------------------------------+
#property copyright "daisi"
#property link      "https://github.com/daisi2016"
#property version   "1.10"
#define MAGICMA  20178888
#define SIGNAL_BAR 1

input double 止盈点数    =100;//盈利100个点
input double 每次开仓手数  =0.1; //每次下单量=01手
input double 移动止损点数  =100; //移动止损=30点 

input int    boll中轨 =20; //均线趋势周期40根K线线
input int    均线周期 =40; //均线趋势周期40根K线线
input int    趋势信号柱 =10; //均线趋势周期40根K线线
input int 报价小数点位数（重要）=5;
input int 滑点数=3;

 
  void OnTick(){
  if(CalculateCurrentOrders(Symbol())>0){
 // Print("有持仓,监测平仓条件");
  CheckForClose();
  }else{
 // Print("无持仓,监测开仓条件");
  CheckForOpen();
  }
   
  }
  
  int CalculateCurrentOrders(string symbol)
  {
   int buys=0,sells=0;
   int num=0;

   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MAGICMA)
        {
         num++;
         if(OrderType()==OP_BUY)  buys++;
         if(OrderType()==OP_SELL) sells++;
        }
     }

   //if(buys>0) return(buys);
   //else       return(-sells);
   return num;
   
   

}

  
  
  //http://www.codeforge.cn/article/202360
  
  int jugeRake(){//判断斜率

  int MATrendPeriod=均线周期;
  

double angle;
double ma40 = iMA(NULL,0,MATrendPeriod,0,MODE_EMA,PRICE_CLOSE,MATrendPeriod);
double ma0 = iMA(NULL,0,MATrendPeriod,0,MODE_EMA,PRICE_CLOSE,1);
double ma1 = iMA(NULL,0,MATrendPeriod,0,MODE_EMA,PRICE_CLOSE,2);

 int indexHight = iHighest(Symbol(),0,MODE_HIGH,40,0);
 double hight= High[indexHight];
 
  int lowIndex = iLowest(Symbol(),0,MODE_HIGH,40,0);
 double low= Low[lowIndex];

//angle = MathArctan(MathTan(((ma40-ma0)/(hight- low))/((MATrendPeriod-0)*1.000/40)))*180/3.14;
 //Print("angle0: ",angle);
 
 //double a0=MathArctan((ma0/ma1-1)*100)*180/3.1416;
 angle=(MathTan((ma0/ma1-1)*100))*180/3.1416;

//Print("angle1: ",a0);
//Print("angle2: ",angle);

//if(MathAbs(angle)>=1){

  
  if(angle>0){
  return  1;
   }
   if(angle<0){
      return 0;
   }
  // } 
   return -1;
   
   
  } 
  int macdRiseOpen(int index){
   
     double macd0,macd1;
     int count=0;
    
    for(int i=1;i<index;i++){
     macd0=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,i);
      macd1=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,i+1);
      if(i==1&&macd0>macd1){
      count++;
      }
      
      if(i!=1){
         if(macd1>macd0){
         count++;
         }
      }
    }
   
    if(count==index-1){
    return 1;
    }
    
    return 0;
 
  }
  int macdRiseClose(int index){
     double macd0,macd1;
     int count=0;
      
  
    for(int i=1;i<index;i++){
     macd0=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,i);
      macd1=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,i+1);
      if(i==1&&macd0<macd1){
      count++;
      }
      
      if(i!=1){
         if(macd1<macd0){
         count++;
         }
      }
    }
   
    if(count==index-1){
    return 1;
    }
   
    return 0;
  
  }
  
  int macdDeclineOpen(int index){
 
    
     double macd0,macd1;
     int count=0;
      
  
    for(int i=1;i<index;i++){
     macd0=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,i);
      macd1=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,i+1);
      if(i==1&&macd0>0&&macd1>0&&macd0<macd1){
      count++;
      }
      
      if(i!=1){
         if(macd1<macd0){
         count++;
         }
      }
    }
   
    if(count==index-1){
    return 1;
    }
   
    return 0;
  
  } 
  
  int macdDeclineClose(int index){
  
     double macd0,macd1;
     int count=0;
    
    for(int i=1;i<index;i++){
     macd0=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,i);
      macd1=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,i+1);
      if(i==1&&macd0>macd1){
      count++;
      }
      
      if(i!=1){
         if(macd1>macd0){
         count++;
         }
      }
    }
   
    if(count==index-1){
    return 1;
    }
    
    return 0;
    
  } 
    
     int throughRiseMA( int MATrendPeriod,int index){//上穿均线
  double ma20;
  ma20=iMA(NULL,0,MATrendPeriod,0,MODE_SMA,PRICE_CLOSE,index);
  if(Open[index]<ma20 && Close[index]>ma20) return 1;
  if(Open[index+1]<ma20 && Close[index+1]<=ma20&&Open[index]>=ma20 && Close[index]>ma20)return 1;
  return 0;
 
 }
  int throughDeclineMA( int MATrendPeriod,int index){//下穿均线
   double ma20;
  ma20=iMA(NULL,0,MATrendPeriod,0,MODE_SMA,PRICE_CLOSE,2);
  if(Open[index]>ma20 && Close[index]<ma20) return 1;
  if(Open[index+1]>ma20 && Close[index+1]>=ma20&&Open[index]<=ma20 && Close[index]<ma20)return 1;
  return 0;
 }
    
 
 
 int bollAbove(int number){//boll上轨
 int count=0;
 double close,ma;
 for(int i=3;i<=(2+number);i++){
 close = Close[i];
 ma = iMA(NULL,0,boll中轨,0,MODE_SMA,PRICE_CLOSE,i);
 if(close>ma)count++;
 }
 if(count>=number*0.8)return 1;
 //if(count==number)return 1;
 return 0;
 
 
 }
 int bollBelow(int number){//boll下轨
 
 int count=0;
 double close,ma;
 for(int i=3;i<=(2+number);i++){
 close = Close[i];
 ma = iMA(NULL,0,boll中轨,0,MODE_SMA,PRICE_CLOSE,i);
 if(close<ma)count++;
 }
 // if(count==number)return 1;
 if(count>=number*0.8)return 1;
 
 return 0;
 }
 
 

 

  
 
 void CheckForOpen()//开仓
  {
  
   double ma0,ma,ma20,ma202;
    int    res;
    int MATrendPeriod;
    double selfPoint;//自定义的Point常量
    double TakeProfit;//盈利50个点
    double Lots; //每次下单量=01手
    double TrailingStop  ; //移动止损=30点 
    int pricePoint;
    int movePoint;
    
    MATrendPeriod=均线周期;
     TakeProfit=止盈点数;
    Lots=每次开仓手数;
    TrailingStop=移动止损点数;
    pricePoint=报价小数点位数（重要）;
    movePoint =滑点数;
    if(pricePoint==5){
   selfPoint =Point*10;
   }else{
    selfPoint =Point;
   }
    ma0=iMA(NULL,0,MATrendPeriod,0,MODE_SMA,PRICE_CLOSE,0);
   ma=iMA(NULL,0,MATrendPeriod,0,MODE_SMA,PRICE_CLOSE,1);
   ma20=iMA(NULL,0,20,0,MODE_SMA,PRICE_CLOSE,1);
   ma202=iMA(NULL,0,20,0,MODE_SMA,PRICE_CLOSE,2);
   
  //  if((throughRiseMA(20)==1&&bollBelow(5)==1&&Close[1]>ma20&&jugeRake()==1))
  //if((throughRiseMA(boll中轨,2)==1&&bollBelow(5)==1&&(Close[1]-Open[1])>0&&Close[1]>ma20&&(Open[0]>Close[1])&&macdRiseClose(5)!=1))
   if(macdRiseOpen(趋势信号柱)==1)
   
     {
    // Print("BUY:ma:",ma,"Open[1]:",Open[1],"Close[1]:",Close[1],"jugeRake():",jugeRake(),"jugeNear():",jugeNear(Ask));
      //Ask+TakeProfit*selfPoint
      res=OrderSend(Symbol(),OP_BUY,Lots,Ask,movePoint,Ask-TrailingStop*selfPoint,0,"MA Trader",MAGICMA,0,Red);
      return;
     }
     
//if((throughDeclineMA(boll中轨)==1&&bollAbove(5)==1&&Close[1]<Close[2]&&jugeRake()==0))
//if((throughDeclineMA(boll中轨,2)==1&&bollAbove(5)==1&&(Close[1]-Open[1])<0&&Close[1]<ma20&&(Open[0]<Close[1])&&macdDeclineClose(5)!=1))
      if(macdDeclineOpen(趋势信号柱)==1)
    
     {
    //Bid-TakeProfit*selfPoint
      res=OrderSend(Symbol(),OP_SELL,Lots,Bid,movePoint,Bid+TrailingStop*selfPoint,0,"MA Trader",MAGICMA,0,Green);
      return;
     }
 

  }
  
  void CheckForClose()
  {
   double ma,ma1,ma20,ma10;
    int MATrendPeriod;
    double selfPoint;//自定义的Point常量
    double TakeProfit;//盈利50个点
    double Lots; //每次下单量=01手
    double TrailingStop  ; //移动止损=30点 
    int pricePoint;
    int movePoint;
    
    MATrendPeriod=均线周期;
    TakeProfit=止盈点数;
    Lots=每次开仓手数;
    TrailingStop=移动止损点数;
    pricePoint=报价小数点位数（重要）;
    movePoint =滑点数;
    if(pricePoint==5){
      selfPoint =Point*10;
    }else{
      selfPoint =Point;
     }

   ma=iMA(NULL,0,MATrendPeriod,0,MODE_SMA,PRICE_CLOSE,0);
   ma1=iMA(NULL,0,MATrendPeriod,0,MODE_SMA,PRICE_CLOSE,1);
   ma20=iMA(NULL,0,20,0,MODE_SMA,PRICE_CLOSE,1);
   ma10=iMA(NULL,0,10,0,MODE_SMA,PRICE_CLOSE,1);

   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderMagicNumber()!=MAGICMA || OrderSymbol()!=Symbol()) continue;
     
      if(OrderType()==OP_BUY)
        {
         // if((Open[1]>ma1 && Close[1]<ma1&&jugeRake()==1&&macdDC()==1))
         // if(throughDeclineMA(20)==1||throughDeclineMA(40)==1||throughDeclineMA(10)==1||priceThroughDeclineMA(Bid,20))
         // if(throughDeclineMAClose(20)==1||macdRiseClose(5)==1)
           if(macdRiseClose(趋势信号柱)==1||throughDeclineMA(20,1)==1)
           {
             //Print("buy close:ma20:",ma20,"Open[1]:",Open[1],"Close[1]:",Close[1],"jugeRake:",jugeRake());
            if(!OrderClose(OrderTicket(),OrderLots(),Bid,movePoint,Violet))
               Print("多单平仓失败 ",GetLastError());
           }else{
            
                //if((Bid-OrderOpenPrice())>selfPoint*TrailingStop)//  //如果(买价-订单开仓价>移动止损*点) 
                // {
                 
                  if(OrderStopLoss()<Bid-selfPoint*TrailingStop&& ((Bid-selfPoint*TrailingStop)<=OrderOpenPrice()))// //如果(订单止损价<买价-移动止损*点) 
                    {
                  
                     ////修改订单(订单索引，开仓价，买价-移动止损*点，止赢价，限价单，绿色箭头显示)
                     //Bid+TakeProfit*selfPoint
                     // if(!OrderModify(OrderTicket(),OrderOpenPrice(),Bid-selfPoint*TrailingStop,Bid+TakeProfit*selfPoint,0,Blue))
                    
                     if(!OrderModify(OrderTicket(),OrderOpenPrice(),Bid-selfPoint*TrailingStop,0,0,Blue))
                            Print("多单移动止损修改失败 ",GetLastError());
                       
                   
                    }
               //  } 
           }
         break;
        }
      if(OrderType()==OP_SELL)
        {
      // if((Open[1]<ma20 && Close[1]>ma20&&jugeRake()==0&&macdGC()==1))
       //if(throughRiseMA(20)==1||throughRiseMA(40)==1||throughRiseMA(10)==1||priceThroughRiseMA(Ask,20))
   //  if(throughRiseMAClose(20)==1||macdDeclineClose(5)==1)
        if(macdDeclineClose(趋势信号柱)==1||throughRiseMA(20,1)==1)
           {
            //Print("sell close:ma20:",ma20,"Open[1]:",Open[1],"Close[1]:",Close[1],"jugeRake:",jugeRake());
            if(!OrderClose(OrderTicket(),OrderLots(),Ask,movePoint,Violet))
               Print("空单平仓失败 ",GetLastError());
           }else{
          
            //if((OrderOpenPrice()-Ask)>(selfPoint*TrailingStop))
                //如果(订单开仓价-买价>移动止损*点)
                 //{
                  
                  if((OrderStopLoss()>(Ask+selfPoint*TrailingStop)) && (Ask+selfPoint*TrailingStop>=OrderOpenPrice()))
                  //如果(订单止损价>买价+移动止损*点 或 订单止损=0)  ----订单止损=0,代表不设止损价
                    {
                    //if(!OrderModify(OrderTicket(),OrderOpenPrice(),Ask+selfPoint*TrailingStop,Ask-TakeProfit*selfPoint,0,Blue))
                   
                    if(!OrderModify(OrderTicket(),OrderOpenPrice(),Ask+selfPoint*TrailingStop,0,0,Blue))
                     //修改订单(订单编号，开仓价，买价+移动止损*P，止赢，限价单，红色箭头显示) 
                           Print("空单移动止损修改失败 ",GetLastError());
                  
                    }
                // }
           
           }
         break;
        }
     }

  }