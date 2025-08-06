
program outtextxy2;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcCrt, ptcGraph;

var 
  s: string;
  gd, gm: smallint;
  errcode: smallint;

begin
  gd := VGA;
  gm := VGAHi;
  InitGraph(gd, gm, '');
  SetColor(Green);
  errcode := GraphResult;
  if errcode = grOK then
  begin
    s := 'Hello world by ptcGraph';
    OutTextXY(
      (GetMaxX - TextWidth (s)) div 2,
      (GetMaxY - TextHeight(s)) div 2,
      s
    );
    ReadKey;
    CloseGraph;
  end;
end.
