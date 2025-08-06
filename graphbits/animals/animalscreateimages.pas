program TryFiles;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, GraphBits, Animals;

var
  F: File;
  S: Word;

procedure CatFile;
begin
  DrawCat;
  S:= ImageSize(0, 0, 40, 40);
  Assign(F, 'cat.pic');
  ReWrite(F, S);
  BlockWrite(F, Cat^, 1);
  Close(F);
end;

procedure DogFile;
begin
  DrawStillDog;
  S:= ImageSize(100, 0, 175, 50);
  Assign(F, 'stilldog.pic');
  ReWrite(F, S);
  BlockWrite(F, Dog^, 1);
  Close(F);
end;

procedure MoveDogFile;
begin
  DrawMovingDog;
  S := ImageSize(200, 0, 275, 50);
  Assign(F, 'movedog.pic');
  ReWrite(F, S);
  BlockWrite(F, MoveDog^, 1);
  Close(F);
end;

var
  Gd, Gm: smallint;
begin
  Gd:= VGA;
  Gm:= VGAHi;
  InitGraph(Gd, Gm, 'C:\tp\bgi');
  CatFile;
  DogFile;
  MoveDogFile;
  ReadKey;
  CloseGraph;
end.
