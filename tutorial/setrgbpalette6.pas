{ Пример 2: }

{ Пример для SetRGBPalette для систем с VGA адаптером в
  режиме 16 цветов }

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcCrt, ptcGraph;

type RGBRec = record
  RedV     : Integer;
  GreenV   : Integer;   { Значения интенсивности (0 .. 63) }
  BlueV    : Integer;
  Name     : String;
  ColorNum : Integer;
    { Палитра VGA, отражённая в палитре 16 цветов }
end;

{ Таблица желаемых цветов для адаптера VGA в режиме 16 цветов }
const Colors : array[0 .. {MaxColors}15] of RGBRec = (
  (RedV:0 ;GreenV:0 ;BlueV:0 ;Name:'Black'        ;ColorNum: 0),
  (RedV:0 ;GreenV:0 ;BlueV:40;Name:'Blue'         ;ColorNum: 1),
  (RedV:0 ;GreenV:40;BlueV:0 ;Name:'Green'        ;ColorNum: 2),
  (RedV:0 ;GreenV:40;BlueV:40;Name:'Cyan'         ;ColorNum: 3),
  (RedV:40;GreenV:7 ;BlueV:7 ;Name:'Red'          ;ColorNum: 4),
  (RedV:40;GreenV:0 ;BlueV:40;Name:'Magenta'      ;ColorNum: 5),
  (RedV:40;GreenV:30;BlueV:0 ;Name:'Brown'        ;ColorNum: 20),
  (RedV:49;GreenV:49;BlueV:49;Name:'Light Gray'   ;ColorNum: 7),
  (RedV:26;GreenV:26;BlueV:26;Name:'Dark Gray'    ;ColorNum: 56),
  (RedV: 0;GreenV:0 ;BlueV:63;Name:'Light Blue'   ;ColorNum: 57),
  (RedV: 9;GreenV:63;BlueV:9 ;Name:'Light Green'  ;ColorNum: 58),
  (RedV: 0;GreenV:63;BlueV:63;Name:'Light Cyan'   ;ColorNum: 59),
  (RedV:63;GreenV:10;BlueV:10;Name:'Light Red'    ;ColorNum: 60),
  (RedV:44;GreenV:0 ;BlueV:63;Name:'Light Magenta';ColorNum: 61),
  (RedV:63;GreenV:63;BlueV:18;Name:'Yellow'       ;ColorNum: 62),
  (RedV:63;GreenV:63;BlueV:63;Name:'White'        ;ColorNum: 63));

var
  Driver, Mode, I, Error : smallint;
begin
 { Инициализируем графику }
  Driver := VGA;
  Mode := VGAHi;
  InitGraph(Driver, Mode, 'X:\BP');
  Error := GraphResult;
 if Error <> GrOk then
 begin
   WriteLn(GraphErrorMsg(Error));
   Halt(1);
 end;
  SetFillStyle(SolidFill, Green);
  Bar(0, 0, GetMaxX, GetMaxY);
 if GraphResult < 0 then
   Halt(1);
 { Обнуляем палитру }
  SetRGBPalette(Colors[0].ColorNum, 63, 63, 63);
 for I := 1 to 15 do
   with Colors[I] do
      SetRGBPalette(ColorNum, 0, 0, 0);

 { Выводим название цвета, используя сам цвет }

 { Заметьте, что с данными установками палитры, только слова "Press
   any key...", "Black", "Light Gray" и "White" являются видимыми.
   Это происходит потому, что компонент палитры номер 0 (Black)
   установлен на белый цвет. Слова "Light Gray" и "White" выводятся
   на цвете 0 в качестве фона }

  SetColor(0);
  OutTextXY(0, 10, 'Press Any Key...');
 for I := 0 to 15 do
   with Colors[I] do
   begin
      SetColor(I);
      SetFillStyle(SolidFill, (I xor 15) and 7);
     { "(I xor 15)" даёт нам цвет фона }
     { " and 7" уменьшает интенсивность фона }
      Bar(10, (I + 2) * 10 - 1, 10 + TextWidth(Name),
              (I + 2) * 10 + TextHeight(Name) - 1);
      OutTextXY(10, (I + 2) * 10, Name);
   end;
  ReadKey;

{ Восстанавливаем стандартные цвета палитры. Они могут зависеть от
  установок по умолчанию, используемых вашей видеосистемой }

 for I := 0 to 15 do
   with Colors[I] do
      SetRGBPalette(ColorNum, RedV, GreenV, BlueV);
 { Ждём нажатия на клавишу, закрываем графику и выходим }
  ReadKey;
  CloseGraph;
end.
