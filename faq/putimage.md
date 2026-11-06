# What is the structure of the buffer used by PutImage?

The buffer filled by `GetImage` and read by `PutImage` starts with three longints (12 bytes):

- image width;
- image height;
- reserved.

They are followed by `width × height` pixels, line by line:

| Color mode | Pixel |
|---|---|
| 16 colors, 256 colors, 32k colors, 64k colors | 16-bit word. In 64k color modes, the color format is RGB565. |
| 16M colors | 32-bit longword, `$00RRGGBB`. |

This makes it possible to draw into a memory buffer with another library, then to display the result with `PutImage`. See the [agg](../agg) folder for examples with AggPas.

`ImageSize` gives the size of the buffer, header included.

Source: [message of Nikolay Nikolov](http://free-pascal-general.1045716.n5.nabble.com/Implementing-AggPas-with-PtcGraph-tp5728957p5728982.html), author of *ptcGraph*, on the fpc-pascal mailing list. At the time, 64k colors were the highest color depth supported; 16M color modes have been added since.
