
program getpixel1;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, SysUtils;
  
var
  gd, gm: smallint;
  w: word;
  
begin
  gd := d8bit;
  gm := m640x480;
  InitGraph(gd, gm, '');
  if GraphResult <> grOk then
    Halt(1);
  SetRGBPalette(16, $66, $00, $FF);
  SetFillStyle(SolidFill, 16);
  Bar(0, 0, GetMaxX, GetMaxY);
  w := GetPixel(1, 1);
  OutText(IntToHex(w, 8));
  ReadKey;
  CloseGraph;
end.
