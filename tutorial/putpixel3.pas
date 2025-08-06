
program putpixel1;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt{, Colors24};
  
var
  gd, gm: smallint;
  x, y: integer;
  
begin
  gd := 10;
  gm := 536; { 10 536 832x624 16777216 832 x 624 VESA }
  InitGraph(gd, gm, '');
  if GraphResult = grOk then
  begin
    SetBkColor($000000);
    ClearDevice;
    
    for y := 0 to GetMaxY do
      for x := 0 to GetMaxX do
      begin
        PutPixel(x, y, x mod 255 shl 16 or y mod 255 shl 8 or (x + y) mod 255);
      end;
      
    ReadKey;
    CloseGraph;
  end;
end.


