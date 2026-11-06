program Ellipses;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;
var
  d, r, e: smallint;
  xa, ya: Word;
begin
             {Инициируем графику}
  d := Detect; InitGraph(d, r, '');
  e := GraphResult; if e <> grOK then
    WriteLn(GraphErrorMsg(e))
  else
  begin
    SetColor($FF00FF);
             {Первый график}
    OutTextXY(50, 40, 'RX = RY'); {Надпись}
    Line(0, 100, 160, 100); {Ось X}
    Line(80, 55, 80, 145); {Ось Y}
    Ellipse(80, 100, 180, 90, 40, 40);
             {Второй график}
    OutTextXY(260, 40, 'RX = 5*RY');
    Line(190, 100, 410, 100);
    Line(300, 55, 300, 145);
    Ellipse(300, 100, 0, 359, 100, 20);
             {Третий график}
    OutTextXY(465, 40, 'Aspect Ratio');

    Line(440, 100, 600, 100);
    Line(520, 55, 520, 145);
    GetAspectRatio(xa, ya);
    Ellipse(520, 100, 0, 270, 40, round(40 * (xa / ya)));
    if ReadKey = #0 then
      d := ord(ReadKey);
    CloseGraph
  end
end.
