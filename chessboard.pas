
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  SysUtils, ptcCrt, ptcGraph;

procedure OutCharXY(const x, y: integer; const c: char);
begin
  OutTextXY(
    x + (40 - TextWidth(c)) div 2,
    y + (40 - TextHeight(c)) div 2,
    c
  );
end;

var
  d, m: smallint;
  l, c, o, x, y: integer;
  
begin
  d := VESA;
  m := InstallUserMode(400, 400, 16);
  
  if m < 0 then
  begin
    Writeln(ErrOutput, 'Error installing user mode: ', GraphErrorMsg(m));
    Halt(1);
  end;
  
  WindowTitle := 'Chessboard';
  InitGraph(d, m, '');
  
  SetBkColor(White);
  SetColor(Blue);
  ClearViewPort;
  
  Rectangle(39, 39, 360, 360);
  Rectangle(37, 37, 362, 362);
  Rectangle(36, 36, 363, 363);
  
  o := 1;
  
  if o > 0 then
  begin
    for l := 1 to 8 do
    begin
      if o = 1 then
      begin
        OutCharXY(40 * l, 360, Chr(Ord('A') + l - 1));
        OutCharXY(40 * l,   0, Chr(Ord('A') + l - 1));
      end else
      begin
        OutCharXY(40 * l, 360, Chr(Ord('I') - l));
        OutCharXY(40 * l,   0, Chr(Ord('I') - l));
      end;
    end;
    
    for c := 1 to 8 do
    begin
      if o = 1 then
      begin
        OutCharXY(  0, 40 * c, Chr(Ord('9') - c));
        OutCharXY(360, 40 * c, Chr(Ord('9') - c));
      end else
      begin
        OutCharXY(  0, 40 * c, Chr(Ord('0') + c));
        OutCharXY(360, 40 * c, Chr(Ord('0') + c));
      end;
    end;
  end;
  
  for l := 1 to 8 do
    for c := 1 to 8 do
      if (l + c) mod 2 = 1 then
        for x := 0 to 39 do
          for y := 0 to 39 do
            if (x + y) mod 5 = 4 then
              PutPixel(40 * l + x, 40 * c + y, Blue);
  
  ReadKey;
  CloseGraph;
end.
