
program putpixel1;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors24;
  
var
  gd, gm: smallint;
  t: text;
  s: string;
  x, y, p: integer;
  
begin
  gd := 10;
  gm := 536; { 10 536 832x624 16777216 832 x 624 VESA }
  InitGraph(gd, gm, '');
  if GraphResult = grOk then
  begin
    SetBkColor(cDarkOrange);
    ClearDevice;
    Assign(t, 'warlord.txt');
    Reset(t);
    x := 0;
    y := 0;
    while not EOF(t) do
    begin
      ReadLn(t, s);
      if Length(s) = 48 then
        for p := 1 to 48 do
          case s[p] of
            '0': PutPixel(Pred(p) + x, y, cForestGreen);
            '1': PutPixel(Pred(p) + x, y, cLightGray);
            '2': PutPixel(Pred(p) + x, y, cDarkGray);
          end;
      Inc(y);
      if y = 48 then
      begin
        Inc(x, 48);
        y := 0;
      end;
    end;
    Close(t);
    ReadKey;
    CloseGraph;
  end;
end.


