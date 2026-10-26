
uses
{$IFDEF UNIX}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;
  
type
  ballpresence = array[0..8, 0..8] of boolean;
  colors = array[0..8, 0..8] of integer;
  matmenu = array[0..2] of string[10];
  
var
  ci, cj, l, l1, l2, ui, uj, popx, popy, zi, i, j, d, k, colnum, score, x, y, colldp, pop, bufx, bufy, bufi, bufj, buttonhit, bufcol: integer;
  t: ballpresence; elementcolor, cmat: colors;
  c, ch: char;
  p: pointer;
  size: word;
  tox: string;
  z: byte;

const
  ball: array[0..8] of integer = (71, 113, 155, 197, 239, 281, 323, 365, 407);
  menu: matmenu = ('PLAY', 'RULES', 'EXIT');

{<<<<<<<<<<<<<<<<<Splash Screen>>>>>>>>>>>>>>>>>>>>>>>}

procedure Splash(var mk: byte);
const
  CDelay = 5;
begin
     {Letter L}
  SetColor(14);
  SetFillStyle(1, 14);
  FillEllipse(70, 150, 20, 20);
  for zi := 150 to 290 do
  begin
    Bar(60, 150, 80, zi);
    Delay(CDelay);
  end;
  FillEllipse(70, 290, 20, 20);
  for zi := 70 to 140 do
  begin
    Bar(70, 280, zi, 300);
    Delay(CDelay);
  end;
  FillEllipse(140, 290, 20, 20);
     {End of letter L}
     {Letter I}
  SetColor(9);
  SetFillStyle(1, 9);
  FillEllipse(190, 150, 20, 20);
  for zi := 150 to 290 do
  begin
    Bar(180, 150, 200, zi); Delay(CDelay);
  end;
  FillEllipse(190, 290, 20, 20);
     {End of letter I}
     {Letter N}
  SetColor(12);
  SetFillStyle(1, 12);
  FillEllipse(240, 290, 20, 20);
  for zi := 290 downto 150 do
  begin
    Bar(230, 290, 250, zi); Delay(CDelay);
  end;
  FillEllipse(240, 150, 20, 20);
  Line(230, 150, 250, 150);
  for zi := 230 to 300 do
  begin
    Line(230, 150, zi, (2 * zi) - 310); Delay(CDelay);
    Line(250, 150, zi + 20, (2 * (zi + 20)) - 350); Delay(CDelay);
  end;
  Line(300, 290, 320, 290);
  FloodFill(270, 220, 12);
  FillEllipse(310, 290, 20, 20);
  for zi := 290 downto 150 do
  begin
    Bar(300, 290, 320, zi); Delay(CDelay);
  end;
  FillEllipse(310, 150, 20, 20);
     {End ofletter N}
     {Letter E}
  SetColor(10);
  SetFillStyle(1, 10);
  FillEllipse(420, 150, 20, 20);
  for zi := 420 downto 340 do
  begin
    Bar(420, 140, zi, 160); Delay(CDelay);
  end;
  for zi := 150 to 230 do
  begin
    Bar(340, 150, 360, zi); Delay(CDelay);
  end;
  for zi := 340 to 420 do
  begin
    Bar(340, 210, zi, 230); Delay(CDelay);
  end;
  for zi := 230 to 300 do
  begin
    Bar(340, 230, 360, zi); Delay(CDelay);
  end;
  for zi := 360 to 420 do
  begin
    Bar(360, 300, zi, 280); Delay(CDelay);
  end;
  FillEllipse(420, 290, 20, 20);
     {End of letter E}
     {Letter S}
  SetColor(13);
  SetFillStyle(1, 13);
  FillEllipse(470, 290, 20, 20);
  for zi := 470 to 560 do
  begin
    Bar(470, 300, zi, 280); Delay(CDelay);
  end;
  for zi := 280 downto 210 do
  begin
    Bar(560, 280, 540, zi); Delay(CDelay);
  end;
  for zi := 540 downto 470 do
  begin
    Bar(540, 210, zi, 230); Delay(CDelay);
  end;
  for zi := 230 downto 140 do
  begin
    Bar(470, 230, 490, zi); Delay(CDelay);
  end;
  for zi := 470 to 560 do
  begin
    Bar(470, 160, zi, 140); Delay(CDelay);
  end;
  FillEllipse(550, 150, 20, 20);
     {End of letter S}
  SetColor(15);
  SetTextStyle(6, 0, 6);
  OutTextXY(220, 325, 'PLAY');
  OutTextXY(220, 370, 'RULES');
  OutTextXY(220, 415, 'EXIT');
  y := 325;
  mk := 0;
  repeat
    ch := ReadKey;
    SetColor(15);
    OutTextXY(220, 325, 'PLAY');
    OutTextXY(220, 370, 'RULES');
    OutTextXY(220, 415, 'EXIT');
    SetColor(12);
    case ch of
      #72: if y > 325 then
        begin
          y := y - 45; mk := mk - 1;
        end else
        begin
          y := 415; mk := 2;
        end;
      #80: if y < 415 then
        begin
          y := y + 45; mk := mk + 1;
        end else
        begin
          y := 325; mk := 0;
        end;
    end;
    OutTextXY(220, y, menu[mk]);
  until ch = #13;
