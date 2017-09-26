/*
   G e n e r a t e d  by ex4-to-mq4 decompiler LITE 4.0.500.3
   E-mail : Pu R e B EAM@ G MA Il .Com
*/

extern double 第一单挂单价格 = 0.0;
extern int 第一单挂单有效分钟数 = 720;
extern bool buyORsell = TRUE;
extern double lots1 = 0.01;
extern double maxlots = 10.0;
extern double beishu = 2.0;
extern double StopLoss = 30.0;
extern double TakeProfit = 50.0;
extern datetime OpenTime = 0;
extern int OpenVolume = 0;
extern double KaiShiYiDong = 40.0;
extern double HuiDiao = 10.0;
double Gd_156 = 0.0;
double Gd_164 = 0.0;
string Gsa_172[3];
int Gi_176 = 456235;
int Gi_180 = 1;
int Gi_184 = 50;
int Gi_188 = 1;

// E37F0136AA3FFAF149B351F6A4C948E9
int init() {
   string Ls_0;
   if (ObjectFind("fengxian") < 0) {
      ObjectCreate("fengxian", OBJ_LABEL, 0, 0, 0);
      ObjectSetText("fengxian", "EA交易有风险,小心慎用,模拟盘先测试", 9, "Arial", Yellow);
      ObjectSet("fengxian", OBJPROP_CORNER, 0);
      ObjectSet("fengxian", OBJPROP_XDISTANCE, 15);
      ObjectSet("fengxian", OBJPROP_YDISTANCE, 15);
   } else ObjectSetText("fengxian", "EA交易有风险，小心慎用，先用模拟盘测试", 9, "Arial", Yellow);
   if (StringLen(Symbol()) > 6) Ls_0 = "EURUSD" + StringSubstr(Symbol(), 6, StringLen(Symbol()) - 6);
   else Ls_0 = "EURUSD";
   Print(Ls_0);
   if (MarketInfo(Ls_0, MODE_DIGITS) > 4.0) {
      StopLoss = 10.0 * StopLoss;
      TakeProfit = 10.0 * TakeProfit;
      Gi_184 = 10 * Gi_184;
      KaiShiYiDong = 10.0 * KaiShiYiDong;
      HuiDiao = 10.0 * HuiDiao;
   }
   Gsa_172[0] = AccountNumber();
   Gsa_172[1] = "";
   Gsa_172[2] = AccountCompany();
   return (0);
}
		  	 		  	  	    	  	   	 		  		  		 		   			 		  			    	 	   		 		 		      	 	   	  	   				 		   	 	 	 		  	  	 					  			  	   	  		    			 	 		 		   		    	   				 		  		 
// 52D46093050F38C27267BCE42543EF60
int deinit() {
   return (0);
}
	 	 				 	       	        				 									 				  						    	  		  	 						 		  		 			 		 	 				 	 	 	    	  				 	 	  	 							   			 		 				   		  						 					    	   				 	 			 
// D1DDCE31F1A86B3140880F6B1877CBF8
void f0_12() {
   for (int Li_0 = 0; Li_0 < OrdersTotal(); Li_0++) {
      if (OrderSelect(Li_0, SELECT_BY_POS, MODE_TRADES) == TRUE) {
         if (OrderType() == OP_BUY && OrderSymbol() == Symbol() && OrderMagicNumber() == Gi_176) {
            if (Bid - OrderOpenPrice() >= Point * KaiShiYiDong)
               if (Gd_156 < Bid - OrderOpenPrice()) Gd_156 = Bid - OrderOpenPrice();
         }
         if (OrderType() == OP_SELL && OrderSymbol() == Symbol() && OrderMagicNumber() == Gi_176) {
            if (OrderOpenPrice() - Ask >= Point * KaiShiYiDong)
               if (Gd_164 < OrderOpenPrice() - Ask) Gd_164 = OrderOpenPrice() - Ask;
         }
      }
   }
   for (int Li_4 = 0; Li_4 < OrdersTotal(); Li_4++) {
      if (OrderSelect(Li_4, SELECT_BY_POS, MODE_TRADES) == TRUE) {
         if (OrderType() == OP_BUY && OrderSymbol() == Symbol() && OrderMagicNumber() == Gi_176)
            if (Gd_156 > 0.0 && Bid - OrderOpenPrice() <= Gd_156 - Point * HuiDiao) OrderClose(OrderTicket(), OrderLots(), Bid, 500, Green);
         if (OrderType() == OP_SELL && OrderSymbol() == Symbol() && OrderMagicNumber() == Gi_176)
            if (Gd_164 > 0.0 && OrderOpenPrice() - Ask <= Gd_164 - Point * HuiDiao) OrderClose(OrderTicket(), OrderLots(), Ask, 500, Green);
      }
   }
}
		    	   	 		 	  	 		 	 	 	    	  	  	    	 	  	  	 	 	  	    			 	  	     	 			          	 					  		   	 	      	  		 	  	 	 		       	   			  	 	  	    	   	 	  			 	 			 	  
