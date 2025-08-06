
program Penguin;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors16;
  
var
  a, b: array[1..100] of PointType;
  x, y: integer;
  i, j, k: integer;

var
  d, m: smallint;
  
begin
  d := VESA;
  m := m640x480x64k;
  InitGraph(d, m, '');
  
  SetBkColor(cSnow);
  SetColor(cOrange);
  ClearDevice;
  
  x := 20;
  y :=  x;
  i :=  0;
  j :=  0;

  while i <= x * 13 do
  begin
    Line(0 + i, 0, 0 + i, y * 21);
    i := i + x;
  end;
  
  while j <= y * 21 do
  begin
    Line(0, 0 + j, x * 13, 0 + j);
    j := j + y;
  end;
  
  i := 1;
  a[i].x := x * 11; a[i].y := y *  6; Inc(i);
  a[i].x := x * 11; a[i].y := y *  8; Inc(i);
  a[i].x := x * 10; a[i].y := y * 10; Inc(i);
  a[i].x := x * 10; a[i].y := y * 12; Inc(i);
  a[i].x := x * 11; a[i].y := y * 14; Inc(i);
  a[i].x := x *  9; a[i].y := y * 16; Inc(i);
  a[i].x := x *  9; a[i].y := y * 18; Inc(i);
  a[i].x := x *  8; a[i].y := y * 20; Inc(i);
  a[i].x := x *  5; a[i].y := y * 20; Inc(i);
  a[i].x := x *  7; a[i].y := y * 19; Inc(i);
  a[i].x := x *  5; a[i].y := y * 18; Inc(i);
  a[i].x := x *  7; a[i].y := y * 18; Inc(i);
  a[i].x := x *  7; a[i].y := y * 17; Inc(i);
  a[i].x := x *  8; a[i].y := y * 18; Inc(i);
  a[i].x := x *  8; a[i].y := y * 15; Inc(i);
  a[i].x := x *  7; a[i].y := y * 15; Inc(i);
  a[i].x := x *  6; a[i].y := y * 14; Inc(i);
  a[i].x := x *  6; a[i].y := y * 16; Inc(i);
  a[i].x := x *  7; a[i].y := y * 16; Inc(i);
  a[i].x := x *  3; a[i].y := y * 18; Inc(i);
  a[i].x := x *  4; a[i].y := y * 17; Inc(i);
  a[i].x := x *  2; a[i].y := y * 17; Inc(i);
  a[i].x := x *  4; a[i].y := y * 16; Inc(i);
  a[i].x := x *  3; a[i].y := y * 15; Inc(i);
  a[i].x := x *  5; a[i].y := y * 15; Inc(i);
  a[i].x := x *  5; a[i].y := y * 13; Inc(i);
  a[i].x := x *  4; a[i].y := y * 12; Inc(i);
  a[i].x := x *  4; a[i].y := y *  9; Inc(i);
  a[i].x := x *  6; a[i].y := y *  4; Inc(i);
  a[i].x := x *  5; a[i].y := y *  3; Inc(i);
  a[i].x := x *  3; a[i].y := y *  3; Inc(i);
  a[i].x := x *  5; a[i].y := y *  2; Inc(i);
  a[i].x := x *  6; a[i].y := y *  1; Inc(i);
  a[i].x := x *  8; a[i].y := y *  1; Inc(i);
  a[i].x := x *  9; a[i].y := y *  2; Inc(i);
  a[i].x := x *  9; a[i].y := y *  3; Inc(i);
  a[i].x := x * 11; a[i].y := y *  6; Inc(i);
  
  k := i;
  i := 1;
  b[i].x := x *  6; b[i].y := y *  4; Inc(i);
  b[i].x := x *  9; b[i].y := y *  6; Inc(i);
  b[i].x := x *  8; b[i].y := y *  8; Inc(i);
  b[i].x := x *  7; b[i].y := y *  8; Inc(i);
  b[i].x := x *  5; b[i].y := y *  9; Inc(i);
  b[i].x := x *  9; b[i].y := y *  9; Inc(i);
  b[i].x := x * 10; b[i].y := y *  7;
  
  SetColor(cBlue);
  SetLineStyle(SolidLn, 0, ThickWidth);
  DrawPoly(k - 1, a);
  DrawPoly(i, b);
  Circle(x * 6, y * 2, 1);
  
  ReadKey;
end.
