# ptcGraph tutorial

Short examples of the procedures and functions of the *Graph* unit, as implemented by *ptcGraph*. Each file is named after the procedure it shows, followed by a number.

## Initialization and graphic modes

| Procedure | Examples |
|---|---|
| `InitGraph` | [initgraph1](initgraph1.pas) |
| `DetectGraph` | [detectgraph1](detectgraph1.pas), [detectgraph2](detectgraph2.pas) |
| `FullScreenGraph` | [fullscreengraph1](fullscreengraph1.pas) |
| `InstallUserMode` | [installusermode1](installusermode1.pas), [installusermode2](installusermode2.pas), [installusermode3](installusermode3.pas) |
| `QueryAdapterInfo` | [queryadapterinfo1](queryadapterinfo1.pas), [queryadapterinfo2](queryadapterinfo2.pas) |
| `D8bit` driver | [d8bit1](d8bit1.pas) |

## Colors and palette

| Procedure | Examples |
|---|---|
| `GetMaxColor` | [getmaxcolor1](getmaxcolor1.pas), [getmaxcolor2](getmaxcolor2.pas) |
| `GetPaletteSize` | [getpalettesize1](getpalettesize1.pas) |
| `SetRGBPalette` | [setrgbpalette1](setrgbpalette1.pas) to [setrgbpalette7](setrgbpalette7.pas) |
| 16-bit RGB colors | [rgbcolor1](rgbcolor1.pas), [rgbcolor2](rgbcolor2.pas) |

## Pixels and lines

| Procedure | Examples |
|---|---|
| `PutPixel` | [putpixel1](putpixel1.pas), [putpixel2](putpixel2.pas), [putpixel3](putpixel3.pas) |
| `GetPixel` | [getpixel1](getpixel1.pas), [getpixel2](getpixel2.pas) |
| `LineTo` | [lineto1](lineto1.pas) |
| `LineRel` | [linerel1](linerel1.pas), [linerel2](linerel2.pas) |
| `DrawPoly` | [drawpoly1](drawpoly1.pas), [drawpoly2](drawpoly2.pas), [drawpoly3](drawpoly3.pas) |
| `Rectangle` | [rectangle1](rectangle1.pas) |

## Arcs and sectors

| Procedure | Examples |
|---|---|
| `Arc` | [arc1](arc1.pas) |
| `GetArcCoords` | [getarccoord1](getarccoord1.pas) |
| `PieSlice` | [pieslice1](pieslice1.pas), [pieslice2](pieslice2.pas) |
| `Sector` | [sector1](sector1.pas), [sector2](sector2.pas) |

## Filling

| Procedure | Examples |
|---|---|
| `Bar` | [bar1](bar1.pas) |
| `Bar3D` | [bar3d1](bar3d1.pas), [bar3d2](bar3d2.pas), [bar3d3](bar3d3.pas) |
| `FloodFill` | [floodfill1](floodfill1.pas), [floodfill2](floodfill2.pas) |
| `SetFillStyle` | [setfillstyle1](setfillstyle1.pas) |

## Text

| Procedure | Examples |
|---|---|
| `OutTextXY` | [outtextxy1](outtextxy1.pas), [outtextxy2](outtextxy2.pas) |
| `SetTextJustify` | [settextjustify1](settextjustify1.pas) |
| `SetTextStyle` | [settextstyle1](settextstyle1.pas), [settextstyle2](settextstyle2.pas), [settextstyle3](settextstyle3.pas) (accented characters, code page 850) |
| `TextWidth` | [textwidth1](textwidth1.pas) |

## Images

| Procedure | Examples |
|---|---|
| `GetImage` | [getimage1](getimage1.pas) to [getimage4](getimage4.pas) |
| `PutImage` | [putimage1](putimage1.pas), [putimage2](putimage2.pas) |

## Viewports and pages

| Procedure | Examples |
|---|---|
| `SetViewPort` | [setviewport1](setviewport1.pas), [setviewport2](setviewport2.pas) |
| `GetViewSettings` | [getviewsettings1](getviewsettings1.pas) |
| `SetActivePage` | [setactivepage1](setactivepage1.pas) |
| `SetVisualPage` | [visualpage](visualpage) (own *Makefile*; build with `make PAGES=1` to use two pages) |

## Keyboard

| Procedure | Examples |
|---|---|
| `ReadKey` | [readkey1](readkey1.pas) |

`putpixel1` reads the picture to draw from `warlord.txt`.

## Source code of ptcGraph

The source code of *ptcGraph* is part of Free Pascal, in `packages/graph/src/ptcgraph`:

- on Linux, it is installed with the *fpc-src* package (for example in `/usr/share/fpcsrc/packages/graph/src/ptcgraph/` on Mageia);
- it can be browsed on [GitLab](https://gitlab.com/freepascal.org/fpc/source/-/tree/main/packages/graph/src/ptcgraph).

The latest version of PTCPas, on which *ptcGraph* is based, is on [SourceForge](https://sourceforge.net/p/ptcpas/code/HEAD/tree/):

```bash
svn checkout https://svn.code.sf.net/p/ptcpas/code/trunk ptcpas-code
```
