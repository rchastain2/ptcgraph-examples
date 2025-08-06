
program demo16;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  PtcGraph, PtcCrt;
 
function RGBToWord(r, g, b: byte): word;
begin
  if r > 31 then r := 31;
  if g > 63 then g := 63;
  if b > 31 then b := 31;
  result := (r shl 11) or (g shl 5) or b;
end;
 
var
  d, m: smallInt;
  c: word;
  i: byte;
 
begin
  d := 10;    // 640 x 480
  m := $0111; // 65536 couleurs
  InitGraph(d, m, '');
 
  for i := 0 to 31 do
  begin
    c := RGBToWord(i, 0, 0);
    SetFillStyle(SolidFill, c);
    Bar(016, i * (448 div 32) + 16, 208, (i + 1) * (448 div 32) + 16);
  end;
 
  for i := 0 to 63 do
  begin
    c := RGBToWord(0, i, 0);
    SetFillStyle(SolidFill, c);
    Bar(224, i * (448 div 64) + 16, 416, (i + 1) * (448 div 64) + 16);
  end;
 
  for i := 0 to 31 do
    begin
    c := RGBToWord(0, 0, i);
    SetFillStyle(SolidFill, c);
    Bar(432, i * (448 div 32) + 16, 624, (i + 1) * (448 div 32) + 16);
  end;
 
  ReadKey;
  CloseGraph;
end.
