
program MsPacMan;

{ MsPacman game, (C) 1997 by George M. Tzoumas }

{ This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  Use this software AT YOUR OWN RISK. }

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph,
  ptcCrt,
  SysUtils,
  Load,
  Log;

const
  Left   = 1;
  Right  = 2;
  Up     = 3;
  Down   = 4;
  Blinky = 1;
  Inky   = 2;
  Pinky  = 3;
  Sue    = 4;
  Normal = 0;
  Blind  = 1;
  Dead   = 2;
  mzMaxX = 20;
  mzMaxY = 22;
  Chase: array[1..4, 1..2] of shortint = ((0, 0), (0, 0), (0, 0), (0, 0));
  GBonus: array[1..4] of integer = (200, 400, 800, 1600);
  ActStr: array[1..3] of string[9] = ('THEY MEET', 'THE CHASE', 'JUNIOR');

type
  PFrames = ^TFrames;
  TFrames = array[1..4, 0..1] of pointer;
  PBlindFrames = ^TBlindFrames;
  TBlindFrames = array[0..1, 0..1] of pointer;
  P4Frames = ^T4Frames;
  T4Frames = array[1..4] of pointer;
  PMazeData = ^TMazeData;
  TMazeData = array[0..mzMaxX, 0..mzMaxY] of byte;
  TLevelImages = array[0..18] of pointer;
  ByteSet = set of byte;

  PLevel = ^TLevel;
  TLevel = object
    Data: TMazeData;
    No: byte;
    X, Y, Color: integer;
    OX, OY, HX, HY, Height: byte; { Origin of pacman, home of ghosts}
    DrawMode: byte;
    Dots: integer;
    WallColor, FrameColor: shortint;
  { For ghosts }
    cblind: word; { Blind counter init }
    cblindb: word; { Where blinking starts }
    cblindd: word; { Last of blinking }
    procedure Init(ANo, AHeight, AOX, AOY, AHX, AHY: byte; ADots: integer; AWallColor, AFrameColor: shortint; AMazeData: PMazeData);
    procedure DrawAt(Xp, Yp: byte);
    procedure Draw;
    function XFix(p: byte): integer;
    function YFix(p: byte): integer;
    function XPos(AX: integer): byte;
    function YPos(AY: integer): byte;
    function Cell(AX, AY: integer; AOutside: byte = 0): byte;
  end;

  TGhost = object
    Frames: PFrames;
    BlindFrames: PBlindFrames;
    DeadFrames: P4Frames;
    Level: PLevel;
    Name: byte;
    cwf: byte; { Current walking frame }
    wd: byte; { Walking direction }
    X, Y: integer;
    State: byte;
    cb: word; { Blind counter }
    DrawMode: byte;
    Obstacles: ByteSet;
    procedure Init(AFrames: PFrames; AName: byte; ALevel: PLevel);
    procedure Draw;
    procedure UnDraw;
    procedure Move;
    procedure GoHome;
    function SetDir(ADir: byte): boolean;
    function WhatIs(ADir: byte): byte;
    function ExactX: byte;
    function ExactY: byte;
    procedure MakeBlind;
  end;

  TPacMan = object
    Frames: PFrames;
    Lives: byte;
    Level: PLevel;
    Score: Longint;
    cwf, wd: byte;
    X, Y: integer;
    Stopped: boolean;
    Invisible: boolean;
    DrawMode: byte;
    Obstacles: ByteSet;
    GotLife: boolean;
    procedure Init(AFrames: PFrames; ALevel: PLevel);
    procedure Draw;
    procedure UnDraw;
    procedure Move;
    procedure GoHome;
    function SetDir(ADir: byte): boolean;
    function WhatIs(ADir: byte): byte;
    function ExactX: byte;
    function ExactY: byte;
  end;

var
  GhostFrames: array[1..4] of TFrames;
  DefaultBlindFrames: TBlindFrames;
  DefaultDeadFrames: T4Frames;
  LevelImages: TLevelImages;
  GBonusImages: T4Frames;
  ActImages: array[1..5] of pointer;
  Mazes: array[1..3] of PMazeData;
  Ghosts: array[1..4] of TGhost;
  MsPacFrames, PacFrames: TFrames;
  MsPac: TPacMan;
  LastMove: byte;
  CurLevel: PLevel;
  GBonusC: byte;
  Closing: boolean;
  SkipLevel: boolean;

procedure ClearKeyboard;
var
  c: char;
begin
  while KeyPressed do
  begin
    c := ReadKey;
    if c = #0 then
      ReadKey
    else if c = #3 then
      Closing := TRUE;
  end;
end;

procedure LoadImages;
const
  CImagesDir = 'images' + DirectorySeparator;
  CMazesDir = 'mazes' + DirectorySeparator;
