
program sector1;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors16;
  
const
  CAngle1 = 0;
  CAngle2 = 270;
  
var
  LRayon1, LRayon2: integer;
  LPilote, LMode: smallint;
  
begin
  LPilote := 10;
  LMode := 276;
  InitGraph(LPilote, LMode, '');
  SetBkColor(CDarkSlateGray);
  ClearDevice;
  SetColor(CLightYellow);
  
  LRayon1 := GetMaxY div 3;
  LRayon2 := GetMaxY div 5;
  Sector(GetMaxX div 2, GetMaxY div 2, CAngle1, CAngle2, LRayon1, LRayon2);
  
  ReadKey;
  CloseGraph;
end.

