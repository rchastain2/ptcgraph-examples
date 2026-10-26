program Clock;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;
var
  d, r, r1, r2, rr, k,
    x1, y1, x2, y2, x01, y01: smallint;
  Xasp, Yasp: Word;
begin
              {Инициируем графику}
  d := detect; InitGraph(d, r, '');
  k := GraphResult; if k <> grOK then
    WriteLn(GraphErrorMSG(k))
  else
  begin
    SetColor($FF00FF);
              {Определяем отношение сторон и размеры экрана}
    x1 := GetMaxX div 2;
    y1 := GetMaxY div 2;
    GetAspectRatio(Xasp, Yasp);
              {Вычисляем радиусы:}
    r := round(3 * GetMaxY * Yasp / 8 / Xasp);
    r1 := round(0.9 * r); {Часовые деления}
    r2 := round(0.95 * r); {Минутные деления}
              {Изображаем циферблат}
    Circle(x1, y1, r); {Первая внешняя окружность}

    Circle(x1, y1, round(1.02 * r)); {Вторая окружность}
    for k := 0 to 59 do {Деления циферблата}
    begin
      if k mod 5 = 0 then
        rr := r1 {Часовые деления}
      else
        rr := r2; {Минутные деления}
            {Определяем координаты концов делений}
      x01 := x1 + Round(rr * sin(2 * pi * k / 60));
      y01 := y1 - Round(rr * Xasp * cos(2 * pi * k / 60) / Yasp);
      x2 := x1 + Round(r * sin(2 * pi * k / 60));
      y2 := y1 - Round(r * Xasp * cos(2 * pi * k / 60) / Yasp);
      Line(x01, y01, x2, y2) {Выводим деление}
    end;
            {Готовим вывод стрелок}
    SetWriteMode(XORPut);
    SetLineStyle(SolidLn, 0, ThickWidth);
            {Счетчик минут в одном часе}
            {k = минуты}
    r := 0;
            {Цикл вывода стрелок}
    repeat
      for k := 0 to 59 do if not KeyPressed then
        begin
            {Координаты        часовой      стрелки} x2 :=
            x1 + Round(0.85 * r1 * sin(2 * pi * r / 60 / 12));
          y2 := y1 - Round(0.85 * r1 * Xasp * cos(2 * pi * r / 60 / 12) / Yasp);
            {Координаты минутной стрелки}
          x01 := x1 + Round(r2 * sin(2 * pi * k / 60));
          y01 := y1 - Round(r2 * Xasp * cos(2 * pi * k / 60) / Yasp);
            {Изображаем стрелки}
          Line(x1, y1, x2, y2);
          Line(x1, y1, x01, y01);
          Delay(100); {Для имитации реального темпа нужно установить
        задержку 60000}
            {Для удаления стрелок выводим их еще раз!}
          Line(x1, y1, x01, y01);
          Line(x1, y1, x2, y2);
            {Наращиваем и корректируем счетчик минут в часе}

          inc(r); if r = 12 * 60 then
            r := 0
        end
    until KeyPressed;
    if ReadKey = #0 then k := ord(ReadKey);
    CloseGraph
  end
end.
