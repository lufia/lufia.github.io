---
title: SproutCoreとWCF Data Servicesの連携
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2011年2月26日更新
=SproutCoreとWCF Data Servicesの連携

	=SQL Serverとdecimal型

	SQL Serverのdecimal型は、WCF Data ServicesなJSONの中でみると
	String型になります。値を更新する場合も、
	Number型では変換するときにエラーが起こります。
	このため、postUrlまたはputUrlする前に型変換をしておく必要があります。

	.js
	!var h = store.readDataHash(storeKey)
	!h = SC.copy(h, YES)
	!h.decimalValue = h.decimalValue.toString()
	!SC.Request.putUrl(url)
	!	.json()
	!	.header('Accept', 'application/json')
	!	.notify(this, 'didUpdateRecord', store, storeKey)
	!	.send(h)

	=SQL Serverとdatetime型

	バックエンドにSQL Serverを使う場合、
	datetime型はタイムゾーンを持ちません。
	そして、WCF Data Servicesで取得する値は、
	サーバに保存されている時刻をUTC(GMT)として、
	1970年からそこまでのミリ秒が入っています。

	次に、JavaScriptのDateは、
	基本的にタイムゾーンはローカル固定みたいです。
	getUTCxxxとかでUTCな値は調べられるけど、
	オブジェクトのタイムゾーンは変えられません。

	SC.DateTimeはtimezoneに差分を設定すれば変更できますが、
	timezoneを省略した場合、ローカルタイムゾーンになります。
	JST(+09:00)の場合は-540となり、
	Date#getTimezoneOffsetと同じ値です。
	なので、WCF Data Servicesの値をそのままSC.DateTime#createすると、
	そこから+09:00された時刻になります。

	仮に"2010-12-27T00:00:00"がデータベースに保存されていたとすると、
	そのまま、ミリ秒にした値が返されます。
	具体的には1293375600000ですね。
	で、この値をタイムゾーンを省略してSC.DateTime化すると、
	データハッシュには"2010-12-27T09:00:00+09:00"と保存されます。
	このままPUTすると、データベースは"2010-12-27T09:00:00"になります。

	さてさて、SQL Serverの値をどちらと仮定するか、なのですが。

	+SQL Serverの値はUTC
	+あくまでローカル時間

	UTCだと仮定するのなら、問題ないのでそのまま使えばいいですが、
	ローカル時間と仮定する場合(ほとんどがこちらだと思う)は、
	読み込み時に少し調整が必要です。

	.js
	!function dateFrom(s, format)
	!{
	!	var tzoff = new Date().getTimezoneOffset()*60000
	!	var m = s && s.match(/^\\?\/Date\((-?\d+)([+-]\d+)?\)\\?\/$/)
	!	if(m){
	!		var tick = m[1]-0
	!		var off = 0
	!		if(m[2])
	!			off = m[2]-0
	!		var d = SC.DateTime.create(tick+off+tzoff)
	!		if(typeof format == 'undefined')
	!			format = SC.DateTime.recordFormat
	!		return d.toFormattedString(format)
	!	}
	!	return null
	!}

	これを、データソースのfetchやretrieveRecordに仕込むと
	それっぽく動きます。

	=POST, PUTするとき

	JSONでデータを送るときは、
	Content-Typeヘッダにapplication/jsonが必要です。
	これは、SC.Request#jsonを使うと自動で設定されます。
	データの取得にはAcceptヘッダが必要ですが、
	json関数は、こちらは設定しませんので注意です。

	=トリガ

	WCF Data Servicesは、競合を防ぐ目的で、
	Etagが異なればエラーを返すようになっているみたいです。
	insert/updateをトリガとしてデータの一部を加工する処理が動くと、
	結果として異なるEtagになるらしく、4xxエラー(忘れた)が返ります。
	これはどうしたものでしょうね。

	=Entity Framework

	独立キーアソシエーションでODataのモデルを定義すると、
	外部キーを持ちませんので、IDを使ってのリレーション更新ができません。
	なので、外部キーアソシエーションで作っておくことをおすすめします。

	=主キー

	テーブルを設計するときに、複合キーは使わないほうがいいと思います。
	フレームワークにあわせてデータベースを設計するなんて
	なんだか本末転倒な気がしますが、そのほうが扱いやすいです。

	=ほか

	データベース制約に違反している場合はHTTP 500を返すようです。

.aside
{
	*[WCF Data Servicesメモ|1129.w]
	*[SQL Serverのメモ|../2011/0805.w]
}
