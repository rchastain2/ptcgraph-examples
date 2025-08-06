
program croix;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors16;
  
procedure Croix(x, y, a: double; n: integer);
var
  h: double;
begin
  h := Sqrt(Sqr(a) - Sqr(a / 2));
  Line(Round(x), Round(y), Round(x), Round(y + 2 * h / 3));
  Line(Round(x), Round(y), Round(x - a / 2), Round(y - h / 3));
  Line(Round(x), Round(y), Round(x + a / 2), Round(y - h / 3));
  if n > 1 then
  begin
    Croix(x, y + 2 * h / 3, a / 2, n - 1);
    Croix(x - a / 2, y - h / 3, a / 2, n - 1);
    Croix(x + a / 2, y - h / 3, a / 2, n - 1);
  end;
end;
  
var
  d, m: smallint;
  
begin
  d := VESA;
  m := m640x480x64k;
  InitGraph(d, m, '');
  
  ClearDevice;
  SetColor(cYellowGreen);
  Croix(GetMaxX / 2, GetMaxY / 2.5, 200, 6);
  
  ReadKey;
  CloseGraph;
end.
