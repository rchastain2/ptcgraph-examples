
program Squares1;

uses
{$IFDEF UNIX}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors16;

procedure Square(x, y, a: double; n: integer);
begin
  Rectangle(Round(x - a / 2), Round(y - a / 2), Round(x + a / 2), Round(y + a / 2));
  if n > 0 then
  begin
    Square(x - a / 2, y - a / 2, a / 2, n - 1);
    Square(x - a / 2, y + a / 2, a / 2, n - 1);
    Square(x + a / 2, y - a / 2, a / 2, n - 1);
    Square(x + a / 2, y + a / 2, a / 2, n - 1);
  end;
end;

var
  p, m: smallint;
  
begin
  p := VESA;
  m := m800x600x64k;
  InitGraph(p, m, '');
  SetBkColor(cMidnightBlue);
  ClearDevice;
  SetColor(cOrange);
  Square(GetMaxX / 2, GetMaxY / 2, 200, 5);
  ReadKey;
end.
