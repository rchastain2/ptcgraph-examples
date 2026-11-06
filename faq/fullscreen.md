# How do I open the graphic window in full screen?

Set the `FullScreenGraph` variable of *ptcGraph* before calling `InitGraph`:

```pascal
ptcGraph.FullScreenGraph := True;
gd := ptcGraph.Detect;
ptcGraph.InitGraph(gd, gm, '');
```
