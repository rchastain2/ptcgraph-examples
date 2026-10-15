# The Windows 3.x icon format (single 32×32, 16-colour image)

This document describes the icon file format handled by the `win3-icon` project: a Windows `.ico` file containing **exactly one image, 32×32 pixels, 16 colours (4 bits per pixel)**, stored as an uncompressed device-independent bitmap (DIB) followed by a monochrome transparency mask.

This is the profile used by Windows 3.x and by the development tools of that era (Borland Turbo Pascal for Windows, Delphi 1–5, Resource Workshop…). The `.ico` container itself is still used by modern Windows, but modern files usually hold several images, 32-bit colour with alpha, or embedded PNG data. None of these is covered here.

The format of Windows 1.x and 2.x icons is different (device-dependent) and is not covered either.

---

## 1. Overview

A file of this profile is always **766 bytes** long:

| Offset | Size | Part |
|---:|---:|---|
| 0 | 6 | Icon directory header (`ICONDIR`) |
| 6 | 16 | One directory entry (`ICONDIRENTRY`) |
| 22 | 40 | Bitmap information header (`BITMAPINFOHEADER`) |
| 62 | 64 | Colour table: 16 × `RGBQUAD` |
| 126 | 512 | XOR image: 32 × 32 pixels, 4 bits per pixel |
| 638 | 128 | AND mask: 32 × 32 pixels, 1 bit per pixel |
| **766** | | **End of file** |

The bytes from offset 22 to the end (744 bytes) form the *image resource*. They are what the directory entry points to.

All multi-byte integers are **little-endian**. There is no padding between the parts.

---

## 2. Icon directory header (`ICONDIR`) — offset 0, 6 bytes

| Offset | Size | Field | Value | Meaning |
|---:|---:|---|---|---|
| 0 | 2 | `idReserved` | `0` | Reserved, must be 0. |
| 2 | 2 | `idType` | `1` | Resource type: 1 = icon. (2 would be a cursor, which is out of scope.) |
| 4 | 2 | `idCount` | `1` | Number of images in the file. Always 1 in this profile. |

---

## 3. Directory entry (`ICONDIRENTRY`) — offset 6, 16 bytes

| Offset | Size | Field | Expected value | Meaning |
|---:|---:|---|---|---|
| 6 | 1 | `bWidth` | `32` | Image width in pixels. |
| 7 | 1 | `bHeight` | `32` | Image height in pixels. This is the real height (32), **not** the doubled height of the bitmap header. |
| 8 | 1 | `bColorCount` | `16` | Number of colours. See note below. |
| 9 | 1 | `bReserved` | `0` | Reserved. |
| 10 | 2 | `wPlanes` | `0` (or `1`) | Colour planes. Windows 3.x files leave it at 0; later writers put 1. |
| 12 | 2 | `wBitCount` | `0` (or `4`) | Bits per pixel. Windows 3.x files leave it at 0; later writers put 4. |
| 14 | 4 | `dwBytesInRes` | `744` (`$2E8`) | Size of the image resource: 40 + 64 + 512 + 128. |
| 18 | 4 | `dwImageOffset` | `22` (`$16`) | Offset of the image resource from the start of the file. |

**Note on `bColorCount`.** This field is informative only and is not always correct: the sample file `d5.ico` holds 4 instead of 16, although its bitmap is a regular 4-bit, 16-colour bitmap. The writer of that file seems to have stored the number of bits per pixel instead of the number of colours. **A reader must take the colour depth from `biBitCount`** (section 4), never from `bColorCount`.

The same applies to `wPlanes` and `wBitCount`: they may be 0 (most sample files) or 1 and 4 (`odd-fields.ico`), and must not be relied upon.

---

## 4. Bitmap information header (`BITMAPINFOHEADER`) — offset 22, 40 bytes

