 //+------------------------------------------------------------------+
//|                                                FZR_Exp_ZZ_AO.mq4 |
//|                                                              Ves |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Ves"
#property link      ""
/*
Советник работает по ФЗР на индикаторе ЗигЗаг.
В нижней точке ЗЗ для ордера бый выставляет стоплос, а тейкпрофит по сетке фибо на 138.2 уровне.
Для ордера сел все также только наоборот.
Затея с индикатром: пока не получилось, не стал париться!
*/
extern double Lot = 0.1;
//extern double AOUp = -5.0;
//extern double AODown = 5.0;

int OrderBuy, OrderSell;                  //тики ордеров
double SL,TP;                             //стоплос и тейкпрофит
double StopControlSell, StopControlBuy;   //контрольные стопы, что бы не открывалось много одинаковых ордеров

//настройки ЗЗ
extern int ExtDepth=15;
extern int ExtDeviation=0;
extern int ExtBackstep=3;
 
int start()
  {
//*************************вычисляем значения ЗЗ*****************************
   
   int n;
   int Zbar[4];    //номер бара с перегибом
   double Zval[4]; //значение зигзага в точке перегиба Zval[1] - в точке 1 и тд. 
 
   for(int i=0;i<Bars;i++)
      {
       double zz=iCustom(NULL,0,"ZigZag",ExtDepth,ExtDeviation,ExtBackstep,0,i);
         if(zz!=0 && zz!=EMPTY_VALUE)
            {
             Zbar[n]=i;
             Zval[n]=zz;
             n++;
                if(n>=4)break;
            }
      }  
   
   fibo(Zval[1],Zval[2],Zbar[1],Zbar[2]);    //вызывем функцию для сетки фибоначи
   
//*************************открываем ордер бай******************************
       
       //если бай ордер закрылся по стопу, то обнуляем тик
   if (OrderSelect(OrderBuy,SELECT_BY_TICKET) == true)
      if (OrderCloseTime() > 0)
         OrderBuy = 0;
       //если отложенный бай ордер не стал рыночным, то удаляем его
   if (OrderSelect(OrderBuy,SELECT_BY_TICKET) == true)
      if (OrderType() == OP_BUYSTOP)
         if (OrderStopLoss() > Bid)
            {
             OrderDelete(OrderBuy);OrderBuy = 0;
            }

         //проверяем условия для открытия    
   if (Zval[1] > Zval[2] && OrderBuy == 0 || OrderBuy == -1 && Zval[0] < Zval[1] && Zval[0] > Zval[2] && Ask < Zval[1] && Bid > Zval[2])
      {
       //Определяем значение АО
       //double AOBuyUp = iAO(Symbol(),0,Zbar[1]);
       //double AOBuyDown = iAO(Symbol(),0,Zbar[2]);
       //if (AOBuyUp > AOUp && AOBuyDown < AODown){}
          SL = NormalizeDouble(Zval[2],Digits);
          TP = NormalizeDouble(Zval[2] + (Zval[1] - Zval[2]) * 1.382,Digits);
          if (StopControlBuy != SL){
            OrderBuy = OrderSend(Symbol(),OP_BUYSTOP,Lot,NormalizeDouble(Zval[1],Digits),2,SL,TP);
            if (OrderBuy == -1) Comment("\n Ордер вернул ошибку ",GetLastError());
            StopControlBuy = SL;}
      }
    
//************************открываем ордер сел*******************************
          
          //если сел ордер закрылся по стопу, то обнуляем тик
   if (OrderSelect(OrderSell,SELECT_BY_TICKET) == true)
      if (OrderCloseTime() > 0)
         OrderSell = 0;
       //если отложенный селл ордер не стал рыночным, то удаляем его
   if (OrderSelect(OrderSell,SELECT_BY_TICKET) == true)
      if (OrderType() == OP_SELLSTOP)
         if (OrderStopLoss() <  Ask)
            {
             OrderDelete(OrderSell);OrderSell = 0;
            }

         //проверяем условия для открытия    
   if (Zval[1] < Zval[2] && OrderSell == 0 || OrderSell == -1 && Zval[0] > Zval[1] && Zval[0] < Zval[2] && Ask < Zval[2] && Bid > Zval[1])
      {
       //Определяем значение АО
       //double AOSellUp = iAO(Symbol(),0,Zbar[2]);
       //double AOSellDown = iAO(Symbol(),0,Zbar[1]);
       //if (AOSellUp > AOUp && AOSellDown < AODown){}
         
          SL = NormalizeDouble(Zval[2],Digits);
          TP = NormalizeDouble(Zval[1] - (Zval[1] - Zval[2]) * (-1.382 + 1),Digits);
          if (StopControlSell != SL){
            OrderSell = OrderSend(Symbol(),OP_SELLSTOP,Lot,NormalizeDouble(Zval[1],Digits),2,SL,TP);
            if (OrderSell == -1) Comment("\n Ордер вернул ошибку ",GetLastError()); 
            StopControlSell = SL;}
      }
   return(0);
  }

