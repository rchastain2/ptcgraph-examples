
program setfillstyle1;

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
    Halt(1);
  SetFillStyle(XHatchFill, LightGray);
  Bar(10, 10, GetMaxX - 10, GetMaxY - 10);
  ReadKey;
  CloseGraph;
end.