// EA2B2676C28C0DB26D39331A336C6B92
int start() {
   if (f0_11() > 0) Gi_180 = FALSE;
   else {
      Gd_156 = 0;
      Gd_164 = 0;
   }
   if (Gi_180 == FALSE && f0_11() == 0) {
      if (Gi_188 == TRUE) {
         SendMail(Symbol() + "不管涨跌系统已经停止运行", Symbol() + "不管涨跌系统已经停止运行");
         Alert(Symbol() + "不管涨跌系统已经停止运行");
         Gi_188 = FALSE;
      }
   }
   if (Gi_180 && f0_11() == 0) {
      if (第一单挂单价格 == 0.0) {
         if (OpenTime != 0 && TimeLocal() > OpenTime) {
            if (buyORsell == TRUE) {
               if (f0_9(lots1, StopLoss, TakeProfit, Symbol() + "buy", Gi_176) > 0) {
                  Gi_180 = FALSE;
                  Gd_156 = 0;
               }
            } else {
               if (f0_10(lots1, StopLoss, TakeProfit, Symbol() + "sell", Gi_176) > 0) {
                  Gi_180 = FALSE;
                  Gd_164 = 0;
               }
            }
         } else {
            if (OpenTime == 0) {
               if (buyORsell == TRUE) {
                  if (f0_9(lots1, StopLoss, TakeProfit, Symbol() + "buy", Gi_176) > 0) {
                     Gi_180 = FALSE;
                     Gd_156 = 0;
                  }
               } else {
                  if (f0_10(lots1, StopLoss, TakeProfit, Symbol() + "sell", Gi_176) > 0) {
                     Gi_180 = FALSE;
                     Gd_164 = 0;
                  }
               }
            }
         }
      } else {
         if (第一单挂单有效分钟数 <= 10) Alert("第一单挂单有效分钟数不得小于10分钟");
         if (buyORsell == TRUE) {
            if (第一单挂单价格 > Bid) {
               if (f0_3(lots1, StopLoss, TakeProfit, Symbol() + "buy", 第一单挂单价格, Gi_176) > 0) {
                  Gi_180 = FALSE;
                  Gd_156 = 0;
               }
            } else {
               if (f0_8(lots1, StopLoss, TakeProfit, Symbol() + "buy", 第一单挂单价格, Gi_176) > 0) {
                  Gi_180 = FALSE;
                  Gd_156 = 0;
               }
            }
         } else {
            if (第一单挂单价格 > Bid) {
               if (f0_4(lots1, StopLoss, TakeProfit, Symbol() + "sell", 第一单挂单价格, Gi_176) > 0) {
                  Gi_180 = FALSE;
                  Gd_164 = 0;
               }
            } else {
               if (f0_1(lots1, StopLoss, TakeProfit, Symbol() + "sell", 第一单挂单价格, Gi_176) > 0) {
                  Gi_180 = FALSE;
                  Gd_164 = 0;
               }
            }
         }
      }
   }
   double Ld_0 = 0;
   double Ld_8 = 0;
   int Li_16 = f0_2(Ld_0, Ld_8);
   f0_12();
   if (HuiDiao > MarketInfo(Symbol(), MODE_STOPLEVEL)) f0_5();
   if (Li_16 <= 1) {
      if (Li_16 == 0)
         if (f0_0(NormalizeDouble(Ld_0 * beishu, 2), StopLoss, TakeProfit, Symbol() + "sell", Ld_8 - StopLoss * Point, Gi_176) > 0) Gd_164 = 0;
      if (Li_16 == 1)
         if (f0_6(NormalizeDouble(Ld_0 * beishu, 2), StopLoss, TakeProfit, Symbol() + "buy", Ld_8 + StopLoss * Point, Gi_176) > 0) Gd_156 = 0;
   } else {
      if (f0_7() == 1) {
         for (int Li_20 = OrdersTotal() - 1; Li_20 >= 0; Li_20--) {
            if (OrderSelect(Li_20, SELECT_BY_POS, MODE_TRADES)) {
               if (OrderType() > OP_SELL && OrderSymbol() == Symbol() && OrderMagicNumber() == Gi_176)
                  if (OrderLots() > lots1) OrderDelete(OrderTicket());
            }
         }
      }
   }
   return (0);
}
					 		   	 	     	 	   		 	  		 	 	 		  	 		 		 	 		     		   			 	 		  		  	 	 			  	  	 			 				 	 	 		 	  	   						 	 		  	 			  		 		 			 		 	 		  	 	    			 				     		 