| Offset | Size | Field | Expected value | Meaning |
|---:|---:|---|---|---|
| 22 | 4 | `biSize` | `40` | Size of this header. |
| 26 | 4 | `biWidth` | `32` | Width in pixels. |
| 30 | 4 | `biHeight` | `64` | **Twice** the image height: the XOR image (32 rows) plus the AND mask (32 rows). |
| 34 | 2 | `biPlanes` | `1` | Number of planes, always 1. |
| 36 | 2 | `biBitCount` | `4` | Bits per pixel of the XOR image. |
| 38 | 4 | `biCompression` | `0` | `BI_RGB`: no compression. |
| 42 | 4 | `biSizeImage` | `640` (`$280`) | Size of the pixel data: XOR image (512) + AND mask (128). See note below. |
| 46 | 4 | `biXPelsPerMeter` | `0` | Horizontal resolution. Ignored. |
| 50 | 4 | `biYPelsPerMeter` | `0` | Vertical resolution. Ignored. |
| 54 | 4 | `biClrUsed` | `0` | Number of colours used. 0 means "all", i.e. 2^`biBitCount` = 16. |
| 58 | 4 | `biClrImportant` | `0` | Number of important colours. 0 means "all". Ignored. |

**Note on `biSizeImage`.** For an uncompressed bitmap this field may legally be 0, and in practice it is not always consistent. Values found in the sample files: 640 (most files), 512 (`d5.ico`, which counts the XOR image only) and 0 (`odd-fields.ico`). A reader should ignore it and compute sizes from the width, height and bit count.

The resolution fields and `biClrUsed` are also sometimes filled in (`odd-fields.ico` has 72, 72 and 16). They do not change the decoding.

---

## 5. Colour table — offset 62, 64 bytes

Sixteen `RGBQUAD` entries of 4 bytes each, in the order **blue, green, red, reserved**:

| Offset in entry | Field |
|---:|---|
| 0 | `rgbBlue` |
| 1 | `rgbGreen` |
| 2 | `rgbRed` |
| 3 | `rgbReserved` (0) |

Entry *i* (0–15) is at file offset 62 + 4 × *i*. Each pixel of the XOR image is an index into this table.

The table belongs to the file: **any 16 colours are allowed**, and a reader must use the colours actually stored rather than assume a fixed palette. In practice, almost all icons of the period use the 16 colours of the VGA, in one of the two orders below.

### 5.1 Usual order

Found in 5 of the 8 sample files (`blue-checker`, `bp`, `palette`, `tpx`, `turbo`), and in the hard-coded header of RetroNick's `RWICO.PAS` (see section 14).

| Index | R G B (hex) | Colour |
|---:|---|---|
| 0 | `00 00 00` | Black |
| 1 | `80 00 00` | Dark red (maroon) |
| 2 | `00 80 00` | Dark green |
| 3 | `80 80 00` | Dark yellow (olive) |
| 4 | `00 00 80` | Dark blue (navy) |
| 5 | `80 00 80` | Dark magenta (purple) |
| 6 | `00 80 80` | Dark cyan (teal) |
| 7 | `80 80 80` | Dark grey |
| 8 | `C0 C0 C0` | Light grey (silver) |
| 9 | `FF 00 00` | Red |
| 10 | `00 FF 00` | Green |
| 11 | `FF FF 00` | Yellow |
| 12 | `00 00 FF` | Blue |
| 13 | `FF 00 FF` | Magenta |
| 14 | `00 FF FF` | Cyan |
| 15 | `FF FF FF` | White |

Bit 0 of the index selects red, bit 1 green, bit 2 blue, and bit 3 high intensity (except for the two greys).

### 5.2 Alternative order

Found in `d5.ico` and `mml.ico`: identical, except that **indices 7 and 8 are swapped** (7 = light grey `C0C0C0`, 8 = dark grey `808080`), which is the order of the EGA/VGA text-mode colours.

`odd-fields.ico`, the eighth sample file, has a custom palette unrelated to the VGA colours.

### 5.3 Difference with the BGI palette

