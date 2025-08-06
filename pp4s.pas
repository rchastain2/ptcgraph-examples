
program pp4s;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;
  
const
  HB = 10;
  VB = 10;
  
var
  Gd, Gm: smallint;
  MaxX, MaxY, Col1, Col2, Col3, Row1, Row2, Row3, CentreX, CentreY,
  Count, StartX, StartY, X, Y: integer;
  Pentagon: array[1..12] of word;
  Triangle: array[1..8] of word;

procedure DrawRow1;
begin
  SetColor(Red);
  Rectangle(HB, VB, Col1 - HB, Row1 - VB);
  SetFillStyle(SolidFill, Yellow);
  Bar(Col1 + HB, VB, Col2 - HB, Row1 - VB);
  SetColor(Green);
  CentreX := (Col3 + Col2) div 2;
  CentreY := Row1 div 2;
  Circle(CentreX, CentreY, (Row1 div 2) - VB);
  SetColor(Blue);
  SetFillStyle(SolidFill, Blue);
  CentreX := CentreX + Col1;
  FillEllipse(CentreX, CentreY, (Col1 div 2) - HB, (Row1 div 2) - VB);
end;

procedure DrawRow2;
begin
  SetColor(Cyan);
  Line(HB, Row1 + VB, Col1 - HB, Row2 - VB);
  SetLineStyle(DashedLn, 0, ThickWidth);
  MoveTo(Col1 + HB, Row2 - VB);
  SetColor(Brown);
  LineTo(Col2 - HB, Row1 + VB);
  SetColor(White);
  SetLineStyle(SolidLn, 0, NormWidth);
  CentreX := (Col3 + Col2) div 2;
  CentreY := (Row2 + Row1) div 2;
  Ellipse(CentreX, CentreY, 0, 360, (Col1 div 2) - HB, (Row1 div 2) - VB);
  SetColor(Magenta);
  SetFillStyle(BkSlashFill, Magenta);
  CentreX := (Col3 + MaxX) div 2;
  CentreY := (Row2 + Row1) div 2;
  FillEllipse(CentreX, CentreY, (Row1 div 2) - VB, (Row1 div 2) - VB);
end;

procedure DrawRow3;
begin
  SetColor(LightCyan);
  CentreX := Col1 div 2;
  CentreY := (Row2 + Row3) div 2;
  Ellipse(CentreX, CentreY, 0, 270, (Col1 div 2) - HB, (Row1 div 2) - VB);
  SetFillStyle(SolidFill, DarkGray);
  Setcolor(DarkGray);
  Bar3d(Col1 + HB, Row2 + VB, Col2 - HB, Row3 - VB, 10, True);
  SetColor(LightGreen);
  Pentagon[1] := (Col3 + Col2) div 2; Pentagon[2] := Row2 + VB;
  Pentagon[3] := Col3 - HB; Pentagon[4] := (Row2 + Row3) div 2;
  Pentagon[5] := Col3 - (Col1 div 3); Pentagon[6] := Row3 - VB;
  Pentagon[7] := Col2 + (Col1 div 3); Pentagon[8] := Row3 - VB;
  Pentagon[9] := Col2 + HB; Pentagon[10] := (Row2 + Row3) div 2;
  Pentagon[11] := Pentagon[1]; Pentagon[12] := Pentagon[2];
  Drawpoly(6, Pentagon);
  SetFillStyle(SolidFill, LightRed);
  SetColor(LightRed);
  Triangle[1] := (Col3 + MaxX) div 2; Triangle[2] := Row2 + VB;
  Triangle[3] := MaxX - HB; Triangle[4] := Row3 - VB;
  Triangle[5] := Col3 + HB; Triangle[6] := Row3 - VB;
  Triangle[7] := Triangle[1]; Triangle[8] := Triangle[2];
  Fillpoly(4, Triangle);
end;

procedure DrawRow4;
begin
  SetFillStyle(SolidFill, LightMagenta);
  CentreX := Col1 div 2;
  CentreY := (Row3 + MaxY) div 2;
  Sector(CentreX, CentreY, 270, 360, (Col1 div 2) - HB, (Row1 div 2) - VB);
  for Count := 1 to (Row1 div 2) - VB do
  begin
    putPixel(Col1 + HB + Count, Row3 + VB + Count, LightBlue);
  end;
  StartX := Col1 + HB + Count;
  StartY := Row3 + VB + Count;
  for Count := 1 to (Row1 div 2) - VB do
  begin
    putPixel(StartX + Count, StartY - Count, LightBlue);
  end;
  SetColor(Yellow);
  MoveTo(col1 + HB, (Row3 + MaxY) div 2);
  
  OutText('www.pp4s.co.uk');
  
  Count := 1;
  X := Col2 + HB + (Count * 10);
  Y := Row3 + VB + (Count * Count) div 5;
  while (X <= Col3 - HB) and (Y <= MaxY - VB) do
  begin
    PutPixel(X, Y, White);
    PutPixel(X - 1, Y, White);
    PutPixel(X, Y - 1, White);
    PutPixel(X - 1, Y - 1, White);
    Inc(Count);
    X := Col2 + HB + (Count * 10);
    Y := Row3 + VB + (Count * Count) div 5;
  end;
  SetColor(LightGreen);
  Arc((col3 + MaxX) div 2, (Row3 + MaxY) div 2, 0, 180, (Row1 div 2) - VB);
end;

begin
  gd := d8bit;
  gm := m640x480;
  InitGraph(gd, gm, '');
  MaxX := GetMaxX;
  MaxY := GetMaxY;
  Col1 := MaxX div 4;
  Col2 := MaxX div 2;
  Col3 := Col1 + Col2;
  Row1 := MaxY div 4;
  Row2 := MaxY div 2;
  Row3 := Row1 + Row2;
  SetLineStyle(Solidln, 0, Thickwidth);
  SetColor(White);
  SetBkColor(White);
  SetFillStyle(SolidFill, LightGray);
  Bar(0, 0, MaxX, maxY);
  DrawRow1;
  DrawRow2;
  DrawRow3;
  DrawRow4;
  ReadKey;
end.
