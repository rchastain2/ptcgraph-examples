(* This program draws the planets in colour. *)
program graftest;
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph,
  ptcCrt,
  GraphBits;

var
  GraphDRiver, GraphMode, Errorcode, x, y, l, g, h, j, k: integer;
  ch: char;
  s: string;

begin
  GraphicsScreen;
  settextjustify(1, 1);
  settextstyle(1, 0, 4);
  SetColor(LightRed);
  outtextxy(DivX, 100, 'The Planets and their Relative Sizes');
  SetColor(Yellow);
  Line(40, 125, 600, 125);
  settextstyle(1, 0, 3);
  SetColor(Blue);
  outtextxy(DivX, 180, 'by Glenn Kentwell');
  settextstyle(6, 0, 1);
  SetColor(Yellow);
  outtextxy(DivX, 400, 'Press any key to continue...');
  settextstyle(2, 0, 5);
  SetColor(White);
  ellipse(310, 280, 343, 198, 86, 77); {saturn}
  ellipse(310, 280, 205, 334, 86, 77);
  setfillstyle(11, Green);
  ellipse(310, 280, 113, 67, 194, 37); {rings}
  ellipse(310, 280, 126, 54, 140, 30);
  FloodFill(310, 280, 15);
  FloodFill(310, 325, 15);
  SetFillStyle(1, LightGreen);
  FloodFill(490, 280, 15);

  readkey;
  settextjustify(0, 2);
  x := 1;
  cleardevice;
  setfillstyle(1, LightRed);
  FillEllipse(-1800, 48, 1962, 1962); {sun}
  SetFillStyle(1, Yellow);
  fillellipse(50, 50, 10 * x, 10 * x); {mercury}
  SetFillStyle(1, White);
  fillellipse(100, 50, 17 * x, 17 * x); {venus}
  SetFillStyle(1, Blue);
  fillellipse(150, 50, 18 * x, 18 * x); {earth}
  SetFillStyle(1, LightRed);
  fillellipse(200, 50, 10 * x, 10 * x); {mars}
  SetColor(Green);
  settextstyle(0, 1, 1);
  outtextxy(50, 70, 'Mercury');
  outtextxy(100, 80, 'Venus');
  outtextxy(150, 80, 'Earth');
  outtextxy(200, 75, 'Mars');
  setfillstyle(11, Brown);
  fillellipse(450, 105, 202 * x, 189 * x); {jupiter}
  settextstyle(1, 0, 3);
  SetFillStyle(11, Green);
  outtextxy(70, 140, 'Sun');
  outtextxy(405, 60, 'Jupiter');
  setfillstyle(1, Green);
  Fillellipse(100, 350, 171 * x, 154 * x); {saturn}
  outtextxy(75, 320, 'Saturn');
  SetColor(White);
  ellipse(100, 350, 18, 27, 171 * x, 154 * x);
  ellipse(100, 350, 113, 67, 388 * x, 75 * x); {rings}
  ellipse(100, 350, 216, 55, 280 * x, 60 * x);
  SetFillStyle(1, Yellow);
  floodfill(100, 415, 15);
  floodfill(480, 350, 15);
  setfillstyle(1, LightGreen);
  fillellipse(550, 200, 72 * x, 72 * x); {uranus}
  outtextxy(560, 275, 'Uranus');
  SetFillStyle(1, Blue);
  fillellipse(495, 400, 70 * x, 70 * x); {neptune}
  outtextxy(345, 440, 'Neptune');
  fillellipse(610, 380, 2 * x, 2 * x); {pluto}
  settextstyle(0, 1, 1);
  outtextxy(613, 395, 'Pluto');
  setfillstyle(10, 15);
  settextstyle(0, 0, 2);
  outtextxy(235, 220, 'Press any key...');
  readkey;
  cleardevice;
  SetColor(LightBlue);
  settextstyle(1, 0, 6);
  SetTextJustify(1, 1);
  outtextxy(DivX, DivY - 50, 'That''s all,');
  outtextxy(DivX - 20, DivY + 50, ' folks!!');
  readkey;
  closegraph;
end.
