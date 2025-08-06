
program ex30;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors16;
  
procedure Figura(x1, y1, d, m, u: smallint; c: longword);
var
  a, i, d1: smallint;
  p: array[1..9] of PointType;
begin
  d1 := d div m;
  a := u;
  for i := 1 to 8 do
  begin
    if i mod 2 = 0 then
    begin
      p[i].x := x1 + Round(d * Cos(a * pi / 180));
      p[i].y := y1 - Round(d * Sin(a * pi / 180));
    end
    else
    begin
      p[i].x := x1 + Round(d1 * Cos(a * pi / 180));
      p[i].y := y1 - Round(d1 * Sin(a * pi / 180));
    end;
    a := a + 45;
  end;
  p[9].x := p[1].x;
  p[9].y := p[1].y;
  
  MoveTo(p[1].x, p[1].y);
  SetColor(c);
  
  for i := 1 to 9 do
    LineTo(p[i].x, p[i].y);
  
  SetFillStyle(1, c);
  FloodFill(x1, y1, c);
end;

var
  xc, yc: smallint;
var
  d, m: smallint;
  
begin
  d := VESA;
  m := m640x480x64k;
  InitGraph(d, m, '');
  
  SetBkColor(cDarkSlateGray);
  ClearDevice;
  
  xc := GetMaxX div 2;
  yc := GetMaxY div 2;
  
  Figura(xc, yc, 240, 5, -45, cRed);
  Figura(xc, yc, 160, 8,   0, cOrange);
  
  ReadKey;
end.


