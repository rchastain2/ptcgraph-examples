
{
  Martin Fractal program, by Alan Meiss
}

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors16;

function Sign(x: double): integer;
begin
  if x = 0 then
    result := 0
  else
    if x < 0 then
      result := -1
    else
      result := +1;
end;

const
  tcmax = 12;
  
var
  cx, cy: integer;

procedure Plot(x, y: double);
begin
  PutPixel(Round(x) + cx, Round(y) + cy, cWhite);
end;

{ "a", "b", and "c" are random values constant for a given Fractal, "s" is a
  scaling factor. }

procedure Martin(a, b, c, s: double);
var
  t, tc: integer;
  xold, yold, xnew, ynew: double;
begin
  xold := 0;
  yold := 0;
  t := 0;
  tc := 0;
  repeat
    Plot(xold * s, yold * s);
    xnew := yold - Sign(xold) * Sqrt(Abs(b * xold - c));
    ynew := a - xold;
    xold := xnew;
    yold := ynew;
    Inc(t);
    if t > 1000 then
    begin
      Inc(tc);
      t := 0;
    end;
  until tc = tcmax;
end;

var
  sa, sb, sc, sav: double;
  LKey: char;
  
var
  d, m: smallint;
  
begin
  d := VESA;
  m := m640x480x64k;
  InitGraph(d, m, '');
  Randomize;

  SetBkColor(cBlack);
  SetColor(cYellow);
  ClearDevice;
  cx := GetMaxX div 2;
  cy := GetMaxY div 2;
  repeat
    sa := Random * 100.0 - 50.0;
    sb := Random * 100.0 - 50.0;
    sc := Random * 100.0 - 50.0;
    sav := (Abs(sa) + Abs(sb) + Abs(sc)) / 3.0;
    ClearDevice;
    Martin(sa, sb, sc, 6.0 - Abs(sav / 10.0));
    LKey := ReadKey;
  until LKey in [#3, #13, 'q', 'Q'];
  CloseGraph;
end.
