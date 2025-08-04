
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  SysUtils, ptcGraph, ptcCrt, ColorNames;

const
  W = 1024 div  8;
  H =  768 div 32;
  
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
      
      OutTextXY(
        W * x + (W - TextWidth(cn)) div 2,
        H * y + (H - TextHeight(cn)) div 2,
        cn
      );
    end;
  ReadKey;
end.


