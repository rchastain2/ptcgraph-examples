# Color names

A table of 256 named colors, taken from [WinGraph](http://math.ubbcluj.ro/~sberinde/wingraph/main.html#colornames), and two programs using it.

| File | Description |
|---|---|
| `colornames.pas` | Unit: the `TColorName` type and the `DATA` table giving, for each color, its name and its 24-bit value (`$RRGGBB`). |
| `colornamesdemo.pas` | Displays the 256 colors with their names, in 1024×768 with 16M colors. |
| `makeconst.pas` | Writes Pascal constants for the named colors, ready to paste into a program. |

## makeconst

In 64k and 16M color modes, the constants of the *Graph* unit (`Red`, `Blue`…) are palette indexes and cannot be used as colors. The examples of this collection declare the colors they need, for instance:

```pascal
const
  cMidnightBlue = $18CE;
  cOrange       = $FD20;
```

`makeconst` writes such declarations. The first parameter, optional, is the color depth: `16` (default) for the 64k color modes, `24` for the 16M color modes. The following parameters are color names; without them, all 256 colors are written.

```
$ ./makeconst 16 MidnightBlue Orange
const
  cMidnightBlue = $18CE;
  cOrange       = $FD20;

$ ./makeconst 24 MidnightBlue Orange
const
  cMidnightBlue = $191970;
  cOrange       = $FFA500;
```
