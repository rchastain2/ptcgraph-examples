
{ https://github.com/glennkentwell/code/tree/master/pascal }

program Arcs;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph,
  ptcCrt,
  GraphBits;
  
var
  LArcInfo: ArcCoordsType;
{
  ArcCoordsType = record
    x, y : smallint;
    xstart, ystart : smallint;
    xend, yend : smallint;
  end;
}

var
  X1, Y1, SA1, EA1, R1: integer;
  X2, Y2, SA2, EA2, R2: integer;
  BX1, BY1, BR1: boolean;
  BX2, BY2, BR2: boolean;

procedure Init;
var
  Gd, Gm: smallint;
begin
  Gd := VGA;
  Gm := VGAHi;
  InitGraph(Gd, Gm, '');
  SetBkColor(Black);
  SetColor(Green);
  ClearDevice;
  SA1 := Random(90);
  EA1 := Random(90);
  SA2 := Random(90);
  EA2 := Random(90);
  X1 := Random(GetMaxX);
  Y1 := Random(GetMaxY);
  X2 := Random(GetMaxX);
  Y2 := Random(GetMaxY);
  R1 := 60;
  R2 := 30;
end;

procedure Operate;
const
  DX = 2;
  DY = 2;
  DSA = 5;
  DEA = -DSA;
  DR = 1;
begin
  Inc(SA1, DSA);
  Inc(EA1, DEA);
  Inc(SA2, DSA);
  Inc(EA2, DEA);
  
  case BX1 of
    TRUE : Inc(X1, DX);
    FALSE: Dec(X1, DX);
  end;
  case BY1 of
    TRUE : Inc(Y1, DY);
    FALSE: Dec(Y1, DY);
  end;
  
  if X1 > GetMaxX - R1 then BX1 := FALSE;
  if X1 <           R1 then BX1 := TRUE;
  if Y1 > GetMaxY - R1 then BY1 := FALSE;
  if Y1 <           R1 then BY1 := TRUE;
  
  case BR1 of
    TRUE : Inc(R1, DR);
    FALSE: Dec(R1, DR);
  end;
  case BX2 of
    TRUE : Inc(X2, DX);
    FALSE: Dec(X2, DX);
  end;
  case BY2 of
    TRUE : Inc(Y2, DY);
    FALSE: Dec(Y2, DY);
  end;
  case BR2 of
    TRUE : Inc(R2, DR);
    FALSE: Dec(R2, DR);
  end;
  
  if X2 > GetMaxX - R2 then BX2 := FALSE;
  if X2 <           R2 then BX2 := TRUE;
  if Y2 > GetMaxY - R2 then BY2 := FALSE;
  if Y2 <           R2 then BY2 := TRUE;
  
  if R1 > 105 then BR1 := FALSE;
  if R1 <   5 then BR1 := TRUE;
  if R2 > 105 then BR2 := FALSE;
  if R2 <   5 then BR2 := TRUE;
end;

procedure Draw(X, Y, SA, EA, R: integer; color1, color2: word);
begin
  SetColor(color1);
  Arc(X, Y, SA, EA, R);
  SetColor(color2);
  GetArcCoords(LArcInfo);
  with LArcInfo do
  begin
    Line(X, Y + 20, XStart, YStart);
    Line(X, Y - 20, XStart, YStart);
    Line(X + 20, Y, XStart, YStart);
    Line(X - 20, Y, XStart, YStart);
    Line(X, Y + 20, XEnd, YEnd);
    Line(X, Y - 20, XEnd, YEnd);
    Line(X + 20, Y, XEnd, YEnd);
    Line(X - 20, Y, XEnd, YEnd);
    Line(X, Y, XEnd, YEnd);
    Line(X, Y, XStart, YStart);
  end;
end;

procedure Draw;
begin
  Draw(X1, Y1, SA1, EA1, R1, Blue, Red);
  Draw(X2, Y2, SA2, EA2, R2, Green, Red);
end;

var
  page: byte;
  
begin
  Randomize;
  Init;
  page := 0;
  repeat
    SetActivePage(page);
    ClearDevice;
    Operate;
    Draw;
    SetVisualPage(page);
    Delay(50);
    page := 1 - page;
  until KeyPressed;
  CloseGraph;
end.
