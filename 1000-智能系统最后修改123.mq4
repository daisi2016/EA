//+------------------------------------------------------------------+
//|                                                     周氏网格.mq4 |
//|                                                      QQ 12015821 |
//|                                            http://www.haoib.com/ |
//+------------------------------------------------------------------+
#property copyright "QQ 12015821"
#property link      "http://www.haoib.com/"



static double zeroline = 0;
static double zerolineUP = 0;
static double zerolineDN = 0;
static double zerolot = 0;

string 识别码="";

extern bool 母单对冲	 = true;
extern string Tips21 = "--- true buy --- false sell ---";
extern bool	buy_sell	 = true;
extern double first_lot = 0.1;



extern int	网格移动	 = 0;
extern string Tips0 = "---网格间距点数---";
extern int grid_pip= 10;
extern string Tips10 = "---网格点位差---";
extern int grid_pipc= 0;

extern string Tips1 = "---网格数量---";
extern int grid_num= 20;
extern string Tips11 = "---开关---";
extern bool buystop =true;
extern bool buylimit =false;
extern bool sellstop = false;
extern bool selllimit= false;

extern string Tips13 = "止盈范围-单货币true 全账户false";
extern bool BasketSymbol =false;
extern string Tips12 = "---整体赢损---";
extern int BasketProfit =1000;
extern int BasketStopLoss=10000;
extern string Tips15 = "单向止盈设置";
extern int 多单止盈金额 =0;
extern int 空单止盈金额 =0;
extern string Tips14 = "每单止盈止损点数";
extern double TakeProfitPips =0;
extern double StopLossPips =0;
int i,cnt,got;
int magic1[200],magic2[200],magic3[200],magic4[200];
double price1[200],price2[200],price3[200],price4[200],lotbs[200],lotbl[200],lotss[200],lotsl[200];
double digs;




extern string Tips2 = "---=================-----";
extern int 	buystop1	 = 1;
extern int 	buystop2	 = 1;
extern int 	buystop3	 = 1;
extern int 	buystop4	 = 1;
extern int 	buystop5	 = 1;
extern int 	buystop6	 = 1;
extern int 	buystop7	 = 1;
extern int 	buystop8	 = 1;
extern int 	buystop9	 = 1;
extern int 	buystop10	 = 1;
extern int 	buystop11	 = 1;
extern int 	buystop12	 = 1;
extern int 	buystop13	 = 1;
extern int 	buystop14	 = 1;
extern int 	buystop15	 = 1;
extern int 	buystop16	 = 1;
extern int 	buystop17	 = 1;
extern int 	buystop18	 = 1;
extern int 	buystop19	 = 1;
extern int 	buystop20	 = 1;
extern string Tips3 = "---=================-----";
extern int 	sellstop1	 = 1;
extern int 	sellstop2	 = 1;
extern int 	sellstop3	 = 1;
extern int 	sellstop4	 = 1;
extern int 	sellstop5	 = 1;
extern int 	sellstop6	 = 1;
extern int 	sellstop7	 = 1;
extern int 	sellstop8	 = 1;
extern int 	sellstop9	 = 1;
extern int 	sellstop10	 = 1;
extern int 	sellstop11	 = 1;
extern int 	sellstop12	 = 1;
extern int 	sellstop13	 = 1;
extern int 	sellstop14	 = 1;
extern int 	sellstop15	 = 1;
extern int 	sellstop16	 = 1;
extern int 	sellstop17	 = 1;
extern int 	sellstop18	 = 1;
extern int 	sellstop19	 = 1;
extern int 	sellstop20	 = 1;

extern string Tips4 = "---=================-----";
extern int 	buylimit1	 = 0;
extern int 	buylimit2	 = 0;
extern int 	buylimit3	 = 3;
extern int 	buylimit4	 = 0;
extern int 	buylimit5	 = 0;
extern int 	buylimit6	 = 2;
extern int 	buylimit7	 = 0;
extern int 	buylimit8	 = 0;
extern int 	buylimit9	 = 2;
extern int 	buylimit10	 = 0;
extern int 	buylimit11	 = 0;
extern int 	buylimit12	 = 2;
extern int 	buylimit13	 = 0;
extern int 	buylimit14	 = 0;
extern int 	buylimit15	 = 2;
extern int 	buylimit16	 = 0;
extern int 	buylimit17	 = 0;
extern int 	buylimit18	 = 2;
extern int 	buylimit19	 = 2;
extern int 	buylimit20	 = 2;

