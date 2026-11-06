# Turbo Pascal examples

Examples from the Borland Turbo Pascal documentation, ported to *ptcGraph*. They are compiled in Turbo Pascal mode (`-Mtp`).

| File | Source | Description |
|---|---|---|
| `figures.pas` | *Turbo Pascal 6.0 User's Guide*, chapter 4 | Unit: a hierarchy of graphic objects (point, circle). |
| `figdemo.pas` | *Turbo Pascal 6.0 User's Guide*, chapter 4 | Extends *Figures* with an arc type, and drags a circle with the arrow keys. |
| `listdemo.pas` | *Turbo Pascal 6.0 User's Guide*, chapter 4 | Dynamic objects and destructors: a linked list of figures. |
| `tvguid20.pas` | *Turbo Vision Guide* | A collection of graphic objects, displayed with the *ForEach* iterator. |
| `tvguid21.pas` | *Turbo Vision Guide* | The same collection, saved to the stream `GRAPHICS.STM`. |
| `tvguid22.pas` | *Turbo Vision Guide* | Loads the collection from `GRAPHICS.STM` and displays it. Run `tvguid21` first. |
| `bgidemo.pas` | Borland, 1992 | Demonstration of most features of the *Graph* unit. |

The *Turbo Vision Guide* examples use the *Objects* unit of Free Pascal, for collections and streams.
