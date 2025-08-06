
program ex10;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors16;
  
type
  Point3D = record
    X, Y, Z: Single;
  end;
  
var
  CtrlPt: array[-1..80] of Point3D;

procedure SpLine_Calc(Ap, Bp, Cp, Dp: Point3D; T, D: Single; var X, Y: Single);
var
  T2, T3: Single;
begin
  T2 := T * T;
  T3 := T2 * T;
  X := ((Ap.X * T3) + (Bp.X * T2) + (Cp.X * T) + Dp.X) / D;
  Y := ((Ap.Y * T3) + (Bp.Y * T2) + (Cp.Y * T) + Dp.Y) / D;
end;

procedure BSpLine_ComputeCoeffs(N: smallint; var Ap, Bp, Cp, Dp: Point3D);
begin
  Ap.X := -CtrlPt[N - 1].X + 3 * CtrlPt[N].X - 3 * CtrlPt[N + 1].X + CtrlPt[N + 2].X;
  Bp.X := 3 * CtrlPt[N - 1].X - 6 * CtrlPt[N].X + 3 * CtrlPt[N + 1].X;
  Cp.X := -3 * CtrlPt[N - 1].X + 3 * CtrlPt[N + 1].X;
  Dp.X := CtrlPt[N - 1].X + 4 * CtrlPt[N].X + CtrlPt[N + 1].X;
  Ap.Y := -CtrlPt[N - 1].Y + 3 * CtrlPt[N].Y - 3 * CtrlPt[N + 1].Y + CtrlPt[N + 2].Y;
  Bp.Y := 3 * CtrlPt[N - 1].Y - 6 * CtrlPt[N].Y + 3 * CtrlPt[N + 1].Y;
  Cp.Y := -3 * CtrlPt[N - 1].Y + 3 * CtrlPt[N + 1].Y;
  Dp.Y := CtrlPt[N - 1].Y + 4 * CtrlPt[N].Y + CtrlPt[N + 1].Y;
end;

procedure Catmull_Rom_ComputeCoeffs(N: smallint; var Ap, Bp, Cp, Dp: Point3D);
begin
  Ap.X := -CtrlPt[N - 1].X + 3 * CtrlPt[N].X - 3 * CtrlPt[N + 1].X + CtrlPt[N + 2].X;
  Bp.X := 2 * CtrlPt[N - 1].X - 5 * CtrlPt[N].X + 4 * CtrlPt[N + 1].X - CtrlPt[N + 2].X;
  Cp.X := -CtrlPt[N - 1].X + CtrlPt[N + 1].X;
  Dp.X := 2 * CtrlPt[N].X;
  Ap.Y := -CtrlPt[N - 1].Y + 3 * CtrlPt[N].Y - 3 * CtrlPt[N + 1].Y + CtrlPt[N + 2].Y;
  Bp.Y := 2 * CtrlPt[N - 1].Y - 5 * CtrlPt[N].Y + 4 * CtrlPt[N + 1].Y - CtrlPt[N + 2].Y;
  Cp.Y := -CtrlPt[N - 1].Y + CtrlPt[N + 1].Y;
  Dp.Y := 2 * CtrlPt[N].Y;
end;

procedure BSpLine(N, Resolution, Colour: longword);
var
  I, J: smallint;
  X, Y, Lx, Ly: Single;
  Ap, Bp, Cp, Dp: Point3D;
begin
  SetColor(Colour);
  CtrlPt[-1] := CtrlPt[1];
  CtrlPt[0] := CtrlPt[1];
  CtrlPt[N + 1] := CtrlPt[N];
  CtrlPt[N + 2] := CtrlPt[N];
  for I := 0 to N do
  begin
    BSpLine_ComputeCoeffs(I, Ap, Bp, Cp, Dp);
    SpLine_Calc(Ap, Bp, Cp, Dp, 0, 6, Lx, Ly);
    for J := 1 to Resolution do
    begin
      SpLine_Calc(Ap, Bp, Cp, Dp, J / Resolution, 6, X, Y);
      Line(Round(Lx), Round(Ly), Round(X), Round(Y));
      Lx := X;
      Ly := Y;
    end;
  end;
end;

procedure Catmull_Rom_SpLine(N, Resolution, Colour: longword);
var
  I, J: smallint;
  X, Y, Lx, Ly: Single;
  Ap, Bp, Cp, Dp: Point3D;
begin
  SetColor(Colour);
  CtrlPt[0] := CtrlPt[1];
  CtrlPt[N + 1] := CtrlPt[N];
  for I := 1 to N - 1 do
  begin
    Catmull_Rom_ComputeCoeffs(I, Ap, Bp, Cp, Dp);
    SpLine_Calc(Ap, Bp, Cp, Dp, 0, 2, Lx, Ly);
    for J := 1 to Resolution do
    begin
      SpLine_Calc(Ap, Bp, Cp, Dp, J / Resolution, 2, X, Y);
      Line(Round(Lx), Round(Ly), Round(X), Round(Y));
      Lx := X;
      Ly := Y;
    end;
  end;
end;

var
  I, J, Res, NumPts: smallint;
  
var
  d, m: smallint;
  
begin
  d := VESA;
  m := m640x480x64k;
  InitGraph(d, m, '');
  SetBkColor(cDarkSlateGray);
  ClearDevice;
  I := GetMaxX;
  J := GetMaxY;
  Randomize;
  CtrlPt[1].X := Random(I); CtrlPt[1].Y := Random(J);
  CtrlPt[2].X := Random(I); CtrlPt[2].Y := Random(J);
  CtrlPt[3].X := Random(I); CtrlPt[3].Y := Random(J);
  CtrlPt[4].X := Random(I); CtrlPt[4].Y := Random(J);
  CtrlPt[5].X := Random(I); CtrlPt[5].Y := Random(J);
  Res := 20;
  NumPts := 5;
  BSpLine(NumPts, Res, cYellow);
  CatMull_Rom_SpLine(NumPts, Res, cOrange);
  SetColor(cYellowGreen);
  for I := 1 to NumPts do
  begin
    Line(Round(CtrlPt[I].X - 3), Round(CtrlPt[I].Y), Round(CtrlPt[I].X + 3), Round(CtrlPt[I].Y));
    Line(Round(CtrlPt[I].X), Round(CtrlPt[I].Y - 3), Round(CtrlPt[I].X), Round(CtrlPt[I].Y + 3));
  end;
  ReadKey;
  CloseGraph;
end.
