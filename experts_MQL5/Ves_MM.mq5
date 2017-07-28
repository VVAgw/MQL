/*
Советник покупает или продает пары и доливается к прибыльной паре
*/
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.mql5.com"
#property version   "1.00"
#include <Trade\Trade.mqh>          //подключение библиотеки для использования торговых классов
#include <Trade\PositionInfo.mqh>   //подключение библиотеки для использования информации по открытым позициям


input string Para1 = "EURUSD.m";    //первая пара
input ENUM_POSITION_TYPE TypePara1 = POSITION_TYPE_BUY;    //тип открытия перовой пары

input string Para2 = "GBPUSD.m";    //вторая пара
input ENUM_POSITION_TYPE TypePara2 = POSITION_TYPE_SELL;   //тип открытия второй пары

input string Para3 = "EURGBP.m";    //третья пара
input ENUM_POSITION_TYPE TypePara3 = POSITION_TYPE_BUY;    //тип открытия третьей пары

input string Para4 = "GBPCHF.m";    //четвертая пара
input ENUM_POSITION_TYPE TypePara4 = POSITION_TYPE_BUY;    //тип открытия четвертой пары

input string Para5 = "EURNZD.m";    //пятая пара
input ENUM_POSITION_TYPE TypePara5 = POSITION_TYPE_BUY;     //тип открытия пятой пары

input string Para6 = "NZDCHF.m";    //шестая пара
input ENUM_POSITION_TYPE TypePara6 = POSITION_TYPE_BUY;     //тип открытия шестой пары

input double Lot = 1.0;             //лот
input int Profit = 100;             //общий профит для закрытия сделок
input bool TypeDD = false;          //тип доливки: true - с шагом значения "1-я доливка"(DD), false - средняя цена
input int DD  = 100;                //1-я доливка
input int DD2 = 100;                //2-я доливка
input int DD3 = 200;                //3-я доливка
input bool StopProfitPara = false;  //включить фиксацию определенного профита пары
input int ProfitPara = 500;         //уровень профита закрытия пары. Работает при StopProfitPara = truy;
input bool revers = false;          //открывать в обратном направлении пару после переоткрытия
input bool lotStart = false;        //устанавливать начальный лот после переоткрытия 
input bool Time = false;            //работать в определенное время
input int timeStart = 7;            //с какого часа работать
input int timeFinish = 18;          //после какого часа заканчивать
input int Piatnica = 17;            //в пятницу после какога часа заканчивать
input bool TimePeriod = false;      //работа советника после каждого открытия бара текущего таймфрейма
input bool ProfitControl = false;   //проверять профит постоянно, а не при каждом открытии бара. Работает когда TimePeriod = true

CTrade GO;              //объект класса для торговых функций     
CPositionInfo GOinfo;   //объект класса для получения информации по открытым позициям
MqlDateTime timeServer; //объект структуры для получения времени сервера

double PricePara1, PricePara2, PricePara3, PricePara4, PricePara5, PricePara6;
int qpara1, qpara2, qpara3, qpara4, qpara5, qpara6;
int AddDD1, AddDD2, AddDD3, AddDD4, AddDD5, AddDD6;
int BarsControl;

void OnTick()
{
   //если нет открытых позиций-------------------------------------------------------------------------------
   if (PositionsTotal() == 0)
   {
      //проверям торговое ли время если нет. то выходим если функция включена
      if (Time == true)
         TimeClose();
      
      //выставляем позиции
      if (Para1 != "")
         OpenPosition (Para1, TypePara1, PricePara1, qpara1);
      if (Para2 != "")
         OpenPosition (Para2, TypePara2, PricePara2, qpara2);
      if (Para3 != "")
         OpenPosition (Para3, TypePara3, PricePara3, qpara3);
      if (Para4 != "")
         OpenPosition (Para4, TypePara4, PricePara4, qpara4);
      if (Para5 != "")
         OpenPosition (Para5, TypePara5, PricePara5, qpara5);
      if (Para6 != "")
         OpenPosition (Para6, TypePara6, PricePara6, qpara6);
      
      BarsControl = Bars (Symbol(), PERIOD_CURRENT);
   }
   //есть открытые позиции------------------------------------------------------------------------------------------
   else
   {
      //проверяем достигнул ли профит если функция вкючена
      if (ProfitControl == true)
         if (AccountInfoDouble(ACCOUNT_PROFIT) >= Profit)
            ProfitPlusAllClose();
      
      //работа по завершении бара(определенного времени) если функция включена
      if (TimePeriod == true)
         NewBarGoExp();
      
      //проверяем достигнул ли профит---------------------------------------------------------------------------------
      if (AccountInfoDouble(ACCOUNT_PROFIT) >= Profit)
         ProfitPlusAllClose();
      //если профит не достигнут
      else
      {
         //проверяем профит на парах
         if (GOinfo.Select(Para1) == true)
            ControlPosition (Para1, PricePara1, qpara1, AddDD1);
         if (GOinfo.Select(Para2) == true)
            ControlPosition (Para2, PricePara2, qpara2, AddDD2);
         if (GOinfo.Select(Para3) == true)
            ControlPosition (Para3, PricePara3, qpara3, AddDD3);
         if (GOinfo.Select(Para4) == true)
            ControlPosition (Para4, PricePara4, qpara4, AddDD4);
         if (GOinfo.Select(Para5) == true)
            ControlPosition (Para5, PricePara5, qpara5, AddDD5);
         if (GOinfo.Select(Para6) == true)
            ControlPosition (Para6, PricePara6, qpara6, AddDD6);
      }
   }
}
  
   
//-------------------------------------------------------ФУНКЦИИ---------------------------------------------------------


