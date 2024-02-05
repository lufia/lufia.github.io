---
title: hget
style: ../../../../styles/global.css
pre: ../../include/u.i
post: ../../include/nav.i
---

.revision
2009年12月11日更新
=hget

	=BASIC認証
	\[Plan9でTwitter|
	https://oraccha.hatenadiary.org/entry/20091201/1259668368]を読んで、
	なぜこれでfactotumが使われるのだろう？と気になったので調べてみました。

	どうやらWWW-Authenticateヘッダでbasic認証が指定されている場合、
	factotumのエントリが使われるようですね。

	!proto=pass service=http server=%q realm=%q

.aside
{
	=参考ページ
	*[hget(1)]
}
