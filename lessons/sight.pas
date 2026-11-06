program Sight;
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors24; { подключение к программе библиотек Crt и Graph }
const
  Step = 5; { шаг изменения координат центра прицела        }
  Instr = 'УПРАВЛЕНИЕ ДВИЖЕНИЕМ ПРИЦЕЛА - СТРЕЛКИ, ВЫХОД - ESC';
var
  GrDriver, GrMode: smallint; {тип и режим работы графического драйвера}
  X, Y: Integer; { координаты центра прицела              }
  XStr, YStr: string;
  Ch: Char;
 {-----------------------------------------------------------}

procedure MakeSight(X, Y: Integer); { процедура рисования прицела }
begin
  SetColor(cWhite);
  Circle(X, Y, 80);
  SetColor(cLightGreen);
  Line(X - 80, Y, X + 80, Y); Line(X, Y - 63, X, Y + 63); { вывод осей прицела }
  SetColor(cLightRed); Circle(X, Y, 2); { окружность в центре прицела }
  Str(X, XStr); Str(Y, YStr); { перевод координат в строковый тип }
  SetColor(cYellow);
  OutTextXY(X + 5, Y - 35, 'x=' + XStr); { вывод координат центра прицела }
  OutTextXY(X + 5, Y - 20, 'y=' + YStr)
end;
 {-----------------------------------------------------------}
begin
  GrDriver := Detect;
  InitGraph(GrDriver, GrMode, '');
  SetColor(cLightGray);
  X := GetMaxX div 2; Y := GetMaxY div 2; { координаты центра экрана }
  Rectangle(50, 425, 600, 460); { рисование рамки          }
  OutTextXY(120, 440, Instr);
  MakeSight(X, Y); { рисование прицела в центре экрана }

  while TRUE do { цикл работы программы до прерывания по клавише ESC }
  begin
    Ch := ReadKey;
    case Ch of
      #27:
        begin
          CloseGraph; Halt(1)
        end; { выход по клавише ESC }
      #75: X := X - Step; {изменение координат x, y нажатием стрелок}
      #77: X := X + Step; {"влево", "вправо", "вверх", "вниз"       }
      #72: Y := Y - Step;
      #80: Y := Y + Step
    end;

    ClearViewPort; { очистка графического экрана     }
    SetColor(cLightGray); { восстановление рамки с надписью }
    Rectangle(50, 425, 600, 460);
    OutTextXY(120, 440, Instr);
    MakeSight(X, Y) { рисование прицела в текущих координатах }
  end;

  CloseGraph;
end.
