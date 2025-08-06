
program linerel1;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;
  
var
  a, b: smallint;

procedure Nogrieznis(x, y, dx, dy: integer);
begin
  if Abs(dx + dy) > 1 then
  begin
    MoveTo(x, y);
    LineRel(dx, dy);
    Nogrieznis(x + dx, y + dy, dy div 2, dx div 2);
    Nogrieznis(x + dx, y + dy, -dy div 2, -dx div 2);
  end;
end;

begin
  a := d8bit;
  b := m640x480;
  InitGraph(a, b, '');
  Nogrieznis(0, 200, 256, 0);
  ReadKey;
end.