// 71B35A2130EFA6AAAE371285C3CF287B
int f0_7() {
   for (int Li_0 = OrdersHistoryTotal() - 1; Li_0 >= 0; Li_0--) {
      if (OrderSelect(Li_0, SELECT_BY_POS, MODE_HISTORY)) {
         if (OrderType() == OP_BUY || OrderType() == OP_SELL && OrderSymbol() == Symbol() && OrderMagicNumber() == Gi_176) {
            if (OrderProfit() >= 0.0) return (1);
            return (0);
         }
      }
   }
   return (0);
}
	 	   				  		  		  		  	 		   	 			  						 	 	 			 	  		        		  					 	 	  		    					 		   	 		 		 		   			   			 			 	   		    	 		 					 		  						    	 	 				 	 		 			
// 31D2585B5C295F7506401FEC18E9A6BB
int f0_2(double &Ad_0, double &Ad_8) {
   int Li_16 = 2;
   Ad_0 = 0;
   Ad_8 = 0;
   for (int Li_20 = OrdersTotal() - 1; Li_20 >= 0; Li_20--) {
      if (OrderSelect(Li_20, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderMagicNumber() == Gi_176) {
            if (OrderSymbol() == Symbol()) {
               Li_16 = OrderType();
               if (OrderLots() * beishu > maxlots) Li_16 = 2;
               Ad_0 = OrderLots();
               Ad_8 = OrderOpenPrice();
               break;
            }
         }
      }
   }
   return (Li_16);
}
		 		 	   		 	 	  		 	 	 	  	   	   	 	     		  	   		 	  			  			  	 	    	  			  		       						 	 	   	  	     					 	   		 		  		   	  	 		  	  	 	     	  	 	 	 		 	 	   	  
// C118BC5D8D4895973C4598B88E701CEF
int f0_11() {
   int Li_0 = 0;
   for (int Li_4 = 0; Li_4 < OrdersTotal(); Li_4++) {
      if (OrderSelect(Li_4, SELECT_BY_POS, MODE_TRADES))
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == Gi_176) Li_0++;
   }
   return (Li_0);
}
		  	 		  	  	    	  	   	 		  		  		 		   			 		  			    	 	   		 		 		      	 	   	  	   				 		   	 	 	 		  	  	 					  			  	   	  		    			 	 		 		   		    	   				 		  		 
