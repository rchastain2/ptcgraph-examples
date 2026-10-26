program StarrySky;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;
type
  PixelType = record
    x, y: integer;
  end;
const
  N = 5000; {Количество "звезд"}
var
  d, r, e, k: smallint;
  x1, y1, x2, y2: Integer;
  a: array[1..N] of PixelType; {Координаты}
begin

      {Инициируем графику}
  d := Detect; InitGraph(d, r, '');
  e := GraphResult; if e <> grOk then
    WriteLn(GraphErrorMsg(e))
  else
  begin
    SetColor($FF00FF);
      {Создаем окно в центре экрана}
    x1 := GetMaxX div 4;
    y1 := GetMaxY div 4;
    x2 := 3 * x1;
    y2 := 3 * y1;
    Rectangle(x1, y1, x2, y2);
    SetViewPort(x1 + 1, y1 + 1, x2 - 1, y2 - 1, ClipOn);
      {Создаем и запоминаем координаты всех "звезд"}
    for k := 1 to N do with a[k] do
      begin
        x := Random(x2 - x1);
        y := Random(y2 - y1)
      end;
      {Цикл вывода}
    repeat
      for k := 1 to N do
        with a[k] do {Зажигаем "звезду"}
          PutPixel(x, y, {white} $FFFFFF);
      if not KeyPressed then
        for k := N downto 1 do with a[k] do {Гасим "звезду"}
            PutPixel(x, y, {black} 0)
    until KeyPressed;
    while KeyPressed do k := ord(ReadKey);
    CloseGraph
  end;
end.
