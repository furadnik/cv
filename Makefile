PDFS = main_en.pdf main_cz.pdf main_publications.pdf

VENV=.venv
PIP=$(VENV)/bin/pip
HUE=$(VENV)/bin/hue

all: doc main.pdf

doc: $(PDFS)

main.pdf: main_en.pdf
	cp main_en.pdf main.pdf

$(PDFS): %.pdf: %.tex main.tex papers.bib papers_cz.bib papers_en.bib colors.tex
	cp papers.bib papers_all.bib
	cat "$$(echo '$@' | sed 's/\.pdf/.bib/' | sed 's/^main/papers/')" >> papers_all.bib
	lualatex $(notdir $<) || echo "error"
	biber $(basename $(notdir $<)) || echo "error"
	lualatex $(notdir $<) || echo "error"
	lualatex $(notdir $<) || echo "error"

main_publications.pdf: main_publications.tex papers.bib papers_en.bib colors.tex
	cp papers.bib papers_all.bib
	cat "papers_en.bib" >> papers_all.bib
	lualatex $(notdir $<) || echo "error"
	biber $(basename $(notdir $<)) || echo "error"
	lualatex $(notdir $<) || echo "error"
	lualatex $(notdir $<) || echo "error"


colors.tex: $(VENV)/bin/activate
	echo "\\definecolor{HueColor}{RGB}{$$($(HUE) --min_contrast AAA --format '{r}, {g}, {b}')}" \
		>colors.tex

purge:
	rm $(PDFS:.pdf=.fls) || echo "fine"
	rm $(PDFS:.pdf=.ist) || echo "fine"
	rm $(PDFS:.pdf=.aux) || echo "fine"
	rm $(PDFS:.pdf=.fdb_latexmk) || echo "fine"
	rm $(PDFS:.pdf=.log) || echo "fine"
	rm $(PDFS:.pdf=.lol) || echo "fine"
	rm $(PDFS:.pdf=.out) || echo "fine"
	rm papers_all.bib

clean: purge
	rm $(PDFS) || echo "fine"

$(VENV)/bin/activate:
	python -m venv $(VENV)
	$(PIP) install 'git+https://github.com/furadnik/yearly-hue'


.PHONY: all purge clean colors.tex
