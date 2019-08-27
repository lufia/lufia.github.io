@include u.i
%title fs64のバグ？かな？

=fs64のバグ？かな？
.revision
2007年3月19日作成

	lcコマンドが消えた件を復旧してたときに気がついたこと。

	すごく適当にまとめると、subno is N not Mというエラーの後
	カーネルがパニックする場合は、/sys/src/fs/pc/sdata.c:2536を、
	以下のように書き換えるとうまくいくかもしれません。

	=変更前
	!sdp->index = i;

	=変更後
	!sdp->index = i*NCtlrdrv;

@include nav.i
