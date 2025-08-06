
(* Roby's Pascal Tutorial *)

program anim;

uses
{$IFDEF unix}
  cthreads,
{$ENDIF}
  ptccrt, ptcgraph, colors16;

procedure init;
var
  gd, gm: {integer} smallint;
begin
  gd := VESA;
  gm := m800x600x64k;
  initgraph(gd, gm, '\BP\BGI');
  gd := graphresult;
  if gd <> grOK then
  begin
    writeln('Error : ', grapherrormsg(gd));
    halt;
  end;
end;

procedure destroy;
begin
  closegraph;
end;

procedure animate;
var
  backbuf: pointer;
  backsize, i: word;
begin
  { Calculate background buffer size first }
  backsize := imagesize(0, 0, 20, 20);
  { Reserve the buffer }
  getmem(backbuf, backsize);
  { Prepare the colors }
  setfillstyle(1, cOrange);
  setcolor(cDarkOrange);
  setbkcolor(cForestGreen);
  cleardevice;
  
  for i := 0 to GetMaxX - 20 do
  begin
    { Save the background first }
    getimage(0 + i, 0, 20 + i, 20, backbuf^);
    { Draw something (Pacman) }
    sector(10 + i, 10, 30 - (i mod 30), 330 + (i mod 30), 10, 10);
    delay(5);
    { Restore the background }
    putimage(0 + i, 0, backbuf^, 0);
  end;
  { Release the buffer }
  freemem(backbuf, backsize);
end;

begin
  init;
  animate;
  readkey;
  destroy;
end.
