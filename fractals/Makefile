
SOURCE := $(HOME)/Documents/pascal/sources/fpc/packages/graph/src

PFLAGS := -Mobjfpc -Sh
PFLAGS += -ghl
ifdef USE_SOURCE
PFLAGS += -Fu$(SOURCE)/ptcgraph -Fi$(SOURCE)/inc
endif

PROGRAMS := $(wildcard *.pas)

ifeq ($(OS),Windows_NT)
	BINARIES := $(patsubst %.pas,%.exe,$(PROGRAMS))
else
	BINARIES := $(patsubst %.pas,%,$(PROGRAMS))
endif

.PHONY: clean

%: %.pas
	@fpc $(PFLAGS) $<

clean:
	@rm -fv *.o *.ppu

distclean: clean
	@rm -fv $(BINARIES)
