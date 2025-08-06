program pages;
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph,
  ptcCrt,
  GraphBits;
var
  X, Y, XPos, YPos: smallint;
  Size, Result: Word;
  F: file;
  Dog1, Dog2: Pointer;
  Dir: Boolean;

procedure GetPistonImage;
begin
  Size := ImageSize(0, 0, 75, 50);
  GetMem(Dog1, Size);
  Assign(F, 'dog.pic');
  Reset(F, Size);
  BlockRead(F, Dog1^, 1, Result);
  Close(F);
  Size := ImageSize(0, 0, 75, 50);
  GetMem(Dog2, Size);
  Assign(F, 'movedog.pic');
  Reset(F, Size);
  BlockRead(F, Dog2^, 1, Result);
  Close(F);
end;

begin
  X := VGA;
  Y := 1;
  InitGraph(X, Y, '');
  GetPistonImage;
  YPos := 1;
  XPos := 10;
  Y := 50;
  Dir := True;
  SetColor(Black);
  SetFillStyle(1, Black);
  repeat
    Delay(Y);
    SetVisualPage(2);
    SetActivePage(1);
    ClearDevice;
    PutImage(XPos, YPos, Dog2^, NormalPut);
    Inc(XPos, 10);
    if XPos > GetMaxX - 80 then
    begin
      Inc(YPos, 50);
      XPos := 10;
    end;
    if YPos > GetMaxY - 40 then YPos := 1;
    Delay(Y);
    SetVisualPage(1);
    SetActivePage(2);
    ClearDevice;
    PutImage(XPos, YPos, Dog1^, NormalPut);
  until KeyPressed;
  CloseGraph;
end.
