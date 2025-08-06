
program demo16;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  SysUtils, PtcGraph, PtcCrt;

function StringToWord(const s: string): word;
var
  i: integer;
  w: word;
begin
  result := 0;
  for i := 0 to 15 do
    if s[16 - i] > '0' then
    begin
      w := 1;
      result := result or (w shl i);
    end;
end;

var
  d, m: smallInt;
  c: word;
 
begin
  d := VESA;
  m := m640x480x64k; // 65536 couleurs
 
  InitGraph(d, m, 'Hello');
 
  SetColor($FFFF);
  OutTextXY(10, 10, IntToStr(GetMaxX + 1) + 'x' + IntToStr(GetMaxY + 1) + 'x' + IntToStr(GetMaxColor + 1));
 
  c := StringToWord('11111' + '000000' + '00000');
  SetFillStyle(SolidFill, c);
  Bar(100, 100, 240, 380);
 
  c := StringToWord('00000' + '111111' + '00000');
  SetFillStyle(SolidFill, c);
  Bar(250, 100, 390, 380);
 
  c := StringToWord('00000' + '000000' + '11111');
  SetFillStyle(SolidFill, c);
  Bar(400, 100, 540, 380);
 
  ReadKey;
  CloseGraph;
end.
