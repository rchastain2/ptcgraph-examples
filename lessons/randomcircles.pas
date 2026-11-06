program RandomCircles;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;
var
  x1, y1, x2, y2, Err: smallint;
begin
{Инициируем графический режим}
  x1 := Detect; InitGraph(x1, x2, '');
  Err := GraphResult; if Err <> grOk then
    WriteLn(GraphErrorMsg(Err))
  else
  begin
{Определяем координаты окна с учетом разрешения экрана}
    x1 := GetMaxX div 4; y1 := GetMaxY div 4;
    x2 := 3 * x1; y2 := 3 * y1;
{Создаем окно}
    Rectangle(x1, y1, x2, y2);
    SetViewPort(x1 + 1, y1 + 1, x2 - 1, y2 - 1, ClipOn);
    SetColor($FF00FF);
{Заполняем окно случайными окружностями}
    repeat
      Circle(Random(GetMaxX), Random(GetMaxY), Random(GetMaxX) div 5);
    until KeyPressed;
{Очищаем окно и ждем нажатия Enter}
    ClearViewPort;
    OutTextXY(0, 0, 'Press Enter...');
    ReadKey;
    CloseGraph
  end
end.
