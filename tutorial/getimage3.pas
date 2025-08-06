
program rebound;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;
  
const
  SLEEP_TIME = 20;
  DIAMETER = 10;
  X_MOVE_DIST = 5;
  Y_MOVE_DIST = 5;
  X_MAX = 240;
  Y_MAX = 240;
  Y_START = 100;
  
var
  Gd, Gm: smallint;
  Error, X, Y, Radius: integer;
  PBall: pointer;
  MemoryBall: word;
  RightNext, DownNext: boolean;

procedure Move;
begin
  if RightNext then
  begin
    if X + Diameter >= X_MAX then
    begin
      RightNext := False;
      X := X - X_MOVE_DIST;
    end else
    begin
      X := X + X_MOVE_DIST;
    end;
  end else
  begin
    if X <= 0 then
    begin
      RightNext := True;
      X := X + X_MOVE_DIST;
    end else
    begin
      X := X - X_MOVE_DIST;
    end;
  end;
  if DownNext then
  begin
    if Y + Diameter >= Y_MAX then
    begin
      DownNext := False;
      Y := Y - Y_MOVE_DIST;
    end else
    begin
      Y := Y + Y_MOVE_DIST;
    end;
  end else
  begin
    if Y <= 0 then
    begin
      DownNext := True;
      Y := Y + Y_MOVE_DIST;
    end else
    begin
      Y := Y - Y_MOVE_DIST;
    end;
  end;
  
  PutImage(X, Y, PBall^, 0);
  Delay(SLEEP_TIME);
  
  Bar(X, Y, Diameter + X, Diameter + Y);
end;

begin
  Gd := D4bit;
  Gm := m640x480;
  InitGraph(Gd, Gm, '');
  Error := graphResult;
  if (Error <> grOk) then
  begin
    WriteLn('640 x 480 x 16 is not supported.');
    Delay(5000);
    Halt;
  end;
  SetFillStyle(SolidFill, White);
  Radius := Diameter div 2;
  FillEllipse(Radius, Radius, Radius, Radius);
  MemoryBall := ImageSize(0, 0, Diameter, Diameter);
  GetMem(PBall, MemoryBall);
  GetImage(0, 0, Diameter, Diameter, PBall^);
  SetFillStyle(SolidFill, Black);
  Bar(0, 0, Diameter, Diameter);
  Line(X_MAX + 1, 0, X_MAX + 1, Y_MAX + 1);
  Line(0, Y_MAX + 1, X_MAX + 1, Y_MAX + 1);
  X := 0;
  Y := Y_START;
  DownNext := True;
  RightNext := True;
  
  while not KeyPressed do
    Move;
  
  FreeMem(PBall, MemoryBall);
  CloseGraph;
end.


