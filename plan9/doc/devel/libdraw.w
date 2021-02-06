@include u.i
%title libdraw tips

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

@include nav.i
