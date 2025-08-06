
program Forest;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors16;
  
procedure Triangle(x, y, h: smallint; style, col1, col2: longword);
begin
  SetColor(col2);
  MoveTo(x, y);
  LineRel(h div 2, h);
  LineRel(-h, 0);
  LineRel(h div 2, -h);
  SetFillStyle(style, col1);
  FloodFill(x, y + (h div 2), col2);
end;

procedure DrawTree(a, b, h, stl, color1, color2: longword);
var
  i: byte;
begin
  for i := 1 to 3 do
  begin
    triangle(a, b, h, stl, color1, color2);
    b := b + h;
    h := h + 5
  end;
  Rectangle(a - (h div 10), b, a + (h div 10), b + h);
  SetFillStyle(stl, color2);
  FloodFill(a - (h div 10) + 1, b + 1, color2);
end;

procedure Forest(N: byte);
var
  i: byte;
  stl, a, b, h: integer;
begin
  for i := 1 to n do
  begin
    h := Random(30) + 10;
    a := Random(600) + 20;
    b := Random(400) + 5;
    stl := Random(11) + 1;
    DrawTree(a, b, h, stl, cYellowGreen, cForestGreen);
  end;
end;

var
  d, m: smallint;
  
begin
  d := VESA;
  m := m640x480x64k;
  InitGraph(d, m, '');
  
  Randomize;

  SetBkColor(cSnow);
  ClearDevice;
  Forest(25);
  
  ReadKey;
  CloseGraph
end.
