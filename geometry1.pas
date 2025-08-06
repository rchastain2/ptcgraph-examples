
program ex12;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors16;
  
var
  a, n, xc, yc, i: smallint;
  m, ax, bx, cx, ay, by, cy: single;
  
var
  gd, gm: smallint;
  
begin
  gd := VESA;
  gm := m640x480x64k;
  InitGraph(gd, gm, '');
  
  SetBkColor(cDarkSlateGray);
  SetColor(cYellow);
  ClearDevice;
  
  a := 200;
  n := 20;
  m := 0.08;
  xc := GetMaxX div 2;
  yc := GetMaxY div 2;
  ax := xc + a * Cos(pi / 2);
  ay := yc - a * Sin(pi / 2);
  bx := xc + a * Cos(7 * pi / 6);
  by := yc - a * Sin(7 * pi / 6);
  cx := xc + a * Cos(11 * pi / 6);
  cy := yc - a * Sin(11 * pi / 6);
  for i := 1 to n + 1 do
  begin
    Line(Round(ax), Round(ay), Round(bx), Round(by));
    Line(Round(bx), Round(by), Round(cx), Round(cy));
    Line(Round(cx), Round(cy), Round(ax), Round(ay));
    ax := ax + (bx - ax) * m;
    ay := ay + (by - ay) * m;
    bx := bx + (cx - bx) * m;
    by := by + (cy - by) * m;
    cx := cx + (ax - cx) * m;
    cy := cy + (ay - cy) * m;
  end;
  
  ReadKey;
end.
