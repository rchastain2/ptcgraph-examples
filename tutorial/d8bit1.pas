
program d8bit1;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;
 
var
  d, m: smallint;
  x: integer;
 
begin
  d := d8bit;
  m := m800x600;
  
  InitGraph(d, m, '');
  
  for x := 0 to GetMaxX do
  begin
    SetColor(x mod 256);
    Line(x, 0, x, GetMaxY);
  end;
 
  ReadKey;
  CloseGraph;
 end.
