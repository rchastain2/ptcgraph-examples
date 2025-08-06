program ReadPixels;
uses ptcGraph,
  ptcCrt,
  GraphBits;
var
  Size: Word;
  Top, Bottom, Middle: Pointer;
  F: file;
  X, Y: integer;

procedure ReadFile;
var
  F: file;
begin
  Size := ImageSize(0, 0, GetMaxX, GetMaxY div 3);
  GetMem(Top, Size);
  GetMem(Middle, Size);
  GetMem(Bottom, Size);
  Assign(F, 'A:\PIXELS.PIC');
  Reset(F, Size);
  BlockRead(F, Top^, 1);
  BlockRead(F, Middle^, 1);
  BlockRead(F, Bottom^, 1);
  Close(F);
end;

procedure PutPicture;
begin
  PutImage(0, 0, Top^, XORPut);
{  PutImage(0, 0, Middle^, XORPut);
  PutImage(0, 0, Bottom^, XORPut);
  PutImage(0, GetMaxY div 3, Bottom^, XORPut);
  PutImage(0, GetMaxY div 3, Middle^, XORPut);}
  PutImage(0, GetMaxY div 3, Middle^, NormalPut);
  PutImage(0, GetMaxY - GetMaxY div 3 - 1, Bottom^, NormalPut);
{  PutImage(0, GetMaxY - GetMaxY div 3, Top^, XORPut);
  PutImage(0, GetMaxY - GetMaxY div 3, Bottom^, XORPut);}
  ReadKey;
end;

procedure Grafficks;
begin
  {Gd:= VGA;
  Gm:= 2;
  InitGraph(Gd, Gm, 'c:\tp\bgi');}
  GraphicsScreen('c:\tp\bgi');
  GetMaxX := GetMaxX; GetMaxY := GetMaxY;
  DivX := GetMaxX div 2;
  DivY := GetMaxY div 2;
end;

begin
  Grafficks;
  ReadFile;
  PutPicture;
  CloseGraph;
end.
