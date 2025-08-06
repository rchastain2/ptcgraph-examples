
{ https://github.com/glennkentwell/code/tree/master/pascal }

program Nuclear;
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcCrt,
  ptcGraph,
  GraphBits;

var
  Ball: Pointer;
  Size: Word;
  X, Y, XMov, YMov: integer;

procedure Balls;
begin
  XMov := 1;
  YMov := 1;
  X := 0;
  Y := 0;
  ClearDevice;
  while not KeyPressed do
  begin
    PutImage(X, Y, Ball^, NormalPut);
    Inc(X, XMov);
    Inc(Y, YMov);
    if X > GetMaxX - 40 then XMov := -1;
    if Y > GetMaxY - 40 then YMov := -1;
    if X < 0 then XMov := 1;
    if Y < 0 then YMov := 1;
    Delay(5);
  end;
end;

begin
  GraphicsScreen;
  GradePalette(Re);
  Y := 80;
  for X := 0 to 15 do
  begin
    Dec(Y);
    SetColor(X);
    SetFillStyle(1, X);
    FillEllipse(Y div 4, Y div 4, 15 - X, 15 - X);
  end;
  Size := ImageSize(0, 0, 40, 40);
  GetMem(Ball, Size);
  GetImage(0, 0, 40, 40, Ball^);
  PutImage(GetMaxX div 2, GetMaxY div 2, Ball^, NormalPut);
  Balls;
  ReadKey;
  CloseGraph;
end.
