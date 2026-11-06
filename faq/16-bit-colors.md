# How are colors coded in 64k color modes?

In 64k color modes (`m640x480x64k`, `m800x600x64k`…), a color is a 16-bit word in the RGB565 format: 5 bits for red, 6 bits for green, 5 bits for blue.

```
RRRR RGGG GGGB BBBB
```

For example: red `$F800`, green `$07E0`, blue `$001F`, yellow `$FFE0`, magenta `$F81F`, white `$FFFF`.

The constants of the *Graph* unit (`Red`, `Blue`…) are palette indexes: they cannot be used as colors in these modes.

## Converting from 8-bit components

The simplest way is to keep the most significant bits of each component:

```pascal
function RGB565(r, g, b: byte): word;
begin
  result := ((r shr 3) shl 11) or ((g shr 2) shl 5) or (b shr 3);
end;
```

This is what [makeconst](../colornames) does, and the values used in the examples of this collection were computed this way.

Dropping bits truncates the value. To round to the nearest value instead:

```pascal
function RGB565(r, g, b: byte): word;
begin
  result := (Round(r * 31 / 255) shl 11) or (Round(g * 63 / 255) shl 5) or Round(b * 31 / 255);
end;
```

The two functions differ by at most one unit on each component.

Source: [Stack Overflow](https://stackoverflow.com/questions/13720937/c-defined-16bit-high-color).

## Getting a named color

The `makeconst` program of the [colornames](../colornames) folder writes the constants of 256 named colors:

```
$ ./makeconst 16 Orange MidnightBlue
const
  cOrange       = $FD20;
  cMidnightBlue = $18CE;
```
