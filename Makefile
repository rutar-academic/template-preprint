.PHONY: all clean

all: project

clean:
	rm -rf project test

build:
	copier copy --vcs-ref HEAD . build

test:
	copier copy --vcs-ref HEAD . test
	latexmk -pdf -interaction=nonstopmode -silent -Werror -file-line-error -cd test/main.tex
