program example;

{$MODE objfpc}{$H+}

uses
  win3icon;

var
  LIcon: TWin3Icon;
  x, y: integer;
  LError: TIconError;

begin
  ClearIcon(LIcon);
  for y := 0 to IconHeight - 1 do
    for x := 0 to IconWidth - 1 do
      if Sqr(x - 15.5) + Sqr(y - 15.5) <= Sqr(15.5) then
        LIcon.Pixels[y, x] := 9 + (x + y) div 16
      else
        LIcon.Transparent[y, x] := TRUE;

  LError := SaveIcon('example.ico', LIcon);
  if LError <> ieNone then
    WriteLn(IconErrorText(LError));
end.
