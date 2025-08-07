
program PongPicturesDemo;

uses
{$IFDEF unix}
  cThreads,
{$ENDIF}
  ptcGraph, ptcCrt,
  PongPictures,
  ImageUtils;

var
  gd, gm : smallint;
  x, y: integer;
  
begin
  gd := VESA;
  gm := m640x480x16m;
  Initgraph(gd, gm, '');
  (*
  SetBkColor($000000);
  ClearViewPort;
  *)
  for y := 0 to 16 do
    for x := 0 to 16 do
      PutPixel(x, y, CBallPicture[y, x]);
  
  (* Essai de l'unité ImageUtils *)
  
  ImageCopy(0, 0, 16, 16, 17, 0, CopyPut);
  ImageSave(0, 0, 16, 16, 'ball.img');
  ImageLoad(0, 0, 16, 16, 34, 0, 'ball.img', CopyPut);
  
  for y := 0 to 16 do
    for x := 0 to 96 do
      PutPixel(x, y + 20, CPaddlePicture[y, x]);
  
  ImageCopy(0, 20, 96, 36, 0, 37, CopyPut);
  ImageSave(0, 20, 96, 36, 'paddle.img');
  ImageLoad(0, 0, 96, 16, 0, 54, 'paddle.img', CopyPut);
  
  ReadKey;
  Closegraph;
end.
