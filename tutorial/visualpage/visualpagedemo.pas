
program VisualPageDemo;

(*
  Example for SetActivePage and SetVisualPage functions of ptcGraph unit.
*)

{$MODE objfpc}{$H+}
{.$DEFINE PAGES}

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  SysUtils,
  ptcCrt,
  ptcGraph;

var
  LDriver, LMode, LResult: smallint;
  LKey: char;
  LExit: boolean;
  LPage: integer;
  
begin
  WindowTitle := 'Visual page demo';
  LPage := 0;
  LDriver := VESA;
  LMode := m800x600x16m;
  InitGraph(LDriver, LMode, '');
  LResult := GraphResult;
  if LResult <> grOK then
  begin
    WriteLn(GraphErrorMsg(LResult));
    Halt;
  end;
  
  SetBkColor($333333);
  LExit := FALSE;
  
  while not LExit do
  begin
{$IFDEF PAGES}
    SetActivePage(LPage);
{$ENDIF}
    ClearDevice;
    
    SetColor($FFFF00);
    SetFillStyle(SolidFill, $FFFF00);
    FillEllipse(GetMaxX div 2, GetMaxY div 2, GetMaxX div 3, GetMaxY div 3);
{$IFDEF PAGES}
    SetVisualPage(LPage);
{$ENDIF}
    LPage := 1 - LPage;
    
    if KeyPressed then
    begin
      LKey := ReadKey;
      
      if LKey in [#3, #27, 'q', 'Q'] then
        LExit := TRUE;
      
      (*
      if LKey = #0 then
      begin
        LKey := ReadKey;
        // ...
      end;
      *)
    end;
    
    Delay(40);
  end;
  
  CloseGraph;
end.
