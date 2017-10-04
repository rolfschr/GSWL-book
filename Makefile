
OUTPUT_MD=merged.md
OUTPUT_NAME=GettingStartedWithLedger
OUTPUT_PDF=$(OUTPUT_NAME).pdf
OUTPUT_TEX=$(OUTPUT_NAME).tex
OUTPUT_EPUB=$(OUTPUT_NAME).epub
PANDOC_EXEC=pandoc # run >= 1.15
PANDOC_LATEX_ARGS=-V geometry:"top=2cm, bottom=1.5cm, left=1cm, right=1cm" -V linkcolor=blue -V urlcolor=blue
# pandoc highlight style
# Options are `pygments` (the default), `kate`, `monochrome`, `espresso`, `zenburn`, `haddock`, and `tango`.
# zenburn, espresso, haddock
PANDOC_SYNTAX_HIGHLIGHT=--highlight-style=zenburn # --no-highlight
# Use ":=" instead of "=" to only execute once
GITSHA:=$(shell git rev-parse --short HEAD)
TMP_DIR=./tmp
TMP_BEFORE_TEX=$(TMP_DIR)/before.tex
TMP_EPUB_TITLE=$(TMP_DIR)/epub_title.txt
PANDOC_ARGS= --number-sections $(PANDOC_LATEX_ARGS) --toc $(PANDOC_SYNTAX_HIGHLIGHT) -V gitsha=$(GITSHA) #-V title="Getting Started With Ledger"
PANDOC_PDF_ARGS= --include-before $(TMP_BEFORE_TEX)
PANDOC_EPUB_ARGS= $(TMP_EPUB_TITLE)

all: pdf epub slices

pre: before.tex epub_title.txt
	mkdir -p $(TMP_DIR)
	cp before.tex $(TMP_BEFORE_TEX)
	sed -i -e s'/\$$GITSHA\$$/$(GITSHA)/g' $(TMP_BEFORE_TEX)
	cp epub_title.txt $(TMP_EPUB_TITLE)
	sed -i -e s'/\$$GITSHA\$$/$(GITSHA)/g' $(TMP_EPUB_TITLE)

md: pre
	@find *-* -name '*.md' | xargs cat > $(OUTPUT_MD)
	@python preprocess.py $(OUTPUT_MD)

pdf: md
	$(PANDOC_EXEC) $(OUTPUT_MD) $(PANDOC_ARGS) $(PANDOC_PDF_ARGS) -o $(OUTPUT_PDF)

epub: md
	$(PANDOC_EXEC) $(PANDOC_ARGS) $(PANDOC_EPUB_ARGS) $(OUTPUT_MD) -t epub3 -o $(OUTPUT_EPUB)

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
	rm -rf $(OUTPUT_MD) $(OUTPUT_PDF) $(TMP_DIR)
