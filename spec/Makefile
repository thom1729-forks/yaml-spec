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
	tex-to-png $< $@

clean:
	rm -f $(ALL_PNG)
