
default: pongpicturesdemo

magick2pas: magick2pas.pas
	fpc $<

pongpicturesdemo: pongpicturesdemo.pas pongpictures.pas ball.pas paddle.pas Makefile
	fpc $< -Mobjfpc -Sh -O- -Cr -ghl

ball.txt:
	magick -size 17x17 xc:black -fill white -draw "ellipse 8,8 8,8 0,360" -gamma 2.2 ball.bmp
	magick ball.bmp -alpha off ball.txt

ball.pas: ball.txt magick2pas
	./magick2pas $< > $@

paddle.txt:
	magick -size 97x17 xc:black -fill white -draw "roundrectangle 0,0 96,16 2,2" -gamma 2.2 paddle.bmp
	magick paddle.bmp -alpha off paddle.txt

paddle.pas: paddle.txt magick2pas
	./magick2pas $< > $@

clean:
	rm -fv ball.txt
