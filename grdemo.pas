
program grdemo;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcCrt, ptcGraph;
  
var
  Xm, Ym, Xk, Yk: Integer;

procedure GrInit;
var
  Gd, Gm: smallint;
begin
  Gd := d8bit;
  Gm := m800x600;
  InitGraph(Gd, Gm, 'C:\Tp\Bgi');
  if GraphResult <> 0 then Halt;
  Xm := GetMaxX;
  Ym := GetMaxY;
  Xk := Xm div 2;
  Yk := Ym div 2;
end;
begin
  GrInit;
  Randomize;
  repeat
    PutPixel(Random(Xk), Random(Yk), Random(16));
    SetColor(Random(16));
    Line(Xk + Random(Xk), Random(Yk), Xk + Random(Xk), Random(Yk));
    Rectangle(Random(Xk), Yk + Random(Yk), Random(Xk), Yk + Random(Yk));
    Circle(Xk + Random(Xk - 80) + 40, Yk + Random(Yk - 80) + 40, Random(40));
  until KeyPressed;
  CloseGraph;
end.
