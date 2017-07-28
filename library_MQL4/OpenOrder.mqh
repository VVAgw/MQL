/*
функция открывам любой ордер в зависимости от передаваемых параметров и возвращает тикет ордера
передаваемые параметры:
symb - название инстремента
lot - лот
stoploss - уровен стоплосса в пунктах
takeprofit - уровень тейкпрофита в пунктах
type - тип открываемого ордера
       openprice - уровень цены выставления отложенного ордера (только для отложенных ордеров, для рыночных
       ордеров тожно поставить 0)
*/


int OpenOrder (string symb, double lot, int stoploss, int takeprofit, int type, double openprice)
   {
    string Symb = symb;            //назвоние инструмента
    double Lot = lot;              //лот
    int SL = stoploss;             //стоплосс
    int TP = takeprofit;           //тейкпрофит
    int Type = type;               //тип открываемого ордера
    double OpenPrice = NormalizeDouble(openprice, Digits);  //цена установки отложенного ордера
    int Tiket;                     //возвращаемый номер тикета открытого ордера
    double take, stop;
    
    //открываем ордер бай
    if (Type == OP_BUY)
      {
       take = NormalizeDouble (Ask + TP * Point, Digits);
       stop = NormalizeDouble (Ask - SL * Point, Digits);
       Tiket = OrderSend (Symb, Type, Lot, NormalizeDouble (Ask,Digits), 3, stop, take);
       if (Tiket == -1)
         {
          Print ("Ордер вернул ошибку ", GetLastError());
          Comment ("Ордер вернул ошибку ", GetLastError());
          Tiket = 0;
         }
      }
      
   //открываем ордер сел
   if (Type == OP_SELL)
      {
       take = NormalizeDouble (Bid - TP * Point, Digits);
       stop = NormalizeDouble (Bid + SL * Point, Digits);
       Tiket = OrderSend (Symb, Type, Lot, NormalizeDouble (Bid, Digits), 3, stop, take);
       if (Tiket == -1)
         {
          Print ("Ордер вернул ошибку ", GetLastError());
          Comment ("Ордер вернул ошибку ", GetLastError());
          Tiket = 0;
         }
      }      

   //открываем отложенный ордер байстоп
   if (Type == OP_BUYSTOP)
      {
       take = NormalizeDouble (OpenPrice + TP * Point, Digits);
       stop = NormalizeDouble (OpenPrice - SL * Point, Digits);
       Tiket = OrderSend (Symb, Type, Lot, OpenPrice, 3, stop, take);
       if (Tiket == -1)
           {
            Print ("Ордер вернул ошибку ", GetLastError());
            Comment ("Ордер вернул ошибку ", GetLastError());
            Tiket = 0;
           }
      }
   
   //открываем отложенный ордер селстоп
   if (Type == OP_SELLSTOP)
      {
       take = NormalizeDouble (OpenPrice - TP * Point, Digits);
       stop = NormalizeDouble (OpenPrice + SL * Point, Digits);
       Tiket = OrderSend (Symb, Type, Lot, OpenPrice, 3, stop, take);
       if (Tiket == -1)
           {
            Print ("Ордер вернул ошибку ", GetLastError());
            Comment ("Ордер вернул ошибку ", GetLastError());
            Tiket = 0;
           }
      }
   
   //открывем отложенный ордел байлимит
   if (Type == OP_BUYLIMIT)
      {
       take = NormalizeDouble (OpenPrice + TP * Point, Digits);
       stop = NormalizeDouble (OpenPrice - SL * Point, Digits);
       Tiket = OrderSend (Symb, Type, Lot, OpenPrice, 3, stop, take);
       if (Tiket == -1)
           {
            Print ("Ордер вернул ошибку ", GetLastError());
            Comment ("Ордер вернул ошибку ", GetLastError());
            Tiket = 0;
           }
      }
   
   //открывем отложенный ордер селлимит
   if (Type == OP_SELLLIMIT)
      {
       take = NormalizeDouble (OpenPrice - TP * Point, Digits);
       stop = NormalizeDouble (OpenPrice + SL * Point, Digits);
       Tiket = OrderSend (Symb, Type, Lot, OpenPrice, 3, stop, take);
       if (Tiket == -1)
           {
            Print ("Ордер вернул ошибку ", GetLastError());
            Comment ("Ордер вернул ошибку ", GetLastError());
            Tiket = 0;
           }
      }
   
   return (Tiket);
   }
   