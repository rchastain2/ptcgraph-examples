program SeeWhatItDoes;
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph,
  ptcCrt,
  GraphBits;
const
  Col: array[0..8] of integer = (14, 14, 15, 6, 6, 6, 6, 6, 6);
  NumDirts = 2;
var
  DirtPos: array[1..60] of integer;
  Gd, Gm, I: smallint;
  MDog, SDog,
    Dirt: Pointer;
  F: file;
  Size: Word;

procedure GetPics;
begin
  Size := ImageSize(0, 0, 75, 50);
  GetMem(SDog, Size);
  Assign(F, 'stilldog.pic');
  Reset(F, Size);
  BlockRead(F, SDog^, 1, I);
  Close(F);
  Size := ImageSize(0, 0, 75, 50);
  GetMem(MDog, Size);
  Assign(F, 'movedog.pic');
  Reset(F, Size);
  BlockRead(F, MDog^, 1, I);
  Close(F);
end;

procedure Ground;
begin
  Randomize;
  for I := 1 to 32760 do
    PutPixel(Random(99), Random(50), Col[Random(9)]);
  for I := 1 to 17 do
  begin
    SetColor(Brown);
    SetFillStyle(1, Brown);
    FillEllipse(Random(99), Random(50), Random(8), Random(8));
  end;
  Size := ImageSize(0, 0, 99, 50);
  GetMem(Dirt, Size);
  GetImage(0, 0, 99, 50, Dirt^);
  PutImage(100, 100, Dirt^, NormalPut);
end;

procedure NewVals;
begin
  for I := 1 to NumDirts do
  begin
    Dec(DirtPos[I], 8);
    if DirtPos[I] < -10 then DirtPos[I] := GetMaxX - 90;
  end;
end;

procedure DirtPosInit;
begin
  for I := 1 to NumDirts do
    DirtPos[I] := GetMaxX - (100 * (I - 1));
end;

begin
  Gd := VGA; //VESA;
  Gm := VGAHi; //m800x600x16m;
  InitGraph(Gd, Gm, 'C:\tp\bgi');
  
  Ground;
  ReadKey;
  GetPics;
  ClearDevice;
  DirtPosInit;
  while not KeyPressed do
  begin
    PutImage(500, 500, SDog^, NormalPut);
    NewVals;
    for I := 1 to NumDirts do
      PutImage(DirtPos[I], 550, Dirt^, NormalPut);
    PutImage(500, 500, MDog^, NormalPut);
    NewVals;
    for I := 1 to NumDirts do
      PutImage(DirtPos[I], 550, Dirt^, NormalPut);
  end;
  ReadKey;
  CloseGraph;
end.
