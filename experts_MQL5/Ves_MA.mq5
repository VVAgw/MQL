//+------------------------------------------------------------------+
//|                                                       Ves_MA.mq5 |
//|                                                          BigfOOt |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "BigfOOt"
#property link      "http://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

input int TP = 30;
input int SL = 15;
input double Lot = 0.1;

input int BistSred = 20;    //усреднение быстрой средней
input int MedlSred = 40;    //усреднение медленной средней

int HendlBistSred;          //хендл быстрой средней
int HendMedlSred;           //хендл медленной средней
double BistMA[], MedlMA[];  //массивы для хранения значей средних

MqlTradeRequest   TorgPrikaz = {0};   //структура данных для отправки торговых прикозов        
MqlTradeResult    TorgRezult = {0};   //структура данных о результатах выполнения торгового приказа

int OnInit()
  {
   //присваиваем хендлы индикаторов переменным
   HendlBistSred = iMA (_Symbol, _Period, BistSred, 0, MODE_SMA, PRICE_CLOSE);
   HendMedlSred = iMA (_Symbol, _Period, MedlSred, 0, MODE_SMA, PRICE_CLOSE);
   return(0);
  }

void OnDeinit(const int reason)
  {
   //освобождаем хэндлы индикаторов
   IndicatorRelease (HendlBistSred);
   IndicatorRelease (HendMedlSred);
  }


