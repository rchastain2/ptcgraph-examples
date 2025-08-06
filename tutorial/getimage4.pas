
program getimage1;

uses
{$IFDEF UNIX}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;

var
  P: Pointer;
  Size: Word;
  grMode,
  grDriver : smallint;

Begin
  grDriver := VGA;
  grMode := VGAHi;
  InitGraph(grDriver, grMode, '');
  
  SetColor(White);
  MoveTo(0, 0);
  LineTo(3, 3);
  
  Size := ImageSize(0, 0, 3, 3);
  WriteLn('Size = ', Size);
  
  GetMem(P, Size);
  GetImage(0, 0, 3, 3, P^);
  
  PutImage(4, 0, P^, ORPUT);
  PutImage(8, 0, P^, XORPUT);
  
  ReadKey;
  CloseGraph;
  
  FreeMem(P);
End.
