uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;

var
  gd, gm   : smallint;
  ViewPort : ViewPortType;

begin
  gd := VESA;
  gm := InstallUserMode(256, 256, 16, 1, 10000, 10000);
  if gm < 0 then
  begin
    WriteLn(ErrOutput, 'Error installing user mode: ', GraphErrorMsg(gm));
    Halt(1);
  end;
  InitGraph(gd, gm, 'X:\BP');
  if GraphResult <> grOk then
    Halt(2);
  SetBkColor(DarkGray);
  ClearDevice;
  GetViewSettings(ViewPort);
  with ViewPort do
  begin
    Rectangle(0, 0, X2 - X1, Y2 - Y1);
    if Clip then
      OutTextXY(2, 2, 'Clipping is active.')
    else
      OutTextXY(2, 2, 'No clipping today.');
  end;
  ReadKey;
  CloseGraph;
end.
