/*
универсальный мартин. ¬водим коридор, пунктов профита при закрытии всей серии, количество переворотов, коэфицент умножени€.
¬ советнике надо позоботитьс€ чтобы хватало средств дл€ выдерживани€ залога. ¬ советнике это не проедумотрено. »наче ордера при не хватке средств
не будут открыватьс€
*/
#property copyright "Ves Volk"
#property link      ""


extern double Ћот = 0.01;
extern int  оридор = 200;
extern int ѕунктѕрофит = 30;
extern int ѕрофит1ордера = 200;
extern int ‘икс—топ = -50;
extern int  оэф”мн = 8;
extern int  олѕереворотов = 2;
extern bool ¬рем€–аботы = false;
extern int Ќачало–аботы„ас = 6;
extern int  онец–аботы„ас = 19;


int “икет1гоќрдера,  онтрќшибок, –еальныеѕеревороты;
double ÷ена”становкиќтлќрдера;
datetime  онтроль¬ремени;

int start()
  {
   //провер€ем наличие ордеров--------------------------------------------------------
      //есть ордера
   if (OrdersTotal () > 0)
   {
      //если рыночный ордер один
      if (OrdersTotal() == 1)
         //провер€ем закрылс€ ли рервый ордер по профиту, если да то закрываем все ордера
         if (OrderSelect(“икет1гоќрдера, SELECT_BY_TICKET) == true)
            if (OrderCloseTime() > 0)
               «акрытьќрдера();
      //вычисл€ем сколько переворотов случилось
      –еальныеѕеревороты = OrdersTotal() - 1;
      //провер€ем можно ли еще переворачивать-----------------------------------------
         //можно переворачивать
      if (–еальныеѕеревороты <  олѕереворотов)
      {
         //вычисл€ем тикет позднего ордера
          онтроль¬ремени = 0;
         int a = 0;
         for (int i = OrdersTotal(); i != -1; i--)
            if (OrderSelect (i, SELECT_BY_POS) == true)
            {
               if (a == 0)
               {
                  a = 1;
                   онтроль¬ремени = TimeLocal() - OrderOpenTime();
                   онтрќшибок = OrderTicket();
                  continue;
               }
               
               if (TimeLocal() - OrderOpenTime() <  онтроль¬ремени)
               {
                   онтроль¬ремени = TimeLocal() - OrderOpenTime();
                   онтрќшибок = OrderTicket();
               }
            }
            
         //вычисл€ем тип позднего ордера---------------------------------------------------
         if (OrderSelect ( онтрќшибок, SELECT_BY_TICKET) == true)
            //ордер рыночный
            if (OrderType() < 2)
            {
               //убираем профит с первого оредра
               if (OrdersTotal() == 2)
                  OrderModify (“икет1гоќрдера, 0, 0, 0, 0);
               //выставл€ем отложенный ордер---------------------------------------------------
               if (OrderType() == OP_SELL)
               {
                   онтрќшибок = OrderSend (Symbol(), OP_BUYSTOP, OrderLots() *  оэф”мн, NormalizeDouble (OrderOpenPrice() +  оридор * Point, Digits), 2, 0, 0);
                  if ( онтрќшибок == -1)
                  {
                     Print ("ќрдер вернул ошибку ", GetLastError());
                     return;
                  }
               }
               else
               {
                   онтрќшибок = OrderSend (Symbol(), OP_SELLSTOP, OrderLots() *  оэф”мн, NormalizeDouble (OrderOpenPrice() -  оридор * Point, Digits), 2, 0, 0);
                  if ( онтрќшибок == -1)
                  {
                     Print ("ќрдер вернул ошибку ", GetLastError());
                     return;
                  }
               }
            }
            //отложенный ордер
            else
            {
               //если рыночный ордер один то он должен закрытьс€ по тейку
               if (OrdersTotal() == 2)
                  return;
               //вычисл€ем тикет последнего рыночного ордера
                онтроль¬ремени = 0;
               int b = 0;
               for (int i2 = OrdersTotal(); i2 != -1; i2--)
                  if (OrderSelect (i2, SELECT_BY_POS) == true)
                  {
                     if (OrderType() > 1)
                        continue;
                     if (b == 0)
                     {
                        b = 1;
                         онтроль¬ремени = TimeLocal() - OrderOpenTime();
                         онтрќшибок = OrderTicket();
                        continue;
                     }
               
                     if (TimeLocal() - OrderOpenTime() <  онтроль¬ремени)
                     {
                         онтроль¬ремени = TimeLocal() - OrderOpenTime();
                         онтрќшибок = OrderTicket();
                     }
                  }
               //провер€ем профит последнего рыночного ордера------------------------------------------------------
               if (OrderSelect ( онтрќшибок, SELECT_BY_TICKET) == true)
                  //если сел ордер
                  if (OrderType() == OP_SELL)
                  {
                     //если профит отрицательный то выходим
                     if (OrderOpenPrice() - Ask <= 0)
                        return;
                     //если профит положительный   
                     else
                        if (OrderOpenPrice() - Ask >= ѕунктѕрофит * Point)
                           «акрытьќрдера();
                  }
                  //если бай ордер      
                  else
                  {
                     //если профит отрицательный то выходим
                     if (Bid - OrderOpenPrice() <= 0)
                        return;
                     //если профит положительный   
                     else
                        if (Bid - OrderOpenPrice() >= ѕунктѕрофит * Point)
                           «акрытьќрдера();
                   }
            }
      }
         //нельз€ переворачивать-------------------------------------------------------------------------------------
      else
      {
         //вычисл€ем тикет позднего ордера
          онтроль¬ремени = 0;
         int c = 0;
         for (int i3 = OrdersTotal(); i3 != -1; i3--)
            if (OrderSelect (i3, SELECT_BY_POS) == true)
            {
               if (c == 0)
               {
                  c = 1;
                   онтроль¬ремени = TimeLocal() - OrderOpenTime();
                   онтрќшибок = OrderTicket();
                  continue;
               }
               
               if (TimeLocal() - OrderOpenTime() <  онтроль¬ремени)
               {
                   онтроль¬ремени = TimeLocal() - OrderOpenTime();
                   онтрќшибок = OrderTicket();
               }
            }
         
         //провер€ем тип последнего оредра----------------------------------------------------------------------
         if (OrderSelect ( онтрќшибок, SELECT_BY_TICKET) == true)
            //поздний ордер €вл€етс€ рыночным
            if (OrderType() < 2)
               //сел
               if (OrderType() == OP_SELL)
               {
                  //если профит отрицательный
                     if (OrderOpenPrice() - Ask <= ‘икс—топ * Point)
                        «акрытьќрдера();
                     //если профит положительный   
                     else
                        if (OrderOpenPrice() - Ask >= ѕунктѕрофит * Point)
                           «акрытьќрдера();
               }
               //бай
               else
               {
                  //если профит отрицательный
                     if (Bid - OrderOpenPrice() <= ‘икс—топ * Point)
                        «акрытьќрдера();
                     //если профит положительный   
                     else
                        if (Bid - OrderOpenPrice() >= ѕунктѕрофит * Point)
                           «акрытьќрдера();
                }
            //поздний ордер €вл€етс€ отложенным
            else
            {
               //вычисл€ем тикет последнего рыночного ордера
                онтроль¬ремени = 0;
               int bb = 0;
               for (int i4 = OrdersTotal(); i4 != -1; i4--)
                  if (OrderSelect (i4, SELECT_BY_POS) == true)
                  {
                     if (OrderType() > 1)
                        continue;
                     if (bb == 0)
                     {
                        bb = 1;
                         онтроль¬ремени = TimeLocal() - OrderOpenTime();
                         онтрќшибок = OrderTicket();
                        continue;
                     }
               
                     if (TimeLocal() - OrderOpenTime() <  онтроль¬ремени)
                     {
                         онтроль¬ремени = TimeLocal() - OrderOpenTime();
                         онтрќшибок = OrderTicket();
                     }
                  }
                  
               //провер€ем последний рыночный ордер на профит---------------------------------------------------------------
               if (OrderSelect ( онтрќшибок, SELECT_BY_TICKET) == true)
                  //если сел ордер
                  if (OrderType() == OP_SELL)
                  {
                     //если профит отрицательный то выходим
                     if (OrderOpenPrice() - Ask <= 0)
                        return;
                     //если профит положительный   
                     else
                        if (OrderOpenPrice() - Ask >= ѕунктѕрофит * Point)
                           «акрытьќрдера();
                  }
                  //если бай ордер      
                  else
                  {
                     //если профит отрицательный то выходим
                     if (Bid - OrderOpenPrice() <= 0)
                        return;
                     //если профит положительный   
                     else
                        if (Bid - OrderOpenPrice() >= ѕунктѕрофит * Point)
                           «акрытьќрдера();
                   }
            }
         
      }
   }
      //нет ордеров-------------------------------------------------------------------------------------------------------
   else
   {
      //провер€ем включен ли контроль времени
      if (¬рем€–аботы)
      {
         //если врем€ не рабочее, то выходим
         if (Hour() < Ќачало–аботы„ас || Hour() >  онец–аботы„ас)
            return;
      }
      //выставл€ем ордеров
      “икет1гоќрдера = OrderSend (Symbol(), OP_BUY, Ћот, NormalizeDouble(Ask, Digits), 2, 0, 0);
      if (“икет1гоќрдера == -1)
      {
         Print ("ќрдер вернул ошибку ", GetLastError());
         return;
      }
      
      if (OrderSelect (“икет1гоќрдера, SELECT_BY_TICKET) == true)
         ÷ена”становкиќтлќрдера = OrderOpenPrice();
      
      OrderModify (“икет1гоќрдера, 0, 0, NormalizeDouble (÷ена”становкиќтлќрдера + ѕрофит1ордера * Point, Digits), 0);
      
       онтрќшибок = OrderSend (Symbol(), OP_SELLSTOP, Ћот *  оэф”мн, NormalizeDouble(÷ена”становкиќтлќрдера -  оридор * Point, Digits), 2, 0, 0);
      if ( онтрќшибок == -1)
      {
         Print ("ќрдер вернул ошибку ", GetLastError());
         OrderClose (“икет1гоќрдера, Ћот, NormalizeDouble(Bid, Digits), 2);
         return;
      }
   }    
   
   return(0);
  }




//---------------------функци€ закрыти€ всех ордеров------------------------------------------------------------------------
void «акрытьќрдера ()
{
   for (int del = OrdersTotal(); del != -1; del --)
      if (OrderSelect (del, SELECT_BY_POS) == true)
         if (OrderType() == OP_BUY)
            OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Bid, Digits), 2);
         else
            if (OrderType() == OP_SELL)
               OrderClose(OrderTicket(), OrderLots(), NormalizeDouble(Ask, Digits), 2);
            else
               OrderDelete(OrderTicket());
}