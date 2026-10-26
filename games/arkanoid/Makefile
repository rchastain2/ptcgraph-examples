
.PHONY: arkanoid release strip clean run

arkanoid:
ifeq ($(OS),Windows_NT)
	@if not exist units mkdir units
else
	@mkdir -p units
endif
	@fpc -dDEBUG @extrafpc.cfg arkanoid.pas
	@sh -c 'stat --printf="Executable file size: %s bytes\n" arkanoid'
release:
	@mkdir -p units
	@fpc -dRELEASE @extrafpc.cfg arkanoid.pas
	@sh -c 'stat --printf="Executable file size: %s bytes\n" arkanoid'
strip: release
	@upx -qq arkanoid
	@sh -c 'stat --printf="Executable file size: %s bytes\n" arkanoid'
clean:
	@rm -fv arkanoid
	@rm -fv *.log
	@rm -fv units/*.*
	@rm -fv *.o
	@rm -fv *.ppu
run:
	LD_LIBRARY_PATH=$$LD_LIBRARY_PATH:. ./arkanoid
