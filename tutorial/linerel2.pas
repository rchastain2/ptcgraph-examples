
program linerel2;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;
  
var a, b: smallint;

procedure Nogrieznis(x, y: integer);
begin
  if Abs(x + y) > 1 then
  begin
    LineRel(x, y);
    Nogrieznis(9 * (-y div 10), 9 * (x div 10));
  end;
end;

begin
  a := d8bit;
  b := m640x480;
  InitGraph(a, b, '');
  MoveTo(50, 1);
  Nogrieznis(500, 0);
  ReadKey;
  CloseGraph;
end.
