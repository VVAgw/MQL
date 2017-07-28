/*
Советник открывает бай и сел ордера через определенное количество пунктов закрывет 
прибыльный ордер и открывает новй в туже сторон. Ордера будут открываться до тех
пор пока не будет достигнут общий определенный профить всех ордеров с закрытыми, 
когда профит достигнут, то все ордера закрываются и все начинается заного.
*/


//+------------------------------------------------------------------+
//|                                                      Ves_Nol.mq4 |
//|                                                         Ves Volk |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Ves Volk"
#property link      ""

extern double TotalProfit   = 10.0;  //закрыть все ордера при достижении общего профита в пунктах
extern double Lot           = 1.0;   //лот
extern int Shag             = 20;    //ширина шага в пунктах для закрытия прибыльного ордера и открытия ордера

double CloseProfit;    //количество пунктов закрытых в плюс
int Napravlenie;       //направление открытия ордеров: 0 - нейтральное, 1 - покупка, 2 - продажа
int umn, PunktPlus;


int start()
  {
   if (Digits == 5)
      umn = 100000;
   if (Digits == 4)
      umn = 10000;
  
   //выводим общий баланс на экран
   Comment ("\n  Общий уровень прибыли с закрытыми ордерами ", AccountProfit () + CloseProfit,
            "\n  Закрыть все ордера при достижении прибыли в ", TotalProfit,
            "\n  Зафиксированная прибыль ", CloseProfit);
   
   
   //проверяем на наличие рыночных ордеров
   if (OrdersTotal () > 0)
      {
       //проверяем общий уровень прибыли в пунктах
         //если балас положительный, то закрываем все ордера
       if (AccountProfit () + CloseProfit > TotalProfit)
         {
          for (int a = OrdersTotal(); OrdersTotal() != 0; a--)
            {
             if (OrderSelect (a - 1, SELECT_BY_POS) == true)
               {
                if (OrderType () == OP_BUY)
                  OrderClose (OrderTicket(), OrderLots(), NormalizeDouble (MarketInfo (OrderSymbol (), MODE_BID), Digits), 2);
                if (OrderType () == OP_SELL)
                  OrderClose (OrderTicket(), OrderLots(), NormalizeDouble (MarketInfo (OrderSymbol (), MODE_ASK), Digits), 2);
                if (OrderType () > 1)
                  OrderDelete (OrderTicket ());
               }
             if (a == 0 && OrdersTotal () != 0)
               a = OrdersTotal ();
            }
         }
         
         else
         {
         //если прибыль отрицательная, то ищем прибыльные ордер
            //если открыто два рыночных ордера, то определяем направление движения
          if (OrdersTotal () == 2 && Napravlenie == 0)
            {
             for (int x = OrdersTotal (); x != -1; x--)
                if (OrderSelect (x, SELECT_BY_POS) == true)
                  if (OrderProfit () > 0)
                     {
                      if (OrderType () == OP_BUY) //если ордер бай
                        {
                         PunktPlus = (Bid - OrderOpenPrice ()) * umn;
                         if (PunktPlus >= Shag)
                           {
                            CloseProfit = CloseProfit + OrderProfit ();
                            Napravlenie = 1;
                            OrderClose (OrderTicket (), OrderLots (), NormalizeDouble (Bid, Digits), 2);
                            OrderSend (Symbol (), OP_BUY, Lot, NormalizeDouble (Ask,Digits), 2, 0, 0);
                            OrderSend (Symbol (), OP_SELL, Lot, NormalizeDouble (Bid,Digits), 2, 0, 0);
                            return;
                           }
                        }
                      if (OrderType () == OP_SELL)   //если ордер сел
                        {
                         PunktPlus = (OrderOpenPrice () - Ask) * umn;
                         if (PunktPlus >= Shag)
                           {
                            CloseProfit = CloseProfit + OrderProfit ();
                            Napravlenie = 2;
                            OrderClose (OrderTicket (), OrderLots (), NormalizeDouble (Ask, Digits), 2);
                            OrderSend (Symbol (), OP_BUY, Lot, NormalizeDouble (Ask,Digits), 2, 0, 0);
                            OrderSend (Symbol (), OP_SELL, Lot, NormalizeDouble (Bid,Digits), 2, 0, 0);
                            return;
                           }
                        }
                     }
            }
            //если направление движения определена и открыто больше двух рыночных ордеров
          if (OrdersTotal () > 2 && Napravlenie > 0)
            {
             if (Napravlenie == 1)  //если направление на бай
               {
                for (int c = OrdersTotal (); c != -1; c--)
                  if (OrderSelect (c, SELECT_BY_POS) == true)
                     {
                      if (OrderType () == OP_SELL)
                        continue;
                      if (OrderProfit () < 0)
                        continue;
                      else
                        {
                         PunktPlus = (Bid - OrderOpenPrice ()) * umn;
                         if (PunktPlus >= Shag)
                           {
                            CloseProfit = CloseProfit + OrderProfit ();
                            OrderClose (OrderTicket (), OrderLots (), NormalizeDouble (Bid, Digits), 2);
                            OrderSend (Symbol (), OP_BUY, Lot, NormalizeDouble (Ask,Digits), 2, 0, 0);
                            OrderSend (Symbol (), OP_SELL, Lot, NormalizeDouble (Bid,Digits), 2, 0, 0);
                            return;
                           }
                        }
                     }
               }
             if (Napravlenie == 2)  //если направление на сел
               {
                for (int bb = OrdersTotal (); bb != -1; bb--)
                  if (OrderSelect (bb, SELECT_BY_POS) == true)
                     {
                      if (OrderType () == OP_BUY)
                        continue;
                      if (OrderProfit () < 0)
                        continue;
                      else
                        {
                         PunktPlus = (OrderOpenPrice () - Ask) * umn;
                         if (PunktPlus >= Shag)
                           {
                            CloseProfit = CloseProfit + OrderProfit ();
                            OrderClose (OrderTicket (), OrderLots (), NormalizeDouble (Ask, Digits), 2);
                            OrderSend (Symbol (), OP_BUY, Lot, NormalizeDouble (Ask,Digits), 2, 0, 0);
                            OrderSend (Symbol (), OP_SELL, Lot, NormalizeDouble (Bid,Digits), 2, 0, 0);
                            return;
                           }
                        }
                     }
               }
            }
         }
      }
      //если рыночных ордеров нет, то окрываем ордера
   else
      {
       OrderSend (Symbol (), OP_BUY, Lot, NormalizeDouble (Ask,Digits), 2, 0, 0);
       OrderSend (Symbol (), OP_SELL, Lot, NormalizeDouble (Bid,Digits), 2, 0, 0);
       CloseProfit = 0;
       Napravlenie = 0;
      }
   return(0);
  }