//проверям торговое ли время если нет. то выходим если функция включена
void TimeClose ()
{
   TimeCurrent(timeServer);
   if (timeServer.day_of_week == 5 && timeServer.hour > Piatnica)
      return;
   if (timeServer.hour < timeStart || timeServer.hour > timeFinish)
      return;        
}


//проверяем достигнул ли профит если достигнут закрываем-------------------------------
void ProfitPlusAllClose ()
{
   double pp = AccountInfoDouble(ACCOUNT_PROFIT);
   if (GOinfo.Select(Para1) == true)
      GO.PositionClose(Para1, 2);
   if (GOinfo.Select(Para2) == true)
      GO.PositionClose(Para2, 2);
   if (GOinfo.Select(Para3) == true)
      GO.PositionClose(Para3, 2);
   if (GOinfo.Select(Para4) == true)
      GO.PositionClose(Para4, 2);
   if (GOinfo.Select(Para5) == true)
      GO.PositionClose(Para5, 2);
   if (GOinfo.Select(Para6) == true)
      GO.PositionClose(Para6, 2);
   Print ("Закрытие всех позиций. Профит равен ", pp);
   AddDD1 = 0;
   AddDD2 = 0;
   AddDD3 = 0;
   AddDD4 = 0;
   AddDD5 = 0;
   AddDD6 = 0;
}   


//работа по завершении бара(определенного времени) если функция включена--------------------------
void NewBarGoExp ()
{
   //если новый бар не появился, то выходим
   if (Bars (Symbol(), PERIOD_CURRENT) == BarsControl)
   {
      return;
   }
   //если новый бар появился
   else
   {
      BarsControl = Bars (Symbol(), PERIOD_CURRENT);
   }
}  


//функция доливки в прибыльную пару-----------------------------------------------------------
void ControlPosition (string para, double &pricepara, int &qpara, int &addDD)
{
   if (GOinfo.Profit() > 0)
   {
      //закрываем пару и открываем пару при определенном профите. если функция включена
      if (StopProfitPara == true)
      {
         double lot = GOinfo.Volume();
         double profit = GOinfo.Profit();
         ENUM_POSITION_TYPE type = GOinfo.PositionType();
         bool a;
         
         //делаем реверс если функция включена
         if (revers == true)
         {
            if (type == POSITION_TYPE_BUY)
               type = POSITION_TYPE_SELL;
            else
               type = POSITION_TYPE_BUY;
         }
         
         //делаем лот начальным если функция включена
         if (lotStart == true)
         {
            lot = LotBalance (para, Lot);
         }
         
         if (GOinfo.Profit() >= ProfitPara)
         {
            GO.PositionClose (para, 2);
            Print ("Закрытие. Профит пары ", para, " ", profit, ". Лот пары ", GOinfo.Volume(), ". Тип позиции ", GOinfo.PositionType());
            ResetLastError();
            
            if (type == POSITION_TYPE_BUY)
            {
               a = GO.Buy (lot, para);
               if (a == false || GetLastError() != 0)
               {
                  Print ("Ордер вернул ошибку ", GetLastError(), ". Ошибка торгового сервера ", GO.ResultRetcode());
                  return;
               }
               Print ("Переоткрытие пары ", para, " с лотом ", lot, ". Тип позиции ", type);
            }
            else
            {
               a = GO.Sell (lot, para);
               if (a == false || GetLastError() != 0)
               {
                  Print ("Ордер вернул ошибку ", GetLastError(), ". Ошибка торгового сервера ", GO.ResultRetcode());
                  return;
               }
               Print ("Переоткрытие пары ", para, " с лотом ", lot, ". Тип позиции ", type);
            }
         }
      }
      //если позиция бай
      if (GOinfo.PositionType() == POSITION_TYPE_BUY)
      {
         if (StringToDouble (DoubleToString ((SymbolInfoDouble(para, SYMBOL_ASK) - pricepara / qpara), 5)) * 100000 >= DD + addDD)
         {
                  ResetLastError();
                  double ask = SymbolInfoDouble (para, SYMBOL_ASK);
                  bool b = GO.Buy(LotBalance (para, Lot), para);
                  if (b == false || GetLastError() != 0)
                  {
                     Print ("Ордер вернул ошибку ", GetLastError(), ". Ошибка торгового сервера ", GO.ResultRetcode());
                     return;
                  }
                  pricepara = pricepara + ask;
                  qpara++;
                  
                  //увеличиваем доливку зависит от включения функции
                  if (TypeDD == false)
                  {
                     if (qpara >= 3 && qpara < 10)
                     {
                        addDD = DD2;
                     }
                     else
                     {
                        if (qpara >= 10)
                        addDD = DD2 + DD3;
                     }
                  }
                  else
                  {
                     addDD = addDD + DD;
                  }
   
                  Print("Доливка по ", para, ". Ордер номер ", qpara, ". Диапазон доливки равен ", addDD);      
         }
      }
      //если позиция сел
      else
      {
         if (StringToDouble (DoubleToString ((pricepara / qpara - SymbolInfoDouble(para, SYMBOL_BID)), 5)) * 100000 >= DD + addDD)
         {
                  ResetLastError();
                  double bid = SymbolInfoDouble (para, SYMBOL_BID);
                  bool b = GO.Sell(LotBalance (para, Lot), para);
                  if (b == false || GetLastError() != 0)
                  {
                     Print ("Ордер вернул ошибку ", GetLastError(), ". Ошибка торгового сервера ", GO.ResultRetcode());
                     return;
                  }
                  pricepara = pricepara + bid;
                  qpara++;
                  
                  //увеличиваем доливку зависит от включения функции
                  if (TypeDD == false)
                  {
                     if (qpara >= 3 && qpara < 10)
                     {
                        addDD = DD2;
                     }
                     else
                     {
                        if (qpara >= 10)
                           addDD = DD2 + DD3;
                     }
                  }
                  else
                  {
                     addDD = addDD + DD;
                  }
                  
                  Print("Доливка по ", para, ". Ордер номер ", qpara, ". Диапазон доливки равен ", addDD);
         }
      }
   }
}


