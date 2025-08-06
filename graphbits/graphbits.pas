
unit graphbits;

{$MODE DELPHI}

interface

function GraphicsScreen: boolean;
procedure Button(x1, y1, x2, y2, os: integer);
procedure Point(Exx, Whyy, Size, Culla: integer); {X coord, Y coord, size in pixels, colour}
procedure DrawTubeLine(Ex, Why, Leng, Col: integer; XorY: string);
procedure Tube(StartX, StartY, Length: integer; XoY: string);
procedure InitBlocks;
procedure BlockArea(X1, Y1, X2, Y2: integer);
procedure RGB256;

type
  Colour = (Grey, Bl, Gr, Re, Ye, Pu, LPu, Aq);

procedure GradePalette(Hue: Colour);

var
  Block, Half: Pointer;
  DivX, DivY: integer;
  
implementation

uses
  ptcGraph;

function GraphicsScreen: boolean;
var
  GraphDriver, GraphMode, ErrorCode: smallint;
begin
  GraphDriver := VGA;
  GraphMode := VGAHi;
  InitGraph(GraphDriver, GraphMode, '');
  ErrorCode := GraphResult;
  result := ErrorCode = GrOK;
  if result then
  begin
    DivX := GetMaxX div 2;
    DivY := GetMaxY div 2;
  end else
  begin
    Writeln(ErrOutput, 'Error: ', GraphErrorMsg(ErrorCode));
  end;
end;

procedure Point;
var
  S, XInty, YInty: integer;
begin
  S := Size div 2;
  for XInty := Exx to Exx + S do
    for YInty := Whyy to Whyy + S do
      PutPixel(XInty, YInty, Culla);
end;

procedure button;
begin
  rectangle(x1, y1, x2, y2);
  line(x1, y1, x1 + os, y1 + os);
  line(x2, y2, x2 - os, y2 - os);
  line(x2, y1, x2 - os, y1 + os);
  line(x1, y2, x1 + os, y2 - os);
  rectangle(x1 + os, y1 + os, x2 - os, y2 - os);
end;

procedure DrawTubeLine;
begin
  SetColor(Col);
  if XorY = 'Hor' then
  begin
    MoveTo(Ex, GetY + 1);
    LineTo(Ex + Leng, GetY);
  end;
  if XorY = 'Ver' then
  begin
    MoveTo(GetX + 1, Why);
    LineTo(GetX, Why + Leng);
  end;
end;

procedure Tube;
begin
  MoveTo(StartX, StartY);
  DrawTubeLine(StartX, StartY, Length, 8, XoY);
  DrawTubeLine(StartX, StartY, Length, 0, XoY);
  DrawTubeLine(StartX, StartY, Length, 8, XoY);
  DrawTubeLine(StartX, StartY, Length, 8, XoY);
  DrawTubeLine(StartX, StartY, Length, 7, XoY);
  DrawTubeLine(StartX, StartY, Length, 7, XoY);
  DrawTubeLine(StartX, StartY, Length, 7, XoY);
  DrawTubeLine(StartX, StartY, Length, 15, XoY);
  DrawTubeLine(StartX, StartY, Length, 15, XoY);
  DrawTubeLine(StartX, StartY, Length, 15, XoY);
  DrawTubeLine(StartX, StartY, Length, 15, XoY);
  DrawTubeLine(StartX, StartY, Length, 7, XoY);
  DrawTubeLine(StartX, StartY, Length, 7, XoY);
  DrawTubeLine(StartX, StartY, Length, 7, XoY);
  DrawTubeLine(StartX, StartY, Length, 8, XoY);
  DrawTubeLine(StartX, StartY, Length, 8, XoY);
  DrawTubeLine(StartX, StartY, Length, 0, XoY);
  DrawTubeLine(StartX, StartY, Length, 8, XoY);
end; { Tube }

procedure InitBlocks;
var
  X, L, W: integer;
  Size: Word;
