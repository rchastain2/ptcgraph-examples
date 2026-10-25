{.$R+}

{ This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  Use this software AT YOUR OWN RISK. }

{ Level Editor for MsPacman game, (c) 1997 by George M. Tzoumas }
program Editor; { LED.PAS }

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph,
  ptcCrt,
  Load,
  Log;

{ Graphics Images (16x16) }

const
  MaxImages = 18;
  MaxX = 20;
  MaxY = 22;

var
  ch, cf: char;
  Matrix: array[0..MaxX, 0..MaxY] of byte;
  Images: array[0..MaxImages] of pointer;
  FocusC, UnFocusC: word;
  ci: byte; { Current image }
  bi: byte; { Blank image }
  cx, cy: byte;

procedure InitGraphics;
var
  gd, gm: smallint;
begin
  gd := VGA;
  gm := VGAHi;
  WindowTitle := 'MsPacman Level Editor';
  InitGraph(gd, gm, '');
  FocusC := 3;
  UnFocusC := 0;
end;

procedure LoadGraphics;
const
  CImagesDir = 'images' + DirectorySeparator;
begin
  BLoad(CImagesDir + 'wblank', Images[0]);
  BLoad(CImagesDir + 'wfull', Images[1]);
  BLoad(CImagesDir + 'wup', Images[2]);
  BLoad(CImagesDir + 'wdown', Images[3]);
  BLoad(CImagesDir + 'wleft', Images[4]);
  BLoad(CImagesDir + 'wright', Images[5]);
  BLoad(CImagesDir + 'whoriz', Images[6]);
  BLoad(CImagesDir + 'wvert', Images[7]);
  BLoad(CImagesDir + 'wupl', Images[8]);
  BLoad(CImagesDir + 'wupr', Images[9]);
  BLoad(CImagesDir + 'wdownl', Images[10]);
  BLoad(CImagesDir + 'wdownr', Images[11]);
  BLoad(CImagesDir + 'wupt', Images[12]);
  BLoad(CImagesDir + 'wdownt', Images[13]);
  BLoad(CImagesDir + 'wleftt', Images[14]);
  BLoad(CImagesDir + 'wrightt', Images[15]);
  BLoad(CImagesDir + 'ghdoor', Images[16]);
  BLoad(CImagesDir + 'msdot', Images[17]);
  BLoad(CImagesDir + 'mspill', Images[18]);
end;

procedure DrawCell(x, y, pic: byte);
begin
  PutImage(x shl 4, y shl 4, Images[pic]^, CopyPut);
end;

procedure FocusCell(x, y: byte);
var
  sx, sy: word;
begin
  DrawCell(x, y, ci);
  sx := x shl 4;
  sy := y shl 4;
  SetColor(FocusC);
  Rectangle(sx, sy, sx + 15, sy + 15);
end;

procedure UnFocusCell(x, y: byte);
begin
  DrawCell(x, y, Matrix[x, y]);
end;

procedure DrawLevel;
var
  i, j: byte;
begin
  for j := 0 to MaxY do
    for i := 0 to MaxX do
      DrawCell(i, j, Matrix[i, j]);
  FocusCell(cx, cy);
end;

procedure SaveAs;
var
  f: file;
  fn: string;
begin
  RestoreCrtMode;
  Write('Enter file name to save: ');
  ReadLn(fn);
  Assign(f, fn);
  Rewrite(f, 1);
  BlockWrite(f, Matrix, SizeOf(Matrix));
  Close(f);
  SetGraphMode(GetGraphMode);
  DrawLevel;
end;

procedure Load;
var
  f: file;
  fn: string;
begin
  RestoreCrtMode;
  Write('Enter file name to load: ');
  ReadLn(fn);
  Assign(f, fn);
  Reset(f, 1);
  BlockRead(f, Matrix, SizeOf(Matrix));
  Close(f);
  SetGraphMode(GetGraphMode);
  DrawLevel;
end;

procedure CountDots;
var
  c, i, j: Integer;
begin
  RestoreCrtMode;
  c := 0;
  for i := 0 to MaxY do
    for j := 0 to MaxX do
      Inc(c, byte(Matrix[j, i] in [17..18]));
  WriteLn('Total number of dots: ', c);
  ReadKey;
  SetGraphMode(GetGraphMode);
  DrawLevel;
end;

procedure ClearLevel;
begin
  FillChar(Matrix, SizeOf(Matrix), 0);
  ClearDevice;
  FocusCell(cx, cy);
end;

procedure InsertColumn;
begin
  Move(Matrix[cx, 0], Matrix[cx + 1, 0], (MaxX - cx) * (MaxY + 1));
  FillChar(Matrix[cx, 0], MaxY + 1, 0);
  UnFocusCell(cx, cy);
  DrawLevel;
end;

procedure DeleteColumn;
begin
  Move(Matrix[cx + 1, 0], Matrix[cx, 0], (MaxX - cx) * (MaxY + 1));
  FillChar(Matrix[MaxX, 0], MaxY + 1, 0);
  UnFocusCell(cx, cy);
  DrawLevel;
end;

procedure DeleteLine;
var
  i, j: byte;
begin
  for i := cy to MaxY - 1 do
    for j := 0 to MaxX do
      Matrix[j][i] := Matrix[j][i + 1];

  for j := 0 to MaxX do
    Matrix[j][MaxY] := 0;
  UnFocusCell(cx, cy);
  DrawLevel;
end;

procedure InsertLine;
var
  i, j: byte;
begin
  for i := Pred(MaxY) downto cy do
    for j := 0 to MaxX do
      Matrix[j][i + 1] := Matrix[j][i];
  for j := 0 to MaxX do
    Matrix[j][cy] := 0;
  UnFocusCell(cx, cy);
  DrawLevel;
end;

begin
  InitGraphics;
  LoadGraphics;
  Randomize;
  FillChar(Matrix, SizeOf(Matrix), 0);
  cx := 0;
  cy := 0;
  ci := 1;
  bi := 0;
  FocusCell(cx, cy);
  repeat
    ch := readkey;
    //if Caps_Lock then Matrix[cx, cy]:=ci;
    case ch of
      #32: Matrix[cx, cy] := ci;
      #13: Matrix[cx, cy] := bi;
      '+': if ci < MaxImages then inc(ci) else ci := 0;
      '-': if ci > 0 then dec(ci) else ci := MaxImages;
      #12: ClearLevel;
      #14: InsertLine;
      #25: DeleteLine;
      #19: InsertColumn;
      #1: DeleteColumn;
      #4: CountDots;
      #00:
        begin
          cf := ReadKey;
          if cf in [#72..#80] then
            UnFocusCell(cx, cy);
          case cf of
            #75: if cx > 0 then Dec(cx);
            #77: if cx < MaxX then Inc(cx);
            #80: if cy < MaxY then Inc(cy);
            #72: if cy > 0 then Dec(cy);
            #60: SaveAs;
            #61: Load;
          end;
          if cf in [#72..#80] then
            FocusCell(cx, cy);
        end;
    end;
    if ch in ['+', '-'] then
      FocusCell(cx, cy);
  until ch in [#3, #27];
  CloseGraph;
end.
