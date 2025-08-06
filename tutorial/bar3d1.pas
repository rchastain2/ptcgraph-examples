
program bar3d1;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors16;

var
  gd, gm: smallint;

begin
  gd := VESA;
  gm := m800x600x64k;
  InitGraph(gd, gm, '');
  if GraphResult <> grOk then Halt(1);
  SetBkColor(CDarkSlateGray);
  ClearDevice;
  SetColor(CLightYellow);
  Bar3D(100, 100, 200, GetMaxY - 100, 30, True);
  ReadKey;
  CloseGraph;
end.
