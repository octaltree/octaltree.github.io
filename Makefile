TTFS = $(wildcard fonts/rictydiminished/*.ttf)

all: fonts/ricdim

fonts/rictydiminished:
	mkdir -p fonts/rictydiminished
	cd fonts/rictydiminished &&\
		curl -L http://www.rs.tus.ac.jp/yyusa/ricty_diminished/ricty_diminished-4.1.0.tar.gz|\
		tar xzvf -

node_modules/.bin/fontmin:
	npm install

fonts/ricdim: index.html $(TTFS) node_modules/.bin/fontmin fonts/rictydiminished
	if [ -d fonts/ricdim ]; then rm fonts/ricdim/*; fi
	mkdir -p fonts/ricdim
	text=`cat index.html` && for f in `ls fonts/rictydiminished| grep .ttf`; do ./node_modules/.bin/fontmin -t "$$text" fonts/rictydiminished/$$f ./fonts/ricdim; done
	for f in `ls fonts/ricdim`; do to=`echo "$$f"| sed -e 's/RictyDiminished/ricdim/g'`; mv "fonts/ricdim/$$f" "fonts/ricdim/$$to"; done
	for f in `ls fonts/ricdim| sed '/ricdim.*\.css$$/!d'`; do sed -i 's/\(RictyDiminished\|Ricty-Diminished\|Ricty Diminished\)/ricdim/g' "fonts/ricdim/$$f"; done
	for f in `ls fonts/ricdim| sed '/ricdim.*\.css$$/!d'`; do sed -ie '1i /*\n  RictyDiminished licensed under the SIL Open Font License\n  http://www.rs.tus.ac.jp/yyusa/ricty_diminished.html\n  ricdim is subset of RictyDiminished licensed under SIL Open Font License\n*/' "fonts/ricdim/$$f"; done
	ls fonts/ricdim| grep .csse| xargs -L1 -i rm "fonts/ricdim/{}"
