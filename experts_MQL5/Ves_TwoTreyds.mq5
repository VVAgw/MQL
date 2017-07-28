/*
Советник покупает два инструмента на расхождении показателя индикатора
*/
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>


input int Profit = 20;           //общий профит в пунктах
input int Ubitok = -20;          //общий убыток в пунктах
input double Lot = 1.0;          //Размер лота
input double MaxZnach = 0.005;   //максимальное значение для торговли
input bool CloseMinZnach = false;//закрывать по минимальному значению индикатора ?
input double MinZnach = 0.0005;  //минимальное значение для закрытия ордеров

input bool Dolivka1 = false;     //разрешить первую доливку ?
input int Profit1Dolivka = 40;   //профит при первой доливки
input int Ubitok1Dolivka = -80;  //убыток при первой доливки

//входные параметры индикатора
input string Instr1   =  "EURUSD.m";  //первыя пара
input string Instr2   =  "GBPUSD.m";  //вторая пара
input int    KolBarov = 3000;         //количество просчитываемых баров

input int       ExtParam5 = 1000;   //общий знаменатель для первого инструмента
input int       ExtParam6 = 1000;   //общий знаменатель для второго инструмента
input int       ExtParam7 = 21;     //медленная средняя
input int       ExtParam8 = 13;     //быстрая средняя
input ENUM_MA_METHOD      ExtParam9  = MODE_SMMA;        //метод усреднения
input ENUM_APPLIED_PRICE  ExtParam10 = PRICE_WEIGHTED;   //используемая цена для усреднения


//хендл индикатора
int Hendl;
//индикаторные буферы
double para1[], para2[];

CTrade GO;            //объект библиотеки для торговли
CPositionInfo GOinfo;
int a;                //для контроля ошибок ордеров
double TotalProfit;
double Money;
double Rasxod, MaxRasxod, Sch;
int KolDolivok;
bool StartDolivka1 = Dolivka1;


int OnInit()
{
   Hendl = iCustom (Symbol(), PERIOD_CURRENT, "Ves_2toolsV3", Instr1, Instr2, KolBarov, ExtParam5, ExtParam6, ExtParam7, ExtParam8, ExtParam9, ExtParam10);
   ArraySetAsSeries(para1,true);
   ArraySetAsSeries(para2,true);
   return (0);
}


