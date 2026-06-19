@include u.i
%title fs64からfossil+ventiへの移行

=fs64からfossil+ventiへの移行
.revision
2013年8月18日作成

	=移行の理由

	いろいろあるけれど、上から順に、

	*ファイル名の長さ制限がつらい(lnfsの存在を気にしたくない)
	*シリアルポートの存在が厄介でIaaSへ移せない(ログ取りしている)
	*バックアップが難しい(都度、configモードからcopydevする?)
	*メンテされていないので、環境の維持が大変
	*現在は、fossilも安定しているらしい

	特にファイル名の長さ制限が致命的で、
	lnfsのサポートが無ければhgの一部でファイル名が長過ぎて保存できず、
	結果、Go言語をコンパイルできないとかなんとか。
	べつにhgはどうでもいいけれど、Go言語は使いたいですね。

	仮に、fs64のファイル名を長くしようとすると、
	fs64カーネルのNAMELEN定数を変更すれば一定までは増やせます。
	けれど、Dirent構造体のレイアウトが変わるので、
	運用中のサーバをどうこうするのは難しいと思います。

	これはcwfs(4)でも同じで、Dentry構造体は変わっていないようですし、
	今のところ[9frontのcwfs|
	http://code.google.com/p/plan9front/source/browse/sys/src/cmd/cwfs/portdat.h]
	であっても、変わっていないようです。

	=Ventiのバックアップ

	外部メディアへバックアップするにはbackup(8)というそのものがあるし、
	他のサーバへコピーしたい場合は、venti(1)にventi/copyがあります。
	arena全体の見た目は大きくても、実際は小さいarenaの集合なので、
	個別にバックアップができます。

	=Ventiのリストア

	未調査

	=ディスクの追加

	(たぶん)
	追加したディスクをventi/fmtarena、
	venti/fmtisect(必要ならventi/fmtbloomも)して、
	フォーマットしたディスクをventi.confに追記。
	このとき、順番は変えてはだめらしい。
	最後に、ventiへ新しい領域を認識させるため、
	venti/fmtindex -aを実行する。

	ventiのindexを再構築するのはventi/buildindex。
	arenaのデータをもとに、indexを再構築するらしい。

	=fs64からのデータ移行

	Wikiの[Setting up Fossil|
	http://www.plan9.bell-labs.com/wiki/plan9/setting_up_fossil/index.html]
	を読む。

.aside
{
	=参考サイト
	*[Setting up Venti|http://www.plan9.bell-labs.com/wiki/plan9/setting_up_Venti/index.html]
	*[Ventiの管理|http://plan9.aichi-u.ac.jp/admin/venti/]
	*[Venti論文|http://plan9.bell-labs.com/sys/doc/venti/venti.html]
	*[Vent論文の翻訳(途中まで)|http://p9c.tsubame2.org/plan9/venti.html]
}

@include nav.i
