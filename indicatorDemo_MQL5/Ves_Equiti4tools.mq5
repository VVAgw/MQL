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
//количество буферов для индикатора
#property indicator_buffers 5
//графически выводить все три буфера
#property indicator_plots   5
//буферы отображать в виде простых линий
#property indicator_type1   DRAW_LINE
#property indicator_type2   DRAW_LINE
#property indicator_type3   DRAW_LINE
#property indicator_type4   DRAW_LINE
#property indicator_type5   DRAW_LINE
//цвета индикаторных линий
#property indicator_color1  Red
#property indicator_color2  Green
#property indicator_color3  Black
#property indicator_color4  DeepSkyBlue
#property indicator_color5  DarkOrchid
//толщина линий
#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 3
#property indicator_width4 2
#property indicator_width5 2


//входные параметры индикатора
input string Instr1   = "EURUSD.m";   //первыя пара
input bool type1      = false;        //тип ордера первой пары false - бай, true - сел
input double lot1     = 0.1;          //лот для первой пары
input string Instr2   = "GBPUSD.m";   //вторая пара
input bool type2      = true;         //тип ордера второй пары false - бай, true - сел
input double lot2     = 0.1;          //лот для второй пары
input string Instr3   = "AUDUSD.m";   //вторая пара
input bool type3      = true;         //тип ордера третьей пары false - бай, true - сел
input double lot3     = 0.1;          //лот для второй пары
input string Instr4   = "USDCHF.m";   //вторая пара
input bool type4      = true;         //тип ордера четвертой пары false - бай, true - сел
input double lot4     = 0.1;          //лот для второй пары
input datetime StartTime = D'2012.01.01 00:00:00';   //время начала расчета

//массив для буфера
double Bufer1[];
double Bufer2[];
double Balance[];
double Bufer3[], Bufer4[];
//массивы для хранения данных от скользящих средних
double ClosePara1[], ClosePara2[], ClosePara3[], ClosePara4[];
double StartPara1, StartPara2, StartPara3, StartPara4;


//---------------------------------------------------------
int OnInit()
  {/*
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
   */
   
   //привязываем массивы к буферам индикатора
   SetIndexBuffer(0, Bufer1, INDICATOR_DATA);
   SetIndexBuffer(1, Bufer2, INDICATOR_DATA);
   SetIndexBuffer(2, Balance, INDICATOR_DATA);
   SetIndexBuffer(3, Bufer3, INDICATOR_DATA);
   SetIndexBuffer(4, Bufer4, INDICATOR_DATA);
   
   //делаем расчет индикатора и массивов с права на лево
   ArraySetAsSeries(Bufer1,true);
   ArraySetAsSeries(Bufer2,true);
   ArraySetAsSeries(Bufer3,true);
   ArraySetAsSeries(Bufer4,true);
   ArraySetAsSeries(Balance,true);
   ArraySetAsSeries(ClosePara1,true);
   ArraySetAsSeries(ClosePara2,true);
   ArraySetAsSeries(ClosePara3,true);
   ArraySetAsSeries(ClosePara4,true);
   
   //описание индикатора и линий индикатора
   PlotIndexSetString (0, PLOT_LABEL, Instr1);
   PlotIndexSetString (1, PLOT_LABEL, Instr2);
   PlotIndexSetString (2, PLOT_LABEL, "Balance");
   PlotIndexSetString (3, PLOT_LABEL, Instr3);
   PlotIndexSetString (4, PLOT_LABEL, Instr4);
   
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
   
   //присваиваем цены закрытия пар массивам
   CopyOpen (Instr1, _Period, TimeCurrent(), StartTime, ClosePara1);
   CopyOpen (Instr2, _Period, TimeCurrent(), StartTime, ClosePara2);
   CopyOpen (Instr3, _Period, TimeCurrent(), StartTime, ClosePara3);
   CopyOpen (Instr4, _Period, TimeCurrent(), StartTime, ClosePara4);
   
   //вычисляем значение для индикаторных буферов
   StartPara1 = ClosePara1[ArraySize(ClosePara1) - 1];
   StartPara2 = ClosePara2[ArraySize(ClosePara2) - 1];
   StartPara3 = ClosePara3[ArraySize(ClosePara3) - 1];
   StartPara4 = ClosePara4[ArraySize(ClosePara4) - 1];
   double PunktPara1 = 10 * lot1;
   double PunktPara2 = 10 * lot2; 
   double PunktPara3 = 10 * lot3;
   double PunktPara4 = 10 * lot4;
   
   for (int a = ArraySize(ClosePara1) - 1; a != -1; a--)
   {
      if (type1 == false)
         Bufer1[a] = StringToDouble(DoubleToString(ClosePara1[a] - StartPara1,Digits())) * 10000 * PunktPara1;
      else
         Bufer1[a] = StringToDouble(DoubleToString(StartPara1 - ClosePara1[a],Digits())) * 10000 * PunktPara1;
      
      if (type2 == false)
         Bufer2[a] = StringToDouble(DoubleToString(ClosePara2[a] - StartPara2,Digits())) * 10000 * PunktPara2;
      else
         Bufer2[a] = StringToDouble(DoubleToString(StartPara2 - ClosePara2[a],Digits())) * 10000 * PunktPara2;
         
      if (type3 == false)
         Bufer3[a] = StringToDouble(DoubleToString(ClosePara3[a] - StartPara3,Digits())) * 10000 * PunktPara3;
      else
         Bufer3[a] = StringToDouble(DoubleToString(StartPara3 - ClosePara3[a],Digits())) * 10000 * PunktPara3;
         
      if (type4 == false)
         Bufer4[a] = StringToDouble(DoubleToString(ClosePara4[a] - StartPara4,Digits())) * 10000 * PunktPara4;
      else
         Bufer4[a] = StringToDouble(DoubleToString(StartPara4 - ClosePara4[a],Digits())) * 10000 * PunktPara4;
               
         
      Balance[a] = Bufer1[a] + Bufer2[a] + Bufer3[a] + Bufer4[a];
   }

   return(rates_total);
  }
