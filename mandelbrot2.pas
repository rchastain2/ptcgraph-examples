
program mand;
{ Vollständiges Apfelmännchen }

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcCrt, ptcGraph;

label
  naechst;

const
  xmax = 1.5;
  ymax = 1.125;
 {col: array[0..8] of integer = (0, 1, 9, 2, 10, 4, 12, 6, 14);}

var
  i, j, k, l, n1, n2, midy: integer;
  a, b, s, u, v, x, xl, x2, y, y2: real;
  gd, gm: smallint;

begin
 {gd := d4bit;
  gm := DetectMode;}
  gd := VESA;
  gm := m1024x768x16m;
  InitGraph(gd, gm, '');
  
  n1 := round(GetMaxX / 2 - 20);
  midy := round(GetMaxY / 2);
  n2 := round(n1 * ymax / xmax);
  
  for i := -n1 to n1 do
  begin
    a := -0.65 + i * xmax / n1;
    
    for j := 0 to n2 do
    begin
      b := j * ymax / n2;
      u := 4 * (a * a + b * b);
      v := u - 2 * a + 0.25;
      
      if (u + 8 * a + 3.75 < 0) or (v - sqrt(v) + 2 * a - 0.5 < 0) then
        goto naechst;
      
      x := a;
      y := b;
      k := 0;
      repeat
        xl := x;
        k := k + 1;
        x2 := x * x; y2 := y * y;
        x := x2 - y2 + a;
        y := 2 * xl * y + b;
        s := x2 + y2;
      until (s > 4) or (k = 40);
      
      if k < 40 then
      begin
        l := 1 + k mod 8;
        putpixel(20 + n1 + i, midy - j, {col[l]}k * 6);
        putpixel(20 + n1 + i, midy + j, {col[l]}k * 6);
      end;
      
      naechst:
    end;
  end;
  
  readkey;
  closegraph;
end.
