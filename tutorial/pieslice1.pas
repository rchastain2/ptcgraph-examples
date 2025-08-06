
program pieslice1;

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
  LPilote := 10;
  LMode := 276;
  InitGraph(LPilote, LMode, '');
  SetBkColor(CDarkSlateGray);
  ClearDevice;
  SetColor(CLightYellow);
  
  LRayon := GetMaxY div 3;
  PieSlice(GetMaxX div 2, GetMaxY div 2, CAngle1, CAngle2, LRayon);
  
  ReadKey;
  CloseGraph;
end.

