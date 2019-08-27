@include u.i
%title 家計簿作成メモ

=家計簿作成メモ
.revision
2010年5月9日更新

webアプリ家計簿を作ったときに調べたことをメモ。

	=データ
		=JSONかXMLか
		悩んだけど、ふつうにXMLで。
		というのも、JSONはパースが楽なのはいいけれど、
		反面、[いろいろめんどくさい|
		http://www.atmarkit.co.jp/fcoding/index/webapp.html]ので、
		じゃあ自分で書くよ、と。
		それにXMLで表現すると、
		一般的なXMLツールが使えるのもうれしいしね。
		XML Schemaとか、XSLTとか。

		=XMLの検査
		:[XSV|http://www.w3.org/2001/03/webdata/xsv]
		-XML Schemaそのもののチェック
		:[XML Schema Validator|
			http://tools.decisionsoft.com/schemaValidate/]
		-XML文書のチェック

	=サーバ
		当然Plan 9で動かすので、それなりに。

		=認証
		見られるのは別にいいけど、勝手に変更されるのは困るので、
		Plan 9でいちばん手軽なhttps+basic認証を使います。
		参考までに/cfg/wisp/cpustartの一部。

		!ip/httpd/httpd
		!ip/httpd/httpd -c cert \
		!	-n /cfg/wisp/namespace.https -w /usr/sweb

		他のhttpdだと、XST(Cross Site Tracing)の危険性があるので
		TRACEを無効にしないと恐いですが、
		Plan 9 httpdはGET, HEAD, POSTしか対応していないので大丈夫。

		=実行ファイルの置き場所
		CGIは/bin/ip/httpd以下に置きます。
		たとえばpostというプログラムを置くと、
		http://domain.dom/magic/postとして参照します。
		ちなみに/magic/post/path/toと参照すると、
		postから/path/toを調べられます。
		PATH_INFOみたいなこともできますね。

		=作り方
		/sys/src/cmd/ip/httpd以下のソースを参考にして作ります。
		PATH_INFO系の扱い方はman2html.c、
		POSTの動作はwikipost.cあたりがおすすめ。

		ちなみに附属のライブラリを使う場合、
		httpsrv.hをincludeしないといけないので、
		ソースを/sys/src/cmd/ip/httpd以下にbindしたほうが便利です。

		=各種変数
		:httpdのルートディレクトリ
		-webroot
		:リクエストメソッド
		-HConnection.req->>meth
		:PATH_INFOのようなもの
		-HConnection.req->>uri

		=動作環境
		httpdは、ユーザnoneで動作しています。

		.note
		noneは常にotherビットの扱いになります。
		詳しくは[ユーザ none|http://plan9.aichi-u.ac.jp/none/]。

	=CGIトラブルシューティング
		=パーミッションは間違っていないのに、createがエラーになる
		\[create(2)]は、OWRITEでディレクトリを作るとエラーになります。

		!//fd = create(file, OWRITE, 0777|DMDIR);
		!fd = create(file, OREAD, 0777|DMDIR);
		!close(fd)

		よく考えれば当然のような気もしますが、割と悩みました。

		=syslogに書き込んだはずなのに記録されていない
		syslogは、最初に呼び出された時に/sys/log/lognameを開いて、
		次からはそれに対して書き込みをします。
		なので、bindでルートを変更した場合、
		bind前にファイルを開いていなければログが保存できません。

		=localtimeで返すタイムゾーンがGMTになる
		これもsyslogと同様に、はじめて呼ばれたときに/env/timezoneを
		読みます。/envが開けない場合はGMTとして扱われます。

	=クライアント
		=使ったライブラリ
		*jQuery
		*jQuery UI
		*html5.jpの折れ線グラフ、円グラフ

	=webアプリトラブルシューティング
		=jQuery.ajaxエラー時のHTTPエラーコードが見たい
		第1引数のstatusを見ます。

		!$.ajax({
		!	error: function(req){
		!		alert(req.status)
		!	}
		!})

		req.statusTextはエラー内容のはずですが、
		常にOKが入っているのはなぜだろう。

		=jQuery UI datepickerの書式をyyyy/mm/ddにしたい
		dateFormatオプションに書式を与えます。

		!$('input.date').datepicker({
		!	dateFormat: 'yy/mm/dd'
		!})

		=html5.jpのグラフを再度drawすると、前のグラフが残る
		不具合なのか仕様なのか分かりませんが、とりあえず回避。

		!<section id="graph">
		!	<div>
		!	<canvas width="200" height="200" id="canvas1"></canvas>
		!	</div>
		!</section>

		!$('#graph > div > div').remove()
		!circle.draw(...)

		=数値型に変換しようと"3"+0とすると、"30"になる
		Awkのくせでやってました。
		JavaScriptは文字列連結が+なのでそうなるらしいです。
		ちょっと変形させて"3"-0なら3になります。

		=メモ
		*jQuery、連想配列をeachした時の動作がおかしい
		*DOMノードをafter()で追加した時の動作がなんだかおかしい

.aside
{
	=参照ページ
	*[perror(2)]

	=気になった記事
	*[WebメールのHTTP通信の危険性|
	http://www.security.gs/magazine/security/2010/04/14/story_2518/]
}

@include nav.i
