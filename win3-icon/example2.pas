program example2;

{$MODE objfpc}{$H+}

uses
  win3icon;

var
  LIcon: TWin3Icon;
  i, x, y: integer;
  LError: TIconError;

begin
  ClearIcon(LIcon);

  for i := 0 to IconColorCount - 1 do
    with LIcon.Palette[i] do
    begin
      Red := i * 17;
      Green := i * 8;
      Blue := 255 - i * 17;
    end;

  for y := 0 to IconHeight - 1 do
    for x := 0 to IconWidth - 1 do
      LIcon.Pixels[y, x] := (x + y) * IconColorCount div (IconWidth + IconHeight - 1);

  LError := SaveIcon('example2.ico', LIcon);
  if LError <> ieNone then
    WriteLn(IconErrorText(LError));
end.
