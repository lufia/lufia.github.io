@include u.i
%title ASP.NETページ構文とHTMLヘルパ

=ASP.NETページ構文とHTMLヘルパ
.revision
2011年6月7日作成

	=ページ構文

		ASP.NETでは<<% ... %>>と書くと、
		その中をいろいろ処理してページを生成してくれます。
		この機能は[ページ構文|
		http://msdn.microsoft.com/ja-jp/library/fy30at8h%28v=VS.80%29.aspx]
		と呼ぶらしいのですが、それはともかく、よく忘れるのでまとめ。

		=<<% ... %>>

		これは、中にプログラムを書けます。
		何か文字を書き出したい場合はResponse.Write(string)を使うらしいですが、
		次の<<%= ... %>>をよく使うので、あまり。

		!<% for(var i = 0; i < 10; i++) Response.Write(i+"\n") %>

		=<<%= ... %>>

		上記と異なり、この中はプログラム式しか書けません。
		その代わり、Response.Write(string)を使わなくても
		演算結果を書きだしてくれます。

		!<% for(var i = 0; i < 10; i++) { %>
		!	<%= i %>
		!<% } %>

		=<<%: ... %>>

		これは、<<%= ... %>>とほとんど同じですが、
		HTMLでの特殊文字('<<'とか)を文字参照('&lt;'など)に
		変換してから書き出します。

		とはいえ、これを使わなくても、
		HTMLヘルパ関数の中ではHTML特殊文字を変換しますし、
		これを使っても式の結果がオブジェクトなら特に何も起こらないので、
		詳しいところはいまいち分かりません。

		!<%-- エスケープしない --%>
		!<%= Html.ActionLink("Index", "Home", new{ id=3 }) %>
		!
		!<%-- これもエスケープしないでふつうに動く --%>
		!<%: Html.Action("Index", "Home", new{ id=3 }) %>

		=<<%# ... %>>

		データバインド式らしい。DataBind()を呼び出したときに、
		指定したデータをバインドするとか。
		ASP.NET MVC2では使わなくても問題ないのでよく知らない。

		=<<%$ ... %>>

		設定らしい。

		=<<%-- ... --%>>

		コメント。

	=HTMLヘルパ

	Htmlオブジェクトのメソッドとして実装されています。
	HTML要素と関数の対応リスト。

	:a
	-ActionLink
	:form
	-BeginForm
	-EndForm
	:input[[type=text]]
	-TextBox
	:input[[type=radio]]
	-RadioButton
	:input[[type=hidden]]
	-Hidden
	:select
	-DropDownList
	:select[[multiple=multiple]]
	-ListBox

	!<%	var options = new List<SelectListItem> {
	!		new SelectListItem { Text = "item1", Value = "1" },
	!		new SelectListItem { Text = "item2", Value = "2" },
	!	};
	!	using(Html.BeginForm("Create")){
	!%>
	!		<%= Html.DropDownList("mode", options) %>
	!		<input type="submit" value="send"/>
	!<%	} %>

.aside
{
	=関連ページ
	*[ASP.NET関連のいろいろまとめ|0603.w]

	=参考サイト
	*[Introduction to ASP.NET inline expressions|
	http://support.microsoft.com/kb/976112/en-us]
	*[HTMLヘルパーを活用|http://d.hatena.ne.jp/shiba-yan/20110327/1301152413]
}

@include nav.i
