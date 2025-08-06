program TwoHundredAndFiftySixColours;
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph,
  ptcCrt,
  GraphBits;
const
  Imgs = 5;
var
  X, Y, DfX, DfY: array[0..Imgs] of integer;
  Inty, I, XP, YP, Tmr: integer;
  size: word;
  Img: array[0..Imgs] of pointer;
  XDir, YDir: array[0..Imgs] of boolean;

procedure Clear(xx: integer);
begin
  ClearDevice;
  if xx = 1 then
    X[xx] := 0;
  if xx = 2 then
    Y[xx] := 0;
end;

function TestXPos(xx: integer): Boolean;
begin
  if X[xx] > X[Inty] - 15 then
    if X[xx] < X[Inty] + 15 then
      TestXPos := True;
end;

function TestYPos(xx: integer): Boolean;
begin
  if Y[xx] > Y[Inty] - 15 then
    if Y[xx] < Y[Inty] + 15 then
      TestYPos := True;
end;

procedure CalcBall(xx: integer);
begin
  if X[xx] >= GetMaxX - 30 then
  begin
    XDir[xx] := False;
    X[xx] := GetMaxX - 30;
  end;
  if X[xx] < 0 then
  begin
    XDir[xx] := True;
    X[xx] := 0;
  end;
  if Y[xx] >= GetMaxY - 30 then
  begin
    YDir[xx] := False;
    Y[xx] := GetMaxY - 31;
  end;
  if Y[xx] < 0 then
  begin
    YDir[xx] := True;
    Y[xx] := 0;
  end;
  for Inty := 0 to Imgs do
  begin
    if xx <> Inty then
    begin
      if TestXPos(xx) = True then
        if TestYPos(xx) = True then
        begin
          case XDir[Inty] of
            True: XDir[Inty] := False;
            False: XDir[Inty] := True;
          end;
          case YDir[Inty] of
            True: XDir[xx] := False;
            False: YDir[xx] := True;
          end;
        end;
    end;
  end;
  case XDir[xx] of
    True: Inc(X[xx], DfX[xx]);
    False: Dec(X[xx], DfX[xx]);
  end;
  case YDir[xx] of
    True: Inc(Y[xx], DfY[xx]);
    False: Dec(Y[xx], DfY[xx]);
  end;
end;

var
  Gd, Gm: smallint;
begin
  Gd := Detect;
  InitGraph(Gd, Gm, '\tp\bgi');
  
  Size := ImageSize(0, 0, 30, 30);
  for I := 0 to Imgs do
  begin
    Tmr := Random(MaxColors) + 1;
    SetFillStyle(1, Tmr);
    SetColor(Tmr);
    XP := GetMaxX div 100;
    YP := GetMaxY div 100;
    YP := YP * 2;
    FillEllipse(15, 15, XP, YP);
    GetMem(Img[I], Size);
    GetImage(0, 0, 30, 30, Img[I]^);
    X[I] := Random(GetMaxX);
    Y[I] := Random(GetMaxY);
    DfX[I] := Random(5) + 1;
    DfY[I] := Random(5) + 1;
  end;
  Randomize;
  ClearDevice;
  while not KeyPressed do
  begin
    for I := 0 to Imgs do
    begin
      CalcBall(I);
      PutImage(X[I], Y[I], Img[I]^, normalput);
    end;
  end;
  ReadKey;
  CloseGraph;
end.
