
program drawpoly1;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;
  
const
  points: array[1..9] of pointType = (
    (X: 320 - 100; Y: 240 + 000),
    (X: 320 - 020; Y: 240 - 020),
    (X: 320 + 000; Y: 240 - 100),
    (X: 320 + 020; Y: 240 - 020),
    (X: 320 + 100; Y: 240 + 000),
    (X: 320 + 020; Y: 240 + 020),
    (X: 320 + 000; Y: 240 + 100),
    (X: 320 - 020; Y: 240 + 020),
    (X: 320 - 100; Y: 240 + 000)
  );
    
var
  pilote, mode: smallint;
  
begin
  pilote := d8bit;
  mode := m640x480;
  InitGraph(pilote, mode, '');
  DrawPoly(SizeOf(points) div SizeOf(pointType), points);
  ReadKey;
  CloseGraph;
end.
