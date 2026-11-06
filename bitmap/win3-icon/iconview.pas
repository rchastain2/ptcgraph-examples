program iconview;

{$MODE objfpc}{$H+}

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  Classes, SysUtils, ptcGraph, ptcCrt, win3icon;

const
  Zoom = 12;
  ZoomLeft = 16;
  ZoomTop = 32;
  PanelLeft = 416;

  ColorBack = 16;
  ColorText = 17;
  ColorDim = 18;
  ColorCheckLight = 19;
  ColorCheckDark = 20;
  ColorGrid = 21;
  ColorBlack = 22;
  ColorWhite = 23;
  ColorError = 24;

type
  TBackground = (bgChecker, bgBlack, bgWhite);

var
  GFiles: TStringList;
  GIndex: integer;
  GGrid: boolean;
  GBackground: TBackground;

procedure SetUIPalette;
begin
  SetRGBPalette(ColorBack, 48, 48, 56);
  SetRGBPalette(ColorText, 240, 240, 240);
  SetRGBPalette(ColorDim, 150, 150, 160);
  SetRGBPalette(ColorCheckLight, 204, 204, 204);
  SetRGBPalette(ColorCheckDark, 153, 153, 153);
  SetRGBPalette(ColorGrid, 80, 80, 96);
  SetRGBPalette(ColorBlack, 0, 0, 0);
  SetRGBPalette(ColorWhite, 255, 255, 255);
  SetRGBPalette(ColorError, 255, 96, 96);
end;

procedure SetIconPalette(const APalette: TIconPalette);
var
  i: integer;
begin
  for i := 0 to IconColorCount - 1 do
    with APalette[i] do
      SetRGBPalette(i, Red, Green, Blue);
end;

procedure FillBox(ALeft, ATop, ARight, ABottom: integer; AColor: word);
begin
  SetFillStyle(SolidFill, AColor);
  Bar(ALeft, ATop, ARight, ABottom);
end;

procedure DrawText(AX, AY: integer; AColor: word; const AText: string);
begin
  SetColor(AColor);
  OutTextXY(AX, AY, AText);
end;

procedure DrawBackground(ALeft, ATop, ASize, ACell: integer);
var
  x, y: integer;
  c: word;
begin
  case GBackground of
    bgBlack: FillBox(ALeft, ATop, ALeft + ASize - 1, ATop + ASize - 1, ColorBlack);
    bgWhite: FillBox(ALeft, ATop, ALeft + ASize - 1, ATop + ASize - 1, ColorWhite);
  else
    for y := 0 to Pred(ASize div ACell) do
      for x := 0 to Pred(ASize div ACell) do
      begin
        if Odd(x + y) then c := ColorCheckDark else c := ColorCheckLight;
        FillBox(ALeft + x * ACell, ATop + y * ACell, ALeft + (x + 1) * ACell - 1, ATop + (y + 1) * ACell - 1, c);
      end;
  end;
end;

procedure DrawIcon(const AIcon: TWin3Icon; ALeft, ATop, AScale, ACell: integer);
var
  x, y: integer;
begin
  DrawBackground(ALeft, ATop, IconWidth * AScale, ACell);
  for y := 0 to IconHeight - 1 do
    for x := 0 to IconWidth - 1 do
      if not AIcon.Transparent[y, x] then
        if AScale = 1 then
          PutPixel(ALeft + x, ATop + y, AIcon.Pixels[y, x])
        else
          FillBox(ALeft + x * AScale, ATop + y * AScale, ALeft + (x + 1) * AScale - 1, ATop + (y + 1) * AScale - 1, AIcon.Pixels[y, x]);
end;

procedure DrawGrid;
var
  i: integer;
begin
  SetColor(ColorGrid);
  for i := 1 to IconWidth - 1 do
  begin
    Line(ZoomLeft + i * Zoom, ZoomTop, ZoomLeft + i * Zoom, ZoomTop + IconHeight * Zoom - 1);
    Line(ZoomLeft, ZoomTop + i * Zoom, ZoomLeft + IconWidth * Zoom - 1, ZoomTop + i * Zoom);
  end;
end;

function PaletteName(const APalette: TIconPalette): string;
begin
  if CompareMem(@APalette, @UsualPalette, SizeOf(TIconPalette)) then
    result := 'usual'
  else if CompareMem(@APalette, @AlternativePalette, SizeOf(TIconPalette)) then
    result := 'alternative'
  else
    result := 'custom';
end;

procedure DrawPalette(const AIcon: TWin3Icon);
var
  i, x, y, LLeft, LTop: integer;
  LUsed: array[0..IconColorCount - 1] of boolean;
  c: word;
begin
  FillChar(LUsed, SizeOf(LUsed), Ord(FALSE));
  for y := 0 to IconHeight - 1 do
    for x := 0 to IconWidth - 1 do
      if not AIcon.Transparent[y, x] then
        LUsed[AIcon.Pixels[y, x]] := TRUE;

  DrawText(PanelLeft, 112, ColorText, 'Palette (' + PaletteName(AIcon.Palette) + ')');
  for i := 0 to IconColorCount - 1 do
  begin
    LLeft := PanelLeft + (i div 8) * 108;
    LTop := 128 + (i mod 8) * 14;
    SetColor(ColorDim);
    Rectangle(LLeft, LTop, LLeft + 13, LTop + 11);
    FillBox(LLeft + 1, LTop + 1, LLeft + 12, LTop + 10, i);
    if LUsed[i] then c := ColorText else c := ColorDim;
    with AIcon.Palette[i] do
      DrawText(LLeft + 20, LTop + 2, c, IntToHex(i, 1) + ' ' + IntToHex(Red, 2) + IntToHex(Green, 2) + IntToHex(Blue, 2));
  end;
