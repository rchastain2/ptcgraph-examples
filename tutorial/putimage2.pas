uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph,
  ptcCrt,
  Colors16;

procedure init;
var
  gd, gm: smallint;
begin
  gd := VGA;
  gm := VGAHi;
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
  setfillstyle(1, 14);
  setcolor(14);

  for i := 1 to 500 do
  begin
    { Save the background first }
    getimage(0 + i, 0, 20 + i, 20, backbuf^);

    { Draw something (Pacman) }
    sector(10 + i, 10, 30 - (i mod 30), 330 + (i mod 30), 10, 10);
    delay(5); { Delay a bit }

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
