(*
  Description: Endpoints of  PIE Segment
  Author: THOMAS GROFF
  Date: 08-27-93  20:02
*)

{
THOMAS GROFF

> would like a unit to return the endpoints of a PIE segment. You could
> always draw the arc invisibly and then use the GetArcCoords() procedure
> provided in the graph unit and save yourself some time.
}

program getlegs;
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors16;
var
  pts3    : arccoordstype; { <---- Necessary to declare this type var. }
  rad,
  startang,
  endang,
  x, y,
  gd, gm  : smallint;
begin
  gd := detect;
  InitGraph(gd,gm,'e:\bp\bgi');
  cleardevice;
  x := 100;
  y := 100;
  startang := 25;
  endang   := 130;
  rad      := 90;

  setcolor(cBlack);  {  <------ Draw arc in background color. }
  arc(x, y, startang, endang, rad);
  GetArcCoords(pts3);  {  <----- This is what you want, look it up! }
  setcolor(cOrange);     {  <----- Show your lines now.}
  line(pts3.x, pts3.y, pts3.xstart, pts3.ystart);
  line(pts3.x, pts3.y, pts3.xend, pts3.yend);
  outtextxy(50, 150, 'Press enter to see your original arc when ready...');

  readkey;
  setcolor(cDarkOrange);
  arc(x, y, startang, endang, rad);
  outtextxy(50, 200, 'Press enter stop demo.');
  readkey;
  closegraph;
end.
