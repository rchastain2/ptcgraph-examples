
program bar3d2;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcCrt, ptcGraph;
  
var
  gd, gm: smallint;
  
begin
  gd := d8bit;
  gm := m640x480;
  InitGraph(gd, gm, ' ');
  if GraphResult <> grOk then Halt(1);
  SetColor(Red);
  SetFillStyle(SolidFill, Red);
  Bar3d(100, 100, 150, 300, 30, TopOn);
  SetColor(Yellow);
  SetFillStyle(SlashFill, Yellow);
  Bar3d(200, 100, 250, 300, 30, TopOff);
  SetColor(Green);
  SetFillStyle(BkSlashFill, Green);
  Bar3d(300, 100, 350, 300, 30, TopOn);
  SetColor(Blue);
  SetFillStyle(XHatchFill, Blue);
  Bar3d(400, 100, 450, 300, 30, TopOn);
  ReadKey;
  CloseGraph;
end.