begin
{ Load Ghosts }
{ Load Blinky }
  BLoad(CImagesDir + 'blinkyl1', GhostFrames[Blinky][Left, 0]);
  BLoad(CImagesDir + 'blinkyl2', GhostFrames[Blinky][Left, 1]);
  BLoad(CImagesDir + 'blinkyr1', GhostFrames[Blinky][Right, 0]);
  BLoad(CImagesDir + 'blinkyr2', GhostFrames[Blinky][Right, 1]);
  BLoad(CImagesDir + 'blinkyu1', GhostFrames[Blinky][Up, 0]);
  BLoad(CImagesDir + 'blinkyu2', GhostFrames[Blinky][Up, 1]);
  BLoad(CImagesDir + 'blinkyd1', GhostFrames[Blinky][Down, 0]);
  BLoad(CImagesDir + 'blinkyd2', GhostFrames[Blinky][Down, 1]);
{ Load Pinky }
  BLoad(CImagesDir + 'pinkyl1', GhostFrames[Pinky][Left, 0]);
  BLoad(CImagesDir + 'pinkyl2', GhostFrames[Pinky][Left, 1]);
  BLoad(CImagesDir + 'pinkyr1', GhostFrames[Pinky][Right, 0]);
  BLoad(CImagesDir + 'pinkyr2', GhostFrames[Pinky][Right, 1]);
  BLoad(CImagesDir + 'pinkyu1', GhostFrames[Pinky][Up, 0]);
  BLoad(CImagesDir + 'pinkyu2', GhostFrames[Pinky][Up, 1]);
  BLoad(CImagesDir + 'pinkyd1', GhostFrames[Pinky][Down, 0]);
  BLoad(CImagesDir + 'pinkyd2', GhostFrames[Pinky][Down, 1]);
{ Load Inky }
  BLoad(CImagesDir + 'inkyl1', GhostFrames[Inky][Left, 0]);
  BLoad(CImagesDir + 'inkyl2', GhostFrames[Inky][Left, 1]);
  BLoad(CImagesDir + 'inkyr1', GhostFrames[Inky][Right, 0]);
  BLoad(CImagesDir + 'inkyr2', GhostFrames[Inky][Right, 1]);
  BLoad(CImagesDir + 'inkyu1', GhostFrames[Inky][Up, 0]);
  BLoad(CImagesDir + 'inkyu2', GhostFrames[Inky][Up, 1]);
  BLoad(CImagesDir + 'inkyd1', GhostFrames[Inky][Down, 0]);
  BLoad(CImagesDir + 'inkyd2', GhostFrames[Inky][Down, 1]);
{ Load Sue }
  BLoad(CImagesDir + 'suel1', GhostFrames[Sue][Left, 0]);
  BLoad(CImagesDir + 'suel2', GhostFrames[Sue][Left, 1]);
  BLoad(CImagesDir + 'suer1', GhostFrames[Sue][Right, 0]);
  BLoad(CImagesDir + 'suer2', GhostFrames[Sue][Right, 1]);
  BLoad(CImagesDir + 'sueu1', GhostFrames[Sue][Up, 0]);
  BLoad(CImagesDir + 'sueu2', GhostFrames[Sue][Up, 1]);
  BLoad(CImagesDir + 'sued1', GhostFrames[Sue][Down, 0]);
  BLoad(CImagesDir + 'sued2', GhostFrames[Sue][Down, 1]);
{ Load blind state }
  BLoad(CImagesDir + 'blind11', DefaultBlindFrames[0][0]);
  BLoad(CImagesDir + 'blind12', DefaultBlindFrames[0][1]);
  BLoad(CImagesDir + 'blind21', DefaultBlindFrames[1][0]);
  BLoad(CImagesDir + 'blind22', DefaultBlindFrames[1][1]);
{ Load dead state }
  BLoad(CImagesDir + 'deadl', DefaultDeadFrames[1]);
  BLoad(CImagesDir + 'deadr', DefaultDeadFrames[2]);
  BLoad(CImagesDir + 'deadu', DefaultDeadFrames[3]);
  BLoad(CImagesDir + 'deadd', DefaultDeadFrames[4]);
{ Load MsPacman }
  BLoad(CImagesDir + 'mspacl1', MsPacFrames[Left][0]);
  BLoad(CImagesDir + 'mspaclf', MsPacFrames[Left][1]);
  BLoad(CImagesDir + 'mspacr1', MsPacFrames[Right][0]);
  BLoad(CImagesDir + 'mspacrf', MsPacFrames[Right][1]);
  BLoad(CImagesDir + 'mspacu1', MsPacFrames[Up][0]);
  BLoad(CImagesDir + 'mspacuf', MsPacFrames[Up][1]);
  BLoad(CImagesDir + 'mspacd1', MsPacFrames[Down][0]);
  BLoad(CImagesDir + 'mspacdf', MsPacFrames[Down][1]);
{ Load Pacman }
  BLoad(CImagesDir + 'pacl', PacFrames[Left][0]);
  BLoad(CImagesDir + 'pacf', PacFrames[Left][1]);
  BLoad(CImagesDir + 'pacr', PacFrames[Right][0]);
  BLoad(CImagesDir + 'pacu', PacFrames[Up][0]);
  BLoad(CImagesDir + 'pacd', PacFrames[Down][0]);
  PacFrames[Right][1] := PacFrames[Left][1];
  PacFrames[Up][1] := PacFrames[Left][1];
  PacFrames[Down][1] := PacFrames[Left][1];
{ Load Level Images }
  BLoad(CImagesDir + 'wblank', LevelImages[0]);
  BLoad(CImagesDir + 'wfull', LevelImages[1]);
  BLoad(CImagesDir + 'wup', LevelImages[2]);
  BLoad(CImagesDir + 'wdown', LevelImages[3]);
  BLoad(CImagesDir + 'wleft', LevelImages[4]);
  BLoad(CImagesDir + 'wright', LevelImages[5]);
  BLoad(CImagesDir + 'whoriz', LevelImages[6]);
  BLoad(CImagesDir + 'wvert', LevelImages[7]);
  BLoad(CImagesDir + 'wupl', LevelImages[8]);
  BLoad(CImagesDir + 'wupr', LevelImages[9]);
  BLoad(CImagesDir + 'wdownl', LevelImages[10]);
  BLoad(CImagesDir + 'wdownr', LevelImages[11]);
  BLoad(CImagesDir + 'wupt', LevelImages[12]);
  BLoad(CImagesDir + 'wdownt', LevelImages[13]);
  BLoad(CImagesDir + 'wleftt', LevelImages[14]);
  BLoad(CImagesDir + 'wrightt', LevelImages[15]);
  BLoad(CImagesDir + 'ghdoor', LevelImages[16]);
  BLoad(CImagesDir + 'msdot', LevelImages[17]);
  BLoad(CImagesDir + 'mspill', LevelImages[18]);
{ Load Mazes }
  BLoad(CMazesDir + 'pclv1', Mazes[1], FALSE);
  BLoad(CMazesDir + 'pclv2', Mazes[2], FALSE);
  BLoad(CMazesDir + 'pclv3', Mazes[3], FALSE);
{ Load Bonus }
  BLoad(CImagesDir + '200', GBonusImages[1]);
  BLoad(CImagesDir + '400', GBonusImages[2]);
  BLoad(CImagesDir + '800', GBonusImages[3]);
  BLoad(CImagesDir + '1600', GBonusImages[4]);
{ Load Act images }
  BLoad(CImagesDir + 'act1', ActImages[1]);
  BLoad(CImagesDir + 'act2', ActImages[2]);
  BLoad(CImagesDir + 'act3', ActImages[3]);
  BLoad(CImagesDir + 'actc', ActImages[4]);
  BLoad(CImagesDir + 'acto', ActImages[5]);
