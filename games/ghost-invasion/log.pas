
unit Log;

interface

uses
  SysUtils;

procedure LogLn(const ALine: string);

implementation

{$IFDEF DEBUG}
var
  LLog: TextFile;
{$ENDIF}

procedure LogLn(const ALine: string);
begin
{$IFDEF DEBUG}
  WriteLn(LLog, TimeToStr(Time), ' ', ALine);
  Flush(LLog);
{$ENDIF}
end;

{$IFDEF DEBUG}
initialization
  Assign(LLog, ChangeFileExt(ParamStr(0), '.log'));
  Rewrite(LLog);
finalization
  Close(LLog);
{$ENDIF}
end.
