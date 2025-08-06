
program putimage1;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;

var
  d: smallint;
  m: smallint;
  p: pointer;
  s: word;

procedure graphics;
begin
  d := d8bit;
  m := m640x480;
  initgraph(d, m, '');
end;

procedure image;
begin
  setfillstyle(solidfill, yellow);
  bar(10, 10, 15, 15);
  bar(20, 10, 25, 15);
  setcolor(lightred);
  Line(10, 20, 25, 20);
end;

procedure move;
begin
  s := imagesize(9, 9, 26, 21);
  getmem(p, s);
  getimage(9, 9, 26, 21, p^);
  putimage(109, 9, p^, 0);
  freemem(p, s);
end;
  
begin
  graphics;
  image;
  move;
  readkey;
  closegraph;
end.
