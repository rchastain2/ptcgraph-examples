program PaletteLines;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;
var

  d, r, e, N, k, color: smallint;
  Palette: PaletteType;
begin
      {Инициируем графику}
  d := Detect; InitGraph(d, r, ' ');
  e := GraphResult; if e <> grOK then
    WriteLn(GraphErrorMsg(e))
  else
  begin
    SetColor($FF00FF);
      {Выбираем толстые сплошные линии}
    SetLineStyle(SolidLn, 0, ThickWidth);
    GetPalette(Palette); {Текущая палитра}
    for Color := 0 to Palette.Size - 1 do
    begin
      SetColor(Color);
      Line(GetMaxX div 3, Color * 10, 2 * GetMaxX div 3, Color * 10)
    end;
      {Меняем палитру и ждем инициативы пользователя}
    while not KeyPressed do
      for e := 0 to Palette.Size - 1 do
        SetPalette(e, Random(Palette.Size));
    if ReadKey = #0 then d := ord(ReadKey);
    CloseGraph
  end
end.
