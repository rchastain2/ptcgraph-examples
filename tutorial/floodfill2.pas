
program ex02;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors16;

procedure GrInit;
var
  d, m, e: smallint;
begin
  d := VESA;
  m := m800x600x64k;
  InitGraph(d, m, '');
  e := GraphResult;
  if e <> grOk then
  begin
    WriteLn('Error = ', GraphErrorMsg(e));
    Halt(1);
  end;
end;

const
  cFillStopColor = cRed;
  
var
  x, y, d, r: word;
  
begin
  GrInit;
  SetBkColor(cOrange);
  ClearDevice;
  
  x := GetMaxX div 2;
  y := GetMaxY div 2;
  r := 100;
  d := r - 20;
  SetColor(cFillStopColor);
  Circle(x, y, r);
  Rectangle(x - d, y - d, x + d, y + d);
  SetFillStyle({SlashFill}HatchFill, cGreen);
  FloodFill(x, y, cFillStopColor);
  ReadKey;
  CloseGraph;
end.
