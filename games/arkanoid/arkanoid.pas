
program Arkanoid;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, ptcMouse,
  Levels,
  Sound;

const
  Left = 75;
  Right = 77;
  Up = #72;
  Down = #80;
  Enter = #13;
  Esc = 1;
  Space = 57;
  MaxLevel = 10;
  
  PaddleStep = 15;
  BrickSizeX = 28;
  BrickSizeY = 12;

var
  BrickCount, Lives, Level, Score: integer;
  PaddleX, PaddleY, BallX, BallY, PauseN: integer;
  SpeedX, SpeedY: ShortInt;
  Paddle, Ball, P1, P2, P3, P4, P5, P6: pointer;
  EndGame, SoundPro: boolean;
  Tab: array[1..14, 1..14] of byte;
  MouseX, MouseY, MouseXOld, MouseYOld, Button: integer;
  MenuItem: byte;

const
  OptionItems: array[1..4] of string[15] = (
    'VITESSE BALLE',
    'NOMBRE DE VIES',
    'NIVEAU',
    'SON'
  );
  CYes = 'Oui';
  CNo = 'Non';
  
procedure Options;
const
  K = 45;
  X = 450;
var
  Item: byte;
  Y: word;
  Ch: char;
  Rate: array[1..3] of string[3];

  procedure DrawItem(Item: byte; Stat: boolean);
  begin
    Y := GetMaxY div 5;
    if Stat then
      SetColor(Yellow)
    else
      SetColor(LightGreen);
    //SetTextStyle(2, 0, 8);
    if Item = 1 then
      OutTextXY(X + 60, Y + K, '%');
    OutTextXY(110, Y + (K * Item), OptionItems[Item]);
    if Item = 4 then
      if SoundPro then
      begin
        OutTextXY(X, Y + K * Item, CYes);
        SetColor(LightGray);
        OutTextXY(X + 60, Y + K * Item, CNo);
      end else
      begin
        OutTextXY(X + 60, Y + K * Item, CNo);
        SetColor(LightGray);
        OutTextXY(X, Y + K * Item, CYes);
      end
    else
      OutTextXY(X, Y + K * Item, Rate[Item]);
  end;

  procedure ChangeOption(Option: byte; OK: boolean);
  begin
    SetColor(Black);
    //SetTextStyle(2, 0, 8);
    if Option < 4 then
      OutTextXY(X, Y + K * Option, Rate[Option]);
    case Option of
      1:
        begin
         if OK and (Rate[1] <>'100') then PauseN:=PauseN-10;
         if not OK and (Rate[1] <>'0') then PauseN:=PauseN+10;
         Str(100-(PauseN div 10), Rate[1]);
        end;
      2:
        begin
          if OK and (Lives < 50) then
            Inc(Lives);
          if not OK and (Lives > 1) then
            Dec(Lives);
          Str(Lives, Rate[2]);
        end;
      3:
        begin
          if OK and (Level < MaxLevel) then
            Inc(Level);
          if not OK and (Level > 1) then
            Dec(Level);
          Str(Level, Rate[3]);
        end;
      4:
        begin
          SoundPro := not SoundPro;
          DrawItem(4, TRUE);
        end;
    end;
    SetColor(Yellow);
    if Option < 4 then
      OutTextXY(X, Y + K * Option, Rate[Option]);
  end;

  procedure Draw;
  var
    Y: word;
  begin
    SetTextStyle(DefaultFont, HorizDir, 4);
    SetColor(LightGray);
    OutTextXY(185, GetMaxY div 12, 'Options');
    SetColor(LightRed);
    OutTextXY(180, GetMaxY div 12, 'Options');
    SetTextStyle(DefaultFont, HorizDir, 2);
    Str(100-(PauseN div 10), Rate[1]);
    Str(Lives, Rate[2]);
    Str(Level, Rate[3]);
    DrawItem(1, TRUE);
    DrawItem(2, FALSE);
    DrawItem(3, FALSE);
    DrawItem(4, FALSE);
    //SetTextStyle(2, 0, 5);
    SetColor(LightGray);
    Y := GetMaxY - 40;
    OutTextXY(100, Y, {'Изменение параметра <- и ->, перемещение по опциям'}'Changer le paramètre <- et ->, parcourir les options');
    OutTextXY(250, Y + 20, {'Выход: Esc или Enter '}'Quitter: Echap ou Entrée');
    Line(515, Y, 515, Y + 8);
    Line(515, Y, 512, Y + 3);
    Line(515, Y, 518, Y + 3);
    Line(525, Y, 525, Y + 8);
    Line(525, Y + 8, 522, Y + 5);
    Line(525, Y + 8, 528, Y + 5);
  end;

