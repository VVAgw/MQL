/*
функция удаляет ордер по полученному тику. возвращает в случае успаха 1, неудачи -1
*/


int OrderClos (int tik)
   {
    int ok;
    bool a;
    int Tiket = tik;
    if (OrderSelect (Tiket, SELECT_BY_TICKET) == true)
      {
       if (OrderType () == OP_BUY){
         a = OrderClose (OrderTicket (), OrderLots (), NormalizeDouble (MarketInfo (OrderSymbol (), MODE_BID), Digits), 3);
         if (a == false) ok = -1; else ok = 1;}
       if (OrderType () == OP_SELL){
         a = OrderClose (OrderTicket (), OrderLots (), NormalizeDouble (MarketInfo (OrderSymbol (), MODE_ASK), Digits), 3);
         if (a == false) ok = -1; else ok = 1;}
       if (OrderType () > 1){
         a = OrderDelete (OrderTicket ()); if (a == false) ok = -1; else ok = 1;}
      }
    return (ok);
   }
   