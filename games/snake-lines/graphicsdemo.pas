
uses
{$IFDEF UNIX}
  CThreads,
{$ENDIF}
  SysUtils,
  Classes,
  ptcCrt,
  SnakeGame,
  Graphics,
  Constants;

var
  vKey: char;
  vPoint: TPoint;
  
begin
  Settings;
  OpenWindow;
  SetDrawingContext(areaLabel1, TRUE);
  SetDrawingContext(areaLabel2, TRUE);
  SetDrawingContext(areaMain, FALSE);
  vPoint.SetLocation(XMIN, YMIN);
  DrawPoint(vPoint, colorSnake, TRUE);
  vPoint.SetLocation(XMAX, YMAX);
  DrawPoint(vPoint, colorApple, TRUE);
  vKey := ReadKey;
end.
