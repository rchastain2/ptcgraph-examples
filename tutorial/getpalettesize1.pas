
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  SysUtils,
  ptcGraph, ptcCrt;

procedure init;
var 
  gd, gm : smallint;
begin
  gd:=VGA; gm:=VGAHi;
  initgraph(gd, gm, '.\BGI');
  gd:=graphresult;
  if gd<>grOK then
  begin
    writeln('Error in initializing graphic card! The error is');
    writeln(grapherrormsg(gd)); halt;
  end;
end;

procedure destroy;
begin
  closegraph;
  writeln('Good bye!');
end;

begin
  init;
  outtextxy(8, 0 * 12 + 8, format('GetPaletteSize = %d', [GetPaletteSize]));
  outtextxy(8, 1 * 12 + 8, format('GetDriverName = %s', [GetDriverName]));
  outtextxy(8, 2 * 12 + 8, format('GetModeName(%d) = %s', [VGAHi, GetModeName(VGAHi)]));
  readkey;  { Turbo Pascal 5.0 or 6.0 must change this to c:=readkey; }
            { with c is a char variable }
  destroy;
end.
