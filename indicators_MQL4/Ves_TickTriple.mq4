/*
индикатор показывает 3 скользящие средние трех валютных пар. Каждая средняя это 
усредненное отклонение от цены соответствующей валютной пары.
*/
#property copyright "Ves Volk"
#property link      ""

#property indicator_separate_window
#property  indicator_buffers 3        

extern int Усреднение = 100;
 
double БуферGBPUSD [10000000];
double БуферEURUSD [10000000];
double БуферEURGBP [10000000];

double ЦенаGBPUSD [10000000];
double ЦенаEURUSD [10000000];
double ЦенаEURGBP [10000000];

double ЦенаGBPUSDдляСредней [10000000];
double ЦенаEURUSDдляСредней [10000000];
double ЦенаEURGBPдляСредней [10000000];

double GBPUSDСредняя [10000000];
double EURUSDСредняя [10000000];
double EURGBPСредняя [10000000];

int Тик = 0;

int tt;
int tt2;
double Общее;
int tt3, i2, i;


int init()
  {
   SetIndexBuffer(0,БуферGBPUSD);       
   SetIndexStyle(0,DRAW_LINE, EMPTY, 2, Green);
   SetIndexBuffer(1,БуферEURUSD);       
   SetIndexStyle(1,DRAW_LINE, EMPTY, 2, Red);
   SetIndexBuffer(2,БуферEURGBP);       
   SetIndexStyle(2,DRAW_LINE, EMPTY, 2, Blue); 
   return(0);
  }
  
  
int deinit ()
   {
    ObjectsDeleteAll ();
    return (0);
   }
  
  
int start()
  {
   if (ObjectFind ("GBPUSD") == -1)
      {
       ObjectCreate ("GBPUSD", OBJ_LABEL, 1, 0, 0);
       ObjectSet ("GBPUSD", OBJPROP_FONTSIZE, 10);
       ObjectSet ("GBPUSD", OBJPROP_COLOR, Green);
       ObjectSet ("GBPUSD", OBJPROP_XDISTANCE, 1340);
       ObjectSet ("GBPUSD", OBJPROP_YDISTANCE, 3);
       ObjectSetText ("GBPUSD", "GBPUSD");
      } 
    if (ObjectFind ("EURUSD") == -1)
      {
       ObjectCreate ("EURUSD", OBJ_LABEL, 1, 0, 0);
       ObjectSet ("EURUSD", OBJPROP_FONTSIZE, 10);
       ObjectSet ("EURUSD", OBJPROP_COLOR, Red);
       ObjectSet ("EURUSD", OBJPROP_XDISTANCE, 1405);
       ObjectSet ("EURUSD", OBJPROP_YDISTANCE, 3);
       ObjectSetText ("EURUSD", "EURUSD");
      } 
    if (ObjectFind ("EURGBP") == -1)
      {
       ObjectCreate ("EURGBP", OBJ_LABEL, 1, 0, 0);
       ObjectSet ("EURGBP", OBJPROP_FONTSIZE, 10);
       ObjectSet ("EURGBP", OBJPROP_COLOR, Blue);
       ObjectSet ("EURGBP", OBJPROP_XDISTANCE, 1470);
       ObjectSet ("EURGBP", OBJPROP_YDISTANCE, 3);
       ObjectSetText ("EURGBP", "EURGBP");
      } 
   
   
   //массивы цен торговых пар
   ЦенаGBPUSD [Тик] = MarketInfo ("GBPUSD_m", MODE_BID);
   ЦенаEURUSD [Тик] = MarketInfo ("EURUSD_m", MODE_BID);
   ЦенаEURGBP [Тик] = MarketInfo ("EURGBP_m", MODE_BID);
   
   
   
   
   //передаем данные в буфер индикатора
   i2 = 0;
   for (i = Тик; i >= 0 && i2 <= Тик; i--)
      {
       ЦенаGBPUSDдляСредней[i] = ЦенаGBPUSD[i2];
       i2 ++;
      }
   i2 = 0;
   for (i = Тик; i >= 0 && i2 <= Тик; i--)
      {
       ЦенаEURUSDдляСредней[i] = ЦенаEURUSD[i2];
       i2 ++;
      }
   i2 = 0;
   for (i = Тик; i >= 0 && i2 <= Тик; i--)
      {
       ЦенаEURGBPдляСредней[i] = ЦенаEURGBP[i2];
       i2 ++;
      }
      
   
   
   //передаем данные и рисуем скольозящую среднюю гистограммы
   if (Тик > Усреднение)
      {
       for (tt = 0; tt < Тик - Усреднение; tt++)
         {
          Общее = 0;
          tt3 = 0;
          for (tt2 = tt; tt3 < Усреднение; tt2++, tt3++)
            {
             Общее = ЦенаGBPUSDдляСредней[tt2] + Общее;
            }
          GBPUSDСредняя [tt] = Общее / Усреднение;
         }
      }
   if (Тик > Усреднение)
      {
       for (tt = 0; tt < Тик - Усреднение; tt++)
         {
          Общее = 0;
          tt3 = 0;
          for (tt2 = tt; tt3 < Усреднение; tt2++, tt3++)
            {
             Общее = ЦенаEURUSDдляСредней[tt2] + Общее;
            }
          EURUSDСредняя [tt] = Общее / Усреднение;
         }
      }
   if (Тик > Усреднение)
      {
       for (tt = 0; tt < Тик - Усреднение; tt++)
         {
          Общее = 0;
          tt3 = 0;
          for (tt2 = tt; tt3 < Усреднение; tt2++, tt3++)
            {
             Общее = ЦенаEURGBPдляСредней[tt2] + Общее;
            }
          EURGBPСредняя [tt] = Общее / Усреднение;
         }
      }
   
   
   
   //высчитываем значение гистограммы
   if (Тик > Усреднение)
      {
       for (tt = 0; tt < Тик - Усреднение; tt++)
         {
          БуферGBPUSD [tt] = ЦенаGBPUSDдляСредней[tt] - GBPUSDСредняя [tt];
         }
      }
   if (Тик > Усреднение)
      {
       for (tt = 0; tt < Тик - Усреднение; tt++)
         {
          БуферEURUSD [tt] = ЦенаEURUSDдляСредней[tt] - EURUSDСредняя [tt];
         }
      }
   if (Тик > Усреднение)
      {
       for (tt = 0; tt < Тик - Усреднение; tt++)
         {
          БуферEURGBP [tt] = ЦенаEURGBPдляСредней[tt] - EURGBPСредняя [tt];
         }
      }
      
   Comment ("\n  Количество посчитанных тиков = ", Тик);
   Тик ++;
   return(0);
  }

