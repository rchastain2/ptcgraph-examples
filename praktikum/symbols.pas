program Symbols;
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors24; { подключение к программе библиотек Crt и Graph }
var
  Key: Char;
  Font: string; { названия шрифтов }
  Size, MyFont: Word;
  GrDriver, GrMode: smallint; { тип и режим работы графического драйвера}
begin
  GrDriver := Detect; {автоопределение типа графического драйвера}
  InitGraph(GrDriver, GrMode, ''); {установка графического режима}
  if GraphResult <> GrOk then Halt;
  {-----------------------------------------------------------}
  SetTextStyle(DefaultFont, HorizDir, 2);
  SetBkColor(cLightGray); SetColor(cRed);
  OutTextXY(140, 80, 'Меняем размер символов');
  OutTextXY(220, 100, 'и цвет фона');

  for Size := 0 to 13 do {Size - цвет фона и размер символов}
  begin
    SetBkColor(Size); { изменение цвета фона }
    Rectangle(135, 425, 470, 450); { рисование рамки      }
    SetTextStyle(DefaultFont, HorizDir, 1);
    OutTextXY(150, 435, 'Для продолжения нажмите любую клавишу !');
    SetTextStyle(DefaultFont, HorizDir, Size);
    OutTextXY(250 - Size * 15, 200, 'HELLO');
    Key := ReadKey; ClearViewPort;
  end;
  ReadKey;
  {-----------------------------------------------------------}
  SetBkColor(cLightGray); SetColor(cRed); { цвет фона и цвет рисования }
  SetTextStyle(DefaultFont, HorizDir, 2);
                     { установка шрифта, направления и размера символов }
  OutTextXY(70, 100, 'Располагаем строку горизонтально');
  SetTextStyle(DefaultFont, VertDir, 2);
  OutTextXY(310, 150, 'и вертикально');
  Key := ReadKey; ClearViewPort;
  {-----------------------------------------------------------}
  SetTextStyle(DefaultFont, HorizDir, 2);
                     { установка шрифта, направления и размера символов }
  OutTextXY(220, 30, 'Меняем шрифты');

  for MyFont := 0 to 9 do { цикл по номерам шрифтов }
  begin
    case MyFont of
      0: Font := '0 - Точечный (Default)';
      1: Font := '1 - Утроенный (Triplex)';
      2: Font := '2 - Уменьшенный (Small)';
      3: Font := '3 - Прямой (SansSerif)';
      4: Font := '4 - Готический (Gothic)';
      5: Font := '5 - Рукописный';
      6: Font := '6 - Курьер';
      7: Font := '7 - Красивый (Tаймс Italic)';
      8: Font := '8 - Таймс Roman';
      9: Font := '9 - Курьер увеличенный';
    end;
    SetTextStyle(MyFont, HorizDir, 2);
    OutTextXY(40, 70 + MyFont * 35, 'abcdfxyz 0123456789'); { вывод текста }
    SetTextStyle(DefaultFont, HorizDir, 1);
    OutTextXY(410, 80 + MyFont * 35, Font) { вывод названия шрифта }
  end;

  OutTextXY(380, 60, 'N шрифта Описание'); ReadKey;
  CloseGraph; { закрытие графического режима }
end.
