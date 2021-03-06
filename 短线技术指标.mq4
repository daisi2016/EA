#property copyright   "daisi"
#property link        "https://github.com/daisi2016"

input double 止盈点数    =50;//盈利50个点
input double 每次开仓手数  =0.1; //每次下单量=01手
input double 移动止损点数  =20; //移动止损=20点 
input double 开仓参考位置 =3; //开仓水平=3点 
input double 平仓参考位置=2; //平仓水平=2点
input int    均线周期 =26; //均线趋势周期=26根K线线
input int 持仓总数=5;//开仓订单数
input int 报价小数点位数（重要）=5;
input int 滑点数=3;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick(void)
  {
 
   double MacdCurrent,MacdPrevious;
   double SignalCurrent,SignalPrevious;//当前信号
   double MaCurrent,MaPrevious;//当前均线、前次均线
   int    cnt,ticket,total;
   double selfPoint;//自定义的Point常量
   
    double TakeProfit;//盈利50个点
    double Lots; //每次下单量=01手
    double TrailingStop  ; //移动止损=30点 
    double MACDOpenLevel ; //开仓水平=3点 
    double MACDCloseLevel; //平仓水平=2点
    int    MATrendPeriod ; //均线趋势周期=26根K线线
    int orderNum;//开仓订单数
    int pricePoint;
    int movePoint;
    
    TakeProfit=止盈点数;
    Lots=每次开仓手数;
    TrailingStop=移动止损点数;
    MACDOpenLevel=开仓参考位置;
   MACDCloseLevel=平仓参考位置;
   MATrendPeriod=均线周期;
   orderNum=持仓总数;
   pricePoint=报价小数点位数（重要）;
   movePoint =滑点数;
    
   Print("判断进场");
   
   if(Bars<100)
     {
      Print("当前信号线少于100,不做交易判断");
      return;
     }
   if(TakeProfit<10)
     {
      Print("止盈点数小于10点，太少不做交易判断");
      return;
     }

   MacdCurrent=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,0);
   MacdPrevious=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_MAIN,1);
   SignalCurrent=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,0);
   SignalPrevious=iMACD(NULL,0,12,26,9,PRICE_CLOSE,MODE_SIGNAL,1);
   MaCurrent=iMA(NULL,0,MATrendPeriod,0,MODE_EMA,PRICE_CLOSE,0);
   MaPrevious=iMA(NULL,0,MATrendPeriod,0,MODE_EMA,PRICE_CLOSE,1);
   if(pricePoint==5){
   selfPoint =Point*10;
   }else{
    selfPoint =Point;
   }

   total=OrdersTotal();
   if(total<orderNum)//总数=仓单统计
     {
      
      if(AccountFreeMargin()<(1700*Lots))
        {
         Print("保证金不足 ",AccountFreeMargin());
         return;
        }
      //多头下单
      //如果（当前MACD<0 且 当前MACD>当前信号 且 前次MACD<前次信号  且 取绝对值(当前MACD)>开仓水平*点 且 当前均线>前次均线）  
      //MACD处于0轴以下(熊市)+MACD与信号形成金叉+MACD的绝对值>MACD开仓水平值*点数+均线上升--(条件：零下金叉+均线上行) 
      if(MacdCurrent<0 && MacdCurrent>SignalCurrent && MacdPrevious<SignalPrevious && 
         MathAbs(MacdCurrent)>(MACDOpenLevel*Point) && MaCurrent>MaPrevious)
        {
       
         ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,movePoint,Ask-TrailingStop*selfPoint,Ask+TakeProfit*selfPoint,"MACD Trader",11012,0,Green);
                 
         // 开仓（当前货币对，多仓，开仓量，卖价，滑点=3，无止损，止赢=卖价+止赢*点，“MACD Trader”，订单号，限挂单=0，绿色箭头显示）
         if(ticket>0)
           {
            if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))
               Print("多单 : ",OrderOpenPrice());
           }
         else
            Print("多单失败: ",GetLastError());
         return;
        }
       //空头下单
      //如果（当前MACD>0 且 当前MACD<当前信号 且 前次MACD>前次信号 且 当前MACD>MACD水平*点 且 当前MAC<前次MA）          
      //MACD处于0轴以上(牛市)+MACD与信号形成死叉+MACD值>MACD开仓水平值*点数+均线下降--(条件：零上死叉+均线下行) 
      if(MacdCurrent>0 && MacdCurrent<SignalCurrent && MacdPrevious>SignalPrevious && 
         MacdCurrent>(MACDOpenLevel*Point) && MaCurrent<MaPrevious)
        {
        // 开仓（当前货币对，空仓，开仓量，买价，滑点=3，无止损，止赢=买价-止赢*点，“MACD Trader”，订单号，限挂单，红色箭头显示）
         ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,movePoint,Bid+TrailingStop*selfPoint,Bid-TakeProfit*selfPoint,"MACD Trader",11012,0,Red);
            
         if(ticket>0)
           {
            if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))
               Print("空单: ",OrderOpenPrice());
           }
         else
            Print("空单失败 : ",GetLastError());
        }
       
      return;
     }
