/*
Индикатор отрисовывает на 5 минутном графике фракталы с часового и 15 минутного графиков.
На 5 минутный график с дополнении к этому индикатору можно повесить простой фрактальный индикатор
*/
#property copyright "Ves Volk"
#property link      ""

#property indicator_chart_window    //индикатор в окне графика
#property indicator_buffers 6       //буферов в индикаторе

extern color Цвет1час  = Black;   //цвет 1 часовых фракталов
extern color Цвет15мин = Red;//цвет 15 минутных фракталов

//значение цены фракталов
double Массив1часВерх  [100];
double Массив1часНиз   [100];
double Массив15минВерх [100];
double Массив15минНиз  [100];

//значение времени фракталов
datetime Массив1часВерхВремя  [100];
datetime Массив1часНизВремя   [100];
datetime Массив15минВерхВремя [100];
datetime Массив15минНизВремя  [100];


int init()
  {
   //создаем объекты для часового фрактала
   ObjectCreate ("ВерхЧас0", OBJ_ARROW, 0, 0, 0);
   ObjectCreate ("ВерхЧас1", OBJ_ARROW, 0, 0, 0);
   ObjectCreate ("ВерхЧас2", OBJ_ARROW, 0, 0, 0);
   ObjectCreate ("ВерхЧас3", OBJ_ARROW, 0, 0, 0);
   ObjectCreate ("ВерхЧас4", OBJ_ARROW, 0, 0, 0);
   ObjectCreate ("ВерхЧас5", OBJ_ARROW, 0, 0, 0);
   ObjectCreate ("ВерхЧас6", OBJ_ARROW, 0, 0, 0);
   ObjectCreate ("ВерхЧас7", OBJ_ARROW, 0, 0, 0);
   ObjectCreate ("НизЧас0", OBJ_ARROW, 0, 0, 0);
   ObjectCreate ("НизЧас1", OBJ_ARROW, 0, 0, 0);
   ObjectCreate ("НизЧас2", OBJ_ARROW, 0, 0, 0);
   ObjectCreate ("НизЧас3", OBJ_ARROW, 0, 0, 0);
   ObjectCreate ("НизЧас4", OBJ_ARROW, 0, 0, 0);
   ObjectCreate ("НизЧас5", OBJ_ARROW, 0, 0, 0);
   ObjectCreate ("НизЧас6", OBJ_ARROW, 0, 0, 0);
   ObjectCreate ("НизЧас7", OBJ_ARROW, 0, 0, 0);
   //устанавливаем цвет для часового фрактала
   ObjectSet ("ВерхЧас0", OBJPROP_COLOR, Цвет1час);
   ObjectSet ("ВерхЧас1", OBJPROP_COLOR, Цвет1час);
   ObjectSet ("ВерхЧас2", OBJPROP_COLOR, Цвет1час);
   ObjectSet ("ВерхЧас3", OBJPROP_COLOR, Цвет1час);
   ObjectSet ("ВерхЧас4", OBJPROP_COLOR, Цвет1час);
   ObjectSet ("ВерхЧас5", OBJPROP_COLOR, Цвет1час);
   ObjectSet ("ВерхЧас6", OBJPROP_COLOR, Цвет1час);
   ObjectSet ("ВерхЧас7", OBJPROP_COLOR, Цвет1час);
   ObjectSet ("НизЧас0", OBJPROP_COLOR, Цвет1час);
   ObjectSet ("НизЧас1", OBJPROP_COLOR, Цвет1час);
   ObjectSet ("НизЧас2", OBJPROP_COLOR, Цвет1час);
   ObjectSet ("НизЧас3", OBJPROP_COLOR, Цвет1час);
   ObjectSet ("НизЧас4", OBJPROP_COLOR, Цвет1час);
   ObjectSet ("НизЧас5", OBJPROP_COLOR, Цвет1час);
   ObjectSet ("НизЧас6", OBJPROP_COLOR, Цвет1час);
   ObjectSet ("НизЧас7", OBJPROP_COLOR, Цвет1час);
   //устанавливаем размер для часового фрактала
   ObjectSet ("ВерхЧас0", OBJPROP_WIDTH, 7);
   ObjectSet ("ВерхЧас1", OBJPROP_WIDTH, 7);
   ObjectSet ("ВерхЧас2", OBJPROP_WIDTH, 7);
   ObjectSet ("ВерхЧас3", OBJPROP_WIDTH, 7);
   ObjectSet ("ВерхЧас4", OBJPROP_WIDTH, 7);
   ObjectSet ("ВерхЧас5", OBJPROP_WIDTH, 7);
   ObjectSet ("ВерхЧас6", OBJPROP_WIDTH, 7);
   ObjectSet ("ВерхЧас7", OBJPROP_WIDTH, 7);
   ObjectSet ("НизЧас0", OBJPROP_WIDTH, 7);
   ObjectSet ("НизЧас1", OBJPROP_WIDTH, 7);
   ObjectSet ("НизЧас2", OBJPROP_WIDTH, 7);
   ObjectSet ("НизЧас3", OBJPROP_WIDTH, 7);
   ObjectSet ("НизЧас4", OBJPROP_WIDTH, 7);
   ObjectSet ("НизЧас5", OBJPROP_WIDTH, 7);
   ObjectSet ("НизЧас6", OBJPROP_WIDTH, 7);
   ObjectSet ("НизЧас7", OBJPROP_WIDTH, 7);
   //устанавливаем код для часового фрактала
   ObjectSet ("ВерхЧас0", OBJPROP_ARROWCODE, 242);
   ObjectSet ("ВерхЧас1", OBJPROP_ARROWCODE, 242);
   ObjectSet ("ВерхЧас2", OBJPROP_ARROWCODE, 242);
   ObjectSet ("ВерхЧас3", OBJPROP_ARROWCODE, 242);
   ObjectSet ("ВерхЧас4", OBJPROP_ARROWCODE, 242);
   ObjectSet ("ВерхЧас5", OBJPROP_ARROWCODE, 242);
   ObjectSet ("ВерхЧас6", OBJPROP_ARROWCODE, 242);
   ObjectSet ("ВерхЧас7", OBJPROP_ARROWCODE, 242);
   ObjectSet ("НизЧас0", OBJPROP_ARROWCODE, 241);
   ObjectSet ("НизЧас1", OBJPROP_ARROWCODE, 241);
   ObjectSet ("НизЧас2", OBJPROP_ARROWCODE, 241);
   ObjectSet ("НизЧас3", OBJPROP_ARROWCODE, 241);
   ObjectSet ("НизЧас4", OBJPROP_ARROWCODE, 241);
   ObjectSet ("НизЧас5", OBJPROP_ARROWCODE, 241);
   ObjectSet ("НизЧас6", OBJPROP_ARROWCODE, 241);
   ObjectSet ("НизЧас7", OBJPROP_ARROWCODE, 241);
//----------------------------------------------------------
   //создаем обхекты для 15 минутного фрактала
   ObjectCreate ("Верх15мин0", OBJ_ARROW, 0, 0, 0);
   ObjectCreate ("Верх15мин1", OBJ_ARROW, 0, 0, 0);
   ObjectCreate ("Верх15мин2", OBJ_ARROW, 0, 0, 0);
   ObjectCreate ("Верх15мин3", OBJ_ARROW, 0, 0, 0);
   ObjectCreate ("Верх15мин4", OBJ_ARROW, 0, 0, 0);
   ObjectCreate ("Верх15мин5", OBJ_ARROW, 0, 0, 0);
   ObjectCreate ("Верх15мин6", OBJ_ARROW, 0, 0, 0);
   ObjectCreate ("Верх15мин7", OBJ_ARROW, 0, 0, 0);
   ObjectCreate ("Низ15мин0", OBJ_ARROW, 0, 0, 0);
   ObjectCreate ("Низ15мин1", OBJ_ARROW, 0, 0, 0);
   ObjectCreate ("Низ15мин2", OBJ_ARROW, 0, 0, 0);
   ObjectCreate ("Низ15мин3", OBJ_ARROW, 0, 0, 0);
   ObjectCreate ("Низ15мин4", OBJ_ARROW, 0, 0, 0);
   ObjectCreate ("Низ15мин5", OBJ_ARROW, 0, 0, 0);
   ObjectCreate ("Низ15мин6", OBJ_ARROW, 0, 0, 0);
   ObjectCreate ("Низ15мин7", OBJ_ARROW, 0, 0, 0);
   //устанавливаем цвет для часового фрактала
   ObjectSet ("Верх15мин0", OBJPROP_COLOR, Цвет15мин);
   ObjectSet ("Верх15мин1", OBJPROP_COLOR, Цвет15мин);
   ObjectSet ("Верх15мин2", OBJPROP_COLOR, Цвет15мин);
   ObjectSet ("Верх15мин3", OBJPROP_COLOR, Цвет15мин);
   ObjectSet ("Верх15мин4", OBJPROP_COLOR, Цвет15мин);
   ObjectSet ("Верх15мин5", OBJPROP_COLOR, Цвет15мин);
   ObjectSet ("Верх15мин6", OBJPROP_COLOR, Цвет15мин);
   ObjectSet ("Верх15мин7", OBJPROP_COLOR, Цвет15мин);
   ObjectSet ("Низ15мин0", OBJPROP_COLOR, Цвет15мин);
   ObjectSet ("Низ15мин1", OBJPROP_COLOR, Цвет15мин);
   ObjectSet ("Низ15мин2", OBJPROP_COLOR, Цвет15мин);
   ObjectSet ("Низ15мин3", OBJPROP_COLOR, Цвет15мин);
   ObjectSet ("Низ15мин4", OBJPROP_COLOR, Цвет15мин);
   ObjectSet ("Низ15мин5", OBJPROP_COLOR, Цвет15мин);
   ObjectSet ("Низ15мин6", OBJPROP_COLOR, Цвет15мин);
   ObjectSet ("Низ15мин7", OBJPROP_COLOR, Цвет15мин);
   //устанавливаем размер для часового фрактала
   ObjectSet ("Верх15мин0", OBJPROP_WIDTH, 4);
   ObjectSet ("Верх15мин1", OBJPROP_WIDTH, 4);
   ObjectSet ("Верх15мин2", OBJPROP_WIDTH, 4);
   ObjectSet ("Верх15мин3", OBJPROP_WIDTH, 4);
   ObjectSet ("Верх15мин4", OBJPROP_WIDTH, 4);
   ObjectSet ("Верх15мин5", OBJPROP_WIDTH, 4);
   ObjectSet ("Верх15мин6", OBJPROP_WIDTH, 4);
   ObjectSet ("Верх15мин7", OBJPROP_WIDTH, 4);
   ObjectSet ("Низ15мин0", OBJPROP_WIDTH, 4);
   ObjectSet ("Низ15мин1", OBJPROP_WIDTH, 4);
   ObjectSet ("Низ15мин2", OBJPROP_WIDTH, 4);
   ObjectSet ("Низ15мин3", OBJPROP_WIDTH, 4);
   ObjectSet ("Низ15мин4", OBJPROP_WIDTH, 4);
   ObjectSet ("Низ15мин5", OBJPROP_WIDTH, 4);
   ObjectSet ("Низ15мин6", OBJPROP_WIDTH, 4);
   ObjectSet ("Низ15мин7", OBJPROP_WIDTH, 4);
   //устанавливаем код для часового фрактала
   ObjectSet ("Верх15мин0", OBJPROP_ARROWCODE, 242);
   ObjectSet ("Верх15мин1", OBJPROP_ARROWCODE, 242);
   ObjectSet ("Верх15мин2", OBJPROP_ARROWCODE, 242);
   ObjectSet ("Верх15мин3", OBJPROP_ARROWCODE, 242);
   ObjectSet ("Верх15мин4", OBJPROP_ARROWCODE, 242);
   ObjectSet ("Верх15мин5", OBJPROP_ARROWCODE, 242);
   ObjectSet ("Верх15мин6", OBJPROP_ARROWCODE, 242);
   ObjectSet ("Верх15мин7", OBJPROP_ARROWCODE, 242);
   ObjectSet ("Низ15мин0", OBJPROP_ARROWCODE, 241);
   ObjectSet ("Низ15мин1", OBJPROP_ARROWCODE, 241);
   ObjectSet ("Низ15мин2", OBJPROP_ARROWCODE, 241);
   ObjectSet ("Низ15мин3", OBJPROP_ARROWCODE, 241);
   ObjectSet ("Низ15мин4", OBJPROP_ARROWCODE, 241);
   ObjectSet ("Низ15мин5", OBJPROP_ARROWCODE, 241);
   ObjectSet ("Низ15мин6", OBJPROP_ARROWCODE, 241);
   ObjectSet ("Низ15мин7", OBJPROP_ARROWCODE, 241);
   return(0);
  }

