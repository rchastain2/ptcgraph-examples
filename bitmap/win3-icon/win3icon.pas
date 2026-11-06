unit win3icon;

{$MODE objfpc}{$H+}

interface

uses
  Classes, SysUtils;

const
  IconWidth = 32;
  IconHeight = 32;
  IconColorCount = 16;
  IconFileSize = 766;
  IconResourceSize = 744;
  IconResourceOffset = 22;

type
  TIconDir = packed record
    idReserved: word;
    idType: word;
    idCount: word;
  end;

  TIconDirEntry = packed record
    bWidth: byte;
    bHeight: byte;
    bColorCount: byte;
    bReserved: byte;
    wPlanes: word;
    wBitCount: word;
    dwBytesInRes: longword;
    dwImageOffset: longword;
  end;

  TBitmapInfoHeader = packed record
    biSize: longword;
    biWidth: longint;
    biHeight: longint;
    biPlanes: word;
    biBitCount: word;
    biCompression: longword;
    biSizeImage: longword;
    biXPelsPerMeter: longint;
    biYPelsPerMeter: longint;
    biClrUsed: longword;
    biClrImportant: longword;
  end;

  TRGBQuad = packed record
    rgbBlue: byte;
    rgbGreen: byte;
    rgbRed: byte;
    rgbReserved: byte;
  end;

  TIconFile = packed record
    Dir: TIconDir;
    Entry: TIconDirEntry;
    Header: TBitmapInfoHeader;
    Colors: array[0..IconColorCount - 1] of TRGBQuad;
    XorImage: array[0..IconHeight - 1, 0..IconWidth div 2 - 1] of byte;
    AndMask: array[0..IconHeight - 1, 0..IconWidth div 8 - 1] of byte;
  end;

  TIconColor = record
    Red: byte;
    Green: byte;
    Blue: byte;
  end;

  TIconPalette = array[0..IconColorCount - 1] of TIconColor;
  TIconPixels = array[0..IconHeight - 1, 0..IconWidth - 1] of byte;
  TIconMask = array[0..IconHeight - 1, 0..IconWidth - 1] of boolean;

  TWin3Icon = record
    Palette: TIconPalette;
    Pixels: TIconPixels;
    Transparent: TIconMask;
  end;

  TIconError = (
    ieNone,
    ieFileOpen,
    ieFileRead,
    ieFileWrite,
    ieTooShort,
    ieBadHeader,
    ieBadEntry,
    ieBadBitmap
  );

const
  UsualPalette: TIconPalette = (
    (Red: $00; Green: $00; Blue: $00),
    (Red: $80; Green: $00; Blue: $00),
    (Red: $00; Green: $80; Blue: $00),
    (Red: $80; Green: $80; Blue: $00),
    (Red: $00; Green: $00; Blue: $80),
    (Red: $80; Green: $00; Blue: $80),
    (Red: $00; Green: $80; Blue: $80),
    (Red: $80; Green: $80; Blue: $80),
    (Red: $C0; Green: $C0; Blue: $C0),
    (Red: $FF; Green: $00; Blue: $00),
    (Red: $00; Green: $FF; Blue: $00),
    (Red: $FF; Green: $FF; Blue: $00),
    (Red: $00; Green: $00; Blue: $FF),
    (Red: $FF; Green: $00; Blue: $FF),
    (Red: $00; Green: $FF; Blue: $FF),
    (Red: $FF; Green: $FF; Blue: $FF)
  );

  AlternativePalette: TIconPalette = (
    (Red: $00; Green: $00; Blue: $00),
    (Red: $80; Green: $00; Blue: $00),
    (Red: $00; Green: $80; Blue: $00),
    (Red: $80; Green: $80; Blue: $00),
    (Red: $00; Green: $00; Blue: $80),
    (Red: $80; Green: $00; Blue: $80),
    (Red: $00; Green: $80; Blue: $80),
    (Red: $C0; Green: $C0; Blue: $C0),
    (Red: $80; Green: $80; Blue: $80),
    (Red: $FF; Green: $00; Blue: $00),
    (Red: $00; Green: $FF; Blue: $00),
    (Red: $FF; Green: $FF; Blue: $00),
    (Red: $00; Green: $00; Blue: $FF),
    (Red: $FF; Green: $00; Blue: $FF),
    (Red: $00; Green: $FF; Blue: $FF),
    (Red: $FF; Green: $FF; Blue: $FF)
  );