//функция для открытия первой позиции------------------------------------------------------
void OpenPosition (string para, ENUM_POSITION_TYPE type, double &pricepara, int &qpara)
{
   //открываем бай
   if (type == POSITION_TYPE_BUY)
   {
         pricepara = SymbolInfoDouble (para, SYMBOL_ASK);
         ResetLastError();
         bool a = GO.Buy (LotBalance (para, Lot), para);
         if (a == false || GetLastError() != 0)
         {
            Print ("Ордер вернул ошибку ", GetLastError(), ". Ошибка торгового сервера ", GO.ResultRetcode());
            return;
         }
         Print("Открыли позицию ", para);
         qpara = 1;
   }
   //открываем сел
   else
   {
         pricepara = SymbolInfoDouble (para, SYMBOL_BID);
         ResetLastError();
         bool a = GO.Sell (LotBalance (para, Lot), para);
         if (a == false || GetLastError() != 0)
         {
            Print ("Ордер вернул ошибку ", GetLastError(), ". Ошибка торгового сервера ", GO.ResultRetcode());
            return;
         }
         Print("Открыли позицию ", para);
         qpara = 1;
   }
}    


//функция уравновешивания стоимости пункта валютных пар-----------------------------------------------------
double LotBalance (string para, double InputLot)
{
   double PipPrice = 10 * InputLot;    //стоимость одного пункта при объявленном лоте во внешней переменной приминительно к обратной паре xxxUSD
   double llot = 0; 
   double pips = 0;
   //пара с обратной котировкой xxxUSD
   if (SymbolInfoString (para, SYMBOL_CURRENCY_PROFIT) == "USD")
   {
      llot = InputLot;
   }
   //пара с прямой котировкой USDxxx
   else
   {
      if (SymbolInfoString (para, SYMBOL_CURRENCY_BASE) == "USD")
      {
         for (double l = 0.01; true; l = l + 0.01)
         {
            pips = SymbolInfoDouble (para, SYMBOL_TRADE_CONTRACT_SIZE)  *  SymbolInfoDouble (para, SYMBOL_TRADE_TICK_SIZE)  /  SymbolInfoDouble (para, SYMBOL_BID)  *  l  *  10;    //домнажаем на 10 если есть пятизнак
            if (pips > PipPrice)
               break;
            llot = l;
         }
      }
      //если кросс пара 
      else
      {
         double sym = SymbolInfoDouble (SymbolInfoString (para, SYMBOL_CURRENCY_BASE) + "USD.m", SYMBOL_BID);
         if (sym == 0)
            sym = SymbolInfoDouble ("USD" + SymbolInfoString (para, SYMBOL_CURRENCY_BASE) + ".m", SYMBOL_BID);
         
         for (double l = 0.01; true; l = l + 0.01)
         {
            pips = SymbolInfoDouble (para, SYMBOL_TRADE_CONTRACT_SIZE)  *  SymbolInfoDouble (para, SYMBOL_TRADE_TICK_SIZE)  *  sym  /  SymbolInfoDouble (para, SYMBOL_BID)  *  l  *  10;    //домнажаем на 10 если есть пятизнак
            if (pips > PipPrice)
               break;
            llot = l;
         }
      }
   }
   return (StringToDouble(DoubleToString (llot, 2)));
}