/*
индикатор пробо€. показывает утренный флет и т€нет на него сетку фибоначчи
*/
#property copyright "Ves Volk"
#property link      ""

#property indicator_chart_window    //индикатор в окне графика
//#property indicator_buffers 6       //буферов в индикаторе


extern int  олƒней = 20;
extern int Ќачалозуфа = 0;
extern int  онец«уфа = 6;
extern color ÷вет«уфа = DimGray;
extern color ÷ветЅычьегоƒн€ = DarkSeaGreen;
extern color ÷ветћедвежьегоƒн€ = DarkSalmon;
extern color ÷вет‘ибо—етки = Maroon;


double “очка1«уф÷ена [10000];
double “очка2«уф÷ена [10000];
datetime “очка1«уф¬рем€ [10000];
datetime “очка2«уф¬рем€ [10000];
double “очка1ƒень÷ена [10000];
double “очка2ƒень÷ена [10000];
datetime “очка1ƒень¬рем€ [10000];
datetime “очка2ƒень¬рем€ [10000];
string «уфЌиз = "«уфЌиз";
string «уф¬ерх = "«уф¬ерх";
string ƒень = "ƒень";
double “очка1‘ибо÷ена, “очка2‘ибо÷ена;
datetime “очка1‘ибо¬рем€, “очка2‘ибо¬рем€;

double
‘ибо_ћ510.8,
‘ибо_ћ423.6,
‘ибо_ћ361.8,
‘ибо_ћ311,
‘ибо_ћ261.8,
‘ибо_ћ211,
‘ибо_ћ161.8,
‘ибо_ћ138.2,
‘ибо_0,
‘ибо_23.6,
‘ибо_38.2,
‘ибо_50,
‘ибо_61.8,
‘ибо_76.4,
‘ибо_100,
‘ибо_138.2,
‘ибо_161.8,
‘ибо_211,
‘ибо_261.8,
‘ибо_311,
‘ибо_361.8,
‘ибо_423.6,
‘ибо_510.8;

int ѕробой≈сть¬верх, ѕробой≈сть¬низ, Ќапр“ренда;     //Ќапр“ренда: 1 - вверх, 2 - вниз, 3 - флет

