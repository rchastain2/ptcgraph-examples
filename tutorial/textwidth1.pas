
program textwidth1;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;
  
var
  driver, mode: smallint;
  color: byte;
  x, y, w, h: smallint;
  index: string;
  left, top: smallint;
begin
  driver := d8bit;
  mode := m640x480;
  InitGraph(driver, mode, '');
  SetColor(0);
  w := 40;
  h := 30;
  for color := 0 to 255 do
  begin
    x := color mod 16;
    y := color div 16;
    x := w * x;
    y := h * y;
    SetFillStyle(SolidFill, color);
    Bar(x, y, x + w, y + h);
    Str(color, index);
    left := (w - TextWidth(index)) div 2;
    top := (h - TextHeight(index)) div 2;
    OutTextXY(x + left, y + top, index);
  end;
  ReadKey;
  CloseGraph;
end.


