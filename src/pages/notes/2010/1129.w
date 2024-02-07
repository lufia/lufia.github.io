---
title: WCF Data Servicesメモ
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2011年6月28日更新
=WCF Data Servicesメモ

	=WCF Data ServicesとWCF RIA Servicesの使い分け

	|WCF(ASMX Web Service)	SOAP
	|WCF Data Service		REST
	|WCF RIA Services		両方対応っぽい感じ

	結局どれを使えばいいの？ってところですけど、[MSDNのブログ|
	http://blogs.msdn.com/b/aonishi/archive/2010/05/31/10017706.aspx]によると、

	>エンティティやメタデータを利用して
	>ビジネスロジックを実装していく場合は、WCF RIA Services、
	>RESTアクセスが中心ならばWCF Data Servicesという感じです。

	とのことです。

	=JSON形式でデータ操作

	通常はXML形式のデータが返ってきますが、
	リクエストのAcceptヘッダをapplication/jsonにしておくと、
	JSONで返してくれます。

	.console
	!% telnet svr 80
	!GET /Service.svc/List?$top=2 HTTP/1.1
	!Host: svr
	!Connection: close
	!Accept: application/json

	ここで、HTTP/1.0にすると、
	Acceptヘッダが無視されてXML形式になるので注意です。
	また、POSTやPUTの時は、これに加えてContent-Typeも指定しておきます。

	.http
	!Content-Type: application/json

	=サービス操作

	svcファイルに、WebGetかWebInvoke属性を付けたメソッドを定義して、
	SetServiceOperationAccessRuleを使って公開します。

	*[サービス操作を定義する|
	http://msdn.microsoft.com/ja-jp/library/dd744841.aspx]

	=複数の主キー

	1つの場合は、括弧の中にそのまま値を書きますが、
	複数ある場合は名前と値のペアを並べるようです。

	!List(1)
	!List('ID')
	!List(Key1='xxx',Key2=0)

	=子アイテムの指定方法

	\$expandや$selectに渡すプロパティ名は、/で階層を表します。

	!$expand=Item,Item/Details

	=非同期ローディング

	Silverlightなどで、非同期読み込みする場合、
	比較的便利な書き方があったのでメモ。

	.cs
	!var uri = new Uri("DataService.svc", UriKind.RelativeOrAbsolute);
	!var ctxt = new DataEntities(uri);
	!var binding = new DataServiceCollection<Item>();
	!binding.LoadCompleted += (sender, e) => {
	!	if(e.Error != null)
	!		return;
	!	if(binding.Continuation != null){
	!		binding.LoadNextPartialSetAsync();
	!		return;
	!	}
	!	// ここでデータが全部読み込み終わり
	!	var q1 = from c in binding select c.xxx;
	!};
	!binding.LoadAsync(ctxt.Items);

	=ADO.NET Entity Frameworkメモ

		WCF Data Servicesとは違いますが、
		関係も深いのでまとめてメモ。

		=アソシエーションの使い方

		まず、ふつうに張って関係を定義します。
		このときに、どれとどれが関係しているのかを決めるのですが、
		ここで2種類の連結方法があります。

		:外部キーを残さないもの
		-独立アソシエーション
		:外部キーを残すもの
		-外部キーアソシエーション

		=独立アソシエーション

		サロゲートキーなテーブルならこちら。

		アソシエーションのマッピングを開いてマップします。
		xxにマップという欄は、
		子テーブル(*0または1*対*多*なら*多*のほう)を選んで、
		マップしたプロパティを子テーブル側から削除します。

		.note
		キーとなるプロパティは削除できないので、
		その場合は外部キーアソシエーションを使う？

		=外部キーアソシエーション

		自然キーのテーブルはこちら。
		\.NET Framework 4.0から対応しているみたいです。

		アソシエーションをダブルクリックで開いて、
		対応するプロパティを定義します。
		\*0または1*対*多*関係の場合は、
		親テーブル(*0または1*のほう)を選びます。
		入力が終わったら、アソシエーションのマッピングを開いて、
		そこにマッピングが残っていたら削除して終わりです。

		=参考ページ
		*[外部キーアソシエーションに変更する方法|
		http://d.hatena.ne.jp/sixpetals/20100506]

	=トラブルメモ

		=組み込み演算子が動作しない

		組み込み演算子($selectなど)はASCII文字しか認識しないのかも。
		以下の指定はどちらも正常に動作します。

		!List?$select=Type
		!リスト('ID')

		以下の場合はエラーになります。

		!List?$select=種類

		リスト名はマルチバイト文字を受け付けるのですね。
		なんだかなあ、ださいなあ、と思います。

		=datetime型の書き込みができない

		datetime型を持つレコードを、
		JSON形式でPOSTまたはPUTすると、文法エラーが返ってきます。
		具体的なコードは以下。

		.js
		!var data = {d: "\\/Date(1291005669546)\\/"}
		!post(url, data)		// エラー

		これは、文字列としては"\/Date(...)\/"なのですが、
		JSONにすると"\\/Date(...)\\/"になり、
		WCF Data Servicesの想定する日付表現と異なるためです。
		ややこしいことに、以下のように書くと、
		今度は"/Date(...)/"となり、これもまたエラーになります。

		!var data = {d: "\/Date(1291005669546)\/"}

		これ、バグじゃないかとさえ思えてくるのですが、
		とりあえず以下のようにすると、うまく動作します。

		!var data = {d: "2010-11-29T12:00:00"}

		=PUTするとアクセス権エラーになる

		GET, POSTはできているのにPUTがエラーになる場合、
		Webサーバのファイルアクセス権が足りないのかもしれません。
		関係するアクセス権は以下の通り。

		*Webサーバ(http動詞)
		*Webサーバ(ファイルアクセス権)
		*WCF Data Services
		*データベース(ユーザ認証)
		*データベース(テーブルアクセス権)

		分かりにくいのはWebサーバ(ファイルアクセス権)でしょうか。
		この場合、[Troubleshooting Failed Request Using Tracing in IIS7|
		http://learn.iis.net/page.aspx/266/troubleshooting-failed-requests-using-tracing-in-iis-7/]
		のようにログを取ると、FileAuthorizationになっていますので、
		wwwrootまたは必要な場所でIUSRに書き込み権を与えると解消します。
		IIS_IUSRとは違いますので注意です。

		=キーを指定してデータを取得すると構文エラーになる

		WCF Data Servicesでは、':'(コロン)を含むURLを弾くみたいです。
		これが問題になるのはdatetime型を
		キーにしている場合が多いかなあと思いますが、
		時刻が全部0なら、datetime'2010-11-29'のように
		省略すれば回避できます。

		しかし、時刻部分がある場合はどうすればいいのだろう。

.aside
{
	=関連情報
	*[SproutCoreとWCF Data Servicesの連携|1227.w]

	=WCF Data Services
	*[WCF Data Services|
	http://msdn.microsoft.com/ja-jp/library/cc668792.aspx]
	*[Open Data Protocol|http://www.odata.org/]
	*[実用OData|
	http://msdn.microsoft.com/ja-jp/magazine/ff714561.aspx]
	*[ODataとAtomPub|
	http://msdn.microsoft.com/ja-jp/magazine/ff872392.aspx]
	*[OData-SDK|http://www.odata.org/developers/odata-sdk]
}
