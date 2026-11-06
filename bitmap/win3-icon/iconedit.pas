program iconedit;

{$MODE objfpc}{$H+}

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  SysUtils, Types, ptcGraph, ptcCrt, ptcMouse, win3icon;

const
  Zoom = 12;
  GridLeft = 16;
  GridTop = 32;
  PanelLeft = 416;
  SwatchTop = 120;
  SwatchPitch = 28;
  SwatchSize = 24;
  TransparentTop = SwatchTop + 4 * SwatchPitch + 4;
  CurrentTop = TransparentTop + 40;
  ToolTop = CurrentTop + 48;
  ActionTop = ToolTop + 28;
  ButtonWidth = 64;
  ButtonHeight = 20;
  ButtonPitch = 72;
  MaxUndo = 100;

  Transparent = IconColorCount;

  ColorBack = 16;
  ColorText = 17;
  ColorDim = 18;
  ColorCheckLight = 19;
  ColorCheckDark = 20;
  ColorGrid = 21;
  ColorButton = 22;
  ColorSelected = 23;
  ColorError = 24;

type
  TTool = (tlPencil, tlFill, tlPicker);

const
  ToolNames: array[TTool] of string = ('Pencil', 'Fill', 'Picker');

var
  GFileName: string;
  GIcon: TWin3Icon;
  GUndo: array of TWin3Icon;
  GModified: boolean;
  GGrid: boolean;
  GTool, GPreviousTool: TTool;
  GColor: array[boolean] of integer;
  GMessage: string;
  GMessageColor: word;

procedure SetUIPalette;
begin
  SetRGBPalette(ColorBack, 48, 48, 56);
  SetRGBPalette(ColorText, 240, 240, 240);
  SetRGBPalette(ColorDim, 150, 150, 160);
  SetRGBPalette(ColorCheckLight, 204, 204, 204);
  SetRGBPalette(ColorCheckDark, 153, 153, 153);
  SetRGBPalette(ColorGrid, 80, 80, 96);
  SetRGBPalette(ColorButton, 72, 72, 88);
  SetRGBPalette(ColorSelected, 64, 112, 192);
  SetRGBPalette(ColorError, 255, 96, 96);
end;

procedure SetIconPalette;
var
  i: integer;
begin
  for i := 0 to IconColorCount - 1 do
    with GIcon.Palette[i] do
      SetRGBPalette(i, Red, Green, Blue);
end;

procedure FillBox(ALeft, ATop, ARight, ABottom: integer; AColor: word);
begin
  SetFillStyle(SolidFill, AColor);
  Bar(ALeft, ATop, ARight, ABottom);
end;

procedure DrawText(AX, AY: integer; AColor: word; const AText: string);
begin
  SetColor(AColor);
  OutTextXY(AX, AY, AText);
end;

procedure DrawChecker(ALeft, ATop, ASize, ACell: integer);
var
  x, y: integer;
  c: word;
begin
  for y := 0 to Pred(ASize div ACell) do
    for x := 0 to Pred(ASize div ACell) do
    begin
      if Odd(x + y) then c := ColorCheckDark else c := ColorCheckLight;
      FillBox(ALeft + x * ACell, ATop + y * ACell, ALeft + (x + 1) * ACell - 1, ATop + (y + 1) * ACell - 1, c);
    end;
end;

function GetCell(x, y: integer): integer;
begin
  if GIcon.Transparent[y, x] then
    result := Transparent
  else
    result := GIcon.Pixels[y, x];
end;

procedure DrawColorBox(ALeft, ATop, ASize, AColor: integer);
begin
  if AColor = Transparent then
    DrawChecker(ALeft, ATop, ASize, ASize div 2)
  else
    FillBox(ALeft, ATop, ALeft + ASize - 1, ATop + ASize - 1, AColor);
end;

procedure DrawPreviewPixel(ALeft, ATop, AScale, ACell, x, y: integer);
var
  LColor: integer;
  c: word;
begin
  LColor := GetCell(x, y);
  if LColor = Transparent then
  begin
    if Odd((x * AScale) div ACell + (y * AScale) div ACell) then c := ColorCheckDark else c := ColorCheckLight;
  end else
    c := LColor;
  FillBox(ALeft + x * AScale, ATop + y * AScale, ALeft + (x + 1) * AScale - 1, ATop + (y + 1) * AScale - 1, c);
end;

procedure DrawCell(x, y: integer);
var
  LLeft, LTop: integer;