int init()
  {
//-----------------------------------------------------------------------------------------
   //создаем объекты
   for (int a = 0; a <  олƒней; a++)
      {
       //создаем зуф
       ObjectCreate («уфЌиз + a, OBJ_TREND, 0, 0, 0, 0, 0);
       ObjectCreate («уф¬ерх + a, OBJ_TREND, 0, 0, 0, 0, 0);
       ObjectSet («уфЌиз + a, OBJPROP_COLOR, ÷вет«уфа);
       ObjectSet («уф¬ерх + a, OBJPROP_COLOR, ÷вет«уфа);
       ObjectSet («уфЌиз + a, OBJPROP_RAY, false);
       ObjectSet («уф¬ерх + a, OBJPROP_RAY, false);
       ObjectSet («уфЌиз + a, OBJPROP_WIDTH, 3);
       ObjectSet («уф¬ерх + a, OBJPROP_WIDTH, 3);
     
       //создаем день
       if (a > 0)
          {
              //если день был бычьим
          if (iClose (Symbol (), PERIOD_D1, a) > iOpen (Symbol (), PERIOD_D1, a))
             {
              ObjectCreate (ƒень + a, OBJ_RECTANGLE, 0, 0, 0, 0, 0);
              ObjectSet (ƒень + a, OBJPROP_COLOR, ÷ветЅычьегоƒн€);
             }
           //если день был медвежьим
          else
             {
              ObjectCreate (ƒень + a, OBJ_RECTANGLE, 0, 0, 0, 0, 0);
              ObjectSet (ƒень + a, OBJPROP_COLOR, ÷ветћедвежьегоƒн€);
             }
          }
      
      }
//------------------------------------------------------------------------------------------
   //создаем фибо сетку
   ObjectCreate("fibo",OBJ_FIBO,0,0,0,0,0);
   
   ObjectSet("fibo",OBJPROP_RAY,false);                      //луч или не луч
   ObjectSet("fibo",OBJPROP_LEVELCOLOR,÷вет‘ибо—етки);       //цвет самой сетки
   ObjectSet("fibo",OBJPROP_COLOR,Red);                      //цвет линии между точками координат
   ObjectSet("fibo",OBJPROP_STYLE,STYLE_DOT);                //стиль отображени€ линии, котора€ находитс€ между координатами
   ObjectSet("fibo",OBJPROP_LEVELSTYLE,STYLE_DASHDOT);       //стиль отображени€ фибо уровней
   ObjectSet("fibo",OBJPROP_FIBOLEVELS,28);                  //количество фибо уровней
   
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
      //еще несколько уровней
   ObjectSet("fibo",OBJPROP_FIRSTLEVEL+15,3.11);
   ObjectSetFiboDescription("fibo",15,"311.0 " + " (%$) ");
   ObjectSet("fibo",OBJPROP_FIRSTLEVEL+16,3.618);
   ObjectSetFiboDescription("fibo",16,"361.8 " + " (%$) ");
   ObjectSet("fibo",OBJPROP_FIRSTLEVEL+17,-2.11);
   ObjectSetFiboDescription("fibo",17,"311.0 " + " (%$) ");
   ObjectSet("fibo",OBJPROP_FIRSTLEVEL+18,-2.618);
   ObjectSetFiboDescription("fibo",18,"361.8 " + " (%$) ");
   ObjectSet("fibo",OBJPROP_FIRSTLEVEL+19,4.236);
   ObjectSetFiboDescription("fibo",19,"423.6 " + " (%$) ");
   ObjectSet("fibo",OBJPROP_FIRSTLEVEL+20,5.108);
   ObjectSetFiboDescription("fibo",20,"510.8 " + " (%$) ");
   ObjectSet("fibo",OBJPROP_FIRSTLEVEL+21,-3.236);
   ObjectSetFiboDescription("fibo",21,"423.6 " + " (%$) ");
   ObjectSet("fibo",OBJPROP_FIRSTLEVEL+22,-4.108);
   ObjectSetFiboDescription("fibo",22,"510.8 " + " (%$) ");
    
   return(0);
  }