extern string Tips5 = "---=================-----";
extern int 	selllimit1	 = 0;
extern int 	selllimit2	 = 0;
extern int 	selllimit3	 = 3;
extern int 	selllimit4	 = 0;
extern int 	selllimit5	 = 0;
extern int 	selllimit6	 = 2;
extern int 	selllimit7	 = 0;
extern int 	selllimit8	 = 0;
extern int 	selllimit9	 = 2;
extern int 	selllimit10	 = 0;
extern int 	selllimit11	 = 0;
extern int 	selllimit12	 = 2;
extern int 	selllimit13	 = 0;
extern int 	selllimit14	 = 0;
extern int 	selllimit15	 =2;
extern int 	selllimit16	 = 0;
extern int 	selllimit17	 = 0;
extern int 	selllimit18	 = 2;
extern int 	selllimit19	 = 2;
extern int 	selllimit20	 = 2;

   int g_file_152,ca;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   if (Digits <= 3) digs = 0.01;
   else digs = 0.0001;

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
  

   if(OrdersTotal()==0)
      {
      g_file_152 = FileOpen("zhou.txt", FILE_CSV|FILE_WRITE);
      FileWrite(g_file_152, "0");
      FileClose(g_file_152);
      }

//----
   int total=OrdersTotal();
   int symtotal;
   for(cnt=total-1;cnt>=0;cnt--)
      {
      OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
      if(OrderSymbol()==Symbol() && OrderComment()==识别码) symtotal++;
      }   

   static int go;
   if(symtotal==0 && first_lot>0)
      {
      if(ObjectFind("##mamPrice")==0) ObjectDelete("##mamPrice"); 
      if(ObjectFind("##mamLot")==0) ObjectDelete("##mamLot"); 
      if(ObjectFind("##zerolineUP")==0) ObjectDelete("##zerolineUP"); 
      if(ObjectFind("##zerolineDN")==0) ObjectDelete("##zerolineDN"); 
      if(母单对冲==true)
         {
         go=-1;
         while(go<0)
            {
            go=OrderSend(Symbol(),OP_BUY,first_lot,Ask,0,0,0,识别码,0,0);
            if(go<0)GetLastError(); 
            Print(go);
            }
         go=-1;
         while(go<0)
            {
            go=OrderSend(Symbol(),OP_SELL,first_lot,Bid,0,0,0,识别码,0,0);
            if(go<0)GetLastError(); 
            Print(go);
            }
         }
       else
         {     
         if(buy_sell == true)
            {
            go=-1;
            while(go<0)
               {
               go=OrderSend(Symbol(),OP_BUY,first_lot,Ask,0,0,0,识别码,0,0);
               if(go<0)GetLastError(); 
               Print(go);
               }
            }   
         if(buy_sell == false)
            {
            go=-1;
            while(go<0)
               {
               go=OrderSend(Symbol(),OP_SELL,first_lot,Bid,0,0,0,识别码,0,0);
               if(go<0)GetLastError(); 
               Print(go);
               }
            }
          }  
      }

   if(go>0) 
      {
      //int otype;
      for(cnt=total-1;cnt>=0;cnt--)
         {
         OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
         if(OrderSymbol()==Symbol() && OrderComment()==识别码) 
            {

            //zeroline=OrderOpenPrice();
            //zerolot=OrderLots();
            //otype=OrderType();
            if(ObjectFind("##mamPrice")==-1)
               {
                  ObjectCreate("##mamPrice",OBJ_TEXT,0,D'2004.10.22 12:30', OrderOpenPrice());  
               }
            if(ObjectFind("##mamLot")==-1)
               {
                  ObjectCreate("##mamLot",OBJ_TEXT,0,D'2004.10.22 12:30', OrderLots());  
               }
            if(ObjectFind("##zerolineUP")==-1)
               {
                  ObjectCreate("##zerolineUP",OBJ_TEXT,0,D'2004.10.22 12:30', OrderOpenPrice());  
               }
            if(ObjectFind("##zerolineDN")==-1)
               {
                  ObjectCreate("##zerolineDN",OBJ_TEXT,0,D'2004.10.22 12:30', OrderOpenPrice());  
               }
            go=0;   
            break;
            }
         }
      }
   zeroline=ObjectGet("##mamPrice",OBJPROP_PRICE1);
   zerolot=ObjectGet("##mamLot",OBJPROP_PRICE1);
   zerolineUP=ObjectGet("##zerolineUP",OBJPROP_PRICE1);
   zerolineDN=ObjectGet("##zerolineDN",OBJPROP_PRICE1);
   //Print("zl",zerolineUP," ",zerolineDN);   
   if(网格移动>0)
      {
      for(i=0;i<grid_num;i++)
         {
         if(Bid > zerolineUP + grid_pip * digs *(i+1+网格移动)) ObjectSet("##zerolineUP",OBJPROP_PRICE1,zerolineUP + grid_pip * digs *(i+1+网格移动));
         if(Ask < zerolineDN - grid_pip * digs *(i+1+网格移动)) ObjectSet("##zerolineDN",OBJPROP_PRICE1,zerolineDN - grid_pip * digs *(i+1+网格移动));
         }
      }
   
   for(i=0;i<grid_num;i++)
      {
      price1[i]=zerolineDN + grid_pip * digs *(i+1);
      price2[i]=zerolineUP - grid_pip * digs *(i+1);
      
      price3[i]=price1[i]+grid_pipc*digs;
      price4[i]=price2[i]-grid_pipc*digs;
      
      magic1[i]=i+10000;
      magic2[i]=i+20000;
      magic3[i]=i+30000;
      magic4[i]=i+40000;
      }
   
