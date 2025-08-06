uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;

var
  gd, gm: smallint;
  i: integer;
  s: string;

begin
  gd := VGA;
  gm := VGAMed;
  initGraph(gd, gm, 'c:\bp\bgi');
  {
  for i:=1 to 15 do begin
    setPalette(i, i); (* THIS IS THE FIX *)
    setRGBPalette(i, 0, 0, 0);
  end;
  }
  for i:=1 to 15 do begin
    setColor(i);
    str(i, s);
    outTextXY(100, 10 + 12*i, 'color = ' + s);
  end;

  readkey;
end.
