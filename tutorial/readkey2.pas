
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcCrt, ptcGraph;

procedure OpenGraph;
var
  gd, gm: smallint;
begin
  gd := VGA;
  gm := VGAHi;
  InitGraph(gd, gm, '');
end;

procedure CheckKeyboard();
var
  c: char;
begin
  if not KeyPressed then
    exit;
  c := ReadKey;
  case c of
    #27: // Esc key
      begin
        CloseGraph;
        Halt;
      end;
    #0:
      begin // Extended keys
        c := ReadKey;
        case c of
          #75: OutText('Left');  // Left key
          #77: OutText('Right'); // Right key
          #72: OutText('Up');    // Up key
          #80: OutText('Down');  // Down key
        end;
      end;
    else
      begin
        OutText(c);
      end;
  end;
end;

begin
  OpenGraph;
  while TRUE do
  begin
    CheckKeyboard();
    Delay(50);
  end;
  CloseGraph;
end.
