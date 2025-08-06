
program Rain;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt, Colors16;

const
  NBLOBS = 20;
  MIN_SIZE_OF_BLOB = 10;
  MAX_SIZE_OF_BLOB = 200;

type
  Blob = record
    X: integer;
    Y: integer;
    Radius: integer;
    Max_radius: integer;
    Color: longword;
    Tick: longint;
  end;

var
  blobs: array[1..NBLOBS] of Blob;
  iterator: integer;

procedure draw_blobs(i: integer);
begin
 {Clear old blob}
  SetColor(cBlack);
  Circle(blobs[i].X, blobs[i].Y, blobs[i].Radius - 1);
 {Draw new blob}
  SetColor(blobs[i].Color);
  Circle(blobs[i].X, blobs[i].Y, blobs[i].Radius);
end;

procedure init_blob(i: integer);
begin
  blobs[i].X := Random(GetMaxX) + 0;
  blobs[i].Y := Random(GetMaxY) + 0;
  blobs[i].Radius := Random(MAX_SIZE_OF_BLOB - MIN_SIZE_OF_BLOB) + MIN_SIZE_OF_BLOB;
  blobs[i].Max_radius := Random(MAX_SIZE_OF_BLOB - blobs[i].Radius) + blobs[i].Radius;
  blobs[i].Color := Random(128) + 128;
  blobs[i].Tick := Round(blobs[i].Radius / blobs[i].Color) + 1;
end;

procedure update_blob(i: integer);
begin
  blobs[i].Radius := blobs[i].Radius + 1;
 {If tick is passed update color}
  if blobs[i].Radius mod blobs[i].Tick = 0 then
  begin
    blobs[i].Color := blobs[i].Color - 1;
  end;
 {If radius or color equal zero re init this blob}
  if (blobs[i].Radius = blobs[i].Max_radius) or (blobs[i].Color = 0) then
  begin
    SetColor(cBlack);
    Circle(blobs[i].X, blobs[i].Y, blobs[i].Radius - 1);
    init_blob(i);
  end;
end;

var

  Gd, Gm: smallint;
  
begin
  Randomize;
  
  Gd := VESA;
  Gm := m640x480x16m;
  InitGraph(Gd, Gm, '');
  
  SetBkColor(cBlack);
  ClearDevice;
  
 {Init all blobs}
  for iterator := 1 to NBLOBS do
  begin
    init_blob(iterator);
  end;

  while not KeyPressed do
  begin
    for iterator := 1 to NBLOBS do
    begin
   {Draw blob}
      draw_blobs(iterator);
   {Update or re init blob}
      update_blob(iterator);
   {Delay calculs maximal for stable fps}
      Delay(Round((100 * (5 / NBLOBS)) / NBLOBS) + 1);
    end;
  end;
  CloseGraph;
end.
