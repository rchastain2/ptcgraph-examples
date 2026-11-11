
program grgula; { graphic pyramid }

(*
  Adaptation d'un programme de Görbe Mihály.
  https://gorbem.hu/TP/Grafika.htm
*)

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;

const
  cDarkSlateGray = $2A69;
  cYellow        = $FFE0;

const
  C  = 260;
  T  = 50;
  A  = 10;
  QX = 15;
  QY = 11;
  N  = 9;
  CS = N + 2;
  LC = 3;
  LS = 2 * N;

type
  Vekt    = array[1..3] of single;          { vector }
  Csucsok = array[1..CS] of Vekt;           { vertices }
  Lapok   = array[1..LS, 1..LC] of byte;    { faces }

const
  al: integer = 2;                          { rotation angles: alpha, beta, gamma }
  be: integer = 0;
  ga: integer = 1;

var
  kx, ky: integer;                          { screen center }
  page: word;
  test: Csucsok;                            { body (solid) }
  testl: Lapok;                             { body faces }
  s: Longint;

procedure Gula;                             { pyramid }
var
  i: byte;
begin
  test[1, 1] := 0;
  test[1, 2] := 0;
  test[1, 3] := A;

  for i := 0 to N - 1 do
  begin
    test[i + 2, 1] := A * Cos(i * 360 / N * PI / 180);
    test[i + 2, 2] := A * Sin(i * 360 / N * PI / 180);
    test[i + 2, 3] := 0;
  end;

  test[N + 2, 1] := 0;
  test[N + 2, 2] := 0;
  test[N + 2, 3] := -A / 3;

  for i := 1 to N - 1 do
  begin
    testl[i, 1] := 1;
    testl[i, 2] := i + 1;
    testl[i, 3] := i + 2;
  end;

  testl[N, 1] := 1;
  testl[N, 2] := N + 1;
  testl[N, 3] := 2;

  for i := N + 1 to 2 * N - 1 do
  begin
    testl[i, 1] := N + 2;
    testl[i, 2] := i - N + 2;
    testl[i, 3] := i - N + 1;
  end;

  testl[2 * N, 1] := N + 2;
  testl[2 * N, 2] := 2;
  testl[2 * N, 3] := N + 1;
end;

procedure Forgatas;                         { rotation }
var
  i: byte;
  px, py, pz: single;
  sinal, cosal, sinbe, cosbe, singa, cosga: single;
begin
  Inc(s);

  if s mod 100 = 0 then
  begin
    al := al + Random(2) - 1;
    be := be + Random(2) - 1;
    ga := ga + Random(2) - 1;

    if Abs(al) > 4 then al := 2;
    if Abs(be) > 2 then be := 0;
    if Abs(ga) > 3 then ga := 1;
  end;

  sinal := Sin(al * PI / 180);  cosal := Cos(al * PI / 180);
  sinbe := Sin(be * PI / 180);  cosbe := Cos(be * PI / 180);
  singa := Sin(ga * PI / 180);  cosga := Cos(ga * PI / 180);

  for i := 1 to CS do
  begin
    px := test[i, 1] * cosbe * cosga
        - test[i, 2] * cosbe * singa
        + test[i, 3] * sinbe;

    py := test[i, 1] * (cosal * singa + sinal * sinbe * cosga)
        + test[i, 2] * (cosal * cosga - sinal * sinbe * singa)
        - test[i, 3] * sinal * cosbe;

    pz := test[i, 1] * (sinal * singa - cosal * sinbe * cosga)
        + test[i, 2] * (sinal * cosga + cosal * sinbe * singa)
        + test[i, 3] * cosal * cosbe;

    test[i, 1] := px;
    test[i, 2] := py;
    test[i, 3] := pz;
  end;
end;

procedure Vetites;                          { projection }

  procedure VektSzor(a, b: Vekt; var s: Vekt);  { cross product }
  begin
    s[1] := a[2] * b[3] - a[3] * b[2];
    s[2] := a[3] * b[1] - a[1] * b[3];
    s[3] := a[1] * b[2] - a[2] * b[1];
  end;

  procedure VektKul(a, b: Vekt; var k: Vekt);   { vector difference }
  begin
    k[1] := a[1] - b[1];
    k[2] := a[2] - b[2];
    k[3] := a[3] - b[3];
  end;

  function Skalar(a, b: Vekt): single;          { dot product }
  begin
    result := a[1] * b[1] + a[2] * b[2] + a[3] * b[3];
  end;

  function KepPont(const v: Vekt): PointType;   { projected point }
  begin
    result.x := Round(kx + C * v[1] * QX / (C - T - v[3]));
    result.y := Round(ky - C * v[2] * QY / (C - T - v[3]));
  end;

  function Arnyalas(f: byte): single;           { shading }
  const
    FENY: Vekt = (-0.36, 0.48, 0.8);            { light }
  var
    a, b, n, m: Vekt;
    c, p: byte;
    d: single;
  begin
    VektKul(test[testl[f, 2]], test[testl[f, 1]], a);
    VektKul(test[testl[f, 3]], test[testl[f, 1]], b);
    VektSzor(a, b, n);

    for c := 1 to 3 do
    begin
      m[c] := 0;
      for p := 1 to LC do
        m[c] := m[c] + test[testl[f, p], c] / LC;

      d := 0;
      for p := 1 to CS do
        d := d + test[p, c] / CS;

      m[c] := m[c] - d;
    end;

    if Skalar(n, m) < 0 then
      for c := 1 to 3 do
        n[c] := -n[c];

    d := Skalar(n, FENY) / Sqrt(Skalar(n, n));
    if d < 0 then
      d := 0;

    result := 0.25 + 0.75 * d;
  end;

  function Szin(e: single): word;               { color (RGB565) }
  begin
    result := (Round(31 * 0.3 * e) shl 11)
           or (Round(63 * 0.6 * e) shl 5)
           or  Round(31 * e);
  end;

var
  kp: array[1..LC + 1] of PointType;            { projected points }
  i, j: byte;
  sz: word;
begin
  SetActivePage(page);
  ClearDevice;

  for i := 1 to LS do
  begin
    for j := 1 to LC do
      kp[j] := KepPont(test[testl[i, j]]);
    kp[LC + 1] := kp[1];

    if kp[1].x * (kp[2].y - kp[3].y)
     + kp[2].x * (kp[3].y - kp[1].y)
     + kp[3].x * (kp[1].y - kp[2].y) < 0 then
    begin
      sz := Szin(Arnyalas(i));
      SetColor(sz);
      SetFillStyle(SolidFill, sz);
      FillPoly(LC, kp);
    end;
  end;

  SetVisualPage(page);
  Delay(20);
  page := 1 - page;
end;

var
  driver, mode: smallint;

begin
  driver := VESA;
  mode := m800x600x64k;
  WindowTitle := 'ptcGraph';
  InitGraph(driver, mode, '');
  SetBkColor(cDarkSlateGray);
  SetColor(cYellow);
  ClearDevice;

  kx := GetMaxX div 2;
  ky := GetMaxY div 2;

  Gula;

  page := 0;
  repeat
    Vetites;
    Forgatas;
  until KeyPressed;

  CloseGraph;
end.