end;

function OppDir(ADir: byte): byte;
begin
  case ADir of
    Left: result := Right;
    Right: result := Left;
    Up: result := Down;
    Down: result := Up;
  end;
end;

procedure ShowMessage(s: string; MS: word);
var
  x, y: integer;
begin
  x := CurLevel^.XFix(CurLevel^.HX + 1) - 8 - TextWidth(s) shr 1;
  y := CurLevel^.YFix(CurLevel^.HY + 2);
  SetColor(Yellow);
  OutTextXY(x, y, s);
  Delay(MS);
  SetColor(Black);
  OutTextXY(x, y, s);
  SetColor(White);
end;

procedure ShowScore;
var
  s: string;
begin
  Str(MsPac.Score:7, s);
  Bar(CurLevel^.X, CurLevel^.Y - 16, CurLevel^.X + TextWidth(s), CurLevel^.Y);
  OutTextXY(CurLevel^.X, CurLevel^.Y - 16, s);
end;

procedure ShowLives;
var
  i: byte;
  y: integer;
begin
  LogLn('ShowLives');
  y := CurLevel^.Y + Succ(CurLevel^.Height) shl 4;
  i := 0;
  while i < MsPac.Lives do
  begin
    PutImage(CurLevel^.X + i shl 4, y, MsPacFrames[Right, 0]^, CopyPut);
    Inc(i);
  end;
  PutImage(CurLevel^.X + i shl 4, y, LevelImages[0]^, CopyPut);
end;

procedure ScoreUp(By: integer);
begin
  LogLn(Format('ScoreUp(%d)', [By]));
  Inc(MsPac.Score, By);
  ShowScore;
  if MsPac.GotLife then
    Exit;
  if MsPac.Score >= 20000 then
  begin
    Inc(MsPac.Lives);
    MsPac.GotLife := TRUE;
    ShowLives;
  end;
end;

procedure TLevel.Init(ANo, AHeight, AOX, AOY, AHX, AHY: byte; ADots: integer; AWallColor, AFrameColor: shortint; AMazeData: PMazeData);
begin
  LogLn(Format('TLevel.Init(%d,...)', [ANo]));
  No := ANo;
  Data := AMazeData^;
  Color := 8;
  X := 640 shr 1 - mzMaxX shl 3;
  Y := 480 shr 1 - mzMaxY shl 3;
  OX := AOX;
  OY := AOY;
  HX := AHX;
  HY := AHY;
  Height := AHeight;
  DrawMode := OrPut;
  Dots := ADots;
  WallColor := AWallColor;
  FrameColor := AFrameColor;
  cblind := 512; { Blind counter init }
  cblindb := 214; { Where blinking starts }
  cblindd := 48; { Last of blinking }
end;

procedure TLevel.DrawAt(Xp, Yp: byte);
begin
  PutImage(X + Xp shl 4, Y + Yp shl 4, LevelImages[Data[Xp, Yp]]^, DrawMode);
end;

procedure TLevel.Draw;
var
  i, j: byte;
begin
  for j := 0 to mzMaxY do
    for i := 0 to mzMaxX do
      DrawAt(i, j);
end;

function TLevel.XFix(p: byte): integer;
begin
  XFix := X + p shl 4;
end;

function TLevel.YFix(p: byte): integer;
begin
  YFix := Y + p shl 4;
end;

function TLevel.XPos(AX: integer): byte;
begin
  XPos := (AX - X) shr 4;
end;

function TLevel.YPos(AY: integer): byte;
begin
  YPos := (AY - Y) shr 4;
end;

function TLevel.Cell(AX, AY: integer; AOutside: byte): byte;
begin
  if (AX >= 0) and (AX <= mzMaxX) and (AY >= 0) and (AY <= mzMaxY) then
    Cell := Data[AX, AY]
  else
    Cell := AOutside;
end;

procedure TGhost.Init(AFrames: PFrames; AName: byte; ALevel: PLevel);
begin
  LogLn(Format('TGhost.Init(%p,%d,%p)', [AFrames, AName, ALevel]));
  Level := ALevel;
  if Level^.No = 1 then
  begin
    Frames := AFrames;
    BlindFrames := @DefaultBlindFrames;
    DeadFrames := @DefaultDeadFrames;
    Name := AName;
    DrawMode := CopyPut;
    Obstacles := [2..15];
  end;
  GoHome;
end;

procedure TGhost.Draw;
var
  ax, ay: byte;
begin
  ax := Level^.XPos(X);
  ay := Level^.YPos(Y);
  case State of
    Normal: PutImage(X, Y, Frames^[wd][byte(cwf mod 24 >= 12)]^, DrawMode);
    Blind: PutImage(X, Y, BlindFrames^[byte((cb < Level^.cblindb) and (cb mod Level^.cblindd > Level^.cblindd shr 1))][byte(cwf mod 24 >= 12)]^, DrawMode);
    Dead: PutImage(X, Y, DeadFrames^[wd]^, DrawMode);
  end;
  if not ((ExactX < 5) and (ExactY < 5)) then
    case wd of
      Left: Level^.DrawAt(ax + 1, ay);
      Right: Level^.DrawAt(ax, ay);
      Up: Level^.DrawAt(ax, ay + 1);
      Down: Level^.DrawAt(ax, ay);
    end;
