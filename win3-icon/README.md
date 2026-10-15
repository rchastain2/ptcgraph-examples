# win3-icon

Free Pascal tools for the Windows 3.x icon format: `.ico` files holding a single 32×32, 16-colour image.

- `FORMAT.md` — a precise description of the format, byte by byte.
- `win3icon.pas` — a unit to read and write these files.
- `iconview.pas` — an icon viewer based on ptcGraph.
- `iconedit.pas` — a simple icon editor based on ptcGraph and ptcMouse.
- `icontest.pas` — a test program for the unit.
- `example.pas` — an example that creates an icon by program.
- `example2.pas` — an example that redefines the palette.
- `samples/` — test icons, described in section 13 of `FORMAT.md`.

## Building

The programs require Free Pascal (tested with 3.2.2) and its `ptcGraph`, `ptcCrt` and `ptcMouse` units, which are part of the standard `graph` package.

```
make          # build all programs
make test     # build icontest and run it on samples/
make clean    # remove the compiled files
```

## The unit

`win3icon` decodes a file into a `TWin3Icon` record, which is easy to work with:

```pascal
TWin3Icon = record
  Palette: TIconPalette;      { 16 colours: Red, Green, Blue }
  Pixels: TIconPixels;        { [y, x], row 0 at the top, values 0..15 }
  Transparent: TIconMask;     { [y, x], TRUE where the AND mask is set }
end;
```

Main routines:

| Routine | Purpose |
|---|---|
| `LoadIcon`, `SaveIcon` | Read or write a file. |
| `ReadIcon`, `WriteIcon` | Read or write a stream. |
| `LoadIconFile`, `ReadIconFile` | Read the raw file structure (`TIconFile`) without decoding it. |
| `DecodeIcon`, `EncodeIcon` | Convert between `TIconFile` and `TWin3Icon`. |
| `ClearIcon` | Create a blank icon with the usual palette. |
| `IndexOfColor` | Find a colour in a palette. |
| `IconErrorText` | Describe an error code. |

The reader is tolerant: it only checks the fields that matter and keeps the palette of the file. The writer produces the same header values as the Borland icons of the period, so that `turbo.ico`, `tpx.ico` or `bp.ico` are rewritten byte for byte. The rules are explained in section 9 of `FORMAT.md`.

### Creating an icon by program

`example.pas` draws a disc with coloured stripes on a transparent background and saves it as `example.ico`:

```pascal
ClearIcon(LIcon);
for y := 0 to IconHeight - 1 do
  for x := 0 to IconWidth - 1 do
    if Sqr(x - 15.5) + Sqr(y - 15.5) <= Sqr(15.5) then
      LIcon.Pixels[y, x] := 9 + (x + y) div 16
    else
      LIcon.Transparent[y, x] := TRUE;
LError := SaveIcon('example.ico', LIcon);
```

`ClearIcon` starts from a blank icon (usual palette, all pixels black, none transparent). Pixels take palette indices from 0 to 15, with row 0 at the top; the unit takes care of the bottom-up order of the file and puts black under transparent pixels. To modify an existing icon instead, replace `ClearIcon` with `LoadIcon`.

### Redefining the palette

The 16 colours are not fixed: each icon carries its own palette. `example2.pas` replaces it with a gradient from blue to orange, then fills the icon with a diagonal gradient that uses all 16 entries, and saves it as `example2.ico`:

```pascal
ClearIcon(LIcon);
for i := 0 to IconColorCount - 1 do
  with LIcon.Palette[i] do
  begin
    Red := i * 17;
    Green := i * 8;
    Blue := 255 - i * 17;
  end;
for y := 0 to IconHeight - 1 do
  for x := 0 to IconWidth - 1 do
    LIcon.Pixels[y, x] := (x + y) * IconColorCount div (IconWidth + IconHeight - 1);
LError := SaveIcon('example2.ico', LIcon);
```

A whole palette can also be assigned at once, e.g. `LIcon.Palette := AlternativePalette`. If the icon has transparent pixels, keep black (`000000`) somewhere in the palette: the writer puts the index of black under transparent pixels, and falls back to index 0 when there is none, which would not be transparent on screen (see section 8 of `FORMAT.md`).

## The viewer

```
./iconview FILE.ico ...
./iconview samples
```

It shows the icon enlarged, at actual size and at double size, with the palette of the file, the raw header fields (in red when they differ from the usual values) and the number of transparent pixels.

| Key | Action |
|---|---|
| Left / Right, PgUp / PgDn | Previous / next file |
| Home / End | First / last file |
| G | Show or hide the grid |
| B | Change the background of transparent pixels (checker, black, white) |
| Esc, Q | Quit |

## The editor

```
./iconedit FILE.ico
```

The file is opened if it exists, otherwise a new white icon is created and saved under that name.

- Left click paints with the left colour, right click with the right colour.
- Clicking a colour, or the transparent box, selects it for the left or right button.

| Key | Action |
|---|---|
| P | Pencil |
| F | Fill |
| K | Colour picker (returns to the previous tool) |
| U, Ctrl+Z | Undo |
| S | Save |
| G | Show or hide the grid |
| Esc, Q | Quit (asks for confirmation if the icon was modified) |

## Credits

This project builds on earlier work by:

- Paul Toth, *BMP2ICO*: http://tothpaul.free.fr/sources.php?tools.bmp2ico
- RetroNick, *Raster Master*, `RWICO.PAS`: https://github.com/RetroNick2020/raster-master-dos/blob/main/RM/RWICO.PAS and https://github.com/RetroNick2020/raster-master/discussions/34#discussioncomment-16262434
- Sylvain Maltais, *Corail*, `VIEWICO.PAS`: https://github.com/gladir/corail
