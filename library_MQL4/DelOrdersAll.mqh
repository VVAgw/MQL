/*
Функция закрывает все ордера и возворащает в случае успаха 1
*/

int DelOrdersAll ()
   {
    int ok = 0;
    for (int a = OrdersTotal(); OrdersTotal() != 0; a--)
      {
       if (OrderSelect (a, SELECT_BY_POS) == true)
         {
          if (OrderType () == OP_BUY)
            OrderClose (OrderTicket(), OrderLots(), NormalizeDouble (MarketInfo (OrderSymbol (), MODE_BID), Digits), 3);
          if (OrderType () == OP_SELL)
            OrderClose (OrderTicket(), OrderLots(), NormalizeDouble (MarketInfo (OrderSymbol (), MODE_ASK), Digits), 3);
          if (OrderType () > 1)
            OrderDelete (OrderTicket ());
         }
       if (a == 0 && OrdersTotal () != 0)
         a = OrdersTotal ();
      }
      ok = 1;
    return (ok);
   }