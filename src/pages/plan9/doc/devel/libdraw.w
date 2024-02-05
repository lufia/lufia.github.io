---
title: libdraw tips
style: ../../../../styles/global.css
pre: ../../include/u.i
post: ../../include/nav.i
---

.revision
2004年11月10日更新
=libdraw tips

	=トラブルシューティング

		=ウインドウサイズを変更したのに、eresizedが呼ばれない
		einitにおいてEmouseビットを立てなかった場合は、
		サイズを変更した時のeresizedは呼ばれない。

.aside
{
	=関連情報
	*[event(2)]
}
