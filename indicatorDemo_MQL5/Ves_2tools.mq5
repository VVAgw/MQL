//+------------------------------------------------------------------+
//|                                                       Ves_MA.mq5 |
//|                                                          BigfOOt |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "BigfOOt"
#property link      "http://www.mql5.com"
#property version   "1.00"



//выводить индикатор в отдельном окне
#property indicator_separate_window
//количество буферов дл€ индикатора
#property indicator_buffers 2
//графически выводить все три буфера
#property indicator_plots   2
//буферы отображать в виде простых линий
#property indicator_type1   DRAW_LINE
#property indicator_type2   DRAW_LINE
//цвета индикаторных линий
#property indicator_color1  Red
#property indicator_color2  Green
//толщина линий
#property indicator_width1 2
#property indicator_width2 2



//входные параметры индикатора
input string Instr1   =  "EURUSD.m";  //первы€ пара
input string Instr2   =  "GBPUSD.m";  //втора€ пара
input int    KolBarov = 3000;         //количество просчитываемых баров

input int       ExtParam5 = 1000;   //общий знаменатель дл€ первого инструмента
input int       ExtParam6 = 1000;   //общий знаменатель дл€ второго инструмента
input int       ExtParam7 = 21;     //медленна€ средн€€
input int       ExtParam8 = 13;     //быстра€ средн€€
input ENUM_MA_METHOD      ExtParam9  = MODE_SMMA;        //метод усреднени€
input ENUM_APPLIED_PRICE  ExtParam10 = PRICE_WEIGHTED;   //используема€ цена дл€ усреднени€

//массив дл€ буфера
double Bufer1[];
double Bufer2[];
//массивы дл€ хранени€ данных от скольз€щих средних
double OpenPara1[], OpenPara2[];
double MAPara1[], MAPara2[], MAPara11[], MAPara22[];
int MA1, MA2, MA11, MA22;
double minx, miny, mindelta;
double MaxRasxod, Sch;


//---------------------------------------------------------
int OnInit()
  {
   //создаем графический информационный объект
   ObjectCreate(0, "inf1df2", OBJ_LABEL, ChartWindowFind(), 0, 0);
   ObjectSetString(0, "inf1df2", OBJPROP_TEXT, Instr1);
   ObjectSetInteger(0, "inf1df2", OBJPROP_COLOR, Red);
   ObjectSetInteger(0, "inf1df2", OBJPROP_XDISTANCE, 210);
   ObjectSetInteger(0, "inf1df2", OBJPROP_YDISTANCE, 1);
   
   ObjectCreate(0, "infdssf22", OBJ_LABEL, ChartWindowFind(), 0, 0);
   ObjectSetString(0, "infdssf22", OBJPROP_TEXT, Instr2);
   ObjectSetInteger(0, "infdssf22", OBJPROP_COLOR, Green);
   ObjectSetInteger(0, "infdssf22", OBJPROP_XDISTANCE, 310);
   ObjectSetInteger(0, "infdssf22", OBJPROP_YDISTANCE, 1);
   
   ObjectCreate(0, "idsdfeeesf22", OBJ_LABEL, ChartWindowFind(), 0, 0);
   ObjectSetString(0, "idsdfeeesf22", OBJPROP_TEXT, "макс. расхождение = 0");
   ObjectSetInteger(0, "idsdfeeesf22", OBJPROP_COLOR, SaddleBrown);
   ObjectSetInteger(0, "idsdfeeesf22", OBJPROP_XDISTANCE, 410);
   ObjectSetInteger(0, "idsdfeeesf22", OBJPROP_YDISTANCE, 1);
   
   //прив€зываем массивы к буферам индикатора
   SetIndexBuffer(0, Bufer1, INDICATOR_DATA);
   SetIndexBuffer(1, Bufer2, INDICATOR_DATA);
   
   //присваиваем хэндлы скольз€щих средних переменным
   MA1 = iMA (Instr1, _Period, ExtParam8, 0, ExtParam9, ExtParam10);
   MA2 = iMA (Instr2, _Period, ExtParam8, 0, ExtParam9, ExtParam10);
   MA11 = iMA (Instr1, _Period, ExtParam7, 0, ExtParam9, ExtParam10);
   MA22 = iMA (Instr2, _Period, ExtParam7, 0, ExtParam9, ExtParam10);
   
   //делаем расчет индикатора и массивов с права на лево
   ArraySetAsSeries(Bufer1,true);
   ArraySetAsSeries(Bufer2,true);
   ArraySetAsSeries(OpenPara1,true);
   ArraySetAsSeries(OpenPara2,true);
   ArraySetAsSeries(MAPara1, true);
   ArraySetAsSeries(MAPara2, true);
   ArraySetAsSeries(MAPara11, true);
   ArraySetAsSeries(MAPara22, true);
   
   //описание индикатора и линий индикатора
   PlotIndexSetString (0, PLOT_LABEL, Instr1);
   PlotIndexSetString (1, PLOT_LABEL, Instr2);
   
   return(0);
  }


