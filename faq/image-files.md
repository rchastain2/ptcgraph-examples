# How do I copy a part of the screen, or save it to a file?

`GetImage` copies a rectangle of the screen into a buffer, `PutImage` draws it back. `ImageSize` gives the size of the buffer (see [putimage.md](putimage.md) for its structure).

## Copying a rectangle

```pascal
procedure ImageCopy(X1, Y1, X2, Y2, X, Y: Integer; Mode: Word);
var
  Image: Pointer;
  Size: LongInt;
begin
  Size := ImageSize(X1, Y1, X2, Y2);
  GetMem(Image, Size);
  GetImage(X1, Y1, X2, Y2, Image^);
  PutImage(X, Y, Image^, Mode);
  FreeMem(Image, Size);
end;
```

`Mode` is one of `NormalPut`, `XorPut`, `OrPut`, `AndPut`, `NotPut`.

## Saving a rectangle to a file, and loading it

The buffer contains the width and the height of the image, so it can be written to a file as it is.

```pascal
procedure ImageSave(X1, Y1, X2, Y2: Integer; const FileName: string);
var
  Image: Pointer;
  Size: LongInt;
  F: file;
begin
  Size := ImageSize(X1, Y1, X2, Y2);
  GetMem(Image, Size);
  GetImage(X1, Y1, X2, Y2, Image^);
  Assign(F, FileName);
  Rewrite(F, 1);
  BlockWrite(F, Image^, Size);
  Close(F);
  FreeMem(Image, Size);
end;

procedure ImageLoad(X, Y: Integer; const FileName: string; Mode: Word);
var
  Image: Pointer;
  Size: LongInt;
  F: file;
begin
  Assign(F, FileName);
  Reset(F, 1);
  Size := FileSize(F);
  GetMem(Image, Size);
  BlockRead(F, Image^, Size);
  Close(F);
  PutImage(X, Y, Image^, Mode);
  FreeMem(Image, Size);
end;
```

The file depends on the color mode: an image saved in a 16M color mode cannot be loaded in a 64k color mode.

## Saving the whole screen

With Turbo Pascal, an image could not exceed 64 KB, so the screen had to be saved in several strips. With *ptcGraph*, `ImageSize` returns a `LongInt` and the whole screen can be saved at once:

```pascal
ImageSave(0, 0, GetMaxX, GetMaxY, 'screen.img');
```

These procedures are adapted from Czech Turbo Pascal code of unknown origin (`ImageCopy`, `ImageSave`, `ImageLoad`) and from a [forum answer](http://computer-programming-forum.com/29-pascal/8df71282e03db4e0.htm) (saving the screen in strips).
