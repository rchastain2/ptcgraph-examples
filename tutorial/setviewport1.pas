
program setviewport1;

{ http://codingrus.ru/readarticle.php?article_id=2525 }

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors24;
  
var
  x, y, e: smallint;
  x11, y11, x12, y12, {Координаты 1-го окна}
  x21, x22, {Левый верхний угол 2-го}
  R, {Начальный радиус}
  k: Integer;
  
begin
  DirectVideo := False; {Блокируем прямой доступ к видеопа-мяти в модуле CRT}
{Инициируем графический режим}
  x := {Detect}10;
  y := 531;
  InitGraph(x, y, '');
{Проверяем результат}
  e := GraphResult;
  if e <> grOk then
    WriteLn(GraphErrorMsg(e)) {Ошибка}
  else
  begin {Нет ошибки}
    SetBkColor(cOrange);
    SetColor(cBlue);
    ClearDevice;
{Вычисляем координаты с учетом разрешения экрана}
    x11 := GetMaxX div 60;
    x12 := GetMaxX div 3;
    y11 := GetMaxY div 4;
    y12 := 2 * y11;
    R := (x12 - x11) div 4;
    x21 := x12 * 2;
    x22 := x21 + x12 - x11;
{Рисуем окна}
    Rectangle(x11, y11, x12, y12);
    Rectangle(x21, y11, x22, y12);
{Назначаем 1-е окно и рисуем четыре окружности}
    SetViewPort(x11, y11, x12, y12, ClipOn);
    for k := 1 to 4 do
      Circle(0, y11, R * k);
{Назначаем 2-е окно и рисуем окружности}
    SetViewPort(x21, y11, x22, y12, ClipOff);
    for k := 1 to 4 do
      Circle(0, y11, R * k);
{Ждем нажатия любой клавиши}
    if ReadKey = #0 then k := Ord(ReadKey);
    CloseGraph;
  end
end.
