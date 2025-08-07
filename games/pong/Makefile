
UNITS := $(filter-out pong.pas,$(wildcard *.pas))

.PHONY: clean

pong: pong.pas $(UNITS)
	@fpc $<  -Mobjfpc -Sh -O- -Cr -ghl

start: pong
	@sh -c "LD_LIBRARY_PATH=$LD_LIBRARY_PATH:. ./$<"

clean:
	@rm -fv pong
	@rm -fv *.o *.ppu