// 689C35E4872BA754D7230B8ADAA28E48
void f0_5() {
   for (int Li_0 = 0; Li_0 < OrdersTotal(); Li_0++) {
      if (OrderSelect(Li_0, SELECT_BY_POS, MODE_TRADES) == TRUE) {
         if (OrderType() == OP_BUY && OrderSymbol() == Symbol() && OrderMagicNumber() == Gi_176) {
            if (Bid - OrderOpenPrice() >= Point * KaiShiYiDong)
               if (OrderStopLoss() < Bid - Point * HuiDiao || OrderStopLoss() == 0.0) OrderModify(OrderTicket(), OrderOpenPrice(), Bid - Point * HuiDiao, OrderTakeProfit(), 0, Green);
         }
         if (OrderType() == OP_SELL && OrderSymbol() == Symbol() && OrderMagicNumber() == Gi_176) {
            if (OrderOpenPrice() - Ask >= Point * KaiShiYiDong)
               if (OrderStopLoss() > Ask + Point * HuiDiao || OrderStopLoss() == 0.0) OrderModify(OrderTicket(), OrderOpenPrice(), Ask + Point * HuiDiao, OrderTakeProfit(), 0, Red);
         }
      }
   }
}
	   	 	 			  	 				  	 		  		    	 		 	 		 			   	 			 				 	  	   		 	 		    		 	  	   		 					     	  	  		   			 			  	 			 	 	  	    	   		 	  		 	 		 		  		    		  			  	 	
// 50257C26C4E5E915F022247BABD914FE
int f0_3(double Ad_0, double Ad_8, double Ad_16, string As_24, double Ad_32, int Ai_40) {
   bool Li_44 = FALSE;
   bool Li_48 = FALSE;
   int Li_52 = 0;
   for (int Li_56 = 0; Li_56 < OrdersTotal(); Li_56++) {
      if (OrderSelect(Li_56, SELECT_BY_POS, MODE_TRADES))
         if (OrderComment() == As_24 && OrderSymbol() == Symbol() && OrderMagicNumber() == Ai_40) Li_48 = TRUE;
   }
   if (Li_48 == FALSE) {
      if (Ad_8 != 0.0 && Ad_16 != 0.0) Li_52 = OrderSend(Symbol(), OP_BUYSTOP, Ad_0, Ad_32, 0, Ad_32 - Ad_8 * Point, Ad_32 + Ad_16 * Point, As_24, Ai_40, TimeCurrent() + 60 * 第一单挂单有效分钟数, White);
      if (Ad_8 == 0.0 && Ad_16 != 0.0) Li_52 = OrderSend(Symbol(), OP_BUYSTOP, Ad_0, Ad_32, 0, 0, Ad_32 + Ad_16 * Point, As_24, Ai_40, TimeCurrent() + 60 * 第一单挂单有效分钟数, White);
      if (Ad_8 != 0.0 && Ad_16 == 0.0) Li_52 = OrderSend(Symbol(), OP_BUYSTOP, Ad_0, Ad_32, 0, Ad_32 - Ad_8 * Point, 0, As_24, Ai_40, TimeCurrent() + 60 * 第一单挂单有效分钟数, White);
      if (Ad_8 == 0.0 && Ad_16 == 0.0) Li_52 = OrderSend(Symbol(), OP_BUYSTOP, Ad_0, Ad_32, 0, 0, 0, As_24, Ai_40, TimeCurrent() + 60 * 第一单挂单有效分钟数, White);
      Li_44 = Li_52;
   }
   return (Li_44);
}
	 		  		 	 			   	 			    	    				   		 		  	 				  	   	 	    	 	   		 				 	 				   	 		  		 	 				 	  	    	 	 	 						  	  				   									  	   		 		       								  	 		 
