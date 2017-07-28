
//SMA 26 and EMA 13
double SMA[4], EMA[4];  //значение индикатора на последних 4 барах
extern int SMAm = 26;   //значение медленной скользящей 
extern int EMAb = 13;   //значение быстрой скользящей
bool MAbuy = false;     //сигнал на покупку 
bool MAsell = false;    //сигнал на продажу



void SMAf ()
   {
    //присваиваем значение индикаторным линиям
    for (int i = 0; i < 4; i++)
      {
       SMA[i] = iMA (Symbol (), 0, SMAm, 0, MODE_SMA, PRICE_CLOSE, i);
       EMA[i] = iMA (Symbol (), 0, EMAb, 0, MODE_EMA, PRICE_CLOSE, i);
      }
    //проверяем условие на бай
    if (SMA[3] > EMA[3] && SMA[1] <  EMA[1])
      MAbuy = true;
    else MAbuy = false;
    //проверяем условие на сел
    if (SMA[3] < EMA[3] && SMA[1] > EMA[1])
      MAsell = true;
    else MAsell = false;
   }