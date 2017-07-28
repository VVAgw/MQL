/*
Расчет всех пар по пунктам от начальной точки
*/
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window

//выводить индикатор в отдельном окне
#property indicator_separate_window
//количество буферов для индикатора
#property indicator_buffers 9
//графически выводить все два буфера
#property indicator_plots   3
//буферы отображать в виде простых линий
#property indicator_type1   DRAW_LINE
#property indicator_type2   DRAW_LINE
#property indicator_type3   DRAW_LINE
//цвета индикаторных линий
#property indicator_color1  Black
#property indicator_color2  Red
#property indicator_color3  Green
//толщина линий
#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 2


input string kross = "EURUSD.m";   //кросс пара
input string para1 = "EURGBP.m";   //первая пара
input string para2 = "GBPUSD.m";   //вторая пара
input int kolBarov = 3000;         //баров считать
input bool revPara2 = false;       //перевернуть вторую пару

input int ema = 15;                 //усреднение для пар
input int fast_ema_period = 12;    // период быстрой средней
input int slow_ema_period = 26;    // период медленной средней
input int signal_period = 9;       // период усреднения разности
input ENUM_APPLIED_PRICE metod = PRICE_CLOSE;  //считать по каким ценам

double buferKross[], bufer1[], bufer2[];       //массивы для буфера
double emaKross[], emaPara1[], emaPara2[],   //массивы для хранения значения индикатора MACD
closeKross[], closePara1[], closePara2[];   
int handlEmaKross, handlEma1, handlEma2;     //хендлы индикаторов MACD для массивов
int reversPara2;                               //для переворота пары
//переменные для создания объектов
string objKross = "objKross", obj1 = "obj1", obj2 = "obj2";
double startCross,startPara1,startPara2;
int start;