//*******************************функция сетки фибо***************************

void fibo(double money1,double money2,int bar1,int bar2)
  {
   double to4ka1;
   datetime tim1;
   double to4ka2;
   datetime tim2;
   
   if (money1 > money2)
      {
       to4ka1 = money2;
       tim1 = Time[bar2];
       to4ka2 = money1;
       tim2 = Time[bar1];
      }
   else
      {
       to4ka1 = money1;
       tim1 = Time[bar1];
       to4ka2 = money2;
       tim2 = Time[bar2];
      }
      
   if (ObjectFind("fibo") == -1)
      ObjectCreate("fibo",OBJ_FIBO,0,tim1,to4ka1,tim2,to4ka2);  //координаты на которые натягивать сетку и создание сетки
   else
      {
       ObjectSet("fibo",OBJPROP_TIME1,tim1);
       ObjectSet("fibo",OBJPROP_PRICE1,to4ka1);
       ObjectSet("fibo",OBJPROP_TIME2,tim2);
       ObjectSet("fibo",OBJPROP_PRICE2,to4ka2);
      }
   ObjectSet("fibo",OBJPROP_RAY,false);                      //луч или не луч
   ObjectSet("fibo",OBJPROP_LEVELCOLOR,DarkSlateGray);       //цвет самой сетки
   ObjectSet("fibo",OBJPROP_COLOR,Red);                      //цвет линии между точками координат
   ObjectSet("fibo",OBJPROP_STYLE,STYLE_DOT);                //стиль отображения линии, которая находится между координатами
   ObjectSet("fibo",OBJPROP_LEVELSTYLE,STYLE_DASHDOT);       //стиль отображения фибо уровней
   ObjectSet("fibo",OBJPROP_FIBOLEVELS,16);                  //количество фибо уровней
   
       //верхние
   ObjectSet("fibo",OBJPROP_FIRSTLEVEL+0,2.618);
   ObjectSetFiboDescription("fibo",0,"261.8 " + " (%$) ");
   ObjectSet("fibo",OBJPROP_FIRSTLEVEL+1,2.11);
   ObjectSetFiboDescription("fibo",1,"211.0 " + " (%$) ");
   ObjectSet("fibo",OBJPROP_FIRSTLEVEL+2,1.618);
   ObjectSetFiboDescription("fibo",2,"161.8 " + " (%$) ");
   ObjectSet("fibo",OBJPROP_FIRSTLEVEL+3,1.382);
   ObjectSetFiboDescription("fibo",3,"138.2 " + " (%$) ");
        //внутренние 
   ObjectSet("fibo",OBJPROP_FIRSTLEVEL+4,1.0);
   ObjectSetFiboDescription("fibo",4,"100.0 " + " (%$) ");
   ObjectSet("fibo",OBJPROP_FIRSTLEVEL+5,0.764);
   ObjectSetFiboDescription("fibo",5,"76.4 " + " (%$) ");
   ObjectSet("fibo",OBJPROP_FIRSTLEVEL+6,0.618);
   ObjectSetFiboDescription("fibo",6,"61.8 " + " (%$) ");
   ObjectSet("fibo",OBJPROP_FIRSTLEVEL+7,0.5);
   ObjectSetFiboDescription("fibo",7,"50.0 " + " (%$) ");
   ObjectSet("fibo",OBJPROP_FIRSTLEVEL+8,0.382);
   ObjectSetFiboDescription("fibo",8,"38.2 " + " (%$) ");
   ObjectSet("fibo",OBJPROP_FIRSTLEVEL+9,0.236);
   ObjectSetFiboDescription("fibo",9,"23.6 " + " (%$) ");
   ObjectSet("fibo",OBJPROP_FIRSTLEVEL+10,0.0);
   ObjectSetFiboDescription("fibo",10,"0.0 " + " (%$) ");
          //нижние
   ObjectSet("fibo",OBJPROP_FIRSTLEVEL+11,-0.382);
   ObjectSetFiboDescription("fibo",11,"138.2 " + " (%$) ");
   ObjectSet("fibo",OBJPROP_FIRSTLEVEL+12,-0.618);
   ObjectSetFiboDescription("fibo",12,"161.8 " + " (%$) ");
   ObjectSet("fibo",OBJPROP_FIRSTLEVEL+13,-1.11);
   ObjectSetFiboDescription("fibo",13,"211.0 " + " (%$) ");
   ObjectSet("fibo",OBJPROP_FIRSTLEVEL+14,-1.618);
   ObjectSetFiboDescription("fibo",14,"261.8 " + " (%$) ");
  }

