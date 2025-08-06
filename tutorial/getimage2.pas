
program getimage2;

{ Sample code for the GetImage procedure. }

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, colors24;

{ 10 516 640x360 16777216 }

var
  d, m: smallint;
  p: pointer;
  sz: longint;
  
begin
  d := 10;
  m := 516;
  InitGraph(d, m, '');
  if GraphResult <> grOk then
    Halt(1);
  SetBkColor(cOrange);
  ClearViewPort;
  SetFillStyle(SlashFill, cBlue);
  Bar(0, 0, 319, 179);
  sz := ImageSize(0, 0, 320, 180);
  GetMem(p, sz);   { Allocate memory on heap }
  GetImage(0, 0, 320, 180, p^);
  PutImage(320, 180, p^, NormalPut);
  FreeMem(p, sz);
  ReadKey;
  CloseGraph;
end.
