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
	@echo Cleaning up ${target}.
	-@rm -f *.aux *.bbl *.log *.lof *.toc *.blg ${target}.pdf

