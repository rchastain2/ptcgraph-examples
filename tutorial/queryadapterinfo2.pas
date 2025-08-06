
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  SysUtils,
  ptcgraph, ptccrt;

function OpenGraph(const AWidth, AHeight, AColorDepth: integer; const AWindowTitle: string = ''): boolean;
var
  LMI: PModeInfo;
{ http://www.freepascal.ru/article/freepascal/20120215095658/ }
begin
  result := FALSE;
  LMI := QueryAdapterInfo;
  if LMI = nil then
    Exit
  else
    while (LMI <> nil)
    and not result do
      if  (LMI^.MaxX     = Pred(AWidth))
      and (LMI^.MaxY     = Pred(AHeight))
      and (LMI^.MaxColor = 1 shl AColorDepth) then
      begin
        result := TRUE;
        if Length(AWindowTitle) = 0 then
          WindowTitle := Format('ptcGraph driver %d mode %d name %s', [LMI^.DriverNumber, LMI^.ModeNumber, LMI^.ModeName])
        else
          WindowTitle := AWindowTitle;
        InitGraph(LMI^.DriverNumber, LMI^.ModeNumber, '');
      end else
        LMI := LMI^.Next;
end;

begin
  if OpenGraph(320, 200, 24) then
  begin
    SetColor($FFFF00);
    Rectangle(10, 10, GetMaxX - 10, GetMaxY - 10);
    OutTextXY(20, 20, Format('%dx%d', [Succ(GetMaxX), Succ(GetMaxY)]));
    Readkey;
    CloseGraph;
  end;
end.
