
uses
{$IFDEF unix}
  CThreads,
{$ENDIF}
  ptcGraph, ptcCrt;

var
  Treiber, Modus: smallint;

begin
  ptcGraph.FullScreenGraph := TRUE;
  DetectGraph(Treiber, Modus);
  InitGraph(Treiber, Modus, '');
  ReadKey;
  CloseGraph;
end.