lotsl	[	0	]=	selllimit1	*zerolot; 
lotsl	[	1	]=	selllimit2	*zerolot;
lotsl	[	2	]=	selllimit3	*zerolot;
lotsl	[	3	]=	selllimit4	*zerolot;
lotsl	[	4	]=	selllimit5	*zerolot;
lotsl	[	5	]=	selllimit6	*zerolot;
lotsl	[	6	]=	selllimit7	*zerolot;
lotsl	[	7	]=	selllimit8	*zerolot;
lotsl	[	8	]=	selllimit9	*zerolot;
lotsl	[	9	]=	selllimit10	*zerolot;
lotsl	[	10	]=	selllimit11	*zerolot;
lotsl	[	11	]=	selllimit12	*zerolot;
lotsl	[	12	]=	selllimit13	*zerolot;
lotsl	[	13	]=	selllimit14	*zerolot;
lotsl	[	14	]=	selllimit15	*zerolot;
lotsl	[	15	]=	selllimit16	*zerolot;
lotsl	[	16	]=	selllimit17	*zerolot;
lotsl	[	17	]=	selllimit18	*zerolot;
lotsl	[	18	]=	selllimit19	*zerolot;
lotsl	[	19	]=	selllimit20	*zerolot;



lotbl	[	0	]=	buylimit1	*zerolot;
lotbl	[	1	]=	buylimit2	*zerolot;
lotbl	[	2	]=	buylimit3	*zerolot;
lotbl	[	3	]=	buylimit4	*zerolot;
lotbl	[	4	]=	buylimit5	*zerolot;
lotbl	[	5	]=	buylimit6	*zerolot;
lotbl	[	6	]=	buylimit7	*zerolot;
lotbl	[	7	]=	buylimit8	*zerolot;
lotbl	[	8	]=	buylimit9	*zerolot;
lotbl	[	9	]=	buylimit10	*zerolot;
lotbl	[	10	]=	buylimit11	*zerolot;
lotbl	[	11	]=	buylimit12	*zerolot;
lotbl	[	12	]=	buylimit13	*zerolot;
lotbl	[	13	]=	buylimit14	*zerolot;
lotbl	[	14	]=	buylimit15	*zerolot;
lotbl	[	15	]=	buylimit16	*zerolot;
lotbl	[	16	]=	buylimit17	*zerolot;
lotbl	[	17	]=	buylimit18	*zerolot;
lotbl	[	18	]=	buylimit19	*zerolot;
lotsl	[	19	]=	buylimit20	*zerolot;




