---
title: ファイルのロック
pre: ../../include/u.i
post: ../../include/nav.i
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
