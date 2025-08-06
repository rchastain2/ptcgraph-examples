program Frakt;

{ https://gorbem.hu/TP/Rekurzio.htm }

uses
{$IFDEF UNIX}
  cThreads,
{$ENDIF}
  ptcGraph,
  ptcCrt;

const
  x_el = -300;
  y_el = 0;
  nagyitas = 60;
  elemek_szama_max = 32;

type
  matrix = array[0..1, 0..1] of single;

  vektor = array[0..1] of single;

  ifs_elem = record
    szorzo: matrix;
    plusz: vektor;
    p: single;
  end;

  ifs_fractal = record
    elemek: array[0..elemek_szama_max - 1] of ifs_elem;
    elemek_szama: byte;
  end;

var
  x, y: single;
  fractal: ifs_fractal;

procedure init;
var
  gd, gm: smallint;
  procedure ifs_feltolt(x1, y1, x2, y2, ax, ay, dp: single);
  begin
    with fractal do
    begin
      with elemek[elemek_szama] do
      begin
        szorzo[0, 0] := x1; szorzo[0, 1] := y1;
        szorzo[1, 0] := x2; szorzo[1, 1] := y2;
        plusz[0] := ax;
        plusz[1] := ay;
        p := dp;
      end;
      inc(elemek_szama);
    end;
  end;

  procedure ifs_init;
  var
    i: byte;
  begin
    fractal.elemek_szama := 0;
    for i := 0 to elemek_szama_max - 1 do fractal.elemek[i].p := 1;
  end;

begin
  randomize;
  gd := vga;
  gm := vgahi;
  initgraph(gd, gm, 'c:\bp\bgi');
  ifs_init;
  ifs_feltolt(0.16, 0, 0, 0, 0, 0, 0.01);
  ifs_feltolt(0.85, -0.04, 0.04, 0.85, 1.6, 0, 0.85);
  ifs_feltolt(0.22, 0.23, -0.26, 0.2, 1.6, 0, 0.07);
  ifs_feltolt(0.24, 0.26, 0.28, -0.15, 0.44, 0, 0.07);
  x := 0;
  y := 0;
end;

procedure kiszamol(akt_elem: byte; var x, y: single);
var
  uj_x, uj_y: single;
begin
  with fractal do
  begin
    with elemek[akt_elem] do
    begin
      uj_x := szorzo[0, 0] * x + szorzo[0, 1] * y + plusz[0];
      uj_y := szorzo[1, 0] * x + szorzo[1, 1] * y + plusz[1];
    end;
  end;
  x := uj_x;
  y := uj_y;
end;

procedure uj_pont(var x, y: single; prob: single);
var
  val: single;
  akt_elem: byte;
begin
  val := 0;
  akt_elem := 0;
  with fractal do
  begin
    while val < prob do
    begin
      val := val + elemek[akt_elem].p;
      inc(akt_elem);
    end;
    kiszamol(akt_elem - 1, x, y);
  end;
end;

procedure rajzol(x, y: single);
begin
  putpixel(trunc(x * nagyitas + getmaxx / 2 + x_el), trunc(-y * nagyitas + getmaxy / 2 - y_el), Green);
end;

begin
  init;
  repeat
    uj_pont(x, y, random);
    rajzol(x, y);
  until keypressed;
end.