lotbs	[	0	]=	buystop1	*zerolot;
lotbs	[	1	]=	buystop2	*zerolot;
lotbs	[	2	]=	buystop3	*zerolot;
lotbs	[	3	]=	buystop4	*zerolot;
lotbs	[	4	]=	buystop5	*zerolot;
lotbs	[	5	]=	buystop6	*zerolot;
lotbs	[	6	]=	buystop7	*zerolot;
lotbs	[	7	]=	buystop8	*zerolot;
lotbs	[	8	]=	buystop9	*zerolot;
lotbs	[	9	]=	buystop10	*zerolot;
lotbs	[	10	]=	buystop11	*zerolot;
lotbs	[	11	]=	buystop12	*zerolot;
lotbs	[	12	]=	buystop13	*zerolot;
lotbs	[	13	]=	buystop14	*zerolot;
lotbs	[	14	]=	buystop15	*zerolot;
lotbs	[	15	]=	buystop16	*zerolot;
lotbs	[	16	]=	buystop17	*zerolot;
lotbs	[	17	]=	buystop18	*zerolot;
lotbs	[	18	]=	buystop19	*zerolot;
lotbs	[	19	]=	buystop20	*zerolot;
					 


lotss	[	0	]=	sellstop1	*zerolot;
lotss	[	1	]=	sellstop2	*zerolot;
lotss	[	2	]=	sellstop3	*zerolot;
lotss	[	3	]=	sellstop4	*zerolot;
lotss	[	4	]=	sellstop5	*zerolot;
lotss	[	5	]=	sellstop6	*zerolot;
lotss	[	6	]=	sellstop7	*zerolot;
lotss	[	7	]=	sellstop8	*zerolot;
lotss	[	8	]=	sellstop9	*zerolot;
lotss	[	9	]=	sellstop10	*zerolot;
lotss	[	10	]=	sellstop11	*zerolot;
lotss	[	11	]=	sellstop12	*zerolot;
lotss	[	12	]=	sellstop13	*zerolot;
lotss	[	13	]=	sellstop14	*zerolot;
lotss	[	14	]=	sellstop15	*zerolot;
lotss	[	15	]=	sellstop16	*zerolot;
lotss	[	16	]=	sellstop17	*zerolot;
lotss	[	17	]=	sellstop18	*zerolot;
lotss	[	18	]=	sellstop19	*zerolot;
lotss	[	19	]=	sellstop20	*zerolot;


