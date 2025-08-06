
program trefle;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors16;


var
  t, a: single;
  x, y: integer;
var
  d, m: smallint;
  
begin
  d := VESA;
  m := m640x480x64k;
  InitGraph(d, m, '');
  SetBkColor(cDarkOrange);
  //SetColor(cYellow);
  ClearDevice;
  begin
    t := 0;
    a := 280.0;
    repeat
      x := Trunc(2 * a * Sqr(Sin(t)) * Cos(t));
      y := Trunc(2 * a * Sqr(Cos(t)) * Sin(t));
      PutPixel(320 + x, 240 + y, cYellow);
      t := t + 0.005;
      Delay(5);
    until (t > 2 * PI) or KeyPressed;
    ReadKey;
  end;
end.


