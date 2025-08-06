
{ https://github.com/glennkentwell/code/tree/master/pascal }

program Graphics;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcCrt,
  ptcGraph,
  GraphBits;
  
const
  OT: array[0..4] of shortint = (0, 1, -1, 2, -2);
  Bits = 900;
  
type
  TPixel = object
    XPos, YPos, Rad: integer;
    Colour: Word;
    procedure GiveMeLife;
    procedure WhatDoIDo;
    procedure EraseMe;
    procedure DrawMe;
  end;

var
  Gd, Gm: smallint;
  X, Y, MaxRad, MinRad, Col, rx, ry, Counter, Clr: integer;
  No, Ex: integer;
  Bit: array[1..Bits] of TPixel;
  GotBall, DirX, DirY, DirRx, DirRy: Boolean;
  Ball: Pointer;
  Size: Word;
  XPos, YPos: array[1..2] of integer;
  Poly: array[1..5] of PointType;
  DivX, DivY: integer;
  
procedure TPixel.GiveMeLife;
begin
  XPos := Random(9) - 5;
  YPos := Random(9) - 5;
  Rad := Random(3) + 1;
  if XPos = 0 then XPos := OT[Random(3) + 1];
  if YPos = 0 then YPos := OT[Random(3) + 1];
  Colour := Random(Clr) + 1;
end;

procedure TPixel.WhatDoIDo;
begin
  if XPos < 0 then Dec(XPos, Random(Abs(XPos)) + OT[Random(2)])
  else Inc(XPos, Random(Abs(XPos)) + OT[Random(2)]);
  if YPos < 0 then Dec(YPos, Random(Abs(YPos)) + OT[Random(2)])
  else Inc(YPos, Random(Abs(YPos)) + OT[Random(2)]);
  if XPos > GetMaxX then Inc(No);
end;

procedure TPixel.DrawMe;
begin
  Point(DivX + XPos, DivY + YPos, Rad, Colour);
end;

procedure TPixel.EraseMe;
begin
  Point(DivX + XPos, DivY + YPos, Rad, 0);
end;

procedure Quitter;
begin
  ReadKey;
  CloseGraph;
  Halt(0);
end;

procedure Explosion;
var
  Co: integer;
begin
  Clr := 15;
  for Co := 1 to Bits do
  begin
    Bit[Co].GiveMeLife;
  end;
  repeat
    if KeyPressed then Quitter;
    for Co := 1 to Bits do
      Bit[Co].DrawMe;
    for Co := 1 to Bits do
    begin
{    Bit[Co].EraseMe;}
      Bit[Co].WhatDoIDo;
    end;
  until No > Bits div 2;
  No := 0;
end;

procedure Shades;
begin
  for X := DivX downto 1 do
    for Y := 0 to DivY do
    begin
      PutPixel(Random(GetMaxX), DivY - Random(Y), Blue);
      PutPixel(Random(GetMaxX), DivY + Random(Y), Green);
      if KeyPressed then Quitter;
    end;
  for Y := 0 to DivY div 2 do
    for X := 0 to DivX do
    begin
      PutPixel(Random(GetMaxX), Random(Y), LightBlue);
      PutPixel(Random(GetMaxX), GetMaxY - Random(Y), LightGreen);
      if KeyPressed then Quitter;
    end;
end;

procedure MiddleShades;
begin
  for Y := 0 to DivY div 2 do
    for X := 0 to DivX do
    begin
      PutPixel((DivX + DivX div 2) - Random(X), (DivY + DivY div 2) - Random(Y), Magenta);
      PutPixel(DivX div 2 + Random(X), DivY div 2 + Random(Y), Yellow);
      PutPixel((DivX + DivX div 2) - Random(X), DivY div 2 + Random(Y), Red);
      PutPixel(DivX div 2 + Random(X), (DivY + DivY div 2) - Random(Y), LightRed);
      if KeyPressed then Quitter;
    end;
  for Y := 0 to DivY div 4 do
    for X := 0 to DivX div 4 do
    begin
      PutPixel(DivX - Random(X), DivY - Random(Y), LightMagenta);
      PutPixel(DivX + Random(X), DivY + Random(Y), LightMagenta);
      PutPixel(DivX - Random(X), DivY + Random(Y), LightMagenta);
      PutPixel(DivX + Random(X), DivY - Random(Y), LightMagenta);
      if KeyPressed then Quitter;
    end;
end;

procedure UpDownLines;
var
  Ln, C: integer;
begin
  SetWriteMode(NormalPut);
  //Randomize;
  for C := 7 downto 1 do
  begin
    X := 0;
    while X < GetMaxX do
    begin
      Inc(X);
      SetColor(C);
      Ln := Random(DivY);
      Line(X, DivY - Ln div 2, Random(X), DivY + Ln div 2);
      Inc(X);
      SetColor(7 + C);
      Ln := Random(DivY);
      Line(X, DivY - Ln div 2, Random(X), DivY + Ln div 2);
      if KeyPressed then Quitter;
    end;
    X := GetMaxX;
    while X > 0 do
    begin
      Dec(X);
      SetColor(C);
      Ln := Random(DivY);
      Line(Random(X), DivY - Ln div 2, X, DivY + Ln div 2);
      if KeyPressed then Quitter;
      Dec(X);
      SetColor(7 + C);
      Ln := Random(DivY);
      Line(Random(X), DivY - Ln div 2, X, DivY + Ln div 2);
    end;
  end;
  SetWriteMode(NormalPut);
end;

procedure Ellipses;
begin
  Col := GetMaxColor;
  SetColor(Col);
  Y := DivY;
  X := DivX;
  while X >= -10 do
  begin
    SetFillStyle(1, Col);
    FillEllipse(DivX, DivY, X, Y);
    Dec(X, 4);
    Dec(Y, 4);
    Dec(Col);
    if Col < 1 then Col := 15;
    if KeyPressed then Quitter;
  end;
end;

procedure Circles;
begin
  X := DivX;
  while X > 0 do
  begin
    SetFillStyle(1, Col);
    FillEllipse(DivX, DivY, X, X);
    Dec(X, 3);
    Dec(Col);
    if Col < 1 then Col := 15;
    if KeyPressed then Quitter;
  end;
end;

procedure Operate;
begin
  if X < Rx then DirX := True;
  if X > GetMaxX - Rx then DirX := False;
  if Y < Ry then DirY := True;
  if Y > GetMaxY - Ry then DirY := False;
  case DirX of
    True: Inc(X, 3);
    False: Dec(X, 3);
  end;
  case DirY of
    True: Inc(Y, 2);
    False: Dec(Y, 2);
  end;
  Dec(Col);
  if Col < 0 then Col := 15;
  if DirRx = True then Inc(rx, 1)
  else Dec(rx, 1);
  if rx < MinRad then DirRx := True;
  if rx > MaxRad then DirRx := False;
  if DirRy = True then Inc(ry, 1)
  else Dec(ry, 1);
  if ry < MinRad then DirRy := True;
  if ry > MaxRad then DirRy := False;
  Inc(Counter);
end;

procedure Bounce;
var
  Co: integer;
begin
  MinRad := GetMaxY div 45;
  MaxRad := GetMaxY div 10;
  SetColor(Black);
  //Randomize;
  Co := 0;
  X := Random(GetMaxX);
  Y := Random(GetMaxY);
  Rx := 0;
  Ry := 0;
  Counter := 0;
  Col := 15;
  repeat
    SetFillStyle(1, Random(Col));
    FillEllipse(X, Y, rx, ry);
    if KeyPressed then Quitter;
    Operate;
    Inc(Co);
  until Co >= 1500;
end;

procedure Test(Colr, XYPix, XPos: integer);
begin
  if XYPix <= Colr then
    PutPixel(XPos, Y, Black)
  else if KeyPressed then Quitter;
end;

procedure BlackColours;
var
  Co, XYP: shortint;
begin
  Co := 0;
  while Co < 15 do
  begin
    Inc(Co, 8);
    for X := 0 to DivX do
      for Y := 0 to GetMaxY do
      begin
        XYP := GetPixel(X, Y);
        Test(Co, XYP, X);
        XYP := GetPixel(GetMaxX - X, Y);
        Test(Co, XYP, GetMaxX - X);
      end;
  end;
end;

procedure Dissolve;
var
  Yy: integer;
begin
  SetColor(Black);
  Yy := 0;
  while Yy <= GetMaxY do
  begin
    Line(0, Yy, GetMaxX, Yy);
    Inc(Yy, 2);
  end;
  Yy := GetMaxY;
  while Yy >= 0 do
  begin
    Line(0, Yy, GetMaxX, Yy);
    Dec(Yy, 2);
  end;
  ClearDevice;
end;

procedure Star;
begin
  Dissolve;
  for Y := 0 to DivY do
    for X := 0 to DivX do
    begin
      PutPixel(DivX - Random(X), DivY - Random(Y), LightBlue);
      PutPixel(DivX + Random(X), DivY + Random(Y), LightBlue);
      PutPixel(DivX - Random(X), DivY + Random(Y), LightBlue);
      PutPixel(DivX + Random(X), DivY - Random(Y), LightBlue);
      if KeyPressed then Quitter;
    end;
  for Y := 0 to DivY div 2 do
    for X := 0 to DivX div 2 do
    begin
      PutPixel(DivX - Random(X), DivY - Random(Y), Yellow);
      PutPixel(DivX + Random(X), DivY + Random(Y), Yellow);
      PutPixel(DivX - Random(X), DivY + Random(Y), Yellow);
      PutPixel(DivX + Random(X), DivY - Random(Y), Yellow);
      if KeyPressed then Quitter;
    end;
end;

procedure Spiral;
var
  I: integer;
begin
  
  X := 1;
  Y := 0;
  Col := 0;
  for I := 0 to 10 do
  begin
    X := 1;
    Inc(Col);
    SetColor(Col);
    while X < DivX do
    begin
      Ellipse(DivX, DivY, Y, Y + 5 * I, X + I, X);
      Inc(Y, 5 * I);
      Inc(X, 1);
      if KeyPressed then Quitter;
    end;
  end;
end;

procedure BlackSpiral;
var
  Diag: integer;
begin
  Diag := (GetMaxX div 4) * 5;
  Diag := Diag div 2;
  SetFillStyle(1, Black);
  SetColor(Black);
  X := 2;
  while X < DivX + (DivX div 2) do
  begin
    FillEllipse(DivX, DivY, X, X);
    Inc(X, X div 2);
    if KeyPressed then Quitter;
  end;
end;

procedure Polies;
var
  Co, I: integer;
begin
  Co := 0;
  
  repeat
    Inc(Co);
    Col := Random(15);
    SetColor(Col);
    SetFillStyle(1, Col);
    I := Random(9) + 1;
    for Ex := 1 to I do
      with Poly[Ex] do
      begin
        X := Random(GetMaxX);
        Y := Random(GetMaxY);
      end;
    FillPoly(I, Poly);
    if KeyPressed then Quitter;
  until Co >= 200;
  Dissolve;
end;

procedure RadialLines;
var
  X2, Y2: integer;
begin
  SetWriteMode(XORPut);
  X2 := DivX;
  Y2 := 0;
  SetLineStyle(0, 0, 3);
  while X2 >= 0 do
  begin
    SetColor(Col);
    Line(X, Y, X2, Y2);
    Dec(X2, 3);
    Dec(Col);
    if Col < 0 then Col := 15;
  end;
  while Y2 <= GetMaxY do
  begin
    SetColor(Col);
    Line(X, Y, X2, Y2);
    Inc(Y2, 3);
    Dec(Col);
    if Col < 0 then Col := 15;
  end;
  while X2 <= GetMaxX do
  begin
    SetColor(Col);
    Line(X, Y, X2, Y2);
    Inc(X2, 3);
    Dec(Col);
    if Col < 0 then Col := 15;
  end;
  while Y2 >= 0 do
  begin
    SetColor(Col);
    Line(X, Y, X2, Y2);
    Dec(Y2, 3);
    Dec(Col);
    if Col < 0 then Col := 15;
    if KeyPressed then Quitter;
  end;
  while X2 >= DivX do
  begin
    SetColor(Col);
    Line(X, Y, X2, Y2);
    Dec(X2, 3);
    Dec(Col);
    if Col < 0 then Col := 15;
  end;
  SetLineStyle(0, 0, 1);
  SetWriteMode(NormalPut);
end;

procedure BlackRadialLines;
var
  X2, Y2: integer;
begin
  X2 := DivX;
  Y2 := 0;
  Col := Black;
  SetColor(Col);
  SetLineStyle(0, 0, 3);
  while X2 >= 0 do
  begin
    Line(X, Y, X2, Y2);
    Dec(X2, 3);
  end;
  while Y2 <= GetMaxY do
  begin
    Line(X, Y, X2, Y2);
    Inc(Y2, 3);
  end;
  while X2 <= GetMaxX do
  begin
    Line(X, Y, X2, Y2);
    Inc(X2, 3);
  end;
  while Y2 >= 0 do
  begin
    Line(X, Y, X2, Y2);
    Dec(Y2, 3);
    if KeyPressed then Quitter;
  end;
  while X2 >= DivX do
  begin
    Line(X, Y, X2, Y2);
    Dec(X2, 3);
  end;
  SetLineStyle(0, 0, 1);
  ClearDevice;
end;

procedure Lines;
var
  X2, Y2, X3, Y3, Times: integer;
begin
  X := Random(GetMaxX);
  Y := Random(GetMaxY);
  X2 := Random(GetMaxX);
  Y2 := Random(GetMaxY);
  X3 := Random(GetMaxX);
  Y3 := Random(GetMaxY);
  SetLineStyle(0, 0, 3);
  Times := 3000;
  for Counter := 1 to Times do
  begin
    Operate;
    Rx := 0; Ry := 0;
    SetColor(Col);
    Line(X2, Y2, X, Y);
    Line(X3, Y3, X, Y);
    if KeyPressed then Quitter;
  end;
  SetLineStyle(0, 0, 1);
end;

procedure ColourIt;
var
  Ex, Why: integer;
begin
  Ex := 0;
  Why := 0;
  while Ex <= DivX do
  begin
    SetColor(Random(16));
    SetFillStyle(1, Random(16));
    Rectangle(Ex, Why, GetMaxX - Ex, GetMaxY - Why);
    Inc(Ex); Inc(Why);
    if KeyPressed then Quitter;
  end;
end;

procedure BlackIt;
var
  Sx, Sy, Ex, Ey, Dif: integer;
begin
  DivX := GetMaxX div 2;
  DivY := GetMaxY div 2;
  Sx := DivX;
  Sy := DivY;
  Ex := DivX;
  Ey := DivY;
  Dif := 8;
  while Sx >= -2 do
  begin
    SetColor(Black);
    SetFillStyle(1, Black);
    Bar(Sx, Sy, Ex, Ey);
    Dec(Sx, Dif); Dec(Sy, Dif);
    Inc(Ex, Dif); Inc(Ey, Dif);
    if KeyPressed then Quitter;
  end;
end;

procedure CalcBall(Nom: shortint);
begin
  Inc(XPos[Nom], GetMaxX div 65);
  Inc(YPos[Nom], GetMaxY div 65);
end;

procedure RedCircles;
begin
  X := 4;
  SetColor(Yellow);
  while X < DivX div 2 do
  begin
    SetFillStyle(1, Red);
    FillEllipse(DivX, DivY, X div 2, X div 4);
    Inc(X, X div 4);
    if KeyPressed then Quitter;
  end;
  X := 4;
  SetColor(Yellow);
  while X < GetMaxX do
  begin
    SetFillStyle(1, Red);
    FillEllipse(DivX, DivY, X, X div 2);
    Inc(X, X div 4);
    if KeyPressed then Quitter;
  end;
end;

procedure PixAcross(NegOrPos: Boolean);
begin
  if NegOrPos = True then
    for X := 0 to GetMaxX do
    begin
      PutPixel(X, DivY - 3, Random(15) + 1);
      PutPixel(X, DivY - 2, Random(15) + 1);
      PutPixel(X, DivY - 1, Random(15) + 1);
      PutPixel(X, DivY, Random(15) + 1);
      PutPixel(X, DivY + 1, Random(15) + 1);
      PutPixel(X, DivY + 2, Random(15) + 1);
      PutPixel(X, DivY + 3, Random(15) + 1);
    end;
  if NegOrPos = False then
    for X := GetMaxX downto 0 do
    begin
      PutPixel(X, DivY - 3, Random(15) + 1);
      PutPixel(X, DivY - 2, Random(15) + 1);
      PutPixel(X, DivY - 1, Random(15) + 1);
      PutPixel(X, DivY, Random(15) + 1);
      PutPixel(X, DivY + 1, Random(15) + 1);
      PutPixel(X, DivY + 2, Random(15) + 1);
      PutPixel(X, DivY + 3, Random(15) + 1);
    end;
end;

procedure GetBall;
begin
  GradePalette(Re);
  Y := 120;
  for X := 0 to 15 do
  begin
    Dec(Y);
    SetColor(X);
    SetFillStyle(1, X);
    FillEllipse(Y div 4, Y div 4, 15 - X, 15 - X);
  end;
  Size := ImageSize(0, 0, 55, 50);
  GetMem(Ball, Size);
  GetImage(0, 0, 55, 50, Ball^);
end;

procedure BallSmash;
begin
  SetActivePage(0);
  if GotBall <> True then GetBall
  {else GradePalette(Hues[Random(6) + 1])};
  GotBall := True;
  for X := 1 to 2 do
  begin
    XPos[X] := 0;
    YPos[X] := 0;
  end;
  //Randomize;
  PutImage(GetMaxX, GetMaxY - 20, Ball^, XORPut);
  repeat
    CalcBall(1);
    PutImage(XPos[1], YPos[1], Ball^, NormalPut);
    CalcBall(2);
    PutImage(GetMaxX - XPos[2], GetMaxY - YPos[2], Ball^, NormalPut);
    PutImage(GetMaxX - XPos[2], YPos[1], Ball^, NormalPut);
    PutImage(XPos[1], GetMaxY - YPos[2], Ball^, NormalPut);
    CalcBall(1);
    PutImage(XPos[1], YPos[1], Ball^, NormalPut);
    CalcBall(2);
    PutImage(GetMaxX - XPos[2], GetMaxY - YPos[2], Ball^, NormalPut);
    PutImage(GetMaxX - XPos[2], YPos[1], Ball^, NormalPut);
    PutImage(XPos[1], GetMaxY - YPos[2], Ball^, NormalPut);
    if KeyPressed then Quitter;
  until YPos[1] >= DivY;
  //NormalColours;
  RedCircles;
  if not KeyPressed then
    PixAcross(False);
  if not KeyPressed then
  begin
    ClearDevice;
    PixAcross(True);
  end;
end;

procedure OpenGraph;
begin
  Gd := VGA;
  Gm := VGAHi;
  InitGraph(Gd, Gm, '');
  DivX := GetMaxX div 2;
  DivY := GetMaxY div 2;
end;

begin
  //Randomize;
  OpenGraph;
  repeat
    BallSmash; Delay(1000);
    Shades; Delay(1000);
    UpDownLines; Delay(1000);
    MiddleShades; Delay(1000);
    Bounce; Delay(1000);
    RadialLines; Delay(1000);
    BlackRadialLines; Delay(1000);
    Spiral; Delay(1000);
    BlackSpiral; Delay(1000);
    Explosion; Delay(1000);
    Lines; Delay(1000);
    Circles; Delay(1000);
    Dissolve; Delay(1000);
    ColourIt; Delay(1000);
    BlackIt; Delay(1000);
  until KeyPressed;
end.
