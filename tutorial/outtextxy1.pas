
program outtextxy1;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcCrt, ptcGraph;
  
var
  grdriver, grmode: smallint;
  errcode: integer;
  y: longint;
  
begin
  grdriver := VGA;
  grmode := VGAHi;
  InitGraph(grdriver, grmode, '');
  errcode := GraphResult;
  if errcode = grOk then
  begin
    for y := 1 to 15 do
    begin
      SetColor(y);
      OutTextXY(20, y * 20, 'ptcGraph');
    end;
    ReadKey;
    CloseGraph;
  end else
    WriteLn(GraphErrorMsg(errcode));
end.