function IconErrorText(AError: TIconError): string;
function IndexOfColor(const APalette: TIconPalette; ARed, AGreen, ABlue: byte): integer;
procedure ClearIcon(out AIcon: TWin3Icon; AColor: byte = 0);
function DecodeIcon(const AFile: TIconFile; out AIcon: TWin3Icon): TIconError;
procedure EncodeIcon(const AIcon: TWin3Icon; out AFile: TIconFile);
function ReadIconFile(AStream: TStream; out AFile: TIconFile): TIconError;
function ReadIcon(AStream: TStream; out AIcon: TWin3Icon): TIconError;
function WriteIcon(AStream: TStream; const AIcon: TWin3Icon): TIconError;
function LoadIconFile(const AFileName: string; out AFile: TIconFile): TIconError;
function LoadIcon(const AFileName: string; out AIcon: TWin3Icon): TIconError;
function SaveIcon(const AFileName: string; const AIcon: TWin3Icon): TIconError;

implementation

function IconErrorText(AError: TIconError): string;
begin
  case AError of
    ieNone: result := 'No error';
    ieFileOpen: result := 'Cannot open file';
    ieFileRead: result := 'Cannot read file';
    ieFileWrite: result := 'Cannot write file';
    ieTooShort: result := 'File too short';
    ieBadHeader: result := 'Not a single-image icon file';
    ieBadEntry: result := 'Icon is not 32x32';
    ieBadBitmap: result := 'Bitmap is not an uncompressed 32x32, 16-colour DIB';
  else
    result := 'Unknown error';
  end;
end;

function IndexOfColor(const APalette: TIconPalette; ARed, AGreen, ABlue: byte): integer;
var
  i: integer;
begin
  for i := 0 to IconColorCount - 1 do
    with APalette[i] do
      if (Red = ARed) and (Green = AGreen) and (Blue = ABlue) then
        Exit(i);
  result := -1;
end;

procedure ClearIcon(out AIcon: TWin3Icon; AColor: byte);
begin
  AIcon.Palette := UsualPalette;
  FillChar(AIcon.Pixels, SizeOf(AIcon.Pixels), AColor and $0F);
  FillChar(AIcon.Transparent, SizeOf(AIcon.Transparent), Ord(FALSE));
end;

function DecodeIcon(const AFile: TIconFile; out AIcon: TWin3Icon): TIconError;
var
  i, x, y, row: integer;
  b: byte;
begin
  with AFile.Dir do
    if (idReserved <> 0) or (LEtoN(idType) <> 1) or (LEtoN(idCount) <> 1) then
      Exit(ieBadHeader);

  with AFile.Entry do
    if (bWidth <> IconWidth) or (bHeight <> IconHeight) then
      Exit(ieBadEntry);

  with AFile.Header do
    if (LEtoN(biSize) <> SizeOf(TBitmapInfoHeader))
    or (LEtoN(biWidth) <> IconWidth)
    or (LEtoN(biHeight) <> 2 * IconHeight)
    or (LEtoN(biPlanes) <> 1)
    or (LEtoN(biBitCount) <> 4)
    or (LEtoN(biCompression) <> 0) then
      Exit(ieBadBitmap);

  for i := 0 to IconColorCount - 1 do
  begin
    AIcon.Palette[i].Red := AFile.Colors[i].rgbRed;
    AIcon.Palette[i].Green := AFile.Colors[i].rgbGreen;
    AIcon.Palette[i].Blue := AFile.Colors[i].rgbBlue;
  end;

  for y := 0 to IconHeight - 1 do
  begin
    row := IconHeight - 1 - y;
    for x := 0 to IconWidth - 1 do
    begin
      b := AFile.XorImage[row, x div 2];
      if Odd(x) then
        AIcon.Pixels[y, x] := b and $0F
      else
        AIcon.Pixels[y, x] := b shr 4;
      AIcon.Transparent[y, x] := ((AFile.AndMask[row, x div 8] shr (7 - x mod 8)) and 1) = 1;
    end;
  end;

  result := ieNone;
end;

procedure EncodeIcon(const AIcon: TWin3Icon; out AFile: TIconFile);
var
  i, x, y, row, black: integer;
  index: byte;
