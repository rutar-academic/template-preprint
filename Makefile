.PHONY: all clean

all: build

clean:
	rm -rf build test

build:
	copier copy --vcs-ref HEAD . build

test:
	copier copy --vcs-ref HEAD . test
	latexmk -pdf -interaction=nonstopmode -silent -Werror -file-line-error -cd test/main.tex
