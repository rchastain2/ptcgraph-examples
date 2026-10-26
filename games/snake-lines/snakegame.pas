
unit SnakeGame;

interface

uses
  SysUtils,
  Classes,
  Constants;
  
type
  TSnake = array of TPoint;
  
  TSnakeGame = class
    vSnake: TSnake;
    vDirection, vOld, vApple: TPoint;
    vDirectionIndex: integer;
    constructor Create;
    destructor Destroy; override;
    procedure MoveSnake;
    procedure ChangeDirection(const aDirectionIndex: integer); overload;
    procedure ChangeDirection(const aRight: boolean); overload;
    function IsSnake(const aPoint: TPoint): boolean;
    function IsApple(const aPoint: TPoint): boolean;
    function SetAppleLocation: boolean;
    function Collision(const aWalls: boolean = TRUE): boolean;
    function SnakeEats: boolean;
    procedure SnakeGrows;
    procedure SaveTailPosition;
  end;

function OppositeDirections(const aPoint1, aPoint2: TPoint): boolean;

const
  INITIAL_SNAKE_LENGTH = 2;

implementation
  
const
  DIRECTIONS: array[0..3] of TPoint = (
    (x: 0; y: 1),
    (x: 1; y: 0),
    (x: 0; y:-1),
    (x:-1; y: 0)
  );

function OppositeDirections(const aPoint1, aPoint2: TPoint): boolean;
begin
  result := (aPoint1.x = -1 * aPoint2.x) and (aPoint1.y = -1 * aPoint2.y);
end;

constructor TSnakeGame.Create;
begin
  inherited Create;
  vDirectionIndex := 1;
  vDirection := DIRECTIONS[vDirectionIndex];
  SetLength(vSnake, INITIAL_SNAKE_LENGTH);
  vSnake[0].SetLocation(5, 5);
  vSnake[1].SetLocation(vSnake[0].Subtract(vDirection));
end;

destructor TSnakeGame.Destroy;
begin
  SetLength(vSnake, 0);
  inherited Destroy;
end;

procedure TSnakeGame.MoveSnake;
begin
  { Déplacer le corps du serpent en fonction de la position antérieure de la tête. }
  Move(vSnake[0], vSnake[1], High(vSnake) * SizeOf(TPoint));
  { Déplacer la tête en fonction de la direction courante. }
  vSnake[0].Offset(vDirection);
  { Si la tête est sortie de la surface de jeu, la téléporter de l'autre côté. Utile seulement si la
  téléportation est autorisée, autrement dit si la fonction Collision a été appelée avec la valeur
  FALSE, c'est-à-dire en mode "sans murs". }
  if vSnake[0].x > XMAX then vSnake[0].x := XMIN;
  if vSnake[0].x < XMIN then vSnake[0].x := XMAX;
  if vSnake[0].y > YMAX then vSnake[0].y := YMIN;
  if vSnake[0].y < YMIN then vSnake[0].y := YMAX;
end;

procedure TSnakeGame.ChangeDirection(const aDirectionIndex: integer);
begin
  if not OppositeDirections(vDirection, DIRECTIONS[aDirectionIndex]) then
    vDirection := DIRECTIONS[aDirectionIndex];
end;

procedure TSnakeGame.ChangeDirection(const aRight: boolean);
begin
  if aRight then
  begin
    Inc(vDirectionIndex);
    if vDirectionIndex > High(DIRECTIONS) then
      vDirectionIndex := Low(DIRECTIONS);
  end else
  begin
    Dec(vDirectionIndex);
    if vDirectionIndex < Low(DIRECTIONS) then
      vDirectionIndex := High(DIRECTIONS);
  end;
  ChangeDirection(vDirectionIndex);
end;

function TSnakeGame.IsSnake(const aPoint: TPoint): boolean;
var
  vSnakePart: integer;
  vTail: integer;
begin
  result := FALSE;
  vSnakePart := 1;
  vTail := High(vSnake);
  while (vSnakePart <= vTail) and not result do
  begin
    result := aPoint = vSnake[vSnakePart];
    Inc(vSnakePart);
  end;
end;

function TSnakeGame.IsApple(const aPoint: TPoint): boolean;
begin
  result := aPoint = vApple;
end;

function TSnakeGame.SetAppleLocation: boolean;
const
  MAX_ATTEMPT = 20;
var
  vCount: integer;
begin
  result := FALSE;
  vCount := 0;
  repeat
    Inc(vCount);
    vApple.SetLocation(Random(XMAX) + XMIN, Random(YMAX) + YMIN);
    result := not (IsSnake(vApple) or (vApple = vOld));
  until result or (vCount > MAX_ATTEMPT);
end;

function TSnakeGame.Collision(const aWalls: boolean): boolean;
begin
  result := IsSnake(vSnake[0].Add(vDirection));
  
  if aWalls then
    result := result
    or (vSnake[0].x + vDirection.x > XMAX)
    or (vSnake[0].x + vDirection.x < XMIN)
    or (vSnake[0].y + vDirection.y > YMAX)
    or (vSnake[0].y + vDirection.y < YMIN);
end;

function TSnakeGame.SnakeEats: boolean;
begin
  result := IsApple(vSnake[0].Add(vDirection));
end;

procedure TSnakeGame.SnakeGrows;
begin
  SetLength(vSnake, Succ(Length(vSnake)));
end;

procedure TSnakeGame.SaveTailPosition;
var
  vTail: integer;
begin
  vTail := High(vSnake);
  vOld.SetLocation(vSnake[vTail]);
end;

end.
