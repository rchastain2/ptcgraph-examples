program Whatever;
{$MODE DELPHI}
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph,
  ptcCrt,
  GraphBits;

const
  North: array[1..3] of Byte = (1, 2, 8);
  NorthEast: array[1..3] of Byte = (1, 2, 3);
  East: array[1..3] of Byte = (2, 3, 4);
  SouthEast: array[1..3] of Byte = (3, 4, 5);
  South: array[1..3] of Byte = (4, 5, 6);
  SouthWest: array[1..3] of Byte = (5, 6, 7);
  West: array[1..3] of Byte = (6, 7, 8);
  NorthWest: array[1..3] of Byte = (7, 8, 1);
  MoveDist = 2;

type
  TBall = object
    X, Y,
      XSize, YSize,
      XMov, YMov: integer;
    GenDirection, Direction: Byte;
    procedure MoveBall;
    procedure TestForEdges;
    procedure StartBall(XP, YP, XM, YM: integer);
  end;

var
  I,
    XPos, YPos,
    Dela, NumBalls,
    XSize, YSize: integer;
  Size: integer;
  M, P: pointer;
  Balls: array[1..100] of TBall;

procedure TBall.TestForEdges;
begin
  if X >= GetMaxX - 40 then
    if GenDirection in [2, 3, 4] then GenDirection := West[Random(3) + 1];
  if Y >= GetMaxY - 40 then
    if GenDirection in [4, 5, 6] then GenDirection := North[Random(3) + 1];
  if X <= 10 then
    if GenDirection in [6, 7, 8] then GenDirection := East[Random(3) + 1];
  if Y <= 10 then
    if GenDirection in [1, 2, 8] then GenDirection := South[Random(3) + 1];
end;

function Direct(Dir: Byte): Byte;
begin
  case Dir of
    1: Direct := North[Random(3) + 1];
    2: Direct := NorthEast[Random(3) + 1];
    3: Direct := East[Random(3) + 1];
    4: Direct := SouthEast[Random(3) + 1];
    5: Direct := South[Random(3) + 1];
    6: Direct := SouthWest[Random(3) + 1];
    7: Direct := West[Random(3) + 1];
    8: Direct := NorthWest[Random(3) + 1];
  end;
end;

procedure TBall.MoveBall;
begin
  TestForEdges;
  Direction := Direct(GenDirection);
  case Direction of
    1:
      repeat
        Dec(Y, MoveDist); { North }
      until Y < GetMaxX - 40;
    2:
      repeat
        Inc(X, MoveDist); { North - East }
        Dec(Y, MoveDist);
      until (X > 10) and (Y < GetMaxY - 40);
    3:
      repeat
        Inc(X, MoveDist); { East }
      until X > 10;
    4:
      repeat
        Inc(X, MoveDist); { South - East }
        Inc(Y, MoveDist);
      until (X > 10) and (Y > 10);
    5:
      repeat
        Inc(Y, MoveDist); { South }
      until Y > 10;
    6:
      repeat
        Dec(X, MoveDist); { South West }
        Inc(Y, MoveDist);
      until (X < GetMaxX - 40) and (Y > 10);
    7:
      repeat
        Dec(X, MoveDist); { West }
      until X < GetMaxX - 40;
    8:
      repeat
        Dec(X, MoveDist); { North - West }
        Dec(Y, MoveDist);
      until (X < GetMaxX - 40) and (Y < GetMaxY - 40);
  end;
  PutImage(X, Y, P^, NormalPut);
{  if X = GetMaxX - 34 then PutImage(X, Y, P^, NormalPut);}
end;

procedure DrawBall;
begin
  XPos := 18;
  YPos := 18;
  XSize := 36;
  YSize := XSize;
  for I := 0 to 15 do
  begin
{
    SetPalette(I, I);
    SetRGBPalette(I, I * 3, I * 3, I * 3);
    SetColor(I);
    SetFillStyle(1, I);
}
    SetColor(White);
    SetFillStyle(1, White);
    FillEllipse(XPos, YPos, 15 - I, 15 - I);
  end;
  Size := ImageSize(0, 0, XSize, YSize);
  GetMem(P, Size);
  GetImage(0, 0, XSize, YSize, P^);
  SetFillStyle(1, White);
  Bar(100, 100, 100 + XSize, 100 + YSize);
  PutImage(100, 100, P^, xorput);
  GetMem(M, Size);
  GetImage(100, 100, 100 + XSize, 100 + YSize, M^);
end;

procedure TBall.StartBall;
begin
  X := XP;
  Y := YP;
  GenDirection := Random(8) + 1;
end;

function RandX: integer;
begin
  RandX := Random(GetMaxX - 34);
end;

function RandY: integer;
begin
  RandY := Random(GetMaxY - 34);
end;

function RndXM: integer;
begin
  RndXM := Random(2) + 1;
end;

function RndYM: integer;
begin
  RndYM := Random(4) + 1;
end;

procedure RunEm;
begin
  ClearDevice;
  for I := 1 to NumBalls do
  begin
    Balls[I].StartBall(RandX, RandY, RndXM, RndYM);
  end;
  while not KEyPressed do
  begin
    for I := 1 to NumBalls do
    begin
      Balls[I].MoveBall;
      Delay(Dela);
    end;
  end;
end;

procedure Starter;
var
  Code: integer;
begin
  if ParamCount = 0 then
  begin
    NumBalls := 2;
    Dela := 0;
  end;
  if ParamCount > 0 then
  begin
    Val(ParamStr(1), NumBalls, Code);
    Dela := 0;
  end;
  if ParamCount > 1 then
    Val(ParamStr(2), Dela, Code);
  if NumBalls > 100 then NumBalls := 100;
  if Dela > 1000 then Dela := 1000;
  if Dela < 0 then Dela := 0;
  if NumBalls < 1 then NumBalls := 1;
end;

begin
  Randomize;
  GraphicsScreen;
  Starter;
  DrawBall;
  RunEm;
  ReadKey;
  CloseGraph;
end.
