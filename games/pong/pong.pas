
program Pong;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  SysUtils,
  ptcCrt,
  ptcGraph,
  ptcMouse,
  Sound,
  Utils,
  Image;

const
  CGraphDriver      = VESA;
  CGraphMode        = {m1024x768x16m}m640x480x16m;
  CScreenWidth      = {1024}640;
  CScreenHeight     = {768}480;
  CViewPortLeft     = CScreenWidth div 6;
  CViewPortTop      = 0;
  CViewPortWidth    = 2 * CScreenWidth div 3;
  CViewPortHeight   = CScreenHeight;
  CBallAreaHeight   = CViewPortWidth;
  CPaddleAreaHeight = CScreenHeight - CBallAreaHeight;
  CBallWidth        = 17;
  CBallHeight       = CBallWidth;
  CPaddleTop        = CBallAreaHeight;
  CPaddleWidth      = 97;
  CPaddleHeight     = 17;
  CMinPaddleLeft    = 0;
  CMaxPaddleLeft    = CViewPortWidth - CPaddleWidth;
  CDelay            = 10;
  CAppName          = 'Pong for ptcGraph';
  CPressStart       = 'PRESS A KEY TO START';
  CPressQuit        = 'PRESS A KEY TO QUIT';
  CGameOver         = 'GAME OVER';
  CWallColor        = $404040;
  CBackgroundColor  = $101010;
  CTextColor        = $F0F000;
  CBallColor        = $00F000;
  CPaddleColor      = $F0F0F0;

var
  LBallLeft, LBallTop: double;
  LMoveHoriz, LMoveVert: integer;
  LPaddleLeft: integer;
  LGameOver: boolean;
  LBallImage, LPaddleImage: TImage;
  
procedure SetBallPosition(const dt: double);
begin
  LBallLeft := LBallLeft + 16 * dt * LMoveHoriz;
  LBallTop := LBallTop + 16 * dt * LMoveVert;
  
  if LBallLeft < 0 then
  begin
    LBallLeft := -1 * LBallLeft;
    LMoveHoriz := -1 * LMoveHoriz;
    Play(sndWall);
  end else
  if LBallLeft + CBallWidth > CViewPortWidth then
  begin
    LBallLeft := CViewPortWidth - (LBallLeft + CBallWidth - CViewPortWidth) - CBallWidth;
    LMoveHoriz := -1 * LMoveHoriz;
    Play(sndWall);
  end;
  
  if LBallTop < 0 then
  begin
    LBallTop := -1 * LBallTop;
    LMoveVert := -1 * LMoveVert;
    Play(sndWall);
  end else
  if LBallTop + CBallHeight > CBallAreaHeight then
  (*
    if (LBallLeft + CBallWidth > LPaddleLeft) and (LBallLeft < LPaddleLeft + CPaddleWidth) then
  *)
    if (LBallLeft + CBallWidth div 2 >= LPaddleLeft) and (LBallLeft + CBallWidth div 2 < LPaddleLeft + CPaddleWidth) then
    begin
      LBallTop := CBallAreaHeight - (LBallTop + CBallHeight - CBallAreaHeight) - CBallHeight;
      LMoveVert := -1 * LMoveVert;
      Play(sndPaddle);
    end else
    begin
      LGameOver := TRUE;
      Play(sndWall);
    end;
end;

procedure SetPaddlePosition(const dt: double);
var
  x, y, b: integer;
begin
  GetMouseState(x, y, b);
  Dec(x, CViewPortLeft);
  
  if x < CMinPaddleLeft + CPaddleWidth div 2 then
    LPaddleLeft := CMinPaddleLeft
  else
    if x > CMaxPaddleLeft + CPaddleWidth div 2 then
      LPaddleLeft := CMaxPaddleLeft
    else
      LPaddleLeft := LPaddleLeft + Round(16 * dt * (x - CPaddleWidth div 2 - LPaddleLeft));
end;

procedure DrawBall;
var
  LBallLeft1, LBallTop1: integer;
