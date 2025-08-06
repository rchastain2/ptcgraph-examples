
program arc1;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors16;
  
const
  CAngle1 = 0;
  CAngle2 = 270;
  
var
  LRayon: integer;
  LPilote, LMode: smallint;
  
begin
  LPilote := VESA;
  LMode := m800x600x64k;
  InitGraph(LPilote, LMode, '');
  SetBkColor(CDarkSlateGray);
  ClearDevice;
  SetColor(COrange);
  
  LRayon := 0;
  repeat
    Inc(LRayon, 8);
    Arc(GetMaxX div 2, GetMaxY div 2, CAngle1, CAngle2, LRayon);
  until LRayon > GetMaxY div 3;
  
  ReadKey;
  CloseGraph;
end.

