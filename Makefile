
OUTPUT_MD=merged.md
OUTPUT_NAME=GettingStartedWithLedger
OUTPUT_PDF=$(OUTPUT_NAME).pdf
OUTPUT_TEX=$(OUTPUT_NAME).tex
PANDOC_EXEC=pandoc # run >= 1.15
PANDOC_LATEX_ARGS=-V geometry:"top=2cm, bottom=1.5cm, left=1cm, right=1cm" -V linkcolor=blue -V urlcolor=blue
# pandoc highlight style
# Options are `pygments` (the default), `kate`, `monochrome`, `espresso`, `zenburn`, `haddock`, and `tango`.
# zenburn, espresso, haddock
PANDOC_SYNTAX_HIGHLIGHT=--highlight-style=zenburn # --no-highlight
# Use ":=" instead of "=" to only execute once
GITSHA:=$(shell git rev-parse --short HEAD)
TMP_BEFORE_TEX:=$(shell mktemp)
PANDOC_ARGS= --number-sections $(PANDOC_LATEX_ARGS) --toc $(PANDOC_SYNTAX_HIGHLIGHT) --include-before $(TMP_BEFORE_TEX) -V gitsha=$(GITSHA) #-V title="Getting Started With Ledger"

pre:
	@cp before.tex $(TMP_BEFORE_TEX)
	@sed -i -e s'/\$$GITSHA\$$/$(GITSHA)/g' $(TMP_BEFORE_TEX)

md: pre
	@find *-* -name '*.md' | xargs cat > $(OUTPUT_MD)
	@python preprocess.py $(OUTPUT_MD)

pdf: md
	@$(PANDOC_EXEC) $(OUTPUT_MD) $(PANDOC_ARGS) -o $(OUTPUT_PDF)

latex: md
	@$(PANDOC_EXEC) $(OUTPUT_MD) $(PANDOC_ARGS) -o $(OUTPUT_TEX)

slices: pdf
	@# csv conversion
	pdftk $(OUTPUT_PDF) cat 9 output $(OUTPUT_NAME)_preview_p9.pdf
	@# recurring reports
	pdftk $(OUTPUT_PDF) cat 13 output $(OUTPUT_NAME)_preview_p13.pdf
	@# investing
	pdftk $(OUTPUT_PDF) cat 18 output $(OUTPUT_NAME)_preview_p18.pdf

clean:
	@rm $(OUTPUT_MD) $(OUTPUT_PDF)
