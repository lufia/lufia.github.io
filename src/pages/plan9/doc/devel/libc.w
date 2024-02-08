---
title: libc tips
style: ../../../../styles/global.css
pre: ../../../../layouts/plan9/u.i
post: ../../../../layouts/plan9/nav.i
---

.revision
2009年6月29日更新
=libc tips

	=atoi, atol

	Plan 9のatoiは、0xのような、Cと同じプリフィックスを解析するようです。
	ANSIでは[strtol(s, NULL, 10)と等価|http://ja.wikipedia.org/wiki/Atoi]
	らしいですが、Plan 9 libcではstrtol(nptr, nil, 0)とだいたい同じ。

.aside
{
	=関連情報
	*[atof(2)]
}
