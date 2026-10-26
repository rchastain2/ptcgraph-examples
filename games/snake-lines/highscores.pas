
unit HighScores;

interface

type
  TScore = record
    vScore: integer;
    vName, vDate: ansistring;
  end;
  
  THighScores = array[1..10] of TScore;
  
procedure InitHighScores(var aScores: THighScores);
procedure SortHighScores(var aScores: THighScores);
procedure LoadHighScores(var aScores: THighScores);
procedure SaveHighScores(const aScores: THighScores);

const
  cDateFormat = 'dd-mm-yy';
  
implementation

uses
  SysUtils;

const
  FILENAME = 'snakehigh.dat';
  
procedure InitHighScores(var aScores: THighScores);
var
  vScoreIndex: integer;
begin
  for vScoreIndex := Low(THighScores) to High(THighScores) do
  begin
    aScores[vScoreIndex].vScore := 0;
    aScores[vScoreIndex].vName := '';
    aScores[vScoreIndex].vDate := FormatDateTime(cDateFormat, 0);
  end;
end;

procedure SortHighScores(var aScores: THighScores);
var
  vDisorder: boolean;
  vIndex, vScore1: integer;
  vDate1, vName1: ansistring;
begin
  repeat
    vDisorder := FALSE;
    for vIndex := Low(THighScores) to Pred(High(THighScores)) do
      if aScores[vIndex].vScore < aScores[Succ(vIndex)].vScore then
      begin
        vScore1 := aScores[vIndex].vScore;
        vName1 := aScores[vIndex].vName;
        vDate1 := aScores[vIndex].vDate;
        aScores[vIndex].vScore := aScores[Succ(vIndex)].vScore;
        aScores[vIndex].vName := aScores[Succ(vIndex)].vName;
        aScores[vIndex].vDate := aScores[Succ(vIndex)].vDate;
        aScores[Succ(vIndex)].vScore := vScore1;
        aScores[Succ(vIndex)].vName := vName1;
        aScores[Succ(vIndex)].vDate := vDate1;
        vDisorder := TRUE;
      end;
  until not vDisorder;
end;

procedure LoadHighScores(var aScores: THighScores);
var
  vFile: text;
  vIndex: integer;
begin
  InitHighScores(aScores);
  
  if not FileExists(FILENAME) then
    SaveHighScores(aScores);
  
  Assign(vFile, FILENAME);
  Reset(vFile);
  for vIndex := Low(THighScores) to High(THighScores) do
  begin
    ReadLn(vFile, aScores[vIndex].vScore);
    ReadLn(vFile, aScores[vIndex].vName);
    ReadLn(vFile, aScores[vIndex].vDate);
  end;
  Close(vFile);
end;

procedure SaveHighScores(const aScores: THighScores);
var
  vFile: text;
  vIndex: integer;
begin
  Assign(vFile, FILENAME);
  Rewrite(vFile);
  for vIndex := Low(THighScores) to High(THighScores) do
  begin
    WriteLn(vFile, aScores[vIndex].vScore);
    WriteLn(vFile, aScores[vIndex].vName);
    WriteLn(vFile, aScores[vIndex].vDate);
  end;
  Close(vFile);
end;

end.
