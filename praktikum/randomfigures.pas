program RandomFigures;
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;
var
  Key: Char;
  GrDriver, GrMode: SmallInt;
  Radius, MaxX, MaxY, Ugol: Word; { параметры процедур }
begin
  GrDriver := Detect; { автоопределение типа графического драйвера }
  InitGraph(GrDriver, GrMode, ''); { установка графического режима }
  SetTextStyle(DefaultFont, HorizDir, 2);
                         { установка шрифта, направления и размера символов }
  OutTextXY(160, 50, 'Рисуем звездное небо');
  Rectangle(110, 90, 520, 380); { рисование рамки }
  Randomize; { инициализация датчика случайных чисел }

  repeat { цикл прерывается нажатием любой клавиши }
    PutPixel(Random(GetMaxX - 250) + 120, Random(GetMaxY - 210) + 100,
      Random(15)); { вывод пикселя в области, ограниченной рамкой }
    Delay(5) { задержка                                     }
  until KeyPressed;

  Key := ReadKey; ClearDevice; { очистка графического экрана }
        {-------------------------------------------}
  SetColor(White); {  цвет рисования             }
  OutTextXY(140, 30, 'Рисуем случайные эллипсы');
  Rectangle(100, 70, 560, 420); { рисование рамки            }
  MaxX := GetMaxX;
  MaxY := GetMaxY;
  Radius := MaxY div 10;
  SetLineStyle(0, 0, 1); { толщина и стиль линии }
  SetViewPort(101, 71, 559, 419, ClipOn); { установка окна внутри рамки }
  Randomize; { инициализация датчика случайных чисел }

  repeat { цикл прерывается нажатием любой клавиши }
    SetBkColor(Black); { цвет фона                               }
    SetColor(Random(13) + 1); { цвет рисования                          }
    SetFillStyle(Random(12), Random(13) + 1); { образец и цвет штриховки  }
    FillEllipse(Random(MaxX), Random(MaxY), { координаты центра эллипса }
      Random(Radius), Random(Radius)); { полуоси эллипса           }
  until KeyPressed;

  Key := ReadKey;
  ClearDevice; { очистка графического экрана }
        {-------------------------------------------}
  SetColor(White); SetViewPort(1, 1, GetMaxX, GetMaxY, ClipOn);
  OutTextXY(140, 20, 'Рисуем случайные секторы');
  Rectangle(90, 60, 570, 420); { рисование рамки }
  SetViewPort(92, 62, 569, 419, ClipOn); { установка окна внутри рамки }

  repeat { цикл прерывается нажатием любой клавиши }
    SetFillStyle(Random(12), Random(13) + 1); { изменение штриховки и цвета }
    Ugol := Random(360); { угол сектора                }
    Sector(Random(MaxX - 200), Random(MaxY - 180), Random(Ugol), Ugol,
      Random(Radius * 2), Random(Radius * 2)); { рисование сектора           }
  until KeyPressed;

  ClearViewPort; { очистка окна                 }
  CloseGraph; { закрытие графического режима }
end.
