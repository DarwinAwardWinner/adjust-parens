.PHONY: all clean

ELCFILES = $(addsuffix .elc, $(basename $(wildcard *.el)))

all: $(ELCFILES)

%.elc : %.el
	@echo Compiling $<
	@emacs --batch -q --no-site-file -L . -f batch-byte-compile $<

clean:
	@rm -f *.elc

check: $(ELCFILES)
	@emacs --batch -q --no-site-file -L . -l adjust-parens-tests.el -f ert-run-tests-batch-and-exit

