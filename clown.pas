
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors16;
  
var
  d, m, e: smallint;
  
begin
  d := VESA;
  m := m640x480x64k;
  InitGraph(d, m, '');
  
  e := GraphResult;
  if e <> grOk then
  begin
    WriteLn(GraphErrorMsg(e));
    Exit;
  end;
  
  SetBkColor(cDarkSlateGray);
  ClearDevice;
  
  { Ovale du visage. }
  SetColor(cWhite);
  Ellipse(213 - 50, 239, 0, 360, 100, 150);
  
  { Nez. }
  SetColor(cLightMagenta);
  SetFillStyle(SolidFill, cLightMagenta);
  Circle(213 - 50, 239 + 25, 20);
  FloodFill(213 - 50, 239 + 25, cLightMagenta);
  
  { Bouche. }
  SetColor(cOrchid);
  Ellipse(213 - 50, 239 + 60, 180, 360, 50, 55);
  Ellipse(213 - 50, 239 + 60, 180, 360, 50, 20);
  Ellipse(213 - 50, 239 + 60, 180, 360, 50, 54);
  Ellipse(213 - 50, 239 + 60, 180, 360, 50, 21);
  
  { Yeux. }
  SetColor(cRed);
  Ellipse(213 - 90, 239, 0, 180, 20, 60);
  Ellipse(213 - 90, 239 + 4, 0, 360, 20, 10);
  SetColor(cBlue);
  SetFillStyle(SolidFill, cBlue);
  Circle(213 - 90, 239 + 4, 10);
  FloodFill(213 - 90, 239 + 4, cBlue);
  SetColor(cBlack);
  SetFillStyle(SolidFill, cBlack);
  Circle(213 - 90, 239 + 4, 3);
  FloodFill(213 - 90, 239 + 4, cBlack);
  SetColor(cWhite);
  Circle(213 - 90, 239 + 4, 10);
  
  SetColor(cRed);
  Ellipse(213 - 10, 239, 0, 180, 20, 60);
  Ellipse(213 - 10, 239 + 4, 0, 360, 20, 10);
  SetColor(cBlue);
  SetFillStyle(SolidFill, cBlue);
  Circle(213 - 10, 239 + 4, 10);
  FloodFill(213 - 10, 239 + 4, cBlue);
  SetColor(cBlack);
  SetFillStyle(SolidFill, cBlack);
  Circle(213 - 10, 239 + 4, 3);
  FloodFill(213 - 10, 239 + 4, cBlack);
  SetColor(cWhite);
  Circle(213 - 10, 239 + 4, 10);
  
  { Cheveux. }
  SetColor(cMagenta);
  SetFillStyle(SolidFill, cMagenta);
  Circle(100, 100, 15);
  FloodFill(100, 100, cMagenta);
  
  SetColor(cGreen);
  SetFillStyle(HatchFill, cGreen);
  Circle(79, 124, 15);
  FloodFill(79, 124, cGreen);
  
  SetColor(cBlue);
  SetFillStyle(LineFill, cBlue);
  Circle(65, 151, 15);
  FloodFill(65, 151, cBlue);
  
  SetColor(cGreen);
  SetFillStyle(LineFill, cGreen);
  Circle(56, 180, 15);
  FloodFill(56, 180, cGreen);
  
  SetColor(cYellow);
  SetFillStyle(SlashFill, cYellow);
  Circle(50, 208, 15);
  FloodFill(50, 208, cYellow);
  
  ReadKey;
  CloseGraph;
end.
