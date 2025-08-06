
program settextstyle2;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;
  
const
  t = 'Hello ptcGraph';
  
var
  d, m: smallint;
  e, w, h: integer;
  
begin
  d := d8bit;
  m := m640x480;
  InitGraph(d, m, '');
  e := GraphResult;
  if not (e = grOk) then
    Halt(1);
  SetBkColor(LightGray);
  ClearDevice;
  SetColor(Blue);
  Rectangle(10, 10, GetMaxX - 10, GetMaxY - 10);
  SetTextStyle(defaultFont, horizDir, 2);
  w := TextWidth(t);
  h := TextHeight(t);
  OutTextXY(
    (GetMaxX - w) div 2,
    (GetMaxY - h) div 2,
    t
  );
  ReadKey;
  CloseGraph;
end.
