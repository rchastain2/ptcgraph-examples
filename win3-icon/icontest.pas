program icontest;

{$MODE objfpc}{$H+}

uses
  Classes, SysUtils, win3icon;

function Min(a, b: int64): int64;
begin
  if a < b then result := a else result := b;
end;

function CountDifferences(const AFileName: string; AStream: TMemoryStream): integer;
var
  LOriginal: TMemoryStream;
  i: integer;
  a, b: PByte;
begin
  LOriginal := TMemoryStream.Create;
  try
    LOriginal.LoadFromFile(AFileName);
    result := Abs(LOriginal.Size - AStream.Size);
    a := LOriginal.Memory;
    b := AStream.Memory;
    for i := 0 to Pred(Min(LOriginal.Size, AStream.Size)) do
      if a[i] <> b[i] then
        Inc(result);
  finally
    LOriginal.Free;
  end;
end;

var
  LDir: string;
  LSearch: TSearchRec;
  LIcon: TWin3Icon;
  LError: TIconError;
  LStream: TMemoryStream;
  LDiff, LTransparent, x, y: integer;

begin
  if SizeOf(TIconFile) <> IconFileSize then
  begin
    WriteLn('SizeOf(TIconFile) = ', SizeOf(TIconFile), ', expected ', IconFileSize);
    Halt(1);
  end;

  if ParamCount > 0 then
    LDir := IncludeTrailingPathDelimiter(ParamStr(1))
  else
    LDir := 'samples' + DirectorySeparator;

  if FindFirst(LDir + '*.ico', faAnyFile, LSearch) = 0 then
  try
    repeat
      LError := LoadIcon(LDir + LSearch.Name, LIcon);
      if LError <> ieNone then
      begin
        WriteLn(LSearch.Name:16, '  ', IconErrorText(LError));
        Continue;
      end;

      LTransparent := 0;
      for y := 0 to IconHeight - 1 do
        for x := 0 to IconWidth - 1 do
          if LIcon.Transparent[y, x] then
            Inc(LTransparent);

      LStream := TMemoryStream.Create;
      try
        WriteIcon(LStream, LIcon);
        LDiff := CountDifferences(LDir + LSearch.Name, LStream);
      finally
        LStream.Free;
      end;

      Write(LSearch.Name:16, '  transparent ', LTransparent:4, '  ');
      if LDiff = 0 then
        WriteLn('identical')
      else
        WriteLn(LDiff, ' byte(s) differ');
    until FindNext(LSearch) <> 0;
  finally
    FindClose(LSearch);
  end;
end.
