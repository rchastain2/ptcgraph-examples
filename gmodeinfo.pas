
{ http://www.freepascal.ru/article/freepascal/20120215095658/ }

program gmodeinfo;

uses
{$IFDEF unix}
  CThreads,
{$ENDIF}
  SysUtils, ptcGraph;

var
  i: PModeInfo; // Сюда будет заносится информация о видеорежимах
  s: string;

begin
  i := QueryAdapterInfo;
  if i = nil then
    WriteLn('Не удалось получить информацию у видеоадаптера...')
  else
  begin
    WriteLn('№ драйвера № режима Разрешение   Цветов');
    WriteLn('----------------------------------------------------------');
    while {i^.Next}i <> nil do
    begin
      Write(i^.DriverNumber: 10);
      Write(i^.ModeNumber: 9);
      s := IntToStr(i^.MaxX + 1) + 'x' + IntToStr(i^.MaxY + 1);
      Write(s: 11);
      Write(i^.MaxColor: 9);
      WriteLn(i^.ModeName: 19);
      i := i^.Next;
    end;
  end;
end.
