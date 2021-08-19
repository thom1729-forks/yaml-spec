DOCKER_TOOL := html-to-markydown
include ../tool/make/init.mk

ALL_TEX := $(shell echo tex/*.tex)
ALL_PNG := $(ALL_TEX:tex/%.tex=img/%.png)

ALL := \
    $(ALL_PNG) \

default:
	@echo $(ALL_PNG)

build: $(ALL)

img/%.png: tex/%.tex
	pdflatex -halt-on-error -output-directory /tmp $< >/dev/null
	pdftoppm -png -r 750 $(<:tex/%.tex=/tmp/%.pdf) tmp
	mv tmp-1.png $@
	rm -f *.aux *.log *.pdf

clean:
	rm -f $(ALL_PNG)
