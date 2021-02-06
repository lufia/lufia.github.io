@include u.i
%title patchを送る

.revision
2008年6月12日更新
=patchを送る

	Plan 9には、配布物へのパッチを
	sourcesへ送るコマンドが用意されています。

	=使い方

	.sh
	!patch/create subject email paths [<description]

	:subject
	-/n/sources/patchに作成されるディレクトリ名
	:email
	-作成者の連絡先
	-無い場合は'-'とする
	:paths
	-パッチ適用済みのファイル。
	-通常、/sys/src以下のファイルになる。相対パスでも可。

	=例

	この例ではオリジナルを書き換えないように
	コピーをbindしてますが、直接書き換えてしまっても大丈夫です。
	patch/createは、pathsの各ファイルと/n/sources以下の
	同じファイルを比較してアップロードします。

	.console
	!% cd /tmp
	!% cp $original $new
	!(edit $new)
	!% 9fs sources	# patch/createがマウントするので無くてもいい
	!% bind $new $original
	!% patch/create error-subject - $original
	!(パッチの説明...)
	!^D

.aside
{
	=マニュアル
	*[patch(1)]
}

@include nav.i
