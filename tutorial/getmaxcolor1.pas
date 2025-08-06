
program getmaxcolor1;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  SysUtils,
  ptcGraph, ptcCrt;
  
var
  treiber, modus: smallint;

begin
  DetectGraph(treiber, modus);
  InitGraph(treiber, modus, '');
  WriteLn(GetMaxColor);
  ReadKey;
  CloseGraph;
end.
