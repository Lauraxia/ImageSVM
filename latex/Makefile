ccpdf  = pdflatex
ccbib  = bibtex
target = report

all:
	@echo Building ${target} Base File
	@${ccpdf} ${target} 1>/dev/null
	@echo Creating Bibliography References Lookup File
	@${ccbib} ${target} 1>/dev/null
	@echo Linking References to ${target}.pdf
	@${ccpdf} ${target} 1>/dev/null
	@echo Finalizing ${target}.pdf
	@${ccpdf} ${target} 1>/dev/null

clean:
	@echo Cleaning up ${target} generation files.
	-@rm -f *.aux *.bbl *.log *.lof *.toc *.blg

cleanpdf:
	@echo Removing ${target}'s PDF rendering.
	-@rm -f ${target}.pdf

