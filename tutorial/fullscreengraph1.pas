
uses
{$IFDEF unix}
  CThreads,
{$ENDIF}
  ptcGraph, ptcCrt;

var
  Treiber, Modus: smallint;

begin
  FullScreenGraph := TRUE;
  DetectGraph(Treiber, Modus);
  InitGraph(Treiber, Modus, '');
  //WriteLn(GetMaxColor);
  ReadKey;
  CloseGraph;
end.
