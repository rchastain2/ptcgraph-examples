
program Hello;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  SysUtils,
  ptcCrt, ptcGraph;

function IsPowerOfTwo(const x: qword; var n: integer): boolean;
var
  i: integer;
begin
  result := PopCnt(x) = 1;
  if result then
  begin
    n := 0;
    while not (qword(1) shl n = x) do
      Inc(n);
  end else
    n := -1;
end;

var 
  gd, gm: smallint;
  err: smallint;
  s: string;
  m, n: integer;
  
begin
  gd := VGA;
  gm := VGAHi;
  InitGraph(gd, gm, '');
  
  err := GraphResult;
  if err = grOK then
  begin
    m := Succ(GetMaxColor);
    if IsPowerOfTwo(m, n) then
      WriteLn(Format('%d colors (%d-bit colors)', [m, n]));
    
    SetBkColor(Blue);
    SetColor(Yellow);
    
    s := 'Hello world by ptcGraph';
    OutTextXY(
      (GetMaxX - TextWidth (s)) div 2,
      (GetMaxY - TextHeight(s)) div 2,
      s
    );
    
    ReadKey;
    CloseGraph;
  end;
end.