// 2569208C5E61CB15E209FFE323DB48B7
int f0_1(double Ad_0, double Ad_8, double Ad_16, string As_24, double Ad_32, int Ai_40) {
   bool Li_44 = FALSE;
   bool Li_48 = FALSE;
   int Li_52 = 0;
   for (int Li_56 = 0; Li_56 < OrdersTotal(); Li_56++) {
      if (OrderSelect(Li_56, SELECT_BY_POS, MODE_TRADES))
         if (OrderComment() == As_24 && OrderSymbol() == Symbol() && OrderMagicNumber() == Ai_40) Li_48 = TRUE;
   }
   if (Li_48 == FALSE) {
      if (Ad_8 != 0.0 && Ad_16 != 0.0) Li_52 = OrderSend(Symbol(), OP_SELLSTOP, Ad_0, Ad_32, 0, Ad_32 + Ad_8 * Point, Ad_32 - Ad_16 * Point, As_24, Ai_40, TimeCurrent() + 60 * 第一单挂单有效分钟数, Red);
      if (Ad_8 == 0.0 && Ad_16 != 0.0) Li_52 = OrderSend(Symbol(), OP_SELLSTOP, Ad_0, Ad_32, 0, 0, Ad_32 - Ad_16 * Point, As_24, Ai_40, TimeCurrent() + 60 * 第一单挂单有效分钟数, Red);
      if (Ad_8 != 0.0 && Ad_16 == 0.0) Li_52 = OrderSend(Symbol(), OP_SELLSTOP, Ad_0, Ad_32, 0, Ad_32 + Ad_8 * Point, 0, As_24, Ai_40, TimeCurrent() + 60 * 第一单挂单有效分钟数, Red);
      if (Ad_8 == 0.0 && Ad_16 == 0.0) Li_52 = OrderSend(Symbol(), OP_SELLSTOP, Ad_0, Ad_32, 0, 0, 0, As_24, Ai_40, TimeCurrent() + 60 * 第一单挂单有效分钟数, Red);
      Li_44 = Li_52;
   }
   return (Li_44);
}
	   	   			  						  				  		 	  	 		   		 				  	 								 	 		   		   		     	 	  	 	 		 			 	     		 	  		 	 			 		   	 					 	  	 	  	   	  	  		   		 		 			    	   			    	
// 6ABA3523C7A75AAEA41CC0DEC7953CC5
int f0_6(double Ad_0, double Ad_8, double Ad_16, string As_24, double Ad_32, int Ai_40) {
   bool Li_44 = FALSE;
   bool Li_48 = FALSE;
   int Li_52 = 0;
   for (int Li_56 = 0; Li_56 < OrdersTotal(); Li_56++) {
      if (OrderSelect(Li_56, SELECT_BY_POS, MODE_TRADES))
         if (OrderComment() == As_24 && OrderSymbol() == Symbol() && OrderMagicNumber() == Ai_40) Li_48 = TRUE;
   }
   if (Li_48 == FALSE) {
      if (Ad_8 != 0.0 && Ad_16 != 0.0) Li_52 = OrderSend(Symbol(), OP_BUYSTOP, Ad_0, Ad_32, 0, Ad_32 - Ad_8 * Point, Ad_32 + Ad_16 * Point, As_24, Ai_40, 0, White);
      if (Ad_8 == 0.0 && Ad_16 != 0.0) Li_52 = OrderSend(Symbol(), OP_BUYSTOP, Ad_0, Ad_32, 0, 0, Ad_32 + Ad_16 * Point, As_24, Ai_40, 0, White);
      if (Ad_8 != 0.0 && Ad_16 == 0.0) Li_52 = OrderSend(Symbol(), OP_BUYSTOP, Ad_0, Ad_32, 0, Ad_32 - Ad_8 * Point, 0, As_24, Ai_40, 0, White);
      if (Ad_8 == 0.0 && Ad_16 == 0.0) Li_52 = OrderSend(Symbol(), OP_BUYSTOP, Ad_0, Ad_32, 0, 0, 0, As_24, Ai_40, 0, White);
      Li_44 = Li_52;
   }
   return (Li_44);
}
			 	 	 	    	 		    	 						     			 	 	 				    				 		   	  	 				 	 	 	   		  	 	   	 						 		  	  					   	   			   				 	  	 	     	  		 					 	 	 			  				  		    	  	 	
