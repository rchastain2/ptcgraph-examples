
program flocon1;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors16;

var
  a, b: double;

procedure Koch(x1, y1, x2, y2: double);
var
  sx1, sx2, sx3,
  sy1, sy2, sy3: double;
  l: double;
begin
  l := Sqrt(Sqr(x2 - x1) + Sqr(y2 - y1));
  if l > 3 then
  begin
    sx1 := (2 * x1 + x2) / 3;
    sy1 := (2 * y1 + y2) / 3;
    sx3 := (x1 + 2 * x2) / 3;
    sy3 := (y1 + 2 * y2) / 3;
    sx2 := sx1 + a * (sx3 - sx1) + b * (sy3 - sy1);
    sy2 := sy1 - b * (sx3 - sx1) + a * (sy3 - sy1);
    Koch( x1,  y1, sx1, sy1);
    Koch(sx1, sy1, sx2, sy2);
    Koch(sx2, sy2, sx3, sy3);
    Koch(sx3, sy3,  x2,  y2);
  end else
  begin
    Line(Round(x1), Round(y1), Round(x2), Round(y2));
  end;
end;

var
  d1, d2, d3,
  f1, f2, f3: double;
  c: double;
  d, m: smallint;
  
begin
  d := VESA;
  m := m800x600x64k;
  InitGraph(d, m, '');
  
  SetBkColor(cDarkSlateGray);
  SetColor(cYellow);
  ClearDevice;
  
  a := Cos(pi / 3);
  b := Sin(pi / 3);
  c := 2 * GetMaxY / (3 * b);
  d1 := GetMaxX / 2 - c / 2;
  d3 := GetMaxX / 2 + c / 2;
  f1 := GetMaxY - c * b / 2;
  f3 := f1;
  d2 := d1 + a * (d3 - d1) + b * (f3 - f1);
  f2 := f1 - b * (d3 - d1) + a * (f3 - f1);
  
  Koch(d1, f1, d2, f2);
  Koch(d2, f2, d3, f3);
  Koch(d3, f3, d1, f1);
  
  ReadKey;
  CloseGraph;
end.
