{ SEMAFOR.PAS               Copyright (c) TrSek alias Zdeno Sekerak }
{ Program simuluje semafor z F1.                                    }
{ Potrebuje graficku kniznicu egavga.bgi.                           }
{                                                                   }
{ Datum:30.05.2004                             http://www.trsek.com }

program semafor;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph,
  ptcCrt,
  Colors24;

var
  gd, gm: smallint;
  x, y: integer;

  { inicializuje grafiku }

procedure InitGrafika;
begin
  Gd := Detect;
  InitGraph(Gd, Gm, '');
  if GraphResult <> grOk then
  begin
    WriteLn('Nieje mozne inicializovat grafiku asi chyba subor EgaVga.bgi');
    Halt(1);
  end;
end;

{ vyplni kruh na suradniciach pozadovanou farbou }

procedure Vypln(x1, y1: integer; color: integer);
var
  x, y: integer;
  xd, yd: integer;
begin
  xd := GetMaxX div 16;
  yd := GetMaxY div 16;

  x := (5 * xd) * (x1 - 1) + xd;
  y := (5 * yd) * (y1 - 1) + yd;

  SetColor(color);
  Circle(x + (2 * xd), y + (2 * yd), 2 * yd - 10);

  SetFillStyle(SolidFill, color);
  FloodFill(x + (2 * xd), y + (2 * yd), color);
end;

{ urobi stvorec na suradniciach }

procedure KresliKruh(x1, y1: integer; color: integer);
var
  x, y: integer;
  xd, yd: integer;
begin
  xd := GetMaxX div 16;
  yd := GetMaxY div 16;

  x := (5 * xd) * (x1 - 1) + xd;
  y := (5 * yd) * (y1 - 1) + yd;

  SetFillStyle(XHatchFill, cLightGray);
  SetColor(cDarkGray);
  Bar3d(x, y, x + (4 * xd), y + (4 * yd), 0, true);

  Vypln(x1, y1, color);
end;

{ vykresli 3 kruhy vedla seba a pocka tim milisekund }

procedure PruhBlik(y: integer; color: integer; tim: integer);
var
  i: integer;
begin
  for i := 1 to y do
  begin
    Vypln(1, i, color);
    Vypln(2, i, color);
    Vypln(3, i, color);
  end;
  Delay(tim);
end;

begin
  InitGrafika;

  { najprv vsetko v sedom }
  for x := 1 to 3 do
    for y := 1 to 3 do
      KresliKruh(x, y, cDarkGray);

  { prva cervena }
  for y := 1 to 3 do
  begin
    PruhBlik(1, cRed, 500);
    PruhBlik(1, cDarkGray, 300);
  end;

  { druha magenta }
  for y := 1 to 3 do
  begin
    PruhBlik(2, cDarkOrange, 500);
    PruhBlik(2, cDarkGray, 300);
  end;

  { nakoniec zelena }
  PruhBlik(3, cGreen, 500);

  OutTextXY(40, GetMaxY - 10, 'Koniec - stlac Enter');

  ReadKey;
  CloseGraph;
end.
