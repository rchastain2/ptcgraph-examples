program SquareWhirl2;
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
  TPolygon = record
    Pol: array[0..10] of PointType;
    Size: word;
  end;

var
  Length,
    Color,
    x0, y0: word;

procedure InitGr;
var
  gd, gm: smallint;
begin
  gd := Detect;
  InitGraph(gd, gm, '..\bgi');
  if Graphresult <> 0 then
    Halt;
end;

procedure Rotate2D(var P: TPolygon; Angle: single);
var
  _cos, _sin: single;
  k: word;
  xx, yy: integer;
begin
  _cos := cos(Angle);
  _sin := sin(Angle);
  for k := 0 to P.Size - 1 do
    with P.Pol[k] do
    begin
      xx := round(x * _cos + y * _sin);
      yy := round(y * _cos - x * _sin);
      x := x0 + xx;
      y := y0 - yy;
    end;
end;

procedure PlotFigure(P: TPolygon);
var
  k: word;
begin
  inc(Color);
  SetColor(Color);

  with P.Pol[0] do
    MoveTo(X, Y);

  for k := 1 to P.Size - 1 do
    with P.Pol[k] do
      LineTo(X, Y);

  with P.Pol[0] do
    LineTo(X, Y);

  FillPoly(P.Size, P.Pol);
end;

procedure PlotSquare(Length: word; phi: single);
var
  Polygon: TPolygon;

begin
  with Polygon do
  begin
    Size := 4;

    Pol[0].X := -Length div 2;
    Pol[0].Y := -Pol[0].X;

    Pol[1].X := Pol[0].X + length;
    Pol[1].Y := Pol[0].Y;

    Pol[2].X := Pol[1].X;
    Pol[2].Y := Pol[0].Y - length;

    Pol[3].X := Pol[0].X;
    Pol[3].Y := Pol[2].Y;
  end;

  Rotate2D(Polygon, phi);
  PlotFigure(Polygon);
end;

var
  i: word;
  Coeff: single;
  Alpha,
    Beta: single;

begin
  Alpha := Arctan(m / (1.0 - m));
  Beta := 0.0;
  InitGr;

  Color := GetMaxColor div 4;

  x0 := GetMaxX div 2;
  y0 := GetMaxY div 2;

  Length := y0;
  Coeff := M / sin(Alpha);

  for i := 1 to Max do
  begin
    PlotSquare(Length, Beta);
    Beta := Beta + Alpha;
    Length := round(Length * Coeff);
  end;

  repeat until keypressed;
  CloseGraph;
end.