int deinit()
  {
   ObjectsDeleteAll ();
   return(0);
  }


int start()
  {
   int СчетчикСдвига = 0;
   double СчетчикФракталов [1000];
//--------------------------------------------------------------------------------------
   //вычисляем верхние часовые
   for (int x = 0; СчетчикСдвига < 8; x++)
      {
       СчетчикФракталов [x] = iFractals (Symbol (), PERIOD_H1, MODE_UPPER, x);
       if (СчетчикФракталов [x] != 0)
         {
          Массив1часВерх [СчетчикСдвига] = СчетчикФракталов [x] + 100 * Point;
          Массив1часВерхВремя [СчетчикСдвига] = iTime (Symbol (), PERIOD_H1, x);
          СчетчикСдвига++;
         } 
      }
   //вычисляем нижние часовые
   СчетчикСдвига = 0;
   for (int x1 = 0; СчетчикСдвига < 8; x1++)
      {
       СчетчикФракталов [x1] = iFractals (Symbol (), PERIOD_H1, MODE_LOWER, x1);
       if (СчетчикФракталов [x1] != 0)
         {
          Массив1часНиз [СчетчикСдвига] = СчетчикФракталов [x1];
          Массив1часНизВремя [СчетчикСдвига] = iTime (Symbol (), PERIOD_H1, x1);
          СчетчикСдвига++;
         } 
      }
//-----------------------------------------------------------------------------------------
   //вычисляем верхние 15 минутные
   СчетчикСдвига = 0;
   for (int x2 = 0; СчетчикСдвига < 8; x2++)
      {
       СчетчикФракталов [x2] = iFractals (Symbol (), PERIOD_M15, MODE_UPPER, x2);
       if (СчетчикФракталов [x2] != 0)
         {
          Массив15минВерх [СчетчикСдвига] = СчетчикФракталов [x2] + 50 * Point;
          Массив15минВерхВремя [СчетчикСдвига] = iTime (Symbol (), PERIOD_M15, x2);
          СчетчикСдвига++;
         } 
      }
   //вычисляем нижние 15 минутные
   СчетчикСдвига = 0;
   for (int x3 = 0; СчетчикСдвига < 8; x3++)
      {
       СчетчикФракталов [x3] = iFractals (Symbol (), PERIOD_M15, MODE_LOWER, x3);
       if (СчетчикФракталов [x3] != 0)
         {
          Массив15минНиз [СчетчикСдвига] = СчетчикФракталов [x3];
          Массив15минНизВремя [СчетчикСдвига] = iTime (Symbol (), PERIOD_M15, x3);
          СчетчикСдвига++;
         } 
      }
   //отрисовываем фракталы
   //часовые фракталы
   ObjectSet ("ВерхЧас0", OBJPROP_TIME1, Массив1часВерхВремя [0]); 
   ObjectSet ("ВерхЧас0", OBJPROP_PRICE1, Массив1часВерх [0]);
   ObjectSet ("ВерхЧас1", OBJPROP_TIME1, Массив1часВерхВремя [1]); 
   ObjectSet ("ВерхЧас1", OBJPROP_PRICE1, Массив1часВерх [1]);
   ObjectSet ("ВерхЧас2", OBJPROP_TIME1, Массив1часВерхВремя [2]); 
   ObjectSet ("ВерхЧас2", OBJPROP_PRICE1, Массив1часВерх [2]);
   ObjectSet ("ВерхЧас3", OBJPROP_TIME1, Массив1часВерхВремя [3]); 
   ObjectSet ("ВерхЧас3", OBJPROP_PRICE1, Массив1часВерх [3]);
   ObjectSet ("ВерхЧас4", OBJPROP_TIME1, Массив1часВерхВремя [4]); 
   ObjectSet ("ВерхЧас4", OBJPROP_PRICE1, Массив1часВерх [4]);
   ObjectSet ("ВерхЧас5", OBJPROP_TIME1, Массив1часВерхВремя [5]); 
   ObjectSet ("ВерхЧас5", OBJPROP_PRICE1, Массив1часВерх [5]);
   ObjectSet ("ВерхЧас6", OBJPROP_TIME1, Массив1часВерхВремя [6]); 
   ObjectSet ("ВерхЧас6", OBJPROP_PRICE1, Массив1часВерх [6]);
   ObjectSet ("ВерхЧас7", OBJPROP_TIME1, Массив1часВерхВремя [7]); 
   ObjectSet ("ВерхЧас7", OBJPROP_PRICE1, Массив1часВерх [7]);
   
   ObjectSet ("НизЧас0", OBJPROP_TIME1, Массив1часНизВремя [0]); 
   ObjectSet ("НизЧас0", OBJPROP_PRICE1, Массив1часНиз [0]);
   ObjectSet ("НизЧас1", OBJPROP_TIME1, Массив1часНизВремя [1]); 
   ObjectSet ("НизЧас1", OBJPROP_PRICE1, Массив1часНиз [1]);
   ObjectSet ("НизЧас2", OBJPROP_TIME1, Массив1часНизВремя [2]); 
   ObjectSet ("НизЧас2", OBJPROP_PRICE1, Массив1часНиз [2]);
   ObjectSet ("НизЧас3", OBJPROP_TIME1, Массив1часНизВремя [3]); 
   ObjectSet ("НизЧас3", OBJPROP_PRICE1, Массив1часНиз [3]);
   ObjectSet ("НизЧас4", OBJPROP_TIME1, Массив1часНизВремя [4]); 
   ObjectSet ("НизЧас4", OBJPROP_PRICE1, Массив1часНиз [4]);
   ObjectSet ("НизЧас5", OBJPROP_TIME1, Массив1часНизВремя [5]); 
   ObjectSet ("НизЧас5", OBJPROP_PRICE1, Массив1часНиз [5]);
   ObjectSet ("НизЧас6", OBJPROP_TIME1, Массив1часНизВремя [6]); 
   ObjectSet ("НизЧас6", OBJPROP_PRICE1, Массив1часНиз [6]);
   ObjectSet ("НизЧас7", OBJPROP_TIME1, Массив1часНизВремя [7]); 
   ObjectSet ("НизЧас7", OBJPROP_PRICE1, Массив1часНиз [7]);
   
   //15 минутные фракталы
   ObjectSet ("Верх15мин0", OBJPROP_TIME1, Массив15минВерхВремя [0]); 
   ObjectSet ("Верх15мин0", OBJPROP_PRICE1, Массив15минВерх [0]);
   ObjectSet ("Верх15мин1", OBJPROP_TIME1, Массив15минВерхВремя [1]); 
   ObjectSet ("Верх15мин1", OBJPROP_PRICE1, Массив15минВерх [1]);
   ObjectSet ("Верх15мин2", OBJPROP_TIME1, Массив15минВерхВремя [2]); 
   ObjectSet ("Верх15мин2", OBJPROP_PRICE1, Массив15минВерх [2]);
   ObjectSet ("Верх15мин3", OBJPROP_TIME1, Массив15минВерхВремя [3]); 
   ObjectSet ("Верх15мин3", OBJPROP_PRICE1, Массив15минВерх [3]);
   ObjectSet ("Верх15мин4", OBJPROP_TIME1, Массив15минВерхВремя [4]); 
   ObjectSet ("Верх15мин4", OBJPROP_PRICE1, Массив15минВерх [4]);
   ObjectSet ("Верх15мин5", OBJPROP_TIME1, Массив15минВерхВремя [5]); 
   ObjectSet ("Верх15мин5", OBJPROP_PRICE1, Массив15минВерх [5]);
   ObjectSet ("Верх15мин6", OBJPROP_TIME1, Массив15минВерхВремя [6]); 
   ObjectSet ("Верх15мин6", OBJPROP_PRICE1, Массив15минВерх [6]);
   ObjectSet ("Верх15мин7", OBJPROP_TIME1, Массив15минВерхВремя [7]); 
   ObjectSet ("Верх15мин7", OBJPROP_PRICE1, Массив15минВерх [7]);
   
   ObjectSet ("Низ15мин0", OBJPROP_TIME1, Массив15минНизВремя [0]); 
   ObjectSet ("Низ15мин0", OBJPROP_PRICE1, Массив15минНиз [0]);
   ObjectSet ("Низ15мин1", OBJPROP_TIME1, Массив15минНизВремя [1]); 
   ObjectSet ("Низ15мин1", OBJPROP_PRICE1, Массив15минНиз [1]);
   ObjectSet ("Низ15мин2", OBJPROP_TIME1, Массив15минНизВремя [2]); 
   ObjectSet ("Низ15мин2", OBJPROP_PRICE1, Массив15минНиз [2]);
   ObjectSet ("Низ15мин3", OBJPROP_TIME1, Массив15минНизВремя [3]); 
   ObjectSet ("Низ15мин3", OBJPROP_PRICE1, Массив15минНиз [3]);
   ObjectSet ("Низ15мин4", OBJPROP_TIME1, Массив15минНизВремя [4]); 
   ObjectSet ("Низ15мин4", OBJPROP_PRICE1, Массив15минНиз [4]);
   ObjectSet ("Низ15мин5", OBJPROP_TIME1, Массив15минНизВремя [5]); 
   ObjectSet ("Низ15мин5", OBJPROP_PRICE1, Массив15минНиз [5]);
   ObjectSet ("Низ15мин6", OBJPROP_TIME1, Массив15минНизВремя [6]); 
   ObjectSet ("Низ15мин6", OBJPROP_PRICE1, Массив15минНиз [6]);
   ObjectSet ("Низ15мин7", OBJPROP_TIME1, Массив15минНизВремя [7]); 
   ObjectSet ("Низ15мин7", OBJPROP_PRICE1, Массив15минНиз [7]);
   
   return(0);
  }

