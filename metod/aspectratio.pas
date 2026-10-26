program AspectRatio;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;
const

  R = 50;
  dx = 1000;
var
  d, m, e, k: smallint;
  Xasp, Yasp: Word;
begin
  d := Detect;
  InitGraph(d, m, '');
  SetColor($FFFFFF);
  e := GraphResult;
  if e <> grOk then
    WriteLn(GraphErrorMsg(e))
  else
  begin
    GetAspectRatio(Xasp, Yasp);
    for k := 0 to 20 do
    begin
      SetAspectRatio(Xasp + k * dx, Yasp);
      Circle(GetMaxX div 2, GetMaxY div 2, R)
    end;
    if ReadKey = #0 then k := ord(ReadKey);
    CloseGraph
  end
end.
