
PC = fpc

FPGUI ?= $(HOME)/Documents/sources/fpgui
AGGPAS := $(FPGUI)/framework/src/main/pascal/corelib/render/software
AGGEXT := $(FPGUI)/extras/aggpas

PFLAGS := -Mobjfpc -Sh
PFLAGS += -FUunits
PFLAGS += -Fi$(AGGPAS)
PFLAGS += -Fu$(AGGPAS)
PFLAGS += -Fu$(AGGEXT)

SOURCES := $(filter-out agg_2D.pas,$(wildcard *.pas))
TARGETS := $(SOURCES:%.pas=%)

ORIGINAL := $(AGGPAS)/agg_2D.pas

.PHONY: all clean distclean

all: $(TARGETS)

%: %.pas agg_2D.pas
ifeq ($(OS),Windows_NT)
	@if not exist units mkdir units
else
	@[ -d units ] || mkdir -p units
endif
	@$(PC) $(PFLAGS) $<

agg_2D.pas: $(ORIGINAL) agg_2D.patch
	patch -o $@ $(word 1,$^) < $(word 2,$^) || { rm -f $@; exit 1; }

clean:
	@rm -fv *.bak *.bak? *.log *.orig *.rej units/*.o units/*.ppu

distclean: clean
	@rm -fv $(TARGETS) agg_2D.pas
