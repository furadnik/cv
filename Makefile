MAINS = $(shell find . -maxdepth 3 -type f -name main.tex)

PDFS = main_en.pdf main_cz.pdf

all: doc

doc: $(PDFS)

$(PDFS): %.pdf: %.tex main.tex papers.bib papers_cz.bib papers_en.bib
	cp papers.bib papers_all.bib
	cat "$$(echo '$@' | sed 's/\.pdf/.bib/' | sed 's/^main/papers/')" >> papers_all.bib
	pdflatex $(notdir $<) || echo "error"
	bibtex $(basename $(notdir $<)) || echo "error"
	pdflatex $(notdir $<) || echo "error"
	pdflatex $(notdir $<) || echo "error"

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

upload: doc
	cd $(dir $<) && ./upload_to_mff.sh || echo "error"

.PHONY: all purge clean
