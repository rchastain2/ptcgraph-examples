
PFLAGS := -Mobjfpc -Sh
PFLAGS += -ghl

ifdef PAGES
PFLAGS += -dPAGES
endif

.PHONY: clean

visualpagedemo: visualpagedemo.pas
	@fpc $(PFLAGS) $<

clean:
	@rm -fv *.o *.ppu

distclean: clean
	@rm -fv visualpagedemo
