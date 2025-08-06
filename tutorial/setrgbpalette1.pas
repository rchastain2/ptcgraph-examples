
program setrgbpal1;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;

type
  RGBRec = record
    RedVal, GreenVal, BlueVal: Integer;
  end;
  
const
  cMaxColors = 15;
  EGAColors: array[0..{MaxColors}cMaxColors] of RGBRec =
    (                                     {NAME       COLOR}
    (RedVal:$00;GreenVal:$00;BlueVal:$00),{Black      EGA  0}
    (RedVal:$00;GreenVal:$00;BlueVal:$FC),{Blue       EGA  1}
    (RedVal:$24;GreenVal:$FC;BlueVal:$24),{Green      EGA  2}
    (RedVal:$00;GreenVal:$FC;BlueVal:$FC),{Cyan       EGA  3}
    (RedVal:$FC;GreenVal:$14;BlueVal:$14),{Red        EGA  4}
    (RedVal:$B0;GreenVal:$00;BlueVal:$FC),{Magenta    EGA  5}
    (RedVal:$70;GreenVal:$48;BlueVal:$00),{Brown      EGA 20}
    (RedVal:$C4;GreenVal:$C4;BlueVal:$C4),{White      EGA  7}
    (RedVal:$34;GreenVal:$34;BlueVal:$34),{Gray       EGA 56}
    (RedVal:$00;GreenVal:$00;BlueVal:$70),{Lt Blue    EGA 57}
    (RedVal:$00;GreenVal:$70;BlueVal:$00),{Lt Green   EGA 58}
    (RedVal:$00;GreenVal:$70;BlueVal:$70),{Lt Cyan    EGA 59}
    (RedVal:$70;GreenVal:$00;BlueVal:$00),{Lt Red     EGA 60}
    (RedVal:$70;GreenVal:$00;BlueVal:$70),{Lt Magenta EGA 61}
    (RedVal:$FC;GreenVal:$FC;BlueVal:$24),{Yellow     EGA 62}
    (RedVal:$FC;GreenVal:$FC;BlueVal:$FC) {Br. White  EGA 63}
    );
    
var
  Driver, Mode, I: smallint;
  
begin
  Driver := IBM8514;   { Override detection }
  Mode := IBM8514Hi;
  InitGraph(Driver, Mode, '');   { Put in graphics mode }
  if GraphResult < 0 then
    Halt(1);
  { Zero palette, make all graphics output invisible }
  for I := 0 to MaxColors do
    with EGAColors[I] do
      SetRGBPalette(I, 0, 0, 0);
  { Display something }
  { Change first 16 8514 palette entries }
  for I := 1 to MaxColors do
  begin
    SetColor(I);
    OutTextXY(10, I * 10, ' ..Press any key.. ');
  end;
  { Restore default EGA colors to 8514 palette }
  for I := 0 to MaxColors do
    with EGAColors[I] do
      SetRGBPalette(I, RedVal, GreenVal, BlueVal);
  ReadKey;
  CloseGraph;
end.
