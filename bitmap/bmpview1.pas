
(* http://www.freepascal.ru/forum/viewtopic.php?f=1&t=43571&p=165870#p165870 *)

program BMPViewer;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;

const
  CFileName = 'bmpview1.bmp';

var
  GraphDriver, GraphMode, GraphError: smallint;
  ErrorMessage: string;

function DrawBMP(FileName: string; X, Y: Integer; out ErrorMessage: string): Boolean;
type
  TBitmapFileHeader = packed record
    bfType: Word;
    bfSize: Longint;
    bfReserved1: Word;
    bfReserved2: Word;
    bfOffBits: Longint;
  end;
  TBitmapInfoHeader = packed record
    biSize: DWORD;
    biWidth: Longint;
    biHeight: Longint;
    biPlanes: Word;
    biBitCount: Word;
    biCompression: DWORD;
    biSizeImage: DWORD;
    biXPelsPerMeter: Longint;
    biYPelsPerMeter: Longint;
    biClrUsed: DWORD;
    biClrImportant: DWORD;
  end;
  TRGBQuad = packed record
    B, G, R, Reserved: Byte;
  end;
var
  BitmapFile: file;
  BitmapFileHeader: TBitmapFileHeader;
  BitmapInfoHeader: TBitmapInfoHeader;
  Palette: array[0..255] of TRGBQuad;
  Masks: array[0..2] of DWORD;
  PaletteSize: Integer;
  BitmapLine: PByte;
  RowSize: Integer;
  W, H: Integer;
  TopDown: Boolean;
  I, J, Row: Integer;
  Index: Byte;
  Color: Longint;

function RGB(R, G, B: Byte): Longint;
begin
  Result := (R shl 16) or (G shl 8) or B;
end;

begin
  Result := False;
  ErrorMessage := '';

  Assign(BitmapFile, FileName); // открытие файла
  {$I-}
  Reset(BitmapFile, 1);
  {$I+}
  if IOResult <> 0 then
  begin
    ErrorMessage := 'Cannot open ' + FileName;
    Exit;
  end;

  BitmapLine := nil;
  try
    FillChar(BitmapFileHeader, SizeOf(BitmapFileHeader), 0);
    FillChar(BitmapInfoHeader, SizeOf(BitmapInfoHeader), 0);
    BlockRead(BitmapFile, BitmapFileHeader, SizeOf(BitmapFileHeader)); // чтение заголовка файла
    BlockRead(BitmapFile, BitmapInfoHeader, SizeOf(BitmapInfoHeader)); // чтение заголовка изображения

    if BitmapFileHeader.bfType <> $4D42 then
    begin
      ErrorMessage := 'Not a BMP file';
      Exit;
    end;
    if BitmapInfoHeader.biSize < SizeOf(TBitmapInfoHeader) then
    begin
      ErrorMessage := 'Unsupported BMP header';
      Exit;
    end;
    if (BitmapInfoHeader.biCompression = 3) and (BitmapInfoHeader.biBitCount = 32) then
    begin
      BlockRead(BitmapFile, Masks, SizeOf(Masks));
      if (Masks[0] = $00FF0000) and (Masks[1] = $0000FF00) and (Masks[2] = $000000FF) then
        BitmapInfoHeader.biCompression := 0;
    end;
    if BitmapInfoHeader.biCompression <> 0 then
    begin
      ErrorMessage := 'Compressed BMP files are not supported';
      Exit;
    end;
    if not (BitmapInfoHeader.biBitCount in [1, 4, 8, 24, 32]) then
    begin
      ErrorMessage := 'Unsupported color depth';
      Exit;
    end;

    W := BitmapInfoHeader.biWidth; // ширина изображения
    H := Abs(BitmapInfoHeader.biHeight); // высота изображения
    TopDown := BitmapInfoHeader.biHeight < 0;

    if BitmapInfoHeader.biBitCount <= 8 then // если глубина цвета меньше или равна 8 битам
    begin
      PaletteSize := BitmapInfoHeader.biClrUsed;
      if (PaletteSize = 0) or (PaletteSize > 1 shl BitmapInfoHeader.biBitCount) then
        PaletteSize := 1 shl BitmapInfoHeader.biBitCount;
      FillChar(Palette, SizeOf(Palette), 0);
      Seek(BitmapFile, SizeOf(TBitmapFileHeader) + BitmapInfoHeader.biSize);
      BlockRead(BitmapFile, Palette, PaletteSize * SizeOf(TRGBQuad)); // чтение палитры
    end;

    RowSize := ((W * BitmapInfoHeader.biBitCount + 31) div 32) * 4;
    GetMem(BitmapLine, RowSize); // выделение памяти под строку пикселей

    Seek(BitmapFile, BitmapFileHeader.bfOffBits);

    for I := 0 to H - 1 do
    begin
      BlockRead(BitmapFile, BitmapLine^, RowSize);
      if TopDown then
        Row := I
      else
        Row := H - 1 - I;
      for J := 0 to W - 1 do
      begin
        case BitmapInfoHeader.biBitCount of
          1: Index := (BitmapLine[J shr 3] shr (7 - J and 7)) and 1;
          4: Index := (BitmapLine[J shr 1] shr (4 * (1 - J and 1))) and $0F;
          8: Index := BitmapLine[J];
        end;
        case BitmapInfoHeader.biBitCount of
          1, 4, 8:
            Color := RGB(Palette[Index].R, Palette[Index].G, Palette[Index].B);
          24:
            Color := RGB(BitmapLine[3 * J + 2], BitmapLine[3 * J + 1], BitmapLine[3 * J]);
          32:
            Color := RGB(BitmapLine[4 * J + 2], BitmapLine[4 * J + 1], BitmapLine[4 * J]);
        end;
        PutPixel(X + J, Y + Row, Color);
      end;
    end;

    Result := True;
  finally
    if BitmapLine <> nil then
      FreeMem(BitmapLine); // освобождение памяти
    Close(BitmapFile); // закрытие файла
  end;
end;

begin
  GraphDriver := VESA;
  GraphMode := m640x480x16m;
  InitGraph(GraphDriver, GraphMode, ''); // инициализация графического режима
  GraphError := GraphResult;
  if GraphError <> grOk then
  begin
    WriteLn('Graphics error: ', GraphErrorMsg(GraphError));
    Halt(1);
  end;

  if DrawBMP(CFileName, 0, 0, ErrorMessage) then // чтение и вывод BMP-файла на экран
    ReadKey // ожидание нажатия клавиши
  else
  begin
    CloseGraph;
    WriteLn(ErrorMessage);
    Halt(1);
  end;

  CloseGraph; // выход из графического режима
end.
