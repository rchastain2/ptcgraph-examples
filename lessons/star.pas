program Star;
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors24; { подключение к программе библиотек Crt и Graph   }
const { массив координат вершин многоугольника (звезды) }
  TopsStar: array[1..18] of Integer = (300, 125, 325, 225, 425, 250,
    325, 275, 300, 375, 275, 275, 180, 250, 275, 225, 300, 125);
var
  i, j, GrDriver, GrMode: smallint;
begin
  GrDriver := Detect;
  InitGraph(GrDriver, GrMode, ''); {установка графического режима}
  SetTextStyle(DefaultFont, HorizDir, ThickWidth); {установка шрифта, направления}
                                             {и размера символов           }
  SetColor(cOrange);
  OutTextXY(220, 60, 'S T A R ');
  SetTextStyle(DefaultFont, VertDir, ThickWidth);
  OutTextXY(140, 150, 'S T A R ');
  SetTextStyle(DefaultFont, VertDir, ThickWidth);
  OutTextXY(500, 150, 'S T A R ');

  i := 0;
  repeat
    j := i mod 12; { j - остаток от деления i на 12 }
    SetFillStyle(j, {Random(13)} cRed); { штриховка и фон                }
    FillPoly(9, TopsStar); { рисование и штриховка звезды   }
    Inc(i); { увеличение i на 1              }
    Delay(500)
  until KeyPressed; { завершение цикла нажатием любой клавиши }

  CloseGraph
end.
