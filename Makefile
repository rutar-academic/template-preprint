.PHONY: all clean build test

all: build

clean:
	rm -rf build test

build:
	copier copy --vcs-ref HEAD --force . build

test:
	copier copy --vcs-ref HEAD --force . test
	latexmk -pdf -interaction=nonstopmode -silent -Werror -file-line-error -cd test/main.tex