//---平仓判断   
   for(cnt=0;cnt<total;cnt++)
     {
      if(!OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES))
         continue;
      if(OrderType()<=OP_SELL &&   OrderSymbol()==Symbol()) 
        {
         
         if(OrderType()==OP_BUY)
           {
            
            //如果(当前MACD>0 且 当前MACD<当前信号   且 前次MACD>前次信号 且 当前MACD>MACD平仓水平*点)  
            //MACD处于0轴上方+MACD与信号线形成死叉+当前MACD>MACD平仓水平*点
            if(MacdCurrent>0 && MacdCurrent<SignalCurrent && MacdPrevious>SignalPrevious && MacdCurrent>(MACDCloseLevel*Point))
              {
               //平仓(订单索引，订单持仓量，买价，滑点=3，紫罗兰色箭头
               if(!OrderClose(OrderTicket(),OrderLots(),Bid,movePoint,Violet))
                  Print("多单平仓失败 ",GetLastError());
               return;
              }
           
            if(TrailingStop>0)
              {
               if(Bid-OrderOpenPrice()>selfPoint*TrailingStop)//  //如果(买价-订单开仓价>移动止损*点) 
                 {
                  if(OrderStopLoss()<Bid-selfPoint*TrailingStop)// //如果(订单止损价<买价-移动止损*点) 
                    {
                  
                     ////修改订单(订单索引，开仓价，买价-移动止损*点，止赢价，限价单，绿色箭头显示)
                     if(!OrderModify(OrderTicket(),OrderOpenPrice(),Bid-selfPoint*TrailingStop,OrderTakeProfit(),0,Green))
                        Print("多单移动止损修改失败 ",GetLastError());
                     return;
                    }
                 }
              }
           }
         else  
           {  
            //如果（当前MACD<0 且 当前MACD>当前信号  且 前次MACD<前次信号 且 MACD与信号线形成金叉 且 取绝对值(当前MACD)>MACD平仓水平*点）  ----MACD处于0轴下方+MACD与信号出现金叉+当前MACD绝对值>MACD平仓点
            if(MacdCurrent<0 && MacdCurrent>SignalCurrent && 
               MacdPrevious<SignalPrevious && MathAbs(MacdCurrent)>(MACDCloseLevel*Point))
              {
               
               if(!OrderClose(OrderTicket(),OrderLots(),Ask,movePoint,Violet))
                  Print("空单平仓失败 ",GetLastError());
               return;
              }
          
            //空头移动止损
            if(TrailingStop>0)
              {
               if((OrderOpenPrice()-Ask)>(selfPoint*TrailingStop))
                //如果(订单开仓价-买价>移动止损*点)
                 {
                  if((OrderStopLoss()>(Ask+selfPoint*TrailingStop)) || (OrderStopLoss()==0))
                  //如果(订单止损价>买价+移动止损*点 或 订单止损=0)  ----订单止损=0,代表不设止损价
                    {
                    if(!OrderModify(OrderTicket(),OrderOpenPrice(),Ask+selfPoint*TrailingStop,OrderTakeProfit(),0,Red))
                     //修改订单(订单编号，开仓价，买价+移动止损*P，止赢，限价单，红色箭头显示) 
                        Print("空单移动止损修改失败 ",GetLastError());
                     return;
                    }
                 }
              }
           }
        }
     }

  }
