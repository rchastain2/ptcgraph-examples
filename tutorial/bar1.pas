
program bar1;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;

const
  cDarkOrange  = $FC60;
  cLightYellow = $FFFC;
  
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
