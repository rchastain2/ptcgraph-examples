
program clowns;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors16;
  
var
  d, m: smallint;
  
begin
  d := VESA;
  m := m640x480x64k;
  InitGraph(d, m, '');
  
  SetBkColor(cDarkSlateGray);
  ClearDevice;

  setcolor(cWhite);
  ellipse(GetMaxX div 3 - 50, GetMaxY div 2, 0, 360, 100, 150);
  ellipse(GetMaxX - GetMaxX div 3 + 50, GetMaxY div 2, 0, 360, 100, 150);
  
  setcolor(cMauve);
  setfillstyle(solidfill, cOrchid);
  circle(GetMaxX div 3 - 50, GetMaxY div 2 + 25, 20);
  floodfill(GetMaxX div 3 - 50, GetMaxY div 2 + 25, cMauve);
  
  setcolor(cYellowGreen);
  setfillstyle(solidfill, cLightGreen);
  circle(GetMaxX - GetMaxX div 3 + 50, GetMaxY div 2 + 25, 20);
  floodfill(GetMaxX - GetMaxX div 3 + 50, GetMaxY div 2 + 25, cYellowGreen);
  
  setcolor(cCornFlowerBlue);
  ellipse(GetMaxX div 3 - 50, GetMaxY div 2 + 60, 180, 360, 50, 55);
  ellipse(GetMaxX div 3 - 50, GetMaxY div 2 + 60, 180, 360, 50, 20);
  ellipse(GetMaxX div 3 - 50, GetMaxY div 2 + 60, 180, 360, 50, 54);
  ellipse(GetMaxX div 3 - 50, GetMaxY div 2 + 60, 180, 360, 50, 21);
  setcolor(cTomato);
  ellipse(GetMaxX - GetMaxX div 3 + 50, GetMaxY div 2 + 60, 180, 360, 50, 55);
  ellipse(GetMaxX - GetMaxX div 3 + 50, GetMaxY div 2 + 60, 180, 360, 50, 20);
  ellipse(GetMaxX - GetMaxX div 3 + 50, GetMaxY div 2 + 60, 180, 360, 50, 21);
  ellipse(GetMaxX - GetMaxX div 3 + 50, GetMaxY div 2 + 60, 180, 360, 50, 54);
  ellipse(GetMaxX div 3 - 90, GetMaxY div 2, 0, 180, 20, 60);
  ellipse(GetMaxX div 3 - 90, GetMaxY div 2 + 4, 0, 360, 20, 10);
  setcolor(cCornFlowerBlue);
  setfillstyle(solidfill, cCornFlowerBlue);
  circle(GetMaxX div 3 - 90, GetMaxY div 2 + 4, 10);
  floodfill(GetMaxX div 3 - 90, GetMaxY div 2 + 4, cCornFlowerBlue);
  setcolor(cMidnightBlue);
  setfillstyle(solidfill, cMidnightBlue);
  circle(GetMaxX div 3 - 90, GetMaxY div 2 + 4, 3);
  floodfill(GetMaxX div 3 - 90, GetMaxY div 2 + 4, cMidnightBlue);
  setcolor(cWhite);
  circle(GetMaxX div 3 - 90, GetMaxY div 2 + 4, 10);
  setcolor(cTomato);
  ellipse(GetMaxX div 3 - 10, GetMaxY div 2, 0, 180, 20, 60);
  ellipse(GetMaxX div 3 - 10, GetMaxY div 2 + 4, 0, 360, 20, 10);
  setcolor(cCornFlowerBlue);
  setfillstyle(solidfill, cCornFlowerBlue);
  circle(GetMaxX div 3 - 10, GetMaxY div 2 + 4, 10);
  floodfill(GetMaxX div 3 - 10, GetMaxY div 2 + 4, cCornFlowerBlue);
  setcolor(cMidnightBlue);
  setfillstyle(solidfill, cMidnightBlue);
  circle(GetMaxX div 3 - 10, GetMaxY div 2 + 4, 3);
  floodfill(GetMaxX div 3 - 10, GetMaxY div 2 + 4, cMidnightBlue);
  setcolor(cWhite);
  circle(GetMaxX div 3 - 10, GetMaxY div 2 + 4, 10);
  setcolor(cTomato);
  ellipse(GetMaxX - GetMaxX div 3 + 95, GetMaxY div 2, 0, 180, 20, 60);
  ellipse(GetMaxX - GetMaxX div 3 + 95, GetMaxY div 2 + 4, 0, 360, 20, 10);
  setcolor(cCornFlowerBlue);
  setfillstyle(solidfill, cCornFlowerBlue);
  circle(GetMaxX - GetMaxX div 3 + 95, GetMaxY div 2 + 4, 10);
  floodfill(GetMaxX - GetMaxX div 3 + 95, GetMaxY div 2 + 4, cCornFlowerBlue);
  setcolor(cMidnightBlue);
  setfillstyle(solidfill, cMidnightBlue);
  circle(GetMaxX - GetMaxX div 3 + 95, GetMaxY div 2 + 4, 3);
  floodfill(GetMaxX - GetMaxX div 3 + 95, GetMaxY div 2 + 4, cMidnightBlue);
  setcolor(cWhite);
  circle(GetMaxX - GetMaxX div 3 + 95, GetMaxY div 2 + 4, 10);
  setcolor(cTomato);
  ellipse(GetMaxX - GetMaxX div 3 + 8, GetMaxY div 2, 0, 180, 20, 60);
  ellipse(GetMaxX - GetMaxX div 3 + 8, GetMaxY div 2 + 4, 0, 360, 20, 10);
  setcolor(cCornFlowerBlue);
  setfillstyle(solidfill, cCornFlowerBlue);
  circle(GetMaxX - GetMaxX div 3 + 8, GetMaxY div 2 + 4, 10);
  floodfill(GetMaxX - GetMaxX div 3 + 8, GetMaxY div 2 + 4, cCornFlowerBlue);
  setcolor(cMidnightBlue);
  setfillstyle(solidfill, cMidnightBlue);
  circle(GetMaxX - GetMaxX div 3 + 8, GetMaxY div 2 + 4, 3);
  floodfill(GetMaxX - GetMaxX div 3 + 8, GetMaxY div 2 + 4, cMidnightBlue);
  setcolor(cWhite);
  circle(GetMaxX - GetMaxX div 3 + 8, GetMaxY div 2 + 4, 10);
  setcolor(cMauve);
  circle(100, 100, 15);
  floodfill(100, 100, cMauve);
  setcolor(cYellowGreen);
  setfillstyle(hatchfill, cYellowGreen);
  circle(79, 124, 15);
  floodfill(79, 124, cYellowGreen);
  setcolor(cLightSteelBlue);
  setfillstyle(linefill, cLightSteelBlue);
  circle(65, 151, 15);
  floodfill(65, 151, cLightSteelBlue);
  setcolor(cMediumBlue);
  circle(56, 180, 15);
  floodfill(56, 180, cMediumBlue);
  setcolor(cLemon);
  setfillstyle(slashfill, cLemon);
  circle(50, 208, 15);
  floodfill(50, 208, cLemon);
  ellipse(477, 180, 0, 192, 100, 50);
  ellipse(477, 180, 345, 360, 100, 50);
  readkey;
  closegraph;
end.
