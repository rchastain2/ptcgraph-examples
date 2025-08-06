
program moveto1;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;
  
const
  L = 640;
  H = 480;

function f(t: double): double;
begin
  f := -3 * Cos(t) - 2 * Cos(3 * t);
end;

function g(t: double): double;
begin
  g := -3 * Sin(t) + 2 * Sin(3 * t);
end;

procedure Trace(a, b, c, d, t1, t2, pas: double);
var
  t: double;
begin
  t := t1;
  MoveTo(
    Round(L * (f(t) - a)) div Round(b - a),
    Round(H * (g(t) - d)) div Round(c - d)
    );
  repeat
    LineTo(
      Round(L * (f(t) - a)) div Round(b - a),
      Round(H * (g(t) - d)) div Round(c - d)
      );
    t := t + pas;
    Delay(5);
  until t > t2;
end;

var
  pilote, mode: smallint;
  
begin
  pilote := d8bit;
  mode := m800x600;
  InitGraph(pilote, mode, '');
  SetBkColor(White);
  SetColor(Blue);
  ClearDevice;
  Trace(-6, 6, -6, 6, 0, 6.28, 0.02);
  ReadKey;
  CloseGraph;
end.
