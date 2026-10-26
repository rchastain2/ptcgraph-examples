
program Snake;

{$IFDEF MSWINDOWS}
{$APPTYPE GUI}
{$R snake.res}
{$ENDIF}

uses
{$IFDEF UNIX}
  CThreads,
{$ENDIF}
  SysUtils,
  SnakeVideoGame;

begin
  Randomize;
  with TSnakeVideoGame.Create do
  try
    Execute;
  finally
    Free;
  end;
end.
