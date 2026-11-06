
program makeconst;

uses
  SysUtils,
  ColorNames;

function To16(AColor: longword): word;
var
  r, g, b: byte;
begin
  r := (AColor shr 16) and $FF;
  g := (AColor shr 8) and $FF;
  b := AColor and $FF;
  result := ((r shr 3) shl 11) or ((g shr 2) shl 5) or (b shr 3);
end;

function FindColor(const AName: string; out AColor: TColorName): boolean;
var
  c: TColorName;
begin
  for c := Low(TColorName) to High(TColorName) do
    if SameText(DATA[c].name, AName) then
    begin
      AColor := c;
      Exit(true);
    end;
  result := false;
end;

var
  Depth, First, i, Width: integer;
  Selected: array of TColorName;
  c: TColorName;
  Value: string;

begin
  Depth := 16;
  First := 1;
  if (ParamCount >= 1) and ((ParamStr(1) = '16') or (ParamStr(1) = '24')) then
  begin
    Depth := StrToInt(ParamStr(1));
    First := 2;
  end;

  if ParamCount >= First then
  begin
    SetLength(Selected, ParamCount - First + 1);
    for i := First to ParamCount do
      if not FindColor(ParamStr(i), Selected[i - First]) then
      begin
        WriteLn(ErrOutput, 'Unknown color: ', ParamStr(i));
        Halt(1);
      end;
  end else
  begin
    SetLength(Selected, Ord(High(TColorName)) + 1);
    for c := Low(TColorName) to High(TColorName) do
      Selected[Ord(c)] := c;
  end;

  Width := 0;
  for c in Selected do
    if Length(DATA[c].name) > Width then
      Width := Length(DATA[c].name);

  WriteLn('const');
  for c in Selected do
  begin
    if Depth = 16 then
      Value := IntToHex(To16(DATA[c].value), 4)
    else
      Value := IntToHex(DATA[c].value, 6);
    WriteLn('  c', DATA[c].name, '': Width - Length(DATA[c].name), ' = $', Value, ';');
  end;
end.
