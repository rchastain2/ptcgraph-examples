# AggPas in RGB565

This example draws with the *Agg2D* object of AggPas into a 16-bit RGB565 buffer, then displays the buffer in a *ptcGraph* window (800×600, 64k colors) with `PutImage`.

It is derived from the [Agg2DConsole.dpr](https://github.com/graemeg/fpGUI/tree/develop/extras/aggpas/agg-demos) demo of fpGUI. The parent folder contains an example that works without any patch, in 16M color mode.

## Patch

The *Agg2D* constructor always uses the 32-bit BGRA pixel format. To draw in another format, such as RGB565, the constructor must take the pixel format as a parameter:

```pascal
constructor Agg2D.Construct(pixfmt: define_pixfmt);
begin
  m_rbuf.Construct;

  pixfmt(m_pixFormat, @m_rbuf);
  pixfmt_custom_blend_rgba(m_pixFormatComp, @m_rbuf, @comp_op_adaptor_rgba, rgba_order);
  pixfmt(m_pixFormatPre, @m_rbuf);
  pixfmt_custom_blend_rgba(m_pixFormatCompPre, @m_rbuf, @comp_op_adaptor_rgba, rgba_order);
  { ... }
```

The *Makefile* applies `agg_2D.patch` to the `agg_2D.pas` unit of fpGUI and saves the result in this folder, where the compiler finds it first. The path of fpGUI can be changed with `make FPGUI=...`.

Rendering seems to work with pixel formats other than RGBA32, but custom blending may need further testing.

## Bitmap structure

The buffer given to `PutImage` starts with three longints (12 bytes): image width, image height, and a reserved value. They are followed by `width × height` 16-bit words. See [this message](http://lists.freepascal.org/pipermail/fpc-pascal/2017-June/051524.html) on the fpc-pascal mailing list.

Other implementations of the *Graph* unit, or other video modes, may need a different structure.

## agg_2D or Agg2D?

AggPas has two similar units. `agg_2D.pas` has no GUI dependency: it is meant for console or web applications, and this is the one used here. `Agg2D.pas` depends on fpGUI, because it implements an fpGUI canvas that uses AggPas for all its drawing.
