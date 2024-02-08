# MKSHELL is referred only on Unix
MKSHELL=$PLAN9/bin/rc

# resources
MAPFILES=`{cd src/pages && ls */*/*/*.map}
JPEGFILES=`{cd src/pages && ls */*/*.jpg}
PNGFILES=`{cd src/pages && ls */*/*.png}

#`{cd src/pages && ls */*/*.df */*/*.pic}\

JSFILES=`{ls lib/*.js}
XSDFILES=`{ls lib/*.xsd}

TARG=\
	${MAPFILES:%.map=public/%.svg}\
	${JSFILES:%.js=public/%.js}\
	${JPEGFILES:%.jpg=public/%.jpg}\
	${PNGFILES:%.png=public/%.png}\
	${XSDFILES:%.xsd=public/%.xsd}\

all:V: $TARG
	npm run build

public/(.+)/([^/]*)\.svg:RD: src/pages/\1/\2.map
	mkdir -p public/$stem1
	mapsvg $MAPFLAGS $prereq >$target

public/(.+)/([^/]*)\.png:RD: src/pages/\1/\2.df
	mkdir -p public/$stem1
	dformat $prereq |
	pic | eqn | troff -ms |
	lp -dstdout |
	gs -q -dSAFER -dBATCH -dNOPAUSE -r100 -s'DEVICE=ppm' -s'OutputFile=-' - |
	ppm -tc |
	crop -c 255 255 255 |
	topng >$target

public/(.+)/([^/]*)\.png:RD: src/pages/\1/\2.pic
	mkdir -p public/stem1
	pic $prereq | troff |
	lp -dstdout |
	gs -q -dSAFER -dBATCH -dNOPAUSE -r100 -s'DEVICE=ppm' -s'OutputFile=-' - |
	ppm -tc |
	crop -c 255 255 255 |
	topng >$target

public/(.+)/([^/]*)\.jpg:RD: src/pages/\1/\2.jpg
	mkdir -p public/$stem1
	cp $prereq $target

public/(.+)/([^/]*)\.png:RD: src/pages/\1/\2.png
	mkdir -p public/$stem1
	cp $prereq $target