begin
  LLeft := GridLeft + x * Zoom;
  LTop := GridTop + y * Zoom;
  DrawColorBox(LLeft, LTop, Zoom, GetCell(x, y));
  if GGrid then
  begin
    SetColor(ColorGrid);
    if x > 0 then Line(LLeft, LTop, LLeft, LTop + Zoom - 1);
    if y > 0 then Line(LLeft, LTop, LLeft + Zoom - 1, LTop);
    if x < IconWidth - 1 then Line(LLeft + Zoom, LTop, LLeft + Zoom, LTop + Zoom - 1);
    if y < IconHeight - 1 then Line(LLeft, LTop + Zoom, LLeft + Zoom - 1, LTop + Zoom);
  end;
  DrawPreviewPixel(PanelLeft, GridTop, 1, 4, x, y);
  DrawPreviewPixel(PanelLeft + 48, GridTop, 2, 8, x, y);
end;

procedure DrawTitle;
var
  LTitle: string;
begin
  FillBox(0, 0, GetMaxX, GridTop - 8, ColorBack);
  LTitle := ExtractFileName(GFileName);
  if GModified then
    LTitle := LTitle + ' *';
  DrawText(GridLeft, 12, ColorText, LTitle);
end;

procedure DrawStatus;
begin
  FillBox(0, GetMaxY - 44, GetMaxX, GetMaxY - 30, ColorBack);
  DrawText(GridLeft, GetMaxY - 40, GMessageColor, GMessage);
end;

procedure SetMessage(const AText: string; AColor: word = ColorText);
begin
  GMessage := AText;
  GMessageColor := AColor;
  DrawStatus;
end;

procedure DrawButton(ALeft, ATop: integer; const ACaption: string; ASelected: boolean);
var
  c: word;
begin
  if ASelected then c := ColorSelected else c := ColorButton;
  FillBox(ALeft, ATop, ALeft + ButtonWidth - 1, ATop + ButtonHeight - 1, c);
  SetColor(ColorDim);
  Rectangle(ALeft, ATop, ALeft + ButtonWidth - 1, ATop + ButtonHeight - 1);
  DrawText(ALeft + (ButtonWidth - TextWidth(ACaption)) div 2, ATop + 6, ColorText, ACaption);
end;

procedure DrawTools;
var
  t: TTool;
begin
  for t := Low(TTool) to High(TTool) do
    DrawButton(PanelLeft + Ord(t) * ButtonPitch, ToolTop, ToolNames[t], t = GTool);
  DrawButton(PanelLeft, ActionTop, 'Undo', FALSE);
  DrawButton(PanelLeft + ButtonPitch, ActionTop, 'Save', FALSE);
  DrawButton(PanelLeft + 2 * ButtonPitch, ActionTop, 'Grid', GGrid);
end;

procedure DrawCurrentColors;
var
  b: boolean;
  LLeft: integer;
begin
  FillBox(PanelLeft, CurrentTop, GetMaxX, CurrentTop + SwatchSize + 1, ColorBack);
  for b := FALSE to TRUE do
  begin
    LLeft := PanelLeft + Ord(b) * 108;
    SetColor(ColorDim);
    Rectangle(LLeft, CurrentTop, LLeft + SwatchSize + 1, CurrentTop + SwatchSize + 1);
    DrawColorBox(LLeft + 1, CurrentTop + 1, SwatchSize, GColor[b]);
    if b then
      DrawText(LLeft + SwatchSize + 8, CurrentTop + 9, ColorText, 'Right')
    else
      DrawText(LLeft + SwatchSize + 8, CurrentTop + 9, ColorText, 'Left');
  end;
end;

procedure DrawSwatches;
var
  i, LLeft, LTop: integer;
begin
  DrawText(PanelLeft, SwatchTop - 16, ColorText, 'Colors');
  for i := 0 to IconColorCount - 1 do
  begin
    LLeft := PanelLeft + (i mod 4) * SwatchPitch;
    LTop := SwatchTop + (i div 4) * SwatchPitch;
    SetColor(ColorDim);
    Rectangle(LLeft, LTop, LLeft + SwatchSize + 1, LTop + SwatchSize + 1);
    DrawColorBox(LLeft + 1, LTop + 1, SwatchSize, i);
  end;
  SetColor(ColorDim);
  Rectangle(PanelLeft, TransparentTop, PanelLeft + SwatchSize + 1, TransparentTop + SwatchSize + 1);
  DrawColorBox(PanelLeft + 1, TransparentTop + 1, SwatchSize, Transparent);
  DrawText(PanelLeft + SwatchSize + 8, TransparentTop + 9, ColorText, 'Transparent');
end;