int OnInit()
{
   if (start == 0)
   {   
      startCross = SymbolInfoDouble(kross,SYMBOL_BID);
      startPara1 = SymbolInfoDouble(para1,SYMBOL_BID);
      startPara2 = SymbolInfoDouble(para2,SYMBOL_BID);
   }
   //привязываем массивы к буферам индикатора
   SetIndexBuffer(0, buferKross, INDICATOR_DATA);
   SetIndexBuffer(1, bufer1, INDICATOR_DATA);
   SetIndexBuffer(2, bufer2, INDICATOR_DATA);
   SetIndexBuffer(3, emaPara1, INDICATOR_CALCULATIONS);
   SetIndexBuffer(4, emaPara2, INDICATOR_CALCULATIONS);
   SetIndexBuffer(5, emaKross, INDICATOR_CALCULATIONS);
   SetIndexBuffer(6, closeKross, INDICATOR_CALCULATIONS);
   SetIndexBuffer(7, closePara1, INDICATOR_CALCULATIONS);
   SetIndexBuffer(8, closePara2, INDICATOR_CALCULATIONS);
   
   //привязываем хендлы индикаторов к переменным
   handlEmaKross = iMA(kross, Period(), ema, 0, MODE_EMA, PRICE_CLOSE);
   handlEma1 = iMA(para1, Period(), ema, 0, MODE_EMA, PRICE_CLOSE);
   handlEma2 = iMA(para2, Period(), ema, 0, MODE_EMA, PRICE_CLOSE);
   
   //создаем объекты
   ObjectCreate (0, objKross, OBJ_LABEL, ChartWindowFind(), 0, 0);
   ObjectSetString (0, objKross, OBJPROP_TEXT, " Кросс " + SymbolInfoString(kross, SYMBOL_CURRENCY_BASE) + SymbolInfoString(kross, SYMBOL_CURRENCY_PROFIT));
   ObjectSetInteger (0, objKross, OBJPROP_COLOR, Black);
   ObjectSetInteger (0, objKross, OBJPROP_XDISTANCE, 460);
      
   ObjectCreate (0, obj1, OBJ_LABEL, ChartWindowFind(), 0, 0);
   ObjectSetString (0, obj1, OBJPROP_TEXT, SymbolInfoString(para1, SYMBOL_CURRENCY_BASE) + SymbolInfoString(para1, SYMBOL_CURRENCY_PROFIT));
   ObjectSetInteger (0, obj1, OBJPROP_COLOR, Red);
   ObjectSetInteger (0, obj1, OBJPROP_XDISTANCE, 300);
      
   ObjectCreate (0, obj2, OBJ_LABEL, ChartWindowFind(), 0, 0);
   ObjectSetString (0, obj2, OBJPROP_TEXT, SymbolInfoString(para2, SYMBOL_CURRENCY_BASE) + SymbolInfoString(para2, SYMBOL_CURRENCY_PROFIT));
   ObjectSetInteger (0, obj2, OBJPROP_COLOR, Green);
   ObjectSetInteger (0, obj2, OBJPROP_XDISTANCE, 380);
   
   //описание линий индикатора
   PlotIndexSetString (0, PLOT_LABEL, SymbolInfoString(kross, SYMBOL_CURRENCY_BASE) + SymbolInfoString(kross, SYMBOL_CURRENCY_PROFIT));
   PlotIndexSetString (1, PLOT_LABEL, SymbolInfoString(para1, SYMBOL_CURRENCY_BASE) + SymbolInfoString(para1, SYMBOL_CURRENCY_PROFIT));
   PlotIndexSetString (2, PLOT_LABEL, SymbolInfoString(para2, SYMBOL_CURRENCY_BASE) + SymbolInfoString(para2, SYMBOL_CURRENCY_PROFIT));
   
   //IndicatorSetString(INDICATOR_SHORTNAME,"Ves_2line_v4 ("+string(fast_ema_period)+","+string(slow_ema_period)+","+string(signal_period)+"), кросс ("+string(emaForKross)+")");
   IndicatorSetString(INDICATOR_SHORTNAME,ChartIndicatorName(0,ChartWindowFind(),0)+" ("+string(fast_ema_period)+","+string(slow_ema_period)+","+string(signal_period)+")");
   
   return(0);
}

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
   //переворачиваем пару если функция включена
   if (revPara2 == true)
      reversPara2 = -1;
   else
      reversPara2 = 1;
   
   //расчет значения буферов
   if(BarsCalculated(handlEma1) < 0)
     {
      Print("Недостаточно данных для первой пары. Ошибка ",GetLastError());
      return(0);
     }
   if(BarsCalculated(handlEma2) < 0)
     {
      Print("Недостаточно данных для второй пары. Ошибка ",GetLastError());
      return(0);
     }
   if(BarsCalculated(handlEmaKross) < 0)
     {
      Print("Недостаточно данных для кросс пары. Ошибка ",GetLastError());
      return(0);
     }
   
   int to_copy;
   if(prev_calculated > rates_total || prev_calculated < 0) 
      to_copy=rates_total - kolBarov;
   else
     {
      to_copy = rates_total - prev_calculated;
      
      if(prev_calculated > 0) 
         to_copy ++;
     }
     
   //привязываем значения индикатора MACD к массивам через хендл
   CopyBuffer(handlEma1,0,0,to_copy,emaPara1);
   CopyBuffer(handlEma2,0,0,to_copy,emaPara2);
   CopyBuffer(handlEmaKross,0,0,to_copy,emaKross);
   CopyClose(kross,Period(),0,to_copy,closeKross);
   CopyClose(para1,Period(),0,to_copy,closePara1);
   CopyClose(para2,Period(),0,to_copy,closePara2);
   
   int limit;
   if (prev_calculated == 0)
      limit = rates_total - kolBarov;
   else
      limit = prev_calculated - 1;
      
   for (int i = limit; i < rates_total; i ++)
   {
      buferKross[i] = closeKross[i] - startCross;
      bufer1[i] = closePara1[i] - startPara1;
      bufer2[i] = closePara2[i] - startPara2;
   }
   
   return(rates_total);
}