end;

procedure TGhost.UnDraw;
var
  ax, ay: byte;
begin
  LogLn('TGhost.UnDraw');
  ax := Level^.XPos(X);
  ay := Level^.YPos(Y);
  Draw; DrawMode := XorPut;
  Draw; DrawMode := CopyPut;
  case wd of
    Left, Right:
      begin
        Level^.DrawAt(ax + 1, ay);
        Level^.DrawAt(ax, ay);
      end;
    Up, Down:
      begin
        Level^.DrawAt(ax, ay + 1);
        Level^.DrawAt(ax, ay);
      end;
  end;
end;

procedure TGhost.Move;
begin
  if (wd = Right) and (Level^.XPos(X) = 18) then
  begin
    PutImage(X, Y, LevelImages[0]^, CopyPut);
    X := Level^.X;
    Draw;
  end;
  if (wd = Left) and (X = Level^.X) then
  begin
    PutImage(X, Y, LevelImages[0]^, CopyPut);
    X := Level^.X + 18 * 16;
    Draw;
  end;
  case wd of
    Left: Dec(X);
    Right: Inc(X);
    Up: Dec(Y);
    Down: Inc(Y);
  end;
  if cwf < High(byte) then
    Inc(cwf)
  else
    cwf := 0;
  if State = Blind then
  begin
    if cb > 0 then
      Dec(cb)
    else
      cb := High(word);
    if cb = 0 then
      State := Normal;
  end;
end;

procedure TGhost.GoHome;
begin
  LogLn('TGhost.GoHome');
  case Name of
    Blinky, Pinky: X := Level^.XFix(Level^.HX);
    Inky: X := Level^.XFix(Level^.HX - 1);
    Sue: X := Level^.XFix(Level^.HX + 1);
  end;
  case Name of
    Blinky: Y := Level^.YFix(Level^.HY - 1);
    Inky..Sue: Y := Level^.YFix(Level^.HY);
  end;
  case Name of
    Blinky, Pinky: wd := Up;
    Inky: wd := Right;
    Sue: wd := Left;
  end;
  cwf := 0;
  State := Normal;
end;

function TGhost.SetDir(ADir: byte): boolean;
var
  s: ByteSet;
begin
  SetDir := FALSE;
  if (ADir = Down) and (State <> Dead) then
    s := [16]
  else
    s := [];
  if (
    ((ADir in [Left, Right]) and (ExactY = 0)) or
    ((ADir in [Up, Down]) and (ExactX = 0))
    ) and not (WhatIs(ADir) in (Obstacles + s)) then
  begin
    wd := ADir;
    SetDir := TRUE;
  end;
end;

function TGhost.WhatIs(ADir: byte): byte;
begin
  WhatIs := 0;
  case ADir of
    Left: if Level^.XPos(X) - 1 >= 0 then WhatIs := Level^.Data[Level^.XPos(X) - 1, Level^.YPos(Y)];
    Right: if Level^.XPos(X) + 1 <= mzMaxX then WhatIs := Level^.Data[Level^.XPos(X) + 1, Level^.YPos(Y)];
    Up: if Level^.YPos(Y) - 1 >= 0 then WhatIs := Level^.Data[Level^.XPos(X), Level^.YPos(Y) - 1];
    Down: if Level^.YPos(Y) + 1 <= mzMaxY then WhatIs := Level^.Data[Level^.XPos(X), Level^.YPos(Y) + 1];
  end;
end;

function TGhost.ExactX: byte;
begin
  ExactX := (X - Level^.X) mod 16;
end;

function TGhost.ExactY: byte;
begin
  ExactY := (Y - Level^.Y) mod 16;
end;

procedure TGhost.MakeBlind;
begin
  LogLn('MakeBlind');
  if State = Dead then
    Exit;
  if Level^.cblind = 0 then
    Exit;
  if (State = Normal) and not (WhatIs(OppDir(wd)) in Obstacles) then
    wd := OppDir(wd);
  State := Blind;
  cb := Level^.cblind;
end;

procedure TPacMan.Init(AFrames: PFrames; ALevel: PLevel);
begin
  LogLn(Format('TPacMan.Init(%p,%p)', [AFrames, ALevel]));
  Level := ALevel;
  if Level^.No = 1 then
  begin
    Frames := AFrames;
    Lives := 4;
    Score := 0;
    GotLife := FALSE;
    DrawMode := CopyPut;
    Obstacles := [2..16];
    Invisible := FALSE;
  end;
  GoHome;
end;

procedure TPacMan.Draw;
begin
  PutImage(X, Y, Frames^[wd][byte(cwf mod 6 >= 3)]^, DrawMode)
end;

procedure TPacMan.UnDraw;
begin
  Draw; DrawMode := XorPut;
  Draw; DrawMode := CopyPut;
end;

procedure TPacMan.Move;
var
  OX, OY: integer;
  i: byte;
