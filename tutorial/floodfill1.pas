
program floodfill1;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors16;
  
var
  treiber, modus: smallint;
  
begin
  treiber := VESA;
  modus := m800x600x64k;
  InitGraph(treiber, modus, '');
  SetBkColor(cOrange);
  ClearDevice;
  SetColor(cGreen);
  Circle(GetMaxX div 2, GetMaxY div 2, 100);
  SetFillStyle(SolidFill, CYellow);
  FloodFill(GetMaxX div 2, GetMaxY div 2, cGreen);
  
  SetColor(cRed);
  Circle(GetMaxX div 3, GetMaxY div 3, 100);
  SetFillStyle(SlashFill, cDarkOrange);
  FloodFill(GetMaxX div 3, GetMaxY div 3, cRed);
  
  ReadKey;
  CloseGraph;
end.
