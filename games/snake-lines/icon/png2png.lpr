program png2png;

uses
  Classes, SysUtils, BGRABitmap, BGRABitmapTypes;

var
  img1, img2: TBGRABitmap;

begin
  img1 := TBGRABitmap.Create('snake-graphics.png');
  img2 := TBGRABitmap.Create(3 * 64, 3*64);

  BGRAReplace(img2, img1.GetPart(Rect(0, 0, 3*64, 3*64)));
  img2.PutImage(64, 64, img1.GetPart(Rect(4*64, 0, 5*64, 64)), dmDrawWithTransparency);
  img2.PutImage(64, 128, img1.GetPart(Rect(4*64, 2*64, 5*64, 3*64)), dmDrawWithTransparency);

  img2.SaveToFile('snake.png');

  img1.Free;
  img2.Free;
end.

