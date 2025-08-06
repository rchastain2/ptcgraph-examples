
program bar1;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors16;
  
var
  d, m: smallint;
  
begin
  d := VESA;
  m := m800x600x64k;
  InitGraph(d, m, '');
  SetBkColor(cLightYellow);
  ClearDevice;
  SetFillStyle(SolidFill, cDarkOrange);
  Bar(1, 1, 798, 598);
  ReadKey;
end.
