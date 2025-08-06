
program lineto1;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;
  
var
  gd, gm: smallint;
begin
  gd := d8bit;
  gm := m640x480;
  InitGraph(gd, gm, '');
  if GraphResult <> grOk then
    Halt;
  Randomize;
  repeat
    SetColor(Random(GetMaxColor) + 1);
    LineTo(Random(GetMaxX), Random(GetMaxY));
  until KeyPressed;
  CloseGraph;
end.
