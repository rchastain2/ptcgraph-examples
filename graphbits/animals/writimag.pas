program WriteAnimals;
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph,
  GraphBits,
  ptcCrt,
  Animals;
const
  OT: array[0..4] of shortint = (0, 1, -1, 2, -2);

type
  TPixel = object
    Index, XPos, YPos: integer;
    Colour: Word;
    procedure GiveMeLife;
    procedure WhatDoIDo;
    procedure EraseMe;
    procedure DrawMe;
  end;

var
  F: file;
  Result: Word;
  Gd, Gm: integer;
  Bit: array[1..200] of TPixel;

procedure TPixel.GiveMeLife;
begin
  XPos := Random(9) - 5;
  YPos := Random(9) - 5;
  if XPos = 0 then
    XPos := OT[Random(3) + 1];
  if YPos = 0 then
    YPos := OT[Random(3) + 1];
  Colour := Random(14 + 1);
end;

procedure TPixel.WhatDoIDo;
begin
  if XPos < 0 then
    Dec(XPos, Random(Abs(XPos)) + OT[Random(2)])
  else
    Inc(XPos, Random(Abs(XPos)) + OT[Random(2)]);
  if YPos < 0 then
    Dec(YPos, Random(Abs(YPos)) + OT[Random(2)])
  else
    Inc(YPos, Random(Abs(YPos)) + OT[Random(2)]);
end;

procedure TPixel.DrawMe;
begin
  PutPixel(DivX + XPos, DivY + YPos, Colour);
end;

procedure TPixel.EraseMe;
begin
  PutPixel(DivX + XPos, DivY + YPos, 0);
end;

procedure Explosion;
var
  Co: integer;
  S: string;
begin
  Randomize;
  for Co := 1 to 200 do
  begin
    Bit[Co].GiveMeLife;
  end;
  repeat
    for Co := 1 to 200 do
      Bit[Co].DrawMe;
    for Co := 1 to 200 do
    begin
      Bit[Co].EraseMe;
      Bit[Co].WhatDoIDo;
    end;
  until KeyPressed;
end;

procedure WriteDog;
begin
  DrawStillDog; { 0, 0, 75, 50 }
  Assign(F, 'dog.pic');
  Rewrite(F, Size);
  BlockWrite(F, Dog^, 1, Result);
  Close(F);
end;

procedure WriteCat;
begin
  DrawCat; { 0, 0, 40, 40 }
  Assign(F, 'cat.pic');
  Rewrite(F, Size);
  BlockWrite(F, Cat^, 1, Result);
  Close(F);
end;

begin
  GraphicsScreen;
  WriteDog;
  WriteCat;
  Explosion;
  CloseGraph;
end.
