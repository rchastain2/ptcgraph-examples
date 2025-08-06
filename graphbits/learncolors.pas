program Colours;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcCrt,
  ptcGraph,
  GraphBits;
  
const
  Colr: array[0..15] of string = ('Black', 'Blue', 'Green',
    'Cyan', 'Red', 'Magenta', 'Brown',
    'LightGray', 'DarkGray', 'LightBlue',
    'LightGreen', 'LightCyan', 'LightRed',
    'LightMagenta', 'Yellow', 'White');

var
  i: byte;

begin
  GraphicsScreen();
  SetColor(Black);
  i := 0;
  SetTextStyle(3, 0, 6);
  repeat
    SetFillStyle(1, i);
   {FloodFill(1, 1, i);}
    Bar(0, 0, GetMaxX, GetMaxY);
    OutTextXY(20, 200, Colr[i]);
    ReadKey;
    Inc(i);
    ClearDevice;
  until I = 16;
end.
