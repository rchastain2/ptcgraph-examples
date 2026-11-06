
program colornamesdemo;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  SysUtils, ptcGraph, ptcCrt, ColorNames;

const
  W = 1024 div  8;
  H =  768 div 32;

function TextColorFor(AColor: longword): longword;
var
  r, g, b: integer;
begin
  r := (AColor shr 16) and $FF;
  g := (AColor shr 8) and $FF;
  b := AColor and $FF;
  if 299 * r + 587 * g + 114 * b > 140000 then
    result := $000000
  else
    result := $FFFFFF;
end;

var
  d, m: smallint;
  x, y: smallint;
  color: longword;
  colorname: TColorName;
  cn: string;

begin
  d := VESA;
  m := m1024x768x16m;
  InitGraph(d, m, '');
  if GraphResult <> grOk then
    Halt(1);
  for y := 0 to 31 do
    for x := 0 to 7 do
    begin
      colorname := TColorName(8 * y + x);

      color := Data[colorname].value;
      SetFillStyle(SolidFill, color);
      Bar(W * x, H * y, W * Succ(x) - 1, H * Succ(y) - 1);

      cn := Data[colorname].name;

      if TextWidth(cn) > W then
      begin
        repeat
          SetLength(cn, Pred(Length(cn)));
        until TextWidth(cn + '...') < W;
        cn := cn + '...';
      end;

      SetColor(TextColorFor(color));
      OutTextXY(
        W * x + (W - TextWidth(cn)) div 2,
        H * y + (H - TextHeight(cn)) div 2,
        cn
      );
    end;
  ReadKey;
  CloseGraph;
end.
