
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors16;
  
var
  d, m: smallint;
  
begin
  d := VESA;
  m := m640x480x64k;
  InitGraph(d, m, '');
  
  Randomize;
  
  SetBkColor(cDarkSlateGray);
  SetColor(cYellow);
  ClearDevice;
  
  MoveTo(Random(GetMaxX), Random(GetMaxY));
  repeat
    SetColor(Random(GetMaxColor + 1));
    LineTo(Random(GetMaxX + 1), Random(GetMaxY + 1));
  until KeyPressed;
  
  CloseGraph;
end.