double stopLv=MarketInfo(Symbol(),MODE_STOPLEVEL) * Point;
int ticket;
//Print(stopLv);
   for(i=0;i<grid_num;i++)
      {
      got=0;
      for(cnt=total-1;cnt>=0;cnt--)
         {
         OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
         if(OrderMagicNumber()==magic1[i] && OrderSymbol()==Symbol())
            {
            got=1;
            break;
            }
         }
      if(got==0 && buystop==true && price1[i] - Ask > stopLv) OrderSend(Symbol(),OP_BUYSTOP,lotbs[i],price3[i],0,0,0,识别码,magic1[i],0);
      //Print("op",OrderOpenPrice()," ",price1[i]);
      if(got==1 && buystop==true && MathAbs(OrderOpenPrice()-price3[i])>0.00001 && OrderType()>OP_SELL) 
         {
         ticket=OrderModify(OrderTicket(),price3[i],0,0,0); 
         if(ticket==0)Print("Error Modify order : ",GetLastError());
         }
      if(got==1 && buystop==false && OrderType()>1) OrderDel(OrderTicket());

      }
   
   for(i=0;i<grid_num ;i++)
      {
      got=0;
      for(cnt=total-1;cnt>=0;cnt--)
         {
         OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
         if(OrderMagicNumber()==magic2[i] && OrderSymbol()==Symbol())
            {
            got=1;
            break;
            }
         }
      if(got==0 && buylimit==true && Bid - price2[i]> stopLv) OrderSend(Symbol(),OP_BUYLIMIT,lotbl[i],price2[i],0,0,0,识别码,magic2[i],0);
      if(got==1 && buylimit==true && MathAbs(OrderOpenPrice()-price2[i])>0.00001 && OrderType()>OP_SELL) OrderModify(OrderTicket(),price2[i],0,0,0); 
      if(got==1 && buylimit==false && OrderType()>1) OrderDel(OrderTicket());
      }
   
   for(i=0;i<grid_num;i++)
      {
      got=0;
      for(cnt=total-1;cnt>=0;cnt--)
         {
         OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
         if(OrderMagicNumber()==magic3[i] && OrderSymbol()==Symbol())
            {
            got=1;
            break;
            }
         }
      if(got==0 && sellstop==true && Bid - price2[i]> stopLv) OrderSend(Symbol(),OP_SELLSTOP,lotss[i],price4[i],0,0,0,识别码,magic3[i],0);
      if(got==1 && sellstop==true && MathAbs(OrderOpenPrice()-price4[i])>0.00001 && OrderType()>OP_SELL) OrderModify(OrderTicket(),price4[i],0,0,0); 
      if(got==1 && sellstop==false && OrderType()>1) OrderDel(OrderTicket());
      } 
   
   for(i=0;i<grid_num;i++)
      {
      got=0;
      for(cnt=total-1;cnt>=0;cnt--)
         {
         OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
         if(OrderMagicNumber()==magic4[i] && OrderSymbol()==Symbol())
            {
            got=1;
            break;
            }
         }
      if(got==0 && selllimit==true && price1[i] - Ask > stopLv) OrderSend(Symbol(),OP_SELLLIMIT,lotsl[i],price1[i],0,0,0,识别码,magic4[i],0);
      if(got==1 && selllimit==true && MathAbs(OrderOpenPrice()-price1[i])>0.00001 && OrderType()>OP_SELL) OrderModify(OrderTicket(),price1[i],0,0,0); 
      if(got==1 && selllimit==false && OrderType()>1) OrderDel(OrderTicket());
      }
   
 
 
 
 
CommentScreen(); 
//止盈
//Print("止盈");
GetBasketProfit(BasketProfit);
//止损
//Print("止损");
GetBasketStopLoss(BasketStopLoss);




g_file_152 = FileOpen("zhou.txt", FILE_CSV|FILE_READ);
   if(g_file_152 < 0) {
     Print("read error");
   }
   else 
   {
      ca = FileReadNumber(g_file_152);
      FileClose(g_file_152);  
   }
if(ca==1)
   {
      CloseBuyOrders();
      CloseSellOrders();
      DelAllOrders();
   }


//单向止盈
GetCurrentBasket单向();

//加止盈单

   if(TakeProfitPips>0)
      {
      for (int cnt=total-1;cnt>=0;cnt--)
         {
           OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
         if(OrderComment()==识别码)
            {
            if(OrderType()==OP_BUY || OrderType()==OP_BUYSTOP || OrderType()==OP_BUYLIMIT)
               {
               if(OrderTakeProfit()!=OrderOpenPrice()+TakeProfitPips*digs) OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),OrderOpenPrice()+TakeProfitPips*digs,0);
               }
            if(OrderType()==OP_SELL || OrderType()==OP_SELLSTOP || OrderType()==OP_SELLLIMIT)
               {
               if(OrderTakeProfit()!=OrderOpenPrice()-TakeProfitPips*digs) OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),OrderOpenPrice()-TakeProfitPips*digs,0);
               }
            }
         }
      }
    else
      {
      for (cnt=total-1;cnt>=0;cnt--)
         {
         OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
         if(OrderComment()==识别码 && OrderTakeProfit()!=0)OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),0,0);
 
         }
      }
