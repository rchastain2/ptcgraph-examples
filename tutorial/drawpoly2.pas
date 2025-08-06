
program drawpoly2;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;
  
const
  A = 2 * PI / 8;
  
var
  pilote, mode: smallint;
  points: array[0..8] of PointType;
  xc, yc, r, i: integer;
  
begin
  pilote := d8bit;
  mode := m640x480;
  InitGraph(pilote, mode, '');
  xc := GetMaxX div 2;
  yc := GetMaxY div 2;
  r := GetMaxY div 3;
  
  for i := 0 to 8 do
  begin
    points[i].x := xc + Round(r * Cos(A * i));
    points[i].y := yc + Round(r * Sin(A * i));
  end;
  
  DrawPoly(SizeOf(points) div SizeOf(PointType), points);
  
  ReadKey;
  CloseGraph;
end.

