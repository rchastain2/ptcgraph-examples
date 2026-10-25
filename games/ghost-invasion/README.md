
# Ghost Invasion

Pac-Man clone written for Turbo Pascal by George M. Tzoumas, ported to Free Pascal by [RetroNick2020](https://github.com/RetroNick2020) and [rchastain2](https://github.com/rchastain2).

## Compilation

```
make
```

Use `make release` for an optimized build and `make editor` for the level editor.

## Usage

Run `./mspacman` from the project directory. Use the arrow keys to move, and press Escape to quit.

Cheat keys:

| Key | Action |
|---|---|
| F5 | Score up by 1000 points |
| F6 | Extra life |
| F7 | Eat a power pill |
| F8 | Toggle invisible mode |
| F9 | Skip level |

## Level editor

Run `./editor <file>` from the project directory, for example `./editor mazes/pclv1`. If the file does not exist, a new level is started and will be saved under that name (`level` by default).

| Key | Action |
|---|---|
| Arrows | Move the cursor |
| `+` / `-` | Select the next/previous tile |
| Space | Put the selected tile |
| Enter | Erase the tile |
| F2 | Save the level |
| F3 | Reload the level from the file |
| Ctrl+D | Count the dots |
| Ctrl+L | Clear the level |
| Ctrl+N / Ctrl+Y | Insert/delete a line |
| Ctrl+S / Ctrl+A | Insert/delete a column |
| Escape | Quit |

## Links

* [MSPACMAN](http://cgi.di.uoa.gr/~geotz/dos/)
* [Discussion](https://forum.lazarus.freepascal.org/index.php/topic,54531.0.html)

## Screenshot

![Screenshot](screenshot.png)
