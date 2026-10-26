
unit Graphics;

interface

uses
  SysUtils,
  Classes,
  StrUtils,
  ptcGraph,
  ptcCrt,
  HighScores,
  Colors16;

type
  TPointColor = (colorSnake, colorApple, colorBackground);
  TScreenArea = (areaLabel1, areaLabel2, areaMain);
  
procedure Settings;
procedure OpenWindow;
procedure SetDrawingContext(const aScreenArea: TScreenArea; const aClearViewPort: boolean = FALSE);
procedure DrawLabel(const aScreenArea: TScreenArea; const aText: string);
procedure DisplayTitle;
procedure DisplaySnakeField;
procedure DisplayGameOver;
procedure DisplayInput(const aInput: string);
procedure DisplayHighScores(const aHighScores: THighScores);
procedure DrawPoint(const aSquare: TPoint; const aColor: TPointColor; const aUpdateScreen: boolean);
procedure DrawCurrentScore(const aScore: integer);
procedure CloseWindow;
function CloseRequest: boolean;

implementation

uses
  Constants;

{$INCLUDE language.inc}

var
  vFieldHeight: integer;
  vSquareWidth: integer;
  vLabelHeight: integer;

type
  TDrawContext = record
    vTop, vBottom, vTextSize: integer;
    vColor, vBkColor: integer;
    constructor Create(const aTop, aBottom, aTextSize: integer; const aColor, aBkColor: integer);
  end;

constructor TDrawContext.Create(const aTop, aBottom, aTextSize: integer; const aColor, aBkColor: integer);
begin
  vTop := aTop;
  vBottom := aBottom;
  vTextSize := aTextSize;
  vColor := aColor;
  vBkColor := aBkColor;
end;

var
  vContextArray: array[TScreenArea] of TDrawContext;
  
procedure Settings;
begin
  vFieldHeight := 201;
  vSquareWidth := vFieldHeight div XMAX;
  vLabelHeight := 24;
  vContextArray[areaLabel1].Create(0, vLabelHeight - 1, 1, cLemonChiffon, cMidnightBlue);
  vContextArray[areaMain].Create(vLabelHeight, vLabelHeight + vFieldHeight - 1, 1, cLemonChiffon, cBlack);
  vContextArray[areaLabel2].Create(vLabelHeight + vFieldHeight, 2 * vLabelHeight + vFieldHeight - 1, 1, cLemonChiffon, cMidnightBlue);
end;

procedure OpenWindow;
var
  vDriver, vMode: smallint;
begin
  vDriver := VESA;
  vMode := InstallUserMode(vFieldHeight, 2 * vLabelHeight + vFieldHeight, 1 shl 16);
  if vMode < 0 then
  begin
    Writeln(ErrOutput, 'Error installing user mode: ', GraphErrorMsg(vMode));
    Halt(1);
  end;
  WindowTitle := GAME_TITLE;
  InitGraph(vDriver, vMode, '');
end;

procedure SetDrawingContext(const aScreenArea: TScreenArea; const aClearViewPort: boolean);
begin
  with vContextArray[aScreenArea] do
  begin
    SetViewPort(0, vTop, vFieldHeight - 1, vBottom, ClipOff);
    SetColor(vColor);
    SetBkColor(vBkColor);
    SetTextStyle(Defaultfont, HorizDir, vTextSize);
    if aClearViewPort then
      ClearViewPort;
  end;
end;

procedure DrawLabel(const aScreenArea: TScreenArea; const aText: string);
begin
  SetDrawingContext(aScreenArea, TRUE);
  OutTextXY((vFieldHeight - TextWidth(aText)) div 2, (vLabelHeight - TextHeight(aText)) div 2, aText);
  SetDrawingContext(areaMain);
end;

procedure DisplayTitle;
var
  vText: string;
  vX, vY: integer;
