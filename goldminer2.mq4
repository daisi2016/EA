
#property copyright "Copyright ForexFunnel"
#property link      ""

#property indicator_separate_window
#property indicator_minimum 0.0
#property indicator_maximum 1.0
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 Red

#import "MT_PRO.dll"
   string AccountMatch(string a0, string a1);
#import

string gs_unused_76 = "http://www.forexfunnel.com/mt_auth/serveme.php";
string gs_unused_84 = "ther\'s an error!";
string gs_unused_92 = "this is not registered account number!";
string gs_unused_100 = "this account does not match  the registered account number!";
string gs_unused_108 = "trial period had been expired!";
string gs_unused_116 = "Good Account";
string gs_unused_124 = "";
bool gi_unused_132 = FALSE;
extern int SSP = 7;
extern double Kmax = 50.6;
extern int CountBars = 300;
double g_ibuf_152[];
double g_ibuf_156[];
double g_ibuf_160[];
double g_ibuf_164[];
int flag = 0;

int init() {
   IndicatorBuffers(4);
   SetIndexStyle(0, DRAW_HISTOGRAM, STYLE_SOLID, 4);
   SetIndexBuffer(0, g_ibuf_160);
   SetIndexStyle(1, DRAW_HISTOGRAM, STYLE_SOLID, 4);
   SetIndexBuffer(1, g_ibuf_164);
   SetIndexBuffer(2, g_ibuf_152);
   SetIndexBuffer(3, g_ibuf_156);
   Comment("goldminer");
   IndicatorShortName("goldminer");
   SetIndexLabel(0, "");
   SetIndexLabel(1, "");
   flag = 0;
   return (0);
}

int deinit() {
   return (0);
}

int start() {
   double ld_8;
   double ld_16;
   double ld_32;
   if (CountBars >= Bars) CountBars = Bars;
   SetIndexDrawBegin(0, Bars - CountBars + SSP);
   SetIndexDrawBegin(1, Bars - CountBars + SSP);
   int l_ind_counted_4 = IndicatorCounted();
   if (Bars <= SSP + 1) return (0);
   if (l_ind_counted_4 < SSP + 1) {
      for (int li_0 = 1; li_0 <= SSP; li_0++) g_ibuf_152[CountBars - li_0] = 0.0;
      for (li_0 = 1; li_0 <= SSP; li_0++) g_ibuf_156[CountBars - li_0] = 0.0;
   }
   for (li_0 = CountBars - SSP; li_0 >= 0; li_0--) {
      ld_8 = High[iHighest(NULL, 0, MODE_HIGH, SSP, li_0 - SSP + 1)];
      ld_16 = Low[iLowest(NULL, 0, MODE_LOW, SSP, li_0 - SSP + 1)];
      ld_32 = ld_8 - (ld_8 - ld_16) * Kmax / 100.0;
      g_ibuf_152[li_0 - SSP + 6] = ld_32;
      g_ibuf_156[li_0 - SSP - 1] = ld_32;
   }
   for (int li_40 = CountBars - SSP; li_40 >= 0; li_40--) {
      if (g_ibuf_152[li_40] > g_ibuf_156[li_40]) {
         g_ibuf_160[li_40] = 1;
         g_ibuf_164[li_40] = 0;
         
         
      } else {
         g_ibuf_160[li_40] = 0;
         g_ibuf_164[li_40] = 1;

      }
   }
   
   
   if(g_ibuf_160[1] == 0 && g_ibuf_160[0] == 1 && flag != 1){
            Alert(Symbol(),"  ",Period(),"分钟  转向多头");
            PlaySound("alert2.wav");
            flag = 1;
   }
   if(g_ibuf_164[1] == 0 && g_ibuf_164[0] == 1 && flag != -1){
            Alert(Symbol(),"  ",Period(),"分钟  转向空头");
            PlaySound("alert2.wav");
            flag = -1;
   }
   return (0);
}