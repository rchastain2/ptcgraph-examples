 
program txt2pas;

uses
  SysUtils, Classes, RegExpr;

var
  list: TStringList;
  expr1, expr2: TRegExpr;
  i, j: integer;
  w, h: integer;
  
begin
  list := TStringList.Create;
  expr1 := TRegExpr.Create('# ImageMagick pixel enumeration: (\d+),(\d+),0,255,srgb');
  expr2 := TRegExpr.Create('#([\dA-H]{6})');
  
  list.LoadFromFile(ParamStr(1));
  
  if expr1.Exec(list[0]) then
  begin
    w := StrToInt(expr1.Match[1]);
    h := StrToInt(expr1.Match[2]);
  end else
    Exit;
  
  for i := 1 to Pred(list.Count) do
    if expr2.Exec(list[i]) then
    begin
      j := Pred(i) mod w;
      
      if j = 0 then Write('  (') else Write(', ');
      
      Write('$', expr2.Match[1]);
      
      if j = w - 1 then
      begin
        Write(')');
        if i < Pred(list.Count) then
          WriteLn(',')
        else
          WriteLn;
      end;
    end;
  
  list.Free;
  expr1.Free;
  expr2.Free;
end.
