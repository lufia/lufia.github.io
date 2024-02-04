@include u.i
%title secstoreの使い方

.revision
2009年10月20日更新
=secstoreの使い方

	secstoreとは、認証情報を恒久的に記録するものです。
	通常factotumが認証情報を取り扱うのですが、
	こいつはログアウトすると消えてしまいます。
	そこで、secstoreに保存しておいて、
	ログイン時にそこからfactotumへ取り込んだりします。
	factotumがメモリとすると、
	ハードディスクみたいなものですね。

	=secstoreの有効化

	認証サーバのコンソールから実行します。
	有効期限がありますので、忘れないようにしましょう。
	まあ、忘れたとしても、*/adm/secstore/who/user*を読むと、
	1行目に有効期限が書かれていたりします。

	.console
	!# auth/secuser -v user
	!(secstoreパスワードを入力)

	=読み書き

	.console
	!% ramfs
	!% cd /tmp
	!
	!# factotumとして保存されているものを取得
	!% auth/secstore -g factotum
	!secstore password:
	!
	!# factotumをsecstoreに保存
	!% auth/secstore -p factotum
	!secstore password:

	これらは、*/adm/secstore/store/$user*以下に
	factotumという名前で保存します。
	ファイル名が違えば、仮にpasswdというファイルを読み書きすれば
	store以下のpasswdを扱うのですが、[factotum(4)]が扱うものは
	factotumという名前で保存しなければいけません。

.aside
{
	=関連情報
	*[secstore(1)]
	*[secstore(8)]
}

@include nav.i
