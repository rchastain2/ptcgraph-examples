
uses
  SysUtils,
  ColorNames;
  
function From32To16(AColor: longint): word;
(* https://forum.lazarus.freepascal.org/index.php/topic,51934.msg382008.html#msg382008 *)
var red, green, blue, red5, green6, blue5: byte;
begin
  red := AColor and $FF;
  green := (AColor shr 8) and $FF;
  blue := (AColor shr 16) and $FF;
  red5 := red shr 3;
  green6 := green shr 2;
  blue5 := blue shr 3;
  result := red5 + (green6 shl 5) + (blue5 shl 11);
end;

var
  c: TColorName;
  w: word;
  s: string;
  l, lmax: integer;
  
begin
  lmax := 0;
  WriteLn('const');
  for c := Low(TColorName) to High(TColorName) do
  begin
    w := From32To16(DATA[c].value);
    s := DATA[c].name;
    l := Length(s);
    if l > lmax then
      lmax := l;
    WriteLn('  c', s, '': 22 - l, ' = $', IntToHex(w, 4), ';');
  end;
  WriteLn('lmax = ', lmax);
end.
