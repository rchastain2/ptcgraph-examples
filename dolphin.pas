
program Dolphin;

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
  A: array[-1..80] of Point3D;
  
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
  Ap.X := -A[N - 1].X + 3 * A[N].X - 3 * A[N + 1].X + A[N + 2].X;
  Bp.X := 3 * A[N - 1].X - 6 * A[N].X + 3 * A[N + 1].X;
  Cp.X := -3 * A[N - 1].X + 3 * A[N + 1].X;
  Dp.X := A[N - 1].X + 4 * A[N].X + A[N + 1].X;
  Ap.Y := -A[N - 1].Y + 3 * A[N].Y - 3 * A[N + 1].Y + A[N + 2].Y;
  Bp.Y := 3 * A[N - 1].Y - 6 * A[N].Y + 3 * A[N + 1].Y;
  Cp.Y := -3 * A[N - 1].Y + 3 * A[N + 1].Y;
  Dp.Y := A[N - 1].Y + 4 * A[N].Y + A[N + 1].Y;
end;

procedure Catmull_Rom_ComputeCoeffs(N: smallint; var Ap, Bp, Cp, Dp: Point3D);
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

procedure BSpLine(N, Resolution, Colour: longword);
var
  I, J: smallint;
  X, Y, Lx, Ly: Single;
  Ap, Bp, Cp, Dp: Point3D;
begin
  SetColor(Colour);
  A[-1] := A[1];
  A[0] := A[1];
  A[N + 1] := A[N];
  A[N + 2] := A[N];
  for I := 0 to N do
  begin
    BSpLine_ComputeCoeffs(I, Ap, Bp, Cp, Dp);
    SpLine_Calc(Ap, Bp, Cp, Dp, 0, 6, Lx, Ly);
    for J := 1 to Resolution do
    begin
      SpLine_Calc(Ap, Bp, Cp, Dp, J / Resolution, 6, X, Y);
      Line(Round(Lx), Round(Ly), Round(X), Round(Y));
      Lx := X; Ly := Y;
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
  A[0] := A[1];
  A[N + 1] := A[N];
  for I := 1 to N - 1 do begin
    Catmull_Rom_ComputeCoeffs(I, Ap, Bp, Cp, Dp);
    SpLine_Calc(Ap, Bp, Cp, Dp, 0, 2, Lx, Ly);
    for J := 1 to Resolution do begin
      SpLine_Calc(Ap, Bp, Cp, Dp, J / Resolution, 2, X, Y);
      Line(Round(Lx), Round(Ly), Round(X), Round(Y));
      Lx := X; Ly := Y;
    end;
  end;
end;

const
  cBackground = {cAquaMarine}cDarkSeaGreen;
  cContour = cSilver;
  cSkin = cDarkTeaGreen;
  cReflects = cSnow;
  cSkin2 = cTeaGreen;
  
var
  Res, NumPts: smallint;
  
var
  d, m: smallint;
  
