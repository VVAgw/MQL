
/*
код находит последние три переломных точки индикатора ZigZag 
и находит номера баров на которых эти точки находятся
*/

//в общей секции внешние переменные индикатора ZigZag
extern int ExtDepth=12;
extern int ExtDeviation=5;
extern int ExtBackstep=3;

int start()
  {
   //в функции
   int n;
   int Zbar[4]; //номер бара с перегибом
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
   
   return(0);
  }