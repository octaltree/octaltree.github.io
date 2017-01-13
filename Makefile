TTFS = $(wildcard rictydiminished/*.ttf)

all: fonts

rictydiminished:
	mkdir -p rictydiminished
	cd rictydiminished &&\
		curl -L http://www.rs.tus.ac.jp/yyusa/ricty_diminished/ricty_diminished-4.1.0.tar.gz|\
		tar xzvf -

node_modules/.bin/fontmin:
	npm install

fonts: index.html $(TTFS) node_modules/.bin/fontmin rictydiminished
	text=`cat index.html` && for f in `ls rictydiminished| grep .ttf`; do ./node_modules/.bin/fontmin -t "$$text" rictydiminished/$$f ./fonts; done
	for f in `ls fonts`; do to=`echo "$$f"| sed -e 's/RictyDiminished/ricdim/g'`; mv "fonts/$$f" "fonts/$$to"; done
	for f in `ls fonts| sed '/ricdim.*\.css$$/!d'`; do sed -i 's/\(RictyDiminished\|Ricty-Diminished\|Ricty Diminished\)/ricdim/g' "fonts/$$f"; done
	for f in `ls fonts| sed '/ricdim.*\.css$$/!d'`; do sed -ie '1i /*\n  RictyDiminished licensed under the SIL Open Font License\n  http://www.rs.tus.ac.jp/yyusa/ricty_diminished.html\n  ricdim is subset of RictyDiminished licensed under SIL Open Font License\n*/' "fonts/$$f"; done
	ls fonts| grep .csse| xargs -L1 -i rm "fonts/{}"
