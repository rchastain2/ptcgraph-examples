
PC = fpc

ifdef LCL
LAZARUS := ~/Documents/sources/lazarus
AGGPAS := $(LAZARUS)/components/aggpas/src
else
FPGUI := ~/Documents/pascal/sources/fpgui/develop
AGGPAS := $(FPGUI)/framework/src/main/pascal/corelib/render/software
AGGEXT := $(FPGUI)/extras/aggpas
endif

PFLAGS := -Mobjfpc -Sh
PFLAGS += -FUunits

PFLAGS += -Fi$(AGGPAS)
PFLAGS += -Fu$(AGGPAS)
PFLAGS += -Fu$(AGGPAS)/platform/linux
PFLAGS += -Fu$(AGGPAS)/ctrl
PFLAGS += -Fu$(AGGPAS)/util
ifndef LCL
PFLAGS += -Fu$(AGGEXT)
endif

SOURCES := $(filter-out agg_2D.pas,$(wildcard *.pas))
TARGETS := $(SOURCES:%.pas=%)

ORIGINAL := $(FPGUI)/framework/src/main/pascal/corelib/render/software/agg_2D.pas

all: $(TARGETS)

%: %.pas agg_2D.pas
ifeq ($(OS),Windows_NT)
	@if not exist units mkdir units
else
	@[ -d units ] || mkdir -p units
endif
	@$(PC) $(PFLAGS) $<

agg_2D.patch: $(ORIGINAL) mod/agg_2D.pas
	-diff -u $(word 1,$^) $(word 2,$^) > $@

agg_2D.pas: $(ORIGINAL) agg_2D.patch
	patch -o $@ $(word 1,$^) < $(word 2,$^)

clean:
	@rm -fv *.bak *.bak? *.log units/*.o units/*.ppu

distclean: clean
	@rm -fv $(TARGETS)
