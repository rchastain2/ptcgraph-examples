
program getimage1;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;
  
var
  gd, gm: smallint;
  p: pointer;
  s: word;

begin
  gd := d8bit;
  gm := m640x480;
  InitGraph(gd, gm, '');
  
  SetBkColor(Blue);
  ClearDevice;
  
  SetFillStyle(solidFill, Yellow);
  Bar(0, 0, 39, 39);
  
  s := ImageSize(0, 0, 39, 39);
  GetMem(p, s);
  GetImage(0, 0, 39, 39, p^);
  PutImage(40, 40, p^, CopyPut);
  FreeMem(p, s);
  
  ReadKey;
  CloseGraph;
end.
