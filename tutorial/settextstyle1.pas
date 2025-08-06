
program settextstyle1;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;

var
  gd, gm: smallint;
  y, size: Integer;
  
begin
  gd := d4bit;
  gm := m640x480;
  InitGraph(gd, gm, '');
  SetBkColor(Red);
  SetColor(Yellow);
  if GraphResult <> grOk then
    Halt(1);
  
  y := 8;
  for size := 1 to 4 do
  begin
    SetTextStyle(DefaultFont, HorizDir, size);
    OutTextXY(8, y, 'Hello size ' + Chr(size + 48));
    Inc(y, TextHeight('H'));
  end;
  
  ReadKey;
  CloseGraph;
end.
