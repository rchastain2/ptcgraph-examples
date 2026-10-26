program Design;
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors24; { подключение к программе библиотек Crt и Graph }
const
  Height: array[1..8] of Integer = (40, 150, 90, 240, 190, 120, 50, 90);
                                         { массив высот столбиков диаграммы }
var
  Color: Word; { код цвета }
  Key: Char;
  i, x: Integer;
  GrDriver, GrMode: SmallInt; {тип и режим работы графического драйвера}
  GrError: SmallInt; { код ошибки графики                       }
begin
  GrDriver := Detect; InitGraph(GrDriver, GrMode, '');
  GrError := GraphResult; if GrError <> GrOk then Halt;

  ClearViewPort;
  SetTextStyle(DefaultFont, HorizDir, 2);
  OutTextXY(100, 20, 'Рисуем столбиковую диаграмму');
  x := 50; Randomize; { инициализация датчика случайных чисел }

  for i := 1 to 8 do { цикл по столбикам диаграммы           }
  begin
    Color := Random(GetMaxColor + 1); { задание кода цвета (кроме черного)    }
    SetFillStyle(i, Color); { задание типа штриховки и цвета        }
    SetColor(Color);
    Bar3D(x, 350 - Height[i], x + 50, 380, 20, TopOn); {рисование столбика}
    x := x + 70; { изменение координаты x };
    Delay(200);
  end;

  Key := ReadKey; CloseGraph; {Закрытие графического режима}
end.