//加止损单

   if(StopLossPips>0)
      {
      for (cnt=total-1;cnt>=0;cnt--)
         {
           OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
         if(OrderComment()==识别码)
            {
            if(OrderType()==OP_BUY || OrderType()==OP_BUYSTOP || OrderType()==OP_BUYLIMIT)
               {
               if(OrderTakeProfit()!=OrderOpenPrice()-StopLossPips*digs) OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-StopLossPips*digs,OrderTakeProfit(),0);
               }
            if(OrderType()==OP_SELL || OrderType()==OP_SELLSTOP || OrderType()==OP_SELLLIMIT)
               {
               if(OrderTakeProfit()!=OrderOpenPrice()+StopLossPips*digs) OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+StopLossPips*digs,OrderTakeProfit(),0);
               }
            }
         }
      }
    else
      {
      for (cnt=total-1;cnt>=0;cnt--)
         {
         OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
         if(OrderComment()==识别码 && OrderStopLoss()!=0)OrderModify(OrderTicket(),OrderOpenPrice(),0,OrderTakeProfit(),0);
 
         }
      }
//----
   return(0);
  }
//+------------------------------------------------------------------+


int OrderDel(int ticket)
   {
   bool found=true;
   while(found==true)
      {
      found=false;
      int total=OrdersTotal();
      for (int cnt=total-1;cnt>=0;cnt--)
         {
         OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
         if(OrderTicket()==ticket)
            {
            found=true;
            OrderDelete(ticket);
            }
         }
      }  
   return(0);
   }


int GetBasketProfit(int BasketProfit)
   {
   double CurrentBasket=GetCurrentBasket();
 
   if(CurrentBasket>=BasketProfit)
      {
      g_file_152 = FileOpen("zhou.txt", FILE_CSV|FILE_WRITE);
      FileWrite(g_file_152, "1");
      FileClose(g_file_152);
      CloseBuyOrders();
      CloseSellOrders();
      DelAllOrders();
      return(0);
      }
   } 
int GetBasketStopLoss(int BasketStopLoss)
   {
   double CurrentBasket=GetCurrentBasket();
 
   if(CurrentBasket<=-BasketStopLoss)
      {
      g_file_152 = FileOpen("zhou.txt", FILE_CSV|FILE_WRITE);
      FileWrite(g_file_152, "1");
      FileClose(g_file_152);
      CloseBuyOrders();
      CloseSellOrders();
      DelAllOrders();
      return(0);
      }
   } 
int GetCurrentBasket()
{
  double CurrentBasket=0;
  int total=OrdersTotal();
  for (int cnt=total-1;cnt>=0;cnt--)
  {
    OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
    if(BasketSymbol==true)
    {
      if(OrderSymbol()==Symbol()) CurrentBasket+=OrderProfit();
    }
    else CurrentBasket+=OrderProfit();
 
  }
  return(CurrentBasket);
}

int GetCurrentBasket单向()
{
  double CurrentBasketB,CurrentBasketS;
  int total=OrdersTotal();
  for (int cnt=total-1;cnt>=0;cnt--)
  {
    OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
    if(BasketSymbol==true)
    {
      if(OrderSymbol()==Symbol() && OrderType()==OP_BUY) CurrentBasketB+=OrderProfit();
      if(OrderSymbol()==Symbol() && OrderType()==OP_SELL) CurrentBasketS+=OrderProfit();
    }
    else
    {
      if(OrderType()==OP_BUY) CurrentBasketB+=OrderProfit();
      if(OrderType()==OP_SELL) CurrentBasketS+=OrderProfit();
    }
  }
   if(CurrentBasketB>多单止盈金额 && 多单止盈金额>0)CloseBuyOrders();
   if(CurrentBasketS>空单止盈金额 && 空单止盈金额>0)CloseSellOrders();

  return(0);
}

