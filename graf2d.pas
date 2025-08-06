
program graf2d;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors16;

const
  pockrok = 360;
  c_move = 50;
  os_x = 320;
  os_y = 240;

var
  i, ix, iy: integer;
  krokeps, krokx, kroky: integer;
  xx, yy, epsilon: single;

function FuncX(i: integer): integer;
var
  t: single;
  xx: single;
begin
  t := i * 2 * pi / 360;
  xx := 6 * (4 + sin(t) + 3 * cos(t) - 0.7 * sin(2 * t) + 0.8 * cos(15 * t) + 0.3 * abs(cos(30 * t))) * cos(t) - 15;
  FuncX := os_x + round((xx / c_move) * 240);
end;

function FuncY(i: integer): integer;
var
  t: single;
  yy: single;
begin
  t := i * 2 * pi / 360;
  yy := 6 * (6 + sin(t) + 3 * cos(t) - 0.9 * sin(2 * t) + 0.3 * cos(15 * t) + 0.3 * abs(cos(30 * t))) * sin(t);
  FuncY := os_y - round((yy / c_move) * 240);
end;

procedure Oskriz(farba: longword);
begin
  SetColor(farba);
  SetLineStyle(SolidLn, 0, NormWidth);
  Line(0, os_y, GetMaxX, os_y);
  Line(os_x, 0, os_x, GetMaxY);
end;

procedure SetGraf(farba: longword; thickness: word);
begin
  SetColor(farba);
  SetLineStyle(SolidLn, 0, thickness);
end;

var
  gd, gm: smallint;
begin
  gd := D8bit;
  gm := m640x480;

  InitGraph(gd, gm, '');
  if GraphResult <> grOk then halt(1);

  SetBkColor(cWhite);
  ClearDevice;

  epsilon := 5;
  krokeps := round(c_move / epsilon);

  for krokx := -krokeps to krokeps do
    for kroky := -krokeps to krokeps do
    begin
      xx := (epsilon / 2) + epsilon * krokx;
      yy := (epsilon / 2) + epsilon * kroky;
      ix := round((xx / c_move) * 240);
      iy := round((yy / c_move) * 240);
      if (GetPixel(os_x + ix, os_y - iy) = cGreen) then
        PutPixel(os_x + ix, os_y - iy, cTangerine)
      else
        PutPixel(os_x + ix, os_y - iy, cDarkTangerine)
    end;

  SetGraf(cOrange, NormWidth);

  for krokx := -krokeps to krokeps + 1 do
  begin
    xx := epsilon * krokx;
    ix := round((xx / c_move) * 240);
    Line(os_x + ix, 0, os_x + ix, GetMaxY);
  end;

  for kroky := -krokeps to krokeps do
  begin
    yy := epsilon * kroky;
    iy := round((yy / c_move) * 240);
    Line(0, os_y - iy, GetMaxX, os_y - iy);
  end;

  Oskriz(cDarkOrange);

  SetGraf(cDarkGray, NormWidth);
  MoveTo(FuncX(0), FuncY(0));
  for i := 0 to pockrok do
    LineTo(FuncX(i), FuncY(i));

  ReadKey;
  CloseGraph;
end.

