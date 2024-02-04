---
title: ASP.NET関連のいろいろまとめ
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2011年7月14日更新
=ASP.NET関連のいろいろまとめ

	=WCF Data Services

	WCF RIA Servicesで子テーブルを含む場合は.Include()ですが、
	WCF Data Servicesでは.Expand()を使います。
	同じ作業なのにいちいち名前が違っていてめんどくさい。。。

	ちなみにExpand()は、$expand=xxxに渡す文字列を引数に書きます。

	=ASP.NET MVC2

		はじめてつかった。

		=JSONを返す

		コントローラからJSONを返すには、
		戻り値の型をJsonResultに変えて(通常はActionResult)、
		Jsonヘルパメソッドの戻り値を返します。

		.cs
		!public PartialViewResult Index()
		!{
		!	var q = from c in ctxt.Items select c;
		!	return Json(q, [JsonRequestBehavior]);
		!}

		それから、コントローラの中からクエリ文字列をみるには、
		Request.QueryString[[]]を調べるといいみたい。

		=ユーザコントロールを使う

		コントローラの戻り値をPartialViewResultに変更して、
		PartialView()により作成されたものを返すように作ります。

		.cs
		!public PartialViewResult Index()
		!{
		!	var q = from c in ctxt.Items select c;
		!	return PartialView(q);
		!}

		次に、Html.Action()を使ってその結果を取り込みます。

		.xml
		!<%: Html.Action("Index", "Controller1") %>

		単純な取り込みでよければ、
		ページの最初あたりでコントロールを登録すると使えるようにります。

		.xml
		!<%@ Register TagPrefix="my"
		! TagName="ctl1"
		! Src="~/Views/Controller1/Index.ascx" %>

		runat="server"は必須です。

		.xml
		!<my:ctl1 runat="server"/>

		ただしこの場合、ユーザコントロールの中でModelを参照すると、
		呼び出し元のModelをそのまま参照してしまいます。
		あまり使い道はなさそうです。

		=相対URL

		開発環境と実環境でパスが異なる場合、絶対パスは使えないし、
		同じビューが異なるURLで使われたりするので厳しい。
		こういうとき、Url.Content(string path)を使います。
		これはpathが~/ではじまっている場合、
		正しいURLへ書き換えてくれます。

		=URLの部分取得

		Controller/Action/idなどから、
		idのような特定部分を取り出したい場合、
		Request[["id"]]のように調べると見れます。
		または、ViewData[["id"]]とか。

		=?Length=7

		.cs
		!Html.ActionLink("Action", "Controller", new{ id=3 })

		このようにすると、Home/Action?Length=7という
		どこに設定したのだか分からないパラメータ付きURLになります。
		これはメソッドのオーバーロードが悪さをしているらしいので、
		全部パラメータを与えてあげれば解決です。

		.cs
		!Html.ActionLink("Action", "Controller", new{ id=3 }, new{})

		ここでnew{}の代わりにnullを使うとうまくないっぽい。

		=戻りURL

			コントローラで何かを処理した後の戻りURL、
			たとえば削除したときに戻る先はどうするの、という話。

			=UrlReferrerを使う

			単純に戻る場合はUrlReferrerをみればいいです。
			ただし、URLを直接入力した場合はnullなので使いづらい。

			.cs
			!if(Request.UrlReferrer != null)
			!	Redirect(Request.UrlReferrer.AbsolutePath);

			=戻りURLパラメータを渡す

			RedirectToUrlのようなパラメータにフォーム等で渡す方法。

			.xml
			!<% using(Html.BeginForm()) { %>
			!	<%: Html.Hidden("redirectToUrl", "...") %>
			!<% } %>

			コントローラ側では、引数として受け取る。

			.cs
			!public ActionResult Action1(string redirectToUrl)
			!{
			!	...
			!}

	=jQuery.autocomplete(url, option)

	autocompleteは、urlからデータを読み込み、
	その内容をもとに表示します。
	このデータは||で区切った行の集まりです。
	また、urlはQUERY_STRINGに"q=(検索文字列)"を渡すので、
	データを絞り込むのにそれが使えます。

	!key1|value1
	!key2|value2
	!...

	配列をもとにオートコンプリートする場合は、
	autocomplete()の代わりにautocompleteArray()を使います。

	オプションはいろいろありますが、よく使うものを例に書きました。

	.js
	!$(document).ready(function(){
	!	$('#target').autocomplete(url, {
	!		max: 25,
	!		formatItem: function(r){ return r[1] },
	!		formatResult: function(r){ return r[1] }
	!	}).result(function(e, r){
	!		location.href = r[0]
	!	})
	!})

	result()は一覧から選択したときに関数を実行します。

	=jQuery.dataTables

	いろいろありすぎてよくわからない。

	*[オプション一覧っぽいもの|
	http://www.sprymedia.co.uk/article/DataTables]

.aside
{
	=関連ページ
	*[ASP.NETページ構文とHTMLヘルパ|0607.w]

	=参考サイト
	*[コードで学ぶ ASP.NET MVC アプリケーション開発入門|
	http://msdn.microsoft.com/ja-jp/asp.net/gg490787]
	*[ASP.NET MVC入門|
	http://www.atmarkit.co.jp/fdotnet/aspnetmvc/index/index.html]
	*[ASP.NET MVC 3開発入門|
	http://d.hatena.ne.jp/shiba-yan/20110208/1297096899]
	*[ASP.NET Music Storeチュートリアル|
	http://msdn.microsoft.com/ja-jp/asp.net/gg315881.aspx]
	*[EditorFor、DisplayForで使用されるカスタムテンプレート|
	http://d.hatena.ne.jp/freemake/20100907/1283880424]
}
