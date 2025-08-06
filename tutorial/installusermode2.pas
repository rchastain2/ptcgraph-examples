(*
  https://www.mail-archive.com/fpc-pascal@lists.freepascal.org/msg53625.html
  
  Does anyone know how I could make my PTCGraph windows a custom weird
  size that doesn't necessarily match the available video drivers?

  It's not possible with the current implementation, but right now I'm
  working on a patch that would make this possible. I'll post here when
  it's ready for testing.

  Implemented and committed in ptcpas and fpc trunk. The new function is called 
  InstallUserMode:

  function InstallUserMode(Width, Height: SmallInt; Colors: LongInt;
  HardwarePages: SmallInt; XAspect, YAspect: Word): smallint;

  Example use:
*)

program InstallUserMode1;

uses
{$ifdef UNIX}
  cthreads,
{$endif}
  ptcgraph, ptccrt;
  
var
  gd, gm: SmallInt;
begin
  gd := VESA;
  gm := InstallUserMode(100, 160, 16{, 1});
  if gm < 0 then
  begin
    Writeln(ErrOutput, 'Error installing user mode: ', GraphErrorMsg(gm));
    Halt(1);
  end;
  InitGraph(gd, gm, '');
  OutText('Hello!');
  ReadKey;
  CloseGraph;
end.

(*
  It supports adding modes with 16, 256, 32768, 65536 and 16777216 colors with a custom X 
  and Y resolution, custom number of hardware pages (for use with SetActivePage and 
  SetVisualPage) and a custom pixel aspect ratio (used for drawing circles instead of 
  ellipses on displays without square pixels - for square pixels, use "10000, 
  10000").
*)
