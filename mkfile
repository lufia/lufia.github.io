# MKSHELL is referred only on Unix
MKSHELL=$PLAN9/bin/rc

# resources
PAGE=\
	`{ls lib/*.js lib/*.xsd}\
	`{ls estpolis/*/*/*.map}\
	`{ls notes/*/*.jpg}\
	`{ls notes/*/*.png}\
#	`{ls notes/*/*.jpg notes/*/*.df notes/*/*.pic}\

TARG=\
	${PAGE:%.map=public/%.svg}\
	${PAGE:%.df=public/%.png}\
	${PAGE:%.pic=public/%.png}\
	${PAGE:%.js=public/%.js}\
	${PAGE:%.jpg=public/%.jpg}\
	${PAGE:%.png=public/%.png}\
	${PAGE:%.xsd=public/%.xsd}\

all:V: $TARG
	npm run build

release:V: all
	touch out/.nojekyll
	git -C out init
	git -C out remote add origin `{git remote get-url origin}
	git -C out switch -c gh-pages
	git -C out add .
	git -C out commit -m update
	git -C out push -f origin gh-pages

public/(.+)/([^/]*)\.svg:RD: \1/\2.map
	mkdir -p public/$stem1
	mapsvg $MAPFLAGS $prereq >$target

public/(.+)/([^/]*)\.png:RD: \1/\2.df
	mkdir -p public/$stem1
	dformat $prereq |
	pic | eqn | troff -ms |
	lp -dstdout |
	gs -q -dSAFER -dBATCH -dNOPAUSE -r100 -s'DEVICE=ppm' -s'OutputFile=-' - |
	ppm -tc |
	crop -c 255 255 255 |
	topng >$target

public/(.+)/([^/]*)\.png:RD: \1/\2.pic
	mkdir -p public/stem1
	pic $prereq | troff |
	lp -dstdout |
	gs -q -dSAFER -dBATCH -dNOPAUSE -r100 -s'DEVICE=ppm' -s'OutputFile=-' - |
	ppm -tc |
	crop -c 255 255 255 |
	topng >$target

public/(.+)/([^/]*):RD: \1/\2
	mkdir -p public/$stem1
	cp $prereq $target
