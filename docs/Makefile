# Makefile to ease trivial tasks for the project

all: convert

.PHONY: convert convert1 convert2
convert: convert1 convert2
bib-convert: convert bib
convert1 convert2:
	# convert LaTex file to PDF
	pdflatex -output-directory=$(dir ${DOC}) ${DOC}


.PHONY: bib
bib:
	@bibtex ${DOC:.tex=.aux}


.PHONY: clean
clean:
	# clean out LaTex cache and temporary files
	@find . \( -name '*.log' -o -name '*.aux' -o -name '*.bbl' -o -name '*.blg' \) -delete