The default palette of the BGI graphics library (Turbo Pascal `Graph`, Free Pascal `ptcGraph`) follows the EGA order, where **bit 0 selects blue and bit 2 red**: 1 = Blue, 4 = Red, 9 = LightBlue, 12 = LightRed, and 7 = LightGray, 8 = DarkGray.

Drawing the indices of an icon directly with `PutPixel` therefore swaps red and blue (a blue icon such as `blue-checker.ico` appears red) and, for files in the usual order, the two greys. A viewer must either:

- load the 16 colours of the file into the hardware palette, e.g. `SetRGBPalette(i, R, G, B)` with the 8-bit components of the file (Free Pascal's `Graph` and `ptcGraph` take values from 0 to 255 and reduce them to the 6 bits of the VGA DAC themselves), then draw the indices as they are — **this is the exact method**; or
- translate each index through a fixed table, such as the one used by RetroNick's `RWICO.PAS`:
  `(0, 4, 2, 6, 1, 5, 3, 8, 7, 12, 10, 14, 9, 13, 11, 15)`.
  This is only correct for files in the usual order.

---

## 6. XOR image — offset 126, 512 bytes

The colour image, 32 × 32 pixels at 4 bits per pixel.

- **Rows are stored bottom-up**: the first row in the file is the **bottom** row of the image.
- Each row is 32 pixels × 4 bits = **16 bytes**. This is already a multiple of 4, so there is no row padding.
- Each byte holds **two pixels**: the **high nibble** (bits 7–4) is the left pixel, the **low nibble** (bits 3–0) the right pixel.

With *x* from 0 (left) to 31 (right) and *y* from 0 (top) to 31 (bottom):

```
offset = 126 + (31 - y) * 16 + x div 2
index  = byte shr 4        if x is even
index  = byte and $0F      if x is odd
```

---

## 7. AND mask — offset 638, 128 bytes

A monochrome image, 32 × 32 pixels at 1 bit per pixel, that defines transparency.

- **Rows are stored bottom-up**, like the XOR image.
- Each row is 32 bits = **4 bytes**. No padding is needed.
- Within a byte, the **most significant bit** (bit 7) is the **leftmost** pixel.

```
offset = 638 + (31 - y) * 4 + x div 8
bit    = (byte shr (7 - x mod 8)) and 1
```

The mask has no colour table of its own.

---

## 8. How an icon is drawn

Windows draws an icon in two steps, on each pixel of the destination:

```
destination := (destination AND mask) XOR image
```

where `mask` is all ones or all zeros according to the AND bit, and `image` is the colour of the XOR pixel. This gives four cases:

| AND bit | XOR colour | Result | Use |
|:---:|---|---|---|
| 0 | any colour C | C | Opaque pixel. |
| 1 | black (`000000`) | Background unchanged | **Transparent pixel.** |
| 1 | white (`FFFFFF`) | Background inverted | "Inverted screen" pixel. |
| 1 | other colour C | Background XOR C | Rarely intended. |

"Black" and "white" here mean the RGB values `000000` and `FFFFFF`: the XOR operation applies to the colours on screen, not to the indices.

So a well-formed transparent pixel has its AND bit set to 1 **and** its XOR pixel set to black. A simple viewer that does not reproduce the XOR operation can treat every pixel whose AND bit is 1 as transparent.

In the sample files:

| File | Opaque pixels | XOR index under the transparent pixels |
|---|---:|---|
| `blue-checker`, `bp`, `palette`, `tpx`, `turbo` | 1024 (no transparency) | — |
| `d5.ico` | 523 | 0 (black): true transparency |
| `mml.ico` | 678 | 0 (black): true transparency |
| `odd-fields.ico` | 683 | 6, which is black in its own palette: true transparency |

---

## 9. Reading and writing rules

### 9.1 Reader

A reader should **check** these values and reject the file if any of them is wrong:

- file size = 766 (or at least ≥ 766);
- `idReserved` = 0, `idType` = 1, `idCount` = 1;
- `bWidth` = 32, `bHeight` = 32;
- `dwImageOffset` = 22 (or, more tolerant: read the resource at `dwImageOffset`);
- `biSize` = 40, `biWidth` = 32, `biHeight` = 64;
- `biPlanes` = 1, `biBitCount` = 4, `biCompression` = 0.

A reader should **ignore** these values, which are often wrong or zero in real files:

- `bColorCount`, `bReserved`, `wPlanes`, `wBitCount`, `dwBytesInRes`;
- `biSizeImage`, `biXPelsPerMeter`, `biYPelsPerMeter`, `biClrUsed`, `biClrImportant`;
- `rgbReserved`.

It must **keep the colour table** of the file instead of assuming a fixed palette.

### 9.2 Writer

To produce files identical, byte for byte, to the usual reference files (`turbo.ico`, `tpx.ico`, `bp.ico`…), a writer should use these values:

| Field | Value |
|---|---|
| `idReserved`, `idType`, `idCount` | 0, 1, 1 |
| `bWidth`, `bHeight`, `bColorCount`, `bReserved` | 32, 32, 16, 0 |
| `wPlanes`, `wBitCount` | 0, 0 |
| `dwBytesInRes`, `dwImageOffset` | 744, 22 |
| `biSize`, `biWidth`, `biHeight` | 40, 32, 64 |
| `biPlanes`, `biBitCount`, `biCompression` | 1, 4, 0 |
| `biSizeImage` | 640 |
| `biXPelsPerMeter`, `biYPelsPerMeter`, `biClrUsed`, `biClrImportant` | 0, 0, 0, 0 |
| Colour table | the file's palette (by default the usual order of section 5.1) |

It should also set the XOR pixel to black (index of `000000`) wherever the AND bit is 1, so that transparent pixels really are transparent.

Writing 1 and 4 in `wPlanes` and `wBitCount` is also valid, and is what later versions of Windows produce; it simply breaks the byte-for-byte comparison with the Windows 3.x files.

---

## 10. Reference dump

The first 126 bytes of `turbo.ico` (headers and colour table):

```
00000000: 0000 0100 0100 2020 1000 0000 0000 e802  ......  ........
00000010: 0000 1600 0000 2800 0000 2000 0000 4000  ......(... ...@.
00000020: 0000 0100 0400 0000 0000 8002 0000 0000  ................
00000030: 0000 0000 0000 0000 0000 0000 0000 0000  ................
00000040: 0000 0000 8000 0080 0000 0080 8000 8000  ................
00000050: 0000 8000 8000 8080 0000 8080 8000 c0c0  ................
00000060: c000 0000 ff00 00ff 0000 00ff ff00 ff00  ................
00000070: 0000 ff00 ff00 ffff 0000 ffff ff00       ..............
```

Reading it:

| Bytes | Value | Field |
|---|---|---|
| `0000` | 0 | `idReserved` |
| `0100` | 1 | `idType` |
| `0100` | 1 | `idCount` |
| `20` `20` `10` `00` | 32, 32, 16, 0 | `bWidth`, `bHeight`, `bColorCount`, `bReserved` |
| `0000` `0000` | 0, 0 | `wPlanes`, `wBitCount` |
| `e802 0000` | 744 | `dwBytesInRes` |
| `1600 0000` | 22 | `dwImageOffset` |
| `2800 0000` | 40 | `biSize` |
| `2000 0000` `4000 0000` | 32, 64 | `biWidth`, `biHeight` |
| `0100` `0400` | 1, 4 | `biPlanes`, `biBitCount` |
| `0000 0000` | 0 | `biCompression` |
| `8002 0000` | 640 | `biSizeImage` |
| 4 × `0000 0000` | 0 | resolution, `biClrUsed`, `biClrImportant` |
| `0000 0000` `0000 8000` … | | colour table (B, G, R, 0) |

---

## 11. Pascal declarations

```pascal
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
    Colors: array[0..15] of TRGBQuad;
    XorImage: array[0..31, 0..15] of byte;
    AndMask: array[0..31, 0..3] of byte;
  end;
```

`SizeOf(TIconFile)` must be 766. Fixed-size types (`word`, `longword`, `longint`) are used on purpose: the size of `integer` depends on the compiler mode in Free Pascal (16 bits in the default `fpc` and `tp` modes, 32 bits in `objfpc` and `delphi` modes), which would corrupt the layout. In `XorImage` and `AndMask`, the first index is the row **as stored**, i.e. row 0 is the bottom row of the image.

---

## 12. Converting to and from a BMP file

The XOR image and its colour table form a regular 4-bit DIB. A 32×32, 16-colour `.bmp` file is obtained by putting a 14-byte `BITMAPFILEHEADER` in front of them, and is 630 bytes long:

| Offset | Size | Field | Value |
|---:|---:|---|---|
| 0 | 2 | `bfType` | `'BM'` (`$4D42`) |
| 2 | 4 | `bfSize` | 630 |
| 6 | 2 | `bfReserved1` | 0 |
| 8 | 2 | `bfReserved2` | 0 |
| 10 | 4 | `bfOffBits` | 118 (14 + 40 + 64) |
| 14 | 40 | `BITMAPINFOHEADER` | as in section 4, but `biHeight` = **32** and `biSizeImage` = **512** (or 0) |
| 54 | 64 | Colour table | unchanged |
| 118 | 512 | Pixels | the XOR image, unchanged |

The colour indices and the palette are the same in both formats, so no colour translation is needed. The AND mask has no place in a BMP: a converter has to encode transparency some other way (for instance a reserved colour index) and rebuild the mask in the other direction.

Note: a converter that copies `biSizeImage` unchanged from the icon (640) produces a BMP that announces 640 bytes of pixel data in a 630-byte file. It should write 512, or 0.

---

## 13. Sample files

The `samples/` directory holds 8 icons used to check the reader and the writer.

| File | Interest |
|---|---|
| `turbo.ico`, `tpx.ico`, `bp.ico` | Reference files of the period: canonical header values, usual palette order, no transparency. A writer should reproduce them byte for byte. |
| `blue-checker.ico` | Blue and grey checkerboard (indices 4, 8 and 12 only), same header and palette as the reference files. Drawn with the BGI default palette, it appears red: a quick test of the red/blue swap described in section 5.3. |
| `palette.ico` | Colour chart: 16 squares of 8×8 pixels, one per palette index, with the same header and palette as the reference files. Useful to check that a viewer renders every index with the right colour. |
| `d5.ico` | `bColorCount` = 4 and `biSizeImage` = 512; alternative palette order; correct transparency. |
| `mml.ico` | Alternative palette order; correct transparency. |
| `odd-fields.ico` | Test file for a tolerant reader: `wPlanes` = 1, `wBitCount` = 4, `biSizeImage` = 0, resolution fields and `biClrUsed` filled in, custom palette in which black is index 6, not 0 (a writer must look black up in the palette). Not a model to follow. |

---

## 14. Sources

- Microsoft, *Icons* (Win32 documentation): `ICONDIR`, `ICONDIRENTRY` and the description of the AND/XOR masks.
- Microsoft, `BITMAPINFOHEADER` and `RGBQUAD` structures (Win32 documentation).
- Paul Toth, *BMP2ICO* (2001): http://tothpaul.free.fr/sources.php?tools.bmp2ico
- RetroNick, *Raster Master*, `RWICO.PAS`: https://github.com/RetroNick2020/raster-master-dos/blob/main/RM/RWICO.PAS
- Sylvain Maltais, *Corail*, `VIEWICO.PAS`: https://github.com/gladir/corail
- The 8 sample files in `samples/`, analysed byte by byte for this document.
