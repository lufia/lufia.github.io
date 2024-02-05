---
title: SproutCoreでデータベースと接続
style: ../../../styles/global.css
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2011年2月26日更新
=SproutCoreでデータベースと接続

	=データソースの作成

	.console
	!$ sc-gen data-source Blog.articleDataSource

	data_sourcesにファイルが生成されます。
	以下のうち必要な関数を書き換えるといいです。

	:fetch
	-クエリでSC.Store#findした場合などで使われる
	:retrieveRecord
	-IDを使ってSC.Store#findした場合
	:createRecord
	-SC.Store#createRecordしたとき
	:updateReocrd
	-変更
	:destroyRecord
	-削除

	自動更新しない場合は、

	.js
	!SC.Store.create({ commitRecordsAutomatically: NO }).find(...)

	=ストアキー

	個々のレコードには、ストア内かな、で一意なIDが割り当てられます。
	これをストアキーと呼ぶみたいです。
	SC.Record#primaryKeyはモデル別に一意なのですが、
	こちらはモデルが違っても競合することはありません。

	.js
	!var a = Blog.store.find(Blog.Article, 1)
	!var c = Blog.store.find(Blog.Comment, 1)
	!a.get('id')			// 1
	!c.get('id')			// 1
	!a.get('storeKey')	// 6とか、その都度いろいろ
	!c.get('storeKey')	// 7とか

	=NestedStore

	NestedStoreは、別ウインドウでOKボタンを押したら
	データをサーバへ保存する、といった場合によく使います。
	SC.NestedStore#commitChangesで元のストアに反映されて、
	最終的にSC.Store#commitRecordsにより保存です。
	SC.Store#commitRecordsAutomaticallyがYESであっても
	commitChangesで自動的に反映はしないっぽい。

	*[DataStore NestedStores|
	http://wiki.sproutcore.com/w/page/12412873/DataStore-NestedStores]

	=クエリ

		=クエリの種類

		大きく、ローカルクエリとリモートクエリの2種類あります。
		リモートクエリはサーバと通信して
		データをメモリに読み込むことを目的としていて、
		検索条件や並び替えなどは無視されます。
		ローカルクエリはメモリに読み込んだデータを扱い、
		検索条件や並び替えといった機能が有効になっています。

		例外的に、ローカルクエリであっても最初の呼び出し時だけは
		サーバと通信してデータをメモリに読み込みます。

		=ローカルクエリ

		並び替え

		.js
		!SC.Query.local(Blog.Article, { orderBy: 'createdDate DESC' })

		または、パラメータ(SCQL)を使う場合

		.js
		!SC.Query.local(Blog.Comment, 'article = {article}', {
		!	article: this
		!})

		いわゆるwhereとorderbyを同時に設定するクエリを書くには、
		SC.Query#localは使えません。以下のようにします。

		.js
		!SC.Query.create({
		!	recordType: Blog.Article,
		!	conditions: 'category={target}',
		!	parameters: { target: value },
		!	orderBy: 'createdDate DESC'
		!})

		また、SC.Query#localと違って、
		recordTypeを文字列にできません。

	=トラブルシューティング

		=SC.Query作成時に型が無いとエラーになる

		型を参照する前にsc_requireを使うと、
		回避できるかもしれません。

		.js
		!sc_require('models/article')
		!Blog.ARTICLE_QUERY = SC.Query.local('Blog.Article', {
		!	orderBy: 'createdDate DESC'
		!})

		=IEでputすると、HTTPステータスコードが1223で失敗する

		これはIEの不具合で、204を受け取るとなぜか1223となるみたい。
		SproutCore 1.4.1ではまだ対応されていないですし、
		対応するのかも分かりませんが、
		とりあえず以下のコードで回避できます。
		ちょっと強引ですけどね。

		.js
		!didUpdateRecord: function(r, store, storeKey){
		!	if(SC.ok(r) || (SC.browser.msie && r.get('status') == 1223)
		!		// success
		!	else
		!		// error
		!}

		ちなみに、SC.browser.msieにはバージョンが入っています。
		IE8の場合は"8.0"という文字列。

		=新規レコードのIDがundefinedになる

		レコード作成時に、SC.Store#dataSourceDidCompleteの
		第3引数でIDを設定した場合、データハッシュのIDは変わっていません。
		なので、ストアキーからIDを調べる場合は、
		常にSC.Store#idForを使ったほうがいいと思います。

		=createRecordしたのにデータソースへ処理が移らない

		ストアのcommitRecordsAutomaticallyがNOの場合、
		commitRecordするといいかもしれないです。

.aside
{
	*[SproutCoreのモデル定義|1203.w]
	*[Hooking Up to the Backend|
	http://wiki.sproutcore.com/w/page/12413058/Todos%2007-Hooking%20Up%20to%20the%20Backend]
}
