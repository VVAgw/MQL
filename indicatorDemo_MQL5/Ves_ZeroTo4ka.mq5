//+------------------------------------------------------------------+
//|                                                Ves_ZeroTo4ka.mq5 |
//|                                                              Ves |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Ves"
#property link      "http://www.mql5.com"
#property version   "1.00"

//в отдельном окне
#property indicator_separate_window
//количество буферов дл€ индикатора
#property indicator_buffers 1
//графически выводить один буфер
#property indicator_plots   1
//буферы отображать в виде простых линий
#property indicator_type1   DRAW_LINE
//цвета индикаторных линий
#property indicator_color1  Red
//толщина линий
#property indicator_width1 2


//входные параметры
input int Usrednenie = 10;   //значение усреднени€
input int KolBarov = 1000;   //количество баров дл€ расчета


//дл€ хранени€ хэндлов скольз€щих средних
int x1;


//объ€вление массива дл€ буфера
double Bufer[];
//массивы дл€ хранени€ данных
double PraceClose[], MA[];
   


int OnInit()
  {
   //присваиваем хэндлы скольз€щих средних переменным
   x1 = iMA (Symbol(), _Period, Usrednenie, 0, MODE_SMA, PRICE_CLOSE);
   //прив€зываем массивы к буферам индикатора
   SetIndexBuffer(0, Bufer, INDICATOR_DATA);
   //делаем расчет индикатора и массивов с права на лево
   ArraySetAsSeries(Bufer,true);
   ArraySetAsSeries(PraceClose,true);
   ArraySetAsSeries(MA,true);
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
   //присваиваем цену закрыти€ баров массиву
   CopyClose (Symbol(), _Period, 0, KolBarov, PraceClose);
   
   //прив€зываем данные индикатора к массиву через хендл
   CopyBuffer (x1, 0, 0, KolBarov, MA);
   
   //вычисл€ем значение дл€ индикаторных буферов
   for (int a = 0; a < KolBarov; a++)
      {
       Bufer[a] = PraceClose[a] - MA[a];
      }
   return(rates_total);
  }
//+------------------------------------------------------------------+
