.PHONY: pacman editor release strip run clean units
pacman: units
	@fpc mspacman.pas @extrafpc.cfg -dDEBUG
#	@sh -c 'stat --printf="Executable file size: %s bytes\n" mspacman'
editor: units
	@fpc editor.pas @extrafpc.cfg -dDEBUG
#	@sh -c 'stat --printf="Executable file size: %s bytes\n" editor'
release: units
	@fpc mspacman.pas @extrafpc.cfg -dRELEASE
#	@sh -c 'stat --printf="Executable file size: %s bytes\n" mspacman'
strip: units
	@fpc mspacman.pas @extrafpc.cfg -dRELEASE
	@upx -qq mspacman
#	@sh -c 'stat --printf="Executable file size: %s bytes\n" mspacman'
units:
ifeq ($(OS),Windows_NT)
	@if not exist units mkdir units
else
	@mkdir -p units
endif
run:
ifeq ($(OS),Windows_NT)
	@mspacman 2> run.err | tee run.out
else
	@./mspacman 2> run.err | tee run.out
endif
clean:
ifeq ($(OS),Windows_NT)
	@del /q units\*.*
	@del /q editor.exe
	@del /q mspacman.exe
else
	@rm -fv editor
	@rm -fv mspacman
	@rm -fv *.log
	@rm -fv *.err
	@rm -fv *.out
	@rm -fv units/*.*
	@rm -fv *.o
	@rm -fv *.ppu
endif
