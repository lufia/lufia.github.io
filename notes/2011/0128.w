@include u.i
%title SproutCoreのいろいろ

=SproutCoreのいろいろ
.revision
2011年1月28日作成

	=HTTP Proxy

	Buildfileにproxyを指定すると、
	そのアクセスがあった場合に:toで指したホストへ切り替えてくれます。
	テストをするときにとても便利。

	!proxy '/services/Service1.svc', :to => 'www.local'

	sc-serverを再起動するまでは反映しません。

	=ビルド

	プロジェクトの場所に移動して、

	!sc-build -r [-c] [--languages=ja]

	これで、tmp/build以下にファイルがビルドされてます。
	cオプションは事前にクリーン。

	.note
	いちど失敗しても、cオプションを外して何度か実行すると完了するみたい。
	何が原因なのでしょうね。

	=展開

	tmp/build以下のパッケージを、webサーバのルートへコピーします。
	URLは、だいたい/$project/$application/$lang/$GUID/index.html。

		=パッケージ名の指定

		デフォルトはstaticですが、
		Buildfileでurl_prefixを使って設定できます。

		!config :all, :required => :sproutcore, :url_prefix => '/path'

		=リダイレクト

		URLの中に、およそビルドごとに変化するGUIDが入っていますので、
		連絡するURLを単純にしておいて、
		なんらかの方法でリダイレクトするといいかもしれません。
		個人的に/$project/$application/までを連絡するのがおすすめです。

	=アプリケーションの追加

	!sc-gen app AppName

	\$project/apps以下に、新しいアプリケーションが作られます。

	=ライブラリ

	SC.Enumerable.reduceMaxは数値比較(<<)なので、
	DateTime型の比較には使えません。

@include nav.i