//--------------------------------------------------------
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
   //прив€зываем данные индикаторного буфера скольз€щих средних к массивам через хэндл
   CopyBuffer (MA1, 0, 0, KolBarov, MAPara1);
   CopyBuffer (MA2, 0, 0, KolBarov, MAPara2);
   CopyBuffer (MA11, 0, 0, KolBarov, MAPara11);
   CopyBuffer (MA22, 0, 0, KolBarov, MAPara22);
   
   //присваиваем цены закрыти€ пар массивам
   CopyOpen (Instr1, _Period, 0, KolBarov, OpenPara1);
   CopyOpen (Instr2, _Period, 0, KolBarov, OpenPara2);
   
   //вычислени€ дл€ определени€ лотов дл€ пар
   /*
   double ynax = SymbolInfoDouble (Instr1, SYMBOL_TRADE_TICK_VALUE) /  SymbolInfoDouble (Instr2, SYMBOL_TRADE_TICK_VALUE) *
                 (OpenPara1[0] / SymbolInfoDouble (Instr1, SYMBOL_TRADE_TICK_SIZE))  /  (OpenPara2[0] / SymbolInfoDouble (Instr2, SYMBOL_TRADE_TICK_SIZE));
                 
   minx=0; miny=0; mindelta=9999;

   for (double x=0.01; x<=1; x+=0.01)
   {
      for (double y=0.01; y<=1; y+=0.01)
      {
         double delta=MathAbs(y/x-ynax);
         if (delta<mindelta)
         {
            minx = StringToDouble(DoubleToString(x,2));
            miny = StringToDouble(DoubleToString(y,2));
            mindelta = delta;
         }
      }
   }
   IndicatorSetString (INDICATOR_SHORTNAME, "Ћот дл€ " + Instr1 + " = " + minx + "     Ћот дл€ " + Instr2 + " = " + miny + "     ");
   */
   
   //вычисл€ем значение дл€ индикаторных буферов
   for (int a = KolBarov - 1; a != -1; a--)
   {
      Bufer1[a] = (MAPara1[a] - MAPara11[a]) * ExtParam5;
      Bufer2[a] = (MAPara2[a] - MAPara22[a]) * ExtParam6;
   }
   
   //вычисл€ем максимальное значение расхождени€
   Sch = 0;
   MaxRasxod = 0;
   for (int x = 0; x < KolBarov; x++)
   {
      if(Bufer1[x] > Bufer2[x])
         Sch = NormalizeDouble(Bufer1[x] - Bufer2[x], Digits());
      else
         Sch = NormalizeDouble(Bufer2[x] - Bufer1[x], Digits());
         
      if (Sch > MaxRasxod)
         MaxRasxod = Sch;
   }
   ObjectSetString(0, "idsdfeeesf22", OBJPROP_TEXT, "макс расхождение = " + DoubleToString(MaxRasxod, 5));

   return(rates_total);
  }