procedure DrawAll;
var
  x, y: integer;
begin
  FillBox(0, 0, GetMaxX, GetMaxY, ColorBack);
  DrawTitle;
  for y := 0 to IconHeight - 1 do
    for x := 0 to IconWidth - 1 do
      DrawCell(x, y);
  DrawSwatches;
  DrawCurrentColors;
  DrawTools;
  DrawStatus;
  DrawText(GridLeft, GetMaxY - 20, ColorDim, 'P pencil  F fill  K picker  U undo  S save  G grid  Esc quit');
end;

procedure SetModified(AValue: boolean);
begin
  if GModified <> AValue then
  begin
    GModified := AValue;
    DrawTitle;
  end;
end;

procedure PushUndo;
begin
  if Length(GUndo) = MaxUndo then
  begin
    Move(GUndo[1], GUndo[0], (MaxUndo - 1) * SizeOf(TWin3Icon));
    SetLength(GUndo, MaxUndo - 1);
  end;
  SetLength(GUndo, Length(GUndo) + 1);
  GUndo[High(GUndo)] := GIcon;
end;

procedure Undo;
var
  x, y: integer;
begin
  if Length(GUndo) = 0 then
  begin
    SetMessage('Nothing to undo', ColorDim);
    Exit;
  end;
  GIcon := GUndo[High(GUndo)];
  SetLength(GUndo, Length(GUndo) - 1);
  for y := 0 to IconHeight - 1 do
    for x := 0 to IconWidth - 1 do
      DrawCell(x, y);
  SetModified(TRUE);
  SetMessage('');
end;

procedure SetCell(x, y, AColor: integer);
begin
  if GetCell(x, y) = AColor then
    Exit;
  if AColor = Transparent then
    GIcon.Transparent[y, x] := TRUE
  else
  begin
    GIcon.Transparent[y, x] := FALSE;
    GIcon.Pixels[y, x] := AColor;
  end;
  DrawCell(x, y);
  SetModified(TRUE);
end;

procedure FloodFill(AX, AY, AColor: integer);
var
  LStack: array of TPoint;
  LCount, LTarget, x, y: integer;

  procedure Push(px, py: integer);
  begin
    if (px < 0) or (py < 0) or (px >= IconWidth) or (py >= IconHeight) then
      Exit;
    if GetCell(px, py) <> LTarget then
      Exit;
    if LCount = Length(LStack) then
      SetLength(LStack, 2 * LCount + 16);
    LStack[LCount] := Point(px, py);
    Inc(LCount);
  end;

begin
  LTarget := GetCell(AX, AY);
  if LTarget = AColor then
    Exit;
  LCount := 0;
  Push(AX, AY);
  while LCount > 0 do
  begin
    Dec(LCount);
    x := LStack[LCount].X;
    y := LStack[LCount].Y;
    if GetCell(x, y) <> LTarget then
      Continue;
    SetCell(x, y, AColor);
    Push(x - 1, y);
    Push(x + 1, y);
    Push(x, y - 1);
    Push(x, y + 1);
  end;
end;

procedure SelectTool(ATool: TTool);
begin
  if ATool = GTool then
    Exit;
  if ATool = tlPicker then
    GPreviousTool := GTool;
  GTool := ATool;
  DrawTools;
end;

procedure ToggleGrid;
var
  x, y: integer;
begin
  GGrid := not GGrid;
  for y := 0 to IconHeight - 1 do
    for x := 0 to IconWidth - 1 do
      DrawCell(x, y);
  DrawTools;
end;

procedure Save;
var
  LError: TIconError;
begin
  LError := SaveIcon(GFileName, GIcon);
  if LError = ieNone then
  begin
    SetModified(FALSE);
    SetMessage('Saved ' + ExtractFileName(GFileName));
  end else
    SetMessage(IconErrorText(LError), ColorError);
end;

function InBox(AX, AY, ALeft, ATop, AWidth, AHeight: integer): boolean;
begin
  result := (AX >= ALeft) and (AY >= ATop) and (AX < ALeft + AWidth) and (AY < ATop + AHeight);
end;

procedure GridClick(AX, AY: integer; ARight, APressed: boolean);
var
  x, y: integer;
begin
  x := (AX - GridLeft) div Zoom;
  y := (AY - GridTop) div Zoom;
  case GTool of
    tlPencil:
      begin
        if APressed then
          PushUndo;
        SetCell(x, y, GColor[ARight]);
      end;
    tlFill:
      if APressed and (GetCell(x, y) <> GColor[ARight]) then
      begin
        PushUndo;
        FloodFill(x, y, GColor[ARight]);
      end;
    tlPicker:
      if APressed then
      begin
        GColor[ARight] := GetCell(x, y);
        DrawCurrentColors;
        SelectTool(GPreviousTool);
      end;
  end;
