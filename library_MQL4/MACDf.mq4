
//MACD 12,26,9
double MACDmin, MACDmax;           //уровни на индикаторе за которыми тожно открывать сделку
double MACDur[170];                //массив для расчета уровней
double MACD[4], MACDsignal[4];     //значение индикатора на последних 4 барах
extern int fastEMA = 12;           //значение быстрой скользящей
extern int slowEMA = 26;           //значение медлоенной скользящей
extern int signalEMA = 9;          //значение сигнальной линии
bool MACDbuy = false;              //сигнал на покупку 
bool MACDsell = false;             //сигнал на продажу
extern int k = 70;                 //уровень выше/ниже которого можно открывать сделку по сигналу
                                   //в процентном соотношении



void MACDf ()
   {
    for (int a = 0; a < 4; a++)
      {
       //присваиваем цену индикатора на последних 4 барах
       MACD[a] = iMACD (Symbol (), 0, fastEMA, slowEMA, signalEMA, PRICE_CLOSE, MODE_MAIN, a);
       MACDsignal[a] = iMACD (Symbol (), 0, fastEMA, slowEMA, signalEMA, PRICE_CLOSE, MODE_SIGNAL, a);
      }
    //устанавливем значение уровней max and min
    
    MACDmin = 0; 
    MACDmax = 0;
    for (int x = 0; x <= 170; x++)
      {
       MACDur[x] = iMACD (Symbol (), 0, fastEMA, slowEMA, signalEMA, PRICE_CLOSE, MODE_MAIN, x);
       if (MACDur[x] > MACDmax)
         MACDmax = MACDur[x];
       if (MACDur[x] < MACDmin)
         MACDmin = MACDur[x];
      }
      MACDmax = MACDmax / 100 * k;
      MACDmin = MACDmin / 100 *k; 
    //пороверяем условие на бай
    if (MACD[3] < MACDsignal[3] && MACD[1] > MACDsignal[1] && MACD[3] < MACDmin)
      MACDbuy = true;
    else MACDbuy = false;
    //проверяем условие на сел
    if (MACD[3] > MACDsignal[3] && MACD[1] < MACDsignal[1] && MACD[3] > MACDmax)
      MACDsell = true;
    else MACDsell = false;
   }