end;

procedure DrawInfo(const AFile: TIconFile; const AIcon: TWin3Icon);
var
  x, y, LCount, LTop: integer;

  procedure Info(const ALabel: string; AValue: int64; AExpected: int64);
  var
    c: word;
  begin
    if AValue = AExpected then c := ColorText else c := ColorError;
    DrawText(PanelLeft, LTop, ColorDim, ALabel);
    DrawText(PanelLeft + 128, LTop, c, IntToStr(AValue));
    Inc(LTop, 12);
  end;

begin
  LCount := 0;
  for y := 0 to IconHeight - 1 do
    for x := 0 to IconWidth - 1 do
      if AIcon.Transparent[y, x] then
        Inc(LCount);

  LTop := 256;
  DrawText(PanelLeft, LTop - 16, ColorText, 'Header');
  with AFile.Entry do
  begin
    Info('bColorCount', bColorCount, IconColorCount);
    Info('wPlanes', LEtoN(wPlanes), 0);
    Info('wBitCount', LEtoN(wBitCount), 0);
    Info('dwBytesInRes', LEtoN(dwBytesInRes), IconResourceSize);
    Info('dwImageOffset', LEtoN(dwImageOffset), IconResourceOffset);
  end;
  with AFile.Header do
  begin
    Info('biSizeImage', LEtoN(biSizeImage), 640);
    Info('biXPelsPerMeter', LEtoN(biXPelsPerMeter), 0);
    Info('biYPelsPerMeter', LEtoN(biYPelsPerMeter), 0);
    Info('biClrUsed', LEtoN(biClrUsed), 0);
  end;
  Inc(LTop, 8);
  DrawText(PanelLeft, LTop, ColorDim, 'Transparent');
  DrawText(PanelLeft + 128, LTop, ColorText, IntToStr(LCount) + ' px');
end;

procedure Show;
const
  CBackground: array[TBackground] of string = ('checker', 'black', 'white');
var
  LFile: TIconFile;
  LIcon: TWin3Icon;
  LError: TIconError;
  LName: string;
begin
  FillBox(0, 0, GetMaxX, GetMaxY, ColorBack);
  LName := GFiles[GIndex];
  DrawText(16, 12, ColorText, ExtractFileName(LName));
  DrawText(PanelLeft, 12, ColorDim, Format('%d / %d', [GIndex + 1, GFiles.Count]));

  LError := LoadIconFile(LName, LFile);
  if LError = ieNone then
    LError := DecodeIcon(LFile, LIcon);

  if LError <> ieNone then
  begin
    DrawText(ZoomLeft, ZoomTop, ColorError, IconErrorText(LError));
  end else
  begin
    SetIconPalette(LIcon.Palette);
    DrawIcon(LIcon, ZoomLeft, ZoomTop, Zoom, Zoom div 2 * 2);
    if GGrid then
      DrawGrid;
    DrawIcon(LIcon, PanelLeft, ZoomTop, 1, 4);
    DrawIcon(LIcon, PanelLeft + 48, ZoomTop, 2, 8);
    DrawPalette(LIcon);
    DrawInfo(LFile, LIcon);
  end;

  DrawText(16, GetMaxY - 40, ColorDim, 'Background: ' + CBackground[GBackground]);
  DrawText(16, GetMaxY - 20, ColorDim, 'Left/Right: file   G: grid   B: background   Esc: quit');
end;

procedure AddFiles(const AName: string);
var
  LSearch: TSearchRec;
  LDir: string;
begin
  if DirectoryExists(AName) then
  begin
    LDir := IncludeTrailingPathDelimiter(AName);
    if FindFirst(LDir + '*.ico', faAnyFile, LSearch) = 0 then
    try
      repeat
        GFiles.Add(LDir + LSearch.Name);
      until FindNext(LSearch) <> 0;
    finally
      FindClose(LSearch);
    end;
  end else
    GFiles.Add(AName);
end;

var
  gd, gm: smallint;
  i: integer;
  LKey: char;
  LQuit, LRedraw: boolean;

begin
  GFiles := TStringList.Create;
  try
    GFiles.Sorted := TRUE;
    GFiles.Duplicates := dupIgnore;
    for i := 1 to ParamCount do
      AddFiles(ParamStr(i));

    if GFiles.Count = 0 then
    begin
      WriteLn('Usage: ', ExtractFileName(ParamStr(0)), ' FILE.ico | DIRECTORY ...');
      Halt(1);
    end;

    gd := D8bit;
    gm := m640x480;
    InitGraph(gd, gm, '');
    if GraphResult <> grOk then
    begin
      WriteLn('Cannot initialize graphics');
      Halt(1);
    end;

    SetUIPalette;
    GIndex := 0;
    GGrid := FALSE;
    GBackground := bgChecker;
    LQuit := FALSE;
    LRedraw := TRUE;

    repeat
      if LRedraw then
        Show;
      LRedraw := TRUE;
      LKey := ReadKey;
      case LKey of
        #0:
          case ReadKey of
            #75, #73: if GIndex > 0 then Dec(GIndex) else LRedraw := FALSE;
            #77, #81: if GIndex < GFiles.Count - 1 then Inc(GIndex) else LRedraw := FALSE;
            #71: GIndex := 0;
            #79: GIndex := GFiles.Count - 1;
          else
            LRedraw := FALSE;
          end;
        'g', 'G': GGrid := not GGrid;
        'b', 'B': if GBackground = High(TBackground) then GBackground := Low(TBackground) else Inc(GBackground);
        #27, 'q', 'Q': LQuit := TRUE;
      else
        LRedraw := FALSE;
      end;
    until LQuit;

    CloseGraph;
  finally
    GFiles.Free;
  end;
end.
