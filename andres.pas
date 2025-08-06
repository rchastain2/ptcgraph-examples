
program Andres;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;

procedure AndresCircle(const cx, cy, r: integer; const cl: colorType);
var
  x, y, d: integer;
begin
  x := 0;
  y := r;
  d := r - 1;
  while y >= x do
  begin
    PutPixel(cx + x, cy + y, cl);
    PutPixel(cx + y, cy + x, cl);
    PutPixel(cx - x, cy + y, cl);
    PutPixel(cx - y, cy + x, cl);
    PutPixel(cx + x, cy - y, cl);
    PutPixel(cx + y, cy - x, cl);
    PutPixel(cx - x, cy - y, cl);
    PutPixel(cx - y, cy - x, cl);
    if d >= x + x then
    begin
      d := d - x - x - 1;
      Inc(x);
    end else
      if d <= r + r - y - y then
      begin
        d := d + y + y - 1;
        Dec(y);
      end else
      begin
        d := d + y + y - x - x - 2;
        Dec(y);
        Inc(x);
      end;
  end;
end;

var
  d, m, e: smallint;
  
begin
  d := VGA;
  m := VGAHi;
  InitGraph(d, m, '');
  
  e := GraphResult;
  if e <> grOk then
  begin
    WriteLn(GraphErrorMsg(e));
    Exit;
  end;
  
  SetBkColor(Black);
  ClearDevice;
  
  AndresCircle(GetMaxX div 2, GetMaxY div 2, GetMaxY div 3, Yellow);
  
  ReadKey;
  CloseGraph;
end.
