
default: snake

SOURCES = $(wildcard *.pas)

snake: snake.pas $(SOURCES)
	fpc -Mdelphi $<

debug: snake.pas $(SOURCES)
	fpc -Mdelphi $< -ghl

graphicsdemo: graphicsdemo.pas $(SOURCES)
	fpc -Mdelphi $< -ghl

start: snake
	export LD_LIBRARY_PATH=$$LD_LIBRARY_PATH:. && ./snake

%: languages/%.inc
	cp -f $< language.inc
	rm -f snake
	make start

clean:
	rm -f *.o *.ppu

clean2:
	make clean
	rm -f snake
