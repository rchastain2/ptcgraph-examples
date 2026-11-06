
program aggdemo32;

{$MODE objfpc}{$H+}

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph,
  ptcCrt,
  agg_2D;

const
  IMAGE_WIDTH = 800;
  IMAGE_HEIGHT = 600;

type
  TGraphBitmap = packed record
    Width, Height, Reserved: longint;
    Data: array[0..IMAGE_WIDTH * IMAGE_HEIGHT - 1] of longword;
  end;

var
  Bitmap: TGraphBitmap;

procedure Draw(agg: Agg2D_ptr);
var
  c1, c2: Color;
  i: integer;
  a: double;
begin
  agg^.clearAll(245, 240, 225);

  agg^.noLine;
  agg^.fillColor(230, 40, 40, 140);
  agg^.ellipse(180, 170, 110, 110);
  agg^.fillColor(40, 180, 40, 140);
  agg^.ellipse(270, 170, 110, 110);
  agg^.fillColor(40, 80, 230, 140);
  agg^.ellipse(225, 250, 110, 110);

  c1.Construct(255, 230, 60, 255);
  c2.Construct(230, 90, 0, 255);
  agg^.lineColor(120, 50, 0);
  agg^.lineWidth(3);
  agg^.fillRadialGradient(570, 200, 130, c1, c2);
  agg^.star(570, 200, 55, 130, Deg2Rad(-90), 5);

  c1.Construct(60, 120, 200, 255);
  c2.Construct(200, 230, 255, 255);
  agg^.lineColor(30, 60, 120);
  agg^.lineWidth(2);
  agg^.fillLinearGradient(80, 400, 80, 540, c1, c2);
  agg^.roundedRect(80, 400, 360, 540, 25);

  agg^.noFill;
  agg^.lineCap(CapRound);
  agg^.lineColor(150, 0, 120, 220);
  agg^.lineWidth(12);
  agg^.resetPath;
  agg^.moveTo(420, 540);
  agg^.cubicCurveTo(480, 330, 640, 640, 740, 400);
  agg^.drawPath(StrokeOnly);

  agg^.lineWidth(1);
  agg^.lineColor(0, 0, 0, 200);
  for i := 0 to 36 do
  begin
    a := Deg2Rad(i * 2.5);
    agg^.line(420, 300, 420 + 330 * Cos(a), 300 + 330 * Sin(a) * 0.3);
  end;
end;

procedure DrawAndDisplay;
var
  agg: Agg2D_ptr;
begin
  New(agg, Construct);
  agg^.attach(@Bitmap.Data, IMAGE_WIDTH, IMAGE_HEIGHT, IMAGE_WIDTH * SizeOf(longword));
  Draw(agg);
  Dispose(agg, Destruct);

  Bitmap.Width := IMAGE_WIDTH;
  Bitmap.Height := IMAGE_HEIGHT;
  PutImage(0, 0, Bitmap, NormalPut);
end;

var
  gd, gm: smallint;

begin
  gd := VESA;
  gm := m800x600x16m;
  WindowTitle := 'AggPas without patch';
  InitGraph(gd, gm, '');
  if GraphResult <> grOk then
    Halt(1);
  DrawAndDisplay;
  ReadKey;
  CloseGraph;
end.
