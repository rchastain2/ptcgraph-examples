
(* https://forum.lazarus.freepascal.org/index.php/topic,51955.msg538270.html#msg538270 *)

program test;
 
{$mode objfpc}{$h+}
 
uses
{$ifdef unix}
  cthreads,
{$endif}
  ptcGraph,
  ptcCrt;
 
var
  myCustomUserGraphMode : smallint;
  grDriver              : smallint;
  grMode                : smallint;
 
 
procedure setup;
begin
  myCustomUserGraphMode := InstallUserMode
  (
    1920,  // width in pixels
    1080,  // height in pixels
    256    // number of colors
  );
end;
 
 
begin
  setup;
 
  grDriver    := VESA;
  grMode      := myCustomUserGraphMode;
  WindowTitle := 'My title';
  InitGraph(grDriver, grMode, '');
 
  SetBkColor(white);
  ClearViewPort;
 
  SetFillStyle(SolidFill, lightgreen);
  Bar(100, 100, 800, 500);
 
  readkey;
  CloseGraph;
end.
 
