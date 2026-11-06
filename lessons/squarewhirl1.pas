program SquareWhirl1;
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcCrt,
  ptcGraph;

const
  m = 0.1;
  Max = 20;

type
  TPoint = record
    x, y: integer;
  end;

  TPolygon = array[0..10] of TPoint;
var
  Length,
    x0, y0: word; { центр экрана, точка отсчёта }

procedure InitGr;
var
  gd, gm: smallint;
begin
  gd := Detect;
  InitGraph(gd, gm, '..\bgi');
  if Graphresult <> 0 then
    Halt;
end;

{ Вращение объекта вокруг своей оси на Angle радиан}

procedure Rotate2D(var P: TPolygon; Angle: single);
var
  _cos, _sin: single;
  k: word;
  xx, yy: integer;
begin
  _cos := cos(Angle);
  _sin := sin(Angle);
  for k := 1 to P[0].x do
    with P[k] do
    begin
      xx := round(x * _cos + y * _sin);
      yy := round(y * _cos - x * _sin);
      { перевод в экранные координаты }
      x := x0 + xx;
      y := y0 - yy;
    end;
end;

{ построение фигуры }

procedure PlotFigure(P: TPolygon);
var
  k: word;
begin
  { установка позиции граф. курсора на 1-ю точку }
  MoveTo(P[1].X, P[1].Y);

  for k := 2 to P[0].X do
    { отрисовка линий от граф. курсора до точки }
    LineTo(P[k].X, P[k].Y);

  { отрисовка замыкающей линии }
  LineTo(P[1].X, P[1].Y);
end;

procedure PlotSquare(Length: word; phi: single);
var
  Polygon: TPolygon;

begin
  { так зададим кол-во сторон полигона  }
  Polygon[0].X := 4;

  { инициализация координат, относительно x0 и y0 }
  Polygon[1].X := -Length div 2;
  Polygon[1].Y := -Polygon[1].X;

  Polygon[2].X := Polygon[1].X + length;
  Polygon[2].Y := Polygon[1].Y;

  Polygon[3].X := Polygon[2].X;
  Polygon[3].Y := Polygon[1].Y - length;

  Polygon[4].X := Polygon[1].X;
  Polygon[4].Y := Polygon[3].Y;

  Rotate2D(Polygon, phi);
  PlotFigure(Polygon);
end;

var
  i: word;
  Coeff: single;
  Alpha, Beta: single;

begin
  Alpha := Arctan(m / (1.0 - m));
  Beta := 0.0;

  InitGr;
  
  SetColor($FFFF00);
  
  x0 := GetMaxX div 2;
  y0 := GetMaxY div 2;

  { Длина стороны квадрата размером в полэкрана }
  Length := y0;

  { коэффициент уменьшения стороны квадрата }
  Coeff := M / sin(Alpha);

  for i := 1 to Max do
  begin
    { построить квадрат со стороной Length и поворотом Beta }
    PlotSquare(Length, Beta);

    { увеличить величину поворота на угол Alpha }
    Beta := Beta + Alpha;
    Length := round(Length * Coeff);
  end;

  repeat until keypressed;
  CloseGraph;
end.
