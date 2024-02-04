---
title: SproutCoreモデル定義
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2011年2月14日更新
=SproutCoreモデル定義

	=モデルの作成

	.console
	!$ sc-gen model Blog.Article

	これで、model/article.jsが生成されます。
	もうひとつテスト用のファイルも作られますが、
	それについては後日。

	=レコードとデータハッシュ

	SproutCoreのデータは、だいたい2種類の構成に分かれます。
	ひとつは、SC.Recordを拡張したモデル定義部分で、
	もうひとつは実際のデータを持ったオブジェクトです。
	後者はデータハッシュと呼ばれます。

	レコードは内部にデータハッシュを持ち、
	get/setを使ったアクセス時には、関数プロパティを除いて
	ほとんどがデータハッシュの値を扱います。
	ふつうは、これらの違いを意識する必要はないと思いますが、
	新規レコードの作成やFIXTURESの設定など、直接データハッシュを
	扱う場合がありますので注意です。

	たとえばブログ的なものの記事を定義する場合、

	.js
	!Blog.Article = SC.Record.extend({
	!	subject: SC.Record.attr(String, {
	!		key: 'Subject'
	!	}),
	!	createdDate: SC.Record.attr(SC.DateTime, {
	!		key: 'CreatedDate'
	!	})
	!})

	FIXTURESに設定するオブジェクトは以下のようになります。
	下のほうでも詳しく書きますが、SC.DateTime型のデータハッシュは
	文字列になりますので注意です。

	.js
	!Blog.Article.FIXTURES = [
	!{	guid: 0,
	!	Subject: 'article1',
	!	CreatedDate: '2010-12-03T00:00:00+09:00'
	!},
	!{	guid: 1,
	!	Subject: 'article2',
	!	CreatedDate: '2010-12-14T00:00:00+09:00'
	!}
	!]

	同様に、SC.Store#createRecordの第2引数もデータハッシュです。

	=主キーのカラム名

	主キーのカラム名を変更する場合は、
	次に書くSC.Record.attrのkeyオプションを使うのではなくて、
	特別にSC.Record#primaryKeyプロパティを設定します。

	!Blog.Article = SC.Record.extend({
	!	primaryKey: 'ID',
	!	...

	この場合に、article.get('id')はデータハッシュのIDを返しますが、
	article.get('guid')はundefinedになります。
	特別な理由が無い限り、常にget('id')を使ったほうが無難です。

	=SC.Record.attrのオプション

	上のほうでもkeyオプションを使っていますが、
	SC.Record.attr()の第2引数にはオプションオブジェクトを渡せます。
	ここで使えるオプションは以下になります。

	:isRequired
	-必須ならYES
	:key
	-対応するテーブルのカラム名
	-指定しなければ同名
	:defaultValue
	-デフォルト値
	:format
	-型がSC.DateTimeの場合のみ有効
	-get/set時に、この書式を使ってparseやtoFormattedStringを呼び出す
	-指定しなければ'%Y-%m-%dT%H:%M:%S%Z'
	:useIsoDate
	-型がDateの場合のみ有効で、初期値はYES
	-用途としてはformatと同じ

	最後のformatとuseIsoDateは分かりにくいですが、
	データハッシュとモデルの間で変換するために使われるだけです。
	getするとその書式で文字列が返ってくるわけではありません。
	なので、SC.TextFieldViewなどに書式を指定してバインドする場合は、
	これとは別にSC.Binding#dateTimeを使います。

	=実験

	.js
	!data.set('createdDate', SC.DateTime.create({
	!	year: 2010, month: 12, day: 14, hour: 0
	!})
	!// 特別に、こっちでも同じ
	!//data.set('createdDate', '2010-12-14T00:00:00+09:00')
	!
	!// もちろん設定した値は同じ
	!equals(data.get('createdDate'), SC.DateTime.create({...}))
	!
	!// データハッシュは文字列型
	!var p = Blog.store.readDataHash(data.get('storeKey'))
	!equals(p.CreatedDate, '2010-12-14T00:00:00+09:00')

	.note
	{
		SC.DateTimeは、年月日しか明示的に指定しなかった場合、
		時刻部分を現在時刻で設定します。
		これはSC.DateTime.parseでも同じ動きをして、
		以下の場合も現在時刻が設定されます。

		!var d = SC.DateTime.parse('2010-12-01', '%Y-%m-%d')

		時刻を0:00:00で初期化したい場合は、時間に0を設定します。

		!var d = SC.DateTime.parse('2010-12-01T00', '%Y-%m-%dT%H')
		!
		!// 以下でも同じ
		!d = SC.DateTime.parse('2010-12-01', '%Y-%m-%d')
		!	.adjust({ hour: 0 })
	}

	=DateTime型変換

	上でも書いたように、SC.DateTime型のプロパティは
	データハッシュに文字列として保存されます。
	これは、アプリケーション全体に適用される、
	型とデータハッシュの変換ルールに設定されているからです。
	通常これで困ることはありませんが、独自にルールを設定したい場合とか、
	これが悪さをする場合には、SC.RecordAttribute.registerTransformで
	別のルールに差し替えられるようになっています。
	registerTransformは対象の型と変換オブジェクトを引数に取ります。

	.note
	SC.DateTimeに限らず、NumberやDateも
	あらかじめ変換ルールが設定されています。

	使い方は以下のような感じ。
	この例では、データハッシュをDateにさせています。
	個人的にmain.jsの先頭が定位置。

	.js
	!SC.RecordAttribute.registerTransform(SC.DateTime, {
	!	to: function(d, attr){
	!		if(SC.none(d))
	!			return null
	!		return SC.DateTime.create(d.valueOf())
	!	},
	!	from: function(s, attr){
	!		if(SC.none(s) || s === '')
	!			return null
	!		else if(SC.instanceOf(s, SC.DateTime))
	!			return new Date(s.get('milliseconds'))
	!		else
	!			return new Date(s.valueOf())
	!	}
	!})

	from関数はレコードのset呼び出し時に使われ、to関数は逆です。
	これらは第1引数に設定する値(またはデータハッシュの値)、
	第2引数にモデルのSC.Record.attrで設定したオブジェクトを取ります。
	setはtoを使わないでvalueをそのまま返しますので、
	動作テストするときには注意です。

	.js
	!// set('key', value)の時(だいたいこんな感じ)
	!hash[key] = from(value)
	!return value
	!
	!// get('key')の時(だいたいこんな感じ)
	!return to(hash[key])

	=関数プロパティ

	英語でcomputed propertyですが、うまい訳を思いつかなかったので。

	.js
	!createdYear: function(){
	!	return this.getPath('createdDate.year')
	!}.property('createdDate').cacheable()

	ここで、Function#propertyに渡す引数は、
	計算するときに依存するプロパティの名前です。
	複数のプロパティに依存する場合は、第2引数、第3引数と、
	必要なだけプロパティ名を渡します。
	レコードのプロパティ名で、データハッシュではありません。
	上記の場合、createdDateに対してsetを呼び出すと、
	createdYearが更新されたことを、
	これに依存しているオブジェクトへ通知します。

	=リレーションシップ

	たとえば記事とコメントの関係は、
	モデルで定義すると以下のようになります。
	必要な部分だけ抜粋しつつ、まずは記事テーブルの一部。

	|*列名*		*型っぽいもの*
	|ID			主キー
	|Subject		文字列
	|CreatedDate	日付

	コメントのほうはこちら。

	|*列名*		*型っぽいもの*
	|ID			主キー
	|ArticleID		外部キー
	|Message		文字列

	で、モデル定義。

	.js
	!Blog.Article = SC.Record.extend({
	!	primaryKey: 'ID',
	!	subject: SC.Record.attr(String, {key: 'Subject'}),
	!	createdDate: SC.Record.attr(SC.DateTime, {key: 'CreatedDate'}),
	!	comments: SC.Record.toMany('Blog.Comment', {
	!		inverse: 'article',
	!		isMaster: NO
	!	})
	!})
	!Blog.Comment = SC.Record.extend({
	!	primaryKey: 'ID',
	!	message: SC.Record.attr(String, {key: 'Message'}),
	!	article: SC.Record.toOne('Blog.Article', {
	!		key: 'ArticleID',
	!		inverse: 'comments',
	!		isMaster: YES
	!	})
	!})

	何がどう対応するかは、なんとなく分かるかなあと思います。

	ちょっと不思議なものはisMasterオプションで、
	これは、リレーションの変更があった場合に
	どちらのデータを更新するかを指示するものです。

	.js
	!var article = getArticle()
	!var comment = SC.store.createRecord(Blog.Comment, {
	!	Message: '...',
	!})
	!comment.set('postedDate', SC.DateTime.create())
	!comment.set('article', article)

	=モデルへのデータ格納

	サーバにないデータをモデルに格納したい場合。
	たとえば固定的なメニューを作りたい時は、
	SC.Store#loadRecordまたはloadRecordsを使うといいです。
	これはデータハッシュを受け付けますので、
	そこに作成したいモデル用のデータを渡します。

	=オートナンバーなキーの場合

	作成時はnullにしておいて、データソースの
	createRecord時に取得したロケーションなどを使って設定するっぽい。
	詳細は[データストアまとめ|1225.w]のほうで書きます。

	=トラブルシューティング

		=何も変更していないのにBUSY_COMMITTING

		データストアと関連しての症状ですが、
		データベースのデータを読み込んだだけで、
		各レコードのステータスがBUSY_COMMITTINGになる場合。

		これは、SC.Record#writeAttributeを
		関数プロパティの中で使っていたのですが、
		たとえモデルに定義していないプロパティへ書き込んだとしても、
		何かを書き込んだ時点で「変更あり」扱いになるのが原因でした。

		ちなみに、レコードのステータスは、
		SC.Store#statusStringを使うと分かりやすくていいです。

		=SC.DateTimeをTextFieldViewにバインドして編集するとエラー

		.js
		!valueBinding: SC.Binding
		!	.from('Blog.articleController.createdDate')
		!	.dateTime('%Y/%m/%d')

		これを編集可能にして、実際に編集すると、
		「オブジェクトでサポートされていないプロパティまたはメソッドです」
		というエラーで終了します。

		これは、SproutCoreの仕様なのかバグなのか、
		はたまた使い方が間違っているのか知りませんが、
		SC.Binding#dateTimeはSC.DateTime型を想定しています。
		でも編集後の型は文字列になっているので、
		String#toFormattedStringを呼び出そうとして落ちているみたいです。

		同様に、デフォルトでregisterTransformされている関数も、
		String#toFormattedStringを呼び出そうとしてエラーになります。
		なので、この2点に修正が必要です。

		.js
		!function getFormat(attr)
		!{
		!	return attr.get('format') || SC.DateTime.recordFormat
		!}
		!SC.RecordAttribute.registerTransform(SC.DateTime, {
		!	to: function(d, attr){
		!		if(SC.none(d))
		!			return null
		!		var fmt = getFormat(attr)
		!		return SC.DateTime.parse(d, fmt)
		!	},
		!	from: function(s, attr){
		!		if(SC.none(s) || s === '')
		!			return null
		!		if(!SC.instanceOf(s, SC.DateTime))
		!			s = SC.DateTime.create({
		!				milliseconds: new Date(s).valueOf()
		!			})
		!		var fmt = getFormat(attr)
		!		return s.toFormattedString(fmt)
		!	}
		!})
		!
		!Blog.dateTimeValidator = SC.Validator.extend({
		!	format: null,
		!
		!	validate: function(form, field){
		!		var value = field.get('fieldValue')
		!		return value ==='' || !!SC.DateTime.parse(value, this.get('format'))
		!	},
		!
		!	validateError: function(form, field){
		!		var label = field.get('errorLabel') || 'Field'
		!		return SC.$error('invalid date'.loc(), label)
		!	}
		!})
		!
		!Blog.DateTimeBinding = SC.Binding
		!	.transform(function(d){
		!		if(SC.instanceOf(d, SC.DateTime))
		!			return d.toFormattedString('%Y/%m/%d')
		!		return d				
		!	})
		!
		!Blog.mainPage = SC.Page.design({
		!	...
		!	createdDateView: SC.LabelView.design({
		!		isEditable: YES,
		!		valueBinding: Blog.DateTimeBinding
		!			.beget('Blog.articleController.createdDate'),
		!		validator: Blog.dateTimeValidator.create({
		!			format: '%Y/%m/%d'
		!		})
		!	}),
		!	...
		!})

		ここでは、空文字列のときはnullに変換しています。
		validatorは無くてもいいけど、あったほうが親切。

		ほかは、バインド用のプロパティを介して
		やりとりするという方法もあります。
		個数が少ないなら、こちらのほうが楽かもしれません。

		.js
		!targetDate: function(key, value){
		!	var fmt = '%Y-%m-%d'.loc()
		!	if(!SC.none(value)){
		!		try{
		!			var newp = SC.DateTime
		!				.parse(value, fmt)
		!				.adjust({ hour: 0 })
		!			this.set('date', newp)
		!		}catch(e){
		!			// 無視する
		!		}
		!	}
		!	var p = this.get('date')
		!	return p && p.toFormattedString(fmt)
		!}.property('date').cacheable(),

		=DateTimeBindingが1つを除いて空欄になる

		上のトラブルシューティングに関連して。

		SC.Binding#fromは必要なければインスタンスを作りませんので、
		Blog.DateTimeBindingでbegetをfromに変えると、
		最後のものしか有効になりません。

		=バインドした値が更新されない

		モデルだけでテストしようとすると、
		バインドした値が更新されなかったりします。
		いろいろ端折るとこんな感じ。

		.js
		!var A = SC.Object.create({ name: 'aaa' })
		!var B = SC.Object.create({ nameBinding: 'A.name' })
		!A.set('name', 'test')
		!// B.get('name') == undefined
		!SC.RunLoop.begin()
		!SC.RunLoop.end()
		!// B.get('name') == 'test'
		!B.set('name', 'aaa')
		!// A.get('name') == 'test'

		=loadRecordsで複数作成したのに1つしかない

		これはたぶん、primaryKeyとなるプロパティが無いからです。

.aside
{
	=関連情報
	*[WCF Data Servicesメモ|http://lufia.org/notes/2010/1129.html]

	=参考サイト
	*[Showing a relation as selection on a list view|
	http://wiki.sproutcore.com/w/page/28716312/Showing-a-relation-as-selection-on-a-list-view]
	*[DateTime|http://wiki.sproutcore.com/w/page/12412887/DateTime]
}
