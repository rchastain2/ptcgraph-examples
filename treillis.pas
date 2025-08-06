
program treillis;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors16;

const
  scale = 20;
  
var
  x, y, t, i: integer;
  
var
  d, m: smallint;
  
begin
  d := VESA;
  m := m640x480x64k;
  InitGraph(d, m, '');
  
  SetColor(cYellowGreen);
  
  x := 30;
  y := 30;
  t := 420;
  
  for i := 0 to t div scale do
  begin
    MoveTo(x, y + i * scale);
    LineTo(x + i * scale, y + t);
  end;
  
  ReadKey;
end.