begin
  FillChar(AFile, SizeOf(AFile), 0);

  with AFile.Dir do
  begin
    idType := NtoLE(word(1));
    idCount := NtoLE(word(1));
  end;

  with AFile.Entry do
  begin
    bWidth := IconWidth;
    bHeight := IconHeight;
    bColorCount := IconColorCount;
    dwBytesInRes := NtoLE(longword(IconResourceSize));
    dwImageOffset := NtoLE(longword(IconResourceOffset));
  end;

  with AFile.Header do
  begin
    biSize := NtoLE(longword(SizeOf(TBitmapInfoHeader)));
    biWidth := NtoLE(longint(IconWidth));
    biHeight := NtoLE(longint(2 * IconHeight));
    biPlanes := NtoLE(word(1));
    biBitCount := NtoLE(word(4));
    biSizeImage := NtoLE(longword(SizeOf(AFile.XorImage) + SizeOf(AFile.AndMask)));
  end;

  for i := 0 to IconColorCount - 1 do
  begin
    AFile.Colors[i].rgbRed := AIcon.Palette[i].Red;
    AFile.Colors[i].rgbGreen := AIcon.Palette[i].Green;
    AFile.Colors[i].rgbBlue := AIcon.Palette[i].Blue;
  end;

  black := IndexOfColor(AIcon.Palette, 0, 0, 0);
  if black < 0 then
    black := 0;

  for y := 0 to IconHeight - 1 do
  begin
    row := IconHeight - 1 - y;
    for x := 0 to IconWidth - 1 do
    begin
      if AIcon.Transparent[y, x] then
      begin
        index := black;
        AFile.AndMask[row, x div 8] := AFile.AndMask[row, x div 8] or ($80 shr (x mod 8));
      end else
        index := AIcon.Pixels[y, x] and $0F;
      if Odd(x) then
        AFile.XorImage[row, x div 2] := AFile.XorImage[row, x div 2] or index
      else
        AFile.XorImage[row, x div 2] := AFile.XorImage[row, x div 2] or (index shl 4);
    end;
  end;
end;

function ReadIconFile(AStream: TStream; out AFile: TIconFile): TIconError;
var
  LStart: int64;
  LOffset: longword;
begin
  FillChar(AFile, SizeOf(AFile), 0);
  try
    LStart := AStream.Position;
    if AStream.Read(AFile, IconResourceOffset) <> IconResourceOffset then
      Exit(ieTooShort);
    LOffset := LEtoN(AFile.Entry.dwImageOffset);
    if LOffset <> IconResourceOffset then
      AStream.Position := LStart + LOffset;
    if AStream.Read(AFile.Header, IconResourceSize) <> IconResourceSize then
      Exit(ieTooShort);
  except
    Exit(ieFileRead);
  end;
  result := ieNone;
end;

function ReadIcon(AStream: TStream; out AIcon: TWin3Icon): TIconError;
var
  LFile: TIconFile;
begin
  result := ReadIconFile(AStream, LFile);
  if result = ieNone then
    result := DecodeIcon(LFile, AIcon);
end;

function WriteIcon(AStream: TStream; const AIcon: TWin3Icon): TIconError;
var
  LFile: TIconFile;
begin
  EncodeIcon(AIcon, LFile);
  try
    AStream.WriteBuffer(LFile, SizeOf(LFile));
  except
    Exit(ieFileWrite);
  end;
  result := ieNone;
end;

function LoadIconFile(const AFileName: string; out AFile: TIconFile): TIconError;
var
  LStream: TFileStream;
begin
  try
    LStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  except
    Exit(ieFileOpen);
  end;
  try
    result := ReadIconFile(LStream, AFile);
  finally
    LStream.Free;
  end;
end;

function LoadIcon(const AFileName: string; out AIcon: TWin3Icon): TIconError;
var
  LStream: TFileStream;
begin
  try
    LStream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  except
    Exit(ieFileOpen);
  end;
  try
    result := ReadIcon(LStream, AIcon);
  finally
    LStream.Free;
  end;
end;

function SaveIcon(const AFileName: string; const AIcon: TWin3Icon): TIconError;
var
  LStream: TFileStream;
begin
  try
    LStream := TFileStream.Create(AFileName, fmCreate);
  except
    Exit(ieFileOpen);
  end;
  try
    result := WriteIcon(LStream, AIcon);
  finally
    LStream.Free;
  end;
end;

end.
