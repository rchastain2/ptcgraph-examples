program Whatever;
{$MODE DELPHI}
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph,
  ptcCrt,
  GraphBits;

type
  TBall = object
    X, Y,
      XSize, YSize,
      XMov, YMov: integer;
    procedure DirBall;
    procedure MoveBall;
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

procedure TBall.DirBall;
begin
  Inc(X, XMov);
  Inc(Y, YMov);
  if X >= GetMaxX - 36 then XMov := -2;
  if Y >= GetMaxY - 36 then YMov := -3;
  if X <= 0 then XMov := 3;
  if Y <= 0 then YMov := 2;
end;

procedure TBall.StartBall;
begin
  X := XP;
  Y := YP;
  XMov := XM;
  YMov := YM;
end;

procedure TBall.MoveBall;
begin
  PutImage(X, Y, P^, NormalPut);
  if X = GetMaxX - 34 then PutImage(X, Y, P^, NormalPut);
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
      Balls[I].DirBall;
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
    Dela := 3;
  end;
  if ParamCount > 0 then
  begin
    Val(ParamStr(1), NumBalls, Code);
    Dela := 1;
  end;
  if ParamCount > 1 then
    Val(ParamStr(2), Dela, Code);
  if NumBalls > 100 then NumBalls := 100;
  if Dela > 1000 then Dela := 1000;
  if Dela < 0 then Dela := 0;
  if NumBalls < 1 then NumBalls := 1;
end;

begin
  GraphicsScreen;
  Starter;
  DrawBall;
  RunEm;
  ReadKey;
  CloseGraph;
end.
