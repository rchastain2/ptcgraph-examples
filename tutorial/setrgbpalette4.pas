(*
-From: ftp://garbo.uwasa.fi/pc/link/tsfaqp.zip Frequently Asked TP Questions
-Subject: Modifying VGA palette

111. *****
 Q: How can I modify the colors of the VGA graphics palette?

 A: Below is a demo source code how to do it. Solving this problem
is not trivial, but it is not overly complicated either.
   The related task of selecting the RGB (Red Green Blue) color
values to your liking is, in fact, the most laborious task. The
color values for each color component for the adapter run from 0 to
255, but in Turbo Pascal only only the 6 most-significant bits of
the color byte are loaded in the palette. Thus the TP color
components run from 0 to 63 only. The correspondence between the 0
to 255 and the 0 to 63 items can be found using the formula
  ReducedColorItem := Full8bitColorItem shr 2;
The reduction to 6 significant bits means that TP will unfortunately
not be able to utilize all the color combinations your VGA adapter
should be capable of.
*)

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcCrt, ptcGraph;

type RGBRecordType = record
                       c       : byte;
                       r, g, b : byte;
                     end;

type RGBArrayRecordType = array[0..{MaxColors}15] of RGBRecordType;

const
  DefaultPalette : RGBArrayRecordType = (
   (c:  0; r: 0; g: 0; b: 0),   { Black; }
   (c:  1; r: 0; g: 0; b:40),   { Blue; }
   (c:  2; r: 0; g:40; b: 0),   { Green; }
   (c:  3; r: 0; g:40; b:40),   { Cyan; }
   (c:  4; r:40; g: 7; b: 7),   { Red; }
   (c:  5; r:40; g: 0; b:40),   { Magenta; }
   (c: 20; r:40; g:30; b: 0),   { Brown; }
   (c:  7; r:49; g:49; b:49),   { LightGray; }
   (c: 56; r:26; g:26; b:26),   { DarkGray; }
   (c: 57; r: 0; g: 0; b:63),   { LightBlue; }
   (c: 58; r: 9; g:63; b: 9),   { LightGreen; }
   (c: 59; r: 0; g:63; b:63),   { LightCyan; }
   (c: 60; r:63; g:10; b:10),   { LightRed; }
   (c: 61; r:44; g: 0; b:63),   { LightMagenta; }
   (c: 62; r:63; g:63; b:18),   { Yellow; }
   (c: 63; r:63; g:63; b:63) ); { White; }

const
  MyPalette : RGBArrayRecordType = (
   (c:  0; r: 0; g: 0; b: 0),   { Black; }
   (c:  1; r: 0; g: 0; b:32),   { Blue; }
   (c:  2; r: 0; g:32; b: 0),   { Green; }
   (c:  3; r: 0; g:48; b:48),   { Cyan; }
   (c:  4; r:32; g: 0; b: 0),   { Red; }
   (c:  5; r:32; g: 0; b:32),   { Magenta; }
   (c: 20; r:43; g:21; b: 0),   { Brown; }
   (c:  7; r:48; g:48; b:48),   { LightGray; }
   (c: 56; r:32; g:32; b:32),   { DarkGray; }
   (c: 57; r: 0; g: 0; b:63),   { LightBlue; }
   (c: 58; r: 0; g:63; b: 0),   { LightGreen; }
   (c: 59; r: 0; g:63; b:63),   { LightCyan; }
   (c: 60; r:63; g: 0; b: 0),   { LightRed; }
   (c: 61; r:63; g: 0; b:63),   { LightMagenta; }
   (c: 62; r:63; g:63; b: 0),   { Yellow; }
   (c: 63; r:63; g:63; b:63) ); { White; }

const
  BlackPalette : RGBArrayRecordType = (
   (c:  0; r: 0; g: 0; b: 0),   { Black; }
   (c:  1; r: 0; g: 0; b: 0),   { Blue; }
   (c:  2; r: 0; g: 0; b: 0),   { Green; }
   (c:  3; r: 0; g: 0; b: 0),   { Cyan; }
   (c:  4; r: 0; g: 0; b: 0),   { Red; }
   (c:  5; r: 0; g: 0; b: 0),   { Magenta; }
   (c: 20; r: 0; g: 0; b: 0),   { Brown; }
   (c:  7; r:48; g:48; b:48),   { LightGray; }
   (c: 56; r: 0; g: 0; b: 0),   { DarkGray; }
   (c: 57; r: 0; g: 0; b: 0),   { LightBlue; }
   (c: 58; r: 0; g: 0; b: 0),   { LightGreen; }
   (c: 59; r: 0; g: 0; b: 0),   { LightCyan; }
   (c: 60; r: 0; g: 0; b: 0),   { LightRed; }
   (c: 61; r: 0; g: 0; b: 0),   { LightMagenta; }
   (c: 62; r: 0; g: 0; b: 0),   { Yellow; }
   (c: 63; r: 0; g: 0; b: 0) ); { White; }

procedure UsePalette (palette : RGBArrayRecordType);
var i : byte;
begin
  for i := 0 to MaxColors do
    SetRGBPalette (palette[i].c,
                   palette[i].r, palette[i].g, palette[i].b);
end; (* UsePalette *)

procedure DisplayPalette (x0, y0 : integer);
const hight = 20; width = 30; separation = 10;
var i, j, k : integer;
begin
  k := 0;
  for j := 0 to 1 do begin
    for i := 0 to 7 do begin
      SetFillStyle (SolidFill, k);
      Bar (x0+i*(width+separation), y0+j*(hight+separation),
           x0+i*(width+separation)+width, y0+j*(hight+separation)+hight);
      Inc(k);
    end; {for i}
  end; {for j}
end;  (* DisplayPalette *)

var grDriver        : smallint;
    grMode          : smallint;
    ErrCode         : integer;
begin
  grDriver := VGA;
  grMode := VGAHi;
  InitGraph (grDriver, grMode, ' ');
  ErrCode := GraphResult;
  if ErrCode <> grOk then begin
    Writeln ('Graphics error:', GraphErrorMsg(ErrCode)); halt; end;
  ClearDevice;  { Clears and homes the current pointer }
  {}
  SetFillStyle (SolidFill, LightGray);
  Bar (0, 0, GetMaxX, GetMaxy);
  DisplayPalette (50, 50);
  repeat until KeyPressed;
  while KeyPressed do ReadKey;
  {}
  UsePalette (MyPalette);
  DisplayPalette (50, 150);
  repeat until KeyPressed;
  while KeyPressed do ReadKey;
  {}
  UsePalette (BlackPalette);
  DisplayPalette (50, 250);
  repeat until KeyPressed;
  while KeyPressed do ReadKey;
  {}
  UsePalette (DefaultPalette);
  DisplayPalette (50, 350);
  repeat until KeyPressed;
  {}
  RestoreCrtMode;
  CloseGraph;
end.
(*
--------------------------------------------------------------------

   All the best, Timo

....................................................................

Moderating at ftp:// & http://garbo.uwasa.fi archives  193.166.120.5
Department of Accounting and Business Finance  ; University of Vaasa 
*)