void OnTick()
{
   //присваиваем значения индикатора массивам
   CopyBuffer (Hendl, 0, 0, KolBarov, para1);
   CopyBuffer (Hendl, 1, 0, KolBarov, para2);
   //вычисляем расхождение индикатора
   if(para1[0] > para2[0])
      Rasxod = NormalizeDouble(para1[0] - para2[0], Digits());
   else
      Rasxod = NormalizeDouble(para2[0] - para1[0], Digits());
      
   //вычисляем максимальное значение расхождения
   for (int x = 0; x < KolBarov; x++)
   {
      if(para1[x] > para2[x])
         Sch = NormalizeDouble(para1[x] - para2[x], Digits());
      else
         Sch = NormalizeDouble(para2[x] - para1[x], Digits());
         
      if (Sch > MaxRasxod)
         MaxRasxod = Sch;
   }
   //проверяем наличие ордеров----------------------------------------------------------------------------------------------------
   //ордера имеются
   if (PositionsTotal() > 0) 
   {
      //проверяем достигнут ли общий профит в пунктах----------------------------------------------------------------------------
      Money = AccountInfoDouble (ACCOUNT_PROFIT);
      TotalProfit = (Money / (10 * Lot));
      //профит достигнут
      if (TotalProfit >= Profit)
      {
         switch (KolDolivok)
         {
            case 1:
               if (TotalProfit >= Profit1Dolivka)
               {
                  CloseAllOrders();
                  Print ("Закрытие по общему профиту ", TotalProfit + " пунктов");
                  Print ("Профит в валюте ", Money);
                  TotalProfit = 0;
                  KolDolivok = 0;
                  StartDolivka1 = Dolivka1;
               }
               break;
            default:
               CloseAllOrders();
               Print ("Закрытие по общему профиту ", TotalProfit + " пунктов");
               Print ("Профит в валюте ", Money);
               TotalProfit = 0;
               break;
         }
         
         
         /*
         CloseAllOrders();
         Print ("Профит в валюте ", Money, ". Закрытие по общему профиту ", TotalProfit + " пунктов");
         TotalProfit = 0;*/
      }
      else
      {
         //проверяем общий убыток в пунктах--------------------------------------------------------------------------------------
         switch (KolDolivok)
         {
            case 1:
               if (TotalProfit <= Ubitok1Dolivka)
               {
                  CloseAllOrders();
                  Print ("Закрытие по общему профиту ", TotalProfit + " пунктов");
                  Print ("Профит в валюте ", Money);
                  TotalProfit = 0;
                  KolDolivok = 0;
                  StartDolivka1 = Dolivka1;
               }
               break;
            default:
               if (TotalProfit <= Ubitok)
               {
                  //если доливка разрешена, то доливаемся
                  if (StartDolivka1 == true)
                  {
                     //открываемся в ту же сторону относительно первой сделки
                     GOinfo.Select(Instr1);
                     if (GOinfo.PositionType() == POSITION_TYPE_BUY)
                     {
                        OrdersOpen_Sell_Buy (Instr2, Instr1, Lot * 2);
                        Print ("ДОЛИВКА. Продали ", Instr2, ", купили ", Instr1);
                        Print ("Профит ", TotalProfit + " пунктов");
                     }
                     else
                     {
                        OrdersOpen_Sell_Buy (Instr1, Instr2, Lot * 2);
                        Print ("ДОЛИВКА. Продали ", Instr1, ", купили ", Instr2);
                        Print ("Профит ", TotalProfit + " пунктов");
                     }
                        
                     KolDolivok ++;
                     StartDolivka1 = false;
                  }
                  //если доливка запрещена, то закрываем ордера
                  else
                  {
                     CloseAllOrders();
                     Print ("Закрытие по общему профиту ", TotalProfit + " пунктов");
                     Print ("Профит в валюте ", Money);
                     TotalProfit = 0;
                  }
               }
               break;
         }
         
         
         /*
         if (TotalProfit <= Ubitok)
         {
            //если доливка разрешена, то доливаемся
            if (Dolivka1 == true)
            {
               //открываемся в ту же сторону относительно первой сделки
               GOinfo.Select(Instr1);
               if (GOinfo.PositionType() == POSITION_TYPE_BUY)
                  OrdersOpen_Sell_Buy (Instr2, Instr1, Lot * 2);
               else
                  OrdersOpen_Sell_Buy (Instr1, Instr2, Lot * 2);
                  
               KolDolivok ++;
            }
            //если доливка запрещена, то закрываем ордера
            else
            {
               CloseAllOrders();
               Print("Профит в валюте ", Money, ". Закрытие по общему убытку ", TotalProfit + " пунктов");
               TotalProfit = 0;
            }
         }*/
      }
      //закрывем ордера если минимальное значение индикатора достигнуто------------------------------------------------------------
      if(Rasxod <= MinZnach && CloseMinZnach == true)
      {
         CloseAllOrders();
         Print("Закрытие по минимальному значению индикатора ", Rasxod);
         Print("Профит в валюте ", Money);
         TotalProfit = 0;
      }
   }
   //ордера отсутствуют------------------------------------------------------------------------------------------------------------
   else
   {
      //определяем есть ли сигнал от индикатора
      //продажа 1-го инструмента-----------------------------------------------------------------------------------------------------
      if (Rasxod >= MaxZnach && para1[0] > para2[0])
      {
         OrdersOpen_Sell_Buy (Instr1, Instr2, Lot);
         Print ("Продали ", Instr1, ", купили ", Instr2);
         Print ("Расхождение ", Rasxod);
      }
      //продажа 2-го инструмента---------------------------------------------------------------------------------------------------
      else
      {
         if (Rasxod >= MaxZnach)
         {
            OrdersOpen_Sell_Buy (Instr2, Instr1, Lot);
            Print ("Продали ", Instr2, ", купили ", Instr1);
            Print ("Расхождение ", Rasxod);
         }
      }
   }
   
   Comment ("\n  Профит = ", TotalProfit,
            "\n  Текущее расхождение = ", Rasxod,
            "\n  Максимальное расхождение = ", MaxRasxod);
}


//--------------------функции-----------------------------------------------------------------------------------
void OrdersOpen_Sell_Buy (string inst1, string inst2, double llot)
{
   //выставляем ордер на продажу
   ResetLastError();
   a = GO.Sell (llot, inst1);
   if (a == false || GetLastError() != 0)
   {
      Print ("Ордер вернул ошибку ", GetLastError());
      Print ("Ошибка торгового сервера ", GO.ResultRetcode());
   }
   
   //выставляем ордер на покупку
   ResetLastError();
   a = GO.Buy (llot, inst2);
   if (a == false || GetLastError() != 0)
   {
      Print ("Ордер вернул ошибку ", GetLastError());
      Print ("Ошибка торгового сервера ", GO.ResultRetcode());
      GO.PositionClose(inst1, 2);
   }
}



void CloseAllOrders ()
{
   GO.PositionClose(Instr1, 2);
   GO.PositionClose(Instr2, 2);
}