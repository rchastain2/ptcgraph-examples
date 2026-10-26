.PHONY: sokoban release strip clean
sokoban:
	@mkdir -p units
	@fpc -dDEBUG @extrafpc.cfg sokoban.pas
	@sh -c 'stat --printf="Executable file size: %s bytes\n" sokoban'
release:
	@mkdir -p units
	@fpc -dRELEASE @extrafpc.cfg sokoban.pas
	@sh -c 'stat --printf="Executable file size: %s bytes\n" sokoban'
strip: release
	@upx -qq sokoban
	@sh -c 'stat --printf="Executable file size: %s bytes\n" sokoban'
clean:
	@rm -fv sokoban
	@rm -fv *.log
	@rm -fv units/*.*
	@rm -fv *.o
	@rm -fv *.ppu
