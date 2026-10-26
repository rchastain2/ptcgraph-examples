program sokoban;

uses
{$IFDEF unix}
  cthreads,
{$ENDIF}
  ptcgraph, ptccrt, UManager;

var gd, gm: smallint;

begin
  gd := VESA;
  gm := m800x600x16;
  initgraph(gd, gm, '');
  init;
  closegraph;
end.