begin
  if Stopped then
    Exit;
  if (wd = Right) and (Level^.XPos(X) = 18) then
  begin
    PutImage(X, Y, LevelImages[0]^, CopyPut);
    X := Level^.X;
    Draw;
  end;
  if (wd = Left) and (X = Level^.X) then
  begin
    PutImage(X, Y, LevelImages[0]^, CopyPut);
    X := Level^.X + 18 * 16;
    Draw;
  end;
  case wd of
    Left, Right: if (WhatIs(wd) in Obstacles) and (ExactX = 0) then Stopped := TRUE;
    Up, Down: if (WhatIs(wd) in Obstacles) and (ExactY = 0) then Stopped := TRUE;
  end;
  if Stopped then
    Exit;
  case wd of
    Left: Dec(X);
    Right: Inc(X);
    Up: Dec(Y);
    Down: Inc(Y);
  end;
  if cwf < High(byte) then
    Inc(cwf)
  else
    cwf := 0;
  OX := Level^.XPos(X);
  OY := Level^.YPos(Y);
  case wd of
    Right: Inc(OX, byte(not (ExactX = 0)));
    Down: Inc(OY, byte(not (ExactY = 0)));
  end;
  if Level^.Data[OX, OY] <> 0 then
  begin
    if Level^.Data[OX, OY] = 18 then
    begin
      for i := 1 to 4 do
        Ghosts[i].MakeBlind;
      GBonusC := 0;
      ScoreUp(50);
    end;
    if Level^.Data[OX, OY] = 17 then
      ScoreUp(10);
    Level^.Data[OX, OY] := 0;
    Level^.DrawMode := CopyPut;
    Level^.DrawAt(OX, OY);
    Level^.DrawMode := OrPut;
    Dec(Level^.Dots);
  end;
end;

procedure TPacMan.GoHome;
begin
  X := Level^.XFix(Level^.OX);
  Y := Level^.YFix(Level^.OY);
  wd := Left;
  cwf := 0;
  Stopped := FALSE;
end;

function TPacMan.SetDir(ADir: byte): boolean;
begin
  SetDir := FALSE;
  if (
    ((ADir in [Left, Right]) and (ExactY = 0)) or
    ((ADir in [Up, Down]) and (ExactX = 0))
    ) and not (WhatIs(ADir) in Obstacles) then
  begin
    wd := ADir;
    Stopped := FALSE;
    SetDir := TRUE;
  end;
end;

function TPacMan.WhatIs(ADir: byte): byte;
begin
  case ADir of
    Left: WhatIs := Level^.Cell(Level^.XPos(X) - 1, Level^.YPos(Y));
    Right: WhatIs := Level^.Cell(Level^.XPos(X) + 1, Level^.YPos(Y));
    Up: WhatIs := Level^.Cell(Level^.XPos(X), Level^.YPos(Y) - 1);
    Down: WhatIs := Level^.Cell(Level^.XPos(X), Level^.YPos(Y) + 1);
  end;
end;

function TPacMan.ExactX: byte;
begin
  ExactX := (X - Level^.X) mod 16;
end;

function TPacMan.ExactY: byte;
begin
  ExactY := (Y - Level^.Y) mod 16;
end;

var
  i: word;
  ch: char;
  Levels: array[1..6] of TLevel;
  t: word;
  pal: shortint;
  om, l: byte;

procedure EatGhost(i: byte);
begin
  MsPac.UnDraw;
  Inc(GBonusC);
  PutImage(Ghosts[i].X, Ghosts[i].Y, GBonusImages[GBonusC]^, CopyPut);
  ScoreUp(GBonus[GBonusC]);
  Delay(500);
  PutImage(Ghosts[i].X, Ghosts[i].Y, GBonusImages[GBonusC]^, XorPut);
  if GBonusC = 4 then GBonusC := 0;
  Ghosts[i].State := Dead;
  Ghosts[i].Draw;
  case Ghosts[i].wd of
    Left, Right: if Odd(Ghosts[i].X) then Ghosts[i].Move;
    Up, Down: if Odd(Ghosts[i].Y) then Ghosts[i].Move;
  end;
  Ghosts[i].Draw;
  MsPac.Draw;
end;

procedure LooseLife;
const
  dd: array[1..4] of byte = (Down, Up, Left, Right);
var
  i: byte;
begin
  if MsPac.Invisible or (CurLevel^.Dots = 0) then Exit;
  Delay(700);
  for i := Blinky to Sue do Ghosts[i].UnDraw;
  MsPac.cwf := 0;
  MsPac.Draw;
  Delay(500);
  for i := 1 to 4 do
  begin
    MsPac.wd := dd[MsPac.wd];
    MsPac.Draw;
    Delay(200);
    MsPac.UnDraw;
  end;
  if MsPac.Lives = 0 then
  begin
    ShowMessage('GAME OVER', 3000);
    CloseGraph;
    Halt;
  end;
  Dec(MsPac.Lives);
  ShowLives;
  for i := Blinky to Sue do
    Ghosts[i].GoHome;
  MsPac.GoHome;
  for i := Blinky to Sue do
    Ghosts[i].Draw;
  MsPac.Draw;
  ClearKeyboard;
  ShowMessage('READY', 1000);
end;

procedure MoveRest;
var
  i, j, p, ox, oy, gx, gy: byte;
  l: string;
  v: ByteSet;
