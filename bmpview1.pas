
(* http://www.freepascal.ru/forum/viewtopic.php?f=1&t=43571&p=165870#p165870 *)

program BMPViewer;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;

var
  GraphDriver, GraphMode: smallint;

procedure DrawBMP(FileName: string; X, Y: Integer);
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
  TRGB = packed record
    B, G, R: Byte;
  end;
  TRGBArray = array[Word] of TRGB;
  PRGBArray = ^TRGBArray;
  TRGBTriple = packed record
    rgbtBlue: Byte;
    rgbtGreen: Byte;
    rgbtRed: Byte;
  end;
var
  BitmapFile: file;
  BitmapFileHeader: TBitmapFileHeader;
  BitmapInfoHeader: TBitmapInfoHeader;
  Palette: array[0..255] of TRGBTriple;
  BitmapLine: PRGBArray;
  W, H: Integer;
  I, J: Integer;
  Padding: array[0..3] of Byte;
  PaddingSize: Integer;

function RGB(R, G, B: Byte): Longint;
begin
  Result := (R or (G shl 8) or (B shl 16));
end;

begin
  Assign(BitmapFile, FileName); // открытие файла
  Reset(BitmapFile, 1);
  BlockRead(BitmapFile, BitmapFileHeader, SizeOf(BitmapFileHeader)); // чтение заголовка файла
  BlockRead(BitmapFile, BitmapInfoHeader, SizeOf(BitmapInfoHeader)); // чтение заголовка изображения

  W := BitmapInfoHeader.biWidth; // ширина изображения
  H := BitmapInfoHeader.biHeight; // высота изображения

  if BitmapInfoHeader.biBitCount <= 8 then // если глубина цвета меньше или равна 8 битам
    BlockRead(BitmapFile, Palette, (1 shl BitmapInfoHeader.biBitCount) * SizeOf(TRGBTriple)); // чтение палитры

  GetMem(BitmapLine, W * SizeOf(TRGB)); // выделение памяти под строку пикселей

  PaddingSize := (4 - (W * SizeOf(TRGB)) mod 4) mod 4; // Если длина строки не кратна 4 байтам,
  //то в конце строки добавляются дополнительные байты (называемые “отступами” или “паддингом”),
  //чтобы выровнять длину строки по границе 4 байт.

  for I := H - 1 downto 0 do
  begin
    BlockRead(BitmapFile, BitmapLine^, W * SizeOf(TRGB));
    BlockRead(BitmapFile, Padding, PaddingSize);
    for J := 0 to W - 1 do
      PutPixel(X + J, Y + I, RGB(BitmapLine^[J].B, BitmapLine^[J].G, BitmapLine^[J].R));
  end;

  FreeMem(BitmapLine); // освобождение памяти
  Close(BitmapFile); // закрытие файла
end;


begin
  GraphDriver := VESA;
  GraphMode := m640x480x16m;
  InitGraph(GraphDriver, GraphMode, ''); // инициализация графического режима

  DrawBMP('bmpview1.bmp', 0, 0); // чтение и вывод BMP-файла на экран

  ReadKey; // ожидание нажатия клавиши
  CloseGraph; // выход из графического режима
end.
