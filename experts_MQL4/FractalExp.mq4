//+------------------------------------------------------------------+
//|                                                   FractalExp.mq4 |
//|                                                              Ves |
//|                                                                  |
//+------------------------------------------------------------------+

/*
Советник работает по фракталам и может по времени торговли (если включить специальныую функцию.
Открыто одновременно может быть только 2 ордера (бай и сел). Если фрактал не дальше 2 баров, 
то советник открывает ордер, если фрактал вверху то ордер сел(стоплосс где фрактал + 5 пунктов, тейкпрофит такой же),
если фрактал снизу то ордер бай
*/
#property copyright "Ves"
#property link      ""

extern double Lot = 0.1;     //лот
extern bool ETime = false;   //включить время торговли
extern int StartTime = 7;    //начало торговли включительно
extern int FinishTime = 19;  //конец торговли включительно

int orderBuy, orderSell;     //тики ордеров 
double SL, TP;               //стоплосс и тейкпрофит

int start()
  {
   
   //**********************вычисляем значеня фракталов*************************   
   
   int nU;               //счетчик верхнего фрактала
   double FracUp [5];    //значения с 1-го фрактала по 5-й верхний
   int BarFracUp [5];    //номер бара где фрактал с 1 по 5 верхний
   int nD;               //счетчик нижнего фрактала
   double FracD [5];     //значения с 1-го фрактала по 5-й нижний
   int BarFracD [5];     //номер бара где фрактал с 1 по 5 нижний
       
       
       //цикл вычисления верхнего фрактала
    for ( int i = 0; i < Bars; i++)
      {    
       double fU = iFractals (Symbol(),0,MODE_UPPER,i);
       if (fU != 0 && fU != EMPTY_VALUE)
         {
          FracUp[nU] = fU;
          BarFracUp[nU] = i;
          nU ++;
          if ( nU >= 5) break;
         }
      }
        
        
        //цикл вычисления нижнего фрактала
    for ( int a = 0; a < Bars; a++)
      {
       double fD = iFractals (Symbol(),0,MODE_LOWER,a);
       if (fD != 0 && fD != EMPTY_VALUE)
         {
          FracD[nD] = fD;
          BarFracD[nD] = a;
          nD ++;
          if ( nD >= 5) break;
         }
      }
      
    //*****************************смотрим уловия открытия ордера*************

    if ( ETime == true && Hour() >= StartTime && Hour() <= FinishTime){ //если время торговли
 
            //проверяем закрылся ли ордер бай по профиту или стопу
    if (OrderSelect(orderBuy,SELECT_BY_TICKET) == true)
      if (OrderCloseTime() > 0)
         orderBuy = 0; 
          
          //открываем бай     
    if (BarFracD[0] < BarFracUp[0] && BarFracD[0] <= 2)
      {
       if (orderBuy == 0){
         SL = NormalizeDouble(FracD[0] - 5*Point,Digits);  //вычисляем уровень стоплосса
         TP = Ask - SL;      //вычисляем уровень тейкпрофита
         orderBuy = OrderSend(Symbol(),OP_BUY,Lot,NormalizeDouble(Ask,Digits),2,SL,NormalizeDouble(Ask + TP,Digits));
         if (orderBuy < 0) Comment(" Ордер вернул ошибку ",GetLastError());}
       
      }
         
         
         
         //проверяем закрылся ли ордер сел по профиту или стопу
    if (OrderSelect(orderSell,SELECT_BY_TICKET) == true)
      if (OrderCloseTime() > 0)
         orderSell = 0;         
     
           //открываем сел
    if (BarFracUp[0] < BarFracD[0] && BarFracUp[0] <= 2)
      {
       if (orderSell == 0){
         SL = NormalizeDouble(FracUp[0] + 5*Point,Digits);  //вычисляем уровень стоплосса
         TP = SL - Bid;      //вычисляем уровень тейкпрофита
         orderSell = OrderSend(Symbol(),OP_SELL,Lot,NormalizeDouble(Bid,Digits),2,SL,NormalizeDouble(Bid-TP,Digits));
         if (orderSell < 0) Comment(" Ордер вернул ошибку ",GetLastError());}
       
      }      
   }
   
   else 
      return;       
   return(0);
  }