// 09CBB5F5CE12C31A043D5C81BF20AA4A
int f0_0(double Ad_0, double Ad_8, double Ad_16, string As_24, double Ad_32, int Ai_40) {
   bool Li_44 = FALSE;
   bool Li_48 = FALSE;
   int Li_52 = 0;
   for (int Li_56 = 0; Li_56 < OrdersTotal(); Li_56++) {
      if (OrderSelect(Li_56, SELECT_BY_POS, MODE_TRADES))
         if (OrderComment() == As_24 && OrderSymbol() == Symbol() && OrderMagicNumber() == Ai_40) Li_48 = TRUE;
   }
   if (Li_48 == FALSE) {
      if (Ad_8 != 0.0 && Ad_16 != 0.0) Li_52 = OrderSend(Symbol(), OP_SELLSTOP, Ad_0, Ad_32, 0, Ad_32 + Ad_8 * Point, Ad_32 - Ad_16 * Point, As_24, Ai_40, 0, Red);
      if (Ad_8 == 0.0 && Ad_16 != 0.0) Li_52 = OrderSend(Symbol(), OP_SELLSTOP, Ad_0, Ad_32, 0, 0, Ad_32 - Ad_16 * Point, As_24, Ai_40, 0, Red);
      if (Ad_8 != 0.0 && Ad_16 == 0.0) Li_52 = OrderSend(Symbol(), OP_SELLSTOP, Ad_0, Ad_32, 0, Ad_32 + Ad_8 * Point, 0, As_24, Ai_40, 0, Red);
      if (Ad_8 == 0.0 && Ad_16 == 0.0) Li_52 = OrderSend(Symbol(), OP_SELLSTOP, Ad_0, Ad_32, 0, 0, 0, As_24, Ai_40, 0, Red);
      Li_44 = Li_52;
   }
   return (Li_44);
}
	 								 	    		 	    	 	 		 	 		 							 	  	 		 	   		 			    	 								 		  					 				 	 	   		   		 	 		 			 		 		 		 	    					 	 			  			 	 							 		  	 		  		 	   				
// 9B1AEE847CFB597942D106A4135D4FE6
int f0_9(double Ad_0, double Ad_8, double Ad_16, string As_24, int Ai_32) {
   int Li_36;
   bool Li_40;
   bool Li_44 = FALSE;
   for (int Li_48 = 0; Li_48 < OrdersTotal(); Li_48++) {
      if (OrderSelect(Li_48, SELECT_BY_POS, MODE_TRADES))
         if (OrderComment() == As_24 && OrderSymbol() == Symbol() && OrderMagicNumber() == Ai_32) Li_44 = TRUE;
   }
   if (Li_44 == FALSE) {
      Li_36 = OrderSend(Symbol(), OP_BUY, Ad_0, Ask, Gi_184, 0, 0, As_24, Ai_32, 0, White);
      if (Li_36 <= 0) return (Li_36);
      if (OrderSelect(Li_36, SELECT_BY_TICKET) != TRUE) return (Li_36);
      Li_40 = FALSE;
      if (Ad_8 != 0.0 && Ad_16 != 0.0) {
         while (Li_40 == FALSE) {
            if (OrderModify(OrderTicket(), OrderOpenPrice(), OrderOpenPrice() - Ad_8 * MarketInfo(Symbol(), MODE_POINT), OrderOpenPrice() + Ad_16 * MarketInfo(Symbol(), MODE_POINT),
               0, Red) == TRUE) Li_40 = TRUE;
            else Sleep(1000);
         }
      }
      if (Ad_8 == 0.0 && Ad_16 != 0.0) {
         while (Li_40 == FALSE) {
            if (OrderModify(OrderTicket(), OrderOpenPrice(), 0, OrderOpenPrice() + Ad_16 * MarketInfo(Symbol(), MODE_POINT), 0, Red) == TRUE) Li_40 = TRUE;
            else Sleep(1000);
         }
      }
      if (!(Ad_8 != 0.0 && Ad_16 == 0.0)) return (Li_36);
      while (Li_40 == FALSE) {
         if (OrderModify(OrderTicket(), OrderOpenPrice(), OrderOpenPrice() - Ad_8 * MarketInfo(Symbol(), MODE_POINT), 0, 0, Red) == TRUE) Li_40 = TRUE;
         else Sleep(1000);
      }
      return (Li_36);
   }
   return (0);
}
		 			    		  		  		  		 	  			 	   		      	 	 	   	 		  								  		     	 	 		  				     	  			 	  	  	  			   			   	   	 			  				 	  	     	  		      				 	 	    	 	  	   
