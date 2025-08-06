
{ http://www.freepascal.ru/article/freepascal/20120215095658/ }

uses
{$IFDEF unix}
  CThreads,
{$ENDIF}
  ptcGraph,
  ptcCrt;

var
  Driver, Mode: SmallInt;

begin
  DetectGraph(Driver, Mode);
  WriteLn('Драйвер: ', Driver, ', Графический режим: ', Mode);
  InitGraph(Driver, Mode, '');
  WriteLn('Разрешение: ', GetMaxX + 1, 'x', GetMaxY + 1, ', Цветов: ', GetMaxColor + 1);
  ReadKey;
  CloseGraph;
end.
