
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  SysUtils, ptcGraph, ptcCrt;

var
  p: PModeInfo; (* http://www.freepascal.ru/article/freepascal/20120215095658/ *)

begin
  p := QueryAdapterInfo;
  while p <> nil do
  begin
    WriteLn(Format('%2d | %3d | %4dx%d | %8d | %18s', [
      p^.DriverNumber,
      p^.ModeNumber,
      p^.MaxX + 1,
      p^.MaxY + 1,
      p^.MaxColor,
      p^.ModeName
    ]));
    p := p^.Next;
  end;
end.