begin
  LBallLeft1 := Round(LBallLeft);
  LBallTop1 := Round(LBallTop);
  (*
  SetFillStyle(SolidFill, CBallColor);
  Bar(LBallLeft1, LBallTop1, Pred(LBallLeft1 + CBallWidth), Pred(LBallTop1 + CBallWidth));
  *)
  LBallImage.Put(LBallLeft1, LBallTop1);
end;

procedure DrawPaddle;
begin
  (*
  SetFillStyle(SolidFill, CPaddleColor);
  Bar(LPaddleLeft, CPaddleTop, Pred(LPaddleLeft + CPaddleWidth), Pred(CPaddleTop + CPaddleHeight));
  *)
  LPaddleImage.Put(LPaddleLeft, CPaddleTop);
end;

procedure DrawText(const AText: string; const ALow: boolean);
begin
  SetTextStyle(defaultFont, horizDir, 2);
  SetColor(CTextColor);
  OutTextXY(
    (CViewPortWidth - TextWidth(aText)) div 2,
    (2 + Ord(ALow)) * (CViewPortHeight div 5) - TextHeight(aText) div 2,
    AText
  );
end;

procedure DebugViewPort;
var
  v: ViewPortType;
begin
  GetViewSettings(v);
  with v do
    Log(Format('Current view port %d, %d, %d, %d, %s', [x1, y1, x2, y2, BoolToStr(clip)]));
end;

function OpenGraph: boolean;
var
  d, m: smallint;
  err: integer;
begin
  d := CGraphDriver;
  m := CGraphMode;
  WindowTitle := CAppName;
  InitGraph(d, m, '');
  err := GraphResult;
  result := err = grOk;
  if result then
  begin
    DebugViewPort;
    SetBkColor(CWallColor);
    SetActivePage(0); ClearViewPort;
    SetActivePage(1); ClearViewPort;
    SetActivePage(0);
    SetViewPort(CViewPortLeft, CViewPortTop, CViewPortLeft + CViewPortWidth - 1, CViewPortTop + CViewPortHeight - 1, ClipOff);
    DebugViewPort;
    SetBkColor(CBackgroundColor);
    ClearViewPort;
  end else
    Log(Concat('Cannot start graphic mode: ', GraphErrorMsg(err)));
end;

procedure InitPositions;
begin
  LBallLeft := Random(CViewPortWidth div 2);
  LBallTop  := 0;
  LMoveHoriz := 8 + Random(3);
  LMoveVert  := 12 + Random(3);
  LPaddleLeft := (CViewPortWidth - CPaddleWidth) div 2;
  LGameOver := FALSE;
end;

procedure Update(const dt: double);
begin
  SetPaddlePosition(dt);
  SetBallPosition(dt);
end;

procedure Draw;
begin
  ClearViewPort;
  DrawBall;
  DrawPaddle;
end;

var
  LPage: integer;
  LTime, LOldTime: qword;
  
begin
  Randomize;
  
  Log(Concat(CAppName, ' ', {$I %DATE%}, ' ', {$I %TIME%}, ' FPC ', {$I %FPCVERSION%}, ' ', {$I %FPCTARGETOS%}, ' ', {$I %FPCTARGETCPU%}), TRUE);
  
  if OpenGraph then
  begin
    HideMouse;
    
    LBallImage := TImage.Create(CBallWidth, CBallHeight);
    LBallImage.Load('factory/ball.img');
    LPaddleImage := TImage.Create(CPaddleWidth, CPaddleHeight);
    LPaddleImage.Load('factory/paddle.img');
    
    InitPositions;
    Draw;
    DrawText(CPressStart, FALSE);
    ReadKey;
    
    LOldTime := GetTickCount64;
    
    LPage := 0;
    repeat
      SetActivePage(LPage);
      LTime := GetTickCount64;
      
      Update((LTime - LOldTime) / 1000);
      Draw;
      
      LOldTime := LTime;
      SetVisualPage(LPage);
      Delay(CDelay);
      LPage := 1 - LPage;
    until KeyPressed or LGameOver;
    
    if LGameOver then
    begin
      DrawText(CGameOver, FALSE); Delay(500);
      DrawText(CPressQuit, TRUE);
      ReadKey;
    end;
    
    CloseGraph;
    
    LBallImage.Free;
    LPaddleImage.Free;
  end;
end.
