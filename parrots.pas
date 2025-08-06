
program Parrots;

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
  
  SetBkColor(cDarkGray);
  SetColor(cGray);
  ClearDevice;
  
  Ellipse(150, 350, 110, 200, 20, 70);
  Arc(151, 370, 180, 278, 20);
  Arc(160, 370, 230, 320, 20);
  Arc(180, 375, 222, 307, 10);
  Ellipse(180, 180, 280, 328, 40, 205);
  MoveTo(500, 309);
  LineRel(-400, -28);
  LineRel(-10, -10);
  LineRel(7, -8);
  LineRel(-8, -6);
  LineRel(6, -9);
  LineRel(-15, -5);
  LineRel(430, 35);
  LineRel(-10, 6);
  LineRel(7, 5);
  LineRel(-8, 7);
  LineRel(16, 9);
  LineRel(-15, 4);
  Ellipse(260, 200, 100, 195, 120, 190);
  Ellipse(240, 53, 0, 90, 50, 40);
  Ellipse(290, 103, 0, 90, 60, 50);
  Ellipse(341, 212, 330, 80, 60, 110);
  Ellipse(350, 340, 290, 26, 30, 90);
  Ellipse(330, 310, 172, 270, 30, 110);
  Arc(337, 413, 220, 320, 10);
  Arc(352, 418, 210, 320, 10);
  Ellipse(320, 160, 150, 238, 50, 120);
  Ellipse(230, 37, 275, 324, 50, 220);
  Arc(322, 110, 210, 330, 58);
  Ellipse(400, 100, 190, 250, 30, 100);
  Ellipse(375, 225, 290, 45, 20, 45);
  Arc(320, 220, 200, 270, 42);
  Ellipse(270, 110, 100, 180, 25, 35);
  Arc(290, 78, 90, 173, 25);
  Ellipse(271, 110, 90, 180, 25, 15);
  Circle(290, 75, 5);
  Circle(290, 75, 2);
  Ellipse(261, 96, 220, 325, 17, 15);
  Ellipse(255, 88, 340, 50, 17, 15);
  Arc(270, 100, 0, 90, 5);
  Line(299, 295, 340, 340);
  Line(340, 340, 375, 300);
  Line(310, 308, 320, 414);
  Line(320, 318, 328, 420);
  Line(335, 335, 345, 420);
  Line(350, 330, 350, 427);
  Line(365, 312, 360, 425);
  Ellipse(290, 275, 90, 265, 15, 18);
  Ellipse(290, 275, 90, 265, 10, 18);
  Ellipse(295, 276, 90, 265, 15, 18);
  Ellipse(295, 276, 90, 265, 10, 18);
  Ellipse(300, 277, 90, 265, 15, 18);
  Ellipse(300, 277, 90, 265, 10, 18);
  Ellipse(350, 281, 90, 265, 15, 18);
  Ellipse(350, 281, 90, 265, 10, 18);
  Ellipse(355, 282, 90, 265, 15, 18);
  Ellipse(355, 282, 90, 265, 10, 18);
  Ellipse(360, 283, 90, 265, 15, 18);
  Ellipse(360, 283, 90, 265, 10, 18);
  Circle(250, 30, 5);
  Circle(250, 30, 2);
  Ellipse(280, 45, 90, 240, 12, 15);
  Ellipse(190, 140, 290, 0, 15, 50);
  Line(195, 186, 143, 248);
  Ellipse(190, 140, 0, 130, 15, 50);
  Ellipse(180, 145, 280, 72, 15, 55);
  Ellipse(200, 155, 246, 78, 20, 40);
  Ellipse(270, 160, 90, 250, 10, 25);
  Ellipse(163, 180, 100, 230, 10, 70);
  Ellipse(175, 170, 110, 224, 10, 70);
  Ellipse(190, 160, 130, 215, 10, 70);
  Line(145, 285, 180, 310);
  Line(180, 310, 210, 290);
  Ellipse(166, 347, 200, 340, 38, 15);
  Ellipse(270, 65, 31, 90, 10, 15);
  Line(155, 292, 148, 385);
  Line(165, 300, 160, 390);
  Line(180, 310, 173, 382);
  Line(195, 300, 188, 380);
  Ellipse(240, 273, 270, 90, 15, 18);
  Ellipse(240, 273, 270, 90, 10, 18);
  Ellipse(235, 272, 270, 90, 15, 18);
  Ellipse(235, 272, 270, 90, 10, 18);
  Ellipse(230, 271, 270, 90, 15, 18);
  Ellipse(230, 271, 270, 90, 10, 18);
  Ellipse(195, 270, 270, 90, 15, 18);
  Ellipse(195, 270, 270, 90, 10, 18);
  Ellipse(190, 269, 270, 90, 15, 18);
  Ellipse(190, 269, 270, 90, 10, 18);
  Ellipse(185, 268, 270, 90, 15, 18);
  Ellipse(185, 268, 270, 90, 10, 18);
  
  SetFillStyle(SolidFill, cYellowGreen);
  FloodFill(223, 89, cGray); 
  FloodFill(200, 120, cGray);
  FloodFill(212, 162, cGray);
  FloodFill(177, 299, cGray);
  FloodFill(142, 334, cGray);
  FloodFill(158, 339, cGray);
  FloodFill(170, 342, cGray);
  SetFillStyle(SolidFill, cYellow);
  FloodFill(185, 342, cGray);
  FloodFill(203, 309, cGray);
  FloodFill(185, 342, cGray);
  SetFillStyle(SolidFill, cGreen);
  FloodFill(140, 369, cGray); 
  FloodFill(156, 379, cGray);
  SetFillStyle(SolidFill, cForestGreen);
  FloodFill(167, 379, cGray); 
  FloodFill(183, 370, cGray);
  FloodFill(195, 364, cGray);
  
  SetFillStyle(SolidFill, cLightYellow);
  FloodFill(334, 209, cGray);
  FloodFill(333, 398, cGray);
  FloodFill(373, 357, cGray);
  FloodFill(307, 335, cGray);
  FloodFill(338, 319, cGray);
  SetFillStyle(SolidFill, cOrange);
  FloodFill(318, 329, cGray);
  SetFillStyle(SolidFill, cTangerine);
  FloodFill(389, 170, cGray);
  
  
  ReadKey;
  CloseGraph;
end.
