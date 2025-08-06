
program Klavier;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;

procedure OrgelKlavier(x, y: integer; aantal: byte);
const
  toets: array[1..5] of integer = (5, 22, 56, 73, 90);
var
  pp, z, p: integer;
begin
  for pp := 1 to aantal do
  begin
    for p := 1 to 8 do
    begin
      setcolor(15); for z := y to y + 60 do line(x, z, x + 15, z);
      putpixel(x, y + 60, 0);
      putpixel(x + 15, y + 60, 0);
      inc(x, 17);
    end;
    dec(x, 131);
    for p := 1 to 5 do
    begin
      setcolor(8); for z := y to y + 40 do line(x + toets[p], z, x + toets[p] + 11, z);
      setcolor(0);
      rectangle(x + toets[p] + 1, y, x + toets[p] + 12, y + 40);
      setcolor(7);
      for z := y + 37 to y + 39 do line(x + toets[p] + 2, z, x + toets[p] + 11, z);
    end;
    inc(x, 114);
  end;
end;

var
  grDriver: SmallInt;
  grMode: SmallInt;
  ErrCode: Integer;

begin
  grDriver := VGA;
  grMode := VGAHi;
  InitGraph(grDriver, grMode, ' ');
  ErrCode := GraphResult;
  if ErrCode = grOk then
  begin
    OrgelKlavier(1, 100, 3);
    ReadKey;
  end else
    WriteLn(ErrOutput, GraphErrorMsg(ErrCode));
end.
