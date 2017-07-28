//+------------------------------------------------------------------+
//|                                                    ZigZagVes.mq4 |
//|                                                              Ves |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Ves"
#property link      ""
/*
Советник выставляет два ордера сел и бай на уровнях UrUp и UrDown (нижний и верхний), на уровнях выставляет горизонтальные линии,
если закрытие свечи на минутном таймфрейме будет выше уровня UrUp, то откроется ордер на покупку,
если закрыти свечи на минутном таймфрейму будет ниже уровня UrDown, то закроется ордер на покупку.
Тоже самое с ордером на продажу только наооброт ...
Советник работает через F3 - меню глобальных переменных, чтобы торговал надо поставить Start = 1
*/

extern int TP = 100;         //тейкпрофит
extern int SL = 100;         //стоплос
extern double Lot = 0.1;     //лот
double Start = 0;            //разрешение на торговлю
double UrUp = 0.0;           //верхний уровень для ордера
double UrDown = 0.0;         //нижний уровень для ордера
int buy, sell;               //ордера


int init ()
   {
    GlobalVariableSet("UrUp",0.0);       //создаем глобальные переменные
    GlobalVariableSet("UrDown",0.0);
    GlobalVariableSet("Start",0.0);
    return(0);
   }

int start()
  {
   UrUp = GlobalVariableGet("UrUp");         //выставляем значения из глобальных переменных
   UrDown = GlobalVariableGet("UrDown");
   Start = GlobalVariableGet("Start");
   
   if (Start == 0){ ObjectDelete("UrUp");ObjectDelete("UrDown");   //если торговля запрещена, то удаляем все открытые ордера и объекты
      if (OrderSelect(buy,SELECT_BY_TICKET) == true)
         OrderClose(buy,OrderLots(),NormalizeDouble(Bid,Digits),2);
      if (OrderSelect(sell,SELECT_BY_TICKET) == true)
         OrderClose(sell,OrderLots(),NormalizeDouble(Ask,Digits),2); buy = 0; sell = 0;}
  
   if (Start == 1)    //если торговля разрешена
      {
       ObjectCreate("UrUp",OBJ_HLINE,0,0,UrUp);         //создаем горизонтальные линии
       ObjectSet("UrUp",OBJPROP_COLOR,DarkBlue);
       ObjectCreate("UrDown",OBJ_HLINE,0,0,UrDown);
       ObjectSet("UrDown",OBJPROP_COLOR,Red);
      
      
       if (Close[1] > UrUp && buy == 0){       //мониторим верхний ордер на открытие
         buy = OrderSend(Symbol(),OP_BUY,Lot,NormalizeDouble(Ask,Digits),2,NormalizeDouble(Ask-SL*Point,Digits),NormalizeDouble(Ask+TP*Point,Digits));
         if (buy < 0) Comment (" Ордер вернул ошибку ",GetLastError());}
       
       if (Close[1] < UrUp && buy > 0){        //мониторим верхний ордер на закрытие
         OrderClose(buy,Lot,NormalizeDouble(Bid,Digits),2);
         if (GetLastError() == 0) buy = 0;} 
      
        if (Close[1] < UrDown && sell == 0){    //мониторим нижний ордер на открытие
         sell = OrderSend(Symbol(),OP_SELL,Lot,NormalizeDouble(Bid,Digits),2,NormalizeDouble(Bid+SL*Point,Digits),NormalizeDouble(Bid-TP*Point,Digits));
         if (sell < 0) Comment (" Ордер вернул ошибку  ",GetLastError());} 
         
       if (Close[1] > UrDown && sell > 0){      //мониторим нижний ордер на закрытие
         OrderClose(sell,Lot,NormalizeDouble(Ask,Digits),2);
         if (GetLastError() == 0) sell = 0;}       
      }       
   return(0);
  }

