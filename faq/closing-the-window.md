# How do I know that the user closed the window?

When the user clicks the close button of the window, *ptcCrt* puts the character `#3` (Ctrl+C) in the keyboard buffer. A program waiting for a key can therefore check for it, for example to stop on Escape or when the window is closed:

```pascal
var
  Key: Char;

repeat
  Key := ReadKey;
until (Key = #3) or (Key = #27);
```

`ReadKey` must be called only once per iteration: `until (ReadKey = #3) or (ReadKey = #27)` would read two keys.

Unlike WinGraph, *ptcGraph* has no `CloseGraphRequest` function.
