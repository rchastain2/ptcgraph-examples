
uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  SysUtils, PtcGraph, PtcCrt;

const
  CText = 'Hello by ptcGraph!';
  
var
  grDriver, grMode, grResult: smallint;
  txWidth, txHeight, txLeft, txTop: integer;
  
begin
  grDriver := VESA;
  grMode := m640x480x16m; (* 640 pixels sur 480, 16 777 216 couleurs (2^24). *)
  InitGraph(grDriver, grMode, '');
  
  grResult := GraphResult;
  if grResult = grOk then
  begin
    SetBkColor($0000FF);
    ClearDevice;
    
    txWidth  := TextWidth(CText);
    txHeight := TextHeight(CText);
    txLeft   := (GetMaxX + 1 - txWidth) div 2;
    txTop    := (GetMaxY + 1 - txHeight) div 2;
    
    SetColor($FFFF00);
    OutTextXY(txLeft, txTop, CText);
    
    ReadKey;
    CloseGraph;
  end else
    WriteLn('Failed to start graphic mode: ', GraphErrorMsg(grResult));
end.