end;

{<<<<<<<<<<<<<<<<<<< DRAWING THE PLAYGROUND>>>>>>>>>>>>>>>>>}

procedure Setka;
begin
  i := 92;
  repeat
    Line(i, 50, i, 428);
    Line(50, i, 428, i);
    i := i + 42;
  until (i > 428);
  SetLineStyle(0, 0, 1);
  Rectangle(50, 50, 428, 428);
  Rectangle(455, 50, 614, 429);
  SetColor(14); SetTextStyle(6, 0, 6);
  OutTextXY(470, 60, 'L');
  SetColor(9); OutTextXY(500, 60, 'I');
  SetColor(12); OutTextXY(510, 60, 'N');
  SetColor(10); OutTextXY(540, 60, 'E');
  SetColor(13); OutTextXY(570, 60, 'S');
  SetColor(15);
  SetTextStyle(6, 0, 1);
  OutTextXY(480, 210, 'Use keyboard ');
  OutTextXY(480, 230, 'to move balls!!!');
  OutTextXY(470, 342, 'TAKE: <Enter>');
  OutTextXY(470, 382, 'EXIT:  <Esc>');
  OutTextXY(470, 362, 'UNTAKE: <Alt+Z>');
  SetTextStyle(0, 0, 1);
  Rectangle(519, 263, 549, 293);
  Rectangle(519, 298, 549, 328);
  Rectangle(484, 298, 514, 328);
  Rectangle(554, 298, 584, 328);
  OutTextXY(531, 278, ' ');
  OutTextXY(531, 313, ' ');
  OutTextXY(499, 310, ' ');
  OutTextXY(569, 310, ' ');
end;

{<<<<<<<<<<<<<<<<<<< YEREQ XARY GUND GCELU PROCEDURA>>>>>>>>>>>>>>>>>}

procedure RandomBalls;
begin
  d := random(6);
  case d of
    0:
      begin
        SetFillStyle(1, 14); SetColor(14); colnum := 14;
      end;
    1:
      begin
        SetFillStyle(1, 12); SetColor(12); colnum := 12;
      end;
    2:
      begin
        SetFillStyle(1, 9); SetColor(9); colnum := 9;
      end;
    3:
      begin
        SetFillStyle(1, 10); SetColor(10); colnum := 10;
      end;
    4:
      begin
        SetFillStyle(1, 13); SetColor(13); colnum := 13;
      end;
    5:
      begin
        SetFillStyle(1, 7); SetColor(7); colnum := 7;
      end;
  end;
  repeat
    i := random(9);
    j := random(9);
  until not t[i, j];
  FillEllipse(ball[i], ball[j], 10, 10);
  t[i, j] := true;
  ElementColor[i, j] := colnum;
