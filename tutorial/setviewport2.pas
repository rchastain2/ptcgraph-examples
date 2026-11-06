program setviewport2;

uses
{$IFDEF UNIX}
  CThreads,
{$ENDIF}
  ptcGraph, ptcCrt;

const
  cDarkOrange  = $FC60;
  cRed         = $F800;
  cYellowGreen = $9E66;

var
  gd, gm: smallint;

begin
  gd := VESA;
  gm := m640x480x64k;
  WindowTitle := 'SetViewPort demo';
  InitGraph(gd, gm, '');
  if GraphResult = grOk then
  begin
    SetBkColor(cDarkOrange);
    ClearDevice;
    SetViewPort(320, 0, 639, 479, ClipOn);
    SetBkColor(cYellowGreen);
    ClearViewPort;
    SetColor(cRed);
    Rectangle(10, 10, 309, 469);
    ReadKey;
    CloseGraph;
  end;
end.
