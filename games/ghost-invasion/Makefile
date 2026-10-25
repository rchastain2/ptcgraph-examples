.PHONY: pacman editor release strip clean
pacman:
ifeq ($(OS),Windows_NT)
	@if not exist units mkdir units
else
	@mkdir -p units
endif
	@fpc mspacman.pas @extrafpc.cfg -dDEBUG
#	@sh -c 'stat --printf="Executable file size: %s bytes\n" mspacman'
editor:
#	@mkdir -p units
	@fpc editor.pas @extrafpc.cfg -dDEBUG
#	@sh -c 'stat --printf="Executable file size: %s bytes\n" editor'
release:
#	@mkdir -p units
	@fpc mspacman.pas @extrafpc.cfg -dRELEASE
#	@sh -c 'stat --printf="Executable file size: %s bytes\n" mspacman'
strip:
#	@mkdir -p units
	@fpc mspacman.pas @extrafpc.cfg -dRELEASE
	@upx -qq mspacman
#	@sh -c 'stat --printf="Executable file size: %s bytes\n" mspacman'
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
