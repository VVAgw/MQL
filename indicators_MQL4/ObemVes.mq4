//+------------------------------------------------------------------+
//|                                                      ObemVes.mq4 |
//|                                                              Ves |
//|                                                                  |
//+------------------------------------------------------------------+

/*
Индикатор отображает количество объемов поступившее за тик. Если
цена ниже предыдущей, то количество объемов поступившее за тик становится
красными (закупка сел), если цена выше предыдущей, то количество объемов 
поступивших за тик становится зелеными (закупка бай).
Индикатор начинает работать когда появится следующий бар после присоединению
его к графику.
Индикатор начинает работу с того бара на котором был установлен.
*/
#property copyright "Ves"
#property link      ""

#property indicator_separate_window   //индикотор в отдельном окне
//#property indicator_minimum -50      //минимум отчета индикаторного окна
//#property indicator_maximum 50       //максимум отчета индикаторного окна
#property  indicator_buffers 2        //количество буферов в индикаторе
#property  indicator_color1  Green    //цвет первого буфера индикатора
#property  indicator_color2  Red      //цвет второго буфера индикатора
#property  indicator_width1  2        //устанавливаем толщину линий
#property  indicator_width2  2        //устанавливаем талщину линий

double inGreen[];      //объявляем массив для первого буфера
double inRed[];        //объявляем массив для второго буфера

double val = 0.0;      //указатель куда пошел тик в отрицательную зону или положитеьную
int StartBar = 0;      //бар с которого начинаем считать
int BariNaGrafike;     //счетчик баров

bool Zapusk = false;   //контрол запуска
double ObemControl;    //контроль объемов
double LP;             //фиксируем разницу плючового объема пришедешего за тик
double LM;             //фиксируем разницу минусового объема пришедшего за тик
int noviyBar;          //счетчик появления первого бара для старта индикатора
double LotPlus[10000000];      //массив хранит плюсовые лоты
double LotMinus[10000000];     //массив хранит минусовые лоты
double LotPlusP;
double LotMinusP;
double BBid;

int init()
  {
   //IndicatorBuffers(4);
   SetIndexBuffer(0,inGreen);           //привязываем массив к 1 буферу индикатора
   SetIndexBuffer(1,inRed);             //привязываем массив к 2 буферу индикатора
   //SetIndexBuffer(2,LotPlus);           //первый массив для подсчета
   //SetIndexBuffer(3,LotMinus);          //второй массив для подсчета
   SetIndexStyle(0,DRAW_HISTOGRAM);     //отображать 1 буфер как гистограмму
   SetIndexStyle(1,DRAW_HISTOGRAM);     //отображать 2 буфер как гистограмму
   noviyBar = Bars;                     //подождем бара для старта индюка
   return(0);
  }
  
  
int start()
  {
   BBid = Bid;    //подставляем сюда БИД. При тестировании надо подставить глобалньную пер.
   
   if (noviyBar == Bars)   //ждем нового бара и стартуем
      return;
   else{
       
       //присваиваем нужные значения переменны при запуске
   if (Zapusk == false)
      {  
       BariNaGrafike = Bars;                //узнаем какое количество баров на графике
       Zapusk = true;
       ObemControl = iVolume(Symbol(),0,0); //узнаем последний объем
       val = BBid;                           //узнаем последную цену АСК 
      }
   
       //если появился новый бар
   if (BariNaGrafike != Bars)      
      {
       StartBar ++; BariNaGrafike = Bars; 
       ObemControl = iVolume(Symbol(),0,0);
       LotPlus[StartBar] = 0;
       LotMinus[StartBar] = 0;
       LotPlusP = 0;
       LotMinusP = 0;
      }   

       //вычисляем объемы
   if (BBid >= val)    //если тик положительный
      {
       LP = iVolume(Symbol(),0,0) - ObemControl;
       LotPlusP = LotPlusP + LP;
       LotPlus[StartBar] = LotPlusP;
       ObemControl = iVolume(Symbol(),0,0);
       val = BBid;
      }
   else              //если тик отрицательный
      {
       LM = iVolume(Symbol(),0,0) - ObemControl;
       LotMinusP = LotMinusP - LM;
       LotMinus[StartBar] = LotMinusP;
       ObemControl = iVolume(Symbol(),0,0);
       val = BBid;
      }
  
        //передаем данные в буферы индикатора
   int i2 = 0;
   for (int i = StartBar; i >= 0 && i2 <= StartBar; i--)
      {inGreen[i] = LotPlus[i2]; i2++;}
   
   int e2 = 0;
   for (int e = StartBar; e >= 0 && e2 <= StartBar; e--)
      {inRed[e] = LotMinus[e2]; e2++;}
   
   Comment ("\n Количество обработанных баров = ",StartBar);
  }
   return(0);
  }


