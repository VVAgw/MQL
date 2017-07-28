//+------------------------------------------------------------------+
//|                                                    Ves_2line.mq5 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#property indicator_chart_window

//выводить индикатор в отдельном окне
#property indicator_separate_window
//количество буферов для индикатора
#property indicator_buffers 2
//графически выводить все два буфера
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


input string para1 = "EURUSD.m"; //первая пара
input string para2 = "GBPUSD.m"; //вторая пара
input int kolBarov = 3000;       //баров считать
input bool revPara1 = false;     //перевернуть первую пару
input bool revPara2 = false;     //перевернуть вторую пару

input int fast_ema_period = 12;  // период быстрой средней
input int slow_ema_period = 26;  // период медленной средней
input int signal_period = 9;     // период усреднения разности
input ENUM_APPLIED_PRICE metod = PRICE_CLOSE;   //считать по каким ценам

double bufer1[], bufer2[];         //массивы для буфера
double macdPara1[], macdPara2[];   //массивы для хранения значения индикатора MACD
int handlMacd1, handlMacd2;        //хендлы индикаторов MACD для массивов
int reversPara1, reversPara2;      //для переворота пары


int OnInit()
{
   //привязываем массивы к буферам индикатора
   SetIndexBuffer(0, bufer1, INDICATOR_DATA);
   SetIndexBuffer(1, bufer2, INDICATOR_DATA);
   
   //привязываем хендлы индикаторов к переменным
   handlMacd1 = iMACD (para1, Period(), fast_ema_period, slow_ema_period, signal_period, metod);
   handlMacd2 = iMACD (para2, Period(), fast_ema_period, slow_ema_period, signal_period, metod);
   
   //делаем расчет индикатора и массивов с права на лево
   ArraySetAsSeries(bufer1,true);
   ArraySetAsSeries(bufer2,true);
   ArraySetAsSeries(macdPara1,true);
   ArraySetAsSeries(macdPara2,true);
   
   //описание линий индикатора
   PlotIndexSetString (0, PLOT_LABEL, SymbolInfoString(para1, SYMBOL_CURRENCY_BASE) + SymbolInfoString(para1, SYMBOL_CURRENCY_PROFIT));
   PlotIndexSetString (1, PLOT_LABEL, SymbolInfoString(para2, SYMBOL_CURRENCY_BASE) + SymbolInfoString(para2, SYMBOL_CURRENCY_PROFIT));

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
   //привязываем значения индикатора MACD к массивам через хендл
   CopyBuffer (handlMacd1, 0, 0, kolBarov, macdPara1);
   CopyBuffer (handlMacd2, 0, 0, kolBarov, macdPara2);
   
   //переворачиваем пары если функция включена
   if (revPara1 == true)
      reversPara1 = -1;
   else
      reversPara1 = 1;
   
   if (revPara2 == true)
      reversPara2 = -1;
   else
      reversPara2 = 1;
   
   //расчет значения буферов
   for (int a = kolBarov - 1; a != -1; a --)
   {
      bufer1[a] = macdPara1[a] * reversPara1;
      bufer2[a] = macdPara2[a] * reversPara2;
   }
   return(rates_total);
}
