program ModeList;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;
var
  a, b: smallint;
begin
  a := Detect;
  InitGraph(a, b, '');
  WriteLn(GetDriverName);
  for a := 0 to GetMaxMode do
    WriteLn(GetModeName(a): 10);
  ReadKey;
  CloseGraph
end.
