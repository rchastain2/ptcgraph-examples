
unit SnakeVideoGame;

interface

uses
  SysUtils,
  Classes,
  ptcCrt,
  SnakeGame,
  Graphics,
  Sound,
  HighScores;

type
  TSnakeVideoGame = class
    vSnakeGame: TSnakeGame;
    vTime: integer;
    vTwoFingersControl: boolean;
    vHighScores: THighScores;
    constructor Create;
    destructor Destroy; override;
    procedure Execute;
    procedure DrawSnake;
    procedure NewApple;
    function GetUserName: string;
    function ComputeScore: integer;
    procedure CheckArrowKey(const aKey: char);
  end;

implementation

uses
  Constants;

{$INCLUDE KEYS.INC}

constructor TSnakeVideoGame.Create;
const
  cInitialTime = 120;
begin
  inherited Create;
  vTime := cInitialTime;
  vTwoFingersControl := FALSE;
  vSnakeGame := TSnakeGame.Create;
  LoadHighScores(vHighScores);
end;

destructor TSnakeVideoGame.Destroy;
begin
  vSnakeGame.Free;
  inherited Destroy;
end;

procedure TSnakeVideoGame.Execute;
var
  vKey: char;
  vGameOver: boolean;
  vMyScore: integer;
  
  procedure OnKeyPress;
  begin
    vKey := ReadKey;
    case vKey of
      #0: CheckArrowKey(ReadKey);
      'P', 'p': vKey := ReadKey;
      ESC, WINDOW_CLOSE: vGameOver := TRUE;
    end;
  end;
  
  procedure OnCollision;
  begin
    Sound.Play(sndDie);
    DisplayGameOver;
    while KeyPressed do
      vKey := ReadKey;
    //Delay(3000);
    //while KeyPressed do
    //  vKey := ReadKey;
    vKey := ReadKey;
    vGameOver := TRUE;
  end;
  
  procedure OnEat;
  begin
    Sound.Play(sndEat);
    vSnakeGame.SnakeGrows;
    vSnakeGame.MoveSnake;
    DrawCurrentScore(ComputeScore);
    NewApple;
  end;
  
  procedure OnNotEat;
  begin
    vSnakeGame.SaveTailPosition;
    vSnakeGame.MoveSnake;
    DrawPoint(vSnakeGame.vOld, colorBackground, FALSE);
  end;
  
  procedure OnHighScore;
  begin
    Sound.Play(sndHighScore);
    vHighScores[10].vScore := vMyScore;
    vHighScores[10].vName := GetUserName;
    vHighScores[10].vDate := FormatDateTime(cDateFormat, Now);
    SortHighScores(vHighScores);
    SaveHighScores(vHighScores);
  end;
  
begin
  OpenWindow;
  DisplayTitle;
  vKey := ReadKey;
  
  if vKey = WINDOW_CLOSE then
  begin
    CloseWindow;
    Exit;
  end;
  
  vGameOver := FALSE;
  
  repeat
    if vGameOver then
    begin
      vSnakeGame.Free;
      vSnakeGame := TSnakeGame.Create;
      vGameOver := FALSE;
    end;
    
    DrawCurrentScore(0);
    DisplaySnakeField;
    NewApple;
    
    while not vGameOver do
    begin
      if KeyPressed then
        OnKeyPress;
      if not vGameOver then
        if vSnakeGame.Collision then
          OnCollision
        else
        begin
          if vSnakeGame.SnakeEats then
            OnEat
          else
            OnNotEat;
          DrawSnake;
          Delay(vTime);
        end;
    end;
    
    if vKey <> WINDOW_CLOSE then
    begin
      vMyScore := ComputeScore;
      if vMyScore > vHighScores[10].vScore then
        OnHighScore;
      
      DisplayHighScores(vHighScores);
    end;
    
  until (vKey = WINDOW_CLOSE) or (UpCase(ReadKey) <> 'R');
  
  CloseWindow;
end;

procedure TSnakeVideoGame.DrawSnake;
begin  
  DrawPoint(vSnakeGame.vSnake[0], colorSnake, TRUE);
end;

procedure TSnakeVideoGame.NewApple;
begin
  if vSnakeGame.SetAppleLocation then
    DrawPoint(vSnakeGame.vApple, colorApple, FALSE);
end;

function TSnakeVideoGame.GetUserName: string;
var
  vInput: string;
  vKey: char;
begin
  vInput := '';
  
  DisplayInput(vInput);
  
  repeat
    vKey := ReadKey;
    
    if vKey in ['A'..'Z', 'a'..'z'] then
      vInput := Concat(
        vInput,
        UpCase(vKey)
      )
    else
      if (vKey = BACKSPACE)
      and (Length(vInput) >= 1) then
        Delete(
          vInput,
          Length(vInput),
          1
        );
    
    DisplayInput(vInput);
  
  until (vKey in [ENTER, ESC, WINDOW_CLOSE]) or (Length(vInput) = NAME_LEN);
  
  result := vInput;
end;

function TSnakeVideoGame.ComputeScore: integer;
begin
  result := 10 * (Length(vSnakeGame.vSnake) - INITIAL_SNAKE_LENGTH);
end;

procedure TSnakeVideoGame.CheckArrowKey(const aKey: char);
const
  LEFT = FALSE;
  RIGHT = TRUE;
begin
  if vTwoFingersControl then
    case aKey of
      ARROW_LEFT:  vSnakeGame.ChangeDirection(LEFT);
      ARROW_RIGHT: vSnakeGame.ChangeDirection(RIGHT);
    end
  else
    case aKey of
      ARROW_UP:    vSnakeGame.ChangeDirection(0);
      ARROW_RIGHT: vSnakeGame.ChangeDirection(1);
      ARROW_DOWN:  vSnakeGame.ChangeDirection(2);
      ARROW_LEFT:  vSnakeGame.ChangeDirection(3);
    end;
end;

end.