int CloseBuyOrders()
   {
   int ticket;   
   bool found=true;
   while(found==true)
      {
      found=false;
      int total=OrdersTotal();
      for (int cnt=total-1;cnt>=0;cnt--)
         {
         OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
         if(BasketSymbol==true)
            {
            if(OrderType()==OP_BUY && OrderComment()==识别码 && OrderSymbol()==Symbol())
               {
               found=true;
               ticket=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),3);
               if(ticket==0)Print("Error Closing BUY order : ",GetLastError()); 
               }
            }
         else
            {
            if(OrderType()==OP_BUY && OrderComment()==识别码)
               {
               found=true;
               ticket=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),3);
               if(ticket==0)Print("Error Closing BUY order : ",GetLastError()); 
               }
            }   
         }
      }
   }
//|---------close sell orders
int CloseSellOrders()
   {
   int ticket;  
   bool found=true;
   while(found==true)
      {
      found=false;
      int total=OrdersTotal();
      for (int cnt=total-1;cnt>=0;cnt--)
         {
         OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
         if(BasketSymbol==true)
            {
            if(OrderType()==OP_SELL && OrderComment()==识别码 && OrderSymbol()==Symbol())
               {
               found=true;
               ticket=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),3);
               if(ticket==0) Print("Error Closing SELL order : ",GetLastError()); 
               }
            }
         else
            {
            if(OrderType()==OP_SELL && OrderComment()==识别码)
               {
               found=true;
               ticket=OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),3);
               if(ticket==0) Print("Error Closing SELL order : ",GetLastError()); 
               }
            }   
         }
      }
   } 
int DelAllOrders()
{
   bool found=true;
   while(found==true)
      {
      found=false;
      int total=OrdersTotal();
      int ticket;
      for (int cnt=total-1;cnt>=0;cnt--)
         {
         OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
         if(BasketSymbol==true)
            {
            if(OrderType()>OP_SELL && OrderComment()==识别码 && OrderSymbol()==Symbol())
               {
               found=true;
               ticket=OrderDel(OrderTicket());
               }
            }
         else
            {
            if(OrderType()>OP_SELL && OrderComment()==识别码)
               {
               found=true;
               ticket=OrderDel(OrderTicket());
               }
            }   
         }
      }
}

void CommentScreen()
{
 double selllots,buylots,ALLselllots,ALLbuylots,totalprofit;
//--------------------------------------------------------------------------------------
//Calculate total profit loss and trades and pips
for(int cnt=0; cnt<OrdersTotal(); cnt++) 
   {
   OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES);
 
   if(OrderType()==OP_SELL)
      { 
      if(OrderSymbol()==Symbol()) selllots+=OrderLots();
      ALLselllots+=OrderLots();
      }
   if(OrderType()==OP_BUY)
      { 
      if(OrderSymbol()==Symbol()) buylots+=OrderLots();
      ALLbuylots+=OrderLots();
      }
 
    if(BasketSymbol==true)
    {
      if(OrderSymbol()==Symbol()) totalprofit+=OrderProfit();
    }
    else totalprofit+=OrderProfit();
   }
//--------------------------------------------------------------------------------------

   ObjectCreate("zhou_grid", OBJ_LABEL, 0, 0, 0); 
   ObjectSetText("zhou_grid", "整体止盈: "+ DoubleToStr(BasketProfit,2)+",  当前获利: "+DoubleToStr(totalprofit,2), 12, "黑体", LawnGreen); 
   ObjectSet("zhou_grid", OBJPROP_CORNER, 2); 
   ObjectSet("zhou_grid", OBJPROP_XDISTANCE, 1); 
   ObjectSet("zhou_grid", OBJPROP_YDISTANCE, 1); 
   ObjectCreate("zhou_grid2", OBJ_LABEL, 0, 0, 0); 
   ObjectSetText("zhou_grid2", "多单: "+DoubleToStr(ALLbuylots,2)+",  空单: "+DoubleToStr(ALLselllots,2), 12, "黑体", LawnGreen); 
   ObjectSet("zhou_grid2", OBJPROP_CORNER, 2); 
   ObjectSet("zhou_grid2", OBJPROP_XDISTANCE, 1); 
   ObjectSet("zhou_grid2", OBJPROP_YDISTANCE, 20); 

//--------------------------------------------------------------------------------------
return(0);
}

