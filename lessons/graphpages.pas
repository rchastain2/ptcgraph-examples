program GraphPages;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;
var
  d, m, e: smallint;
  s: string;
begin
  d := Detect; InitGraph(d, m, '');
  e := GraphResult; if e <> grOk then
    WriteLn(GraphErrorMsg(e))
  else {Нет  ошибки.  Проверяем,  поддерживает  ли  драйвер
    многостраничную работу с видеопамятью:}
    if {d in [HercMono,EGA,EGA64,MCGA,VGA]}  TRUE then
    begin {Используем многостраничный режим}
      (*
      if d<>HercMono then
      SetGraphMode(m-1);
      *)
      SetColor($FF00FF);
      {Заполняем видимую страницу}
      Rectangle(10, 10, GetMaxX div 2, GetMaxY div 2);
      OutTextXY(0, 0, 'Page 0. Press Enter...');
      {Заполняем невидимую}
      SetActivePage(1);
      Circle(GetMaxX div 2, GetMaxY div 2, 100);
      OutTextXY(0, GetMaxY - 10, 'Page 1. Press Enter...');
      {Демонстрируем страницы}
      ReadKey;
      SetVisualPage(1);
      ReadKey;
      SetVisualPage(0);
      ReadKey;
      CloseGraph
    end
    else
    begin {Драйвер не поддерживает многостраничный режим}
      s := GetDriverName; CloseGraph;
      WriteLn('Адаптер ', s, ' использует только 1 страницу')
    end
end.
