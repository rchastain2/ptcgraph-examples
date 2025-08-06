
program Rectangle2;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors24;

procedure carres(x, y, a: real; n: byte);
begin
  Rectangle(Round(x - a / 2), Round(y - a / 2), Round(x + a / 2), Round(y + a / 2));
  if n > 1 then
  begin
    carres(x, y - 3 * a / 2, a / 2, n - 1);
    carres(x, y + 3 * a / 2, a / 2, n - 1);
    carres(x - 3 * a / 2, y, a / 2, n - 1);
    carres(x + 3 * a / 2, y, a / 2, n - 1);
  end;
end;

var
  p, m: smallint;

begin
  p := 10;
  m := 277;
  InitGraph(p, m, 'c:\bp\bgi');
  SetColor(cYellow);
  carres(GetMaxX / 2, GetMaxY / 2, 75, 4);
  ReadKey;
end.

