{ BAR_GRAPH.PAS                                                     }
{ Nahodne generovany bargraf urceny pre pouzitie v programe.        }
{ V premenej count je pocet stlpcov, v poli value jednotlive hodnoty}
{                                                                   }
{ Date  : 05.01.2009                           http://www.trsek.com }

program bar_graph;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph,
  ptcCrt,
  Colors16;

const
  MAX_COUNT = 30;

var
  grDriver: smallint;
  grMode: smallint;
  value: array[1..MAX_COUNT] of integer;
  count: integer;
  i: integer;
  stepx: integer;
  stepy: real;
  max: integer;

procedure OpenGraph;
var
  ErrCode: Integer;
begin
  grDriver := VESA;
  grMode := m800x600x64k;
  InitGraph(grDriver, grMode, '');
  ErrCode := GraphResult;

  if (ErrCode <> grOk) then
  begin
    Writeln('Error ', GraphErrorMsg(ErrCode));
    halt(1);
  end;

  SetBkColor(CDarkSlateGray);
  ClearDevice;
  SetColor(COrange);
end;

function MakeAxis(x1, x2: integer; y1, y2: integer): real;
var
  maxx, maxy: integer;
  step: real;
begin
  maxx := GetMaxX;
  maxy := GetMaxY;

  line(1, maxy div 2, maxx, maxy div 2);
  line(20, 1, 20, maxy);

  step := ((maxy - 20) / 2) / (y2 - y1);
  MakeAxis := step;
end;

function ToStr(i: integer): string;
var
  s: string;
begin
  Str(i, s);
  ToStr := s;
end;

begin
  Randomize;

  count := Random(20) + 11;

  for i := 1 to count do
    value[i] := random(100);

  max := value[1];
  for i := 1 to count do
    if (max < value[i]) then
      max := value[i];

  OpenGraph;
  stepy := MakeAxis(0, count, 0, max);
  stepx := (GetMaxX - 40) div count;
  setfillstyle(XHatchFill, Red);

  for i := 1 to count do
  begin
    bar3d(20 + ((i - 1) * stepx), (GetMaxY div 2),
      20 + (i * stepx), (GetMaxY div 2) - round(stepy * value[i]),
      0, TopOn);

    Outtextxy(20 + ((i - 1) * stepx) + (stepx div 2), GetMaxY div 2 + 20,
      ToStr(value[i]));
  end;

  ReadKey;
  CloseGraph;
end.
