program Dogger;
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt,
  GraphBits, Animals;

var
  Gd, Gm: smallint;
begin
  Gd:= VGA;
  Gm:= VGAHi;
  InitGraph(Gd, Gm, 'C:\tp\bgi');
  
  DrawMovingDog;
  ClearDevice;
  DrawStillDog;
  ClearDevice;
  
  While not KeyPressed do
  begin
    PutImage(0, 0, Dog^, NormalPut);
    Delay(500);
    PutImage(0, 0, MoveDog^, NormalPut);
    Delay(1000);
  end;
end.
