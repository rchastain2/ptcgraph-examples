
program setviewport2;

uses
{$IFDEF UNIX}
  CThreads,
{$ENDIF}
  SysUtils, ptcGraph, ptcCrt, ptcGraph1, Colors16;
  
begin
  if OpenGraph(640, 480, 16, 'SetViewPort demo') then
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
