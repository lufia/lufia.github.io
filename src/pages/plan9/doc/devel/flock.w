---
title: ファイルのロック
style: ../../../../styles/global.css
pre: ../../../../layouts/plan9/u.i
post: ../../../../layouts/plan9/nav.i
---

.revision
2004年11月8日更新
=ファイルのロック

flockは無い。

openやcreateを呼び出す時、明示的にDMEXCLビットを立てるか、
ファイルのパーミッションにl(exclusive access)を加えればロックされる。

.aside
{
	=マニュアル
	*[chmod(1)]
	*[open(2)]
}