end;

procedure PanelClick(AX, AY: integer; ARight: boolean);
var
  i: integer;
  t: TTool;
begin
  for i := 0 to IconColorCount - 1 do
    if InBox(AX, AY, PanelLeft + (i mod 4) * SwatchPitch, SwatchTop + (i div 4) * SwatchPitch, SwatchSize + 2, SwatchSize + 2) then
    begin
      GColor[ARight] := i;
      DrawCurrentColors;
      Exit;
    end;
  if InBox(AX, AY, PanelLeft, TransparentTop, SwatchSize + 2, SwatchSize + 2) then
  begin
    GColor[ARight] := Transparent;
    DrawCurrentColors;
    Exit;
  end;
  if ARight then
    Exit;
  for t := Low(TTool) to High(TTool) do
    if InBox(AX, AY, PanelLeft + Ord(t) * ButtonPitch, ToolTop, ButtonWidth, ButtonHeight) then
    begin
      SelectTool(t);
      Exit;
    end;
  if InBox(AX, AY, PanelLeft, ActionTop, ButtonWidth, ButtonHeight) then
    Undo
  else if InBox(AX, AY, PanelLeft + ButtonPitch, ActionTop, ButtonWidth, ButtonHeight) then
    Save
  else if InBox(AX, AY, PanelLeft + 2 * ButtonPitch, ActionTop, ButtonWidth, ButtonHeight) then
    ToggleGrid;
end;

function ConfirmQuit: boolean;
var
  LKey: char;
begin
  if not GModified then
    Exit(TRUE);
  SetMessage('Icon modified. Quit without saving? (Y/N)', ColorError);
  repeat
    LKey := UpCase(ReadKey);
  until LKey in ['Y', 'N', #27];
  result := LKey = 'Y';
  if not result then
    SetMessage('');
end;

var
  gd, gm: smallint;
  LError: TIconError;
  LKey: char;
  LQuit, LRight: boolean;
  LX, LY, LButtons, LPrevButtons: longint;

begin
  if ParamCount <> 1 then
  begin
    WriteLn('Usage: ', ExtractFileName(ParamStr(0)), ' FILE.ico');
    Halt(1);
  end;

  GFileName := ParamStr(1);
  if FileExists(GFileName) then
  begin
    LError := LoadIcon(GFileName, GIcon);
    if LError <> ieNone then
    begin
      WriteLn(GFileName, ': ', IconErrorText(LError));
      Halt(1);
    end;
    GMessage := 'Opened ' + ExtractFileName(GFileName);
  end else
  begin
    ClearIcon(GIcon, 15);
    GMessage := 'New icon';
  end;
  GMessageColor := ColorText;

  gd := D8bit;
  gm := m640x480;
  InitGraph(gd, gm, '');
  if GraphResult <> grOk then
  begin
    WriteLn('Cannot initialize graphics');
    Halt(1);
  end;
  InitMouse;
  ShowMouse;

  SetUIPalette;
  SetIconPalette;
  GModified := FALSE;
  GGrid := TRUE;
  GTool := tlPencil;
  GPreviousTool := tlPencil;
  GColor[FALSE] := 0;
  GColor[TRUE] := Transparent;
  DrawAll;

  LPrevButtons := 0;
  LQuit := FALSE;
  repeat
    if KeyPressed then
    begin
      LKey := ReadKey;
      case LKey of
        #0: ReadKey;
        'p', 'P': SelectTool(tlPencil);
        'f', 'F': SelectTool(tlFill);
        'k', 'K': SelectTool(tlPicker);
        'u', 'U', #26: Undo;
        's', 'S': Save;
        'g', 'G': ToggleGrid;
        #27, 'q', 'Q': LQuit := ConfirmQuit;
      end;
    end;

    GetMouseState(LX, LY, LButtons);
    if (LButtons and (LButton or RButton)) <> 0 then
    begin
      LRight := (LButtons and LButton) = 0;
      if InBox(LX, LY, GridLeft, GridTop, IconWidth * Zoom, IconHeight * Zoom) then
        GridClick(LX, LY, LRight, LPrevButtons = 0)
      else if LPrevButtons = 0 then
        PanelClick(LX, LY, LRight);
    end;
    LPrevButtons := LButtons and (LButton or RButton);

    Delay(10);
  until LQuit;

  CloseGraph;
end.
