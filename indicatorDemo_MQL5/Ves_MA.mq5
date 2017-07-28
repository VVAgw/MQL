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
#property indicator_buffers 3
//графически выводить все три буфера
#property indicator_plots   3
//буферы отображать в виде простых линий
#property indicator_type1   DRAW_LINE
#property indicator_type2   DRAW_LINE
#property indicator_type3   DRAW_LINE
//цвета индикаторных линий
#property indicator_color1  Red
#property indicator_color2  Green
#property indicator_color3  Blue
//толщина линий
#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 2



//входные параметры индикатора
input int Usrednenie  = 15;         //”среднение дл€ пар
input string Instr1 =  "EURUSD";    //первы€ пара
input string Instr2 =  "GBPUSD";    //втора€ пара
input string Instr3 =  "AUDUSD";    //треть€ пара
input int KolBarov = 1000;          //количество просчитываемых баров

int MA1, MA2, MA3;   //дл€ хранени€ хэндлов скольз€щих средних

//объ€вление трех массивов дл€ индикаторных буферов
double Para1[], Para2[], Para3[];
//массивы дл€ хранени€ данных от скольз€щих средних
double ParaMA1[], ParaMA2[], ParaMA3[];
//массивы дл€ хранени€ цен закрыти€
double ClosePara1[], ClosePara2[], ClosePara3[];


//---------------------------------------------------------
int OnInit()
  {
   //присваиваем хэндлы скольз€щих средних переменным
   MA1 = iMA (Instr1, _Period, Usrednenie, 0, MODE_SMA, PRICE_CLOSE);
   MA2 = iMA (Instr2, _Period, Usrednenie, 0, MODE_SMA, PRICE_CLOSE);
   MA3 = iMA (Instr3, _Period, Usrednenie, 0, MODE_SMA, PRICE_CLOSE);
   //прив€зываем массивы к буферам индикатора
   SetIndexBuffer(0, Para1, INDICATOR_DATA);
   SetIndexBuffer(1, Para2, INDICATOR_DATA);
   SetIndexBuffer(2, Para3, INDICATOR_DATA);
   //делаем расчет индикатора и массивов с права на лево
   ArraySetAsSeries(Para1,true);
   ArraySetAsSeries(Para2,true);
   ArraySetAsSeries(Para3,true);
   ArraySetAsSeries(ParaMA1,true);
   ArraySetAsSeries(ParaMA2,true);
   ArraySetAsSeries(ParaMA3,true);
   ArraySetAsSeries(ClosePara1,true);
   ArraySetAsSeries(ClosePara2,true);
   ArraySetAsSeries(ClosePara3,true);
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
   //присваиваем цены закрыти€ пар массивам
   CopyClose (Instr1, _Period, 0, KolBarov, ClosePara1);
   CopyClose (Instr2, _Period, 0, KolBarov, ClosePara2);
   CopyClose (Instr3, _Period, 0, KolBarov, ClosePara3);
   //прив€зываем данные индикаторного буфера скольз€щих средних к массивам через хэндл
   CopyBuffer (MA1, 0, 0, KolBarov, ParaMA1);
   CopyBuffer (MA2, 0, 0, KolBarov, ParaMA2); 
   CopyBuffer (MA3, 0, 0, KolBarov, ParaMA3);
   //вычисл€ем значение дл€ индикаторных буферов
   for (int a = 0; a < KolBarov; a++)
      {
       Para1[a] = ClosePara1[a] - ParaMA1[a];
       Para2[a] = ClosePara2[a] - ParaMA2[a];
       Para3[a] = ClosePara3[a] - ParaMA3[a];
      }
      
   return(rates_total);
  }



//---------------------------------------------------------
void OnTradeTransaction(const MqlTradeTransaction& trans,
                        const MqlTradeRequest& request,
                        const MqlTradeResult& result)
  {
   
  }