begin
  d := VESA;
  m := m640x480x64k;
  InitGraph(d, m, '');
  
  SetBkColor(cBackground);
  ClearDevice;
  
  A[01].X := 535; A[01].Y := 450;
  A[02].X := 545; A[02].Y := 385;
  A[03].X := 480; A[03].Y := 355;
  A[04].X := 485; A[04].Y := 210;
  A[05].X := 415; A[05].Y := 120;
  A[06].X := 415; A[06].Y := 110;
  A[07].X := 485; A[07].Y :=  85;
  A[08].X := 390; A[08].Y :=  70;
  A[09].X := 360; A[09].Y :=  86;
  A[10].X := 300; A[10].Y :=  57;
  A[11].X := 200; A[11].Y :=  50;
  A[12].X := 142; A[12].Y :=  94;
  A[13].X := 129; A[13].Y := 151;
  A[14].X := 129; A[14].Y := 151;
  A[15].X := 115; A[15].Y := 168;
  A[16].X := 120; A[16].Y := 185;
  A[17].X := 160; A[17].Y := 174;
  A[18].X := 160; A[18].Y := 174;
  A[19].X := 143; A[19].Y := 173;
  A[20].X := 147; A[20].Y := 163;
  A[21].X := 168; A[21].Y := 155;
  A[22].X := 168; A[22].Y := 155;
  A[23].X := 171; A[23].Y := 136;
  A[24].X := 193; A[24].Y := 133;
  A[25].X := 193; A[25].Y := 133;
  A[26].X := 186; A[26].Y := 137;
  A[27].X := 187; A[27].Y := 142;
  A[28].X := 193; A[28].Y := 144;
  A[29].X := 201; A[29].Y := 140;
  A[30].X := 201; A[30].Y := 133;
  A[31].X := 195; A[31].Y := 133;
  A[32].X := 193; A[32].Y := 133;
  A[33].X := 193; A[33].Y := 133;
  A[34].X := 193; A[34].Y := 133;
  A[35].X := 193; A[35].Y := 133;
  A[36].X := 193; A[36].Y := 133;
  A[37].X := 193; A[37].Y := 133;
  A[38].X := 193; A[38].Y := 133;
  A[39].X := 193; A[39].Y := 133;
  A[40].X := 193; A[40].Y := 133;
  A[41].X := 193; A[41].Y := 133;
  A[42].X := 200; A[42].Y := 116;
  A[43].X := 285; A[43].Y := 124;
  A[44].X := 285; A[44].Y := 124;
  A[45].X := 250; A[45].Y := 110;
  A[46].X := 250; A[46].Y := 110;
  A[47].X := 340; A[47].Y := 110;
  A[48].X := 413; A[48].Y := 182;
  A[49].X := 322; A[49].Y := 139;
  A[50].X := 322; A[50].Y := 139;
  A[51].X := 430; A[51].Y := 210;
  A[52].X := 460; A[52].Y := 275;
  A[53].X := 427; A[53].Y := 260;
  A[54].X := 427; A[54].Y := 260;
  A[55].X := 475; A[55].Y := 310;
  A[56].X := 470; A[56].Y := 360;
  A[57].X := 470; A[57].Y := 360;
  A[58].X := 420; A[58].Y := 385;
  A[59].X := 419; A[59].Y := 419;
  A[60].X := 419; A[60].Y := 419;
  A[61].X := 430; A[61].Y := 403;
  A[62].X := 480; A[62].Y := 408;
  A[63].X := 487; A[63].Y := 385;
  A[64].X := 505; A[64].Y := 417;
  A[65].X := 525; A[65].Y := 415;
  A[66].X := 535; A[66].Y := 450;
  Res := 20; NumPts := 66;
  BSpLine(NumPts, Res, cContour);
  
  SetLineStyle(cContour, 0, ThickWidth);
  
  A[1].X := 156; A[1].Y := 175;
  A[2].X := 240; A[2].Y := 164;
  A[3].X := 300; A[3].Y := 189;
  A[4].X := 300; A[4].Y := 189;
  A[5].X := 285; A[5].Y := 165;
  Res := 20; NumPts := 5;
  BSpLine(NumPts, Res, cContour);
  
  A[1].X := 350; A[1].Y := 210;
  A[2].X := 390; A[2].Y := 228;
  A[3].X := 430; A[3].Y := 261;
  Res := 20; NumPts := 3;
  BSpLine(NumPts, Res, cContour);
  
  A[01].X := 300; A[01].Y := 189;
  A[02].X := 320; A[02].Y := 225;
  A[03].X := 380; A[03].Y := 290;
  A[04].X := 355; A[04].Y := 195;
  A[05].X := 355; A[05].Y := 195;
  A[06].X := 305; A[06].Y := 167;
  A[07].X := 305; A[07].Y := 167;
  A[08].X := 325; A[08].Y := 210;
  A[09].X := 323; A[09].Y := 215;
  A[10].X := 300; A[10].Y := 189;
  Res := 20; NumPts := 10;
  BSpLine(NumPts, Res, cContour);
  
  A[1].X := 242; A[1].Y := 170;
  A[2].X := 257; A[2].Y := 210;
  A[3].X := 285; A[3].Y := 262;
  A[4].X := 297; A[4].Y := 225;
  A[5].X := 285; A[5].Y := 200;
  A[6].X := 290; A[6].Y := 185;
  Res := 20; NumPts := 6;
  BSpLine(NumPts, Res, cContour);
  
  SetFillStyle(SolidFill, cSkin);
  
  FloodFill(330, 200, cContour);
  FloodFill(200, 100, cContour);
  FloodFill(275, 200, cContour);
  FloodFill(193, 140, cContour);
  FloodFill(360, 160, cContour);
  FloodFill(318, 212, cContour);
  FloodFill(435, 266, cContour);
  
  SetFillStyle(SolidFill, cSkin2);
  FloodFill(242, 143, cContour);
  
  A[1].X := 127; A[1].Y := 162;
  A[2].X := 131; A[2].Y := 155;
  A[3].X := 137; A[3].Y := 150;
  A[4].X := 137; A[4].Y := 150;
  A[5].X := 144; A[5].Y := 120;
  A[6].X := 155; A[6].Y := 103;
  Res := 20; NumPts := 6;
  BSpLine(NumPts, Res, cReflects);
  
  A[1].X := 185; A[1].Y := 78;
  A[2].X := 199; A[2].Y := 71;
  A[3].X := 213; A[3].Y := 67;
  Res := 20; NumPts := 3;
  BSpLine(NumPts, Res, cReflects);
  
  A[1].X := 266; A[1].Y := 64;
  A[2].X := 290; A[2].Y := 68;
  A[3].X := 315; A[3].Y := 75;
  Res := 20; NumPts := 3;
  BSpLine(NumPts, Res, cReflects);
  
  A[1].X := 419; A[1].Y := 136;
  A[2].X := 428; A[2].Y := 147;
  A[3].X := 435; A[3].Y := 160;
  Res := 20; NumPts := 3;
  BSpLine(NumPts, Res, cReflects);
  
  A[1].X := 444; A[1].Y := 176;
  A[2].X := 457; A[2].Y := 200;
  Res := 20; NumPts := 2;
  BSpLine(NumPts, Res, cReflects);
  
  ReadKey;
  CloseGraph;
end.
