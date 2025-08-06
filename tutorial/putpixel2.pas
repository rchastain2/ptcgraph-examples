
program putpixel2;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;
  
var
  gd, gm: smallint;
  x, y: integer;
begin
  gd := d8bit;
  gm := m640x480;
  InitGraph(gd, gm, '');
  if GraphResult = grOk then
  begin
    SetBkColor($FF);
    ClearDevice;
    for y := 0 to GetMaxY do
      for x := 0 to GetMaxX do
      begin
        PutPixel(x, y, (x xor y) and $FF);
      end;
    ReadKey;
    CloseGraph;
  end;
end.