end;

{<<<<<<<<<<<<<<<<<<<<PROCEDURE CHANGIN X YS TO I JS>>>>>>>>>>>>>>>}

procedure MATRIX;
begin
  case x of
    55: i := 0;
    97: i := 1;
    139: i := 2;
    181: i := 3;
    223: i := 4;
    265: i := 5;
    307: i := 6;
    349: i := 7;
    391: i := 8;
  end;
  case y of
    55: j := 0;
    97: j := 1;
    139: j := 2;
    181: j := 3;
    223: j := 4;
    265: j := 5;
    307: j := 6;
    349: j := 7;
    391: j := 8;
  end;
end;

procedure Unmatrix;
begin
  case ui of
    0: popx := 55;
    1: popx := 97;
    2: popx := 139;
    3: popx := 181;
    4: popx := 223;
    5: popx := 265;
    6: popx := 307;
    7: popx := 349;
    8: popx := 391;
  end;
  case uj of
    0: popy := 55;
    1: popy := 97;
    2: popy := 139;
    3: popy := 181;
    4: popy := 223;
    5: popy := 265;
    6: popy := 307;
    7: popy := 349;
    8: popy := 391;
  end;
end;

{<<<<<<<<<<<<<Achokner hashvelu yev artacelu>>>>>>>>>>>>>>>>>>}

procedure ScoreCount;
begin
  case colldp of
    4: score := score + 8;
    5: score := score + 10;
    6: score := score + 12;
    7: score := score + 14;
    8: score := score + 16;
  end;
  str(score, tox);
  tox := 'Score: ' + tox;
  SetFillStyle(1, Black);
  Bar(470, 145, 600, 215);
  SetColor(White);
  SetTextStyle(6, 0, 2);
  OutTextXY(470, 145, tox);
end;

{<<<<<<<<<<<<<<<SHARQERY JNJELU PROCEDURE>>>>>>>>>>>>>>>>>>>}

function LineDel: boolean;
var
  i, j: integer;
begin

  pop := 0;
{<<<<<--------UXXADZIQ SHARQERI JNJUM--------->>>>>}
  Linedel := true;
  for i := 0 to 8 do
  begin
    colldp := 0;
    bufcol := 0;
    for j := 0 to 8 do
    begin
      if (t[i, j]) and (bufcol = elementcolor[i, j])
        then
        colldp := colldp + 1
      else
        if t[i, j] then
        begin
          colldp := 0;
          bufcol := elementcolor[i, j];
        end else
        begin
          bufcol := 0; colldp := 0;
        end;
      if colldp >= 4 then
      begin
        scorecount;
        for uj := j - colldp to j do
        begin
          GetImage(1, 1, 35, 35, p^);
          t[i, uj] := false; ui := i;
          unmatrix;
          PutImage(popx, popy, p^, 0)
        end;
        pop := pop + 1;
      end;
      if pop <> 0 then Linedel := true else Linedel := false;
    end;
    scorecount;
  end;

{<<<<---------HORIZONAKAN SHARQERI JNJUM--------->>>>>}
  for j := 0 to 8 do
  begin
    colldp := 0;
    bufcol := 0;
    for i := 0 to 8 do
    begin
      if (t[i, j]) and (bufcol = elementcolor[i, j])
        then
      begin
        colldp := colldp + 1
      end
      else
        if t[i, j] then
        begin
          colldp := 0;
          bufcol := elementcolor[i, j];
        end else
        begin
          bufcol := 0; colldp := 0;
        end;
      if colldp >= 4 then
      begin
        scorecount;
        for ui := i - colldp to i do
        begin
          GetImage(1, 1, 35, 35, p^);
          t[ui, j] := false; uj := j;
          unmatrix;
          PutImage(popx, popy, p^, 0);
        end;
        pop := pop + 1;
      end;
      if pop <> 0 then Linedel := true else Linedel := false;
    end;
  end;
  scorecount;