begin
  SetDrawingContext(areaLabel1, TRUE);
  
  SetDrawingContext(areaMain);
  SetTextStyle(DefaultFont, HorizDir, 3);
  vText := GAME_TITLE;
  vX := (vFieldHeight - TextWidth(vText)) div 2;
  vY := (vFieldHeight - TextHeight(vText)) div 2;
  SetColor(cLimeGreen);
  OutTextXY(Pred(vX), Pred(vY), vText);
  SetColor(cGreen);
  OutTextXY(vX, vY, vText);
  
  SetDrawingContext(areaLabel2, TRUE);
  vText := PRESS_A_KEY;
  OutTextXY((vFieldHeight - TextWidth(vText)) div 2, (vLabelHeight - TextHeight(vText)) div 2, vText);
end;

procedure DisplaySnakeField;
begin
  SetDrawingContext(areaMain, TRUE);
end;

procedure DisplayGameOver;
var
  vX, vY, vW, vH: integer;
begin
  SetDrawingContext(areaMain, FALSE);
  //SetTextStyle(DefaultFont, HorizDir, 2);
  vW := TextWidth(GAME_OVER);
  vH := TextHeight(GAME_OVER);
  vX := (vFieldHeight - vW) div 2;
  vY := (vFieldHeight - vH) div 2;
  //SetColor(cGray);
  //Rectangle(vX - 3, vY - 3, vX + vW + 3, vY + vH + 3);
  //SetFillStyle(SolidFill, cDarkGray);
  //Bar(vX - 2, vY - 2, vX + vW + 2, vY + vH + 2);
  SetColor(cLemon);
  OutTextXY(vX, vY, GAME_OVER);
end;

procedure DisplayInput(const aInput: string);
begin
  SetDrawingContext(areaLabel1);
  DrawLabel(areaLabel1, YOUR_NAME);
  SetDrawingContext(areaMain, TRUE);
  OutTextXY((vFieldHeight - TextWidth(aInput)) div 2, (vFieldHeight - TextHeight(aInput)) div 2, aInput);
end;

procedure DisplayHighScores(const aHighScores: THighScores);
var
  vIndex: integer;
begin
  SetDrawingContext(areaLabel1);
  DrawLabel(areaLabel1, HIGH_SCORES);
  SetDrawingContext(areaMain, TRUE);
  //SetColor(cLemonChiffon);
  for vIndex := Low(THighScores) to High(THighScores) do
  begin
    OutTextXY(1 * 8, vIndex * 16, Concat(aHighScores[vIndex].vName, StringOfChar('.', NAME_LEN - Length(aHighScores[vIndex].vName))));
    OutTextXY((NAME_LEN + 3) * 8, vIndex * 16, Format('%0.*d', [SCORE_LEN, aHighScores[vIndex].vScore]));
    OutTextXY((NAME_LEN + SCORE_LEN + 5) * 8, vIndex * 16, aHighScores[vIndex].vDate);
  end;
end;

procedure DrawPoint(const aSquare: TPoint; const aColor: TPointColor; const aUpdateScreen: boolean);
var
  x, y: integer;
  vColor, vFillColor: integer;
begin
  case aColor of
    colorSnake:
      begin
        vColor := cLimeGreen;
        vFillColor := cGreen;
      end;
    colorApple:
      begin
        vColor := cRed;
        vFillColor := cDarkRed;
      end;
    colorBackground:
      begin
        vColor := cBlack;
        vFillColor := cBlack;
      end;
  end;
  SetColor(vColor);
  SetFillStyle(SolidFill, vFillColor);
  x := vSquareWidth * (aSquare.x - 1);
  y := vFieldHeight - (vSquareWidth * aSquare.y) - 1;
  Rectangle(x + 1, y + 1, x + vSquareWidth - 1, y + vSquareWidth - 1);
  Bar(x + 2, y + 2, x + vSquareWidth - 2, y + vSquareWidth - 2);
  {
  if aUpdateScreen then
    UpdateGraph(UpdateNow);
  }
end;

procedure DrawCurrentScore(const aScore: integer);
begin
  DrawLabel(areaLabel1, Format('%0.4d', [aScore]));
end;

procedure CloseWindow;
begin
  CloseGraph;
end;

function CloseRequest: boolean;
begin
{
  result := CloseGraphRequest;
}
  result := FALSE;
end;

begin
  Settings;
end.
