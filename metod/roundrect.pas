program RoundRect;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;
const
  RadX = 50; {Горизонтальный радиус}
  lx = 400; {Ширина}
  ly = 100; {Высота}
var
  d, r, e: smallint;
  coo: ArcCoordsType;
  x1, y1: Integer;
  xa, ya: Word;
  RadY: Integer; {Вертикальный радиус}
begin
      {Инициируем графику}

  d := Detect; InitGraph(d, r, ' ');
  e := GraphResult; if e <> grOK then
    WriteLn(GraphErrorMsg(e))
  else
  begin
    SetColor($FF00FF);
    GetAspectRatio(xa, ya); {Получаем отношение сторон}
      {Вычисляем  вертикальный  радиус  и  положение  фигуры  с
    учетом отношения сторон экрана}
    RadY := round(RadX * (xa / ya));
    x1 := (GetMaxX - lx) div 2;
    y1 := (GetMaxY - 2 * RadY - ly) div 2;
      {Вычерчиваем фигуру}
    Line(x1, y1, x1 + lx, y1); {Верхняя горизонтальная}
    Arc(x1 + lx, y1 + RadY, 0, 90, RadX); {Скругление}
    GetArcCoords(coo);
    with coo do
    begin
      Line(Xstart, Ystart, Xstart, Ystart + ly);
      {Правая вертикальная}
      Arc(Xstart - RadX, Ystart + ly, 270, 0, RadX);
      GetArcCoords(coo);
      Line(Xstart, Ystart, Xstart - lx, Ystart);
      {Нижняя горизонтальная}
      Arc(Xstart - lx, Ystart - RadY, 180, 270, RadX);
      GetArcCoords(coo);
      Line(Xstart, Ystart, Xstart, Ystart - ly);
      Arc(Xstart + RadX, Ystart - ly, 90, 180, RadX)
    end;
    if ReadKey = #0 then d := ord(ReadKey);
    CloseGraph
  end
end.
