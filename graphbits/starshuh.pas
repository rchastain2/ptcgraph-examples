
program Stars;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph,
  ptcCrt,
  GraphBits;
  
const
  Max = 3238;
  
type
  TStar = object
    OldX, OldY,
    ScreenX, ScreenY,
    C, X, Y, Z: integer;
    Colour: Word;
    procedure New;
    procedure Move;
  end;

var
  Image: Pointer;
  Size: Word;
  ScreenDist: integer;
  Num, X: integer;
  Star: array[1..Max] of TStar;

procedure Create;
begin
  GradePalette(Grey);
  SetLineStyle(1, 1, ThickWidth);
  for X := 1 to 15 do
  begin
    SetColor(X);
    Circle(15, 15, 16 - X);
  end;
  Size := ImageSize(0, 0, 30, 30);
  GetMem(Image, Size);
  GetImage(0, 0, 30, 30, Image^);
end;

procedure TStar.New;
begin
  X := Random(640) - 320;
  Y := Random(480) - 240;
  Z := Random(256) + 1;
  C := 0;
  Colour := 0;
end;

procedure TStar.Move;
begin
  SetActivePage(0);
  SetVisualPage(1);
  PutImage(320 + ScreenX, 240 + ScreenY, Image^, XORPut);

  ScreenX := ScreenDist * Y div Z;
  ScreenY := ScreenDist * X div Z;
  Dec(Z);

  SetActivePage(1);
  SetVisualPage(0);
  PutImage(320 + ScreenX, 240 + ScreenY, Image^, XORPut);
  if Z < 1 then New;
end;

begin
  GraphicsScreen;
  GradePalette(Grey);
  Create;
  ScreenDist := 100;
  Val(ParamStr(1), Num, X);
  if (Num < 1) or (Num > Max) then Num := 100;
  for X := 1 to Num do
    Star[X].New;
  X := 1;
  while not KeyPressed do
  begin
    Inc(X);
    Star[X].Move;
    if X > Num - 1 then X := 0;
  end;
  CloseGraph;
  
  FreeMem(Image);
end.
