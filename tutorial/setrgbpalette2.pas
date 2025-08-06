{ Example for SetRGBPalette with VGA 16 color modes }
program setrgbpal1;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt;

type
  RGBRec = record
    RedVal, GreenVal, BlueVal : Integer;
     { Intensity values (values from 0 to 63) }
    Name: String;
    ColorNum: Integer;
     { The VGA color palette number as mapped into 16 color palette }
  end;
  
const
  { Table of suggested colors for VGA 16 color modes }
  cMaxColors = 15;
  Colors : array[0..{MaxColors}cMaxColors] of RGBRec = (
   ( RedVal:0;GreenVal:0;BlueVal:0;Name:'Black';ColorNum: 0),
   ( RedVal:0;GreenVal:0;BlueVal:40;Name:'Blue';ColorNum: 1),
   ( RedVal:0;GreenVal:40;BlueVal:0;Name:'Green';ColorNum: 2),
   ( RedVal:0;GreenVal:40;BlueVal:40;Name:'Cyan';ColorNum: 3),
   ( RedVal:40;GreenVal:7;BlueVal:7;Name:'Red';ColorNum: 4),
   ( RedVal:40;GreenVal:0;BlueVal:40;Name:'Magenta';ColorNum: 5),
   ( RedVal:40;GreenVal:30; BlueVal:0;Name:'Brown';ColorNum: 20),
   ( RedVal:49;GreenVal:49;BlueVal:49;Name:'Light Gray';ColorNum: 7),
   ( RedVal:26;GreenVal:26;BlueVal:26;Name:'Dark Gray';ColorNum: 56),
   ( RedVal:0;GreenVal:0;BlueVal:63;Name:'Light Blue';ColorNum: 57),
   ( RedVal:9;GreenVal:63;BlueVal:9;Name:'Light Green';ColorNum: 58),
   ( RedVal:0;GreenVal:63;BlueVal:63;Name:'Light Cyan';ColorNum: 59),
   ( RedVal:63;GreenVal:10;BlueVal:10;Name:'Light Red';ColorNum: 60),
   ( RedVal:44;GreenVal:0;BlueVal:63;Name:'Light Magenta';ColorNum: 61),
   ( RedVal:63;GreenVal:63;BlueVal:18;Name:'Yellow';ColorNum: 62),
   ( RedVal:63; GreenVal:63; BlueVal:63; Name: 'White'; ColorNum: 63)
  );
  
var
  Driver, Mode, I, Error: smallint;
  
begin
  { Initialize Graphics Mode }
  Driver := {d4bit}VGA;
  Mode := {m800x600}VGAHi;
  InitGraph(Driver, Mode, 'C:\TP\BGI');
  Error := GraphResult;
  if Error <> GrOk then
    begin
      writeln(GraphErrorMsg(Error));
      halt(1);
    end;
  SetFillStyle(SolidFill, Green);   { Clear }
  Bar(0, 0, GetMaxX, GetMaxY);
  if GraphResult < 0 then
    Halt(1); { Zero palette, make graphics invisible }
  SetRGBPalette(Colors[0].ColorNum, 63, 63, 63);
  for i := 1 to 15 do
    //with Colors[i] do
      SetRGBPalette({ColorNum}i, 0, 0, 0);

  { Display the color name using its color with an appropriate background }

 { Notice how with the current palette settings, only the text for"Press
   any key...", "Black", "Light Gray", and "White" are visible.This occurs
   because the palette entry for color 0 (Black) has been set to display as
   white. For the text "Light Gray" and "White,"color 0 (Black) is used as
   the background.}
  SetColor(0);
  OutTextXY(0, 10, 'Press Any Key...');
  for I := 0 to 15 do
  begin
    with Colors[I] do
      begin
        SetColor(I);
        //SetFillStyle(SolidFill, (I xor 15) and 7);
        { "(I xor 15)" gives an appropriate background }
        { " and 7" reduces the intensity of the background }
        //Bar(10, (I + 2) * 10 - 1, 10 + TextWidth(Name), (I + 2) * 10 + TextHeight(Name) - 1);
        OutTextXY(10, (I + 2) * 10, Name);
      end;
  end;
  ReadKey;
 { Restore original colors to the palette. The default colors might vary
   depending upon the initial values used by your video system.}
  for i := 0 to 15 do
    with Colors[i] do
      SetRGBPalette({ColorNum}i, RedVal, GreenVal, BlueVal);
  { Wait for a keypress and then quit graphics and end. }
  ReadKey;
  Closegraph;
end.
