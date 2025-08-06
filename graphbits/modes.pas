program Coolness;
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcCrt,
  ptcGraph,
  GraphBits;
var
  GD, GM: smallint;
begin
  Randomize;
  GD := CGA;
  GM := 0;
  InitGraph(GD, GM, 'C:\TP\BGI');
  OutTextXY(10, 10, 'Current mode is ' + GetModeName(GM));
  repeat
    SetColor(Random(15));
    Circle(Random(GetMaxX), Random(GetMaxY), Random(50));
  until KeyPressed;
  ReadKey;
  GD := CGA;
  GM := 1;
  InitGraph(GD, GM, 'C:\TP\BGI');
  OutTextXY(10, 10, 'Current mode is ' + GetModeName(GM));
  repeat
    SetColor(Random(15));
    Circle(Random(GetMaxX), Random(GetMaxY), Random(50));
  until KeyPressed;
  ReadKey;
  GD := CGA;
  GM := 2;
  InitGraph(GD, GM, 'C:\TP\BGI');
  OutTextXY(10, 10, 'Current mode is ' + GetModeName(GM));
  repeat
    SetColor(Random(15));
    Circle(Random(GetMaxX), Random(GetMaxY), Random(50));
  until KeyPressed;
  ReadKey;
  GD := CGA;
  GM := 3;
  InitGraph(GD, GM, 'C:\TP\BGI');
  OutTextXY(10, 10, 'Current mode is ' + GetModeName(GM));
  repeat
    SetColor(Random(15));
    Circle(Random(GetMaxX), Random(GetMaxY), Random(50));
  until KeyPressed;
  ReadKey;
  GD := CGA;
  GM := 4;
  InitGraph(GD, GM, 'C:\TP\BGI');
  OutTextXY(10, 10, 'Current mode is ' + GetModeName(GM));
  repeat
    SetColor(Random(15));
    Circle(Random(GetMaxX), Random(GetMaxY), Random(50));
  until KeyPressed;
  ReadKey;
  CloseGraph;
  GD := VGA;
  GM := 0;
  InitGraph(GD, GM, 'C:\TP\BGI');
  OutTextXY(10, 10, 'Current mode is ' + GetModeName(GM));
  repeat
    SetColor(Random(15));
    Circle(Random(GetMaxX), Random(GetMaxY), Random(50));
  until KeyPressed;
  ReadKey;
  GD := VGA;
  GM := 1;
  InitGraph(GD, GM, 'C:\TP\BGI');
  OutTextXY(10, 10, 'Current mode is ' + GetModeName(GM));
  repeat
    SetColor(Random(15));
    Circle(Random(GetMaxX), Random(GetMaxY), Random(50));
  until KeyPressed;
  ReadKey;
  GD := VGA;
  GM := 2;
  InitGraph(GD, GM, 'C:\TP\BGI');
  OutTextXY(10, 10, 'Current mode is ' + GetModeName(GM));
  repeat
    SetColor(Random(15));
    Circle(Random(GetMaxX), Random(GetMaxY), Random(50));
  until KeyPressed;
  ReadKey;
  CloseGraph;
  ReadKey;
  GD := IBM8514;
  GM := 0;
  InitGraph(GD, GM, 'C:\TP\BGI');
  OutTextXY(10, 10, 'Current mode is ' + GetModeName(GM));
  repeat
    SetColor(Random(15));
    Circle(Random(GetMaxX), Random(GetMaxY), Random(50));
  until KeyPressed;
  ReadKey;
  CloseGraph;
end.
