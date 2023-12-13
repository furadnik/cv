MAINS = $(shell find . -maxdepth 3 -type f -name main.tex)

PDFS = main_en.pdf main_cz.pdf

all: doc

doc: $(PDFS)

$(PDFS): %.pdf: %.tex main.tex
	cd $(dir $<) && pdflatex $(notdir $<) || echo "error"

purge:
	rm $(MAINS:.tex=.fls) || echo "fine"
	rm $(MAINS:.tex=.ist) || echo "fine"
	rm $(MAINS:.tex=.aux) || echo "fine"
	rm $(MAINS:.tex=.fdb_latexmk) || echo "fine"
	rm $(MAINS:.tex=.log) || echo "fine"
	rm $(MAINS:.tex=.lol) || echo "fine"
	rm $(MAINS:.tex=.out) || echo "fine"

clean: purge
	rm $(MAINS:.tex=.pdf) || echo "fine"

upload: doc
	cd $(dir $<) && ./upload_to_mff.sh || echo "error"

.PHONY: all purge clean
