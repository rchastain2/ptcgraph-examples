
PC = fpc

FPGUI ?= $(HOME)/Documents/sources/fpgui
AGGPAS := $(FPGUI)/framework/src/main/pascal/corelib/render/software
AGGEXT := $(FPGUI)/extras/aggpas

PFLAGS := -Mobjfpc -Sh
PFLAGS += -FUunits
PFLAGS += -Fi$(AGGPAS)
PFLAGS += -Fu$(AGGPAS)
PFLAGS += -Fu$(AGGEXT)

SOURCES := $(wildcard *.pas)
TARGETS := $(SOURCES:%.pas=%)

.PHONY: all clean distclean

all: $(TARGETS)

%: %.pas
ifeq ($(OS),Windows_NT)
	@if not exist units mkdir units
else
	@[ -d units ] || mkdir -p units
endif
	@$(PC) $(PFLAGS) $<

clean:
	@rm -fv *.bak *.bak? *.log units/*.o units/*.ppu

distclean: clean
	@rm -fv $(TARGETS)
