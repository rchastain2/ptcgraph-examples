
program getmaxcolor4;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  SysUtils,
  ptcGraph, ptcCrt, Colors16;
  
var
  treiber, modus: smallint;
  s: string;
  
begin
  treiber := VESA;
  modus := m1024x768x64k;
  InitGraph(treiber, modus, '');
  s := IntToStr(GetMaxColor);
  SetBkColor(cOrange);
  ClearDevice;
  SetColor(cBlue);
  OutText(s);
  ReadKey;
  CloseGraph;
end.


