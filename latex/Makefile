ccpdf  = pdflatex
ccbib  = bibtex
target = report

all:
	@echo Building ${target} Base File
	@${ccpdf} ${target} > /dev/null 2>&1
	@echo Creating Bibliography References Lookup File
	@${ccbib} ${target} > /dev/null 2>&1
	@echo Linking References to ${target}.pdf
	@${ccpdf} ${target} > /dev/null 2>&1
	@echo Finalizing ${target}.pdf
	@${ccpdf} ${target} > /dev/null 2>&1

clean:
	@echo Cleaning up ${target} generation files.
	-@rm -f *.aux *.bbl *.log *.lof *.toc *.blg

cleanpdf:
	@echo Removing ${target}'s PDF rendering.
	-@rm -f ${target}.pdf

