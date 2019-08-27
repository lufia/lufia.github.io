@include u.i
%title Python

=Python
.revision
2009年11月2日更新

	=インストール
	Python 2.5.1を[contrib/fgb/tar/python.tgz]からダウンロード、
	展開したものからsys/src/cmd/python/README.Plan9を読んで
	インストールすれば終わり。

	いくつか必要なライブラリがあるので、少し手間がかかります。

	=お手軽にインストール
	pythonのバイナリが[contrib/bichued/root/386/bin/python]に
	あるので、それを/binにコピー。

	!% 9fs sources
	!% cp /n/sources/contrib/bichued/root/386/bin/python /bin/python

	このままではモジュール類がありませんので、
	上記の[contrib/fgb/tar/python.tgz]に含まれるものから
	sys/lib/pythonを/sys/lib/pythonにコピーします。

	!% @{cd sys/lib && tar c python} | @{cd /sys/lib && tar xT}

@include nav.i
