
(* https://forum.lazarus.freepascal.org/index.php/topic,72199.msg564719.html#msg564719 *)

program Load_PNG_Example;

{$MODE objfpc}{$H+}

uses
{$IFDEF linux}
  cthreads,
{$ENDIF}
  sysutils, ptcgraph, ptccrt, fpimage, fpreadpng;

type
  TColorType = packed record
    case byte of
      0: (r, g, b, a: byte);
      1: (value: longword);
  end;

function fpColorToColorType(fpColor: TFPColor): TColorType;
begin
  result.value := 0;
  result.r := (fpColor.Red   shr 8) and $00FF;
  result.g := (fpColor.Green shr 8) and $00FF;
  result.b := (fpColor.Blue  shr 8) and $00FF;
end;

procedure start;
var
  gm, gd: smallint;
begin
  gd := vesa;
  gm := installusermode(800, 600, 256, 2, 10000, 8000);
  WindowTitle := 'BW Design';
  initgraph(gd, gm, '');
end;

procedure stop;
begin
  repeat until keypressed;
  closegraph;
end;

procedure load256ColorPng(Filename: string);
var
  Image: TFPMemoryImage;
  ColorType: TColorType;
  x, y, w, h: integer;
  index: integer;
  Color: integer;
begin
  if FileExists(Filename) then
  begin
    Image := TFPMemoryImage.Create(0, 0);
    try
      // have palette load
      Image.UsePalette := true;
      Image.LoadFromFile(Filename);

      // make palette color image copy to ptcpas
      for index := 0 to Image.Palette.Count - 1 do
      begin
        colorType := fpColorToColorType(Image.Palette[Index]);
        SetRGBPalette(index, ColorType.r, ColorType.g, ColorType.b);
      end;

      // make pixel image copy to ptcpas
      x := 100;
      y := 100;
      for w := 0 to Image.Height - 1 do
      begin
        for h := 0 to Image.Width - 1 do
        begin
          Color := Image.Pixels[w, h];
          PutPixel(x + w, y + h, Color);
        end;
      end;
    except
      // Handle file not found or other load errors
      WriteLn('Error loading PNG file');
    end;
  end
  else
    writeln(Filename, ' not exist!');
end;

begin
  start;
  load256ColorPng('color_palette_256_deluxepaint.png');
  stop;
end.