begin
  oy := MsPac.Level^.YPos(MsPac.Y);
  ox := MsPac.Level^.XPos(MsPac.X);
  i := oy;
  j := ox;

  Chase[1, 1] := j - 1;
  Chase[1, 2] := i;

  i := oy;
  j := ox;
  if MsPac.wd = Right then
    while (MsPac.Level^.Cell(j + 1, i, 1) = 0)
      and (MsPac.Level^.Cell(j + 1, i - 1) <> 0)
      and (MsPac.Level^.Cell(j + 1, i + 1) <> 0) do
      Inc(j)
  else
    while (MsPac.Level^.Cell(j - 1, i, 1) = 0)
      and (MsPac.Level^.Cell(j - 1, i - 1) <> 0)
      and (MsPac.Level^.Cell(j - 1, i + 1) <> 0) do
      Dec(j);

  Chase[2, 1] := j;
  Chase[2, 2] := i;

  i := oy;
  j := ox;
  while (MsPac.Level^.Cell(j, i - 1, 1) = 0)
    and (MsPac.Level^.Cell(j - 1, i - 1) <> 0)
    and (MsPac.Level^.Cell(j + 1, i - 1) <> 0) do
    Dec(i);
  Chase[3, 1] := j;
  Chase[3, 2] := i - 1;

  i := oy;
  j := ox;

  if Random(2) = 1 then Chase[4, 1] := j + 2 else Chase[4, 1] := j - 2;
  if Random(2) = 1 then Chase[4, 2] := i + 1 else Chase[4, 2] := i - 1;

  for i := Blinky to Sue do with Ghosts[i] do
    begin
      gx := Level^.XPos(X);
      gy := Level^.YPos(Y);
      if (State = Dead) and (gx = Level^.HX) and (gy = Level^.HY) then State := Normal;
      case wd of
        Left, Right: if (MsPac.ExactY = 0) and (ExactY = 0) and (gy = oy) and (Abs(X - MsPac.X) <= 10) then
            case State of
              Normal: LooseLife;
              Blind: EatGhost(i);
            end;
        Up, Down: if (MsPac.ExactX = 0) and (ExactX = 0) and (gx = ox) and (Abs(Y - MsPac.Y) <= 10) then
            case State of
              Normal: LooseLife;
              Blind: EatGhost(i);
            end;
      end;
      if ((wd in [Left, Right]) and (ExactX = 0)) or ((wd in [Up, Down]) and (ExactY = 0)) then
      begin
        j := 0;
        l := '';
        v := [];
        repeat
          Inc(j);
          if not (WhatIs(j) in Obstacles) then
          begin
            l := l + Chr(j);
            Include(v, j);
          end;
        until (j = 4);
        if (Length(l) > 1) then
        begin
          Delete(l, Pos(Chr(OppDir(wd)), l), 1);
          Exclude(v, OppDir(wd));
        end;
        p := byte(l[Random(Length(l)) + 1]);
        case State of
          Normal:
            begin
              if (Chase[i, 1] > gx) and (Right in v) then p := Right;
              if (Chase[i, 1] < gx) and (Left in v) then p := Left;
              if (Chase[i, 2] < gy) and (Up in v) then p := Up;
              if (Chase[i, 2] > gy) and (Down in v) then p := Down;
            end;
          Dead:
            begin
              if (Level^.HX < gx) and (Left in v) then p := Left;
              if (Level^.HX > gx) and (Right in v) then p := Right;
              if (Level^.HY - 2 < gy) and (Up in v) then p := Up;
              if (Level^.HY - 2 > gy) and (Down in v) then p := Down;
              if (Level^.HX = gx) and (Level^.HY - 2 = gy) then p := Down;
            end;
        end;
        SetDir(p);
      end;
    end;
end;

procedure Cheat(ch: char);
begin
  case ch of
    #63:
      ScoreUp(1000);
    #64:
      begin
        Inc(MsPac.Lives);
        ShowLives;
      end;
    #65:
      begin
        for i := 1 to 4 do
          Ghosts[i].MakeBlind;
        GBonusC := 0;
      end;
    #66:
      MsPac.Invisible := not MsPac.Invisible;
    #67:
      SkipLevel := TRUE;
  end;
end;

