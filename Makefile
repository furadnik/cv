MAINS = $(shell find . -maxdepth 3 -type f -name main.tex)

PDFS = $(MAINS:.tex=.pdf)

all: doc

doc: $(PDFS)

$(PDFS): %.pdf: $(dir %)/*.tex
	cd $(dir $<) && pdflatex main.tex || echo "error"

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
