
program Squares2;

uses
{$IFDEF UNIX}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors16;

procedure Square(x, y, a: double; n: integer);
begin
  Rectangle(Round(x - a / 2), Round(y - a / 2), Round(x + a / 2), Round(y + a / 2));
  if n > 1 then
  begin
    Square(x, y - 3 * a / 2, a / 2, n - 1);
    Square(x, y + 3 * a / 2, a / 2, n - 1);
    Square(x - 3 * a / 2, y, a / 2, n - 1);
    Square(x + 3 * a / 2, y, a / 2, n - 1);
  end;
end;

var
  p, m: smallint;

begin
  p := VESA;
  m := m640x480x64k;
  InitGraph(p, m, '');
  SetBkColor(cMidnightBlue);
  ClearDevice;
  SetColor(cOrange);
  Square(GetMaxX / 2, GetMaxY / 2, 75, 4);
  ReadKey;
end.


