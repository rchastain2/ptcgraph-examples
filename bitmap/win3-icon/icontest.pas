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

function SameImage(const A, B: TWin3Icon): boolean;
var
  i, x, y: integer;
begin
  for i := 0 to IconColorCount - 1 do
    if (A.Palette[i].Red <> B.Palette[i].Red)
    or (A.Palette[i].Green <> B.Palette[i].Green)
    or (A.Palette[i].Blue <> B.Palette[i].Blue) then
      Exit(false);
  for y := 0 to IconHeight - 1 do
    for x := 0 to IconWidth - 1 do
    begin
      if A.Transparent[y, x] <> B.Transparent[y, x] then
        Exit(false);
      if not A.Transparent[y, x] and (A.Pixels[y, x] <> B.Pixels[y, x]) then
        Exit(false);
    end;
  result := true;
end;

var
  LDir: string;
  LSearch: TSearchRec;
  LIcon, LReloaded: TWin3Icon;
  LSame: boolean;
  LFailures: integer;
  LError: TIconError;
  LStream: TMemoryStream;
  LDiff, LTransparent, x, y: integer;

begin
  LFailures := 0;

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
        LStream.Position := 0;
        LSame := (ReadIcon(LStream, LReloaded) = ieNone) and SameImage(LIcon, LReloaded);
      finally
        LStream.Free;
      end;

      Write(LSearch.Name:16, '  transparent ', LTransparent:4, '  ');
      if not LSame then
      begin
        WriteLn('FAILED: image changed after writing');
        Inc(LFailures);
      end
      else if LDiff = 0 then
        WriteLn('identical')
      else
        WriteLn('same image, ', LDiff, ' byte(s) differ');
    until FindNext(LSearch) <> 0;
  finally
    FindClose(LSearch);
  end;

  if LFailures > 0 then
    Halt(1);
end.
