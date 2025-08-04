
ORIGINAL := $(HOME)/Documents/pascal/sources/fpgui/src/corelib/render/software/agg_2D.pas
MODIFIED := software/agg_2D.pas

test: test.pas
	fpc -Mobjfpc -Sh -Fusoftware $<

agg_2D.patch: $(ORIGINAL) $(MODIFIED)
	-diff -u $(word 1,$^) $(word 2,$^) > $@

agg_2D.pas: $(ORIGINAL) agg_2D.patch
	patch -o $@ $(word 1,$^) < $(word 2,$^)

result.txt: agg_2D.pas $(MODIFIED)
	-diff -u $(word 1,$^) $(word 2,$^) > $@

clean:
	find . -name "*.o" -print -delete
	find . -name "*.ppu" -print -delete
