---
title: シェル
pre: ../../include/u.i
post: ../../include/nav.i
---

.revision
2004年11月29日更新
=シェル

	Plan 9唯一のシェルは/bin/rcです。
	それについてのメモ。

	= ファイル名の補完

	途中までファイル名を書いて、^f(control-f)キーを押すと、
	1つに限定される場合はそれに補完されて、
	複数ある場合は、候補が表示されます。

	単純な補完のようで、
	以下のように入力しても、[date(1)]が選ばれるわけではないです。

	.console
	!% dat^f

	次のものなら想像どおり。

	.console
	!% /bin/dat^f

.aside
{
	=参考ページ
	*[rc - the Plan9 shell|http://p9.nyx.link/rc/index.html]
	*[rc - the Plan9 shell(2)|http://p9.nyx.link/rc/rc2.html]
}
