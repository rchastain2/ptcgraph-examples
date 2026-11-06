# AggPas examples

Examples of drawing with [AggPas](https://github.com/graemeg/fpGUI/tree/develop/framework/src/main/pascal/corelib/render/software), the Pascal port of the *Anti-Grain Geometry* library, and displaying the result in a *ptcGraph* window.

AggPas draws into a memory buffer, with anti-aliasing and transparency. The buffer is then copied to the screen with `PutImage`.

| Example | Description |
|---|---|
| `aggdemo32.pas` | Uses the unmodified *Agg2D* object, in 16M color mode. |
| [rgb565](rgb565) | Draws in 16-bit RGB565, in 64k color mode. Needs a patch of *Agg2D*. |

## Why 16M colors work without a patch

By default, *Agg2D* draws in the 32-bit BGRA format: in memory, the bytes blue, green, red and alpha, that is a 32-bit integer `$AARRGGBB`. In 16M color mode, `PutImage` copies 32-bit integers `$00RRGGBB`. The two formats match, except for the high byte. The buffer given to `PutImage` starts with three longints: image width, image height, and a reserved value.

## Building

The examples use the AggPas units of [fpGUI](https://github.com/graemeg/fpGUI). The *Makefile* looks for fpGUI in `~/Documents/sources/fpgui`; another path can be given with:

```
make FPGUI=/path/to/fpgui
```