procedure Act(actno: byte);

  procedure Act1;
  var
    i, x1, x2: integer;
    cwf1, cwf2: byte;
    wd1, wd2: byte;
  begin
    wd1 := Right;
    wd2 := Right;
    cwf1 := 0;
    cwf2 := 0;
    x1 := 640 shr 1 - mzMaxX shl 3;
    x2 := x1 + 32;
    for i := 1 to mzMaxX * 16 do
    begin
      Delay(6);
      if x1 mod 24 = 0 then
      begin
        PutImage(x1, 150, GhostFrames[Inky][wd1][byte(cwf1 mod 24 >= 12)]^, CopyPut);
        Inc(x1);
      end;
      PutImage(x1, 150, GhostFrames[Inky][wd1][byte(cwf1 mod 24 >= 12)]^, CopyPut);
      PutImage(x2, 150, PacFrames[wd2][byte(cwf2 mod 6 >= 3)]^, CopyPut);
      Inc(x1);
      Inc(x2);
      Inc(cwf1);
      Inc(cwf2);
    end;
    ClearDevice;
    Delay(200);

    wd1 := Left;
    wd2 := Left;
    cwf1 := 0;
    cwf2 := 0;
    x2 := 640 shr 1 + mzMaxX shl 3;
    x1 := x2 - 32;
    for i := 1 to mzMaxX * 16 do
    begin
      Delay(6);
      if x1 mod 24 = 0 then
      begin
        PutImage(x2, 250, GhostFrames[Pinky][wd1][byte(cwf1 mod 24 >= 12)]^, CopyPut);
        Dec(x2);
      end;
      PutImage(x2, 250, GhostFrames[Pinky][wd2][byte(cwf2 mod 24 >= 12)]^, CopyPut);
      PutImage(x1, 250, MsPacFrames[wd1][byte(cwf1 mod 6 >= 3)]^, CopyPut);
      Dec(x1);
      Dec(x2);
      Inc(cwf1);
      Inc(cwf2);
    end;
    ClearDevice;
    Delay(200);

    wd1 := Left;
    wd2 := Right;
    cwf1 := 0;
    cwf2 := 0;
    x1 := 640 shr 1 + mzMaxX shl 3;
    x2 := 640 shr 1 - mzMaxX shl 3; ;
    for i := 1 to mzMaxX * 8 - 8 do
    begin
      Delay(6);
      PutImage(x1, 210, PacFrames[wd1][byte(cwf1 mod 6 >= 3)]^, CopyPut);
      PutImage(x2, 210, MsPacFrames[wd2][byte(cwf2 mod 6 >= 3)]^, CopyPut);
      PutImage(x1 + 20, 210, GhostFrames[Inky][wd1][byte(cwf1 mod 24 >= 12)]^, CopyPut);
      PutImage(x2 - 20, 210, GhostFrames[Pinky][wd2][byte(cwf2 mod 24 >= 12)]^, CopyPut);
      Dec(x1);
      Inc(x2);
      Inc(cwf1);
      Inc(cwf2);
    end;
    wd1 := Up;
    wd2 := Up;
    cwf1 := 0;
    cwf2 := 0;
    for i := 210 downto 170 do
    begin
      Delay(6);
      PutImage(x1, i, PacFrames[wd1][byte(cwf1 mod 6 >= 3)]^, CopyPut);
      PutImage(x2, i, MsPacFrames[wd2][byte(cwf2 mod 6 >= 3)]^, CopyPut);
      if (x1 - x2 + 2 * i > 392) then
      begin
        PutImage(x1 + 20 + i - 210, 210, GhostFrames[Inky][Left][byte(cwf1 mod 24 >= 12)]^, CopyPut);
        PutImage(x2 - 20 - i + 210, 210, GhostFrames[Pinky][Right][byte(cwf2 mod 24 >= 12)]^, CopyPut);
      end else
      begin
        PutImage(326 + 186 - i, 210 + Random(2), GhostFrames[Inky][Left][byte(cwf1 mod 24 >= 12)]^, CopyPut);
        PutImage(314 + i - 186, 210 + Random(2), GhostFrames[Pinky][Right][byte(cwf2 mod 24 >= 12)]^, CopyPut);
      end;
      Inc(cwf1);
      Inc(cwf2);
    end;

    wd1 := Left;
    wd2 := Right;
    cwf1 := 0;
    cwf2 := 0;
    PutImage(x1, 170, PacFrames[wd1][byte(cwf1 mod 6 >= 3)]^, CopyPut);
    PutImage(x2, 170, MsPacFrames[wd2][byte(cwf2 mod 6 >= 3)]^, CopyPut);
    PutImage((x1 + x2) div 2, 170 - 8, LevelImages[17]^, OrPut);
    Delay(700);
    ClearDevice;
    Delay(500);
  end;

  procedure Act2;
  var
    i, x1, x2: integer;
    cwf1, cwf2: byte;
    wd1, wd2: byte;
  begin
    wd1 := Right;
    wd2 := Right;
    cwf1 := 0;
    cwf2 := 0;
    x1 := 640 shr 1 - mzMaxX shl 3;
    x2 := x1 + 32;
    for i := 1 to mzMaxX * 16 do
    begin
      Delay(4);
      if x1 mod 24 = 0 then
      begin
        PutImage(x1, 150, PacFrames[wd1][byte(cwf1 mod 6 >= 3)]^, CopyPut);
        Inc(x1);
      end;
      PutImage(x1, 150, PacFrames[wd1][byte(cwf1 mod 6 >= 3)]^, CopyPut);
      PutImage(x2, 150, MsPacFrames[wd2][byte(cwf2 mod 6 >= 3)]^, CopyPut);
      Inc(x1);
      Inc(x2);
      Inc(cwf1);
      Inc(cwf2);
    end;
    ClearDevice;
    Delay(200);

    wd1 := Left;
    wd2 := Left;
    cwf1 := 0;
    cwf2 := 0;
    x1 := 640 shr 1 + mzMaxX shl 3;
    x2 := x1 - 32;
    for i := 1 to mzMaxX * 16 do
    begin
      Delay(4);
      if x1 mod 24 = 0 then
      begin
        PutImage(x1, 250, PacFrames[wd1][byte(cwf1 mod 6 >= 3)]^, CopyPut);
        Dec(x1);
      end;
      PutImage(x1, 250, MsPacFrames[wd1][byte(cwf1 mod 6 >= 3)]^, CopyPut);
      PutImage(x2, 250, PacFrames[wd2][byte(cwf2 mod 6 >= 3)]^, CopyPut);
      Dec(x1);
      Dec(x2);
      Inc(cwf1);
      Inc(cwf2);
    end;
    ClearDevice;
    Delay(200);

    wd1 := Right;
    wd2 := Right;
    cwf1 := 0;
    cwf2 := 0;
    x1 := 640 shr 1 - mzMaxX shl 3;
    x2 := x1 + 32;
    for i := 1 to mzMaxX * 16 do
    begin
      Delay(4);
      if x1 mod 24 = 0 then
      begin
        PutImage(x1, 200, PacFrames[wd1][byte(cwf1 mod 6 >= 3)]^, CopyPut);
        Inc(x1);
      end;
      PutImage(x1, 200, PacFrames[wd1][byte(cwf1 mod 6 >= 3)]^, CopyPut);
      PutImage(x2, 200, MsPacFrames[wd2][byte(cwf2 mod 6 >= 3)]^, CopyPut);
      Inc(x1);
      Inc(x2);
      Inc(cwf1);
      Inc(cwf2);
    end;
    ClearDevice;
    Delay(200);

    wd1 := Right;
    cwf1 := 0;
    x1 := 640 shr 1 - mzMaxX shl 3;
    for i := 1 to mzMaxX * 16 do
    begin
      Delay(1);
      PutImage(x1, 150, MsPacFrames[wd1][byte(cwf1 mod 6 >= 3)]^, CopyPut);
      Inc(x1);
      Inc(cwf1);
    end;
    ClearDevice;
    wd1 := Right;
    cwf1 := 0;
    x1 := 640 shr 1 - mzMaxX shl 3;
    for i := 1 to mzMaxX * 16 do
    begin
      Delay(1);
      PutImage(x1, 150, PacFrames[wd1][byte(cwf1 mod 6 >= 3)]^, CopyPut);
      Inc(x1);
      Inc(cwf1);
    end;
    ClearDevice;
    Delay(200);

    wd1 := Left;
    cwf1 := 0;
    x1 := 640 shr 1 + mzMaxX shl 3;
    for i := 1 to mzMaxX * 16 do
    begin
      Delay(1);
      PutImage(x1, 250, PacFrames[wd1][byte(cwf1 mod 6 >= 3)]^, CopyPut);
      Dec(x1);
      Inc(cwf1);
    end;
    ClearDevice;
    wd1 := Left;
    cwf1 := 0;
    x1 := 640 shr 1 + mzMaxX shl 3;
    for i := 1 to mzMaxX * 16 do
    begin
      Delay(1);
      PutImage(x1, 250, MsPacFrames[wd1][byte(cwf1 mod 6 >= 3)]^, CopyPut);
      Dec(x1);
      Inc(cwf1);
    end;
    ClearDevice;
    Delay(1000);
  end;

