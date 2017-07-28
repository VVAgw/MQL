
/*
Фибо сетка натягивается на две координаты получаемые в функцию. 

Как получить цену верхнего и внутреннего уровеней:
Цена уровня = МинЦена + (МаксЦена - МинЦена) * фибоуровень

Как получить цену нижнего уровня:
Цена уровня = МаксЦена - (МаксЦена - МинЦена) * фибоуровень
*/

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