// A9B24A824F70CC1232D1C2BA27039E8D
int f0_10(double Ad_0, double Ad_8, double Ad_16, string As_24, int Ai_32) {
   int Li_36;
   bool Li_40;
   bool Li_44 = FALSE;
   for (int Li_48 = 0; Li_48 < OrdersTotal(); Li_48++) {
      if (OrderSelect(Li_48, SELECT_BY_POS, MODE_TRADES))
         if (OrderComment() == As_24 && OrderSymbol() == Symbol() && OrderMagicNumber() == Ai_32) Li_44 = TRUE;
   }
   if (Li_44 == FALSE) {
      Li_36 = OrderSend(Symbol(), OP_SELL, Ad_0, Bid, Gi_184, 0, 0, As_24, Ai_32, 0, Red);
      if (Li_36 <= 0) return (Li_36);
      if (OrderSelect(Li_36, SELECT_BY_TICKET) != TRUE) return (Li_36);
      Li_40 = FALSE;
      if (Ad_8 != 0.0 && Ad_16 != 0.0) {
         while (Li_40 == FALSE) {
            if (OrderModify(OrderTicket(), OrderOpenPrice(), OrderOpenPrice() + Ad_8 * MarketInfo(Symbol(), MODE_POINT), OrderOpenPrice() - Ad_16 * MarketInfo(Symbol(), MODE_POINT),
               0, Red) == TRUE) Li_40 = TRUE;
            else Sleep(1000);
         }
      }
      if (Ad_8 == 0.0 && Ad_16 != 0.0) {
         while (Li_40 == FALSE) {
            if (OrderModify(OrderTicket(), OrderOpenPrice(), 0, OrderOpenPrice() - Ad_16 * MarketInfo(Symbol(), MODE_POINT), 0, Red) == TRUE) Li_40 = TRUE;
            else Sleep(1000);
         }
      }
      if (!(Ad_8 != 0.0 && Ad_16 == 0.0)) return (Li_36);
      while (Li_40 == FALSE) {
         if (OrderModify(OrderTicket(), OrderOpenPrice(), OrderOpenPrice() + Ad_8 * MarketInfo(Symbol(), MODE_POINT), 0, 0, Red) == TRUE) Li_40 = TRUE;
         else Sleep(1000);
      }
      return (Li_36);
   }
   return (0);
}
		 		  		 		 		 	 		 		 		  	 		    	  		   				    			 	 			 	  	  	  		  	       		 			   		   	 	 					  	 			 				 	    			    		 		   	 	 			  	  		   	 	 		 	 	 	  	    		
