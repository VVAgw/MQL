
/*   
Код для поиска пяти последних фрактолов верхних и низких 
*/ 
   
   
   
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