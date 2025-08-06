
program ex14;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors16;
  
const
  a = 23;
  b = 20;
  c = 27;
  x: array[1..34] of PointType = (
    (X: 02 * a; Y: 13 * a),
    (X: 04 * a; Y: 11 * a),
    (X: 05 * a; Y: 08 * a),
    (X: 08 * a; Y: 06 * a),
    (X: 12 * a; Y: 05 * a),
    (X: 12 * a; Y: 05 * a),
    (X: 13 * a; Y: 07 * a),
    (X: 16 * a; Y: 09 * a),
    (X: 17 * a; Y: 08 * a),
    (X: 18 * a; Y: 08 * a),
    (X: 19 * a; Y: 09 * a),
    (X: 20 * a; Y: 09 * a),
    (X: 22 * a; Y: 11 * a),
    (X: 21 * a; Y: 12 * a),
    (X: 19 * a; Y: 12 * a),
    (X: 19 * a; Y: 13 * a),
    (X: 20 * a; Y: 13 * a),
    (X: 20 * a; Y: 15 * a),
    (X: 18 * a; Y: 19 * a),
    (X: 16 * a; Y: 17 * a),
    (X: 17 * a; Y: 15 * a),
    (X: 17 * a; Y: 14 * a),
    (X: 16 * a; Y: 14 * a),
    (X: 16 * a; Y: 19 * a),
    (X: 13 * a; Y: 19 * a),
    (X: 13 * a; Y: 13 * a),
    (X: 08 * a; Y: 13 * a),
    (X: 09 * a; Y: 17 * a),
    (X: 08 * a; Y: 17 * a),
    (X: 08 * a; Y: 18 * a),
    (X: 05 * a; Y: 18 * a),
    (X: 06 * a; Y: 14 * a),
    (X: 05 * a; Y: 11 * a),
    (X: 02 * a; Y: 13 * a)
  );
  y: array[1..23] of PointType = (
    (X: 17 * a; Y: 02 * a),
    (X: 19 * a; Y: 03 * a),
    (X: 23 * a; Y: 03 * a),
    (X: 25 * a; Y: 02 * a),
    (X: 27 * a; Y: 04 * a),
    (X: 27 * a; Y: 08 * a),
    (X: 24 * a; Y: 10 * a),
    (X: 23 * a; Y: 08 * a),
    (X: 23 * a; Y: 12 * a),
    (X: 22 * a; Y: 13 * a),
    (X: 19 * a; Y: 13 * a),
    (X: 19 * a; Y: 12 * a),
    (X: 21 * a; Y: 12 * a),
    (X: 22 * a; Y: 11 * a),
    (X: 20 * a; Y: 09 * a),
    (X: 19 * a; Y: 09 * a),
    (X: 19 * a; Y: 09 * a),
    (X: 18 * a; Y: 08 * a),
    (x: 17 * a; y: 08 * a),
    (X: 16 * a; Y: 09 * a),
    (X: 13 * a; Y: 07 * a),
    (X: 12 * a; Y: 05 * a),
    (X: 17 * a; Y: 02 * a)
  );

var
  i: integer;
  d, m: smallint;
  
begin
  d := VESA;
  m := m640x480x64k;
  InitGraph(d, m, '');
    
  SetBkColor(cSnow);
  SetColor(cOrange);
  ClearDevice;
  
  for i := 1 to b do Line(a, a * i, c * a, a * i);
  for i := 1 to c do Line(a * i, a, a * i, b * a);
  
  SetColor(cBlue);
  SetLineStyle(SolidLn, 0, ThickWidth);
  DrawPoly(34, x);
  DrawPoly(23, y);
  Circle(18 * a, 06 * a, a - 7);
  Circle(22 * a, 06 * a, a - 7);
  
  ReadKey;
  CloseGraph;
end.


