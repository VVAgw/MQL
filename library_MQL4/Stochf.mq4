
//Stach 5,3,3
double Stoch[4], Stochsignal[4];   //значение индикатора на последних 4 барах
extern int Kperiod = 5;
extern int Dperiod = 3;
extern int slow = 3;
extern int Stochmax = 85;          //уровень за которым можно открывать сделки на сел
extern int Stochmin = 15;          //уровень за которым можно открывать сделки на бай
bool Stochbuy = false;             //сигнал на покупку 
bool Stochsell = false;            //сигнал на продажу


void Stochf ()
   {
    //узнаем значение индикатора на последних 4 барах
    for (int b = 0; b < 4; b++)
      {
       Stoch[b] = iStochastic (Symbol (), 0, Kperiod, Dperiod, slow, MODE_SMA, PRICE_CLOSE, MODE_MAIN, b);
       Stochsignal[b] = iStochastic (Symbol (), 0, Kperiod, Dperiod, slow, MODE_SMA, PRICE_CLOSE, MODE_SIGNAL, b);
      }
    //проверяем условие на бай
    if (Stoch[3] < Stochsignal[3] && Stoch[1] > Stochsignal[1] && Stoch[3] < Stochmin)
      Stochbuy = true;
    else Stochbuy = false;
    //проверяем условие на сел
    if (Stoch[3] > Stochsignal[3] && Stoch[1] < Stochsignal[1] && Stoch[3] > Stochmax)
      Stochsell = true;
    else Stochsell = false;
   }