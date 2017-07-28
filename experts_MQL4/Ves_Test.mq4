/*
—оветник выставл€ем два лимитных ордера на рассто€нии Ўј√ј и подт€гивает их за ценой если они не стали рыночными.
*/
//+------------------------------------------------------------------+
//|                                                     Ves_Test.mq4 |
//|                                                         Ves Volk |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Ves Volk"
#property link      ""


extern double Ћот = 0.1;
extern int Ўаг = 100;
extern int “ейк = 150;
extern int —топ = 300;

int “икЋимит—ел, “икЋимитЅай, —четчик–ыночныхќрдеров, a;

int start()
  {
   //провер€ем наличие ордеров
   if (OrdersTotal() > 0)
      //есть ордера. провер€ем сколько
      //если один
      if (OrdersTotal() == 1)
         {
          if (OrderSelect(0,SELECT_BY_POS) == true)
            {
             if (OrderType() == OP_BUY)
               {
                a = OrderSend (Symbol(), OP_SELLLIMIT, Ћот, NormalizeDouble(Bid + Ўаг * Point, Digits), 2, NormalizeDouble(Bid + Ўаг * Point + —топ * Point, Digits), NormalizeDouble(Bid + Ўаг * Point - “ейк * Point, Digits));
                if (a == -1)
                   Print ("ќрдер вернул ошибку ", GetLastError());
                return;
               }
             else
               if (OrderType() == OP_SELL)
                  {
                   a = OrderSend (Symbol(), OP_BUYLIMIT, Ћот, NormalizeDouble(Bid - Ўаг * Point, Digits), 2, NormalizeDouble(Bid - Ўаг * Point - —топ * Point, Digits), NormalizeDouble(Bid - Ўаг * Point + “ейк * Point, Digits));
                   if (a == -1)
                     Print ("ќрдер вернул ошибку ", GetLastError());
                   return;
                  }
               else
                  if (OrderType() == OP_SELLLIMIT)
                     {
                      “ралимЋимитник (OrderTicket(), Ўаг);
                      a = OrderSend (Symbol(), OP_BUYLIMIT, Ћот, NormalizeDouble(Bid - Ўаг * Point, Digits), 2, NormalizeDouble(Bid - Ўаг * Point - —топ * Point, Digits), NormalizeDouble(Bid - Ўаг * Point + “ейк * Point, Digits));
                      if (a == -1)
                        Print ("ќрдер вернул ошибку ", GetLastError());
                      return;
                     }
                  else
                     if (OrderType() == OP_BUYLIMIT)
                        {
                         “ралимЋимитник (OrderTicket(), Ўаг);
                         a = OrderSend (Symbol(), OP_SELLLIMIT, Ћот, NormalizeDouble(Bid + Ўаг * Point, Digits), 2, NormalizeDouble(Bid + Ўаг * Point + —топ * Point, Digits), NormalizeDouble(Bid + Ўаг * Point - “ейк * Point, Digits));
                         if (a == -1)
                            Print ("ќрдер вернул ошибку ", GetLastError());
                         return;
                        }
                     else
                        return;
             
            }
         }//----------------------------
      //если два
      else
         {
          —четчик–ыночныхќрдеров = 0;
          for (int i = 0; i <= OrdersTotal() -1; i++)
            {
             if (OrderSelect(i, SELECT_BY_POS) == true)
               {
                if (OrderType() < 2)
                  {
                   —четчик–ыночныхќрдеров++;
                   “икЋимитЅай = 0;
                   “икЋимит—ел = 0;
                   continue;
                  }
                if (OrderType() == OP_BUYLIMIT)
                  “икЋимитЅай = OrderTicket();
                if (OrderType() == OP_SELLLIMIT)
                  “икЋимит—ел = OrderTicket();
               } 
            }
            
          //если нет рыночных ордеров
          if (—четчик–ыночныхќрдеров == 0)
            {
               “ралимЋимитник (“икЋимитЅай, Ўаг);
               “ралимЋимитник (“икЋимит—ел, Ўаг);
               return;
            }
          //если есть один рыночный ордер
          else
            if (—четчик–ыночныхќрдеров == 1)
               if (“икЋимитЅай > 0)
                  “ралимЋимитник (“икЋимитЅай, Ўаг);
               else
                  “ралимЋимитник (“икЋимит—ел, Ўаг);
            //если два рыночных ордера      
            else
               return;
         }
   
   //нет ордеров выставл€ем новые
   else
      {
       a = OrderSend (Symbol(), OP_BUYLIMIT, Ћот, NormalizeDouble(Bid - Ўаг * Point, Digits), 2, NormalizeDouble(Bid - Ўаг * Point - —топ * Point, Digits), NormalizeDouble(Bid - Ўаг * Point + “ейк * Point, Digits));
       if (a == -1)
         Print ("ќрдер вернул ошибку ", GetLastError());
       
       a = OrderSend (Symbol(), OP_SELLLIMIT, Ћот, NormalizeDouble(Bid + Ўаг * Point, Digits), 2, NormalizeDouble(Bid + Ўаг * Point + —топ * Point, Digits), NormalizeDouble(Bid + Ўаг * Point - “ейк * Point, Digits));
       if (a == -1)
         Print ("ќрдер вернул ошибку ", GetLastError());
      }
  
   return(0);
  }


//------------‘ункци€ трала лимит ордера---------------------
void “ралимЋимитник (int “икќрдера, int Ўаг“рала)
   {
    if (OrderSelect(“икќрдера, SELECT_BY_TICKET) == true)
      {
       if (OrderType() == OP_BUYLIMIT)
         if (Bid - OrderOpenPrice() > Ўаг“рала * Point)
            OrderModify (OrderTicket(), NormalizeDouble(Bid - Ўаг“рала * Point, Digits), NormalizeDouble(Bid - Ўаг“рала * Point - —топ * Point, Digits), NormalizeDouble(Bid - Ўаг“рала * Point + “ейк * Point, Digits), 0);
         else
            return;
            
       if (OrderType() == OP_SELLLIMIT)
         if (OrderOpenPrice() - Bid > Ўаг“рала * Point)
            OrderModify (OrderTicket(), NormalizeDouble(Bid + Ўаг“рала * Point, Digits), NormalizeDouble(Bid + Ўаг“рала * Point + —топ * Point, Digits), NormalizeDouble(Bid + Ўаг“рала * Point - “ейк * Point, Digits), 0);
         else
            return;
      }
   }