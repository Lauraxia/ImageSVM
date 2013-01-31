texcc  = pdflatex
bibcc  = bibtex
target = report

all:
	${texcc} ${target}
	${bibcc} ${target}
	${texcc} ${target}
	${texcc} ${target}

clean:
	-rm -f ${target}.pdf *.aux *.bbl *.blg *.log