begin
  { Full block }
  SetColor(Brown);
  SetFillStyle(1, Brown);
  L := 39;
  W := 20;
  Bar(0, 0, L, W);
  SetColor(LightGray);
  Line(2, 2, L - 2, 2);
  Line(L - 2, 2, L - 2, W - 2);
  SetColor(Black);
  Line(2, 2, 2, W - 2);
  Line(2, W - 2, L - 2, W - 2);
  for X := 1 to 50 do
    PutPixel(Random(36) + 1, Random(16) + 3, Black);
  Size := ImageSize(0, 0, L, W);
  GetMem(Block, Size);
  GetImage(0, 0, L, W, Block^);
  { End full block, start half block }
  L := 119;
  W := 19;
  SetColor(Brown);
  SetFillStyle(1, Brown);
  Bar(L - 20, 0, L, W);
  SetColor(LightGray);
  Line(L - 18, W - 17, L - 1, W - 17);
  Line(L - 1, W - 17, L - 1, W - 1);
  SetColor(Black);
  Line(L - 18, W - 18, L - 18, W - 1);
  Line(L - 18, W - 1, L - 1, W - 1);
  for X := 1 to 50 do
    PutPixel(Random(L - 3) + 100, Random(W - 3) + 3, Black);
  Size := ImageSize(100, 0, L, W);
  GetMem(Half, Size);
  GetImage(100, 0, L, W, Half^);
  { end half block }
end;

procedure BlockArea;
var
  X, Y: integer;
  Lin: Boolean;
begin
  X := X1;
  Y := Y1;
  Lin := False;
  repeat
    if Lin = True then
    begin
      PutImage(X, Y, Half^, NormalPut);
      Inc(X, 20);
    end;
    while X + 40 <= X2 do
    begin
      PutImage(X, Y, Block^, NormalPut);
      Inc(X, 40);
    end;
    if X = X2 - 20 then
    begin
      PutImage(X, Y, Half^, NormalPut);
      Inc(X, 20);
    end;
    Inc(Y, 20);
    X := X1;
    if Lin = True then Lin := False
    else Lin := True;
  until Y >= Y2;
end;

procedure RestorePalette;
begin
end;

procedure GradePalette;
var
  G, R, X: integer;
begin
  X := 0; G := 0;
  for X := 1 to 15 do
    SetPalette(X, X);
  if Hue = Grey then
    for R := 0 to {15}  63 do
    begin
      SetRGBPalette(R, G, G, G);
      Inc(G, 4);
    end;
  if Hue = Bl then
    for R := 0 to {15}  63 do
    begin
      SetRGBPalette(R, 0, 0, G);
      Inc(G, 4);
    end;
  if Hue = Gr then
    for R := 0 to {15}  63 do
    begin
      SetRGBPalette(R, 0, G, 0);
      Inc(G, 4);
    end;
  if Hue = Re then
    for R := 0 to {15}  63 do
    begin
      SetRGBPalette(R, G, 0, 0);
      Inc(G, 4);
    end;
  if Hue = Ye then
    for R := 0 to {15}  63 do
    begin
      SetRGBPalette(R, G, G, 0);
      Inc(G, 4);
    end;
  if Hue = Pu then
    for R := 0 to {15}  63 do
    begin
      SetRGBPalette(R, G, 0, G);
      Inc(G, 4);
    end;
  if Hue = LPu then
    for R := 0 to {15}  63 do
    begin
      SetRGBPalette(R, G, G div 2, G);
      Inc(G, 4);
    end;
  if Hue = Aq then
    for R := 0 to {15}  63 do
    begin
      SetRGBPalette(R, 0, G, G);
      Inc(G, 4);
    end;
end;

procedure RGB256;
var
  R, G, B: integer;
  X, Y: integer;
begin
  for R := 0 to 63 do
  begin
    SetRGBPalette(R, R, 0, 0);
    SetColor(R);
    MoveTo(0, 0);
    OutText('Just a sec...');
  end;
  R := 0;
  for G := 1 to 63 do
  begin
    SetRGBPalette(G + 127, G, G + 127, 0);
    SetColor(G + 126);
  end;
  G := 0;
  for B := 0 to 63 do
  begin
    SetRGBPalette(B + 190, 0, 0, B);
    SetColor(B + 190);
  end;
  for X := 0 to 255 do
  begin
    SetColor(X);
    Line(X, 180, X, 199);
  end;
end;

end.
