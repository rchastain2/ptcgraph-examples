
var
  i: integer;
  
begin
  for i := 0 to 63 do
    WriteLn(
      '%',
      StringOfChar('0', 63 - i),
      '1',
      StringOfChar('0', i)
    );
end.
