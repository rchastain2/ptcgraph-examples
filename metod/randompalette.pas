program RandomPalette;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;
var
  Palette: PaletteType;
  d, r, e, k: smallint;
begin

            {Инициируем графику}
  d := Detect; InitGraph(d, r, '');
  e := GraphResult; if e <> grOk then
    WriteLn(GraphErrorMsg(e))
  else
  begin
            {Выбираем толстые сплошные линии}
    SetLineStyle(SolidLn, 0, ThickWidth);
            {Выводим линии всеми доступными цветами}
    for k := 1 to GetMaxColor do
    begin
      SetColor(k);
      Line(GetMaxX div 3, k * 10, 2 * GetMaxX div 3, k * 10)
    end;
    Palette.Size := MaxColors + 1; {Размер палитры}
    repeat {Цикл смены палитры}
      for k := 1 to MaxColors do
        with Palette.Colors[k] do
        begin
          Red := Random(256);
          Green := Random(256);
          Blue := Random(256)
        end;
      SetAllPalette(Palette)
    until KeyPressed;
    if ReadKey = #0 then k := ord(ReadKey);
    CloseGraph
  end
end.
