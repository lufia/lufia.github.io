@include u.i
%title hget

=hget
.revision
2009年12月11日更新

	=BASIC認証
	\[Plan9でTwitter|
	http://d.hatena.ne.jp/oraccha/20091201/1259668368]を読んで、
	なぜこれでfactotumが使われるのだろう？と気になったので調べてみました。

	どうやらWWW-Authenticateヘッダでbasic認証が指定されている場合、
	factotumのエントリが使われるようですね。

	!proto=pass service=http server=%q realm=%q

.aside
{
	=参考ページ
	*[hget(1)]
}

@include nav.i
