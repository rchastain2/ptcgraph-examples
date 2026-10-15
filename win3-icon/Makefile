PPU := tmp

FLAGS := -FU$(PPU)
FLAGS += -gl

SOURCES := $(filter-out win3icon.pas,$(wildcard *.pas))
TARGETS := $(patsubst %.pas,%,$(SOURCES))

default: $(TARGETS)
.PHONY: default clean test

%: %.pas win3icon.pas
	mkdir -p $(PPU)
	fpc $(FLAGS) $<

test: icontest
	./icontest samples

clean:
	rm -fv $(PPU)/*.o $(PPU)/*.ppu *.o *.ppu *.res
ifeq ($(OS),Windows_NT)
	rm -fv $(patsubst %.pas,%.exe,$(SOURCES))
else
	rm -fv $(TARGETS)
endif
