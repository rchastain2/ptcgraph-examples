
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  SysUtils,
  ptcGraph, ptcCrt, Colors24;
  
var
  gd, gm: smallint;
  pix: longword;
  
begin
  gd := VESA;
  gm := m800x600x16m;
  InitGraph(gd, gm, '');
  
  SetBkColor(cBlue);
  SetColor(cOrange);
  ClearViewPort;
  
  pix := GetPixel(0, 0);
  OutText(IntToHex(pix, 8));
  ReadKey;
  CloseGraph;
end.