begin
  LogLn(Format('Act(%d)', [actno]));
  ClearDevice;
  OutTextXY((640 - TextWidth(ActStr[actno])) shr 1, 128, ActStr[actno]);
  PutImage(202, 120, ActImages[actno]^, CopyPut);
  PutImage(202, 100, ActImages[4]^, CopyPut);
  Delay(800);
  PutImage(202, 100, ActImages[5]^, CopyPut);
  Delay(400);
  PutImage(202, 100, ActImages[4]^, CopyPut);
  Delay(1000);
  ClearDevice;
  case actno of
    1: Act1;
    2: Act2
  end;
end;

var
  gd, gm: smallint;

begin
  Randomize;
  LogLn(Concat('MS PACMAN ', {$I %DATE%}, ' ', {$I %TIME%}, ' FPC ', {$I %FPCVERSION%}, ' ', {$I %FPCTARGETOS%}, ' ', {$I %FPCTARGETCPU%}));
  WriteLn('MS PACMAN, Beta version - Demonstration');
  WriteLn('Copyright (C) 1997 by George M. Tzoumas');
  WriteLn('Loading...');
  LoadImages;
  Initialize(Levels);
  Levels[1].Init(1, 20, 9, 15, 9, 9, 139, 39, 4, Mazes[1]);
  Levels[2].Init(2, 20, 9, 15, 9, 9, 139, 39, 4, Mazes[1]); Levels[2].cblind := 392;
  Levels[3].Init(3, 21, 9, 16, 9, 10, 159, 43, 63, Mazes[2]); Levels[3].cblind := 256;
  Levels[4].Init(4, 21, 9, 16, 9, 10, 159, 43, 63, Mazes[2]); Levels[4].cblind := 192;
  Levels[5].Init(5, 21, 9, 16, 9, 10, 159, 43, 63, Mazes[2]); Levels[5].cblind := 128;
  Levels[6].Init(6, 21, 9, 16, 9, 10, 158, 4, 63, Mazes[3]); Levels[6].cblind := 392;
  l := 0;
  pal := 63;

  gd := VGA;
  gm := VGAHi;
  WindowTitle := 'MsPacman for ptcGraph';
  InitGraph(gd, gm, '');
  SetFillStyle(SolidFill, Black);
  repeat
    Inc(l);
    CurLevel := @Levels[l];
    Ghosts[Blinky].Init(@GhostFrames[Blinky], Blinky, CurLevel);
    Ghosts[Pinky].Init(@GhostFrames[Pinky], Pinky, CurLevel);
    Ghosts[Inky].Init(@GhostFrames[Inky], Inky, CurLevel);
    Ghosts[Sue].Init(@GhostFrames[Sue], Sue, CurLevel);
    MsPac.Init(@MsPacFrames, CurLevel);
    SetPalette(8, CurLevel^.WallColor);
    SetPalette(7, CurLevel^.FrameColor);
    SetPalette(6, pal);
    ClearDevice;
    CurLevel^.Draw;
    MsPac.Draw;
    ShowLives;
    ShowScore;
    for i := Blinky to Sue do
      Ghosts[i].Draw;
    LastMove := 0;
    om := LastMove;
    t := 0;
    GBonusC := 0;
    ShowMessage('READY', 1000);
    ch := #0;
    repeat
      if t < High(word) then
        Inc(t)
      else
        t := 0;
      while KeyPressed do
      begin
        ch := ReadKey;
        if ch = #0 then
        begin
          ch := ReadKey;
          case ch of
            #75: LastMove := Left;
            #77: LastMove := Right;
            #72: LastMove := Up;
            #80: LastMove := Down;
            #63..#67: Cheat(ch);
          end;
          ch := #0;
        end;
      end;
      if LastMove <> 0 then
        if MsPac.SetDir(LastMove) then
        begin
          if om <> LastMove then
          begin
            om := LastMove;
            MsPac.Move;
            MsPac.Draw;
          end;
          LastMove := 0;
        end;
      MoveRest;
      MsPac.Move;
      MsPac.Draw;
      if t mod 8 = 0 then
      begin
        MsPac.Move;
        MsPac.Draw;
      end;
      for i := Blinky to Sue do
      begin
        Ghosts[i].Move;
        if Ghosts[i].State = Dead then
          Ghosts[i].Move;
      end;
      for i := Blinky to Sue do
        Ghosts[i].Draw;
      if t mod 8 = 0 then
      begin
        pal := pal xor 63;
        SetPalette(6, pal);
      end;

      Delay(10);

      if SkipLevel then
      begin
        CurLevel^.Dots := 0;
        SkipLevel := FALSE;
      end;
    until (ch in [#3, #27]) or Closing or (CurLevel^.Dots = 0);

    MsPac.cwf := 0;
    MsPac.Draw;
    if CurLevel^.Dots = 0 then
    begin
      for i := Blinky to Sue do
        Ghosts[i].UnDraw;
      MsPac.UnDraw;
      if l = 6 then
        ShowMessage('YOU WIN', 3000);
    end;
    if not ((ch in [#3, #27]) or Closing) then
      case l of
        2: Act(1);
        5: Act(2)
      end;
    ClearKeyboard;
  until (ch in [#3, #27]) or Closing or (l = 6);
  CloseGraph;
end.
