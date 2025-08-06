
(* http://pascal.net.ru/SetRGBPalette *)

{ Первый пример иллюстрирует использование SetRGBPalette на системе
  с EGA адаптером. Второй пример показывает, как работает SetRGBPalette
  на системе с VGA адаптером }

{ Пример 1: }

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcCrt, ptcGraph;

type RGBRec = record
  RedV   : Integer;
  GreenV : Integer;
  BlueV  : Integer;
end;
const
  EGAColors : array[0 .. {MaxColors}15] of RGBRec =
    (                                   { имя }   { номер }
    (RedV:$00; GreenV:$00; BlueV:$00),  {Black      EGA  0}
    (RedV:$00; GreenV:$00; BlueV:$FC),  {Blue       EGA  1}
    (RedV:$24; GreenV:$FC; BlueV:$24),  {Green      EGA  2}
    (RedV:$00; GreenV:$FC; BlueV:$FC),  {Cyan       EGA  3}
    (RedV:$FC; GreenV:$14; BlueV:$14),  {Red        EGA  4}
    (RedV:$B0; GreenV:$00; BlueV:$FC),  {Magenta    EGA  5}
    (RedV:$70; GreenV:$48; BlueV:$00),  {Brown      EGA 20}
    (RedV:$C4; GreenV:$C4; BlueV:$C4),  {White      EGA  7}
    (RedV:$34; GreenV:$34; BlueV:$34),  {Gray       EGA 56}
    (RedV:$00; GreenV:$00; BlueV:$70),  {Lt Blue    EGA 57}
    (RedV:$00; GreenV:$70; BlueV:$00),  {Lt Green   EGA 58}
    (RedV:$00; GreenV:$70; BlueV:$70),  {Lt Cyan    EGA 59}
    (RedV:$70; GreenV:$00; BlueV:$00),  {Lt Red     EGA 60}
    (RedV:$70; GreenV:$00; BlueV:$70),  {Lt Magenta EGA 61}
    (RedV:$FC; GreenV:$FC; BlueV:$24),  {Yellow     EGA 62}
    (RedV:$FC; GreenV:$FC; BlueV:$FC)); {Br. White  EGA 63}

var
  Driver, Mode, I : smallint;

begin
  Driver := IBM8514;   { Отключаем автоопределение }
  Mode := IBM8514Hi;
 { Инициализация графики }
  InitGraph(Driver, Mode, 'X:\BP');
 if GraphResult < 0 then
   Halt(1);
 { Обнуляем все компоненты палитры }
 for I := 0 to MaxColors do
    SetRGBPalette(I, 0, 0, 0);
 { Изменяем первые 16 компонентов палитры 8514 }
 for I := 1 to MaxColors do
 begin
    SetColor(I);
    OutTextXY(10, I * 10, 'Press any key');
 end;
 { Возвращаем стандартную EGA палитру }
 for I := 0 to MaxColors do
   with EGAColors[I] do
      SetRGBPalette(I, RedV, GreenV, BlueV);
  ReadKey;
  CloseGraph;
end.

