
unit Load;

{
  Advanced Routines Unit, Version 1.0, Copyright 1996 by George M. Tzoumas
  Free Pascal version by retronick:
  https://forum.lazarus.freepascal.org/index.php/topic,54531.msg405842.html#msg405842
}

interface

procedure BSave(FN: string; P: pointer; ALength: word);
procedure BLoad(FN: string; var P: pointer; const AConvertImage: boolean = TRUE);

implementation

uses
  SysUtils, Log;

{ -------------------------------------------------------------------- }

type
  TResourceInfo = record
    point: pointer;
    size: longint;
  end;
  
var
  Resources: array of TResourceInfo;

procedure AddResourceInfo(point: pointer; size: longint);
var
  l: integer;
begin
  l := Length(Resources);
  SetLength(Resources, Succ(l));
  Resources[l].point := point;
  Resources[l].size := size;
end;

procedure InitResourceInfo;
begin
  Initialize(Resources);
end;

procedure FreeResources;
var
  i: integer;
begin
  for i := 0 to High(Resources) do
    with Resources[i] do
      FreeMem(point, size);
end;

{ -------------------------------------------------------------------- }

const
  MaxWidth = 2047;

type
  BLine = array[0..MaxWidth] of byte;
  WLine = array[0..MaxWidth] of word;

  TPImgRec = record
    width, height: word;
    buf: array[0..10000] of byte;
  end;

  FPImgRec = record
    width, height, reserved: longint;
    buf: array[0..10000] of word;
  end;

const
  BorlandColorMap: array[0..15] of word = (0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15);

function BitOn(APos, AByte: byte): boolean;
var
  LByte: byte;
begin
  LByte := $01;
  LByte := LByte shl APos;
  result := (LByte and AByte) > 0;
end;

function BytesPerRow(AWidth: word): word;
begin
  result := (AWidth + 7) div 8;
end;

procedure MpToSp(var MPlane: BLine; var SPlane: WLine; BPR: word);
var
  i, j, xpos, col, off2, off3, off4: word;
begin
  off2 := BPR;
  off3 := BPR * 2;
  off4 := BPR * 3;
  xpos := 0;
  FillChar(SPlane, SizeOf(SPlane), #0);
  for i := 0 to off2 - 1 do
  begin
    for j := 7 downto 0 do
    begin
      col := 0;
      if BitOn(j, MPlane[i])        then Inc(col, 1);
      if BitOn(j, MPlane[i + off2]) then Inc(col, 2);
      if BitOn(j, MPlane[i + off3]) then Inc(col, 4);
      if BitOn(j, MPlane[i + off4]) then Inc(col, 8);
      SPlane[xpos] := BorlandColorMap[col];
      Inc(xpos);
    end;
  end;
end;

procedure BSave(FN: string; P: pointer; ALength: word);
var
  F: file;
begin
  Assign(F, FN);
  Rewrite(F, ALength);
  BlockWrite(F, P^, 1);
  Close(F);
end;

procedure TPImageToFPImage(var P: pointer; PSize: LongInt);
var
  FPImgPtr: ^FPImgRec;
  TPImgPtr: ^TPImgRec;
  bbuf: bline;
  wbuf: wline;
  pos1, pos2: word;
  width, height: word;
  BPR: word;
  NP: pointer;
  NPSize: longint;
  i: word;
begin
  LogLn(Format('TPImageToFPImage(%p,%d)', [P, PSize]));
  TPImgPtr := P;
  width := Succ(TPImgPtr^.width);
  height := Succ(TPImgPtr^.height);
  BPR := BytesPerRow(width);
  NPSize := 12 + width * height * 2;
  
  GetMem(NP, NPSize);
  AddResourceInfo(NP, NPSize);
  
  FPImgPtr := NP;
  FPImgPtr^.width := width;
  FPImgPtr^.height := height;
  FPImgPtr^.reserved := 0;
  
  pos1 := 0;
  pos2 := 0;
  for i := 1 to height do
  begin
    Move(TPImgPtr^.buf[pos1], bbuf, BPR * 4);
    MpToSp(bbuf, wbuf, BPR);
    Move(wbuf, FPImgPtr^.buf[pos2], width * 2);
    Inc(pos1, BPR * 4);
    Inc(pos2, width);
  end;
  FreeMem(P, PSize);
  P := NP;
end;

procedure BLoad(FN: string; var P: pointer; const AConvertImage: boolean);
var
  F: file;
  LSize: longint;
begin
  LogLn(Format('BLoad(%s,%p,%d)', [FN, P, Ord(AConvertImage)]));
  Assign(F, FN);
  Reset(F, 1);
  LSize := FileSize(F);
  GetMem(P, LSize);
  BlockRead(F, P^, LSize);
  Close(F);
  if AConvertImage then
    TPImageToFPImage(P, LSize)
  else
    AddResourceInfo(P, LSize);
end;

initialization
  InitResourceInfo;
finalization
  FreeResources;
end.