begin
  ClearDevice;
  Draw;
  Item := 1;
  repeat
    if KeyPressed then
    begin
      Ch := ReadKey;
      if (Ch = Up) or (Ch = Down) then
      begin
        DrawItem(Item, FALSE);
        if Ch = Up then
          if Item > 1 then
            Item := Item - 1
          else
            Item := 4;
        if Ch = Down then
          if Item < 4 then
            Item := Item + 1
          else
            Item := 1;
        DrawItem(Item, TRUE);
      end;
      if Ch = #75 then
        ChangeOption(Item, FALSE);
      if Ch = #77 then
        ChangeOption(Item, TRUE);
    end;
  until (Ch = #27) or (Ch = Enter);
  while KeyPressed do
    ReadKey;
  Ch := #0;
end;

procedure Help;
var
  K: integer;
begin
  K := (GetMaxY - 240) div 5;
  ClearDevice;
  SetColor(White);
  SetLineStyle(0, 0, 3);
  Rectangle(15, 15, GetMaxX - 15, GetMaxY - 15);
  SetLineStyle(0, 0, 0);
  SetColor(LightGray);
  SetFillStyle(1, LightGray);
  Bar(18, 18, GetMaxX - 18, GetMaxY - 18);
  PutImage(80, 240 + K, P1^, CopyPut);
  PutImage(80, 240 + (K * 2), P2^, CopyPut);
  PutImage(80, 240 + (K * 3), P3^, CopyPut);
  PutImage(350, 240 + K, P4^, CopyPut);
  PutImage(350, 240 + (K * 2), P5^, CopyPut);
  PutImage(350, 240 + (K * 3), P6^, CopyPut);
  ReadKey;
end;

procedure WelcomeScreen;
const
  ArkStr: string[8] = 'Arkanoid';
  
  procedure DrawLetter(const n: byte);
  begin
    OutTextXY(51 + 64 * Pred(N), 110, ArkStr[n]);
  end;

var
  X, Y: integer;
begin
  SetFillStyle(SolidFill, Red);
  Bar(0, 0, GetMaxX, GetMaxY);
  SetColor(Black);
  for Y := 1 to Succ(GetMaxY) div 18 do
    Line(0, Y * 18, GetMaxX, Y * 18);
  X := 0;
  Y := 0;
  repeat
    repeat
      Line(X, Y, X, Y + 18);
      Line(X - 17, Y + 18, X - 17, Y + 36);
      X := X + 35;
    until X > GetMaxX + 18;
    X := 0;
    Y := Y + 36;
  until Y > GetMaxY + 15;
  SetColor(Yellow);
  OutTextXY(200, GetMaxY - 80, 'Made by Kropochkina Lena 1999-2001');
  OutTextXY(240, GetMaxY - 60, 'All rights reserved');
  SetTextStyle(DefaultFont, HorizDir, 8);
  (*
  OutTextXY(50, 109, ArkStr);
  SetColor(LightGray);
  OutTextXY(51, 110, ArkStr);
  SetColor(Yellow);
  *)
  repeat
    SetColor(LightGray);
    OutTextXY(51, 110, ArkStr);
    Delay(500);
    SetColor(Yellow);
    X := 0;
    repeat
      GetMouseState(MouseX, MouseY, Button);
      Inc(X);
      DrawLetter(X);
      Delay(250);
    until (X = 8) or KeyPressed or (Button <> 0);
  until KeyPressed or (Button <> 0);
  //ReadKey;
  while KeyPressed do
    ReadKey;
end;

procedure GameOver;
var
  Pk, Xg, Color, F: integer;
  CurPos: boolean;
  Mass_K: array[1..6] of integer;
  
  procedure Picture(Yo, Xo: integer);
  begin
    Xo := Mass_K[F] - 15;
    SetColor(Color);
    Circle(Xo, Yo, 3);
    SetFillStyle(1, Color);
    FloodFill(Xo, Yo, Color);
    SetColor(0);
    Circle(Xo, Yo, 3);
    SetFillStyle(1, 0);
    FloodFill(Xo, Yo, 0);
    if Xo <= 0 then
      Xo := GetMaxX;
    Mass_K[F] := Xo;
    F := F + 1;
    if F = 7 then
      F := 1;
  end;
  
begin
  Xg := GetMaxX - 10;
  Pk := GetMaxX;
  CurPos := TRUE;
  //SetTextStyle(0, 0, 6);
  ClearDevice;
  for F := 1 to 6 do
  begin
    Mass_K[F] := Pk - 80;
    if Mass_K[F] <= 0 then
      Mass_K[F] := GetMaxX;
    Pk := Mass_K[F];
  end;
  F := 1;
  Color := 9;
  repeat
    GetMouseState(MouseX, MouseY,Button);
    Picture( 50, Mass_K[1]);
    Picture(100, Mass_K[2]);
    Picture(250, Mass_K[3]);
    Picture(150, Mass_K[4]);
    Picture(400, Mass_K[5]);
    Picture(350, Mass_K[6]);
    if CurPos then
    begin
      SetColor(Black);
      OutTextXY(Xg, 130, 'GAME OVER');
      Xg := Xg - 10;
      SetColor(LightBlue);
      OutTextXY(Xg, 130, 'GAME OVER');
      Delay(2);
    end;
    if Xg <= 120 then
      CurPos := FALSE;
    SetColor(Red);
    if CurPos = FALSE then
    begin
      OutTextXY(Xg, 130, 'GAME OVER');
      Color := 12;
    end;
  until KeyPressed or (Button <> 0);
  while KeyPressed do
    ReadKey;
end;

procedure CreateLevel;
var
  X, Y: integer;
  I, J: byte;
begin
  ClearDevice;
  for I := 1 to 14 do
    for J := 1 to 14 do
    begin
      X := ((J - 1) * BrickSizeX + 45);
      Y := ((I - 1) * BrickSizeY + 45);
      case Level of
        01: Tab[I, J] := Tab1[I, J];
        02: Tab[I, J] := Tab2[I, J];
        03: Tab[I, J] := Tab3[I, J];
        04: Tab[I, J] := Tab4[I, J];
        05: Tab[I, J] := Tab5[I, J];
        06: Tab[I, J] := Tab6[I, J];
        07: Tab[I, J] := Tab7[I, J];
        08: Tab[I, J] := Tab8[I, J];
        09: Tab[I, J] := Tab9[I, J];
        10: Tab[I, J] := TabA[I, J];
      end;

      case Tab[I, J] of
        1: PutImage(X, Y, P1^, XorPut);
        2: PutImage(X, Y, P2^, XorPut);
        3: PutImage(X, Y, P3^, XorPut);
        4: PutImage(X, Y, P4^, XorPut);
        5: PutImage(X, Y, P5^, XorPut);
        6: PutImage(X, Y, P6^, XorPut);
      end;
    end;
  
  BrickCount := 0;
  for I := 1 to 14 do
    for J := 1 to 14 do
      if Tab[I, J] <> 0 then
        Inc(BrickCount);
  
  SetColor(White);
  SetLineStyle(0, 0, 3);
  Rectangle(5, 5, GetMaxX - 152, GetMaxY + 5);
  SetLineStyle(0, 0, 0);
  SetColor(DarkGray);
  SetFillStyle(1, 8);
  Bar(GetMaxX - 130, 5, GetMaxX - 5, GetMaxY - 5);
  SetTextStyle(DefaultFont, HorizDir, 2);
  SetColor(Red);
  OutTextXY(GetMaxX - 100, 20, 'SCORE');
  OutTextXY(GetMaxX - 100, 100, 'LIVES');
  OutTextXY(GetMaxX - 100, 180, 'LEVEL');
end;

procedure WriteCount(Who, N: integer);
var
  S: string[6];
  Y: integer;
begin
  case Who of
    1: Y :=  40;
    2: Y := 120;
    3: Y := 200;
  end;
  Str(N, S);
  SetFillStyle(1, 8);
  Bar(GetMaxX - 85, Y, GetMaxX - 20, Y + 40);
  SetColor(Brown);
  SetTextStyle(DefaultFont, HorizDir, 2);
  OutTextXY(GetMaxX - 85, Y + 5, S);
end;

procedure Collision;
begin
  if (BallX >= PaddleX - 3) and (BallX <= PaddleX + 60 - 3) and (Abs(BallY - PaddleY) < 10) and (SpeedY > 0) then
  begin
    Play(sndPaddle);
    if BallX + 3 - PaddleX <= 10 then
    begin
      SpeedX := -2;
      SpeedY := 1;
    end else
    if (BallX + 3 - PaddleX > 10) and (BallX + 3 - PaddleX <= 20) then
    begin
      SpeedX := -1;
      SpeedY := 1;
    end else
    if (BallX + 3 - PaddleX > 20) and (BallX + 3 - PaddleX < 30) then
    begin
      SpeedX := -1;
      SpeedY := 2;
    end else
    if (BallX + 3 - PaddleX >= 30) and (BallX + 3 - PaddleX < 40) then
    begin
      SpeedX := 1;
      SpeedY := 2;
    end else
    if (BallX + 3 - PaddleX >= 40) and (BallX + 3 - PaddleX < 50) then
    begin
      SpeedX := 1;
      SpeedY := 1;
    end else
    if (BallX + 3 - PaddleX >= 50) then
    begin
      SpeedX := 2;
      SpeedY := 1;
    end;
    SpeedY := -1 * SpeedY;
  end;
end;

procedure MovePaddle;
begin
  PutImage(PaddleX, PaddleY, Paddle^, XorPut);
  if (MouseX < MouseXOld) or (MouseX > MouseXOld) then
    if (MouseX >= 50) and (MouseX < GetMaxX - 190) then
      PaddleX := MouseX - 30;
  GetMouseState(MouseX, MouseY, Button);
  MouseXOld := MouseX;
  PutImage(PaddleX, PaddleY, Paddle^, XorPut);
end;

procedure BallOnPaddle;
begin
  SpeedX := 1;
  SpeedY := -1;
  repeat
    GetMouseState(MouseX, MouseY, Button);
    if MouseX <> MouseXOld then
    begin
      PutImage(BallX, BallY, Ball^, XorPut);
      PutImage(PaddleX, PaddleY, Paddle^, XorPut);
      if (MouseX < MouseXOld) or (MouseX > MouseXOld) then
        if (MouseX >= 50) and (MouseX < GetMaxX - 190) then
        begin
          PaddleX := MouseX - 30;
          BallX := PaddleX + 30 - 3;
        end;
      GetMouseState(MouseX, MouseY, Button);
      MouseXOld := MouseX;
      PutImage(BallX, BallY, Ball^, XorPut);
      PutImage(PaddleX, PaddleY, Paddle^, XorPut);
    end;
  until KeyPressed or (Button <> 0);
end;

procedure MoveBall;
begin
  PutImage(BallX, BallY, Ball^, XorPut);
  BallX := BallX + SpeedX;
  BallY := BallY + SpeedY;
  if (BallX > GetMaxX - 165) or (BallX < 10) then
  begin
    SpeedX := -1 * SpeedX;
    Play(sndWall);
  end;
  if BallY < 10 then
  begin
    SpeedY := -1 * SpeedY;
    Play(sndWall);
  end;
  if BallY > GetMaxY then
  begin
    Lives := Lives - 1;
    Play(sndFall);
    if Lives = 0 then
      EndGame := TRUE
    else
    begin
      WriteCount(2, Lives);
      PutImage(BallX, BallY, Ball^, XorPut);
      PutImage(PaddleX, PaddleY, Paddle^, XorPut);
      BallX := PaddleX + 30 - 3;
      BallY := PaddleY - 8;
      PutImage(BallX, BallY, Ball^, XorPut);
      PutImage(PaddleX, PaddleY, Paddle^, XorPut);
      BallOnPaddle;
    end;
  end else
  begin
    PutImage(BallX, BallY, Ball^, XorPut);
    Delay({Pause}10);
  end;
end;

procedure Win;
var
  Y: word;
begin
  if Level = MaxLevel then
  begin
    ClearDevice;
    //SetTextStyle(2, 0, 8);
    SetColor(LightRed);
    Y := GetmaxY div 4;
    OutTextXY((GetMaxX div 4) - 10, Y, 'Примите поздравления!');
    //SetTextStyle(2, 0, 5);
    SetColor(Yellow);
    OutTextXY(200, Y + 70, {'Вы прошли все уровни.'}'Toutes nos félicitations!');
    SetColor(LightGray);
    OutTextXY(200, GetMaxY - 40, {'Нажмите любую клавишу'}'Appuyez sur une touche');
    while KeyPressed do
      ReadKey;
    EndGame := TRUE;
  end else
  begin
    Inc(Level);
    CreateLevel;
    PaddleX := GetMaxX div 2;
    BallX := PaddleX + 30 - 3;
    PaddleY := GetMaxY - 30;
    BallY := PaddleY - 8;
    SpeedX := 1;
    SpeedY := -1;
    PutImage(PaddleX, PaddleY, Paddle^, XorPut);
    PutImage(BallX, BallY, Ball^, XorPut);
    WriteCount(1, Score);
    WriteCount(2, Lives);
    WriteCount(3, Level);
    BallOnPaddle;
  end;
end;

procedure Kick;
var
  Xp, Yp, Xt, Yt, I, J: integer;
  Tr: boolean;
  Cr, BallRadius: byte;
begin
  Cr := 0;
  BallRadius := 7;
  Xt := BallX - 45;
  Yt := BallY - 45;
  Xp := Xt;
  Yp := Yt;
  Tr := TRUE;
  repeat
    Cr := Cr + 1;
    if (Xp >= 0) and (Yp >= 0) then
    begin
      case Cr of
        2:
          begin
            Xp := Xt + BallRadius;
            Yp := Yt;
          end;
        3:
          begin
            Yp := Yt + BallRadius;
            Xp := Xt;
          end;
        4:
          begin
            Xp := Xt + BallRadius;
            Yp := Yt + BallRadius;
          end;
      end;
      J := (Xp div BrickSizeX) + 1;
      I := (Yp div BrickSizeY) + 1;
      if ((Xp mod BrickSizeX) = 0) and (J > 1) and (SpeedX < 0) then
        Dec(J);
      if ((Yp mod BrickSizeY) = 0) and (I > 1) and (SpeedY < 0) then
        Dec(I);
      if (I > 14) and (Yp < 169) then
        I := 14;
      if (J > 14) and (Xp < 393) then
        J := 14;
      if I < 1 then
        I := 1;
      if J < 1 then
        J := 1;
      if (I < 15) and (J < 15) and (Tab[I, J] <> 0) and Tr then
      begin
        Tr := FALSE;
        if ((Xp mod BrickSizeX) = 0) then
          SpeedX := -1 * SpeedX;
        if (((Xp mod BrickSizeX) = 1) or ((Xp mod BrickSizeX) = BrickSizeX - 1)) and (Abs(SpeedX) = 2) then
          SpeedX := -1 * SpeedX;
        if ((Yp mod BrickSizeY) = 0) then
          SpeedY := -1 * SpeedY;
        if (((Yp mod BrickSizeY) = 1) or ((Yp mod BrickSizeY) = BrickSizeY - 1)) and (Abs(SpeedY) = 2) then
          SpeedY := -1 * SpeedY;
        Xp := (J - 1) * (BrickSizeX) + 45;
        Yp := (I - 1) * (BrickSizeY) + 45;
        
        PutImage(BallX, BallY, Ball^, XorPut);

        case Tab[I, J] of
          1:
            begin
              PutImage(Xp, Yp, P1^, XorPut);
              BrickCount := BrickCount - 1;
              Score := Score + 3;
              Tab[I, J] := 0;
              Play(sndBrick5);
            end;
          2:
            begin
              PutImage(Xp, Yp, P1^, CopyPut);
              Tab[I, J] := 1;
              Score := Score + 2;
              Play(sndBrick4);
            end;
          3:
            begin
              PutImage(Xp, Yp, P2^, CopyPut);
              Tab[I, J] := 2;
              Score := Score + 1;
              Play(sndBrick3);
            end;
          4:
            begin
              PutImage(Xp, Yp, P3^, CopyPut);
              Tab[I, J] := 3;
              Score := Score + 1;
              Play(sndBrick2);
            end;
          5:
            begin
              PutImage(Xp, Yp, P4^, CopyPut);
              Tab[I, J] := 4;
              Score := Score + 1;
              Play(sndBrick1);
            end;
          6:
            begin
              PutImage(Xp, Yp, P5^, CopyPut);
              Tab[I, J] := 5;
              Score := Score + 1;
              Play(sndBrick1);
            end;
        end;
        WriteCount(1, Score);
        PutImage(BallX, BallY, Ball^, XorPut);
        if BrickCount = 0 then
          Win;
      end;
    end;
  until Cr = 4;
end;

procedure Game;
begin
  ClearDevice;
  EndGame := FALSE;
  PaddleX := GetMaxX div 2;
  PaddleY := GetMaxY - 30;
  BallX := PaddleX + 30 - 3;
  BallY := PaddleY - 8;
  SpeedX := 1;
  SpeedY := -1;
  Score := 0;
  CreateLevel;
  PutImage(PaddleX, PaddleY, Paddle^, XorPut);
  PutImage(BallX, BallY, Ball^, XorPut);
  WriteCount(1, Score);
  WriteCount(2, Lives);
  WriteCount(3, Level);
  BallOnPaddle;
  repeat
    GetMouseState(MouseX, MouseY, Button);
    if MouseX <> MouseXOld then MovePaddle;
    MoveBall;
    if (BallX > 38) and (BallX < 438) and (BallY > 38) and (BallY < 214) then
      Kick;
    Collision;
    if KeyPressed and (ReadKey = #27) then
      Break;
  until EndGame;
  if Lives = 0 then
    GameOver;
end;

procedure Menu(var Nv: byte);

  procedure AnimatedTitle2;
  var
    Sa, Xa, Ya: integer;
    TextMove: boolean = TRUE;
  begin
    ClearDevice;
    if TextMove then
    begin
      Sa := 0;
      Xa := 230;
      Ya := GetmaxY div 10;
      repeat
        if Sa > 0 then
        begin
          SetTextStyle(DefaultFont, HorizDir, Sa);
          SetColor(Black);
          OutTextXY(Pred(Xa), Pred(Ya), 'Arkanoid');
          OutTextXY(Xa, Ya, 'Arkanoid');
        end;
        
        Xa := Xa - 10;
        Ya := Ya + 5;
        Sa := Sa + 1;
        
        SetTextStyle(DefaultFont, HorizDir, Sa);
        SetColor(LightGray);
        OutTextXY(Pred(Xa), Pred(Ya), 'Arkanoid');
        SetColor(LightRed);
        OutTextXY(Xa, Ya, 'Arkanoid');
        Delay(250);
      until Sa = 6;
      TextMove := FALSE;
    end;
    SetTextStyle(DefaultFont, HorizDir, 6);
    SetColor(LightGray);
    OutTextXY(169, (GetMaxY div 10) + 29, 'Arkanoid');
    SetColor(LightRed);
    OutTextXY(170, (GetMaxY div 10) + 30, 'Arkanoid');
    SetTextStyle(DefaultFont, HorizDir, 2);
  end;

const
  MenuItems: array[1..4] of string[7] = ('GAME', 'HELP', 'OPTIONS', 'EXIT');
var
  Ch: char;
  
  procedure DrawItem(Item: byte; Stat: boolean);
  begin
    if Stat then
    begin
      SetFillStyle(1, 14);
      SetColor(Green);
    end else
    begin
      SetFillStyle(1, 0);
      SetColor(LightGreen);
    end;
    Bar(255, 130 + (40 * Item) - 2, 372, 130 + (40 * Item) + 15);
    if Item = 3 then
      OutTextXY(260, 130 + (40 * Item), MenuItems[Item])
    else
      OutTextXY(280, 130 + (40 * Item), MenuItems[Item]);
  end;

begin
  Nv := 1;
  AnimatedTitle2;
  DrawItem(1, TRUE);
  DrawItem(2, FALSE);
  DrawItem(3, FALSE);
  DrawItem(4, FALSE);
  while KeyPressed do
    ReadKey;
  GetMouseState(MouseX, MouseY, Button);
  MouseYOld := MouseY;
  Ch := #0;
  repeat;
    GetMouseState(MouseX, MouseY, Button);
    if KeyPressed or (Abs(MouseY - MouseYOld) > 15) then
    begin
      if KeyPressed then
        Ch := ReadKey;
      if (Ch = #0) or (Abs(MouseY - MouseYOld) > 15) then
      begin
        if KeyPressed then
          Ch := ReadKey;
        DrawItem(Nv, FALSE);
        if (Ch = Up) or (MouseY < MouseYOld) then
          if Nv > 1 then
            Nv := Nv - 1
          else
            Nv := 4;
        if (Ch = Down) or (MouseY > MouseYOld) then
          if Nv < 4 then
            Nv := Nv + 1
          else
            Nv := 1;

          GetMouseState(MouseX, MouseY, Button);
          MouseYOld := MouseY;

        DrawItem(Nv, TRUE);
      end;
    end;
  until (Ch = Enter) or (Button <> 0);

  while KeyPressed do
    ReadKey;
  Ch := #0;
end;

procedure CreateImages;
var
  PicSize: integer;
  
  function Brick(BrickColor: byte): pointer;
  var
    Pic: pointer;
  begin
    SetFillStyle(1, BrickColor + 8);
    Bar(0, 0, 25, 9);
    SetColor(BrickColor);
    Rectangle(26, 0, 27, 11);
    Rectangle(0, 10, 27, 11);
    GetMem(Pic, PicSize);
    GetImage(0, 0, 27, 11, Pic^);
    Brick := Pic;
  end;
  
begin
  PicSize := ImageSize(0, 0, 27, 11);
  P1 := Brick(5);
  P2 := Brick(6);
  P3 := Brick(1);
  P4 := Brick(4);
  P5 := Brick(3);
  P6 := Brick(2);

  ClearDevice;
  SetColor(LightCyan);
  Line(3, 0, 56, 0);
  Line(2, 1, 57, 1);
  Line(1, 2, 58, 2);
  SetFillStyle(1, LightCyan);
  Bar(0, 3, 59, 6);
  Line(1, 7, 58, 7);
  Line(2, 8, 57, 8);
  Line(3, 9, 56, 9);
  SetColor(Red);
  Line(8, 3, 51, 3);
  Line(7, 4, 52, 4);
  Line(7, 5, 52, 5);
  Line(8, 6, 51, 6);
  PicSize := ImageSize(0, 0, 59, 9);
  GetMem(Paddle, PicSize);
  GetImage(0, 0, 59, 9, Paddle^);
  
  ClearDevice;
  SetColor(White);
  Circle(3, 3, 3);
  SetFillStyle(1, White);
  FloodFill(3, 3, White);
  PicSize := ImageSize(0, 0, 6, 6);
  GetMem(Ball, PicSize);
  GetImage(0, 0, 6, 6, Ball^);
  ClearDevice;
end;

var
  GrDriver, GrMode: smallint;
  
begin
  GrDriver := EGA;
  GrMode := EGAHi;
  InitGraph(GrDriver, GrMode, '');
  Randomize;
  CreateImages;
  WelcomeScreen;
  PauseN:=150;
  Lives := 5;
  Level := 1;
  SoundPro := TRUE;
  repeat
    Menu(MenuItem);
    case MenuItem of
      1: Game;
      2: Help;
      3: Options;
    end;
  until MenuItem = 4;
  FreeMem(Ball);
  FreeMem(Paddle);
  FreeMem(P6);
  FreeMem(P5);
  FreeMem(P4);
  FreeMem(P3);
  FreeMem(P2);
  FreeMem(P1);
  CloseGraph;
end.