end;

{<<<<<<<<<<<<<<<<<<<<Way checking algorithm>>>>>>>>>>>>>>}

function Check: Boolean;
begin
  l := 1; l1 := 0;
  for ci := 0 to 8 do
    for cj := 0 to 8 do
      if t[ci, cj] then cmat[ci, cj] := -1 else cmat[ci, cj] := 0;
  cmat[bufi, bufj] := -2;
  cmat[i, j] := -3;
  if (bufi > 0) and (cmat[bufi - 1, bufj] = 0) then cmat[bufi - 1, bufj] := l;
  if (bufj > 0) and (cmat[bufi, bufj - 1] = 0) then cmat[bufi, bufj - 1] := l;
  if (bufi < 8) and (cmat[bufi + 1, bufj] = 0) then cmat[bufi + 1, bufj] := l;
  if (bufj < 8) and (cmat[bufi, bufj + 1] = 0) then cmat[bufi, bufj + 1] := l;
  repeat

    for ci := 0 to 8 do
    begin
      for cj := 0 to 8 do
      begin
        if cmat[ci, cj] = l then
        begin
          if (ci > 0) and ((cmat[ci - 1, cj] = 0) or (cmat[ci - 1, cj] = -3)) then cmat[ci - 1, cj] := l + 1;
          if (cj > 0) and ((cmat[ci, cj - 1] = 0) or (cmat[ci, cj - 1] = -3)) then cmat[ci, cj - 1] := l + 1;
          if (ci < 8) and ((cmat[ci + 1, cj] = 0) or (cmat[ci + 1, cj] = -3)) then cmat[ci + 1, cj] := l + 1;
          if (cj < 8) and ((cmat[ci, cj + 1] = 0) or (cmat[ci, cj + 1] = -3)) then cmat[ci, cj + 1] := l + 1;
        end;
      end;

    end;
    inc(l);
    inc(l1);
  until (cmat[i, j] <> -3) or (l1 >= 81);
  check := (cmat[i, j] <> -3) or ((bufi = i) and ((j = bufj + 1) or (j = bufj - 1))) or ((bufj = j) and ((i = bufi + 1) or (i = bufi - 1)));
end;

{<<<<<<<<<<<<<<<<<<<<<<GAME OVER SCREEN>>>>>>>>>>>>>>>>>>>>}

function GameOver: Boolean;
var
  i, j: integer;
begin
  l2 := 0;
  for i := 0 to 8 do
    for j := 0 to 8 do
      if t[i, j] then inc(l2);
  if l2 = 81 then
  begin
    ClearDevice;
    SetTextStyle(6, 0, 6);
    SetColor(12);
    SetColor(14);
    SetTextStyle(3, 0, 9);
    OutTextXY(65, 149, 'G');
    SetColor(9);
    OutTextXY(125, 149, 'A');
    SetColor(12);
    OutTextXY(185, 149, 'M');
    SetColor(10);
    OutTextXY(245, 149, 'E');
    SetColor(9);
    OutTextXY(325, 149, 'O');
    SetColor(13);
    OutTextXY(385, 149, 'V');
    SetColor(14);
    OutTextXY(445, 149, 'E');
    SetColor(10);
    OutTextXY(505, 149, 'R');
    SetColor(8);
    SetTextStyle(6, 0, 3);
    OutTextXY(230, 289, '<Press any key>');
    ReadKey;

    GameOver := true;
  end else GameOver := false;
end;

{<<<<<<<<<<<<<<SHARIKNERY TEXAPOXELU PROCEDURE>>>>>>>>>>}

