/*
Советник работает по 3 индикаторам:
1 - две скользящие средние
2 - МАКД
3 - Стохастик
кодгда две машки пересекаются и макд и стохастик находятся в зоне совершения сделки 
окрыватся ордер в зависимости от направления
Для работы индикатор требуется библиотека #include <OpenOrder.mqh>
*/

#property copyright "Ves"
#property link      ""
#include <OpenOrder.mqh>
#include <DelOrdersAll.mqh>
#include <OrderClos.mqh>

extern int TP = 20;       //тейк профит 
extern int SL = 10;       //стоплосс
extern double Lot = 0.1;  //лот

//SMA 26 and EMA 13
double SMA[4], EMA[4];  //значение индикатора на последних 4 барах
extern int SMAm = 26;   //значение медленной скользящей 
extern int EMAb = 13;   //значение быстрой скользящей
bool MAbuy = false;     //сигнал на покупку 
bool MAsell = false;    //сигнал на продажу

//MACD 12,26,9
double MACDmin, MACDmax;           //уровни на индикаторе за которыми тожно открывать сделку
double MACDur[170];                //массив для расчета уровней
double MACD[4], MACDsignal[4];     //значение индикатора на последних 4 барах
extern int fastEMA = 12;           //значение быстрой скользящей
extern int slowEMA = 26;           //значение медлоенной скользящей
extern int signalEMA = 9;          //значение сигнальной линии
bool MACDbuy = false;              //сигнал на покупку 
bool MACDsell = false;             //сигнал на продажу
extern int k = 70;                 //уровень выше/ниже которого можно открывать сделку по сигналу
                                   //в процентном соотношении
//Stach 5,3,3
double Stoch[4], Stochsignal[4];   //значение индикатора на последних 4 барах
extern int Kperiod = 5;
extern int Dperiod = 3;
extern int slow = 3;
extern int Stochmax = 85;          //уровень за которым можно открывать сделки на сел
extern int Stochmin = 15;          //уровень за которым можно открывать сделки на бай
bool Stochbuy = false;             //сигнал на покупку 
bool Stochsell = false;            //сигнал на продажу

int buy, sell;  //ордера

int start()
  {
   SMAf ();
   MACDf ();
   Stochf ();
   //если ордер закрылся по стопу то обнуляем тикет
   if (OrderSelect (buy, SELECT_BY_TICKET) == true)
      if (OrderCloseTime () > 0)
         buy = 0;
   if (OrderSelect (sell, SELECT_BY_TICKET) == true)
      if (OrderCloseTime () > 0)
         sell = 0;
   
   //открываем ордер при сигнале
   if (MACDbuy == true && Stochbuy == true && MAbuy == true && buy == 0)
      buy = OpenOrder (Symbol (), Lot, SL, TP, OP_BUY, 0);
      
   if (MACDsell == true && Stochsell == true && MAsell == true && sell == 0)
      sell = OpenOrder (Symbol (), Lot, SL, TP, OP_SELL, 0);
      
      
   return(0);
  }



void SMAf ()
   {
    //присваиваем значение индикаторным линиям
    for (int i = 0; i < 4; i++)
      {
       SMA[i] = iMA (Symbol (), 0, SMAm, 0, MODE_SMA, PRICE_CLOSE, i);
       EMA[i] = iMA (Symbol (), 0, EMAb, 0, MODE_EMA, PRICE_CLOSE, i);
      }
    //проверяем условие на бай
    if (SMA[3] > EMA[3] && SMA[1] <  EMA[1])
      MAbuy = true;
    else MAbuy = false;
    //проверяем условие на сел
    if (SMA[3] < EMA[3] && SMA[1] > EMA[1])
      MAsell = true;
    else MAsell = false;
   }
   
void MACDf ()
   {
    for (int a = 0; a < 4; a++)
      {
       //присваиваем цену индикатора на последних 4 барах
       MACD[a] = iMACD (Symbol (), 0, fastEMA, slowEMA, signalEMA, PRICE_CLOSE, MODE_MAIN, a);
       MACDsignal[a] = iMACD (Symbol (), 0, fastEMA, slowEMA, signalEMA, PRICE_CLOSE, MODE_SIGNAL, a);
      }
    //пороверяем условие на бай
    if (MACD[1] > MACDsignal[1] && MACDsignal[1] < 0)
      MACDbuy = true;
    else MACDbuy = false;
    //проверяем условие на сел
    if (MACD[1] < MACDsignal[1] && MACDsignal[1] > 0)
      MACDsell = true;
    else MACDsell = false;
   }
   
void Stochf ()
   {
    //узнаем значение индикатора на последних 4 барах
    for (int b = 0; b < 4; b++)
      {
       Stoch[b] = iStochastic (Symbol (), 0, Kperiod, Dperiod, slow, MODE_SMA, PRICE_CLOSE, MODE_MAIN, b);
       Stochsignal[b] = iStochastic (Symbol (), 0, Kperiod, Dperiod, slow, MODE_SMA, PRICE_CLOSE, MODE_SIGNAL, b);
      }
    //проверяем условие на бай
    if (Stoch[1] > Stochsignal[1] && Stochsignal[1] < 0)
      Stochbuy = true;
    else Stochbuy = false;
    //проверяем условие на сел
    if (Stoch[1] < Stochsignal[1] && Stochsignal[1] > 0)
      Stochsell = true;
    else Stochsell = false;
   }

