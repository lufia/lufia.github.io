---
title: Plan 9 to Inferno translation
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2010年5月12日更新
=Plan 9 to Inferno translation

	=腰痛い
	起き上がれずに、寝たきりです。
	暇なのでInfernoのいろいろまとめます。

	=command
	|*Plan 9*			*Inferno*
	|tar x file.tar		gettar <<file.tar
	|tar c file >>file.tar	ls file || puttar >>file.tar
	|tar t file			lstar <<file
	|gunzip -c file.gz	gunzip file.gz
	|hget url >>out		webgrab -o out url
	|mntgen /n		mount {mntgen} /n
	|rfork			pctl; nsbuild
	|while(line=``{read}){ command }	getlines { command }
	|ip/httpd/httpd		svc/httpd/httpd

	=file structure
	|*Plan 9*			*Inferno*
	|/$objtype/bin		/dis
	|/$objtype/lib		/dis/lib
	|/rc/bin			/dis
	|/srv				/services
	|/proc			/prog
	|/adm/timezone	/locale
	|/adm/keys		/keydb/keys
	|/lib/font/bit		/fonts
	|/sys/src			/appl
	|/sys/include		/include
	|/usr/web			/services/httpd/root
	|$home/lib/profile	$home/lib/wmsetup

	=他にも
	気づいたらこの記事に追記します。