//------------------------------------------------------------------------------
int start()
  {
   //провер€ем закончилось ли формирование «”‘ј
      //закончилось
   if (Hour () >  онец«уфа)
      {
       //вычисл€ем значени€ точек дл€ отрисовки объектов
      int ѕродолжительность¬ремени«уфа =  онец«уфа * 60 * 60; 
      for (int x = 0; x <  олƒней; x++)
            {
             if (x == 0)
               {
                “очка1«уф¬рем€ [x] = iTime (Symbol (), PERIOD_H1, Hour ());
                “очка2«уф¬рем€ [x] = iTime (Symbol (), PERIOD_H1, Hour () -  онец«уфа);
             
                ObjectSet («уфЌиз + x, OBJPROP_TIME1, “очка1«уф¬рем€ [x]);
                ObjectSet («уфЌиз + x, OBJPROP_TIME2, “очка2«уф¬рем€ [x]);
                ObjectSet («уф¬ерх + x, OBJPROP_TIME1, “очка1«уф¬рем€ [x]);
                ObjectSet («уф¬ерх + x, OBJPROP_TIME2, “очка2«уф¬рем€ [x]);
             
                “очка2«уф÷ена [x] = iLow (Symbol (), 0, iLowest (Symbol (), 0, MODE_LOW,  онец«уфа * 60 / Period (), ObjectGetShiftByValue («уфЌиз + x, 0) -  онец«уфа * 60 / Period ()));
                “очка1«уф÷ена [x] = iHigh (Symbol (), 0, iHighest (Symbol (), 0, MODE_HIGH,  онец«уфа * 60 / Period (), ObjectGetShiftByValue («уф¬ерх + x, 0) -  онец«уфа * 60 / Period ()));
               }
             else
               {
                “очка1«уф¬рем€ [x] = iTime (Symbol (), PERIOD_D1, x);
                “очка2«уф¬рем€ [x] = iTime (Symbol (), PERIOD_D1, x) + ѕродолжительность¬ремени«уфа;
             
                ObjectSet («уфЌиз + x, OBJPROP_TIME1, “очка1«уф¬рем€ [x]);
                ObjectSet («уфЌиз + x, OBJPROP_TIME2, “очка2«уф¬рем€ [x]);
                ObjectSet («уф¬ерх + x, OBJPROP_TIME1, “очка1«уф¬рем€ [x]);
                ObjectSet («уф¬ерх + x, OBJPROP_TIME2, “очка2«уф¬рем€ [x]);
             
                “очка2«уф÷ена [x] = iLow (Symbol (), 0, iLowest (Symbol (), 0, MODE_LOW,  онец«уфа * 60 / Period (), ObjectGetShiftByValue («уфЌиз + x, 0) -  онец«уфа * 60 / Period ()));
                “очка1«уф÷ена [x] = iHigh (Symbol (), 0, iHighest (Symbol (), 0, MODE_HIGH,  онец«уфа * 60 / Period (), ObjectGetShiftByValue («уф¬ерх + x, 0) -  онец«уфа * 60 / Period ()));
                
                “очка1ƒень÷ена [x] = iLow (Symbol (), PERIOD_D1, x);
                “очка1ƒень¬рем€ [x] = iTime (Symbol (), PERIOD_D1, x);
                “очка2ƒень÷ена [x] = iHigh (Symbol (), PERIOD_D1, x);
                “очка2ƒень¬рем€ [x] = iTime (Symbol (), PERIOD_D1, x - 1);
               }
            }
      }
//------------------------------------------------------------------------------------------
      //не закончилось
   if (Hour () <  онец«уфа)
      {
       //вычисл€ем значени€ точек дл€ отрисовки объектов
      int ѕродолжительность¬ремени«уфа2 =  онец«уфа * 60 * 60;
      for (int x2 = 0; x2 <  олƒней; x2++)
            {
             if (x2 == 0)
               {
                “очка1«уф¬рем€ [x2] = iTime (Symbol (), PERIOD_D1, 0);
                “очка2«уф¬рем€ [x2] = MarketInfo (Symbol (), MODE_TIME);
                
                ObjectSet («уфЌиз + x2, OBJPROP_TIME1, “очка1«уф¬рем€ [x2]);
                ObjectSet («уфЌиз + x2, OBJPROP_TIME2, “очка2«уф¬рем€ [x2]);
                ObjectSet («уф¬ерх + x2, OBJPROP_TIME1, “очка1«уф¬рем€ [x2]);
                ObjectSet («уф¬ерх + x2, OBJPROP_TIME2, “очка2«уф¬рем€ [x2]);
                
                “очка2«уф÷ена [x2] = iLow (Symbol (), 0, iLowest (Symbol (), 0, MODE_LOW, ObjectGetShiftByValue («уфЌиз + x2, 0), 0));
                “очка1«уф÷ена [x2] = iHigh (Symbol (), 0, iHighest (Symbol (), 0, MODE_HIGH, ObjectGetShiftByValue («уф¬ерх + x2, 0), 0));
               }
             else
               {
                “очка1«уф¬рем€ [x2] = iTime (Symbol (), PERIOD_D1, x2);
                “очка2«уф¬рем€ [x2] = iTime (Symbol (), PERIOD_D1, x2) + ѕродолжительность¬ремени«уфа2;
             
                ObjectSet («уфЌиз + x2, OBJPROP_TIME1, “очка1«уф¬рем€ [x2]);
                ObjectSet («уфЌиз + x2, OBJPROP_TIME2, “очка2«уф¬рем€ [x2]);
                ObjectSet («уф¬ерх + x2, OBJPROP_TIME1, “очка1«уф¬рем€ [x2]);
                ObjectSet («уф¬ерх + x2, OBJPROP_TIME2, “очка2«уф¬рем€ [x2]);
             
                “очка2«уф÷ена [x2] = iLow (Symbol (), 0, iLowest (Symbol (), 0, MODE_LOW,  онец«уфа * 60 / Period (), ObjectGetShiftByValue («уфЌиз + x2, 0) -  онец«уфа * 60 / Period ()));
                “очка1«уф÷ена [x2] = iHigh (Symbol (), 0, iHighest (Symbol (), 0, MODE_HIGH,  онец«уфа * 60 / Period (), ObjectGetShiftByValue («уф¬ерх + x2, 0) -  онец«уфа * 60 / Period ()));
                
                “очка1ƒень÷ена [x2] = iLow (Symbol (), PERIOD_D1, x2);
                “очка1ƒень¬рем€ [x2] = iTime (Symbol (), PERIOD_D1, x2);
                “очка2ƒень÷ена [x2] = iHigh (Symbol (), PERIOD_D1, x2);
                “очка2ƒень¬рем€ [x2] = iTime (Symbol (), PERIOD_D1, x2 - 1);
               }
            }
      }
//----------------------------------------------------------------------------------------
   //вызываем функцию дл€ расчета уровней фибо дл€ выставлени€ ордеров
   –асчет”ровней‘ибо ();
//----------------------------------------------------------------------------------------
   //отрисовываем объекты-----------------------------------------
   for (int bb = 0; bb <  олƒней; bb++)
      {
       //создаем зуф
       ObjectSet («уфЌиз + bb, OBJPROP_PRICE1, “очка1«уф÷ена [bb]);
       ObjectSet («уфЌиз + bb, OBJPROP_PRICE2, “очка1«уф÷ена [bb]);
       ObjectSet («уф¬ерх + bb, OBJPROP_PRICE1, “очка2«уф÷ена [bb]);
       ObjectSet («уф¬ерх + bb, OBJPROP_PRICE2, “очка2«уф÷ена [bb]);
       //отрисоваваем день---------------------------------------
       if (bb > 0)
          {
              //если день был бычьим------------------------------------------------
          if (iClose (Symbol (), PERIOD_D1, bb) > iOpen (Symbol (), PERIOD_D1, bb))
             {
              ObjectSet (ƒень + bb, OBJPROP_TIME1, “очка1ƒень¬рем€ [bb]);
              ObjectSet (ƒень + bb, OBJPROP_PRICE1, “очка1ƒень÷ена [bb]);
              ObjectSet (ƒень + bb, OBJPROP_TIME2, “очка2ƒень¬рем€ [bb]);
              ObjectSet (ƒень + bb, OBJPROP_PRICE2, “очка2ƒень÷ена [bb]);
              ObjectSet (ƒень + bb, OBJPROP_COLOR, ÷ветЅычьегоƒн€);
             }
           //если день был медвежьим----------------------------------------------
          else
             {
              ObjectSet (ƒень + bb, OBJPROP_TIME1, “очка1ƒень¬рем€ [bb]);
              ObjectSet (ƒень + bb, OBJPROP_PRICE1, “очка1ƒень÷ена [bb]);
              ObjectSet (ƒень + bb, OBJPROP_TIME2, “очка2ƒень¬рем€ [bb]);
              ObjectSet (ƒень + bb, OBJPROP_PRICE2, “очка2ƒень÷ена [bb]);
              ObjectSet (ƒень + bb, OBJPROP_COLOR, ÷ветћедвежьегоƒн€);
             }
          }
      
      }
//---------------------------------------------------------------------------------------
   //отрисовываем фибо сетку
   ObjectSet("fibo",OBJPROP_TIME1,“очка1«уф¬рем€ [0]);
   ObjectSet("fibo",OBJPROP_PRICE1,“очка1«уф÷ена [0]);
   ObjectSet("fibo",OBJPROP_TIME2,“очка2«уф¬рем€ [0]);
   ObjectSet("fibo",OBJPROP_PRICE2,“очка2«уф÷ена [0]);
//----------------------------------------------------------------------------------------
     
   
   return(0);
  }
  
  
