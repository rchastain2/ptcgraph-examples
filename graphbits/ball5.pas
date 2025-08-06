program Bounce;
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph,
  ptcCrt,
  GraphBits;
var
  Gd, Gm: smallint;
  XPos, YPos, Y: integer;
  Size, Col: Word;
  Ball: Pointer;
  XDir, YDir: Boolean;
  Snd, Ht: Integer;
  Ch: Char;

procedure Beginnings;
begin
  Gd := VGA;
  Gm := 1;
  InitGraph(Gd, Gm, '');
  SetColor(Col);
  SetFillStyle(1, Col);
  FillEllipse(15, 10, 15, 10);
  SetColor(White);
  Ellipse(15, 10, 0, 70, 12, 8);
  Ellipse(15, 10, 80, 85, 12, 8);
  SetColor(Black);
  Ellipse(15, 10, 180, 270, 13, 9);
  Size := ImageSize(0, 0, 30, 20);
  GetMem(Ball, Size);
  GetImage(0, 0, 30, 20, Ball^);
  ClearDevice;
  Randomize;
end;

procedure NewDo;
begin
  XPos := 10;
  Ypos := 12;
  Ht := 1;
  XDir := True;
  YDir := True;
end;

procedure GetDelay;
var
  err: integer;
begin
  if ParamCount <> 0 then
    Val(ParamStr(1), Col, err)
  else Col := Blue;
end;

procedure Crash;
begin
  Sound(Snd); Delay(5);
  NoSound;
end;

procedure CalcBall;
begin
  Inc(Ht);
  case XDir of
    True: Inc(XPos, Ht div 5);
    False: Dec(XPos, Ht div 5);
  end;
  case YDir of
    True: Inc(YPos, YPos div 5);
    False: Dec(YPos, YPos div 5);
  end;
  if XPos > GetMaxX - 30 then
  begin
    XDir := False;
    XPos := GetMaxX - 30;
    Crash;
  end;
  if XPos < 10 then
  begin
    XDir := True;
    Ht := 4;
    XPos := 10;
    Crash;
  end;
  if YPos > GetMaxY - 50 then
  begin
    YDir := False;
    Crash;
  end;
  if YPos < 10 then
  begin
    YDir := True;
  end;
end;

begin
  GetDelay;
  Beginnings;
  NewDo;
  y := 100;
  PutImage(XPos, YPos, Ball^, XORPut);
  repeat
    repeat
      SetVisualPage(1);
      SetActivePage(2);
      ClearDevice;
      CalcBall;
      PutImage(XPos, YPos, Ball^, XORPut);
      Delay(Y);
      SetVisualPage(2);
      SetActivePage(1);
      ClearDevice;
      CalcBall;
      PutImage(XPos, YPos, Ball^, XORPut);
      Delay(Y);
    until KeyPressed;
    Ch := ReadKey;
    if UpCase(Ch) = 'S' then if Snd = 100 then Snd := 0
      else Snd := 100;
  until UpCase(Ch) <> 'S';
  CloseGraph;
end.
