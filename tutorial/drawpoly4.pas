
program ex24;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors16;
  
const
  n = 8;
  
var
  poly: array[1..n + 1] of PointType;
  r, x, y, i: smallint;
  alpha: Single;
  
var
  d, m: smallint;
  
begin
  d := VESA;
  m := m640x480x64k;
  InitGraph(d, m, '');
  
  r := 100;
  alpha := 0;
  
  SetBkColor(cDarkSlateGray);
  SetColor(cYellow);
  ClearDevice;
  repeat
    x := GetMaxX shr 1;
    y := GetMaxY shr 1;
    for i := 1 to n + 1 do
    begin
      poly[i].X := x + Round(R * Cos(alpha + (i - 1) * 2 * pi / n));
      poly[i].Y := y + Round(R * Sin(alpha + (i - 1) * 2 * pi / n));
    end;
    SetColor(cYellow);
    DrawPoly(n + 1, poly);
    alpha := alpha + pi / 180;
    Delay(100);
    SetColor(cDarkSlateGray);
    DrawPoly(n + 1, poly);
  until KeyPressed;
  CloseGraph;
end.