int deinit()
  {
   //удал€ем все объекты
   ObjectsDeleteAll ();  
   return(0);
  }

//--------------------------------------------------------
//функци€ дл€ рачета уровней фибо дл€ выставлени€ ордеров
void –асчет”ровней‘ибо ()
   {
    ‘ибо_ћ261.8 = NormalizeDouble (“очка1«уф÷ена [0] - (“очка1«уф÷ена [0] - “очка2«уф÷ена [0]) * 2.618, Digits);
    ‘ибо_ћ211 = NormalizeDouble (“очка1«уф÷ена [0] - (“очка1«уф÷ена [0] - “очка2«уф÷ена [0]) * 2.11, Digits);
    ‘ибо_ћ161.8 = NormalizeDouble (“очка1«уф÷ена [0] - (“очка1«уф÷ена [0] - “очка2«уф÷ена [0]) * 1.618, Digits);
    ‘ибо_ћ138.2 = NormalizeDouble (“очка1«уф÷ена [0] - (“очка1«уф÷ена [0] - “очка2«уф÷ена [0]) * 1.382, Digits);
    ‘ибо_0 = NormalizeDouble (“очка2«уф÷ена [0], Digits);
    ‘ибо_23.6 = NormalizeDouble (“очка2«уф÷ена [0] + (“очка1«уф÷ена [0] - “очка2«уф÷ена [0]) * 0.236, Digits);
    ‘ибо_38.2 = NormalizeDouble (“очка2«уф÷ена [0] + (“очка1«уф÷ена [0] - “очка2«уф÷ена [0]) * 0.382, Digits);
    ‘ибо_50 = NormalizeDouble (“очка2«уф÷ена [0] + (“очка1«уф÷ена [0] - “очка2«уф÷ена [0]) * 0.5, Digits);
    ‘ибо_61.8 = NormalizeDouble (“очка2«уф÷ена [0] + (“очка1«уф÷ена [0] - “очка2«уф÷ена [0]) * 0.618, Digits);
    ‘ибо_76.4 = NormalizeDouble (“очка2«уф÷ена [0] + (“очка1«уф÷ена [0] - “очка2«уф÷ена [0]) * 0.764, Digits);
    ‘ибо_100 = NormalizeDouble (“очка1«уф÷ена [0], Digits);
    ‘ибо_138.2 = NormalizeDouble (“очка2«уф÷ена [0] + (“очка1«уф÷ена [0] - “очка2«уф÷ена [0]) * 1.382, Digits);
    ‘ибо_161.8 = NormalizeDouble (“очка2«уф÷ена [0] + (“очка1«уф÷ена [0] - “очка2«уф÷ена [0]) * 1.618, Digits);
    ‘ибо_211 = NormalizeDouble (“очка2«уф÷ена [0] + (“очка1«уф÷ена [0] - “очка2«уф÷ена [0]) * 2.11, Digits);
    ‘ибо_261.8 = NormalizeDouble (“очка2«уф÷ена [0] + (“очка1«уф÷ена [0] - “очка2«уф÷ена [0]) * 2.618, Digits);
    /*
     ак получить цену верхнего и внутреннего уровеней:
    ÷ена уровн€ = ћин÷ена + (ћакс÷ена - ћин÷ена) * фибоуровень

     ак получить цену нижнего уровн€:
    ÷ена уровн€ = ћакс÷ена - (ћакс÷ена - ћин÷ена) * фибоуровень
   */
   }