procedure Move;
begin
  x := 55;
  y := 55;
  i := 1;
  j := 1;
  size := ImageSize(50, 50, 90, 90);
  GetMem(P, size);
  repeat
    c := ReadKey;
    PutImage(x, y, p^, 0);
    case c of
      #75: if x > 96 then x := x - 42;
      #77: if x < 365 then x := x + 42;
      #72: if y > 96 then y := y - 42;
      #80: if y < 365 then y := y + 42;
      #13:
        begin
          matrix;
          if (ButtonHit = 0) and (t[i, j]) then
          begin
            Bufx := x;
            Bufy := y;
            ButtonHit := 1;
            Bufi := i;
            Bufj := j;
            BufCol := ElementColor[i, j];
            SetColor(4);
            SetLineStyle(0, 0, 3);
            Rectangle(ball[bufi] - 18, ball[bufj] - 18, ball[bufi] + 18, ball[bufj] + 18);
          end;
          if (ButtonHit = 1) and
            (not t[i, j]) and (check) then
          begin
            SetColor(Black);
            Rectangle(ball[bufi] - 18, ball[bufj] - 18, ball[bufi] + 18, ball[bufj] + 18);
            GetImage(1, 1, 35, 35, p^);
            PutImage(bufx, bufy, p^, 0);
            t[Bufi, Bufj] := false;
            ElementColor[Bufi, Bufj] := 0;
            ButtonHit := 0;
            SetColor(BufCol);
            SetFillStyle(1, BufCol);
            FillEllipse(Ball[i], Ball[j], 10, 10);
            T[i, j] := True;
            ElementColor[i, j] := BufCol;
            k := 0;
            if (not Linedel) then
              repeat
                RandomBalls;
                k := k + 1;
              until k = 3;
            Linedel;
          end;
        end;
      #44: if buttonhit = 1 then
        begin
          SetColor(Black);
          Rectangle(ball[bufi] - 18, ball[bufj] - 18, ball[bufi] + 18, ball[bufj] + 18);
          buttonhit := 0;
        end;
    end;
    GetImage(x, y, x + 7, y + 7, p^);
    SetColor(7);
    SetTextStyle(0, 0, 1);
    OutTextXY(x, y, '>');
  until (c = #27) or (GameOver);
end;

function PLAY: boolean;
begin
  ClearDevice;
  randomize;
  SetColor(15);
  Setka;
  if (not Linedel) then
    repeat
      RandomBalls;
      k := k + 1;
    until k = 3;
  Linedel;
  Move;
  play := true;
end;

procedure RULES;
begin
  ClearDevice;
  repeat
    SetColor(12);
    SetTextStyle(3, 0, 8);
    OutTextXY(181, 10, 'RULES');
    SetTextStyle(6, 0, 3);
    SetColor(7);
    OutTextXY(90, 160, ' This strategy game will make you think');
    OutTextXY(90, 180, 'and concentrate for hours if you accept');
    OutTextXY(90, 200, ' the challenge. The game will randomly');
    OutTextXY(90, 220, 'place three color balls on the board at');
    OutTextXY(90, 240, ' every round, you have to strategically');
    OutTextXY(90, 260, 'select one ball and move it to the most');
    OutTextXY(90, 280, '         convenient location');
    SetColor(14);
    OutTextXY(130, 350, '<Press enter to go back to menu>');
    ch := ReadKey;
  until ch = #13;
  ClearDevice;
  splash(z);
  case z of
    0: PLAY;
    1: RULES;
    2: exit;
  end;
end;

{<<<<<<<<<<<<<<<<<<<<<<<<MAIN PROGRAM>>>>>>>>>>>>>>>>>}
var
  gd, gm: smallint;
begin
  gd := {VESA} VGA;
  gm := {m640x480x16m} VGAHi;
  InitGraph(gd, gm, '');
  splash(z);
  case z of
    0: PLAY;
    1: RULES;
    2: exit;
  end;
end.