// 78BAA8FAE18F93570467778F2E829047
int f0_8(double Ad_0, double Ad_8, double Ad_16, string As_24, double Ad_32, int Ai_40) {
   bool Li_44 = FALSE;
   bool Li_48 = FALSE;
   int Li_52 = 0;
   for (int Li_56 = 0; Li_56 < OrdersTotal(); Li_56++) {
      if (OrderSelect(Li_56, SELECT_BY_POS, MODE_TRADES))
         if (OrderComment() == As_24 && OrderMagicNumber() == Ai_40 && OrderSymbol() == Symbol() && OrderType() == OP_BUY || OrderType() == OP_BUYLIMIT || OrderType() == OP_BUYSTOP) Li_48 = TRUE;
   }
   if (Li_48 == FALSE) {
      if (Ad_8 != 0.0 && Ad_16 != 0.0) {
         Li_52 = OrderSend(Symbol(), OP_BUYLIMIT, Ad_0, Ad_32, 0, Ad_32 - Ad_8 * MarketInfo(Symbol(), MODE_POINT), Ad_32 + Ad_16 * MarketInfo(Symbol(), MODE_POINT), As_24,
            Ai_40, TimeCurrent() + 60 * 第一单挂单有效分钟数, White);
      }
      if (Ad_8 == 0.0 && Ad_16 != 0.0) {
         Li_52 = OrderSend(Symbol(), OP_BUYLIMIT, Ad_0, Ad_32, 0, 0, Ad_32 + Ad_16 * MarketInfo(Symbol(), MODE_POINT), As_24, Ai_40, TimeCurrent() + 60 * 第一单挂单有效分钟数,
            White);
      }
      if (Ad_8 != 0.0 && Ad_16 == 0.0) {
         Li_52 = OrderSend(Symbol(), OP_BUYLIMIT, Ad_0, Ad_32, 0, Ad_32 - Ad_8 * MarketInfo(Symbol(), MODE_POINT), 0, As_24, Ai_40, TimeCurrent() + 60 * 第一单挂单有效分钟数,
            White);
      }
      if (Ad_8 == 0.0 && Ad_16 == 0.0) Li_52 = OrderSend(Symbol(), OP_BUYLIMIT, Ad_0, Ad_32, 0, 0, 0, As_24, Ai_40, TimeCurrent() + 60 * 第一单挂单有效分钟数, White);
      Li_44 = Li_52;
   }
   return (Li_44);
}
	 		 			 	 		    	 		     	  	 				  			 		    				      	 	 	  	 	  			 						 				 	 	 		   	 	 			  	  	  	 	 	 	  					     				 	 						 		  	  			 		  	    			 				  				 
// 58B0897F29A3AD862616D6CBF39536ED
int f0_4(double Ad_0, double Ad_8, double Ad_16, string As_24, double Ad_32, int Ai_40) {
   bool Li_44 = FALSE;
   bool Li_48 = FALSE;
   int Li_52 = 0;
   for (int Li_56 = 0; Li_56 < OrdersTotal(); Li_56++) {
      if (OrderSelect(Li_56, SELECT_BY_POS, MODE_TRADES))
         if (OrderComment() == As_24 && OrderMagicNumber() == Ai_40 && OrderSymbol() == Symbol() && OrderType() == OP_SELL || OrderType() == OP_SELLLIMIT || OrderType() == OP_SELLSTOP) Li_48 = TRUE;
   }
   if (Li_48 == FALSE) {
      if (Ad_8 != 0.0 && Ad_16 != 0.0) {
         Li_52 = OrderSend(Symbol(), OP_SELLLIMIT, Ad_0, Ad_32, 0, Ad_32 + Ad_8 * MarketInfo(Symbol(), MODE_POINT), Ad_32 - Ad_16 * MarketInfo(Symbol(), MODE_POINT), As_24,
            Ai_40, TimeCurrent() + 60 * 第一单挂单有效分钟数, Red);
      }
      if (Ad_8 == 0.0 && Ad_16 != 0.0) {
         Li_52 = OrderSend(Symbol(), OP_SELLLIMIT, Ad_0, Ad_32, 0, 0, Ad_32 - Ad_16 * MarketInfo(Symbol(), MODE_POINT), As_24, Ai_40, TimeCurrent() + 60 * 第一单挂单有效分钟数,
            Red);
      }
      if (Ad_8 != 0.0 && Ad_16 == 0.0) {
         Li_52 = OrderSend(Symbol(), OP_SELLLIMIT, Ad_0, Ad_32, 0, Ad_32 + Ad_8 * MarketInfo(Symbol(), MODE_POINT), 0, As_24, Ai_40, TimeCurrent() + 60 * 第一单挂单有效分钟数,
            Red);
      }
      if (Ad_8 == 0.0 && Ad_16 == 0.0) Li_52 = OrderSend(Symbol(), OP_SELLLIMIT, Ad_0, Ad_32, 0, 0, 0, As_24, Ai_40, TimeCurrent() + 60 * 第一单挂单有效分钟数, Red);
      Li_44 = Li_52;
   }
   return (Li_44);
}