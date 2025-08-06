
program ex09;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors16;

type
  Point3D = record
    X, Y, Z: Single;
  end;
  TAr = array[-1..80] of Point3D;

procedure SpLine_Calc(Ap, Bp, Cp, Dp: Point3D; T, D: Single; var X, Y: Single);
var
  T2, T3: Single;
begin
  T2 := T * T;
  T3 := T2 * T;
  X := ((Ap.X * T3) + (Bp.X * T2) + (Cp.X * T) + Dp.X) / D;
  Y := ((Ap.Y * T3) + (Bp.Y * T2) + (Cp.Y * T) + Dp.Y) / D;
end;

procedure BSpLine_ComputeCoeffs(A: TAr; N: smallint; var Ap, Bp, Cp, Dp: Point3D);
begin
  Ap.X := -A[N - 1].X + 3 * A[N].X - 3 * A[N + 1].X + A[N + 2].X;
  Bp.X := 3 * A[N - 1].X - 6 * A[N].X + 3 * A[N + 1].X;
  Cp.X := -3 * A[N - 1].X + 3 * A[N + 1].X;
  Dp.X := A[N - 1].X + 4 * A[N].X + A[N + 1].X;
  Ap.Y := -A[N - 1].Y + 3 * A[N].Y - 3 * A[N + 1].Y + A[N + 2].Y;
  Bp.Y := 3 * A[N - 1].Y - 6 * A[N].Y + 3 * A[N + 1].Y;
  Cp.Y := -3 * A[N - 1].Y + 3 * A[N + 1].Y;
  Dp.Y := A[N - 1].Y + 4 * A[N].Y + A[N + 1].Y;
end;

procedure Catmull_Rom_ComputeCoeffs(A: TAr; N: smallint; var Ap, Bp, Cp, Dp: Point3D);
begin
  Ap.X := -A[N - 1].X + 3 * A[N].X - 3 * A[N + 1].X + A[N + 2].X;
  Bp.X := 2 * A[N - 1].X - 5 * A[N].X + 4 * A[N + 1].X - A[N + 2].X;
  Cp.X := -A[N - 1].X + A[N + 1].X;
  Dp.X := 2 * A[N].X;
  Ap.Y := -A[N - 1].Y + 3 * A[N].Y - 3 * A[N + 1].Y + A[N + 2].Y;
  Bp.Y := 2 * A[N - 1].Y - 5 * A[N].Y + 4 * A[N + 1].Y - A[N + 2].Y;
  Cp.Y := -A[N - 1].Y + A[N + 1].Y;
  Dp.Y := 2 * A[N].Y;
end;

procedure BSpLine(A: TAr; N, Resolution, Colour: longword);
var
  I, J: smallint; X, Y, Lx, Ly: Single; Ap, Bp, Cp, Dp: Point3D;
begin
  SetColor(Colour);
  A[-1] := A[1];
  A[0] := A[1];
  A[N + 1] := A[N];
  A[N + 2] := A[N];
  for I := 0 to N do
  begin
    BSpLine_ComputeCoeffs(A, I, Ap, Bp, Cp, Dp);
    SpLine_Calc(Ap, Bp, Cp, Dp, 0, 6, Lx, Ly);
    for J := 1 to Resolution do
    begin
      SpLine_Calc(Ap, Bp, Cp, Dp, J / Resolution, 6, X, Y);
      Line(Round(Lx), Round(Ly), Round(X), Round(Y));
      Lx := X; Ly := Y;
    end;
  end;
end;

procedure Catmull_Rom_SpLine(A: TAr; N, Resolution, Colour: longword);
var
  I, J: smallint; X, Y, Lx, Ly: Single; Ap, Bp, Cp, Dp: Point3D;
begin
  SetColor(Colour);
  A[0] := A[1];
  A[N + 1] := A[N];
  for I := 1 to N - 1 do
  begin
    Catmull_Rom_ComputeCoeffs(A, I, Ap, Bp, Cp, Dp);
    SpLine_Calc(Ap, Bp, Cp, Dp, 0, 2, Lx, Ly);
    for J := 1 to Resolution do
    begin
      SpLine_Calc(Ap, Bp, Cp, Dp, J / Resolution, 2, X, Y);
      Line(Round(Lx), Round(Ly), Round(X), Round(Y));
      Lx := X; Ly := Y;
    end;
  end;
end;

var
  I, J, Res, NumPts, k: smallint;
  a, b: TAr;
  
var
  d, m: smallint;
  
begin
  d := VESA;
  m := m640x480x64k;
  InitGraph(d, m, '');
  SetBkColor(cDarkSlateGray);
  SetColor(cYellow);
  ClearDevice;
  
  I := GetMaxX;
  J := GetMaxY;
  a[1].X := 0; a[1].Y := 0;
  a[2].X := 490; a[2].Y := 20;
  a[3].X := 240; a[3].Y := 400;
  a[4].X := 640; a[4].Y := 480;
  b[1].X := -50; b[1].Y := -30;
  b[2].X := 100; b[2].Y := 200;
  b[3].X := 390; b[3].Y := 280;
  b[4].X := 640; b[4].Y := 430;
  Res := 20;
  NumPts := 4;
  k := 5;
  for i := 1 to 10 do
  begin
    BSpLine(A, NumPts, Res, cYellow);
    a[1].Y := a[1].Y - 5;
    a[2].Y := a[2].Y + 25;
    a[3].Y := a[3].Y + 10;
    a[4].Y := a[4].Y - 1;
    a[1].X := a[1].X + k;
    a[2].X := a[2].X + k;
    a[3].X := a[3].X + k;
    a[4].X := a[4].X + k;
    BSpLine(B, NumPts, Res, cOrange);
    b[1].Y := b[1].Y - 5;
    b[2].Y := b[2].Y + 15;
    b[3].Y := b[3].Y + 7;
    b[4].Y := b[4].Y - 10;
    b[1].X := b[1].X + k;
    b[2].X := b[2].X + k;
    b[3].X := b[3].X + k;
    b[4].X := b[4].X + k;
  end;
  
  ReadKey;
  CloseGraph;
end.
