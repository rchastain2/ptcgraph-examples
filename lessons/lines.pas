program Lines;
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors24; {подключение к программе библиотек Crt и Graph}
var
  Key: Char;
  LineStyle: Word; { номер стиля рисования линии }
  Style: string; { название стиля              }
  GrDriver, GrMode: smallint; { тип и режим работы графического драйвера }
  GrError: Integer; { код ошибки графики          }
begin
  GrDriver := Detect; { автоопределение типа графического драйвера }
  InitGraph(GrDriver, GrMode, ''); { установка графического режима}
  GrError := GraphResult;
  if GrError <> GrOk then
  begin
    Writeln('Обнаружена ошибка!'); Halt
  end;
  SetBkColor(cLightGray); SetColor(cRed); { цвет фона и цвет рисования }
  ClearViewPort;
  {------------------------------------------------------------}
  OutTextXY(120, 100, 'Рисуем линию от точки (200,200) к точке (400,280)');
  Line(200, 200, 400, 280);
  Key := ReadKey; { приостановление исполнения программы }
  ClearViewPort; { очистка окна}
  {-----------------------------------------------------------}
  OutTextXY(240, 80, 'Рисуем ломанную');
  Rectangle(110, 120, 520, 400); { рисование рамки         }
  MoveTo(Round(GetMaxX / 2), Round(GetMaxY / 2)); { указатель в центре окна }

  repeat {цикл прерывается нажатием любой клавиши}
    LineTo(Random(GetMaxX - 250) + 120, Random(GetMaxY - 210) + 120);
    Delay(100);
  until KeyPressed;

  Key := ReadKey; ClearViewPort;
  {-----------------------------------------------------------}
  OutTextXY(190, 80, 'Mеняем стили рисования линий');

  for LineStyle := 0 to 3 do
  begin
    SetLineStyle(LineStyle, 0, 1);
    case LineStyle of
      0: Style := 'Сплошная';
      1: Style := 'Точечная';
      2: Style := 'Штрихпунктирная';
      3: Style := 'Пунктирная'
    end;
    Line(120, 150 + LineStyle * 50, 430, 150 + LineStyle * 50);
    OutTextXY(450, 145 + LineStyle * 50, Style);
  end;

  Key := ReadKey; ClearViewPort; {очистка окна}
  {-----------------------------------------------------------}
  OutTextXY(180, 80, 'Меняем толщину рисования линий');
  SetLineStyle(0, 0, 1); {толщина 1 пиксел }
  Line(140, 200, 430, 200); OutTextXY(450, 195, 'Нормальная');
  SetLineStyle(0, 0, 3); {толщина 3 пиксела}
  Line(140, 250, 430, 250); OutTextXY(450, 245, 'Тройная');
  ReadKey; CloseGraph; {закрытие графического режима}
end.