void OnTick()
  {
  
//+----------------------------------------------------------------------------------+
//| блок данных от индикаторов                                                       |                         
//|----------------------------------------------------------------------------------+                                                         
//|делаем чтобы росчет в массиве с данными от буфера индикатора шел справа на лева как MQL4
   ArraySetAsSeries(BistMA,true);
   ArraySetAsSeries(MedlMA,true);
   
   //привязываем данные индикаторного буфера к массиву через хэндл
   CopyBuffer (HendlBistSred, 0, 0, 5, BistMA);
   CopyBuffer (HendMedlSred, 0, 0, 5, MedlMA);                                           
//----------------------------------------------------------------------------------
   
   //проверяем количество открытих ордеров на валютной паре
   if (PositionSelect (_Symbol) == true) //есть открый ордер
      {
       //проверяем тип оредра
       if (PositionGetInteger (POSITION_TYPE) == POSITION_TYPE_BUY)  //если открыт ордер бай
         {
          //проверяем есть ли сигнал от индикатора на продажу
          if (BistMA[1] < MedlMA[1] && BistMA[3] > MedlMA[3])  //есть сигнал
            {
             //закрываем оредр бай и открываем ордер на продажу
             TorgPrikaz.action = TRADE_ACTION_DEAL;
             TorgPrikaz.magic  = 102;
             TorgPrikaz.symbol = _Symbol;
             TorgPrikaz.volume = Lot * 2;
             TorgPrikaz.price  = NormalizeDouble (SymbolInfoDouble (Symbol (), SYMBOL_BID), _Digits);
             TorgPrikaz.sl     = NormalizeDouble (SymbolInfoDouble (Symbol (), SYMBOL_BID) + SL * SymbolInfoDouble (Symbol (), SYMBOL_POINT), _Digits);
             TorgPrikaz.tp     = NormalizeDouble (SymbolInfoDouble (Symbol (), SYMBOL_BID) - TP * SymbolInfoDouble (Symbol (), SYMBOL_POINT), _Digits);
             TorgPrikaz.deviation = 2;
             TorgPrikaz.type   = ORDER_TYPE_SELL;
             TorgPrikaz.type_filling = ORDER_FILLING_FOK; 
             
             ResetLastError ();                 //обнуляем последнюю ошибку
             OrderSend(TorgPrikaz, TorgRezult); //открываем ордер
             
             if (GetLastError () != 0)  //если ордер выдал ошибку
               {
                Print ("Ошибка = ", GetLastError ());
                Print ("Код торгового сервера = ", TorgRezult.retcode);
               }
             return;  //выходим
            }
          else       //нет сигнала
            return;  //выходим
         }
       else    //если открыт ордер сел
         {
          //проверяем есть ли сигнал от индикатора на покупку
          if (BistMA[1] > MedlMA[1] && BistMA[3] < MedlMA[3])  //есть сигнал
            {
             //закрываем ордер на продажу и открываем ордер на покупку
             TorgPrikaz.action = TRADE_ACTION_DEAL;
             TorgPrikaz.magic  = 102;
             TorgPrikaz.symbol = _Symbol;
             TorgPrikaz.volume = Lot * 2;
             TorgPrikaz.price  = NormalizeDouble (SymbolInfoDouble (Symbol (), SYMBOL_ASK), _Digits);
             TorgPrikaz.sl     = NormalizeDouble (SymbolInfoDouble (Symbol (), SYMBOL_ASK) - SL * SymbolInfoDouble (Symbol (), SYMBOL_POINT), _Digits);
             TorgPrikaz.tp     = NormalizeDouble (SymbolInfoDouble (Symbol (), SYMBOL_ASK) + TP * SymbolInfoDouble (Symbol (), SYMBOL_POINT), _Digits);
             TorgPrikaz.deviation = 2;
             TorgPrikaz.type   = ORDER_TYPE_BUY;
             TorgPrikaz.type_filling = ORDER_FILLING_FOK; 
             
             ResetLastError ();                 //обнуляем последнюю ошибку
             OrderSend(TorgPrikaz, TorgRezult); //открываем ордер
             
             if (GetLastError () != 0)  //если ордер выдал ошибку
               {
                Print ("Ошибка = ", GetLastError ());
                Print ("Код торгового сервера = ", TorgRezult.retcode);
               }
             return;  //выходим
            }
          else      //нет сигнала
            return; //выходим
         }
      }
   else    //нет открытых ордеров по торговой паре
      {
       //проверяем есть ли сигнал от индикатора на бай
       if (BistMA[1] > MedlMA[1] && BistMA[3] < MedlMA[3])  //есть сигнал
         {
          //открываем ордер бай
          TorgPrikaz.action = TRADE_ACTION_DEAL;
          TorgPrikaz.magic  = 102;
          TorgPrikaz.symbol = _Symbol;
          TorgPrikaz.volume = Lot;
          TorgPrikaz.price  = NormalizeDouble (SymbolInfoDouble (Symbol (), SYMBOL_ASK), _Digits);
          TorgPrikaz.sl     = NormalizeDouble (SymbolInfoDouble (Symbol (), SYMBOL_ASK) - SL * SymbolInfoDouble (Symbol (), SYMBOL_POINT), _Digits);
          TorgPrikaz.tp     = NormalizeDouble (SymbolInfoDouble (Symbol (), SYMBOL_ASK) + TP * SymbolInfoDouble (Symbol (), SYMBOL_POINT), _Digits);
          TorgPrikaz.deviation = 2;
          TorgPrikaz.type   = ORDER_TYPE_BUY;
          TorgPrikaz.type_filling = ORDER_FILLING_FOK; 
             
          ResetLastError ();                 //обнуляем последнюю ошибку
          OrderSend(TorgPrikaz, TorgRezult); //открываем ордер
             
          if (GetLastError () != 0)  //если ордер выдал ошибку
             {
              Print ("Ошибка = ", GetLastError ());
              Print ("Код торгового сервера = ", TorgRezult.retcode);
             }
          return;  //выходим
         }
       else    //нет сигнала
         {
          //проверяем есть ли сигнал от индикатора на сел
          if (BistMA[1] < MedlMA[1] && BistMA[3] > MedlMA[3])  //есть сигнал
            {
             //открываем ордер сел
             TorgPrikaz.action = TRADE_ACTION_DEAL;
             TorgPrikaz.magic  = 102;
             TorgPrikaz.symbol = _Symbol;
             TorgPrikaz.volume = Lot;
             TorgPrikaz.price  = NormalizeDouble (SymbolInfoDouble (Symbol (), SYMBOL_BID), _Digits);
             TorgPrikaz.sl     = NormalizeDouble (SymbolInfoDouble (Symbol (), SYMBOL_BID) + SL * SymbolInfoDouble (Symbol (), SYMBOL_POINT), _Digits);
             TorgPrikaz.tp     = NormalizeDouble (SymbolInfoDouble (Symbol (), SYMBOL_BID) - TP * SymbolInfoDouble (Symbol (), SYMBOL_POINT), _Digits);
             TorgPrikaz.deviation = 2;
             TorgPrikaz.type   = ORDER_TYPE_SELL;
             TorgPrikaz.type_filling = ORDER_FILLING_FOK; 
             
             ResetLastError ();                 //обнуляем последнюю ошибку
             OrderSend(TorgPrikaz, TorgRezult); //открываем ордер
             
             if (GetLastError () != 0)  //если ордер выдал ошибку
               {
                Print ("Ошибка = ", GetLastError ());
                Print ("Код торгового сервера = ", TorgRezult.retcode);
               }
             return;  //выходим
            }
          else        //нет сигнала
            return;   //выходим
         }
      }
   
  }   
